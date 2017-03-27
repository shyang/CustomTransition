//
//  MagicAnimator.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "MagicAnimator.h"
#import "ShadowView.h"
#import "UIViewController+MagicView.h"
#import "HoleMaskView.h"

static const CGFloat kTotal = 10;

static const CGFloat kHoleTime = .26 * kTotal;
static const CGFloat kShadowTime = .08 * kTotal;
static const CGFloat kMoveTime = .45 * kTotal;
static const CGFloat kDownTime = .21 * kTotal;

static const CGFloat kFadeTime = .17 * kTotal;

// Fade out, Shadow on, Move&Scale up, Scale down&Shadow off, Hole expand
// kFadeTime
// kShadowTime + kMoveTime + kDownTime + kHoleTime = 100%
// {0,    0,  .09, .51, .75} start
// {.16, .07, .42, .24, .25} duration

// Hole shrink, Shadow on, Move&Scale up, Scale down&Shadow off, Fade in
// kHoleTime + kShadowTime + kMoveTime + kDownTime = 100%
//                                       kFadeTime
// {0,   .27, .35, .82, .82} start
// {.27, .08, .47, .18, .18} duration

@implementation MagicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTotal;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    /*
     主要有 5 个动画需要实现：
     1. 全屏不透明蒙板淡入
     2. 海报四周出现阴影（升起的视觉效果）
     3. 海报移动且放大
     4. 海报四周阴影消失且缩小（下落的视觉效果）
     5. 全屏不透明蒙板以海报为中心，涟漪式消除

     注1: Animator 需要插入各种遮罩，对被动画的 view 中的层级有假设，若嵌套层次超过一层，需要相应的修改。
     */

    UIView *source = from.magicView;
    UIView *target = to.magicView;
    NSAssert(source && target, @"no magic view set in from/to view controllers!");

    UIView *container = transitionContext.containerView;

    if (_operation == UINavigationControllerOperationPush) {
        // 动画1 淡出
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        mask.alpha = 0;
        mask.backgroundColor = [UIColor whiteColor];
        [from.view addSubview:mask];
        [from.view bringSubviewToFront:source]; // ^注1
        [UIView animateWithDuration:kFadeTime animations:^{
            mask.alpha = 1;
        }];

        // 动画2 升起
        [source shadowWithDuration:kShadowTime reverse:NO completion:^(BOOL finished) {

            // 动画3 移动&放大
            CGRect savedFrame = source.frame;
            [UIView animateWithDuration:kMoveTime delay:0 options:0 animations:^{
                CGRect bigger = CGRectInset(target.frame, -target.bounds.size.width * 0.04, -target.bounds.size.height * 0.04);
                source.frame = bigger;
            } completion:^(BOOL finished) {

                // 动画4 降落&缩小
                [source shadowWithDuration:kDownTime reverse:YES completion:nil];

                [UIView animateWithDuration:kDownTime delay:0 options:0 animations:^{
                    source.frame = target.frame;
                } completion:^(BOOL finished) {
                    // revert
                    source.frame = savedFrame;

                    // 动画5 涟漪
                    [container addSubview:to.view];
                    [to.view addSubview:mask];
                    [to.view bringSubviewToFront:target]; // ^注1
                    [mask holeAtCenter:target.center duration:kHoleTime reverse:NO completion:^(BOOL finished) {
                        // end
                        [mask removeFromSuperview];
                        [transitionContext completeTransition:YES];
                    }];
                }];
            }];
        }];

    } else if (_operation == UINavigationControllerOperationPop) {
        // 动画5 涟漪
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        mask.backgroundColor = [UIColor whiteColor];
        [from.view addSubview:mask];
        [from.view bringSubviewToFront:source]; // ^注1
        [mask holeAtCenter:source.center duration:kHoleTime reverse:YES completion:^(BOOL finished) {

            // 动画4 升起
            [source shadowWithDuration:kShadowTime reverse:NO completion:^(BOOL finished) {

                // 动画3 移动&放大
                CGRect savedFrame = source.frame;
                [UIView animateWithDuration:kMoveTime delay:0 options:0 animations:^{
                    CGRect bigger = CGRectInset(target.frame, -target.bounds.size.width * 0.04, -target.bounds.size.height * 0.04);
                    source.frame = bigger;
                } completion:^(BOOL finished) {

                    // 动画2 降落&缩小
                    [source shadowWithDuration:kDownTime reverse:YES completion:nil];

                    [UIView animateWithDuration:kDownTime delay:0 options:0 animations:^{
                        source.frame = target.frame;
                    } completion:^(BOOL finished) {
                        // revert
                        source.frame = savedFrame;
                    }];

                    NSAssert(kFadeTime < kDownTime, @"otherwise change the delay");
                    // 动画1 淡入
                    [container insertSubview:to.view belowSubview:mask];
                    [UIView animateWithDuration:kFadeTime delay:kDownTime - kFadeTime options:0 animations:^{
                        mask.alpha = 0;
                    } completion:^(BOOL finished) {
                        [mask removeFromSuperview];
                        [container addSubview:to.view];
                        // end
                        [transitionContext completeTransition:YES];
                    }];
                }];
            }];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
