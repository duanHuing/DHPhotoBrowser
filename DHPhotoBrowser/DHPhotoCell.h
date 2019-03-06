//
//  DHPhotoCell.h
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPhotoCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UIScrollView *scrollView;

@property (nonatomic,strong,readonly)UIImageView *imageView;

//单击回调
@property (nonatomic, copy) void (^singleClickBlock)(UIImageView *imageView);

- (void)configCellWithItem:(id)item  ;

@end

NS_ASSUME_NONNULL_END
