//
//  MMSCRoundResulltController.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/14.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCRoundResulltController.h"
#import "MMSCGameManager.h"
#import "MMSCFontAndColorUtil.h"

#define MMSCPLAYERTITLETAG 0x111
#define MMSCOYATENPAISWITCHTAG 0x222
#define MMSCPYATENPAILABELTAG 0x333

@interface MMSCRoundResulltController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *playerPickerView;
@property (nonatomic, strong) UIPickerView *fanFuPickerView;

@property (nonatomic, strong) UIPickerView *winnerPickerView;
@property (nonatomic, strong) UIPickerView *fanfu2PickerView;

@property (nonatomic, strong) UIPickerView *drawTypePickerView;

@property (nonatomic, strong) NSArray *playerNames;
@property (nonatomic, strong) NSArray *drawTypes;

@end

@implementation MMSCRoundResulltController

- (instancetype)init {
    if (self = [super init]) {
        _playerNames = [[MMSCGameManager instance] playerNames];
        _drawTypes = @[@"普通流局", @"九种九牌", @"四风连打", @"四杠流局", @"四家立直", @"一炮三响", @"流局满贯"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
    self.view.backgroundColor = backgroundColor;
    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = [self heightForConfirmView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeigt = [UIScreen mainScreen].bounds.size.height;
    
    UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    dialogView.center = CGPointMake(screenWidth / 2.f, screenHeigt / 2.f);
    dialogView.backgroundColor = [UIColor whiteColor];
    dialogView.layer.cornerRadius = 20.f;
    [self.view addSubview:dialogView];
    
    CGFloat buttonHeight = 44;
    CGFloat horizontalSepX = dialogView.frame.origin.x;
    CGFloat seperatorWidth = dialogView.frame.size.width;
    CGFloat seperatorY = dialogView.frame.origin.y + viewHeight - buttonHeight;
    UIView *horizontalSep = [[UIView alloc] initWithFrame:CGRectMake(horizontalSepX, seperatorY, seperatorWidth, 0.5f)];
    horizontalSep.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horizontalSep];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(horizontalSepX, seperatorY, seperatorWidth / 2.f, buttonHeight)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    
    CGFloat verticalSepX = horizontalSepX + seperatorWidth / 2.f;
    UIView *verticalSep = [[UIView alloc] initWithFrame:CGRectMake(verticalSepX, seperatorY, 0.5f, buttonHeight)];
    verticalSep.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:verticalSep];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(verticalSepX, seperatorY, seperatorWidth / 2.f, buttonHeight)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat margin = 8;
    [self createConfirmViewWithFrame:CGRectMake(horizontalSepX + margin, dialogView.frame.origin.y + margin, seperatorWidth - 2 * margin, viewHeight - 2 * margin - buttonHeight)];
    
    [self.view addSubview:confirmButton];
    
    if (self.fanFuPickerView) {
        [self.fanFuPickerView selectRow:2 inComponent:1 animated:NO];
    }
    
    if (self.fanfu2PickerView) {
        [self.fanfu2PickerView selectRow:2 inComponent:1 animated:NO];
    }
}

- (CGFloat)heightForConfirmView {
    switch (self.type) {
        case MMSCRoundResultTypeTsumo:
            return 250;
        case MMSCRoundResultTypeRon:
            return 350;
        case MMSCRoundResultTypeDraw:
            return 480;
    }
}

- (void)createConfirmViewWithFrame:(CGRect)frame {
    switch (self.type) {
        case MMSCRoundResultTypeTsumo:
            [self createTsumoDetailViewWithFrame:frame];
            break;
        case MMSCRoundResultTypeRon:
            [self createRonDetailViewWithFrame:frame];
            break;
        case MMSCRoundResultTypeDraw:
            [self createDrawDetailViewWithFrame:frame];
            break;
    }
}

- (void)createTsumoDetailViewWithFrame:(CGRect)frame {
    [self createTitleView:@"自摸" frame:frame];
    
    CGFloat viewX = frame.origin.x;
    CGFloat viewY = frame.origin.y;
    
    CGFloat labelXInterval = 33;
    CGFloat labelYInterval = 80;
    CGFloat labelWidth = 50;
    CGFloat labelHeight = 25;
    UILabel *playerLabel = [self createLabelWithTitle:@"挂B:" frame:CGRectMake(viewX + labelXInterval, viewY + labelYInterval, labelWidth, labelHeight)];
    [self.view addSubview:playerLabel];
    
    CGFloat pickerWitdth = 200;
    CGFloat pickerHeight = 50;
    self.playerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(viewX + labelXInterval + labelWidth, viewY + labelYInterval - 12, pickerWitdth, pickerHeight)];
    self.playerPickerView.dataSource = self;
    self.playerPickerView.delegate = self;
    [self.view addSubview:self.playerPickerView];
    
    UILabel *fanfuLabel = [self createLabelWithTitle:@"番数:" frame:CGRectMake(viewX + labelXInterval, viewY + labelYInterval + 60, labelWidth, labelHeight)];
    [self.view addSubview:fanfuLabel];
    
    self.fanFuPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(viewX + labelXInterval + labelWidth, viewY + labelYInterval + 60 - 12, pickerWitdth, pickerHeight)];
    self.fanFuPickerView.dataSource = self;
    self.fanFuPickerView.delegate = self;
    [self.view addSubview:self.fanFuPickerView];
}

- (void)createRonDetailViewWithFrame:(CGRect)frame {
    [self createTitleView:@"放铳" frame:frame];
    
    CGFloat viewX = frame.origin.x;
    CGFloat viewY = frame.origin.y;
    
    CGFloat labelXOffset = viewX + 33;
    CGFloat labelYOffset = viewY + 80;
    CGFloat labelWidth = 50;
    CGFloat labelHeight = 25;
    
    UILabel *playerLabel = [self createLabelWithTitle:@"挂B:" frame:CGRectMake(labelXOffset, labelYOffset, labelWidth, labelHeight)];
    [self.view addSubview:playerLabel];
    
    CGFloat pickerWitdth = 200;
    CGFloat pickerHeight = 50;
    self.winnerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(labelXOffset + labelWidth, labelYOffset - 12, pickerWitdth, pickerHeight)];
    self.winnerPickerView.dataSource = self;
    self.winnerPickerView.delegate = self;
    [self.view addSubview:self.winnerPickerView];
    
    CGFloat viewInterval = 60;
    UILabel *loserLabel = [self createLabelWithTitle:@"渣渣:" frame:CGRectMake(labelXOffset, labelYOffset + viewInterval, labelWidth, labelHeight)];
    [self.view addSubview:loserLabel];
    
    self.playerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(labelXOffset + labelWidth, labelYOffset + viewInterval - 12, pickerWitdth, pickerHeight)];
    self.playerPickerView.dataSource = self;
    self.playerPickerView.delegate = self;
    [self.view addSubview:self.playerPickerView];
    
    UILabel *fanfuLabel = [self createLabelWithTitle:@"番数:" frame:CGRectMake(labelXOffset, labelYOffset + 2 * viewInterval, labelWidth, labelHeight)];
    [self.view addSubview:fanfuLabel];
    
    self.fanFuPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(labelXOffset + labelWidth, labelYOffset + 2 * viewInterval - 12, pickerWitdth, pickerHeight)];
    self.fanFuPickerView.dataSource = self;
    self.fanFuPickerView.delegate = self;
    [self.view addSubview:self.fanFuPickerView];
    
    self.fanfu2PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(labelXOffset + labelWidth, labelYOffset + 2 * viewInterval + 35, pickerWitdth, pickerHeight)];
    self.fanfu2PickerView.dataSource = self;
    self.fanfu2PickerView.delegate = self;
    self.fanfu2PickerView.hidden = YES;
    [self.view addSubview:self.fanfu2PickerView];
}

- (void)createDrawDetailViewWithFrame:(CGRect)frame {
    [self createTitleView:@"流局" frame:frame];
    
    CGFloat viewX = frame.origin.x;
    CGFloat viewY = frame.origin.y;
    
    CGFloat labelXOffset = viewX + 33;
    CGFloat labelYOffset = viewY + 80;
    CGFloat labelWidth = 50;
    CGFloat labelHeight = 25;
    
    UILabel *typeLabel = [self createLabelWithTitle:@"类型:" frame:CGRectMake(labelXOffset, labelYOffset, labelWidth, labelHeight)];
    [self.view addSubview:typeLabel];
    
    CGFloat pickerWitdth = 190;
    CGFloat pickerHeight = 50;
    self.drawTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(labelXOffset + labelWidth + 10, labelYOffset - 12, pickerWitdth, pickerHeight)];
    self.drawTypePickerView.dataSource = self;
    self.drawTypePickerView.delegate = self;
    [self.view addSubview:self.drawTypePickerView];
    
    UILabel *tenPaiLabel = [self createLabelWithTitle:@"听牌的挂B们:" frame:CGRectMake(labelXOffset, labelYOffset + 60, pickerWitdth, labelHeight)];
    tenPaiLabel.tag = MMSCPLAYERTITLETAG;
    [self.view addSubview:tenPaiLabel];
    
    CGFloat interval = 45;
    for (int i = 0; i < 4; i++) {
        NSString *playerName = self.playerNames[i];
        UILabel *playerLabel = [self createLabelWithTitle:playerName frame:CGRectMake(labelXOffset, labelYOffset + 105 + i * interval, 130, labelHeight)];
        playerLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:playerLabel];
        
        UISwitch *tenPaiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(labelXOffset + 140, labelYOffset + 101 + i * interval, 40, 20)];
        tenPaiSwitch.tag = MMSCPlayerViewTagPlayer1 + i;
        [self.view addSubview:tenPaiSwitch];
    }
    
    UILabel *oyaTenpaiLabel = [self createLabelWithTitle:@"庄家听牌:" frame:CGRectMake(labelXOffset, labelYOffset + 105 + 4 * interval, 130, labelHeight)];
    oyaTenpaiLabel.tag = MMSCPYATENPAILABELTAG;
    oyaTenpaiLabel.hidden = YES;
    [self.view addSubview:oyaTenpaiLabel];
    
    UISwitch *oyaTenPaiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(labelXOffset + 140, labelYOffset + 101 + 4 * interval, 40, 20)];
    oyaTenPaiSwitch.tag = MMSCOYATENPAISWITCHTAG;
    oyaTenPaiSwitch.hidden = YES;
    [self.view addSubview:oyaTenPaiSwitch];
}

- (void)createTitleView:(NSString *)title frame:(CGRect)frame {
    CGFloat titleLabelHeight = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, titleLabelHeight)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + titleLabelHeight, frame.size.width, 0.5f)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperator];
}

- (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    static UIFont *labelFont = nil;
    if (!labelFont) {
        labelFont = [UIFont systemFontOfSize:20];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = labelFont;
    
    return label;
}

#pragma mark --------------Button click---------------

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (self.type) {
        case MMSCRoundResultTypeTsumo:
            [self handleTsuMoResult];
            break;
        case MMSCRoundResultTypeRon:
            [self handleRonResult];
            break;
        case MMSCRoundResultTypeDraw:
            [self handleDrawResult];
            break;
    }
}

- (void)handleTsuMoResult {
    NSUInteger tsumoPlayerIndex = [self.playerPickerView selectedRowInComponent:0];
    NSInteger fan = [self getFanFromSelectedIndex:[self.fanFuPickerView selectedRowInComponent:0]];
    NSInteger fu = [self getFuFromSelectedIndex:[self.fanFuPickerView selectedRowInComponent:1]];
    
    if ([self.delegate respondsToSelector:@selector(tsumoResultSelected:fan:fu:)]) {
        [self.delegate tsumoResultSelected:tsumoPlayerIndex fan:fan fu:fu];
    }
}

- (void)handleRonResult {
    NSUInteger winner1Index = [self.winnerPickerView selectedRowInComponent:0];
    NSMutableArray *winnerArray = [NSMutableArray array];
    [winnerArray addObject:@(winner1Index)];
    
    NSUInteger loserIndex = [self.playerPickerView selectedRowInComponent:0];
    
    NSMutableArray *fansArray = [NSMutableArray array];
    NSMutableArray *fusArray = [NSMutableArray array];
    NSInteger fan1 = [self getFanFromSelectedIndex:[self.fanFuPickerView selectedRowInComponent:0]];
    NSInteger fu1 = [self getFuFromSelectedIndex:[self.fanFuPickerView selectedRowInComponent:1]];
    [fansArray addObject:@(fan1)];
    [fusArray addObject:@(fu1)];
    
    NSUInteger winner2Index = [self.winnerPickerView selectedRowInComponent:1];
    if (winner2Index > 0 && winner2Index != winner1Index + 1) { // 一炮双响
        [winnerArray addObject:@(winner2Index - 1)];
        
        NSInteger fan2 = [self getFanFromSelectedIndex:[self.fanfu2PickerView selectedRowInComponent:0]];
        NSInteger fu2 = [self getFuFromSelectedIndex:[self.fanfu2PickerView selectedRowInComponent:1]];
        [fansArray addObject:@(fan2)];
        [fusArray addObject:@(fu2)];
    }
    
    if ([winnerArray containsObject:@(loserIndex)]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(ronResultSelected:loser:fan:fu:)]) {
        [self.delegate ronResultSelected:[winnerArray copy] loser:loserIndex fan:[fansArray copy] fu:[fusArray copy]];
    }
}

- (void)handleDrawResult {
    NSUInteger drawType = [self.drawTypePickerView selectedRowInComponent:0];
    
    NSMutableArray *playerArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UISwitch *playerSwitch = [self.view viewWithTag:MMSCPlayerViewTagPlayer1 + i];
        if ([playerSwitch isOn]) {
            [playerArray addObject:@(i)];
        }
    }
    
    if ((drawType == 0 || drawType == 6) && playerArray.count <= 0) {
        return;
    }
    
    UISwitch *oyaTenpaiSwitch = [self.view viewWithTag:MMSCOYATENPAISWITCHTAG];
    BOOL oyaTenpai = [oyaTenpaiSwitch isOn];
    
    if ([self.delegate respondsToSelector:@selector(drawResultSelected:players:oyaTenpai:)]) {
        [self.delegate drawResultSelected:drawType players:[playerArray copy] oyaTenpai:oyaTenpai];
    }
}

- (NSInteger)getFanFromSelectedIndex:(NSUInteger)index {
    return index + 1;
}

- (NSInteger)getFuFromSelectedIndex:(NSUInteger)index {
    if (index == 0) {
        return 20;
    }
    
    if (index == 1) {
        return 25;
    }
    
    return (index + 1) * 10;
}

#pragma mark ------------PickerView------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.fanFuPickerView || pickerView == self.winnerPickerView || pickerView == self.fanfu2PickerView) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.fanFuPickerView || pickerView == self.fanfu2PickerView) {
        return [self fanfuPickerViewNumberOfRowsInComponent:component];
    }
    
    if (pickerView == self.winnerPickerView) {
        return [self winnerPickerViewNumberOfRowsInComponent:component];
    }
    
    if (pickerView == self.drawTypePickerView) {
        return self.drawTypes.count;
    }
    
    return self.playerNames.count;
}

- (NSInteger)fanfuPickerViewNumberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 13;
    } else {
        return 11;
    }
}

- (NSInteger)winnerPickerViewNumberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.playerNames.count;
    }
    
    return self.playerNames.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.playerPickerView) {
        return self.playerNames[row];
    }
    
    if (pickerView == self.winnerPickerView) {
        return [self winnerTitleForRow:row component:component];
    }
    
    if (pickerView == self.drawTypePickerView) {
        return self.drawTypes[row];
    }
    
    return [self fanfuTitleForRow:row component:component];
}

- (NSString *)fanfuTitleForRow:(NSInteger)row component:(NSInteger)component {
    
    if (component == 0) {
        if (row == 12) {
            return @"13+番";
        }
        
        return [NSString stringWithFormat:@"%zd番", row + 1];
    } else {
        if (row == 0)
            return @"20符";
        
        if (row == 1) {
            return @"25符";
        }
        
        return [NSString stringWithFormat:@"%zd0符", row + 1];
    }
}

- (NSString *)winnerTitleForRow:(NSInteger)row component:(NSInteger)component {
    if (component == 0) {
        return self.playerNames[row];
    }
    
    if (row == 0) {
        return @"Null";
    } else {
        return self.playerNames[row - 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.drawTypePickerView) {
        [self didDrawTypeChangeToRow:row];
        return;
    }

    if (pickerView != self.winnerPickerView) {
        return;
    }
    
    if (component == 1) {
        NSUInteger winner1Index = [self.winnerPickerView selectedRowInComponent:0];
        self.fanfu2PickerView.hidden = row == 0 || winner1Index == row - 1;
    } else {
        NSUInteger winner2Index = [self.winnerPickerView selectedRowInComponent:1];
        self.fanfu2PickerView.hidden = winner2Index == 0 || row == winner2Index - 1;
    }
}

- (void)didDrawTypeChangeToRow:(NSInteger)row {
    UILabel *playerLabel = [self.view viewWithTag:MMSCPLAYERTITLETAG];
    playerLabel.text = row != 6 ? @"听牌的挂B们:" : @"流满的挂B们:";
    
    UILabel *oyaTPLabel = [self.view viewWithTag:MMSCPYATENPAILABELTAG];
    oyaTPLabel.hidden = row != 6;
    
    UISwitch *oyaTenPaiSwitch = [self.view viewWithTag:MMSCOYATENPAISWITCHTAG];
    oyaTenPaiSwitch.hidden = row != 6;
}

@end
