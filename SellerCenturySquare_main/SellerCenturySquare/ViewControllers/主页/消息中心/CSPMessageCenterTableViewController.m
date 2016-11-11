//
//  CSPMessageCenterTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMessageCenterTableViewController.h"
#import "CSPPersonCenterLetterTableViewCell.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "CSPLetterDetailTableViewController.h"
#import "CSPRecommendViewController.h"
#import "RecommendTableViewCell.h"
#import "RecommendHistoryListViewController.h"
#import "DeviceDBHelper.h"
#import "ConversationWindowViewController.h"
#import "GetMerchantMainDTO.h"

@interface CSPMessageCenterTableViewController ()
@property (nonatomic,strong) NSMutableArray *allMessageList;
@property (nonatomic,strong) GetMerchantMainDTO *getMerchantMainDTO;
@end

@implementation CSPMessageCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    [self customBackBarButton];
    
    [self getMessageNotification];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessageNotification) name:@"receiveMessage" object:nil];
    
    
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self tabbarHidden:YES];
    [self getMerchantMain];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

#pragma mark - HttpRequest
- (void)getMerchantMain{
    
    [HttpManager sendHttpRequestForGetMerchantMain:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"大B商家中心主页接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
                [_getMerchantMainDTO setDictFrom:[dic objectForKey:@"data"]];
                self.messageCount = [_getMerchantMainDTO.noticeStationNum stringValue];
                [self.tableView reloadData];
            }
            
        }else{
            
            NSLog(@"大B商家中心主页接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testMerchantMain 失败");
        
    } ];
    
}


#pragma mark - 获取消息

- (void)getMessageNotification{
    
    //接口修改
    _allMessageList = [[NSMutableArray alloc]initWithArray:[[DeviceDBHelper sharedInstance]getMyCustomSession]];
    
    if (_allMessageList.count==0) {
        
    }else{
        
        [self.tableView reloadData];
    }
    
    NSLog(@"%@",_allMessageList);
    
    
}



#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        
        return _allMessageList.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendTableViewCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
    CSPPersonCenterLetterTableViewCell *letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    CSPPersonCenterShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
    
    if (!recommendCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendTableViewCell"];
        recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
    }
    
    if (!letterCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterLetterTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterLetterTableViewCell"];
        letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    }
    
    if (!shopCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
        
    }
    
    if (indexPath.section==0) {
        
        return recommendCell;
    }else if(indexPath.section == 1) {
        letterCell.titleLabel.text = @"站内信";
        letterCell.badgeView.badgeNumber = self.messageCount;
         [letterCell.imageView setImage:[UIImage imageNamed:@"04_商家中心主页_站内信"]];
        return letterCell;
    }
    else
    {
        ECSession *ecSession = (ECSession*) _allMessageList[indexPath.row];
        shopCell.ecSession = ecSession;
        shopCell.arrorImageView.hidden = YES;
        
        return shopCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 54;
    }else if (indexPath.section == 1) {
        return 44;
    }else
    {
        return 54;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 10;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        
        case 0:{
            
            RecommendHistoryListViewController *recommendHistoryListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommendHistoryListViewController"];
            [self.navigationController pushViewController:recommendHistoryListVC animated:YES];
            
        }
            break;
        case 1:
        {
            CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 2:
        {
            ConversationWindowViewController *cwVC = [[ConversationWindowViewController alloc]initWithSession:_allMessageList[indexPath.row]];
            
            [self.navigationController pushViewController:cwVC animated:YES];
        }
            break;
            
        default:
            
            break;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section>1) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return  UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ECSession *ecSession = _allMessageList[indexPath.row];
    
        [[DeviceDBHelper sharedInstance]deleteOneSessionOfSession:ecSession];
        
        [_allMessageList removeObject:ecSession];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

@end
