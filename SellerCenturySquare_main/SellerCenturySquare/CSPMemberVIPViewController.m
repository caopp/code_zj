//
//  CSPMemberVIPViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMemberVIPViewController.h"
#import "CSPMemberLevelObject.h"
#import "CSPMemberOnlineServiceObject.h"
#import "CSPMemberOfflineObject.h"

#import "CSPGoodsNewCheckTableViewController.h"


@interface CSPMemberVIPViewController ()<CSPMemberOfflineObjectDelegate,CSPMemberOnlineObjectDelegate>

{
    UITableView *MemberlevelTableView_;
    UITableView *onlineServiceTableView_;
    UITableView *offlineServiceTableView_;
    CSPMemberLevelObject* memberLevel_;
    CSPMemberOnlineServiceObject *memberOnline_;
    CSPMemberOfflineObject *memberOffline_;
}

@property (nonatomic , strong) UITableView *MemberlevelTableView;
@property (nonatomic , strong) UITableView *onlineServiceTableView;
@property (nonatomic , strong) UITableView *offlineServiceTableView;
@property (nonatomic , strong) CSPMemberLevelObject* memberLevel;
@property (nonatomic , strong) CSPMemberOnlineServiceObject *memberOnline;
@property (nonatomic , strong) CSPMemberOfflineObject *memberOffline;

@property (weak, nonatomic) IBOutlet UIButton *levelJudgeButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *offlineServiceButton;

- (IBAction)levelJudgeButtonClicked:(id)sender;
- (IBAction)onlineServiceButtonClicked:(id)sender;
- (IBAction)offlineServiceButtonClicked:(id)sender;

@end


@implementation CSPMemberVIPViewController
@synthesize MemberlevelTableView = MemberlevelTableView_;
@synthesize onlineServiceTableView = onlineServiceTableView_;
@synthesize offlineServiceTableView = offlineServiceTableView_;
@synthesize memberLevel = memberLevel_;
@synthesize memberOnline = memberOnline_;
@synthesize memberOffline = memberOffline_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"等级规则";
    
    self.memberLevel = [[CSPMemberLevelObject alloc]init];
    self.memberOnline = [[CSPMemberOnlineServiceObject alloc]init];
    self.memberOffline = [[CSPMemberOfflineObject alloc]init];
    
    self.memberOnline.delegate = self;
    self.memberOffline.delegate = self;
    
    self.MemberlevelTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30) style:UITableViewStylePlain];
    self.MemberlevelTableView.delegate = self.memberLevel;
    self.MemberlevelTableView.dataSource = self.memberLevel;
    [self.view addSubview:self.MemberlevelTableView];
    self.MemberlevelTableView.hidden = NO;
    
    self.onlineServiceTableView = [[UITableView alloc]initWithFrame:self.MemberlevelTableView.frame style:UITableViewStylePlain];
    self.onlineServiceTableView.delegate = self.memberOnline;
    self.onlineServiceTableView.dataSource = self.memberOnline;
    [self.view addSubview:self.onlineServiceTableView];
    self.onlineServiceTableView.hidden = YES;
    
    self.offlineServiceTableView = [[UITableView alloc]initWithFrame:self.MemberlevelTableView.frame style:UITableViewStylePlain];
    self.offlineServiceTableView.delegate = self.memberOffline;
    self.offlineServiceTableView.dataSource = self.memberOffline;
    [self.view addSubview:self.offlineServiceTableView];
    self.offlineServiceTableView.hidden = YES;
    
    [self setExtraCellLineHidden:self.MemberlevelTableView];
    
    [self setExtraCellLineHidden:self.onlineServiceTableView];
    
    [self setExtraCellLineHidden:self.offlineServiceTableView];

    [self customBackBarButton];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.MemberlevelTableView.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (IBAction)levelJudgeButtonClicked:(id)sender {
    self.MemberlevelTableView.hidden = NO;
    self.onlineServiceTableView.hidden = YES;
    self.offlineServiceTableView.hidden = YES;
    self.levelJudgeButton.backgroundColor = [UIColor whiteColor];
    [self.levelJudgeButton setTitleColor:HEX_COLOR(0x000000FF) forState:UIControlStateNormal];
    self.onlineServiceButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.onlineServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.offlineServiceButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.offlineServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)onlineServiceButtonClicked:(id)sender {
    self.MemberlevelTableView.hidden = YES;
    self.onlineServiceTableView.hidden = NO;
    self.offlineServiceTableView.hidden = YES;
    self.levelJudgeButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.levelJudgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.onlineServiceButton.backgroundColor = [UIColor whiteColor];
    [self.onlineServiceButton setTitleColor:HEX_COLOR(0x000000FF) forState:UIControlStateNormal];
    self.offlineServiceButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.offlineServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)offlineServiceButtonClicked:(id)sender {
    self.MemberlevelTableView.hidden = YES;
    self.onlineServiceTableView.hidden = YES;
    self.offlineServiceTableView.hidden = NO;
    self.levelJudgeButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.levelJudgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.onlineServiceButton.backgroundColor = HEX_COLOR(0x333333FF);
    [self.onlineServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.offlineServiceButton.backgroundColor = [UIColor whiteColor];
    [self.offlineServiceButton setTitleColor:HEX_COLOR(0x000000FF) forState:UIControlStateNormal];
}

#pragma mark--
#pragma CSPMemberOnlineObjectDelegate
-(void)onLineDidSelectAtRow:(NSIndexPath *)indexPath{
    
    CSPGoodsNewCheckTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsNewCheckTableViewController"];
    
    nextVC.Service = indexPath.row + 1;
    
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

#pragma mark--
#pragma CSPMemberOfflineObjectDelegate
-(void)offLineDidSelectAtRow:(NSIndexPath *)indexPath{
    
    CSPGoodsNewCheckTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsNewCheckTableViewController"];
    
    nextVC.Service = indexPath.row + 1 + 6;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
