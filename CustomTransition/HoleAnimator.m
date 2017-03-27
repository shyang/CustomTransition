//
//  HoleAnimator.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleAnimator.h"
#import "HoleMaskView.h"

@implementation HoleAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *container = transitionContext.containerView;

    if (_operation == UINavigationControllerOperationPush) {
        HoleMaskView *maskView = [[HoleMaskView alloc] initWithFrame:container.bounds];
        [maskView animateWithDuration:1 delay:0 preparation:^{
            [container addSubview:to.view];
            [container addSubview:maskView];
            [maskView addSubview:from.view];
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        HoleMaskView *maskView = [[HoleMaskView alloc] initWithFrame:container.bounds];
        [maskView animateWithDuration:1 delay:0 preparation:^{
            maskView.reverse = YES;
            [container addSubview:maskView];
            [maskView addSubview:to.view];
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [container addSubview:to.view];
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
