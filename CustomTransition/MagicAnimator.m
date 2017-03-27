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

// Fade out, Shadow on, Move&Scale up, Scale down&Shadow off, Hole expand
static const CGFloat kAnimationStart[] = {0, 0, .1, .56, .82};
static const CGFloat kAnimationDuration[] = {.18, .08, .46, .26, .28};

// Hole shrink, Shadow on, Move&Scale up, Scale down&Shadow off, Fade in
static const CGFloat kReverseStart[] = {0, .28, .36, .85, .85};
static const CGFloat kReverseDuration[] = {.28, .08, .49, .19, .19};

@implementation MagicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _operation == UINavigationControllerOperationPush ? 1.1 : 1.04;
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
        // 动画1 淡入
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        mask.alpha = 0;
        mask.backgroundColor = [UIColor whiteColor];
        [from.view addSubview:mask];
        [from.view bringSubviewToFront:source]; // ^注1
        [UIView animateWithDuration:kAnimationDuration[0] delay:kAnimationStart[0] options:0 animations:^{
            mask.alpha = 1;
        } completion:nil];

        // 动画2 升起
        ShadowView *shadow = [[ShadowView alloc] initWithFrame:source.frame];
        [shadow animateWithDuration:kAnimationDuration[1] delay:kAnimationStart[1] preparation:^{
            [from.view insertSubview:shadow belowSubview:source];
        } completion:nil];

        // 动画3 移动&放大
        CGRect savedFrame = source.frame;
        [UIView animateWithDuration:kAnimationDuration[2] delay:kAnimationStart[2] options:0 animations:^{
            CGRect bigger = CGRectInset(target.frame, -target.bounds.size.width * 0.04, -target.bounds.size.height * 0.04);
            source.frame = bigger;
            shadow.frame = bigger;
        } completion:nil];

        // 动画4 降落&缩小
        [shadow animateWithDuration:kAnimationDuration[3] delay:kAnimationStart[3] preparation:^{
            shadow.reverse = YES;
        } completion:^(BOOL finished) {
            // revert
            source.frame = savedFrame;
            [shadow removeFromSuperview];
            [mask removeFromSuperview];
        }];
        [UIView animateWithDuration:kAnimationDuration[3] delay:kAnimationStart[3] options:0 animations:^{
            source.frame = target.frame;
            shadow.frame = target.frame;
        } completion:nil];

        // 动画5 涟漪
        HoleMaskView *hole = [[HoleMaskView alloc] initWithFrame:container.bounds];
        [hole animateWithDuration:kAnimationDuration[4] delay:kAnimationStart[4] preparation:^{
            [container addSubview:to.view];
            hole.holeCenter = target.center;
            [to.view addSubview:hole];
            [to.view bringSubviewToFront:target]; // ^注1
        } completion:^(BOOL finished) {
            // end
            [hole removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        // 动画5 涟漪
        HoleMaskView *hole = [[HoleMaskView alloc] initWithFrame:container.bounds];
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        [hole animateWithDuration:kReverseDuration[0] delay:kReverseStart[0] preparation:^{
            hole.reverse = YES;
            hole.holeCenter = source.center;
            [from.view addSubview:hole];
            [from.view bringSubviewToFront:source]; // ^注1
        } completion:^(BOOL finished) {
            // hole 替换为 mask
            mask.backgroundColor = [UIColor whiteColor];
            [from.view insertSubview:mask aboveSubview:hole]; // ^注1
            [hole removeFromSuperview];
        }];

        // 动画4 升起
        ShadowView *shadow = [[ShadowView alloc] initWithFrame:source.frame];
        [shadow animateWithDuration:kReverseDuration[1] delay:kReverseStart[1] preparation:^{
            [from.view insertSubview:shadow belowSubview:source];
        } completion:nil];

        // 动画3 移动
        CGRect savedFrame = source.frame;
        [UIView animateWithDuration:kReverseDuration[2] delay:kReverseStart[2] options:0 animations:^{
            CGRect bigger = CGRectInset(target.frame, -target.bounds.size.width * 0.04, -target.bounds.size.height * 0.04);
            source.frame = bigger;
            shadow.frame = bigger;
        } completion:nil];

        // 动画2 降落
        shadow.reverse = YES;
        [shadow animateWithDuration:kReverseDuration[3] delay:kReverseStart[3] preparation:nil completion:^(BOOL finished) {
            // revert
            source.frame = savedFrame;
            [shadow removeFromSuperview];
        }];
        [UIView animateWithDuration:kReverseDuration[3] delay:kReverseStart[3] options:0 animations:^{
            source.frame = target.frame;
            shadow.frame = target.frame;
        } completion:nil];

        // 动画1 淡出
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReverseStart[4] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [to.view addSubview:mask];
            [to.view bringSubviewToFront:target];
            [container addSubview:to.view];
            [UIView animateWithDuration:kReverseDuration[4] animations:^{
                mask.alpha = 0;
            } completion:^(BOOL finished) {
                [mask removeFromSuperview];

                // end
                [transitionContext completeTransition:YES];
            }];
        });
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
