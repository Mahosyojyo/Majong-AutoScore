//
//  MMSCGame.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSCRound.h"

@class MMSCRoundResult;
@class MMSCPlayer;

@interface MMSCGame : NSObject

// 玩家们
@property(nonatomic, strong) NSArray           *players;
// 庄家索引
@property(nonatomic, assign) NSInteger         oyaIndex;
// 对局们
@property(nonatomic, strong) NSMutableArray    *rounds;

// 初始化游戏
- (void)gameInit;

// 随机座位
- (void)randomSeat;

// 结束该局
- (void)endCurrentRoundWithResult:(MMSCRoundResult *)result;

// 判断对局是否结束
- (BOOL)isGameEnded;

// 立直
- (void)richiAtPlayerIndex:(NSUInteger)playerIndex;

// 获取庄家
- (MMSCPlayer *)getOYA;

// 获取某个玩家
- (MMSCPlayer *)getPlayerAtIndex:(NSInteger)index;

// 获取当前的一局
- (MMSCRound *)currentRound;

@end
