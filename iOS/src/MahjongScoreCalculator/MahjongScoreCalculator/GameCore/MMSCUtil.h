//
//  MMSCUtil.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMSCWind) {
    MMSCWindEast = 0,
    MMSCWindSouth,
    MMSCWindWest,
    MMSCWindNorth
};

#define PLAYER_NUMBER 4

@interface MMSCUtil : NSObject

// 转换为中文
+ (NSString *)convertToCharacterWithNumber:(NSInteger)number;

// 取到100
+ (NSInteger)increaseToHundredForScore:(NSInteger)score;

@end
