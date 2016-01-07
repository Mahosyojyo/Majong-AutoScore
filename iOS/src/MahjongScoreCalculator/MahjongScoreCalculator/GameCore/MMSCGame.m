//
//  MMSCGame.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCGame.h"
#import "MMSCRound.h"

@implementation MMSCGame

- (void)randomSeat {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_players];
    
    for (int i = 0; i < 4; i++) {
        int index = rand() % (4 - i);
        
        [temp exchangeObjectAtIndex:i withObjectAtIndex:i + index];
    }
    
    _players = [NSArray arrayWithArray:temp];
}

- (void)endCurrentRoundWithResult:(MMSCRoundResult *)result {
    
    MMSCRound *currentRound = [self currentRound];
    [currentRound setResult:result];
    
    // 结束该局，分配分数
    [currentRound endRoundWithPlayers:self.players];
    
    if (![self isGameEnded]) {
        [self setNextRound:currentRound];
    }
}

// TODO 创建下一局 1、换庄 2、本场数 3、立直棒的处理，创建新的Round，添加到rounds里
- (void)setNextRound:(MMSCRound *)currentRound {
    
}

@end
