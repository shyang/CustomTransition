//
//  ShadowAnimationView.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowAnimationView.h"

@interface ShadowAnimationView () <CAAnimationDelegate>

@property (nonatomic, copy) void (^doneBlock)(BOOL finished);

@end

@implementation ShadowAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _duration = 1;
    }
    return self;
}

- (void)startAnimationWithCompletion:(void (^)(BOOL))completion {
    _doneBlock = completion;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = .2;
    self.layer.shadowRadius = 5;

    UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(-5, 0, self.bounds.size.width + 10, self.bounds.size.height + 15)];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    if (_reverse) {
        anim.fromValue = (__bridge id)toPath.CGPath;
        anim.toValue = (__bridge id)fromPath.CGPath;
        self.layer.shadowPath = fromPath.CGPath;
    } else {
        anim.fromValue = (__bridge id)fromPath.CGPath;
        anim.toValue = (__bridge id)toPath.CGPath;
        self.layer.shadowPath = toPath.CGPath;
    }
    anim.delegate = self;
    anim.duration = _duration;

    [self.layer addAnimation:anim forKey:@"expand_or_shrink"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.layer removeAllAnimations];

    if (_doneBlock) {
        _doneBlock(flag);
    }
}
@end
