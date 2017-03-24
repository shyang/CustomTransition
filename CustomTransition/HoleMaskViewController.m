//
//  HoleMaskViewController.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleMaskViewController.h"

@interface HoleMaskViewController () <CAAnimationDelegate>

@end

@implementation HoleMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];

    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:maskView];

    UIView *up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maskView.bounds.size.width, 200)];
    up.backgroundColor = [UIColor redColor];
    up.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [maskView addSubview:up];

    UIView *down = [[UIView alloc] initWithFrame:CGRectMake(0, 200, maskView.bounds.size.width, maskView.bounds.size.height - 100)];
    down.backgroundColor = [UIColor blueColor];
    down.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [maskView addSubview:down];

    CGPoint holeCenter = CGPointMake(100, 200);
    CGFloat holeRadius = 0;
    BOOL reverse = NO;
    CFTimeInterval duration = 5;

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [UIColor whiteColor].CGColor; // any color with no transparency

    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:self.view.bounds];

    // 作为参数传入的中心点
    CGFloat x = holeCenter.x;
    CGFloat y = holeCenter.y;

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    CGFloat r = sqrt(w * w + h * h); // 最大可能的半径。不一定是最小的，但能完整覆盖整个 rect

    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - holeRadius, y - holeRadius, holeRadius * 2, holeRadius * 2)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - r, y - r, r * 2, r * 2)];

    [fromPath appendPath:rect];
    [toPath appendPath:rect];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    if (reverse) {
        anim.fromValue = (__bridge id)toPath.CGPath;
        anim.toValue = (__bridge id)fromPath.CGPath;
        layer.path = fromPath.CGPath;
    } else {
        anim.fromValue = (__bridge id)fromPath.CGPath;
        anim.toValue = (__bridge id)toPath.CGPath;
        layer.path = toPath.CGPath;
    }
    anim.delegate = self;
    anim.duration = duration;

    [layer addAnimation:anim forKey:@"expand_or_shrink"];
    maskView.layer.mask = layer;
}

@end
