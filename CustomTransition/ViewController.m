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

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithRootViewController:[[BeginViewController alloc] init]]) {
        self.navigationBarHidden = YES;
        self.delegate = self;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    MagicAnimator *animator = [[MagicAnimator alloc] init];
    return animator;
}

@end
