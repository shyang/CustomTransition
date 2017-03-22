//
//  UIViewController+MagicView.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+MagicView.h"

static void *kMagicViewPointer;

@implementation UIViewController (MagicView)

- (UIView *)magicView {
    return objc_getAssociatedObject(self, &kMagicViewPointer);
}

- (void)setMagicView:(UIView *)magicView {
    objc_setAssociatedObject(self, &kMagicViewPointer, magicView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
