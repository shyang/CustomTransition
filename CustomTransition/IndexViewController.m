//
//  IndexViewController.m
//  CustomTransition
//
//  Created by shaohua on 22/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "IndexViewController.h"
#import "HoleExpandingView.h"
#import "ShadowAnimationView.h"
#import "HoleExpandingViewController.h"
#import "HoleShrinkingViewController.h"
#import "ShadowOnViewController.h"
#import "ShadowOffViewController.h"
#import "BeginViewController.h"
#import "MagicAnimator.h"
#import "UIViewController+MagicView.h"

@interface IndexViewController () <UINavigationControllerDelegate>

@property (nonatomic) NSArray *items;
@property (nonatomic) BOOL enableTransitionAnimation;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.delegate = self;
    _items = @[
        @{@"title": @"圆圈扩张 (hole expanding)", @"next": [HoleExpandingViewController class]},
        @{@"title": @"圆圈收缩 (hole shrinking)", @"next": [HoleShrinkingViewController class]},
        @{@"title": @"阴影扩张 (shadow on)", @"next": [ShadowOnViewController class]},
        @{@"title": @"阴影收缩 (shadow off)", @"next": [ShadowOffViewController class]},
        @{@"title": @"系统缺省 (system push/pop)", @"next": [BeginViewController class]},
        @{@"title": @"定制动画 (customized push/pop)", @"next": [BeginViewController class]},
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _items[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls = _items[indexPath.row][@"next"];
    [self.navigationController pushViewController:[[cls alloc] init] animated:YES];

    _enableTransitionAnimation = indexPath.row == _items.count - 1;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // 可根据 from、to、operation 等进行过滤
    if (_enableTransitionAnimation && fromVC != self && toVC != self) {
        MagicAnimator *animator = [[MagicAnimator alloc] init];
        animator.operation = operation;
        return animator;
    }
    return nil;
}

@end
