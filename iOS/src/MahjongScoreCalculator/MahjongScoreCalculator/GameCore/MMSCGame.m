//
//  MMSCGame.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCGame.h"
#import "MMSCRound.h"
#import "MMSCRoundResult.h"

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

- (void)setNextRound:(MMSCRound *)currentRound {
    MMSCRoundResult *currentResult = [currentRound result];
    MMSCRound *nextRound = [MMSCRound new];
    
    BOOL isDraw = [currentResult isDraw];
    BOOL changeOYA = [currentResult changeOYA:self.oyaIndex];
    
    // 设置场风和局数，换庄
    if (!changeOYA) {
        nextRound.roundWind = currentRound.roundWind;
        nextRound.roundNumeber = currentRound.roundNumeber;
    } else {
        [self setNextOYAAndPlayersWind];
        [self setNextWindAndRoundNumber:nextRound currentRound:currentRound];
    }
    
    // 本场数
    if (!changeOYA || isDraw) {
        nextRound.bonbanNumber = currentRound.bonbanNumber + 1;
    }
    
    // 立直棒处理
    if (isDraw) {
        nextRound.richiScore = currentRound.richiScore;
    }
    
    [self.rounds addObject:nextRound];
}

- (void)setNextOYAAndPlayersWind {
    
    self.oyaIndex++;
    
    if (self.oyaIndex >= 4) {
        self.oyaIndex = 0;
    }
    
    for (MMSCPlayer *player in self.players) {
        player.wind = [self nextWind:player.wind];
    }
}

- (void)setNextWindAndRoundNumber:(MMSCRound *)nextRound currentRound:(MMSCRound *)currentRound {
    NSInteger nextRoundNumber = currentRound.roundNumeber + 1;
    MMSCWind nextRoundWind = currentRound.roundWind;
    
    if (nextRoundNumber > 4) {
        nextRoundWind = [self nextWind:nextRoundWind]; // 虽然不太可能，但是还是保护一下吧
        nextRoundNumber = 1;
    }
    
    nextRound.roundWind = nextRoundWind;
    nextRound.roundNumeber = nextRoundNumber;
}

- (MMSCWind)nextWind:(MMSCWind)currentWind {
    MMSCWind result = currentWind + 1;
    
    if (result > MMSCWindNorth) {
        result = MMSCWindEast;
    }
    
    return result;
}

- (BOOL)isGameEnded {
    
    __block NSInteger topIndex = 0;
    __block BOOL result = NO;
    
    [self.players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMSCPlayer *player = (MMSCPlayer *)obj;
        
        if (player.score < 0) {
            result = YES;
            *stop = YES;
            return;
        }
        
        MMSCPlayer *topPlayer = (MMSCPlayer *)self.players[topIndex];
        if (player.score >= topPlayer.score) {
            topIndex = idx;
        }
    }];
    
    if (result) { // 有人被飞
        return YES;
    }
    
    MMSCRound *currentRound = [self currentRound];
    MMSCPlayer *topPlayer = (MMSCPlayer *)self.players[topIndex];
    BOOL isAllLast = currentRound.roundWind >= MMSCWindNorth && currentRound.roundNumeber >= 4;
    
    if (!isAllLast || (isAllLast && topPlayer.score < 30000)) { // 不是all last 或者 没人上三万分（可能要西入）
        return NO;
    }
    
    if ([currentRound.result changeOYA:self.oyaIndex]) {
        return YES;
    }
    
    return topIndex != self.oyaIndex;
}

- (void)richiAtPlayerIndex:(NSUInteger)playerIndex {
    MMSCRound *currentRound = [self currentRound];
    NSAssert(playerIndex < 4, @"这是什么鬼？！");
    
    MMSCPlayer *richiPlayer = (MMSCPlayer *)self.players[playerIndex];
    [currentRound richiAtPlayer:richiPlayer index:playerIndex];
}

- (MMSCPlayer *)getOYA {
    return (MMSCPlayer *)self.players[self.oyaIndex];
}

- (MMSCPlayer *)getPlayerAtIndex:(NSInteger)index {
    return (MMSCPlayer *)self.players[index];
}

- (MMSCRound *)currentRound {
    return [self.rounds lastObject];
}

@end
