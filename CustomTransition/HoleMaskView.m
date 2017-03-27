//
//  HoleMaskView.m
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "HoleMaskView.h"

@interface HoleMaskView () <CAAnimationDelegate>

@property (nonatomic, copy) void (^doneBlock)(BOOL finished);

@end

@implementation HoleMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _holeCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _holeRadius = 0;
    }
    return self;
}

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay preparation:(void (^)(void))preparation completion:(void (^)(BOOL))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _doneBlock = completion;
        if (preparation) {
            preparation();
        }

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.fillRule = kCAFillRuleEvenOdd;
        layer.fillColor = [UIColor whiteColor].CGColor; // any color with no transparency

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
        if (_reverse) {
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
        anim.removedOnCompletion = YES;
        
        [layer addAnimation:anim forKey:@"expand_or_shrink"];
        self.layer.mask = layer;
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_doneBlock) {
        _doneBlock(flag);
        _doneBlock = nil;
    }
}

@end
