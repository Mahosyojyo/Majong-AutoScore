//
//  MMSCRichiController.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/13.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMSCRichiDelegate <NSObject>

- (void)richiPlayersSelected:(NSArray *)richiPlayerIndexes;

@end

@interface MMSCRichiController : UIViewController

@property (nonatomic, weak) id <MMSCRichiDelegate> delegate;

@end
