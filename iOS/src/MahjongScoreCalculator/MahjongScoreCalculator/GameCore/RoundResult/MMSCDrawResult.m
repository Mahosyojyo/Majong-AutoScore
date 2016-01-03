//
//  MMSCDrawResult.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCDrawResult.h"
#import "MMSCUtil.h"

@implementation MMSCDrawResult

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    
    if (_type != MMSCDrawType_Normal) {
        return;
    }
    
    if (_tenpaiPlayerIndexes.count == PLAYER_NUMBER || _tenpaiPlayerIndexes.count == 0) {
        return;
    }
    
    NSInteger incresement = 3000 / _tenpaiPlayerIndexes.count;
    NSInteger decresement = 3000 / (PLAYER_NUMBER - _tenpaiPlayerIndexes.count);
    
    [players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMSCPlayer *player = (MMSCPlayer *)obj;
        
        if ([_tenpaiPlayerIndexes containsIndex:idx]) {
            [self recordScoreChangeAtIndex:idx player:player change:incresement];
        } else {
            [self recordScoreChangeAtIndex:idx player:player change:-1 * decresement];
        }
    }];
}

@end
