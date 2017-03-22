//
//  HoleAnimationViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HoleAnimationViewController.h"

@interface HoleAnimationViewController () <CAAnimationDelegate>

@end

@implementation HoleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [UIColor whiteColor].CGColor;

    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:self.view.bounds];

    // 作为参数传入的中心点
    CGFloat x = 200;
    CGFloat y = 300;

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    CGFloat r = sqrt(w * w + h * h); // 最大可能的半径。不一定是最小的，但能完整覆盖整个 rect

    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, 0, 0)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - r, y - r, r * 2, r * 2)];

    [fromPath appendPath:rect];
    [toPath appendPath:rect];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.fromValue = (__bridge id)fromPath.CGPath;
    anim.toValue = (__bridge id)toPath.CGPath;
    anim.delegate = self;
    anim.duration = 10;

    [layer addAnimation:anim forKey:@"expand"];
    [self.view.layer addSublayer:layer];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}

@end
