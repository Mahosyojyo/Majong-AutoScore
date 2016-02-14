//
//  MMSCDrawResult.h
//  MahjongScoreCalculator
//
//  流局
//
//  Created by fredfx on 16/1/3.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResult.h"

typedef NS_ENUM(NSInteger, MMSCDrawType) {
    MMSCDrawType_Normal,            // 普通流局
    MMSCDrawType_NineHonor,         // 九种九牌
    MMSCDrawType_FourWind,          // 四风连打
    MMSCDrawType_FourKan,           // 四杠流局
    MMSCDrawType_FourRichi,         // 四家立直
    MMSCDrawType_ThreeWin,          // 一炮三响
    MMSCDrawType_DrawMangan,        // 流局满贯
};

@interface MMSCDrawResult : MMSCRoundResult

// 流局的类型
@property(nonatomic, assign) MMSCDrawType type;

// 听牌的人
@property(nonatomic, strong) NSArray *tenpaiPlayerIndexes;

@end
