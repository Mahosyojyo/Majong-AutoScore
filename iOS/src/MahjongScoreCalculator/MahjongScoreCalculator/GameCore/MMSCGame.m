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
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.players];
    
    for (int i = 0; i < 4; i++) {
        int index = rand() % (4 - i);
        
        [temp exchangeObjectAtIndex:i withObjectAtIndex:i + index];
    }
    
    self.players = [NSArray arrayWithArray:temp];
    
    [self gameInit];
}

- (void)gameInit {
    
    self.oyaIndex = 0;
    
    //分配下风位
    for (int i = 0; i < 4; i++) {
        MMSCPlayer *player = (MMSCPlayer *)self.players[i];
        player.wind = (MMSCWind)(MMSCWindEast + i);
    }
    
    self.rounds = [NSMutableArray array];
    MMSCRound *firstRound = [MMSCRound new];
    firstRound.roundWind = MMSCWindEast;
    firstRound.roundNumeber = 1;
    
    [self.rounds addObject:firstRound];
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
    currentRound.oyaChanged = changeOYA;
    
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
        player.wind = [self previousWind:player.wind];
    }
}

- (void)setPreviousOYAAndPlayersWind {
    self.oyaIndex--;
    
    if (self.oyaIndex < 0) {
        self.oyaIndex = 3;
    }
    
    for (MMSCPlayer *player in self.players) {
        player.wind = [self nextWind:player.wind];
    }
}

- (void)setNextWindAndRoundNumber:(MMSCRound *)nextRound currentRound:(MMSCRound *)currentRound {
    NSInteger nextRoundNumber = currentRound.roundNumeber + 1;
    MMSCWind nextRoundWind = currentRound.roundWind;
    
    if (nextRoundNumber > 4) {
        nextRoundWind = [self nextWind:nextRoundWind];
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

- (MMSCWind)previousWind:(MMSCWind)currentWind {
    MMSCWind result = currentWind - 1;
    
    if (result < 0) {
        result = MMSCWindNorth;
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
    BOOL isAllLast = (currentRound.roundWind == MMSCWindSouth && currentRound.roundNumeber >= 4) || currentRound.roundWind > MMSCWindSouth;
    
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

- (void)cancelRichiAtPlayerIndex:(NSUInteger)playerIndex {
    MMSCRound *currentRound = [self currentRound];
    NSAssert(playerIndex < 4, @"这是什么鬼？！");
    
    MMSCPlayer *richiPlayer = (MMSCPlayer *)self.players[playerIndex];
    [currentRound cancelRichiAtPlayer:richiPlayer index:playerIndex];
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

- (NSArray *)playerRank {
    NSArray *sortedPlayers = [self.players sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MMSCPlayer *player1 = (MMSCPlayer *)obj1;
        MMSCPlayer *player2 = (MMSCPlayer *)obj2;
        
        if (player1.score == player2.score) {
            return NSOrderedSame;
        }
        
        if (player1.score < player2.score) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    return sortedPlayers;
}

- (void)cancelLastRound {
    if (![self isGameEnded]) {
        // 当前未完的一局
        MMSCRound *currentRound = [self currentRound];
        [self.rounds removeObject:currentRound];
    }
    
    // 真正要取消的一局
    MMSCRound *roundToCancel = [self currentRound];
    [self.rounds removeObject:roundToCancel];
    
    // 恢复分数
    NSArray *scoreChanges = [roundToCancel roundScoreChanges];
    for (int i = 0; i < 4; i++) {
        NSInteger scoreChange = [scoreChanges[i] integerValue];
        MMSCPlayer *player = self.players[i];
        [player decreaseScore:scoreChange];
    }
    
    // 恢复风位
    BOOL changeOYA = roundToCancel.oyaChanged;
    if (changeOYA) {
        [self setPreviousOYAAndPlayersWind];
    }
    MMSCRound *currentRound = [self currentRound];
    if (!currentRound) {
        [self gameInit];
        return;
    }
    if (currentRound.oyaChanged) { // 先恢复到结算之前的状态
        [self setPreviousOYAAndPlayersWind];
    }
        
    [self setNextRound:currentRound]; // 重新结算下风位
}

@end
