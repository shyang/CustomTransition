//
//  MagicAnimator.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "MagicAnimator.h"

@implementation MagicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 3;
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
     */

    UIView *source = [from.view viewWithTag:10000];
    UIView *target = [to.view viewWithTag:10000];
    NSAssert(source && target, @"no view with tag 10000 found in from/to view controllers!");

    CGRect savedFrame = source.frame;
    [UIView animateWithDuration:1 animations:^{
        NSLog(@"%@ -> %@", NSStringFromCGRect(source.frame), NSStringFromCGRect(target.frame));
        source.frame = target.frame;
    } completion:^(BOOL finished) {
        // revert
        source.frame = savedFrame;

        // end
        target.tag = 0; // clear
        [transitionContext.containerView addSubview:to.view];
        [transitionContext completeTransition:YES];
    }];
}

@end
