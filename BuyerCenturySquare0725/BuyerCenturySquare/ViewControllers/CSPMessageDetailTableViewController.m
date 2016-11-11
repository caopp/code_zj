//
//  CSPMessageDetailTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMessageDetailTableViewController.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "DeviceDBHelper.h"
#import "UIImageView+WebCache.h"
#import "ConversationWindowViewController.h"

#define ReceiveMessage @"receiveMessage"
@interface CSPMessageDetailTableViewController ()

@property (nonatomic,strong)NSArray *chatArray;

@end

@implementation CSPMessageDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.merchantName;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageInDetail) name:ReceiveMessage object:nil];
    [self addCustombackButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    if (self.merchantName) {
        self.chatArray = [[DeviceDBHelper sharedInstance] getMerchantSession:self.merchantName];
        [self.tableView reloadData];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.chatArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    CSPPersonCenterShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];

    if (!shopCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
        
    }
    
    ECSession *session = self.chatArray[indexPath.row];
    shopCell.badgeimageView.badgeNumber = [NSString stringWithFormat:@"%ld",session.unreadCount];
    shopCell.contentLabel.text = session.text;
    if (session.sessionType == 1) {
        shopCell.titleLabel.text = [NSString stringWithFormat:@"货号:%@  颜色:%@  价格:%@",session.goodsWillNo,session.goodColor,session.goodPrice];
        [shopCell.badgeimageView sd_setImageWithURL:[NSURL URLWithString:session.goodPic]];
    }else{
        shopCell.titleLabel.text = session.merchantName;
        shopCell.badgeimageView.image = [UIImage imageNamed:@"10_商品询单对话_客服.png"];
    }
    shopCell.showLine = YES;
    shopCell.arrorImageView.hidden = YES;
  
    return shopCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)newMessageInDetail
{
    if (self.merchantName) {
        self.chatArray = [[DeviceDBHelper sharedInstance] getMerchantSession:self.merchantName];
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ECSession *session = self.chatArray[indexPath.row];
        BOOL isSuccess = [[DeviceDBHelper sharedInstance]deleteOneSessionOfSession:session];
        if (isSuccess) {
            self.chatArray = [[DeviceDBHelper sharedInstance] getMerchantSession:self.merchantName];
            [self.tableView reloadData];
            //            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECSession *session = self.chatArray[indexPath.row];
    ConversationWindowViewController *conversationVC;
    conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
