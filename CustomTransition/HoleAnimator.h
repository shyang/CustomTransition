//
//  HoleAnimator.h
//  CustomTransition
//
//  Created by shaohua on 24/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoleAnimator : NSObject <UIViewControllerAnimatedTransitioning>

// 动画根据 push、pop 表现不同，需要传入
@property (nonatomic) UINavigationControllerOperation operation;

@end
