//
//  MMSCFontAndColorUtil.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/30.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCFontAndColorUtil.h"

@implementation MMSCFontAndColorUtil

#pragma mark ---------------Font----------------

+ (UIFont *)titleSummaryFont {
    static UIFont *titleSummaryFont = nil;
    static dispatch_once_t titleOnce;
    dispatch_once(&titleOnce, ^{
        titleSummaryFont = [UIFont systemFontOfSize:30];
    });
    
    return titleSummaryFont;
}

+ (UIFont *)windBigLabelFont {
    static UIFont *windBigFont = nil;
    static dispatch_once_t windBigOnce;
    dispatch_once(&windBigOnce, ^{
        windBigFont = [UIFont systemFontOfSize:50 weight:5];
    });
    return windBigFont;
}

+ (UIFont *)startpageFont {
    static UIFont *playerNameFont = nil;
    static dispatch_once_t playerNameOnce;
    dispatch_once(&playerNameOnce, ^{
        playerNameFont = [UIFont systemFontOfSize:25];
    });
    return playerNameFont;
}

#pragma mark ---------------Color-----------------

+ (UIColor *)startPageBackgroundColor {
    static UIColor *startPageBGColor = nil;
    static dispatch_once_t startBGCOnce;
    dispatch_once(&startBGCOnce, ^{
        startPageBGColor = [[UIColor alloc] initWithRed:99/255.f green:133/255.f blue:167/255.f alpha:1];
    });
    return startPageBGColor;
}

+ (UIColor *)startPageLabelFontColor {
    static UIColor *spLabelFC = nil;
    static dispatch_once_t spLabelOnce;
    dispatch_once(&spLabelOnce, ^{
        spLabelFC = [[UIColor alloc] initWithRed:217/255.f green:208/255.f blue:199/255.f alpha:1];
    });
    return spLabelFC;
}

@end
