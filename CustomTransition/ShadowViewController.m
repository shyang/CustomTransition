//
//  ShadowViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowViewController.h"
#import "ShadowAnimationView.h"

@interface ShadowViewController () {
    BOOL _on;
    ShadowAnimationView *_mask;
}

@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"On" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];

    _mask = [[ShadowAnimationView alloc] initWithFrame:CGRectMake(100, 160, 120, 160)];
    _mask.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mask];
}

- (void)toggle {
    if (_on) {
        _mask.reverse = YES;
        [_mask animateWithDuration:1 delay:0 preparation:nil completion:^(BOOL finished) {
            _on = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"On" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
        }];
    } else {
        _mask.reverse = NO;
        [_mask animateWithDuration:1 delay:0 preparation:nil completion:^(BOOL finished) {
            _on = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Off" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
        }];
    }
}

@end
