//
//  MMSCTsuMoResult.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCTsuMoResult.h"
#import "MMSCUtil.h"

@implementation MMSCTsuMoResult

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    
    MMSCPlayer *winner = players[_winnerIndex];
    
    NSInteger basicScore = [self calculateScoreAtFan:_fan fu:_fu isOYAWin:[winner isOYA]];
    
    //立直棒
    [self recordScoreChangeAtIndex:_winnerIndex player:winner change:richiScore];
    
    if ([winner isOYA]) {
        // OYA自摸
        NSInteger payment = [MMSCUtil increaseToHundredForScore:(basicScore / 3) + (100 * bonban)];
        [self recordScoreChangeAtIndex:_winnerIndex player:winner change:payment * 3];
        
         [players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             MMSCPlayer *player = (MMSCPlayer *)obj;
             
             if (player != winner) {
                 [self recordScoreChangeAtIndex:idx player:player change:-1 * payment];
             }
         }];
    } else {
        // 炸庄
        NSInteger oyaPayment = [MMSCUtil increaseToHundredForScore:(basicScore / 2)] + (100 * bonban);
        NSInteger normalPayment = [MMSCUtil increaseToHundredForScore:(basicScore / 4)] + (100 * bonban);
        
        [self recordScoreChangeAtIndex:_winnerIndex player:winner change:oyaPayment + 2 * normalPayment];
        
        [players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MMSCPlayer *player = (MMSCPlayer *)obj;
            
            if (player != winner) {
                NSInteger change = -1 * ([player isOYA] ? oyaPayment : normalPayment);
                [self recordScoreChangeAtIndex:idx player:player change:change];
            }
        }];
    }
}

@end
