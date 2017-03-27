//
//  ShadowAnimationView.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView () <CAAnimationDelegate>

@property (nonatomic, copy) void (^doneBlock)(BOOL finished);

@end

@implementation ShadowView

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay preparation:(void (^)(void))preparation completion:(void (^)(BOOL))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _doneBlock = completion;
        if (preparation) {
            preparation();
        }

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeApplyAffineTransform(self.bounds.size, CGAffineTransformMakeScale(.05, .05));

        float fromValue = 0;
        float toValue = .6;

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        if (_reverse) {
            anim.fromValue = @(toValue);
            anim.toValue = @(fromValue);
            self.layer.shadowOpacity = fromValue;
        } else {
            anim.fromValue = @(fromValue);
            anim.toValue = @(toValue);
            self.layer.shadowOpacity = toValue;
        }
        anim.delegate = self;
        anim.duration = duration;
        anim.removedOnCompletion = YES;
        [self.layer addAnimation:anim forKey:@"expand_or_shrink"];
    });
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    if (_doneBlock) {
        _doneBlock(flag);
        _doneBlock = nil;
    }
}

@end
