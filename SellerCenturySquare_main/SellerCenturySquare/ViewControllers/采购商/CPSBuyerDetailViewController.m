//
//  CPSBuyerDetailViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSBuyerDetailViewController.h"

#import "BuyerDetailInfoTableViewCell.h"
#import "ShopLevelTableViewCell.h"
#import "BlackListTableViewCell.h"
#import "CountListTableViewCell.h"
#import "CPSBuyerDetailInfoViewController.h"
#import "CPSResetBuyerLevelViewController.h"
#import "CPSSetBlackListViewController.h"

#import "MemberTradeDTO.h"
#import "MemberInviteDTO.h"
#import "MemberBlackDTO.h"
#import "GetMemberInfoDTO.h"
#import "ConversationWindowViewController.h"

@interface CPSBuyerDetailViewController ()<UITableViewDataSource>{
    
    GetMemberInfoDTO *getMemberInfoDTO;
}

@end

@implementation CPSBuyerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customBackBarButton];
}

- (void)viewDidAppear:(BOOL)animated{
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self navigationBarSettingShow:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self getHttpData];
}

#pragma mark - HttpRequest
- (void)getHttpData{
    
    NSString *memberNo = [self getMemberNo:_memberDTO];
    
    [HttpManager sendHttpRequestForGetMemberInfo:memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-详情接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                 getMemberInfoDTO = [[GetMemberInfoDTO alloc] init];
                
                [getMemberInfoDTO setDictFrom:[dic objectForKey:@"data"]];
             
                [self.tableView reloadData];
            }
            
        }else{
            
            NSLog(@" 采购商-详情接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
}


#pragma mark - Private Function
- (NSString *)getMemberNo:(id)memberDTO{
    
    if ([memberDTO isMemberOfClass:[MemberTradeDTO class]]) {
        
        return ((MemberTradeDTO*)memberDTO).memberNo;
        
    }else if([memberDTO isMemberOfClass:[MemberInviteDTO class]]){
        
        return ((MemberInviteDTO*)memberDTO).memberNo;
        
    }else if([memberDTO isMemberOfClass:[MemberBlackDTO class]]){
        
        return ((MemberBlackDTO*)memberDTO).memberNo;
    }
    
    return nil;
}

- (IBAction)callAction:(id)sender {
    
    NSString *tel = [NSString stringWithFormat:@"确定拨打电话%@",getMemberInfoDTO.mobilePhone];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        NSString *num = [NSString stringWithFormat:@"tel://%@",getMemberInfoDTO.mobilePhone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

- (IBAction)IMAction:(id)sender {
    
    ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc]initWithNameWithYOffsent:getMemberInfoDTO.nickName withJID:getMemberInfoDTO.chatAccount withMemberNO:getMemberInfoDTO.memberNo];
    
    [self.navigationController pushViewController:IMVC animated:YES];
    
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BuyerDetailInfoTableViewCell *buyerDetailCell = [tableView dequeueReusableCellWithIdentifier:@"BuyerDetailInfoTableViewCell"];
    
    ShopLevelTableViewCell *shopLevelCell = [tableView dequeueReusableCellWithIdentifier:@"ShopLevelTableViewCell"];
    
    BlackListTableViewCell *blackListCell = [tableView dequeueReusableCellWithIdentifier:@"BlackListTableViewCell"];
    
    CountListTableViewCell *countListCell = [tableView dequeueReusableCellWithIdentifier:@"CountListTableViewCell"];
    
    
    if (!buyerDetailCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"BuyerDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuyerDetailInfoTableViewCell"];
        
        buyerDetailCell = [tableView dequeueReusableCellWithIdentifier:@"BuyerDetailInfoTableViewCell"];
    }
    
    if (!shopLevelCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ShopLevelTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopLevelTableViewCell"];
        
        shopLevelCell = [tableView dequeueReusableCellWithIdentifier:@"ShopLevelTableViewCell"];
    }
    
    if (!blackListCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"BlackListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BlackListTableViewCell"];
        
        blackListCell = [tableView dequeueReusableCellWithIdentifier:@"BlackListTableViewCell"];
    }
    
    if (!countListCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CountListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountListTableViewCell"];
        
        countListCell = [tableView dequeueReusableCellWithIdentifier:@"CountListTableViewCell"];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            buyerDetailCell.memberDTO = _memberDTO;
            buyerDetailCell.getMemberInfoDTO = getMemberInfoDTO;
            return buyerDetailCell;
            break;
        case 1:
            shopLevelCell.getMemberInfoDTO = getMemberInfoDTO;
            return shopLevelCell;
            break;
        case 2:
            return blackListCell;
            break;
        case 3:
            countListCell.getMemberInfoDTO = getMemberInfoDTO;
            return countListCell;
            break;
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.1;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        CPSBuyerDetailInfoViewController *buyerDetailInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSBuyerDetailInfoViewController"];
        
        buyerDetailInfoVC.memberNo = getMemberInfoDTO.memberNo;
        buyerDetailInfoVC.nickName = getMemberInfoDTO.nickName;
        buyerDetailInfoVC.chatAccount = getMemberInfoDTO.chatAccount;
        
        [self.navigationController pushViewController:buyerDetailInfoVC animated:YES];
        
    }else if(indexPath.section==1){
        
        CPSResetBuyerLevelViewController *resetBuyerLevelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSResetBuyerLevelViewController"];
        
        resetBuyerLevelVC.memberNo = getMemberInfoDTO.memberNo;
        resetBuyerLevelVC.memberName = getMemberInfoDTO.memberName;
        resetBuyerLevelVC.shopLevel = [NSNumber numberWithInt:[getMemberInfoDTO.shopLevel intValue]];
        resetBuyerLevelVC.tradeLevel = [NSNumber numberWithInt:[getMemberInfoDTO.tradeLevel intValue]];
        resetBuyerLevelVC.level = [[GetMerchantInfoDTO sharedInstance] level];
        
        [self.navigationController pushViewController:resetBuyerLevelVC animated:YES];
    }else if(indexPath.section==2){
        
        CPSSetBlackListViewController *blackListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSSetBlackListViewController"];
    
        blackListVC.isInBlackList = getMemberInfoDTO.blackListFlag;
        blackListVC.memberName = getMemberInfoDTO.memberName;
        blackListVC.memberNo = getMemberInfoDTO.memberNo;
        blackListVC.level = [[GetMerchantInfoDTO sharedInstance] level];
        
        [self.navigationController pushViewController:blackListVC animated:YES];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
