//
//  BeginViewController.m
//  CustomTransition
//
//  Created by shaohua on 21/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "BeginViewController.h"
#import "EndViewController.h"

@interface BeginViewController ()

@end

@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"203.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)]];
}

- (void)onViewTapped:(UIGestureRecognizer *)gesture {
    NSLog(@"%@", NSStringFromCGPoint([gesture locationInView:gesture.view]));

    [self.navigationController pushViewController:[[EndViewController alloc] init] animated:YES];
}

@end
