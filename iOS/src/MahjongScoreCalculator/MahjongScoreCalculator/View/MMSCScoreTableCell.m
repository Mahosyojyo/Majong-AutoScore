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
    
    [self markRichiAtIndex:1];
    [self markRichiAtIndex:3];
    
    [self cancelRichiAtIndex:3];
}

- (void)createScoreChangeLabels {
    CGFloat interval = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat windLabelOffset = 0;
    for (int i = 0; i < 4; i++) {
        UILabel *finalScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset, 2, interval, self.frame.size.height)];
        finalScoreLabel.text = @"-1000";
        finalScoreLabel.font = [UIFont systemFontOfSize:15];
        finalScoreLabel.textAlignment = NSTextAlignmentCenter;
        finalScoreLabel.tag = (MMSCPlayerViewTag)(MMSCPlayerViewTagPlayer1 + i);
        [self.contentView addSubview:finalScoreLabel];
        
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

@end
