//
//  MagicAnimator.h
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicAnimator : NSObject <UIViewControllerAnimatedTransitioning>

// 动画根据 push、pop 表现不同，需要传入
@property (nonatomic) UINavigationControllerOperation operation;

@end
