//
//  MMSCRandomSeatTipsController.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/1.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRandomSeatTipsController.h"
#import "MMSCFontAndColorUtil.h"

@interface MMSCRandomSeatTipsController ()

@property (nonatomic, strong) NSTimer *turnBackTimer;

@end

@implementation MMSCRandomSeatTipsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [MMSCFontAndColorUtil startPageBackgroundColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UILabel *tip1 = [[UILabel alloc] init];
    [tip1 setText:@"对日之前要抽风"];
    [tip1 setTextColor:[MMSCFontAndColorUtil startPageLabelFontColor]];
    [tip1 setFont:[UIFont systemFontOfSize:30 weight:4]];
    [tip1 sizeToFit];
    tip1.frame = CGRectMake(0, 0, screenWidth - 20, tip1.frame.size.height);
    tip1.center = CGPointMake(screenWidth / 2, screenHeight - 75);
    [self.view addSubview:tip1];
    
    UILabel *tip2 = [[UILabel alloc] init];
    [tip2 setText:@"随机座位中..."];
    [tip2 setTextColor:[UIColor colorWithRed:153/255.f green:156/255.f blue:168/255.f alpha:0.8]];
    [tip2 setFont:[UIFont systemFontOfSize:22]];
    [tip2 sizeToFit];
    tip2.frame = CGRectMake(0, 0, screenWidth - 20, tip2.frame.size.height);
    tip2.center = CGPointMake(screenWidth / 2, screenHeight - 40);
    [self.view addSubview:tip2];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!_turnBackTimer) {
        _turnBackTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(onTurnBackTimerTick) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_turnBackTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)onTurnBackTimerTick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_turnBackTimer) {
        [_turnBackTimer invalidate];
    }
}

@end
