//
//  UIView+ShadowAnimation.h
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShadowAnimation)

- (void)shadowWithDuration:(NSTimeInterval)duration reverse:(BOOL)reverse completion:(void (^)(BOOL finished))completion;

@end
