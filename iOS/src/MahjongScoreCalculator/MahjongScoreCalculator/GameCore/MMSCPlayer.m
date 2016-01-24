//
//  MMSCPlayer.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCPlayer.h"

@implementation MMSCPlayer

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
