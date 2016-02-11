//
//  MMSCScoreTableCell.h
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/10.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSCScoreTableCell : UITableViewCell

- (void)setScoreChange:(NSArray *)scoreChanges;

- (void)markRichiAtIndex:(NSUInteger)playerIndex;

- (void)cancelRichiAtIndex:(NSInteger)playerIndex;

@end
