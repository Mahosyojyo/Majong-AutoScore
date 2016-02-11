//
//  MMSCPlayer.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCPlayer.h"

@implementation MMSCPlayer

- (instancetype)initWithName:(NSString *)playerName {
    if (self = [self init]) {
        _name = playerName;
        _score = 25000;
    }
    return self;
}

- (void)increaseScore:(NSInteger)increment {
    self.score += increment;
}

- (void)decreaseScore:(NSInteger)decrement {
    self.score -= decrement;
}

- (BOOL)isOYA {
    return self.wind == MMSCWindEast;
}

@end
