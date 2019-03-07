//
//  DHPicTableViewCell.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/6.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHPicTableViewCell.h"
#import "DHPhotoBrowser.h"


@interface DHPicTableViewCell()
{
    NSArray * _imgNames ;
}
@end

@implementation DHPicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _imgNames = @[@"1",@"2"];
        
        for (int i = 0; i < _imgNames.count; i++) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(50 + (80 + 10) * i, 0, 80, 80)];
            imv.image = [UIImage imageNamed:_imgNames[i]];
            imv.userInteractionEnabled = YES;
            imv.tag = i + 100 ;
            [self.contentView addSubview:imv];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
            [imv addGestureRecognizer:tap];
        }
        
        
    }
    return self ;
}

- (void)clickTap:(UITapGestureRecognizer*)tap {
    
    DHPhotoBrowser *photoBrowser = [DHPhotoBrowser browserWithPhotos:_imgNames currentIndex:tap.view.tag - 100];
    photoBrowser.srcImagesContainerView = tap.view.superview;
    photoBrowser.imageViewBaseTag = 100;
    [self.superVC presentViewController:photoBrowser animated:YES completion:nil];
    
}

@end
