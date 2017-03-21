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

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"269.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)]];
}

- (void)onViewTapped:(UIGestureRecognizer *)gesture {
    NSLog(@"%@", NSStringFromCGPoint([gesture locationInView:gesture.view]));

    [self.navigationController popViewControllerAnimated:YES];
}

@end
