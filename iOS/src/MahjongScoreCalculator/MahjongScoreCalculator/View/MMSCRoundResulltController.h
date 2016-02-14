//
//  MMSCRoundResulltController.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/14.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMSCRoundResultType) {
    MMSCRoundResultTypeTsumo = 0x888,
    MMSCRoundResultTypeRon,
    MMSCRoundResultTypeDraw
};

@protocol MMSCRoundResultDelegate <NSObject>

- (void)tsumoResultSelected:(NSUInteger)playerIndex fan:(NSInteger)fan fu:(NSInteger)fu;

- (void)ronResultSelected:(NSArray *)winnerArray loser:(NSUInteger)loserIndex fan:(NSArray *)fan fu:(NSArray *)fu;

- (void)drawResultSelected:(NSInteger)drawType players:(NSArray *)players oyaTenpai:(BOOL)oyaTenpai;

@end

@interface MMSCRoundResulltController : UIViewController

@property (nonatomic, assign) MMSCRoundResultType type;

@property (nonatomic, weak) id<MMSCRoundResultDelegate> delegate;

@end
