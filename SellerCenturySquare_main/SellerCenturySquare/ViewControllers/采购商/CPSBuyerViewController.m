//
//  CPSBuyerViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSBuyerViewController.h"
#import "AccordingToTimeTableViewCell.h"
#import "NormalTableViewCell.h"
#import "CPSBuyerDetailViewController.h"
#import "HttpManager.h"
#import "GetMemberTradeListDTO.h"
#import "MemberTradeDTO.h"
#import "GetMemberInviteListDTO.h"
#import "MemberInviteDTO.h"
#import "GetMemberBlackListDTO.h"
#import "ConversationWindowViewController.h"

@interface CPSBuyerViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *memberDTOArr;
    
    GetMemberTradeListDTO *getMemberTradeList_OrderByMoneyDTO;
    GetMemberTradeListDTO *getMemberTradeList_OrderByTimeDTO;
    
    GetMemberInviteListDTO *getMemberInviteList_OrderByMoneyDTO;
    GetMemberInviteListDTO *getMemberInviteList_OrderByTimeDTO;
    GetMemberInviteListDTO *getMemberInviteList_OrderByNotInviteDTO;
    
    GetMemberBlackListDTO *getMemberBlackListDTO;
}
//一级状态：有交易的会员1 我邀请的会员2 黑名单3
@property (nonatomic,assign) NSInteger firstState;
//二级状态
@property (nonatomic,assign) NSInteger secondState;
//有交易的会员:按按交易金额or按交易时间
@property (nonatomic,assign) BOOL isAccordingToMoney;
//我邀请的会员：按金额1 按时间2 未接受3
@property (nonatomic,assign) NSInteger inviteButtonState;


@end

@implementation CPSBuyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _firstState = 1;
    _secondState = 10;
    _inviteButtonState = 12;
    _isAccordingToMoney = YES;
    
    [self buttonClickedInit];
    [self dataPreInit];
    
    memberDTOArr = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeFromBlackListNotification) name:kRemoveFromBlackListNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toIM:) name:kAccordingToTimeTableViewCellToIM object:nil];
    
    [_firstView.layer setMasksToBounds:YES];
    [_firstView.layer setCornerRadius:34.0];
    
    [_midView.layer setMasksToBounds:YES];
    [_midView.layer setCornerRadius:34.0];
    
    [_lastView.layer setMasksToBounds:YES];
    [_lastView.layer setCornerRadius:34.0];
}

- (void)viewWillAppear:(BOOL)animated{

    [self navigationBarSettingShow:NO];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    [self getHttpDataAndRefreshTableView];
    [self firstStateChangedWithTag:_firstState];
    [self secondStateChangedWithTag:_secondState];
    
    [self.tableView reloadData];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
 
    NSLog(@"self.tableView.frame.origin.y:%lf",self.tableView.frame.origin.y);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self navigationBarSettingShow:YES];

}

#pragma mark - Private Functions
//一级
//Options:有交易的会员1 我邀请的会员2 黑名单3
- (IBAction)optionButtonClicked:(id)sender {
    
    NSInteger tag = ((UIButton *)sender).tag;
    
    [self firstStateChangedWithTag:tag];
}

//二级状态切换
- (IBAction)changeSequenceMode:(id)sender {
    
    NSInteger tag  = ((UIButton *)sender).tag;
 
    [self secondStateChangedWithTag:tag];
}

- (void)secondStateChangedWithTag:(NSInteger)tag{
    
    _secondState = tag;
    
    //我邀请的初始化
    _inviteAccordingToMoneyButton.selected = NO;
    _inviteAccordingToTimeButton.selected = NO;
    _inviteUnAcceptButton.selected = NO;
    
    [_inviteAccordingToMoneyButton setBackgroundColor:[UIColor colorWithHex:333333]];
    [_inviteAccordingToTimeButton setBackgroundColor:[UIColor colorWithHex:333333]];
    [_inviteUnAcceptButton setBackgroundColor:[UIColor colorWithHex:333333]];
    
    
    switch (tag) {
        case 10:
            //－－有交易－金额
            
            _isAccordingToMoney = YES;
            memberDTOArr = getMemberTradeList_OrderByMoneyDTO.memberTradeDTOList;
            
            //按钮
            _accordingToMoneyButton.selected = YES;
            _accordingToTimeButton.selected = NO;
            [_accordingToMoneyButton setBackgroundColor:[UIColor whiteColor]];
            [_accordingToTimeButton setBackgroundColor:[UIColor colorWithHex:333333]];
            
            break;
        case 11:
            //－－有交易－时间
            
            _isAccordingToMoney = NO;
            memberDTOArr = getMemberTradeList_OrderByTimeDTO.memberTradeDTOList;
            
            //
            _accordingToMoneyButton.selected = NO;
            _accordingToTimeButton.selected = YES;
            
            [_accordingToTimeButton setBackgroundColor:[UIColor whiteColor]];
            [_accordingToMoneyButton setBackgroundColor:[UIColor colorWithHex:333333]];
            break;
        case 12:
            //我邀请的－金额
            _inviteButtonState = tag;
            _inviteAccordingToMoneyButton.selected = YES;
            [_inviteAccordingToMoneyButton setBackgroundColor:[UIColor whiteColor]];
            memberDTOArr = getMemberInviteList_OrderByMoneyDTO.memberInviteDTOList;
            break;
        case 13:
            //我邀请的－时间
            _inviteButtonState = tag;
            _inviteAccordingToTimeButton.selected = YES;
            [_inviteAccordingToTimeButton setBackgroundColor:[UIColor whiteColor]];
            memberDTOArr = getMemberInviteList_OrderByTimeDTO.memberInviteDTOList;
            break;
        case 14:
            //我邀请的－未接受
            _inviteButtonState = tag;
            _inviteUnAcceptButton.selected = YES;
            [_inviteUnAcceptButton setBackgroundColor:[UIColor whiteColor]];
            memberDTOArr = getMemberInviteList_OrderByNotInviteDTO.memberInviteDTOList;
            break;
        default:
            break;
    }
    
    
    [self tableViewReloadData];
}

//一级状态切换
//切换 ：有交易的会员1 我邀请的会员2 黑名单3
- (void)firstStateChangedWithTag:(NSInteger)tag{
    
    _firstState = tag;
    switch (tag) {
        case 1:
            _firstButtonHideView.alpha = 0;
            _midButtonHideView.alpha = 0.5;
            _lastButtonHideView.alpha = 0.5;
            _firstToolBarView.hidden = NO;
            _midToolBarView.hidden = YES;
            memberDTOArr = getMemberTradeList_OrderByMoneyDTO.memberTradeDTOList;
            [self secondStateChangedWithTag:10];
            break;
        case 2:
            _firstButtonHideView.alpha = 0.5;
            _midButtonHideView.alpha = 0;
            _lastButtonHideView.alpha = 0.5;
            _firstToolBarView.hidden = YES;
            _midToolBarView.hidden = NO;
            memberDTOArr = getMemberInviteList_OrderByMoneyDTO.memberInviteDTOList;
            [self secondStateChangedWithTag:12];
            break;
        case 3:
            _firstButtonHideView.alpha = 0.5;
            _midButtonHideView.alpha = 0.5;
            _lastButtonHideView.alpha = 0;
            _firstToolBarView.hidden = YES;
            _midToolBarView.hidden = YES;
            memberDTOArr = getMemberBlackListDTO.memberBlackDTOList;
            break;
        default:
            break;
    }
    
    [self tableViewReloadData];
}


- (void)buttonClickedInit{
    
    //
    _accordingToMoneyButton.selected = YES;
    _accordingToTimeButton.selected = NO;
    [_accordingToMoneyButton setBackgroundColor:[UIColor whiteColor]];
    [_accordingToTimeButton setBackgroundColor:[UIColor colorWithHex:333333]];
    
    //
    _inviteAccordingToTimeButton.selected = NO;
    _inviteUnAcceptButton.selected = NO;
    
    [_inviteAccordingToTimeButton setBackgroundColor:[UIColor colorWithHex:333333]];
    [_inviteUnAcceptButton setBackgroundColor:[UIColor colorWithHex:333333]];
    
    _inviteAccordingToMoneyButton.selected = YES;
    [_inviteAccordingToMoneyButton setBackgroundColor:[UIColor whiteColor]];
}

- (void)toIM:(NSNotification *)note{
    
    NSDictionary *IMInfo = [note userInfo];
    
    NSString *name = IMInfo[@"name"];
    
    NSString *JID = IMInfo[@"JID"];

    ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:IMInfo[@"memberNo"]];

    
    [self.navigationController pushViewController:IMVC animated:YES];
}

- (void)refreshTableViewWithFirstOrSecondState:(NSInteger)tag{
    
    if(_secondState==tag){
        
        [self firstStateChangedWithTag:_firstState];
        
        [self tableViewReloadData];
        
    }
        
    if(_firstState==tag) {
        
        [self firstStateChangedWithTag:_firstState];
        
        [self tableViewReloadData];
    }
}

- (void)UpdateTableViewFrame{
    
    switch (_firstState) {
        case 1:
            _tableViewTopLayout.constant = 0;
            break;
        case 2:
            _tableViewTopLayout.constant = 0;
            break;
        case 3:
            _tableViewTopLayout.constant = -30;
            break;
        default:
            break;
    }
}

- (void)tableViewReloadData{
    
    [self.tableView reloadData];
    [self UpdateTableViewFrame];
}

#pragma mark - HttpRequest
- (void)dataPreInit{
    
    NSString *orderBy = @"1";
    NSNumber*pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber*pageSize = [[NSNumber alloc] initWithInt:30];
    
    //Money
    
    [HttpManager sendHttpRequestForGetMemberTradeList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-有交易的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberTradeList_OrderByMoneyDTO = [[GetMemberTradeListDTO alloc] init];
                
                [getMemberTradeList_OrderByMoneyDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
            memberDTOArr = getMemberTradeList_OrderByMoneyDTO.memberTradeDTOList;
            
            _memberTradeCountL.text = [NSString stringWithFormat:@"%@",getMemberTradeList_OrderByMoneyDTO.totalCount];
            
            [self tableViewReloadData];
        }else{
            
            NSLog(@" 采购商-有交易的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dataInit_dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberTradeList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    
}

- (void)getHttpDataAndRefreshTableView{
    
    NSString *orderBy = @"1";
    NSNumber*pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber*pageSize = [[NSNumber alloc] initWithInt:30];
    
    //Money
    
    [HttpManager sendHttpRequestForGetMemberTradeList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-有交易的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberTradeList_OrderByMoneyDTO = [[GetMemberTradeListDTO alloc] init];
                
                [getMemberTradeList_OrderByMoneyDTO setDictFrom:[dic objectForKey:@"data"]];
                
                _memberTradeCountL.text = [NSString stringWithFormat:@"%@",getMemberTradeList_OrderByMoneyDTO.totalCount];
                
                [self refreshTableViewWithFirstOrSecondState:10];
                
            }

            
        }else{
            
            NSLog(@" 采购商-有交易的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dataInit_dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberTradeList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
   
    
    //Time
    orderBy = @"2";
    [HttpManager sendHttpRequestForGetMemberTradeList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-有交易的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberTradeList_OrderByTimeDTO = [[GetMemberTradeListDTO alloc] init];
                
                [getMemberTradeList_OrderByTimeDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self refreshTableViewWithFirstOrSecondState:11];
            }
            
            
        }else{
            
            NSLog(@" 采购商-有交易的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberTradeList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    
    // *  3.38	采购商-我邀请的会员的列表接口
    //Money
    orderBy = @"1";
    [HttpManager sendHttpRequestForGetMemberInviteList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-我邀请的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberInviteList_OrderByMoneyDTO = [[GetMemberInviteListDTO alloc] init];
                
                [getMemberInviteList_OrderByMoneyDTO setDictFrom:[dic objectForKey:@"data"]];
                
                _memberInviteCountL.text = [NSString stringWithFormat:@"%@",getMemberInviteList_OrderByMoneyDTO.totalCount];
                
                [self refreshTableViewWithFirstOrSecondState:12];
            }
        }else{
            
            NSLog(@" 采购商-我邀请的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    //Time
    orderBy = @"2";
    [HttpManager sendHttpRequestForGetMemberInviteList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-我邀请的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberInviteList_OrderByTimeDTO = [[GetMemberInviteListDTO alloc] init];
                
                [getMemberInviteList_OrderByTimeDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self refreshTableViewWithFirstOrSecondState:13];
                
            }
        }else{
            
            NSLog(@" 采购商-我邀请的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    //Not Invited
    orderBy = @"3";
    [HttpManager sendHttpRequestForGetMemberInviteList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-我邀请的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getMemberInviteList_OrderByNotInviteDTO = [[GetMemberInviteListDTO alloc] init];
                
                [getMemberInviteList_OrderByNotInviteDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self refreshTableViewWithFirstOrSecondState:14];
                
            }
        }else{
            
            NSLog(@" 采购商-我邀请的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    
    // *  3.39	采购商-黑名单列表接口
    
    [HttpManager sendHttpRequestForGetMemberBlackList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                getMemberBlackListDTO = [[GetMemberBlackListDTO alloc] init];
                
                [getMemberBlackListDTO setDictFrom:dic];
                
                _memberBlackCountL.text = [NSString stringWithFormat:@"%@",getMemberBlackListDTO.totalCount];
                
                [self refreshTableViewWithFirstOrSecondState:3];
            }
            
        }else{
            
            NSLog(@" 采购商-黑名单列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

//从黑名单移出
- (void)removeFromBlackListNotification{
    
    // *  3.39	采购商-黑名单列表接口
    
    [HttpManager sendHttpRequestForGetMemberBlackList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                getMemberBlackListDTO = [[GetMemberBlackListDTO alloc] init];
                
                [getMemberBlackListDTO setDictFrom:dic];
                
                _memberBlackCountL.text = [NSString stringWithFormat:@"%@",getMemberBlackListDTO.totalCount];
                
                memberDTOArr = getMemberBlackListDTO.memberBlackDTOList;
                
                [self refreshTableViewWithFirstOrSecondState:3];
                
                [self getHttpDataAndRefreshTableView];
            }
            
        }else{
            
            NSLog(@" 采购商-黑名单列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return memberDTOArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccordingToTimeTableViewCell *accordingCell = [tableView dequeueReusableCellWithIdentifier:@"AccordingToTimeTableViewCell"];
    
    NormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    
    
    if (!accordingCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"AccordingToTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccordingToTimeTableViewCell"];
        accordingCell = [tableView dequeueReusableCellWithIdentifier:@"AccordingToTimeTableViewCell"];
    }
    
    if (!normalCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"NormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"NormalTableViewCell"];
        normalCell = [tableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    }
    
    // Configure the cell...
    if (_isAccordingToMoney) {
        [accordingCell changeToAccordingMoney];
    }else{
        [accordingCell changeToAccordingTime];
    }
    
    switch (_firstState) {
        case 1:
            accordingCell.memberDTO = memberDTOArr[indexPath.row];
            return accordingCell;
            break;
        case 2:
        {
            switch (_inviteButtonState) {
                case 12:
                    [accordingCell changeToAccordingMoney];
                    accordingCell.memberDTO = memberDTOArr[indexPath.row];
                    return accordingCell;
                    break;
                case 13:
                    [accordingCell changeToAccordingTime];
                    accordingCell.memberDTO = memberDTOArr[indexPath.row];
                    return accordingCell;
                    break;
                case 14:
                    [normalCell changeToBlackListState:NO];
                    normalCell.memberDTO = memberDTOArr[indexPath.row];
                    return normalCell;
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
            [normalCell changeToBlackListState:YES];
            normalCell.memberDTO = memberDTOArr[indexPath.row];
            return normalCell;
            break;
        default:
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_firstState==2&&_secondState==14) {
        return;
    }
    
    CPSBuyerDetailViewController *buyerDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSBuyerDetailViewController"];
    
    buyerDetailVC.memberDTO = memberDTOArr[indexPath.row];
    buyerDetailVC.isInBlackList = _firstState==3?YES:NO;
    
    [self.navigationController pushViewController:buyerDetailVC animated:YES];
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
