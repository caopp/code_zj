//
//  CPSSetBlackListViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSSetBlackListViewController.h"
#import "SetBlackListTableViewCell.h"
#import "SetLevelNoticeTableViewCell.h"
#import "CSPVIPUpdateViewController.h"

@interface CPSSetBlackListViewController ()<UIAlertViewDelegate>
@property (nonatomic,assign)BOOL hasJurisdiction;

@end

@implementation CPSSetBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.scrollEnabled = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkShopAuthority) name:kCheckShopAuthorityNotification object:nil];
    // Do any additional setup after loading the view.
    [self customBackBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self setIsInBlackListButtonState];
    
    [_addToBlackListButton setEnabled:_hasJurisdiction];
    if (_addToBlackListButton.enabled) {
        [_addToBlackListButton setBackgroundColor:[UIColor blackColor]];
    }else{
        [_addToBlackListButton setBackgroundColor:[UIColor grayColor]];
    }
    
    [self tabbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    
}

#pragma mark - HttpRequest
- (void)checkShopAuthority{
    
    CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
    
    [self.navigationController pushViewController:vipVC animated:YES];
}

- (void)addToBlackListRequest{
    
    if (!_memberNo) {
        return;
    }
    
    NSString *blackListFlag = _isInBlackList?@"0":@"1";
    
    [HttpManager sendHttpRequestForGetUpdateMemberBlackList: _memberNo  blackListFlag:blackListFlag success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单设置接口  返回正常编码");
            _isInBlackList = !_isInBlackList;
            
            [self setIsInBlackListButtonState];
            [self.tableView reloadData];
            
        }else{
            
            NSLog(@" 采购商-黑名单设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

#pragma mark - Private Functions
- (void)setLevel:(NSNumber *)level{
    
    _level = level;
    
    if (level) {
        
        if ([level integerValue]>=5) {
            
            _hasJurisdiction = YES;
            
        }else{
            
            _hasJurisdiction = NO;
        }
        
        _addToBlackListButton.enabled = _hasJurisdiction;
    }
}

- (void)setIsInBlackListButtonState{
    
    NSString *title;
    
    if (_isInBlackList) {
        title = @"将采购商从黑名单移出";
    }else{
        title = @"将采购商加入黑名单";
    }
    
    [_addToBlackListButton setTitle:title forState:UIControlStateNormal];
    [_addToBlackListButton setTitle:title forState:UIControlStateHighlighted];

}

- (IBAction)addToBlackListButtonClicked:(id)sender {
    
    NSString *msg ;
    
    if (_isInBlackList) {
        msg = @"确定将采购商移出黑名单";
    }else{
        msg = @"确定将采购商加入黑名单";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView cancelButtonIndex]!=buttonIndex) {
        
        [self addToBlackListRequest];
    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_hasJurisdiction) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetLevelNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNoticeTableViewCell"];
    
    SetBlackListTableViewCell *blackListCell = [tableView dequeueReusableCellWithIdentifier:@"SetBlackListTableViewCell"];
    
    if (!noticeCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SetLevelNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetLevelNoticeTableViewCell"];
        noticeCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNoticeTableViewCell"];
    }
    
    if (!blackListCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SetBlackListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetBlackListTableViewCell"];
        blackListCell = [tableView dequeueReusableCellWithIdentifier:@"SetBlackListTableViewCell"];
    }
    
    // Configure the cell...
    if (_hasJurisdiction) {
        
        switch (indexPath.section) {
            case 0:
                blackListCell.memberName = _memberName;
                blackListCell.isInBlackList = _isInBlackList;
                return blackListCell;
                break;
            default:
                return nil;
                break;
        }
    }else{
        
        switch (indexPath.section) {
            case 0:
                noticeCell.isBlackListNotice = YES;
                [noticeCell setNoticeInfo:[_level integerValue]];
                return noticeCell;
                break;
            case 1:
                blackListCell.memberName = _memberName;
                blackListCell.isInBlackList = _isInBlackList;
                return blackListCell;
                break;
            default:
                return nil;
                break;
        }
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
    
    if(section==0){
        return 0.1;
    }else{
        return 10;
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
