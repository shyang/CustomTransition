//
//  ShadowAnimationView.h
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShadowView : UIView

@property (nonatomic) BOOL reverse; // 不是扩张，而是缩小。

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay preparation:(void (^)(void))preparation completion:(void (^)(BOOL finished))completion;

@end
