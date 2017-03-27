//
//  HoleMaskView.h
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HoleAnimation)

// center: 空洞的初始圆心，缺省为正中
// reverse: 不是扩张，而是缩小。holeCenter、holeRadius 的意义变为终止状态时的值
- (void)holeAtCenter:(CGPoint)center duration:(NSTimeInterval)duration reverse:(BOOL)reverse completion:(void (^)(BOOL finished))completion;

@end
