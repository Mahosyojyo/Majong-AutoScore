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

#define MMSCCURRENTROUNDLABELTAG    0x2333
#define MMSCCURRENTOYALABELTAG      0x23333
#define MMSCRICHICOUNTLABELTAG      0x233333

#define MMSCSECTIONHEIGHT           15
#define MMSCTABLEVIEWHEADERHEIGHT   64

static NSString * const kTableviewCellReuseIdentifier = @"mmsc_tableviewcell_identifier";

@interface MMSCScoreTableController ()

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
    
    CGFloat roundLabelWidth = 110;
    currentX += tipLabelWidth + labelOffset;
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, roundLabelWidth, textLabelHeight)];
    roundLabel.tag = MMSCCURRENTROUNDLABELTAG;
    roundLabel.text = @"东三局10本场";
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
    oyaLabel.text = @"冯大水大冯";
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
    richiCountLabel.text = @"X10";
    richiCountLabel.font = textFont;
    [headerView addSubview:richiCountLabel];
    
    NSArray *windNames = @[@"東", @"南", @"西", @"北"];
    CGFloat interval = frame.size.width / 4;
    CGFloat windLabelOffset = 0;
    CGFloat labelHeight = 33;
    CGFloat windLabelWidth = 25;
    CGFloat labelYOffset = frame.size.height - labelHeight - 2;
    for (int i = 0 ; i < 4; i++) {
        UILabel *windLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset, labelYOffset, windLabelWidth, labelHeight)];
        windLabel.text = windNames[i];
        windLabel.layer.borderColor = [UIColor blackColor].CGColor;
        windLabel.layer.borderWidth = 3;
        windLabel.font = [UIFont systemFontOfSize:20];
        windLabel.textAlignment = NSTextAlignmentCenter;
        windLabel.tag = (MMSCPlayerViewTag)(MMSCPlayerViewTagPlayer1 + i);
        [headerView addSubview:windLabel];
        
        UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(windLabelOffset + windLabelWidth, labelYOffset, interval - windLabelWidth, labelHeight)];
        playerLabel.text = @"冯大水大冯";
        playerLabel.font = [UIFont systemFontOfSize:15];
        playerLabel.textAlignment = NSTextAlignmentCenter;
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
        finalScoreLabel.text = @"25000";
        finalScoreLabel.font = [UIFont systemFontOfSize:15];
        finalScoreLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UIAlertAction *richiAction = [UIAlertAction actionWithTitle:@"立直/取消立直" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:richiAction];
    
    UIAlertAction *roundEndAction = [UIAlertAction actionWithTitle:@"东一局10本场完了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:roundEndAction];
    
    UIAlertAction *gameRestartAction = [UIAlertAction actionWithTitle:@"战局再开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:gameRestartAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
    [cell setScoreChange:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MMSCSECTIONHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, MMSCSECTIONHEIGHT)];
    sectionHeaderLabel.backgroundColor = [UIColor colorWithRed:236/255.f green:219/255.f blue:212/255.f alpha:0.5];
    sectionHeaderLabel.font = [UIFont systemFontOfSize:10];
    sectionHeaderLabel.textColor = [UIColor darkGrayColor];
    sectionHeaderLabel.text = [NSString stringWithFormat:@"东一局%zd本场", section];
    
    return sectionHeaderLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 28;
}

@end
