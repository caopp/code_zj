//
//  NewsViewController.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 15/12/22.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "NewsViewController.h"
#import "CSPPersonCenterLetterTableViewCell.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "ChatManager.h"
#import "DeviceDBHelper.h"
#import "UIImageView+WebCache.h"
#import "CSPMessageDetailTableViewController.h"
#import "ConversationWindowViewController.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "CSPLetterDetailTableViewController.h"
#import "NSDate+Utils.h"
#import "LoginDTO.h"
#import "MBProgressHUD.h"
@interface NewsViewController ()<SMSegmentViewDelegate,UITableViewDataSource,UITableViewDelegate>{
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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLetterMessage) name:@"AddLetterMessage" object:nil];
    self.title = @"叮咚";
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageInCenter) name:ReceiveMessage object:nil];
    //_newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.newsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.newsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.newsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.newsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self  setupsegmentWithStyle:CSPNewsStyleTime];
    [self createRefresh];
    
    if(self.observe == CSPNewsStyleTime||!self.messageArray.count){
        [self getLetterData];
    }
    //!!!!
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.refreshHeader beginRefreshing];
   
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    if ([[LoginDTO sharedInstance].isChangeDevice isEqualToString:@"0"]) {//!切换过设备
        
        NSString *memberNo = [LoginDTO sharedInstance].memberNo;
        [self getChatListWithMemberNo:memberNo];
    }else{
        [self newMessageInCenter];

    }
    
   // [self getLetterData];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}


#pragma mark !创建顶部的segment
- (void)setupsegmentWithStyle:(CSPNewsStyle)style {
    
    [self.segment addSegmentWithTitle:NSLocalizedString(@"news", @"消息")];
    
    [self.segment addSegmentWithTitle:NSLocalizedString(@"shop",@"商家")];
    
    // !设定当前
    [self.segment selectSegmentAtIndex:0];
    
    //！记录当前选中的栏目
    self.observe = CSPNewsStyleTime;
    
    self.segment.delegate = self;
    
    
}
#pragma mark !创建刷新
-(void)createRefresh{
    
    // !header
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:_newsTableView];
    self.refreshHeader = refreshHeader;
    
    __weak NewsViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf AddMoreMessage];
    };
    
    
    // !footer
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:_newsTableView];
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

#pragma mark segmentDelegate
-(void)segmentView:(SMSegmentView *)segmentView didSelectSegmentAtIndex:(NSInteger)index{
    if (index == 0) {
        self.observe =  CSPNewsStyleTime;
    }else{
        self.observe = CSPNewsStyleShop;
    }
     [self.refreshHeader beginRefreshing];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.messageArray.count ) {
        // Return the number of sections.
        if (self.observe == CSPNewsStyleTime) {
            return 1;
        }else{
            return self.messageArray.count;
        }
    }else{
        return 1;
    }
    
  
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.messageArray.count) {
        if (self.observe == CSPNewsStyleTime) {
            return self.messageArray.count+1;
        }else{
            NSArray *array = [self.messageArray objectAtIndex:section];
            return array.count+1;
        }
    }else{
        if (self.observe == CSPNewsStyleTime) {
            return 1+1;
        }else{
            return 1;
        }
    }
   
    
  
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *cell;
    if (self.messageArray.count) {
        if (self.observe ==CSPNewsStyleTime) {
            if (indexPath.row ==0) {
               cell =  [self createCSPCenterLetterTableViewCell:indexPath withTable:tableView];
            }
            else{
                 ECSession * session = (ECSession *)self.messageArray[indexPath.row-1];
                NSLog(@"session.goodNo===%@",session.iconUrl);
                cell = [self createCSPPersonCenterTableViewCell:indexPath withTable:tableView withSession:session];
            }
        }else{
            if (indexPath.row ==0) {
                cell = [self createCSPBaseTableViewCell:indexPath withTable:tableView];
            }
            else{
                NSArray *array = [self.messageArray objectAtIndex:indexPath.section ];
                ECSession * session = (ECSession *)array[indexPath.row-1];
                 cell = [self createCSPPersonCenterTableViewCell:indexPath withTable:tableView withSession:session];
            }
        }
    }else{
        if (self.observe ==CSPNewsStyleTime) {
            if (indexPath.row ==0) {
                 cell =  [self createCSPCenterLetterTableViewCell:indexPath withTable:tableView];
            }
            else{
                cell = [self createCSPTitleTableViewCell:indexPath withTable:tableView];
            }
        }else{
             cell = [self createCSPTitleTableViewCell:indexPath withTable:tableView];
          
        }
   
    }
    return cell;
    
}

    

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messageArray.count) {
        if (self.observe == CSPNewsStyleTime) {
            if (indexPath.row == 0) {
                return 64;
            }else
                return  64;
        }else{
            if (indexPath.row == 0)
            {
                return 29;
            }else{
                return 80;
            }
            
        }
    }else{
        if (self.observe == CSPNewsStyleTime) {
            if (indexPath.row==0) {
                return 64;
            }else{
                return self.view.frame.size.height - 64;
            }
        }else{
            return self.view.frame.size.height;
        }
       
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.messageArray.count) {
        if (self.observe == CSPNewsStyleTime) {
            return 0;
        }else{
            if (section) {
                return 10;
            }else{
                return 0;
            }
        }
    }else{        
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0&&self.observe == CSPNewsStyleTime) {
        CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
        nextVC.returnTextBlock =^(){
//            self.messageCount = [NSNumber numberWithInt:[self.messageCount intValue] -1];;
            letterCount = 0;
        };
        letterCount = 0;
        [self.navigationController pushViewController:nextVC animated:YES];
        return;
    }
//    else{
    if (self.messageArray.count) {
        if (self.observe == CSPNewsStyleTime) {
            ECSession * session = (ECSession *)self.messageArray[indexPath.row-1];
            
            [self getJID:session.merchantNo withArray:session];
            
        }else{
            
            if (indexPath.row == 0) {
                
                CSPMessageDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPMessageDetailTableViewController"];
                NSArray * array = (NSArray *)[self.messageArray objectAtIndex:indexPath.section ];
                ECSession * session = (ECSession *)[array objectAtIndex:0];
                nextVC.merchantName = session.merchantName;
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else{
            
                NSArray *array = [self.messageArray objectAtIndex:indexPath.section ];
                ECSession * session = (ECSession *)array[indexPath.row-1];
                
                ConversationWindowViewController *conversationVC;
                conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            }
        }
    }
}

-(void)AddMoreMessage{
   
    [self newMessageInCenter];
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
}

-(void)newMessageInCenter
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:clearNewsNotification object:nil];
    if (self.observe == CSPNewsStyleTime) {
        self.messageArray = [[DeviceDBHelper sharedInstance]getMyCustomSession];
    }else{
        self.messageArray = [[DeviceDBHelper sharedInstance]getCenterSession];
    }
  
    if (self.messageArray.count <10) {
        self.refreshFooter.hidden = YES;
    }else{
        self.refreshFooter.hidden = NO;
    }
    [_newsTableView reloadData];
}
-(void)addLetterMessage{
    [self getLetterData];
}
-(void)getLetterData{
    [HttpManager sendHttpRequestForLetterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//infoTitle,totalCount
          
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            letterFirst = [dataDict objectForKey:@"infoContent"];
            
            letterCount = [dataDict objectForKey:@"totalCount"];
            
            
            if (self.observe == CSPNewsStyleTime) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];//
                CSPPersonCenterLetterTableViewCell *cell = [_newsTableView cellForRowAtIndexPath:index];
                cell.contentLabel.text = [letterFirst length]>0?letterFirst:@"没有站内信消息";
                if ([letterCount intValue]) {
                    cell.badgeImage.badgeNumber = @" "; 
                    cell.badgeImage.badge.frame = CGRectMake(cell.badgeImage.frame.size.width -12, 0, 10, 10);
//                    if (letterCount.intValue >99) {
//                          cell.badgeImage.badge.frame = CGRectMake(cell.badgeImage.frame.size.width -12, -5, 15, 15);
//                    }else{
//                         cell.badgeImage.badge.frame = CGRectMake(cell.badgeImage.frame.size.width -12, -5, 20, 20);
//                    }

                }else{
                    cell = nil;
                    [self.newsTableView reloadData];
                }
                
            }
            
        } else {
            
            
        }
       [self.refreshFooter endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:NSLocalizedString(@"connectError", @"网络连接异常")  duration:2.0f position:@"center"];
        
        
    }];
    

}
- (NSString *)getNumber:(NSNumber *)number
{
    
    if (number.intValue>99) {
        return @" ";
    }else{
        return number.stringValue;
    }
    
}

- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days < 1) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else if(days>=1&&days<=5){
           dateStr =  [lastDate weekday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    //    if ([lastDate hour]>=5 && [lastDate hour]<12) {
    //        period = @"AM";
    //        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    //    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
    //        period = @"PM";
    //        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    //    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
    //        period = @"Night";
    //        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    //    }else{
    //        period = @"Dawn";
    //        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    //    }
    if ([dateStr length]||!dateStr) {
        return [NSString stringWithFormat:@"%@ ",dateStr];
    }else{
        return [NSString stringWithFormat:@"%@ %02d:%02d",dateStr,(int)[lastDate hour],(int)[lastDate minute]];
    }
    
}

- (void)getJID:(NSString *)merchantNo withArray:(ECSession *)session{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
//            NSString* jid = [dic objectForKey:@"data"];
            NSString* jid = dic[@"data"][@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExist = dic[@"data"][@"isExist"];
            session.sessionId = jid;
            ConversationWindowViewController *conversationVC;
            conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
            conversationVC.timeStart = [time isKindOfClass:[NSNumber class]]?time:nil;
            conversationVC.isWaite = isExist.boolValue;

            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }else{
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



-(void)getChatListWithMemberNo:(NSString *)memberNo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForGetChantListWithMemberNo:memberNo pageNo:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:30] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//
            NSLog(@"dic = %@",dic);
            [LoginDTO sharedInstance].isChangeDevice = @"1";
            NSArray *arrlist = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in arrlist) {
                ECSession *session = [[ECSession alloc] init];
                session.iconUrl = [dic objectForKey:@"iconUrl"];
                session.merchantName = [dic objectForKey:@"merchantName"];
                session.merchantNo = [dic objectForKey:@"merchantNo"];
                [[IMMsgDBAccess sharedInstance] deleteMessageOfSession:session.merchantNo];
                [[IMMsgDBAccess sharedInstance] insertSessionNoRepate:session];
            }
        }
        [self newMessageInCenter];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
//    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        NSLog(@"dic = %@",dic);
//        
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            
//            NSString *jid = dic[@"data"];
//            
//            
//            session.sessionId = jid;
//            ConversationWindowViewController *conversationVC;
//            conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
//            [self.navigationController pushViewController:conversationVC animated:YES];
//            
//        }else{
//            
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //[[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//        NSLog(@"The error description is %@\n",[error localizedDescription]);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}
#pragma  mark create TableViewCell
-(CSPPersonCenterLetterTableViewCell *)createCSPCenterLetterTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPPersonCenterLetterTableViewCell *letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    if (!letterCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterLetterTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterLetterTableViewCell"];
        letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    }
    letterCell.contentLabel.text = [letterFirst length]>0?letterFirst:@"没有站内信消息";
    if (letterCount.intValue) {
        letterCell.badgeImage.badge.hidden = NO;
        letterCell.badgeImage.badgeNumber =@" ";
        letterCell.badgeImage.badge.frame = CGRectMake(letterCell.badgeImage.frame.size.width -12, 0, 10, 10);

    }else{
        letterCell.badgeImage.badge.hidden = YES;
       letterCell.badgeImage.badgeNumber = @"0";
    }
    //letterCell.badgeImage.badgeNumber =[self getNumber:letterCount];

//    if (letterCount.intValue >99) {
//        
//        letterCell.badgeImage.badge.frame = CGRectMake(letterCell.badgeImage.frame.size.width -12, -5, 15, 15);
//    }else if(letterCount.intValue >9){
//         letterCell.badgeImage.badge.frame = CGRectMake(letterCell.badgeImage.frame.size.width -12, -5, 23, 18);
//    }else{
//        letterCell.badgeImage.badge.frame = CGRectMake(letterCell.badgeImage.frame.size.width -12, -5, 18, 18);
//    }
    
    return letterCell;
}

-(CSPPersonCenterShopTableViewCell *)createCSPPersonCenterTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView withSession:(ECSession *)session{
    CSPPersonCenterShopTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
    if (!newsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        newsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
    }
   
    //            NSLog(@"unreadCount===%ld",session.unreadCount);
    //            shopCell.badgeimageView.badgeNumber =session.unreadCount>99?@"99+" :[NSString stringWithFormat:@"%ld",session.unreadCount];
    newsCell.contentLabel.text = @"";
    if (session.type == 2||session.type ==3) {
        NSString *goodsWillNo =[[session.goodsWillNo componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodsColor =[[session.goodColor componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodPrice =[[session.goodPrice componentsSeparatedByString:@";"] objectAtIndex:0];
       
        newsCell.goodsNoLabel.text = [NSString stringWithFormat:@"[商品]货号:%@ %@ ¥ %@",[goodsWillNo length]?goodsWillNo:session.goodNo,goodsColor,goodPrice];
    }else if(session.type == 4){
   
        NSString *goodsWillNo =[[session.goodsWillNo componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodsColor =[[session.goodColor componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodPrice =[[session.goodPrice componentsSeparatedByString:@";"] objectAtIndex:0];
        
        newsCell.goodsNoLabel.text = [NSString stringWithFormat:@"[商品推荐]货号:%@ %@ ¥ %@",[goodsWillNo length]?goodsWillNo:session.goodNo,goodsColor,goodPrice];
    }else if(session.type == 5){
        
        newsCell.goodsNoLabel.text = session.text;

    }
    else{
        // newsCell.titleLabel.text = [NSString stringWithFormat:@"客服-%@",session.merchantName?session.merchantName:session.merchantNo];
    
        //newsCell.badgeimageView.image = [UIImage imageNamed:@"10_商品询单对话_客服.png"];
        newsCell.goodsNoLabel.text =session.text;
    }
        newsCell.titleLabel.text = [NSString stringWithFormat:@"%@",session.merchantName?session.merchantName:session.merchantNo];
    
    [newsCell.badgeimageView sd_setImageWithURL:[NSURL URLWithString:session.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_客服.png"]];
    newsCell.badgeimageView.layer.cornerRadius = 22.5f;
    newsCell.badgeimageView.layer.masksToBounds = YES;
    if (session.dateTime ==0) {
        newsCell.timeLabel.text = @"";
    }else{
        newsCell.timeLabel.text = [self changeTheDateString:[CSPUtils getTime:session.dateTime]];

    }
   

    if (session.unreadCount <100&&session.unreadCount>9) {
        
        newsCell.badgeWith.constant = 23;
    }else if(session.unreadCount >99){
        newsCell.badgeHight.constant = 12;
        newsCell.badgeWith.constant = 12;
    }else{
        newsCell.badgeWith.constant = 18;
    }
    if (session.unreadCount >99) {
          [newsCell.custombadge  changeViewToBadgeWithString:@" "];
    }else{
        [newsCell.custombadge  changeViewToBadgeWithString:[NSString stringWithFormat:@"%zi",session.unreadCount] withScale:0.7];
    }
   
    newsCell.custombadge.hidden = !session.unreadCount;


    newsCell.arrorImageView.hidden = YES;
    //newsCell.selectionStyle = UITableViewCellSelectionStyleGray;

    return newsCell;
}
-(TitleZoneGoodsTableViewCell *)createCSPTitleTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    static NSString *cellId = @"TitleZoneGoodsTableViewCell";
    TitleZoneGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TitleZoneGoodsTableViewCell alloc] init];
        
    }
   
    cell.titleLabel.text = @"您暂无询单消息";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.view.backgroundColor = [UIColor whiteColor];

    return cell;
}
-(CSPBaseTableViewCell *)createCSPBaseTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    if (!otherCell) {
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
    }
    for (id view in otherCell.subviews) {
        if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]){
            if (((UIImageView *)view).tag !=99) {
                [view removeFromSuperview];
            }
            
        }
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (29-11)/2, 150, 13)];
    titleLabel.textColor = HEX_COLOR(0x000000FF);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:13];//[UIFont systemFontOfSize:13];
    [otherCell addSubview:titleLabel];
    NSArray * array = (NSArray *)[self.messageArray objectAtIndex:index.section];
    ECSession * session = (ECSession *)[array objectAtIndex:0];
    titleLabel.text = session.merchantName;
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -8-15,(29-12)/2, 8, 12)];
    arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
    [otherCell addSubview:arrowImageView];
    otherCell.selectionStyle = UITableViewCellSelectionStyleGray;
    return otherCell;
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
