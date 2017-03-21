//
//  ViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ViewController.h"
#import "BeginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithRootViewController:[[BeginViewController alloc] init]]) {
        self.navigationBarHidden = YES;
    }
    return self;
}

@end
