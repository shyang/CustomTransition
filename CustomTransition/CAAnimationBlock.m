//
//  CAAnimationBlock.m
//  CustomTransition
//
//  Created by shaohua on 27/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "CAAnimationBlock.h"

@implementation CAAnimationBlock

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_block) {
        _block(flag);
        _block = nil; // one shot
    }
}

@end
