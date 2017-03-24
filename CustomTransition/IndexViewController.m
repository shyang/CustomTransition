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
#import "HoleMaskViewController.h"
#import "HoleAnimator.h"

@protocol Animator <UIViewControllerAnimatedTransitioning>

@property (nonatomic) UINavigationControllerOperation operation;

@end

@interface IndexViewController () <UINavigationControllerDelegate>

@property (nonatomic) NSArray *items;
@property (nonatomic) id<Animator> animator;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.delegate = self;
    _items = @[
        @{@"title": @"圆圈扩张 (hole expanding)", @"next": [HoleExpandingViewController class]},
        @{@"title": @"圆圈收缩 (hole shrinking)", @"next": [HoleShrinkingViewController class]},
        @{@"title": @"非纯色遮罩的扩张、收缩", @"next": [HoleMaskViewController class]},
        @{@"title": @"阴影扩张 (shadow on)", @"next": [ShadowOnViewController class]},
        @{@"title": @"阴影收缩 (shadow off)", @"next": [ShadowOffViewController class]},
        @{@"title": @"系统缺省 (system push/pop)", @"next": [BeginViewController class]},
        @{@"title": @"定制动画1 (customized push/pop)", @"next": [BeginViewController class], @"animator": [HoleAnimator class]},
        @{@"title": @"定制动画2 (customized push/pop)", @"next": [BeginViewController class], @"animator": [MagicAnimator class]},
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
    id item = _items[indexPath.row];
    Class cls = item[@"next"];
    [self.navigationController pushViewController:[[cls alloc] init] animated:YES];

    _animator = [[item[@"animator"] alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // 可根据 from、to、operation 等进行过滤
    if (_animator && fromVC != self && toVC != self) {
        _animator.operation = operation;
        return _animator;
    }
    return nil;
}

@end
