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

    CGFloat w = self.view.bounds.size.width / 2;
    CGFloat h = self.view.bounds.size.height / 2;

    CGFloat r = sqrt(w * w + h * h);

    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(w, h, 0, 0)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(w - r, h - r, r * 2, r * 2)];

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
