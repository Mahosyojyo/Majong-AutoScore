//
//  MMSCNormalWinResult.h
//  MahjongScoreCalculator
//
//  普通的点炮
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResult.h"

@interface MMSCNormalWinResult : MMSCRoundResult

// 胡了的人
@property(nonatomic, assign) NSUInteger winnerIndex;
// 番
@property(nonatomic, assign) NSInteger fan;
// 符
@property(nonatomic, assign) NSInteger fu;

// 点炮的
@property(nonatomic, assign) NSUInteger payerIndex;

@end
