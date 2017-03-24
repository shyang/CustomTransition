//
//  EndViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "EndViewController.h"
#import "UIViewController+MagicView.h"

@interface EndViewController ()

@end

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"EndViewController";

    self.view.backgroundColor = [UIColor greenColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"269.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // [self.view addSubview:imageView];

    UIImageView *post = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_1"]];
    post.frame = CGRectMake(12, 155, 88, 115);
    post.userInteractionEnabled = YES;
    self.magicView = post; // target for Animator
    [self.view addSubview:post];
    [post addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)]];
}

- (void)onViewTapped:(UIGestureRecognizer *)gesture {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
