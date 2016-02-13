//
//  MMSCFontAndColorUtil.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/30.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMSCPlayerViewTag) {
    MMSCPlayerViewTagPlayer1 = 0x666,
    MMSCPlayerViewTagPlayer2,
    MMSCPlayerViewTagPlayer3,
    MMSCPlayerViewTagPlayer4,
};

@interface MMSCFontAndColorUtil : NSObject

// 欢迎页顶层字体
+ (UIFont *)titleSummaryFont;

// 大号风向字体
+ (UIFont *)windBigLabelFont;

// 欢迎页普通字体
+ (UIFont *)startpageFont;

// 欢迎页背景颜色
+ (UIColor *)startPageBackgroundColor;

// 欢迎页Label字体颜色
+ (UIColor *)startPageLabelFontColor;

// Color2Image
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
