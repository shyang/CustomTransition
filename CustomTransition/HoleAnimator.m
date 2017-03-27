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
        UIView *maskView = [[UIView alloc] initWithFrame:container.bounds];
        [container addSubview:to.view];
        [container addSubview:maskView];
        [maskView addSubview:from.view];
        [maskView holeAtCenter:maskView.center duration:1 reverse:NO completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else if (_operation == UINavigationControllerOperationPop) {
        UIView *maskView = [[UIView alloc] initWithFrame:container.bounds];
        [container addSubview:maskView];
        [maskView addSubview:to.view];
        [maskView holeAtCenter:maskView.center duration:1 reverse:YES completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [container addSubview:to.view];
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSAssert(NO, @"Set the operation first!");
    }
}

@end
