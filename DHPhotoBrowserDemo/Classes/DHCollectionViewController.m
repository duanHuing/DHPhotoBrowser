//
//  DHCollectionViewController.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHCollectionViewController.h"
#import "DHPhotoBrowser.h"
#import "DHPicCell.h"

@interface DHCollectionViewController ()

@property (nonatomic, strong) NSArray  *dataArray;

@end

@implementation DHCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"1",@"2"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DHPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.item]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DHPhotoBrowser *photoBrowser = [DHPhotoBrowser browserWithPhotos:self.dataArray currentIndex:indexPath.item];
    photoBrowser.srcImagesContainerView = collectionView;
    photoBrowser.currentSection = indexPath.section;
    [self presentViewController:photoBrowser animated:YES completion:nil];

}


@end
