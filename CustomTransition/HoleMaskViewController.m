//
//  HoleMaskViewController.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleMaskViewController.h"
#import "HoleMaskView.h"

@interface HoleMaskViewController () <CAAnimationDelegate> {
    BOOL _on;
    HoleMaskView *_maskView;
}

@end

@implementation HoleMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];

    _maskView = [[HoleMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_maskView];

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"269.jpg"]];
    imageView.frame = _maskView.bounds;
    [_maskView addSubview:imageView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"On" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
/*
    UIView *up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maskView.bounds.size.width, 200)];
    up.backgroundColor = [UIColor redColor];
    up.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [maskView addSubview:up];

    UIView *down = [[UIView alloc] initWithFrame:CGRectMake(0, 200, maskView.bounds.size.width, maskView.bounds.size.height - 100)];
    down.backgroundColor = [UIColor blueColor];
    down.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [maskView addSubview:down];
 */

}

- (void)toggle {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (_on) {
        _maskView.reverse = YES;
        [_maskView animateWithDuration:1 delay:0 preparation:nil completion:^(BOOL finished) {
            _on = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"On" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    } else {
        _maskView.reverse = NO;
        [_maskView animateWithDuration:1 delay:0 preparation:nil completion:^(BOOL finished) {
            _on = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Off" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}

@end
