//
//  BeginViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "BeginViewController.h"
#import "EndViewController.h"
#import "UIViewController+MagicView.h"

@interface BeginViewController ()

@end

@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"BeginViewController";

    self.view.backgroundColor = [UIColor redColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    // [self.view addSubview:imageView];

    // 加入三个需被操作的海报图片，作为演示只适配了 iPhone 5 的绝对定位：
    for (int i = 0; i < 3; ++i) {
        UIImageView *post = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"post_%d", i + 1]]];
        post.frame = CGRectMake(12 + 96 * i, 273, 88, 115);
        post.userInteractionEnabled = YES;
        [self.view addSubview:post];
        [post addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)]];
    }
}

- (void)onViewTapped:(UIGestureRecognizer *)gesture {
    // Animator 需要知道哪个控件触发了页面跳转事件，此处使用 tag 来标记
    self.magicView = gesture.view;

    [self.navigationController pushViewController:[[EndViewController alloc] init] animated:YES];
}

@end
