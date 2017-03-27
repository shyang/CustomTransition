//
//  CAAnimationBlock.h
//  CustomTransition
//
//  Created by shaohua on 27/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAAnimationBlock : NSObject <CAAnimationDelegate>

@property (nonatomic, copy) void (^block)(BOOL);

@end
