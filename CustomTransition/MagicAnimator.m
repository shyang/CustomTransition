//
//  MagicAnimator.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "MagicAnimator.h"
#import "HoleExpandingView.h"

@implementation MagicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    /*
     主要有 5 个动画需要实现：
     1. 全屏不透明蒙板淡入
     2. 海报四周出现阴影（升起的视觉效果）
     3. 海报移动
     4. 海报四周阴影消失（下落的视觉效果）
     5. 全屏不透明蒙板以海报为中心，涟漪式消除
     
     
     注1: Animator 需要插入各种遮罩，对被动画的 view 中的层级有假设，若嵌套层次超过一层，需要相应的修改。
     */

    UIView *source = [from.view viewWithTag:10000];
    UIView *target = [to.view viewWithTag:10000];
    NSAssert(source && target, @"no view with tag 10000 found in from/to view controllers!");

    UIView *container = transitionContext.containerView;

    if (_operation == UINavigationControllerOperationPush) {
        // 动画1
        UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
        mask.alpha = 0;
        mask.backgroundColor = [UIColor whiteColor];
        [from.view addSubview:mask];
        [from.view bringSubviewToFront:source]; // ^注1

        [UIView animateWithDuration:0.5 animations:^{
            mask.alpha = 1;
        } completion:^(BOOL finished) {

            // 动画2
            CGRect savedFrame = source.frame;
            [UIView animateWithDuration:1 animations:^{
                source.frame = target.frame;
            } completion:^(BOOL finished) {
                // revert
                source.frame = savedFrame;
                [mask removeFromSuperview];

                // 动画5
                [container addSubview:to.view];
                HoleExpandingView *hole = [[HoleExpandingView alloc] initWithFrame:container.bounds];
                hole.holeCenter = target.center;
                [to.view addSubview:hole];
                [to.view bringSubviewToFront:target]; // ^注1

                [hole startAnimationWithCompletion:^(BOOL finished) {
                    // end
                    [hole removeFromSuperview];
                    target.tag = 0; // clear
                    [transitionContext completeTransition:YES];
                }];
            }];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        // 动画5
        HoleExpandingView *hole = [[HoleExpandingView alloc] initWithFrame:container.bounds];
        hole.holeCenter = source.center;
        hole.reverse = YES;
        [from.view addSubview:hole];
        [from.view bringSubviewToFront:source]; // ^注1

        [hole startAnimationWithCompletion:^(BOOL finished) {
            [hole removeFromSuperview];
            // 插入 mask
            UIView *mask = [[UIView alloc] initWithFrame:container.bounds];
            mask.backgroundColor = [UIColor whiteColor];
            [from.view insertSubview:mask belowSubview:source]; // ^注1

            // 动画2
            CGRect savedFrame = source.frame;
            [UIView animateWithDuration:1 animations:^{
                source.frame = target.frame;
            } completion:^(BOOL finished) {
                // revert
                source.frame = savedFrame;

                // 动画1
                [to.view addSubview:mask];
                [to.view bringSubviewToFront:target];
                [container addSubview:to.view];
                [UIView animateWithDuration:.5 animations:^{
                    mask.alpha = 0;
                } completion:^(BOOL finished) {
                    [mask removeFromSuperview];

                    // end
                    target.tag = 0; // clear
                    [transitionContext completeTransition:YES];
                }];
            }];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
