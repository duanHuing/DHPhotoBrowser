//
//  DHZoomTransition.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHZoomTransition.h"
#import "DHPhotoBrowser.h"
#import "DHImageTool.h"

static NSTimeInterval const DHTransitionEntityDuration = 0.3 ;


@interface DHZoomTransition ()

@property (nonatomic,assign)DHZoomTransitionType transitionType;

@end

@implementation DHZoomTransition 

+ (instancetype)transitionWithType:(DHZoomTransitionType)transitionType {
    return [[self alloc] initWithTransitionType:transitionType];
}

- (instancetype)initWithTransitionType:(DHZoomTransitionType)transitionType {
    if (self = [super init]) {
        _transitionType = transitionType;
    }
    return self;
}

#pragma mark - method

/**  放大 present  */
- (void)enlargeTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    DHPhotoBrowser *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    /**  找到被点击的图片view，截图用来做动画  */
    UIImageView *clickedImageView = toViewController.srcImageView;
    
    UIView *imvSnapShot = [clickedImageView snapshotViewAfterScreenUpdates:YES];
    imvSnapShot.frame = [containerView convertRect:clickedImageView.frame fromView:clickedImageView.superview];
    clickedImageView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.collectionView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:imvSnapShot];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         imvSnapShot.frame = [DHImageTool adaptSizeWithImage:clickedImageView.image maxSize:[UIScreen mainScreen].bounds.size];
                         toViewController.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         clickedImageView.hidden = NO;
                         toViewController.collectionView.hidden = NO;
                         [imvSnapShot removeFromSuperview];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         
                     }];
}



/**  缩小  dissmiss   */
- (void)lessenTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DHPhotoBrowser *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIImageView *imv = fromViewController.tmpImageView;
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
        imv.hidden = NO;
        [imvsSnapShot removeFromSuperview];
        
        fromViewController.srcImageView.hidden = NO;
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


#pragma mark - UIViewControllerAnimatedTransitioning

/**  动画时间  */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return DHTransitionEntityDuration;
}

/**  动画  */
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case DHZoomTransitionTypeEnlarge: {
            [self enlargeTransition:transitionContext];
            break;
        }
        case DHZoomTransitionTypeLessen: {
            [self lessenTransition:transitionContext];
            break;
        }
    }
}





@end
