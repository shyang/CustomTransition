//
//  UIView+ShadowAnimation.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+ShadowAnimation.h"
#import "CAAnimationBlock.h"

@implementation UIView (ShadowAnimation)

- (void)shadowWithDuration:(NSTimeInterval)duration reverse:(BOOL)reverse completion:(void (^)(BOOL))completion {
    CAAnimationBlock *wrapper = [[CAAnimationBlock alloc] init];
    wrapper.block = completion;
    objc_setAssociatedObject(self, _cmd, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeApplyAffineTransform(self.bounds.size, CGAffineTransformMakeScale(.05, .05));

    float fromValue = 0;
    float toValue = .6;

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    if (reverse) {
        anim.fromValue = @(toValue);
        anim.toValue = @(fromValue);
        self.layer.shadowOpacity = fromValue;
    } else {
        anim.fromValue = @(fromValue);
        anim.toValue = @(toValue);
        self.layer.shadowOpacity = toValue;
    }
    anim.duration = duration;
    anim.delegate = wrapper;
    anim.removedOnCompletion = YES;
    [self.layer addAnimation:anim forKey:@"expand_or_shrink"];
}

@end
