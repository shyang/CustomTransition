---
layout: post
title:  "自定义转场动画的实现（参考：格瓦拉）"
date:   2017-03-28
---

参考实现：

![screen records of gewara]({{ site.url }}/assets/transition_gewara.gif)

### 辅助工作

* 使用 QuickTime Player 录制一段动画视频 mov。[可参考](http://osxdaily.com/2016/02/15/howto-record-iphone-screen-mac-quicktime/)
* 解压为一堆 png 文件，fps 设为 100，故每张对应 0.01 秒，方便记录动画开始与持续时间：`$ ffmpeg -i input.mov -vf fps=100 prefix-%03d.png`
* 如果要转为 gif，`-r fps` 设得小一些可减小文件体积：`$ ffmpeg -i input.mov -r 10 output.gif`


### 转场动画实现之一

![screen records of gewara]({{ site.url }}/assets/transition_magic.gif)

`UINavigationController` 有缺省的转场动画，可通过实现 `UINavigationControllerDelegate` 返回一个 Animator 对象来定制动画：

```objc
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
```

该 Animator 实现了 `UIViewControllerAnimatedTransitioning` 接口

```obj-c
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    /*
     主要有 5 个动画需要实现：
     1. 全屏不透明蒙板淡入
     2. 海报四周出现阴影（升起的视觉效果）
     3. 海报移动且放大
     4. 海报四周阴影消失且缩小（下落的视觉效果）
     5. 全屏不透明蒙板以海报为中心，涟漪式消除

     注1: Animator 需要插入各种遮罩，对被动画的 view 中的层级有假设，若嵌套层次超过一层，需要相应的修改。
     */

    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = transitionContext.containerView;

    // 动画的实现通过对 from.view, to.view, container 三者操作实现。
    // 在完成后需调用：
    [transitionContext completeTransition:YES];
}
```

以上，参考完整代码：[MagicAnimator.m](https://github.com/shyang/CustomTransition/blob/master/CustomTransition/MagicAnimator.m)

#### PS1 阴影的动画
```
CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
anim.fromValue = @(fromValue);
anim.toValue = @(toValue);
anim.removedOnCompletion = YES;
anim.duration = duration;

self.layer.shadowOpacity = toValue; // 设置为动画终止时的值
[self.layer addAnimation:anim forKey:@"expand_or_shrink"];
```

完整代码：[UIView+ShadowAnimation.m](https://github.com/shyang/CustomTransition/blob/master/CustomTransition/UIView%2BShadowAnimation.m)

#### PS2 涟漪消除的动画
```
CAShapeLayer *layer = [CAShapeLayer layer];
layer.frame = self.bounds;
layer.fillRule = kCAFillRuleEvenOdd;
layer.fillColor = [UIColor whiteColor].CGColor; // any color with no transparency
UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - holeRadius, y - holeRadius, holeRadius * 2, holeRadius * 2)];
UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - r, y - r, r * 2, r * 2)];

CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
anim.fromValue = (__bridge id)fromPath.CGPath;
anim.toValue = (__bridge id)toPath.CGPath;
anim.duration = duration;
anim.removedOnCompletion = YES;

layer.path = toPath.CGPath; // 设置为动画终止时的值
[layer addAnimation:anim forKey:@"expand_or_shrink"];
self.layer.mask = layer;
```

完整代码：[UIView+HoleAnimation.m](https://github.com/shyang/CustomTransition/blob/master/CustomTransition/UIView%2BHoleAnimation.m)

### 转场动画实现之二

![screen records of gewara]({{ site.url }}/assets/transition_hole.gif)

结构流程与实现1完全相同，动画内容较简单，只用了涟漪消除的动画。

完整代码：[HoleAnimator.m](https://github.com/shyang/CustomTransition/blob/master/CustomTransition/HoleAnimator.m)

## Further reading
> 2016-08-31
>
> * [iOS 7: Custom Transitions](https://possiblemobile.com/2013/09/ios-7-custom-transitions)
> * [UIViewController-Transitions-Example](https://github.com/TeehanLax/UIViewController-Transitions-Example)
> * [UIPercentDrivenInteractiveTransition](https://developer.apple.com/reference/uikit/uipercentdriveninteractivetransition)
> * [UIDynamicAnimator](https://developer.apple.com/reference/uikit/uidynamicanimator)
