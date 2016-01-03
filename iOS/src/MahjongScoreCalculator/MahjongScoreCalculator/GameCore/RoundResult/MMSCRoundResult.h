//
//  MMSCRoundResult.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSCPlayer.h"

@interface MMSCRoundResult : NSObject

// 分数的变化情况
@property(nonatomic, strong) NSMutableArray *scoreChanges;

// 分配分数
- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore;

// 记录分数变化
- (void)recordScoreChangeAtIndex:(NSUInteger)index player:(MMSCPlayer *)player change:(NSInteger)change;

// 计算分数
- (NSInteger)calculateScoreAtFan:(NSInteger)fan fu:(NSInteger)fu isOYAWin:(BOOL)isOYAWin;

@end
