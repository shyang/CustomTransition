//
//  HoleMaskViewController.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleMaskViewController.h"
#import "HoleMaskView.h"

@interface HoleMaskViewController () <CAAnimationDelegate>

@end

@implementation HoleMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];

    HoleMaskView *maskView = [[HoleMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:maskView];

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"269.jpg"]];
    imageView.frame = maskView.bounds;
    [maskView addSubview:imageView];

    maskView.holeCenter = CGPointMake(100, 200);
    maskView.holeRadius = 20;
    maskView.duration = 5;
    [maskView startAnimationWithCompletion:nil];

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

@end
