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

// 当前局名
- (NSString *)currentRoundName;

// 当前庄家
- (NSString *)currentOYAName;

// 当前OYAIndex
- (NSUInteger)currentOYAIndex;

// 玩家的名称
- (NSArray *)playerNames;

// 玩家的风位
- (NSArray *)currentPlayerWinds;

// 玩家的分数
- (NSArray *)currentPlayerScores;

// 某一局的名称
- (NSString *)roundNameAtIndex:(NSUInteger)index;

// 某一局的分数变化
- (NSArray *)roundScoreChangesAtIndex:(NSUInteger)index;

// 当前局的分数变化
- (NSArray *)currentRoundScoreChanges;

// 当前局中立直的人
- (NSArray *)currentRichiPlayers;

// 立直
- (void)richiAtPlayers:(NSArray *)richiPlayerIndexes;

// 当前的立直棒数
- (NSInteger)currentRichiCount;

// 自摸
- (void)tsumoAtPlayer:(NSUInteger)playerIndex fan:(NSInteger)fan fu:(NSInteger)fu;

// 放铳
- (void)ronAtPlayers:(NSArray *)winners loser:(NSUInteger)loserIndex fan:(NSArray *)fan fu:(NSArray *)fu;

// 流局
- (void)drawForType:(NSInteger)type players:(NSArray *)players oyaTenpai:(BOOL)oyaTenpai;

// 游戏是否结束
- (BOOL)isGameEnded;

// 玩家排位
- (NSArray *)sortedPlayers;

// 撤销上一局
- (void)cancelLastRound;

@end
