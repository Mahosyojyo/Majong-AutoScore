//
//  MMSCPlayerNameAndSeatController.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/30.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCPlayerNameAndSeatController.h"
#import "MMSCFontAndColorUtil.h"
#import "MMSCRandomSeatTipsController.h"
#import "MMSCScoreTableController.h"
#import "MMSCGameManager.h"

@interface MMSCPlayerNameAndSeatController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *playerNames;

@end

@implementation MMSCPlayerNameAndSeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[MMSCFontAndColorUtil startPageBackgroundColor]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, screenWidth, 60)];
    [summaryLabel setFont:[MMSCFontAndColorUtil titleSummaryFont]];
    [summaryLabel setTextAlignment:NSTextAlignmentCenter];
    [summaryLabel setText:@"打麻将真TM开心"];
    
    [self.view addSubview:summaryLabel];
    
    CGFloat windLabelCenterX = 80;
    CGFloat windLabelCenterY = 165;
    CGFloat windLabelInterval = 80;
    CGFloat textFieldCenterX = windLabelCenterX + 126;
    [self generateLabelWind:@"東" center:CGPointMake(windLabelCenterX, windLabelCenterY)];
    UITextField *player1Field = [self generatePlayerNameFieldAtPoint:CGPointMake(textFieldCenterX, windLabelCenterY) tintText:@"天和"];
    player1Field.tag = MMSCPlayerViewTagPlayer1;
    [self.view addSubview:player1Field];
    
    windLabelCenterY += windLabelInterval;
    [self generateLabelWind:@"南" center:CGPointMake(windLabelCenterX, windLabelCenterY)];
    UITextField *player2Field = [self generatePlayerNameFieldAtPoint:CGPointMake(textFieldCenterX, windLabelCenterY) tintText:@"地和"];
    player2Field.tag = MMSCPlayerViewTagPlayer2;
    [self.view addSubview:player2Field];
    
    windLabelCenterY += windLabelInterval;
    [self generateLabelWind:@"西" center:CGPointMake(windLabelCenterX, windLabelCenterY)];
    UITextField *player3Field = [self generatePlayerNameFieldAtPoint:CGPointMake(textFieldCenterX, windLabelCenterY) tintText:@"人和"];
    player3Field.tag = MMSCPlayerViewTagPlayer3;
    [self.view addSubview:player3Field];
    
    windLabelCenterY += windLabelInterval;
    [self generateLabelWind:@"北" center:CGPointMake(windLabelCenterX, windLabelCenterY)];
    UITextField *player4Field = [self generatePlayerNameFieldAtPoint:CGPointMake(textFieldCenterX, windLabelCenterY) tintText:@"炸和"];
    player4Field.tag = MMSCPlayerViewTagPlayer4;
    [self.view addSubview:player4Field];
    
    UIButton * randomSeatButton = [self generateStartPageButtonAtCenter:CGPointMake(screenWidth / 2, windLabelCenterY + 80) text:@"随机座位"];
    [randomSeatButton addTarget:self action:@selector(waitForRandomSeat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomSeatButton];
    
    UIButton * startBattleButton = [self generateStartPageButtonAtCenter:CGPointMake(screenWidth / 2, randomSeatButton.center.y + 60) text:@"赌上性命开始对日"];
    [startBattleButton addTarget:self action:@selector(startBattle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBattleButton];
}

- (void)generateLabelWind:(NSString *)wind center:(CGPoint)center {
    UILabel *windLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [windLabel setFont:[MMSCFontAndColorUtil windBigLabelFont]];
    [windLabel setTextColor:[MMSCFontAndColorUtil startPageLabelFontColor]];
    [windLabel setText:wind];
    [windLabel sizeToFit];
    windLabel.center = center;
    
    CGFloat seperaterCenterY = center.y + windLabel.frame.size.height / 2;
    [self generateSeperateLineAtCenter:CGPointMake(self.view.frame.size.width / 2, seperaterCenterY)];
    
    [self.view addSubview:windLabel];
}

- (void)generateSeperateLineAtCenter:(CGPoint)center {
    UIView *seperater = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 0.5f)];
    seperater.backgroundColor = [UIColor lightGrayColor];
    seperater.center = center;
    [self.view addSubview:seperater];
}

- (UITextField *)generatePlayerNameFieldAtPoint:(CGPoint)center tintText:(NSString *)tintText {
    UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 195, 35)];
    [playerTextField setFont:[MMSCFontAndColorUtil startpageFont]];
    playerTextField.placeholder = tintText;
    playerTextField.textAlignment = NSTextAlignmentCenter;
    playerTextField.center = center;
    playerTextField.clearButtonMode = UITextFieldViewModeAlways;
    playerTextField.delegate = self;
    playerTextField.returnKeyType = UIReturnKeyDone;
    
    return playerTextField;
}

- (UIButton *)generateStartPageButtonAtCenter:(CGPoint)center text:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    UIImage *origImage = [UIImage imageNamed:@"resource/StartPage_ButtonBG.png"];
    UIImage *origClickImage = [UIImage imageNamed:@"resource/StartPage_ButtonBG_click.png"];
    
    CGFloat resizableWidth = origImage.size.width / 2.f;
    CGFloat resizableHeight = origImage.size.height / 2.f;
    
    UIImage *backgroundImage = [origImage resizableImageWithCapInsets:UIEdgeInsetsMake(resizableHeight, resizableWidth, resizableHeight, resizableWidth)];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UIImage *backgroundClickImage = [origClickImage resizableImageWithCapInsets:UIEdgeInsetsMake(resizableHeight, resizableWidth, resizableHeight, resizableWidth)];
    [button setBackgroundImage:backgroundClickImage forState:UIControlStateSelected];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[MMSCFontAndColorUtil startPageLabelFontColor] forState:UIControlStateNormal];
    [button sizeToFit];
    
    button.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * 40, button.frame.size.height + 5);
    button.center = center;
    
    return button;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.playerNames) {
        for (int i = 0; i < 4; i++) {
            MMSCPlayerViewTag tag = (MMSCPlayerViewTag)(MMSCPlayerViewTagPlayer1 + i);
            UITextField *playerField = [self.view viewWithTag:tag];
            NSString *playerName = (NSString *)self.playerNames[i];
            playerField.text = playerName;
        }
    }
}

#pragma mark ----------TextFieldDelegate----------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ----------button action--------------

- (void)waitForRandomSeat {
    MMSCRandomSeatTipsController *controller = [[MMSCRandomSeatTipsController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    self.playerNames = [[MMSCGameManager instance] randomSeatWithPlayers:[self getPlayerNames]];
}

- (void)startBattle:(id)sender {
    if (!self.playerNames) {
        [[MMSCGameManager instance] initGameWithPlayers:[self getPlayerNames]];
    }
    
    MMSCScoreTableController *scoreTableController = [[MMSCScoreTableController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scoreTableController];
    navController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (NSArray *)getPlayerNames {
    NSMutableArray *playerNames = [NSMutableArray array];
    for (MMSCPlayerViewTag tag = MMSCPlayerViewTagPlayer1; tag <= MMSCPlayerViewTagPlayer4; tag++) {
        UITextField *playerTextField = [self.view viewWithTag:tag];
        NSString *playerName = playerTextField.text.length > 0 ? playerTextField.text : playerTextField.placeholder;
        [playerNames addObject:playerName];
    }
    
    return [playerNames copy];
}

@end
