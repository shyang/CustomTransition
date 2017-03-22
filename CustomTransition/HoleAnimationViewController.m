//
//  HoleAnimationViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//


#import "HoleAnimationViewController.h"
#import "HoleExpandingView.h"

@interface HoleAnimationViewController ()

@end

@implementation HoleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];

    HoleExpandingView *mask = [[HoleExpandingView alloc] initWithFrame:self.view.bounds];
    mask.holeCenter = CGPointMake(0, 0);
    mask.holeRadius = 160;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];
}

@end
