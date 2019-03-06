//
//  DHZoomTransition.h
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, DHZoomTransitionType) {
    DHZoomTransitionTypeEnlarge ,
    DHZoomTransitionTypeLessen
};

NS_ASSUME_NONNULL_BEGIN

@interface DHZoomTransition : NSObject <UIViewControllerAnimatedTransitioning>

+(instancetype)transitionWithType:(DHZoomTransitionType)transitionType ;

@end

NS_ASSUME_NONNULL_END
