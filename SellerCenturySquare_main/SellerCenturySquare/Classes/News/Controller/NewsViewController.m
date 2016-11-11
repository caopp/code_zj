//
//  NewsViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/22.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "NewsViewController.h"
#import "SDRefresh.h"
#import "CSPPersonCenterLetterTableViewCell.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "ChatManager.h"
#import "DeviceDBHelper.h"
#import "UIImageView+WebCache.h"
#import "CSPMessageDetailTableViewController.h"
#import "ConversationWindowViewController.h"
#import "RDVTabBarItem.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "InviteTableViewCell.h"
#import "InviteTableViewController.h"
#import "CSPLetterDetailTableViewController.h"
#import "LoginDTO.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *letterFirst;
    NSNumber *letterCount;
}
@property (nonatomic,strong) NSArray  *messageArray;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"叮咚";
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageInCenter) name:ReceiveMessage object:nil];
    [_newsTableView  reloadData];
    [self createRefresh];
    [self getMerchantInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLetterData];
    [self newMessageInCenter];
    [self clearNew];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToInvite) name:kPushNotification object:nil];
    NSArray *arrayCount = [[DeviceDBHelper sharedInstance]getMyCustomSession];

    if ([[LoginDTO sharedInstance].isChangeDevice isEqualToString:@"0"]||!arrayCount.count) {
        NSString *merchantNo = [LoginDTO sharedInstance].merchantNo;
        [self getChatListWithMemberNo:merchantNo];
    }else{
        [self newMessageInCenter];
       
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:kPushNotification object:nil];
    [super viewWillDisappear:animated];
}
-(void)clearNew{
    NSArray * tabbarItmes  = [[[self rdv_tabBarController] tabBar]items];
    
    // !叮咚
    RDVTabBarItem * dingDongItem = tabbarItmes[2];
    dingDongItem.badgeValue = @"";
}

#pragma mark !创建刷新
-(void)createRefresh{
    
    // !header
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.newsTableView];
    self.refreshHeader = refreshHeader;
    
    __weak NewsViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf AddMoreMessage];
    };
    
    
    // !footer
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.newsTableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf AddMoreMessage];
        [self.refreshFooter noDataRefresh];
    };
    
    // !判断当前商店是什么状态  黑名单  歇业  无商品的时候不进行刷新  改为刷新回来后判断一遍
    //    if (![self showTipViewForSingleMerchantMode]) {
    
   // [refreshHeader beginRefreshing];
    
    //    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.messageArray.count) {
         return self.messageArray.count+1;
    }else{
        return 2;
    }
    
   
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSPBaseTableViewCell *cell;
    if (self.messageArray.count) {
      
        if (indexPath.row ==0) {
           cell =  [self createCSPCenterLetterTableViewCell:indexPath withTable:tableView];
        }else{
            cell = [self createCSPCenterShopTableViewCell:indexPath withTable:tableView];

        }
  
    }else{
      
        if (indexPath.row ==0) {
            cell = [self createCSPCenterLetterTableViewCell:indexPath withTable:tableView];
            
        }else{
           cell =  [self createCSPCenterInttableViewCell:indexPath withTable:tableView];
        }
       

    }
  
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messageArray.count) {
        if (indexPath.row == 0) {
            return 54;
        }else
           return  68;
    }else{
        if (indexPath.row == 0) {
            return 54;
        }else
            return self.view.frame.size.height;
    }
        //return  54;
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;

    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
        if (indexPath.row == 0) {
            CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
            //            nextVC.returnTextBlock =^(){
            //                self.messageCount = [NSNumber numberWithInt:[self.messageCount intValue] -1];;
            //            };
            [self.navigationController pushViewController:nextVC animated:YES];
        }else{
            if (self.messageArray.count) {
                if ([GetMerchantInfoDTO sharedInstance].merchantNo) {
                    ECSession * session = (ECSession *)self.messageArray[indexPath.row-1];

                    [[ChatManager shareInstance]  getServerAcount:session.memberNo withName:session.merchantName withController:self];
                    
                    
                }else{
                    [self getMerchantInfo];
                }
             
            }
        
    }
    
    
}
-(void)AddMoreMessage{
    [self newMessageInCenter];
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
    
}

-(void)newMessageInCenter{
    self.messageArray = [[DeviceDBHelper sharedInstance]getMyCustomSession];
    
    [self.newsTableView reloadData];

}

-(void)getLetterData{
    [HttpManager sendHttpRequestForLetterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//infoTitle,totalCount
           // if (self.messageArray.count) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];//
            CSPPersonCenterLetterTableViewCell *cell = [_newsTableView cellForRowAtIndexPath:index];
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            letterFirst = [dataDict objectForKey:@"infoContent"];
            letterCount = [dataDict objectForKey:@"totalCount"];
            if (cell) {
                cell.contentLabel.text = [letterFirst length]>0?letterFirst:@"暂无站内信";
                cell.badgeView.badgeNumber = [self getNumber:letterCount];
                if (letterCount.intValue >99) {
                    
                    cell.badgeView.badge.frame = CGRectMake(cell.badgeView.frame.size.width -17, 0, 15, 15);
                }else if(letterCount.intValue >9){
                    cell.badgeView.badge.frame = CGRectMake(cell.badgeView.frame.size.width -12, -5, 23, 18);
                }else{
                    cell.badgeView.badge.frame = CGRectMake(cell.badgeView.frame.size.width -12, -5, 18, 18);
                }
            }
           
           
            // letterCount = [];
            
        } else {
            
            
        }
        [self.refreshFooter endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:NSLocalizedString(@"connectError", @"网络连接异常")  duration:2.0f position:@"center"];
        
        
    }];
    
    
}
- (void)pushToInvite{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InviteTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"InviteTableViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (NSString *)getNumber:(NSNumber *)number
{
    
    if (number.intValue>99) {
        return @" ";
    }else{
        return number.stringValue;
    }
    
}

//// 获取服务器时间
//-(void)getServerTime:(NSInteger )interger{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [HttpManager sendHttpRequestForGetChantTimeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//
//            NSLog(@"dic = %@",dic);
//            NSNumber *time = [dic objectForKey:@"data"];
//            ECSession * session = (ECSession *)self.messageArray[interger];
//            
//            ConversationWindowViewController *conversationVC;
//            conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
//            conversationVC.timeStart = time;
//            [self.navigationController pushViewController:conversationVC animated:YES];
//        }
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    }];
//
//}
//获取离线漫游 数据
-(void)getChatListWithMemberNo:(NSString *)memberNo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForGetChantListWithMemberNo:memberNo pageNo:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:20] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//
            NSLog(@"dic = %@",dic);
            
            [LoginDTO sharedInstance].isChangeDevice = @"1";

            NSArray *arrlist = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in arrlist) {
                ECSession *session = [[ECSession alloc] init];
                session.iconUrl = [dic objectForKey:@"iconUrl"];
                session.merchantName = [dic objectForKey:@"memberName"];
                session.memberNo = [dic objectForKey:@"memberNo"];
                session.sessionId = [dic objectForKey:@"memberNo"];
                [[IMMsgDBAccess sharedInstance] deleteMessageOfSession:session.memberNo];

                [[IMMsgDBAccess sharedInstance] insertSessionNoRepate:session];
            }
            
        }
        
        [self newMessageInCenter];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];


}
#pragma  mark create TableViewCell
-(CSPPersonCenterLetterTableViewCell *)createCSPCenterLetterTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPPersonCenterLetterTableViewCell *letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    if (!letterCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterLetterTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterLetterTableViewCell"];
        letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    }
    letterCell.contentLabel.text = [letterFirst length]>0?letterFirst:@"暂无站内信";
    
    letterCell.badgeView.badgeNumber = [self getNumber:letterCount];
    //letterCell.badgeView.badge.frame = CGRectMake(letterCell.badgeView.frame.size.width -12, -5, 15, 15);
    
    if (letterCount.intValue >99) {
        
        letterCell.badgeView.badge.frame = CGRectMake(letterCell.badgeView.frame.size.width -12, -5, 15, 15);
    }else if(letterCount.intValue >9){
        letterCell.badgeView.badge.frame = CGRectMake(letterCell.badgeView.frame.size.width -12, -5, 23, 18);
    }else{
        letterCell.badgeView.badge.frame = CGRectMake(letterCell.badgeView.frame.size.width -12, -5, 18, 18);
    }
    //letterCell.imageView.layer.cornerRadius = 17.5f;
    return letterCell;
}
-(CSPPersonCenterShopTableViewCell *)createCSPCenterShopTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPPersonCenterShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];

    if (!shopCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
        
    }
    ECSession * session = (ECSession *)self.messageArray[index.row-1];
    shopCell.ecSession = session;
    shopCell.arrorImageView.hidden = YES;
    //shopCell.badgeimageView.layer.cornerRadius = 17.5f;
    shopCell.badgeimageView.layer.masksToBounds = YES;
    return shopCell;
}
-(InviteTableViewCell *)createCSPCenterInttableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    InviteTableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteTableViewCell"];
    if (!inviteCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"InviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteTableViewCell"];
        inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteTableViewCell"];
    }
    return inviteCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
