//
//  DHImageTool.h
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/5.
//  Copyright © 2019年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHImageTool : NSObject

+ (CGRect)adaptSizeWithImage:(UIImage*)image maxSize:(CGSize)maxSize ;

@end

NS_ASSUME_NONNULL_END
