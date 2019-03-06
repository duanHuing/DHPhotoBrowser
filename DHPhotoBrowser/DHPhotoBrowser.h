//
//  DHPhotoBrowser.h
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPhotoBrowser : UIViewController

/**  浏览器的载体 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/**  记录下浏览器返回时当前显示的图片载体, 用来计算所在位置，用来做转场动画*/
@property (nonatomic, strong, readonly) UIImageView  *tmpImageView;

/**  记录浏览器出现和消失所在的源图片载体，用来计算所在位置，用来做转场动画  */
@property (nonatomic, strong, readonly) UIImageView *srcImageView;

/**  放图片的容器，如果图片是collectionViewCell.imageView ,则赋值collectionView  */
@property (nonatomic,   weak) UIView *srcImagesContainerView;

/** 创建imageView时 imageView.tag = _imageViewBaseTag + index ,方便找到动画结束时停留的位置 ，如果
    srcImagesContainerView == UICollectionView ,则不需要赋值 */
@property (nonatomic, assign) NSInteger  imageViewBaseTag;

/**
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UICollectionView >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 */

/**  srcImagesContainerView == UICollectionView 时，需要给出被点击cell所在的section，默认为0  */
@property (nonatomic, assign) NSInteger currentSection;
/**  容器为collectionView时，UIImageView 在cell里的key 默认是 imageView */
@property (nonatomic, strong) NSString  *imageViewKeyInCell;

/**
 初始化

 @param photos 图片地址或图片名称
 @param currentIndex 当前位置
 @return DHPhotoBrowser
 */
+ (instancetype)browserWithPhotos:(NSArray*)photos currentIndex:(NSInteger)currentIndex;

/**
 显示浏览器

 @param fromController 控制器
 */
- (void)showFromController:(UIViewController*)fromController ;

@end

NS_ASSUME_NONNULL_END
