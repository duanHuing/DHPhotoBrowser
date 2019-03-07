//
//  DHImageTool.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHImageTool.h"

@implementation DHImageTool

+ (CGRect)adaptSizeWithImage:(UIImage*)image maxSize:(CGSize)maxSize {
    
    CGSize imageSize = image.size;
    
    CGRect newRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    
    if (maxSize.width < maxSize.height) {
        
        // 图片宽度 = 屏幕宽度
        newRect.size.width = maxSize.width;
        newRect.size.height = maxSize.width / imageSize.width * imageSize.height ;
        
        if (newRect.size.height < maxSize.height) {
            newRect.origin.y = (maxSize.height - newRect.size.height) / 2 ;
        }
        return newRect ;
        
        
    }
    
    newRect.size.height = maxSize.height;
    newRect.size.width = maxSize.height / imageSize.height * imageSize.width ;
    
    if (newRect.size.width < maxSize.width) {
        newRect.origin.x = (maxSize.width - newRect.size.width) / 2 ;
    }
    return newRect;
}


@end
