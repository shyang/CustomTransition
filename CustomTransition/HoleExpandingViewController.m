//
//  HoleExpandingViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//


#import "HoleExpandingViewController.h"
#import "HoleExpandingView.h"

@interface HoleExpandingViewController ()

@end

@implementation HoleExpandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];

    HoleExpandingView *mask = [[HoleExpandingView alloc] initWithFrame:self.view.bounds];
    mask.duration = 2;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];
}

@end
