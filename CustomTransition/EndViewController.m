//
//  EndViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "EndViewController.h"

@interface EndViewController ()

@end

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"To";

    self.view.backgroundColor = [UIColor lightGrayColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"269.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // [self.view addSubview:imageView];

    UIImageView *post = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_1"]];
    post.frame = CGRectMake(12, 155, 88, 115);
    post.userInteractionEnabled = YES;
    post.tag = 10000; // target for Animator
    [self.view addSubview:post];
    [post addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)]];
}

- (void)onViewTapped:(UIGestureRecognizer *)gesture {
    NSLog(@"%@", NSStringFromCGPoint([gesture locationInView:gesture.view]));
    gesture.view.tag = 10000; // source for Animator
    [self.navigationController popViewControllerAnimated:YES];
}

@end
