//
//  MMSCScoreTableCell.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/10.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCScoreTableCell.h"
#import "MMSCScoreTableController.h"
#import "MMSCFontAndColorUtil.h"

#define MMSCRICHIMASKVIEWTAGOFFSET  0x233

@implementation MMSCScoreTableCell

- (void)setScoreChange:(NSArray *)scoreChanges {
    if ([self shouldCreateNewLabel]) {
        [self createScoreChangeLabels];
    }
    
    for (int i = 0; i < 4; i++) {
        UILabel *scoreLabel = [self.contentView viewWithTag:MMSCPlayerViewTagPlayer1 + i];
        NSInteger scoreChange = [scoreChanges[i] integerValue];
        scoreLabel.text = [NSString stringWithFormat:@"%zd", scoreChange];
    }
}

- (void)createScoreChangeLabels {
    CGFloat interval = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat windLabelOffset = 0;
    for (int i = 0; i < 4; i++) {
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset, 2, interval, self.frame.size.height)];
        scoreLabel.font = [UIFont systemFontOfSize:15];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.tag = (MMSCPlayerViewTag)(MMSCPlayerViewTagPlayer1 + i);
        [self.contentView addSubview:scoreLabel];
        
        UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(windLabelOffset + interval, 5, 0.5f, self.frame.size.height - 6)];
        sLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:sLine];
        
        windLabelOffset += interval;
    }
}

- (BOOL)shouldCreateNewLabel {
    UIView *playerView = [self.contentView viewWithTag:MMSCPlayerViewTagPlayer1];
    return !playerView;
}

- (void)markRichiAtIndexes:(NSArray *)playerIndexes currentRichiPlayers:(NSArray *)currentRichiPlayerIndexes {
    NSMutableArray *currentRichiPlayers = [currentRichiPlayerIndexes mutableCopy];
    for (NSNumber *playerIndex in playerIndexes) {
        if ([currentRichiPlayers containsObject:playerIndex]) { // 之前已经立直过了
            [currentRichiPlayers removeObject:playerIndex];
        }
        
        [self markRichiAtIndex:playerIndex.unsignedIntegerValue];
    }
    
    if (currentRichiPlayers.count > 0) { // 有取消的情况发生
        for (NSNumber *playerIndex in currentRichiPlayers) {
            [self cancelRichiAtIndex:playerIndex.unsignedIntegerValue];
        }
    }
}

- (void)markRichiAtIndex:(NSUInteger)playerIndex {
    NSAssert(playerIndex < 4, @"playerIndex out of bound");
    
    MMSCPlayerViewTag labelTag = MMSCPlayerViewTagPlayer1 + playerIndex;
    UILabel *playerLabel = [self.contentView viewWithTag:labelTag];
    UIImageView *richiMaskView = [self.contentView viewWithTag:labelTag + MMSCRICHIMASKVIEWTAGOFFSET];
    
    if (!richiMaskView) {
        richiMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerLabel.frame.size.width - 5, self.frame.size.height - 14)];
        richiMaskView.backgroundColor = [UIColor clearColor];
        richiMaskView.image = [UIImage imageNamed:@"resource/richiIcon-horizontal.png"];
        richiMaskView.alpha = 0.6f;
        richiMaskView.tag = labelTag + MMSCRICHIMASKVIEWTAGOFFSET;
        [self.contentView addSubview:richiMaskView];
    }
    
    richiMaskView.hidden = NO;
    richiMaskView.center = playerLabel.center;
    [self.contentView bringSubviewToFront:playerLabel];
}

- (void)cancelRichiAtIndex:(NSInteger)playerIndex {
    NSAssert(playerIndex < 4, @"playerIndex out of bound");
    
    UIImageView *richiMaskView = [self.contentView viewWithTag:MMSCPlayerViewTagPlayer1 + playerIndex + MMSCRICHIMASKVIEWTAGOFFSET];
    
    richiMaskView.hidden = YES;
}

- (void)clearRichiMark {
    for (int i = 0; i < 4; i++) {
        [self cancelRichiAtIndex:i];
    }
}

@end
