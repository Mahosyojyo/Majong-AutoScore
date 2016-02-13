//
//  MMSCRound.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRound.h"
#import "MMSCPlayer.h"
#import "MMSCRoundResult.h"

@implementation MMSCRound

- (instancetype)init {
    if (self = [super init]) {
        _richiPlayerIndexes = [NSMutableArray array];
    }
    return self;
}

- (void)richiAtPlayer:(MMSCPlayer *)player index:(NSUInteger)index {
    self.richiScore += 1000;
    [self.richiPlayerIndexes addObject:@(index)];
    
    [player decreaseScore:1000];
}

- (void)cancelRichiAtPlayer:(MMSCPlayer *)player index:(NSUInteger)index {
    NSNumber *indexNum = @(index);
    if (![self.richiPlayerIndexes containsObject:indexNum]) {
        // 没有立直过的不处理
        return;
    }
    
    self.richiScore -= 1000;
    [self.richiPlayerIndexes removeObject:indexNum];
    
    [player increaseScore:1000];
}

- (void)endRoundWithPlayers:(NSArray *)players {
    if (!self.result) {
        NSAssert(NO, @"未设置本局结果");
    }
    
    [self.result recordRichiChangeWithRichiPlayers:self.richiPlayerIndexes];
    [self.result assignScoreWithPlayers:players bonban:self.bonbanNumber richiScore:self.richiScore];
}

- (NSString *)roundName {
    NSString *wind = [MMSCUtil convertWindEnumToCharacter:self.roundWind];
    NSString *rounNumber = [MMSCUtil convertToCharacterWithNumber:self.roundNumeber];
    
    if (self.bonbanNumber <= 0) {
        return [NSString stringWithFormat:@"%@%@局", wind, rounNumber];
    }
    
    return [NSString stringWithFormat:@"%@%@局 %zd本场", wind, rounNumber, self.bonbanNumber];
}

- (NSArray *)roundScoreChanges {
    if (self.result) { // 已经设置了结果并结算完了就直接返回
        return [self.result.scoreChanges copy];
    }
    
    NSMutableArray *scoreChanges = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0), @(0)]];
    for (NSNumber *index in self.richiPlayerIndexes) {
        scoreChanges[index.unsignedIntegerValue] = @(-1000);
    }
    
    return [scoreChanges copy];
}

@end
