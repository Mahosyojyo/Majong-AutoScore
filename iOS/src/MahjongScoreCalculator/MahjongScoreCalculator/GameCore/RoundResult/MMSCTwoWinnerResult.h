//
//  MMSCTwoWinnerResult.h
//  MahjongScoreCalculator
//
//  一炮双响
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResult.h"

@interface MMSCTwoWinnerResult : MMSCRoundResult

// 第一个
@property(nonatomic, assign) NSInteger winner1Index;
@property(nonatomic, assign) NSInteger fanOfWiiner1;
@property(nonatomic, assign) NSInteger fuOfWinner1;

// 第二个
@property(nonatomic, assign) NSInteger winner2Index;
@property(nonatomic, assign) NSInteger fanOfWinner2;
@property(nonatomic, assign) NSInteger fuOfWinner2;

// 点炮的
@property(nonatomic, assign) NSInteger payerIndex;

@end
