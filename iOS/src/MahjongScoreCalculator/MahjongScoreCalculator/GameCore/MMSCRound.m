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

- (void)richiAtPlayer:(MMSCPlayer *)player index:(NSUInteger)index {
    self.richiScore += 1000;
    [self.richiPlayerIndexes addObject:@(index)];
    
    [player decreaseScore:1000];
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
    
    return [NSString stringWithFormat:@"%@%@局 %zd本场", wind, rounNumber, self.bonbanNumber];
}

@end
