//
//  MMSCTsuMoResult.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResult.h"

@interface MMSCTsuMoResult : MMSCRoundResult

// 自摸的玩家的索引
@property(nonatomic, assign) NSUInteger      winnerIndex;

// 番
@property(nonatomic, assign) NSInteger       fan;

// 符
@property(nonatomic, assign) NSInteger       fu;

@end
