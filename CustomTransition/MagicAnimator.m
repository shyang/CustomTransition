//
//  MagicAnimator.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "MagicAnimator.h"
#import "HoleExpandingView.h"
#import "ShadowAnimationView.h"
#import "UIViewController+MagicView.h"

static const CGFloat kFadeTime = 0.3;
static const CGFloat kShadowTime = 0.1;
static const CGFloat kMoveTime = 0.7;
static const CGFloat kHoleExpandTime = 0.5;

@implementation MagicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kFadeTime + kShadowTime * 2 + kMoveTime + kHoleExpandTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    /*
     主要有 5 个动画需要实现：
     1. 全屏不透明蒙板淡入                      kFadeTime
     2. 海报四周出现阴影（升起的视觉效果）      kShadowTime
     3. 海报移动                                kMoveTime
     4. 海报四周阴影消失（下落的视觉效果）      kShadowTime
     5. 全屏不透明蒙板以海报为中心，涟漪式消除  kHoleExpandTime
     
     
     注1: Animator 需要插入各种遮罩，对被动画的 view 中的层级有假设，若嵌套层次超过一层，需要相应的修改。
     */

    UIView *source = from.magicView;
    UIView *target = to.magicView;
    NSAssert(source && target, @"no magic view set in from/to view controllers!");

    UIView *container = transitionContext.containerView;

    if (_operation == UINavigationControllerOperationPush) {
        // 动画1 淡入
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        mask.alpha = 0;
        mask.backgroundColor = [UIColor whiteColor];
        [from.view addSubview:mask];
        [from.view bringSubviewToFront:source]; // ^注1

        [UIView animateWithDuration:kFadeTime animations:^{
            mask.alpha = 1;
        } completion:^(BOOL finished) {
            // 动画2 升起
            ShadowAnimationView *shadow = [[ShadowAnimationView alloc] initWithFrame:source.frame];
            shadow.duration = kShadowTime;
            [from.view insertSubview:shadow belowSubview:source];
            [shadow startAnimationWithCompletion:^(BOOL finished) {

                // 动画3 移动
                CGRect savedFrame = source.frame;
                [UIView animateWithDuration:kMoveTime animations:^{
                    source.frame = target.frame;
                    shadow.frame = target.frame;
                } completion:^(BOOL finished) {

                    // 动画4 降落
                    shadow.reverse = YES;
                    [shadow startAnimationWithCompletion:^(BOOL finished) {
                        // revert
                        source.frame = savedFrame;
                        [shadow removeFromSuperview];
                        [mask removeFromSuperview];

                        // 动画5 涟漪
                        [container addSubview:to.view];
                        HoleExpandingView *hole = [[HoleExpandingView alloc] initWithFrame:container.bounds];
                        hole.duration = kHoleExpandTime;
                        hole.holeCenter = target.center;
                        [to.view addSubview:hole];
                        [to.view bringSubviewToFront:target]; // ^注1

                        [hole startAnimationWithCompletion:^(BOOL finished) {
                            // end
                            [hole removeFromSuperview];
                            [transitionContext completeTransition:YES];
                        }];
                    }];
                }];
            }];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        // 动画5 涟漪
        HoleExpandingView *hole = [[HoleExpandingView alloc] initWithFrame:container.bounds];
        hole.duration = kHoleExpandTime;
        hole.holeCenter = source.center;
        hole.reverse = YES;
        [from.view addSubview:hole];
        [from.view bringSubviewToFront:source]; // ^注1
        [hole startAnimationWithCompletion:^(BOOL finished) {
            // hole 替换为 mask
            UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
            mask.backgroundColor = [UIColor whiteColor];
            [from.view insertSubview:mask aboveSubview:hole]; // ^注1
            [hole removeFromSuperview];

            // 动画2 升起
            ShadowAnimationView *shadow = [[ShadowAnimationView alloc] initWithFrame:source.frame];
            shadow.duration = kShadowTime;
            [from.view insertSubview:shadow belowSubview:source];
            [shadow startAnimationWithCompletion:^(BOOL finished) {

                // 动画3 移动
                CGRect savedFrame = source.frame;
                [UIView animateWithDuration:kMoveTime animations:^{
                    source.frame = target.frame;
                    shadow.frame = target.frame;
                } completion:^(BOOL finished) {

                    // 动画4 降落
                    shadow.reverse = YES;
                    [shadow startAnimationWithCompletion:^(BOOL finished) {
                        // revert
                        source.frame = savedFrame;
                        [shadow removeFromSuperview];

                        // 动画1 淡出
                        [to.view addSubview:mask];
                        [to.view bringSubviewToFront:target];
                        [container addSubview:to.view];
                        [UIView animateWithDuration:kFadeTime animations:^{
                            mask.alpha = 0;
                        } completion:^(BOOL finished) {
                            [mask removeFromSuperview];

                            // end
                            [transitionContext completeTransition:YES];
                        }];
                    }];
                }];
            }];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
