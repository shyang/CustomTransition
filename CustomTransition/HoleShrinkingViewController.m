//
//  HoleShrinkingViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleShrinkingViewController.h"
#import "HoleExpandingView.h"

@interface HoleShrinkingViewController ()

@end

@implementation HoleShrinkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];

    HoleExpandingView *mask = [[HoleExpandingView alloc] initWithFrame:self.view.bounds];
    mask.duration = 2;
    mask.reverse = YES;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];
}

@end
