//
//  HoleMaskView.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <objc/runtime.h>

#import "CAAnimationBlock.h"
#import "HoleMaskView.h"

@implementation UIView (HoleAnimation)

- (void)holeAtCenter:(CGPoint)center duration:(NSTimeInterval)duration reverse:(BOOL)reverse completion:(void (^)(BOOL))completion {
    CAAnimationBlock *wrapper = [[CAAnimationBlock alloc] init];
    wrapper.block = completion;
    objc_setAssociatedObject(self, _cmd, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [UIColor whiteColor].CGColor; // any color with no transparency

    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:self.bounds];

    // 作为参数传入的中心点
    CGFloat holeRadius = 0; // 空洞的初始半径，缺省为 0
    CGFloat x = center.x;
    CGFloat y = center.y;

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

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
    anim.delegate = wrapper;
    anim.duration = duration;
    anim.removedOnCompletion = YES;

    [layer addAnimation:anim forKey:@"expand_or_shrink"];
    self.layer.mask = layer;
}

@end
