//
//  ShadowAnimationView.h
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShadowAnimationView : UIView

@property (nonatomic) BOOL reverse; // 不是扩张，而是缩小。
@property (nonatomic) CFTimeInterval duration; // 动画时间，缺省 0.1 秒

- (void)startAnimationWithCompletion:(void (^)(BOOL finished))completion;

@end
