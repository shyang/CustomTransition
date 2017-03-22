//
//  ShadowOnViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowOnViewController.h"
#import "ShadowAnimationView.h"

@interface ShadowOnViewController ()

@end

@implementation ShadowOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    ShadowAnimationView *mask = [[ShadowAnimationView alloc] initWithFrame:CGRectMake(100, 100, 40, 60)];
    mask.backgroundColor = [UIColor redColor];
    mask.duration = 3;
    [self.view addSubview:mask];
    [mask startAnimationWithCompletion:nil];
}

@end
