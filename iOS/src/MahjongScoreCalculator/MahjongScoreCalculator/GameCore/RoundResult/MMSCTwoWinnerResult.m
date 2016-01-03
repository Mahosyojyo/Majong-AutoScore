//
//  MMSCTwoWinnerResult.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCTwoWinnerResult.h"

@implementation MMSCTwoWinnerResult

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    
    // 立直棒和本场分数
    NSUInteger extraScoreIndex = [self getBonbanAndRichiScorePlayerIndex];
    MMSCPlayer *extraScorePlayer = players[extraScoreIndex];
    
    [self recordScoreChangeAtIndex:extraScoreIndex player:extraScorePlayer change:richiScore + (300 * bonban)];
    
    MMSCPlayer *winner1 = players[_winner1Index];
    MMSCPlayer *winner2 = players[_winner2Index];
    MMSCPlayer *payer = players[_payerIndex];
    
    NSInteger basicScore1 = [self calculateScoreAtFan:_fanOfWiiner1 fu:_fuOfWinner1 isOYAWin:[winner1 isOYA]];
    [self recordScoreChangeAtIndex:_winner1Index player:winner1 change:basicScore1];
    
    NSInteger basicScore2 = [self calculateScoreAtFan:_fanOfWinner2 fu:_fuOfWinner2 isOYAWin:[winner2 isOYA]];
    [self recordScoreChangeAtIndex:_winner2Index player:winner2 change:basicScore2];
    
    NSInteger payment = basicScore1 + basicScore2 + 300 * bonban;
    [self recordScoreChangeAtIndex:_payerIndex player:payer change:-1 * payment];
}

// 计算拿点棒和本场分数的人:点炮者的下家->对家->上家
- (NSUInteger)getBonbanAndRichiScorePlayerIndex {
    
    NSInteger distance1 = _winner1Index - _payerIndex;
    NSInteger distance2 = _winner2Index - _payerIndex;
    
    if (distance1 * distance2 < 0) { // 一个是点炮的下家，另一个是上家
        return distance1 > 0 ? _winner1Index : _winner2Index;
    }
    
    return distance1 < distance2 ? _winner1Index : _winner2Index; //总之选具体点炮者比较近的
}


@end
