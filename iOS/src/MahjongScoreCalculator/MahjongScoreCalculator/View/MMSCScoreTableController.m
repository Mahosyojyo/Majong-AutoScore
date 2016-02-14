//
//  MMSCScoreTableController.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/7.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCScoreTableController.h"
#import "MMSCScoreTableCell.h"
#import "MMSCFontAndColorUtil.h"
#import "MMSCGameManager.h"
#import "MMSCRichiController.h"
#import "MMSCRoundResulltController.h"

#define MMSCCURRENTROUNDLABELTAG    0x233
#define MMSCCURRENTOYALABELTAG      0x234
#define MMSCRICHICOUNTLABELTAG      0x235
#define MMSCWINDLABELTAGOFFSET      0x236

#define MMSCSECTIONHEIGHT           15
#define MMSCTABLEVIEWHEADERHEIGHT   64

static NSString * const kTableviewCellReuseIdentifier = @"mmsc_tableviewcell_identifier";

@interface MMSCScoreTableController () <MMSCRichiDelegate, MMSCRoundResultDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *headerview;
@property (nonatomic, strong) UIView *footerview;

@end

@implementation MMSCScoreTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"战场";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewYOffset = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat headerViewHeight = 90;
    self.headerview = [self generateHeaderViewAtFrame:CGRectMake(0, viewYOffset, screenWidth, headerViewHeight)];
    [self.view addSubview:self.headerview];
    
    CGFloat footerViewHeight = 40;
    self.footerview = [self generateFooterViewAtFrame:CGRectMake(0, screenHeight - footerViewHeight, screenWidth, footerViewHeight)];
    [self.view addSubview:self.footerview];
    
    CGFloat tableviewHeight = screenHeight - viewYOffset - headerViewHeight - footerViewHeight + MMSCTABLEVIEWHEADERHEIGHT;
    UILabel *tableViewHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, MMSCTABLEVIEWHEADERHEIGHT)];
    tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    tableViewHeaderView.textColor = [UIColor darkGrayColor];
    tableViewHeaderView.font = [UIFont systemFontOfSize:20];
    tableViewHeaderView.textAlignment = NSTextAlignmentCenter;
    tableViewHeaderView.text = @"武功再高，一番撂倒";
    tableViewHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView *headerContentView = [[UIView alloc] initWithFrame:tableViewHeaderView.bounds];
    [headerContentView addSubview:tableViewHeaderView];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, viewYOffset + headerViewHeight - MMSCTABLEVIEWHEADERHEIGHT, screenWidth, tableviewHeight)];
    self.tableview.tableHeaderView = headerContentView;
    self.tableview.allowsSelection = NO;
    [self.tableview registerClass:[MMSCScoreTableCell class] forCellReuseIdentifier:kTableviewCellReuseIdentifier];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    
    [self.view bringSubviewToFront:self.headerview];
    
    UIButton *rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 44)];
    rightItemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [rightItemButton setImage:[UIImage imageNamed:@"resource/more_icon.png"] forState:UIControlStateNormal];
    [rightItemButton setImage:[UIImage imageNamed:@"resource/more_icon_click.png"] forState:UIControlStateHighlighted];
    [rightItemButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 30)];
    leftItemButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [leftItemButton setImage:[UIImage imageNamed:@"resource/menu.png"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setScoreTablePlayerNames];
    [self setTableInfo];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    UIView *headerContentView = self.tableview.tableHeaderView.subviews[0];
    headerContentView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY + 64, 0));
}

- (UIView *)generateHeaderViewAtFrame:(CGRect)frame {
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIFont *textFont = [UIFont systemFontOfSize:18];
    CGFloat textLabelHeight = 40;
    CGFloat labelOffset = 3;
    CGFloat currentX = labelOffset;
    
    CGFloat tipLabelWidth = 41;
    UILabel *curTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, tipLabelWidth, textLabelHeight)];
    curTipLabel.text = @"当前:";
    curTipLabel.font = textFont;
    [headerView addSubview:curTipLabel];
    
    CGFloat roundLabelWidth = 114;
    currentX += tipLabelWidth + labelOffset;
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, roundLabelWidth, textLabelHeight)];
    roundLabel.tag = MMSCCURRENTROUNDLABELTAG;
    roundLabel.font = textFont;
    [headerView addSubview:roundLabel];
    
    currentX += roundLabelWidth + 5 * labelOffset;
    UILabel *oyaTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, tipLabelWidth, textLabelHeight)];
    oyaTipLabel.text = @"庄家:";
    oyaTipLabel.font = textFont;
    [headerView addSubview:oyaTipLabel];
    
    currentX += tipLabelWidth + labelOffset;
    UILabel *oyaLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, roundLabelWidth, textLabelHeight)];
    oyaLabel.tag = MMSCCURRENTOYALABELTAG;
    oyaLabel.font = textFont;
    [headerView addSubview:oyaLabel];
    
    currentX += roundLabelWidth + 2 * labelOffset;
    CGFloat richiIconWidth = 4;
    UIImageView *richiIconView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, 0, richiIconWidth, textLabelHeight)];
    richiIconView.image = [UIImage imageNamed:@"resource/richiIcon-vertical.png"];
    [headerView addSubview:richiIconView];
    
    currentX += richiIconWidth + labelOffset;
    CGFloat richiCountLabelWidth = 35;
    UILabel *richiCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, richiCountLabelWidth, textLabelHeight)];
    richiCountLabel.tag = MMSCRICHICOUNTLABELTAG;
    richiCountLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:richiCountLabel];
    
    CGFloat interval = frame.size.width / 4;
    CGFloat windLabelOffset = 0;
    CGFloat labelHeight = 33;
    CGFloat windLabelWidth = 25;
    CGFloat labelYOffset = frame.size.height - labelHeight - 2;
    for (int i = 0 ; i < 4; i++) {
        UILabel *windLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset, labelYOffset, windLabelWidth, labelHeight)];
        windLabel.layer.borderColor = [UIColor blackColor].CGColor;
        windLabel.layer.borderWidth = 3;
        windLabel.font = [UIFont systemFontOfSize:20];
        windLabel.textAlignment = NSTextAlignmentCenter;
        windLabel.tag = MMSCPlayerViewTagPlayer1 + MMSCWINDLABELTAGOFFSET + i;
        [headerView addSubview:windLabel];
        
        UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset + windLabelWidth, labelYOffset, interval - windLabelWidth, labelHeight)];
        playerLabel.font = [UIFont systemFontOfSize:15];
        playerLabel.textAlignment = NSTextAlignmentCenter;
        playerLabel.tag = (MMSCPlayerViewTag)(MMSCPlayerViewTagPlayer1 + i);
        [headerView addSubview:playerLabel];
        
        windLabelOffset += interval;
    }
    
    
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, textLabelHeight, frame.size.width, 0.5f)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:seperatorLine];
    
    UIView *seperatorLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 0.5f)];
    seperatorLine2.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:seperatorLine2];
    
    return headerView;
}

- (UIView *)generateFooterViewAtFrame:(CGRect)frame {
    UIView *footerView = [[UIView alloc] initWithFrame:frame];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 2, frame.size.width, 0.5f)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:seperatorLine];
    
    CGFloat interval = frame.size.width / 4;
    CGFloat windLabelOffset = 0;
    for (int i = 0; i < 4; i++) {
        UILabel *finalScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset, 2, interval, 20)];
        finalScoreLabel.font = [UIFont systemFontOfSize:15];
        finalScoreLabel.textAlignment = NSTextAlignmentCenter;
        finalScoreLabel.tag = MMSCPlayerViewTagPlayer1 + i;
        [footerView addSubview:finalScoreLabel];
        
        UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(windLabelOffset + interval, 5, 0.5f, 14)];
        sLine.backgroundColor = [UIColor lightGrayColor];
        [footerView addSubview:sLine];
        
        windLabelOffset += interval;
    }
    
    return footerView;
}

#pragma mark ------------navigationItemClickEvent---------
- (void)rightItemClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (![[MMSCGameManager instance] isGameEnded]) {
        UIAlertAction *richiAction = [UIAlertAction actionWithTitle:@"立直/取消立直" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self handleRichi];
        }];
        [alert addAction:richiAction];
        
        NSString *roundEndTitle = [NSString stringWithFormat:@"%@完了", [[MMSCGameManager instance] currentRoundName]];
        UIAlertAction *roundEndAction = [UIAlertAction actionWithTitle:roundEndTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self handleRoundEnd];
        }];
        [alert addAction:roundEndAction];
    }
    
    UIAlertAction *gameRestartAction = [UIAlertAction actionWithTitle:@"战局再开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleBattleRestart];
    }];
    [alert addAction:gameRestartAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleBattleRestart {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"战局再开" message:@"终止这个半庄吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"不好" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleRichi {
    MMSCRichiController *richiCtrl = [[MMSCRichiController alloc] init];
    self.navigationController.definesPresentationContext = YES;
    richiCtrl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    richiCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    richiCtrl.delegate = self;
    
    [self.navigationController presentViewController:richiCtrl animated:YES completion:nil];
}

- (void)handleRoundEnd {
    NSString *roundEndTitle = [NSString stringWithFormat:@"%@完了", [[MMSCGameManager instance] currentRoundName]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:roundEndTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *tsumoAction = [UIAlertAction actionWithTitle:@"自摸" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goRoundResultDetailWithType:MMSCRoundResultTypeTsumo];
    }];
    [alert addAction:tsumoAction];
    
    UIAlertAction *ronAction = [UIAlertAction actionWithTitle:@"放铳" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goRoundResultDetailWithType:MMSCRoundResultTypeRon];
    }];
    [alert addAction:ronAction];
    
    UIAlertAction *drawAction = [UIAlertAction actionWithTitle:@"流局" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goRoundResultDetailWithType:MMSCRoundResultTypeDraw];
    }];
    [alert addAction:drawAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)goRoundResultDetailWithType:(MMSCRoundResultType)type {
    MMSCRoundResulltController *roundEndCtrl = [[MMSCRoundResulltController alloc] init];
    self.navigationController.definesPresentationContext = YES;
    roundEndCtrl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    roundEndCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    roundEndCtrl.delegate = self;
    roundEndCtrl.type = type;
    
    [self.navigationController presentViewController:roundEndCtrl animated:YES completion:nil];
}

- (void)leftItemClicked:(id)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[MMSCGameManager instance] roundCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMSCScoreTableCell *cell = (MMSCScoreTableCell *)[tableView dequeueReusableCellWithIdentifier:kTableviewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell setScoreChange:[[MMSCGameManager instance] roundScoreChangesAtIndex:indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MMSCSECTIONHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString * kMMSCSectionHeaderIdentifier = @"MMSCSectionHeaderIdentifier";
    static NSInteger kHeaderLabelTag = 0x888;
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMMSCSectionHeaderIdentifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kMMSCSectionHeaderIdentifier];
        UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, MMSCSECTIONHEIGHT)];
        sectionHeaderLabel.backgroundColor = [UIColor colorWithRed:236/255.f green:219/255.f blue:212/255.f alpha:0.5];
        sectionHeaderLabel.font = [UIFont systemFontOfSize:10];
        sectionHeaderLabel.textColor = [UIColor darkGrayColor];
        sectionHeaderLabel.tag = kHeaderLabelTag;
        [headerView addSubview:sectionHeaderLabel];
    }
    
    UILabel *sectionHeaderLabel = [headerView viewWithTag:kHeaderLabelTag];
    sectionHeaderLabel.text = [[MMSCGameManager instance] roundNameAtIndex:section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 28;
}

#pragma mark ----------------设置界面-----------------

// 当前局名，庄家
- (void)setCurrentRoundInfo {
    // 局名
    UILabel *currentRoundLabel = [self.headerview viewWithTag:MMSCCURRENTROUNDLABELTAG];
    currentRoundLabel.text = [[MMSCGameManager instance] currentRoundName];
    
    // 庄家名
    UILabel *currentOYALabel = [self. headerview viewWithTag:MMSCCURRENTOYALABELTAG];
    currentOYALabel.text = [[MMSCGameManager instance] currentOYAName];
}

// 设置Header里的玩家名字
- (void)setScoreTablePlayerNames {
    NSArray *playerNames = [[MMSCGameManager instance] playerNames];
    for (int i = 0; i < 4; i++) {
        UILabel *playerLabel = [self.headerview viewWithTag:(MMSCPlayerViewTagPlayer1 + i)];
        NSString *playerName = playerNames[i];
        playerLabel.text = playerName;
    }
}

// 设置风位
- (void)setWindLabel {
    NSArray *playerWinds = [[MMSCGameManager instance] currentPlayerWinds];
    NSUInteger oyaIndex = [[MMSCGameManager instance] currentOYAIndex];
    
    for (int i = 0; i < 4; i++) {
        UILabel *windLabel = [self.headerview viewWithTag:(MMSCPlayerViewTagPlayer1 + MMSCWINDLABELTAGOFFSET + i)];
        NSString *playerWind = playerWinds[i];
        windLabel.text = playerWind;
        
        if (oyaIndex == i) {
            windLabel.layer.borderColor = [UIColor redColor].CGColor;
            windLabel.textColor = [UIColor redColor];
        } else {
            windLabel.layer.borderColor = [UIColor blackColor].CGColor;
            windLabel.textColor = [UIColor blackColor];
        }
    }
}

// 设置玩家分数
- (void)setPlayerScore {
    NSArray *playerScores = [[MMSCGameManager instance] currentPlayerScores];
    for (int i = 0; i < 4; i++) {
        UILabel *scoreLabel = [self.footerview viewWithTag:MMSCPlayerViewTagPlayer1 + i];
        NSString *playerScore = [NSString stringWithFormat:@"%zd", [playerScores[i] integerValue]];
        scoreLabel.text = playerScore;
    }
}

// 设置场上立直棒
- (void)setRichiCount {
    NSInteger currentRichiCount = [[MMSCGameManager instance] currentRichiCount];
    
    UILabel *richiCountLabel = [self.headerview viewWithTag:MMSCRICHICOUNTLABELTAG];
    richiCountLabel.text = [NSString stringWithFormat:@"X%zd", currentRichiCount];
}

- (void)setTableInfo {
    [self setCurrentRoundInfo];
    [self setWindLabel];
    [self setPlayerScore];
    [self setRichiCount];
}

#pragma mark -----------------Richi RoundResult delegate--------------

- (void)richiPlayersSelected:(NSArray *)richiPlayerIndexes {
    
    MMSCScoreTableCell *lastCell = [self lastCell];
    if (!lastCell) {
        return;
    }
    
    [lastCell markRichiAtIndexes:richiPlayerIndexes currentRichiPlayers:[[MMSCGameManager instance] currentRichiPlayers]];
    
    // 立直，设置分数
    [[MMSCGameManager instance] richiAtPlayers:richiPlayerIndexes];
    [lastCell setScoreChange:[[MMSCGameManager instance] currentRoundScoreChanges]];
    
    [self setPlayerScore];
    [self setRichiCount];
}

#pragma mark -----------------RoundEndDelegate----------------------

- (void)tsumoResultSelected:(NSUInteger)playerIndex fan:(NSInteger)fan fu:(NSInteger)fu {
    [[MMSCGameManager instance] tsumoAtPlayer:playerIndex fan:fan fu:fu];
    [self refreshTable];
    [self checkGameEnded];
}

- (void)ronResultSelected:(NSArray *)winnerArray loser:(NSUInteger)loserIndex fan:(NSArray *)fan fu:(NSArray *)fu {
    [[MMSCGameManager instance] ronAtPlayers:winnerArray loser:loserIndex fan:fan fu:fu];
    [self refreshTable];
    [self checkGameEnded];
}

- (void)drawResultSelected:(NSInteger)drawType players:(NSArray *)players oyaTenpai:(BOOL)oyaTenpai {
    [[MMSCGameManager instance] drawForType:drawType players:players oyaTenpai:oyaTenpai];
    [self refreshTable];
    [self checkGameEnded];
}

- (void)refreshTable {
    MMSCScoreTableCell *lastCell = [self lastCell];
    if (!lastCell) {
        return;
    }
    
    [lastCell clearRichiMark]; // 一局结束了把立直标志清掉
    [self.tableview reloadData];
    [self setTableInfo];
}

- (MMSCScoreTableCell *)lastCell {
    NSInteger lastSectionIndex = [self.tableview numberOfSections] - 1;
    if (lastSectionIndex == -1) {
        return nil;
    }
    NSInteger lastCellIndex = [self.tableview numberOfRowsInSection:lastSectionIndex] - 1;
    if (lastCellIndex == -1) {
        return nil;
    }
    
    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForRow:lastCellIndex inSection:lastSectionIndex];
    MMSCScoreTableCell *lastCell = (MMSCScoreTableCell *)[self.tableview cellForRowAtIndexPath:lastCellIndexPath];
    
    return lastCell;
}

- (void)checkGameEnded {
    BOOL gameEnded = [[MMSCGameManager instance] isGameEnded];
    
    if (gameEnded) {
        NSString *message = [NSString stringWithFormat:@"对局结束，大Top是%@", [[MMSCGameManager instance] sortedPlayers][0]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"半庄结束" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

@end
