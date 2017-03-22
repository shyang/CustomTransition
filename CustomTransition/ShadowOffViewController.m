//
//  ShadowOffViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowOffViewController.h"
#import "ShadowAnimationView.h"

@interface ShadowOffViewController ()

@end

@implementation ShadowOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    ShadowAnimationView *mask = [[ShadowAnimationView alloc] initWithFrame:CGRectMake(100, 100, 40, 60)];
    mask.backgroundColor = [UIColor redColor];
    mask.reverse = YES;
    mask.duration = 2;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];
}

@end
