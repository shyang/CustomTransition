//
//  HoleExpandingView.h
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoleExpandingView : UIView <CAAnimationDelegate>

@property (nonatomic) CGPoint holeCenter; // 空洞的初始圆心，缺省为正中
@property (nonatomic) CGFloat holeRadius; // 空洞的初始半径，缺省为 0
@property (nonatomic) UIColor *fillColor; // 空洞外围的填充色，缺省为白色
@property (nonatomic) CFTimeInterval duration; // 动画时间，缺省 1 秒

- (void)startAnimation;

@end
