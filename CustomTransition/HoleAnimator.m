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
        [container addSubview:to.view];

        HoleMaskView *maskView = [[HoleMaskView alloc] initWithFrame:container.bounds];
        [container addSubview:maskView];

        [maskView addSubview:from.view];
        [maskView startAnimationWithCompletion:^(BOOL finished) {
            [maskView removeFromSuperview];

            [transitionContext completeTransition:YES];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        HoleMaskView *maskView = [[HoleMaskView alloc] initWithFrame:container.bounds];
        maskView.reverse = YES;
        [container addSubview:maskView];

        [maskView addSubview:to.view];
        [maskView startAnimationWithCompletion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [container addSubview:to.view];
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
