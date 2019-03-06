//
//  ViewController.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "ViewController.h"
#import "DHPhotoBrowser.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()
{
    NSArray * _imgNames ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    [self.view addSubview:bgView];
    
    _imgNames = @[@"1",@"2",@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=830679257,1064416440&fm=173&app=25&f=JPEG?w=218&h=146&s=2BB0058BC6A230BCC8A9948F030070C2",@"3"];
    
    for (int i = 0; i < _imgNames.count; i++) {
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(50 + (80 + 10) * i, 0, 80, 80)];
        imv.image = [UIImage imageNamed:_imgNames[i]];
        
        if ([_imgNames[i] hasPrefix:@"http"]) {
            [imv sd_setImageWithURL:[NSURL URLWithString:_imgNames[i]]];
        }
        imv.userInteractionEnabled = YES;
        imv.tag = i + 100 ;
        [bgView addSubview:imv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
        [imv addGestureRecognizer:tap];
    }
}

//
- (void)clickTap:(UITapGestureRecognizer*)tap {
    
    DHPhotoBrowser *photoBrowser = [DHPhotoBrowser browserWithPhotos:_imgNames currentIndex:tap.view.tag - 100];
    
    photoBrowser.srcImagesContainerView = tap.view.superview;
    photoBrowser.imageViewBaseTag = 100;
    [photoBrowser showFromController:self];
    
}

- (void)lksjdsfh {
    
}

@end
