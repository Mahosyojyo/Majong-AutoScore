//
//  MMSCDrawManganResult.m
//  MahjongScoreCalculator
//
//  流局满贯
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCDrawManganResult.h"

@implementation MMSCDrawManganResult

- (instancetype)init {
    if (self = [super init]) {
        self.type = MMSCDrawType_DrawMangan;
    }
    
    return self;
}

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    
    
    for (int i = 0; i < _manganPlayerIndexes.count; i++) {
        
        NSInteger playerIndex = [_manganPlayerIndexes[i] integerValue];
        MMSCPlayer *winner = (MMSCPlayer *)players[playerIndex];
        
        if ([winner isOYA]) {
            [self recordScoreChangeAtIndex:playerIndex player:winner change:12000];
            [players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MMSCPlayer *player = (MMSCPlayer *)obj;
                if (player != winner) {
                    [self recordScoreChangeAtIndex:idx player:player change:-4000];
                }
            }];
        } else {
            [self recordScoreChangeAtIndex:playerIndex player:winner change:8000];
            [players enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MMSCPlayer *player = (MMSCPlayer *)obj;
                if (player != winner) {
                    NSInteger decresement = [player isOYA] ? 4000 : 2000;
                    [self recordScoreChangeAtIndex:idx player:player change:-1 * decresement];
                }
            }];
        }
    }
}

@end
