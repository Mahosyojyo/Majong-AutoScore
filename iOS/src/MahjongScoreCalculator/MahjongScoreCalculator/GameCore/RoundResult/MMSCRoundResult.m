//
//  MMSCRoundResult.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResult.h"

@implementation MMSCRoundResult

- (BOOL)isDraw {
    return NO;
}

- (BOOL)changeOYA:(NSUInteger)currentOYAIndex {
    return YES;
}

- (void)assignScoreWithPlayers:(NSArray *)players bonban:(NSInteger)bonban richiScore:(NSInteger)richiScore {
    NSAssert(NO, @"父类方法不该被直接调用");
}

- (void)recordScoreChangeAtIndex:(NSUInteger)index player:(MMSCPlayer *)player change:(NSInteger)change {
    NSInteger currentChange = [self.scoreChanges[index] integerValue];
    
    currentChange += change;
    
    self.scoreChanges[index] = @(currentChange);
    
    if (change > 0) {
        [player increaseScore:change];
    } else {
        [player decreaseScore:-1 * change];
    }
}

- (void)recordRichiChangeWithRichiPlayers:(NSArray *)playerIdxs {
    for (NSNumber *idxNum in playerIdxs) {
        NSUInteger idx = idxNum.unsignedIntegerValue;
        NSInteger currentChange = [self.scoreChanges[idx] integerValue];
        
        currentChange -= 1000;
        
        self.scoreChanges[idx] = @(currentChange);
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _scoreChanges = [NSMutableArray arrayWithArray:@[@0, @0, @0, @0]];
    }
    return self;
}

- (NSInteger)calculateScoreAtFan:(NSInteger)fan fu:(NSInteger)fu isOYAWin:(BOOL)isOYAWin {
    
    NSInteger score;
    
    if (fan >= 5 || (fan == 4 && fu >= 40) || (fan == 3 && fu >= 70)) {
        score = [self calculateManganAtFan:fan isOYAWin:isOYAWin];
    } else {
        score = [self calculateNormalAtFan:fan fu:fu isOYAWin:isOYAWin];
    }
    
    return score;
}

- (NSInteger)calculateManganAtFan:(NSInteger)fan isOYAWin:(BOOL)isOYAWin {
    
    NSAssert(fan >= 3, @"小于3番做什么满贯");
    
    NSInteger result;
    
    switch (false) {
        case 3:
        case 4:
        case 5:
            result = 8000;
            break;
        case 6:
        case 7:
            result = 12000;
            break;
        case 8:
        case 9:
        case 10:
            result = 16000;
            break;
        case 11:
        case 12:
            result = 24000;
            break;
        default:
            result = 32000;
            break;
    }
    
    if (isOYAWin) {
        result *= 1.5;
    }
    
    return result;
}

- (NSInteger)calculateNormalAtFan:(NSInteger)fan fu:(NSInteger)fu isOYAWin:(BOOL)isOYAWin {
    
    NSInteger basic = fu * (NSInteger)pow(fan + 2, 2);
    
    if (isOYAWin) {
        return [MMSCUtil increaseToHundredForScore:basic * 6];
    } else {
        return [MMSCUtil increaseToHundredForScore:basic * 4];
    }
}

@end
