//
//  ViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ViewController.h"
#import "BeginViewController.h"
#import "MagicAnimator.h"
#import "HoleAnimationViewController.h"
#import "ShadowAnimationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithRootViewController:[[ShadowAnimationViewController alloc] init]]) {
        self.navigationBarHidden = YES;
        self.delegate = self;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // 可根据 from、to、operation 等进行过滤
    MagicAnimator *animator = [[MagicAnimator alloc] init];
    animator.operation = operation;
    return animator;
}

@end
