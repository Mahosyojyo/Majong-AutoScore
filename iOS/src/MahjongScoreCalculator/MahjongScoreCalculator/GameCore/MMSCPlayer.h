//
//  MMSCPlayer.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSCUtil.h"

@interface MMSCPlayer : NSObject

// 名字
@property(nonatomic, strong) NSString       *name;
// 风位
@property(nonatomic, assign) MMSCWind       wind;
// 分数
@property(nonatomic, assign) NSInteger      score;

// 加分
- (void)increaseScore:(NSInteger)increment;

// 扣分
- (void)decreaseScore:(NSInteger)decrement;

// 是不是庄家
- (BOOL)isOYA;

@end
