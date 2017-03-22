//
//  ShadowAnimationViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowAnimationViewController.h"
#import "ShadowAnimationView.h"

@interface ShadowAnimationViewController ()

@end

@implementation ShadowAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    ShadowAnimationView *mask = [[ShadowAnimationView alloc] initWithFrame:CGRectMake(100, 100, 40, 60)];
    mask.backgroundColor = [UIColor redColor];
    mask.reverse = YES;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];

}

@end
