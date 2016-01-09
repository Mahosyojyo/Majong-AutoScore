//
//  MMSCNormalWinResult.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCNormalWinResult.h"

@implementation MMSCNormalWinResult

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    
    MMSCPlayer *winner = players[_winnerIndex];
    MMSCPlayer *payer = players[_payerIndex];
    
    NSInteger basicScore = [self calculateScoreAtFan:_fan fu:_fu isOYAWin:[winner isOYA]];
    
    [self recordScoreChangeAtIndex:_winnerIndex player:winner change:basicScore + (300 * bonban) + richiScore];
    
    [self recordScoreChangeAtIndex:_payerIndex player:payer change:-1 * (basicScore + 300 * bonban)];
}

- (BOOL)changeOYA:(NSUInteger)currentOYAIndex {
    return currentOYAIndex != self.winnerIndex;
}

@end
