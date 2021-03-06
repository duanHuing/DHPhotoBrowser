//
//  DHPhotoBrowser.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHPhotoBrowser.h"
#import "DHZoomTransition.h"
#import "DHPhotoCell.h"

@interface DHPhotoBrowser ()<UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UIViewControllerTransitioningDelegate>

/**  一个横向滑动的collectionView  */
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray  *photosArray;


@property (nonatomic, strong) UIImageView  *tmpImageView;

/**  被点击imageView，主要记录它的位置，方便做专场动画   */
@property (nonatomic, strong) UIImageView *srcImageView;

@property (nonatomic, assign) NSInteger  currentIndex;

@end

@implementation DHPhotoBrowser

static NSString * const DHPhotoBrowserCellId = @"CellID";
static CGFloat const DHPhotoBrowserItemSpacing = 10;

+ (instancetype)browserWithPhotos:(NSArray*)photos currentIndex:(NSInteger)currentIndex {
    return [[self alloc] initWithPhotos:photos currentIndex:currentIndex];
}

- (instancetype)initWithPhotos:(NSArray*)photos currentIndex:(NSInteger)currentIndex {
    if (self = [super init]) {
        _photosArray = photos;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc -- %@",self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.transitioningDelegate = self;
   
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self dh_setupConstraints];
    
}

#pragma mark - public 

// 显示浏览器
- (void)showFromController:(UIViewController *)fromController {
    
    [fromController presentViewController:self animated:YES completion:nil];

}

#pragma mark - Private

// 返回
- (void)dh_dismissWhenClickedImageView:(UIImageView *)imageView {
    
    self.tmpImageView = imageView;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 设置约束  VFL
- (void)dh_setupConstraints {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false;
    // H：水平   ； V：垂直
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-s-[collectionView]-s-|"
                                                            options:0
                                                            metrics:@{@"s":@(-DHPhotoBrowserItemSpacing)}
                                                              views:@{@"collectionView":_collectionView}];
    
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                            options:0
                                                            metrics:nil
                                                              views:@{@"collectionView":_collectionView}];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DHPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DHPhotoBrowserCellId forIndexPath:indexPath];
    [cell configCellWithItem:self.photosArray[indexPath.item]];
    
    __weak __typeof(self)weakSelf = self;
    cell.singleClickBlock = ^(UIImageView * _Nonnull imageView) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dh_dismissWhenClickedImageView:imageView];
    };
    return cell;
}

#pragma mark <UICollectionViewDelegate>


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

#pragma mark - UIScrollViewDelegate

/**  监听collectionView滚动  */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _collectionView) {
        return;
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.collectionView.frame);
    int page = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentIndex = page;
    
}

#pragma mark - UIViewControllerTransitioningDelegate

/**  Presented 时的弹出动画  */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [DHZoomTransition transitionWithType:DHZoomTransitionTypeEnlarge];
}

/**  dismiss时的消失动画  */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DHZoomTransition transitionWithType:DHZoomTransitionTypeLessen];
}

#pragma mark - super

// 转屏时会被调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    #warning 屏幕旋转后，改变cell的size，显示图片的cell位置会有问题，待解决
    //[self.collectionView reloadData];
    [self.collectionView performBatchUpdates:nil completion:nil];
}

#pragma mark - getter

- (UIImageView *)srcImageView {
    
    if ([_srcImagesContainerView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView*)_srcImagesContainerView;
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:_currentSection]];
        _srcImageView = [cell valueForKey:self.imageViewKeyInCell];
    }
    else {
        _srcImageView =  [self.srcImagesContainerView viewWithTag:_imageViewBaseTag + _currentIndex] ;
    }
    return _srcImageView;
}

#pragma mark - lazy loading

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 2 * DHPhotoBrowserItemSpacing;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = self.view.frame.size;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, DHPhotoBrowserItemSpacing, 0, DHPhotoBrowserItemSpacing);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-DHPhotoBrowserItemSpacing, 0, CGRectGetWidth(self.view.frame) + 2 * DHPhotoBrowserItemSpacing, CGRectGetHeight(self.view.bounds)) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[DHPhotoCell class] forCellWithReuseIdentifier:DHPhotoBrowserCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSString *)imageViewKeyInCell {
    if (!_imageViewKeyInCell) {
        _imageViewKeyInCell = @"imageView";
    }
    return _imageViewKeyInCell;
}

@end
