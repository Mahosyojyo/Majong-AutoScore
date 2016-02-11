//
//  MMSCGameManager.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/11.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSCGameManager : NSObject

+ (MMSCGameManager *)instance;

// 初始化
- (void)initGameWithPlayers:(NSArray *)playerNames;

// 随机座位，初始化并返回结果
- (NSArray *)randomSeatWithPlayers:(NSArray *)playerNames;

// 局数
- (NSInteger)roundCount;

@end
