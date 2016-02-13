//
//  MMSCRichiController.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/13.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRichiController.h"
#import "MMSCGameManager.h"
#import "MMSCFontAndColorUtil.h"

@implementation MMSCRichiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
    self.view.backgroundColor = backgroundColor;
    
    CGFloat viewWidth = 270;
    CGFloat viewHeight = 240;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeigt = [UIScreen mainScreen].bounds.size.height;
    
    UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    dialogView.center = CGPointMake(screenWidth / 2.f, screenHeigt / 2.f);
    dialogView.backgroundColor = [UIColor whiteColor];
    dialogView.layer.cornerRadius = 20.f;
    [self.view addSubview:dialogView];
    
    CGFloat buttonHeight = 44;
    CGFloat seperatorX = dialogView.frame.origin.x;
    CGFloat seperatorWidth = dialogView.frame.size.width;
    CGFloat seperatorY = dialogView.frame.origin.y + viewHeight - buttonHeight;
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(seperatorX, seperatorY, seperatorWidth, 0.5f)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperator];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(seperatorX, seperatorY, seperatorWidth, buttonHeight)];
    [okButton setTitle:@"ok" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:okButton];
    
    NSArray *playerNames = [[MMSCGameManager instance] playerNames];
    NSArray *currentRichiPlayers = [[MMSCGameManager instance] currentRichiPlayers];
    CGFloat labelInterval = 40;
    CGFloat labelX = dialogView.frame.origin.x + 40;
    CGFloat switchX = dialogView.frame.origin.x + 150;
    CGFloat labelY = dialogView.frame.origin.y + 30;
    CGFloat swithcY = dialogView.frame.origin.y + 25;
    for (int i = 0; i < 4; i++) {
        UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY + labelInterval * i, 100, 20)];
        NSString *playerName = playerNames[i];
        playerLabel.backgroundColor = [UIColor clearColor];
        playerLabel.text = playerName;
        playerLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:playerLabel];
        
        UISwitch *richiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(switchX, swithcY + labelInterval * i, 40, 20)];
        richiSwitch.tag = MMSCPlayerViewTagPlayer1 + i;
        if ([currentRichiPlayers containsObject:@(i)]) {
            [richiSwitch setOn:YES];
        }
        [self.view addSubview:richiSwitch];
    }
}

- (void)okButtonClicked {
    NSMutableArray *richiPlayers = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        UISwitch *richiSwitch = [self.view viewWithTag:MMSCPlayerViewTagPlayer1 + i];
        if ([richiSwitch isOn]) {
            [richiPlayers addObject:@(i)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(richiPlayersSelected:)] ) {
        [self.delegate richiPlayersSelected:richiPlayers];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
