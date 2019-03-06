最近看到了一篇博客[iOS 7 交互式过渡](http://nonomori.farbox.com/post/ios-7-jiao-hu-shi-guo-du),就根据博主提供的demo以及介绍敲了一遍，突然觉得自己可以模仿着这个写一个图片浏览器，于是就写了。

## 效果：

进出图片浏览器时会有一个放大、缩小的动画。浏览器中可以通过捏合缩放图片

![Q20180411-170112-H](https://upload-images.jianshu.io/upload_images/10776844-49f561816b0981c7.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/326)

## 实现思路：

#### 1.浏览器部分是以一个水平滚动的collectionView作为载体

* 自定义一个cell

* 添加子控件

```objective-c
[self.contentView addSubview:self.scrollView];
_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
_imageView.contentMode = UIViewContentModeScaleAspectFit;
[self.scrollView addSubview:_imageView];
```

* 根据image.size调整imageView.frame、scrollerView.contentSize，让长图可以上下滚动

```objective-c
/**
根据image.size调整imageView.frame、scrollerView.contentSize，让长图可以上下滚动
imageView.image赋值成功时调用
*/
- (void)resetSubViews {
UIImage *image = self.imageView.image;
if (!image) {
return;
}
//根据图片大小调整imageView的frame和_scrollView的contentSize，
//固定图片大小为屏宽，根据图片宽高比例算出图片的高度，
CGFloat imageViewHeight = image.size.height / image.size.width * CGRectGetWidth(self.frame);
self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), imageViewHeight);

//如果图片没有超出屏幕，将其放到屏幕中心
if (imageViewHeight < CGRectGetHeight(self.frame)) {
self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}

_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), MAX(imageViewHeight, CGRectGetHeight(self.frame)));
[_scrollView scrollRectToVisible:_scrollView.bounds animated:NO];

if (imageViewHeight <= CGRectGetHeight(self.frame)) {
_scrollView.alwaysBounceVertical = NO;
} else {
_scrollView.alwaysBounceVertical = YES;
}   
}
```

* 捏合实现图片的缩放

```objective-c
_scrollView.delegate = self;
// 设置 scrollView的 最大 和 最小 缩放比率
_scrollView.minimumZoomScale = 1;
_scrollView.maximumZoomScale = 5;
```

```
#pragma mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
// 在ScrollView上  所需要缩放的 对象
return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//捏合图片时调整图片的位置
CGFloat offsetX = (CGRectGetWidth(scrollView.bounds) > scrollView.contentSize.width)?
(CGRectGetWidth(scrollView.bounds) - scrollView.contentSize.width) / 2 : 0.0;

CGFloat offsetY = (CGRectGetHeight(scrollView.bounds) > scrollView.contentSize.height)?
(CGRectGetHeight(scrollView.bounds) - scrollView.contentSize.height) / 2 : 0.0;
self.imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX,
scrollView.contentSize.height / 2 + offsetY);
}
```

* collectionView由viewController管理。

####2、通过自定义转场动画来实现图片浏览器出现与消失时图片的缩放动画。

* 实现viewController的UIViewControllerTransitioningDelegate

```objective-c
self.transitioningDelegate = self;
```

```objective-c
#pragma mark -- UIViewControllerTransitioningDelegate

/**  Presented 时的弹出动画  */
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
return [DHTransitionEntity transitionWithType:1];
}

/**  dismiss时的消失动画  */
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
return [DHTransitionEntity transitionWithType:2];
}
```

* 转场动画的具体实现：

* 新建一个继承NSObject的类：DHTransitionEntity，添加协议：UIViewControllerAnimatedTransitioning，分别实现animateTransition: 和 transitionDuration:

```objective-c
/**  动画时间  */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
return 0.3;
}
```

```objective-c
/**  动画  */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

if (self.transitionType == 1) {
[self enlargeTransition:transitionContext];
}
else if (self.transitionType == 2) {
[self lessenTransition:transitionContext];
}   
}
```

```objective-c
/**  放大 present  */
-(void)enlargeTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

DHPhotoBrowser *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
UIView *containerView = [transitionContext containerView];
NSTimeInterval duration = [self transitionDuration:transitionContext];

/**  找到被点击的图片view，截图用来做动画  */
UIImageView *clickedImageView = toViewController.srcImageView;
UIView *imvsSnapShot = [clickedImageView snapshotViewAfterScreenUpdates:YES];
imvsSnapShot.frame = [containerView convertRect:clickedImageView.frame fromView:clickedImageView.superview];
clickedImageView.hidden = YES;

toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
toViewController.view.alpha = 0;
//   toViewController.imageView.hidden = YES;

[containerView addSubview:toViewController.view];
[containerView addSubview:imvsSnapShot];

[UIView animateWithDuration:duration animations:^{
// Fade in the second view controller's view
toViewController.view.alpha = 1.0;

CGFloat sHeight = clickedImageView.image.size.height / clickedImageView.image.size.width * [UIScreen mainScreen].bounds.size.width;
CGFloat fY = ([UIScreen mainScreen].bounds.size.height - sHeight) / 2 ;
imvsSnapShot.frame = CGRectMake(0, fY > 0 ? fY : 0, [UIScreen mainScreen].bounds.size.width, sHeight);

} completion:^(BOOL finished) {
// Clean up
//toViewController.tempImgView.hidden = NO;
clickedImageView.hidden = NO;
[imvsSnapShot removeFromSuperview];

// Declare that we've finished
[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}];
}
```

```objective-c
/**  缩小  dissmiss   */
-(void)lessenTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
DHPhotoBrowser *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

UIView *containerView = [transitionContext containerView];
NSTimeInterval duration = [self transitionDuration:transitionContext];

UIImageView *imv = fromViewController.tempImageView;
UIView *imvsSnapShot = [imv snapshotViewAfterScreenUpdates:YES];
imvsSnapShot.frame = [containerView convertRect:imv.frame fromView:imv.superview];
imv.hidden = YES;

toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
toViewController.view.alpha = 0;
//   toViewController.imageView.hidden = YES;

[containerView addSubview:toViewController.view];
[containerView addSubview:imvsSnapShot];

[UIView animateWithDuration:duration animations:^{
// Fade in the second view controller's view
toViewController.view.alpha = 1.0;
CGRect frame = [containerView convertRect:fromViewController.srcImageView.frame fromView:fromViewController.srcImageView.superview];
imvsSnapShot.frame = frame;

} completion:^(BOOL finished) {
// Clean up
//  toViewController.imageView.hidden = NO;
imv.hidden = NO;
[imvsSnapShot removeFromSuperview];
// Declare that we've finished
[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}]; 
}
```

[简书](https://www.jianshu.com/p/035b89d3bdd9)

​
​
​​
