//
//  HoleExpandingView.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HoleExpandingView.h"

@implementation HoleExpandingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _holeCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _holeRadius = 0;
        _fillColor = [UIColor whiteColor];
        _duration = 1;
    }
    return self;
}

- (void)startAnimation {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = _fillColor.CGColor;

    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:self.bounds];

    // 作为参数传入的中心点
    CGFloat x = _holeCenter.x;
    CGFloat y = _holeCenter.y;

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

    CGFloat r = sqrt(w * w + h * h); // 最大可能的半径。不一定是最小的，但能完整覆盖整个 rect

    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - _holeRadius, y - _holeRadius, _holeRadius * 2, _holeRadius * 2)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - r, y - r, r * 2, r * 2)];

    [fromPath appendPath:rect];
    [toPath appendPath:rect];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.fromValue = (__bridge id)fromPath.CGPath;
    anim.toValue = (__bridge id)toPath.CGPath;
    anim.delegate = self;
    anim.duration = _duration;

    [layer addAnimation:anim forKey:@"expand"];
    [self.layer addSublayer:layer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperlayer];
    }];
}

@end
