//
//  DHPhotoCell.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHPhotoCell.h"
#import "DHImageTool.h"
#import <UIImageView+WebCache.h>

@interface DHPhotoCell()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation DHPhotoCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.scrollView];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;
    
    [self resetImageSize];
    
}

#pragma mark - actions

-(void)singleTap:(UITapGestureRecognizer*)tap {
    if (self.singleClickBlock) {
        self.singleClickBlock(self.imageView);
    }
}


#pragma mark - method

- (void)resetImageSize {
    if (!self.imageView.image) {
        return;
    }
    
    self.imageView.frame = [DHImageTool adaptSizeWithImage:self.imageView.image maxSize:self.bounds.size];
    CGFloat max_width = MAX(CGRectGetWidth(self.frame), CGRectGetWidth(self.imageView.frame));
    CGFloat max_height = MAX(CGRectGetHeight(self.imageView.frame), CGRectGetHeight(self.frame));
    _scrollView.contentSize = CGSizeMake(max_width, max_height);
    [_scrollView scrollRectToVisible:_scrollView.bounds animated:NO];
    
}

// 赋值
- (void)configCellWithItem:(id)item {
    
    if ([item hasPrefix:@"http"]) {
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [weakSelf resetImageSize];
        
        }];
    }
    else {
        UIImage *img = [UIImage imageNamed:item];
        self.imageView.image = img;
        [self resetImageSize];
    }
}


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


#pragma mark - lazy loading

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        // 设置 scrollView的 最大 和 最小 缩放比率
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 5;
        //没有下面一句的话，顶部会有留白
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_scrollView addGestureRecognizer:singleTap];
    }
    return _scrollView;
}

@end
