//
//  CPSResetBuyerLevelViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSResetBuyerLevelViewController.h"
#import "SetLevelBuyerInfoTableViewCell.h"
#import "SetLevelNormalTableViewCell.h"
#import "SetLevelNoticeTableViewCell.h"
#import "CSPVIPUpdateViewController.h"

@interface CPSResetBuyerLevelViewController ()<UIAlertViewDelegate>
@property (nonatomic,assign)BOOL hasJurisdiction;
@property (nonatomic,assign)NSInteger selectedRow;
@property (nonatomic,assign)NSInteger levelRow;

@end

@implementation CPSResetBuyerLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setLevelSelected:) name:kSetLevelSelectedLevelStateNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkShopAuthority) name:kCheckShopAuthorityNotification object:nil];
    [self customBackBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [_modLevelButton setEnabled:_hasJurisdiction];
    if (_modLevelButton.enabled) {
        [_modLevelButton setBackgroundColor:[UIColor blackColor]];
    }else{
        [_modLevelButton setBackgroundColor:[UIColor grayColor]];
    }
    
    [self tabbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    
}

#pragma mark - HttpRequest
- (void)resetBuyerShopLevelRequest:(NSNumber*)level{
    
    if (!_memberNo) {
        return;
    }
    
    [HttpManager sendHttpRequestForGetMemberLevelSet:_memberNo level:level success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-店铺等级设置接口  返回正常编码");
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            NSLog(@" 采购商-店铺等级设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberLevelSet 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

#pragma mark - Private Functions
- (void)checkShopAuthority{
    
    CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
    
    [self.navigationController pushViewController:vipVC animated:YES];
}

- (void)setLevelSelected:(NSNotification*)note{
    
    
    NSDictionary *dic = [note userInfo];

    NSString *rowStr = dic[@"row"];
    
    NSInteger row = [rowStr integerValue];
    
    _selectedRow = row;
    
    [self.tableView reloadData];
}


- (void)setTradeLevel:(NSNumber *)tradeLevel{
    
    if (tradeLevel) {
        
        _tradeLevel = tradeLevel;
        
        _levelRow = 7-[tradeLevel integerValue];
    }else{
        
        _levelRow = 6;
    }

}

- (void)setShopLevel:(NSNumber *)shopLevel{
    
    if (shopLevel) {
        
        _shopLevel = shopLevel;
        
        _selectedRow = 6-[shopLevel integerValue];
    }else{
        
        _selectedRow = -1;
        
    }
}

- (IBAction)confirmModifyLevel:(id)sender {
    
    NSString *msg = [NSString stringWithFormat:@"确定将采购商等级从V%@调为V%zi",_shopLevel,6-_selectedRow];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex!=[alertView cancelButtonIndex]) {
        
        if (_selectedRow!=-1) {
            
            NSNumber *newLevel = [NSNumber numberWithInteger:6-_selectedRow];
            
            [self resetBuyerShopLevelRequest:newLevel];
        }
    }
}

//是否有权限
- (void)setLevel:(NSNumber *)level{
    
    _level = level;
    
    if (level==nil) {
        return;
    }
    
    if ([level integerValue]>=5) {
        
        _hasJurisdiction = YES;
        
    }else{
        
        _hasJurisdiction = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_hasJurisdiction) {
        return 2;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasJurisdiction) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return _levelRow;
                break;
            default:
                break;
        }
    }else{
        
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return _levelRow;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetLevelBuyerInfoTableViewCell *buyerInfoCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelBuyerInfoTableViewCell"];
    
    SetLevelNormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNormalTableViewCell"];
    
    SetLevelNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNoticeTableViewCell"];
    
    if (!buyerInfoCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SetLevelBuyerInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetLevelBuyerInfoTableViewCell"];
        buyerInfoCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelBuyerInfoTableViewCell"];
    }
    
    if (!normalCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SetLevelNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetLevelNormalTableViewCell"];
        normalCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNormalTableViewCell"];
    }
    
    if (!noticeCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SetLevelNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetLevelNoticeTableViewCell"];
        noticeCell = [tableView dequeueReusableCellWithIdentifier:@"SetLevelNoticeTableViewCell"];
    }
    
    
    // Configure the cell...
    
    if (_hasJurisdiction) {
        
        switch (indexPath.section) {
            case 0:
                buyerInfoCell.nameL.text = [NSString stringWithFormat:@"%@",_memberName];
                [buyerInfoCell setLevel:[_tradeLevel integerValue]];
                return buyerInfoCell;
                break;
            case 1:
                normalCell.index = indexPath.row;
                [normalCell setDisplayLevel:6-indexPath.row];
                [normalCell.selectButton setEnabled:YES];
                if (indexPath.row==_selectedRow) {
                    
                    [normalCell setSelectState:YES];
                }else{
                    
                    [normalCell setSelectState:NO];
                }
                return normalCell;
                break;
            default:
                return nil;
                break;
        }

        
    }else{
        
        switch (indexPath.section) {
            case 0:
                noticeCell.isBlackListNotice = NO;
                [noticeCell setNoticeInfo:[_level integerValue]];
                return noticeCell;
            case 1:
                buyerInfoCell.nameL.text = [NSString stringWithFormat:@"%@",_memberName];
                [buyerInfoCell setLevel:[_tradeLevel integerValue]];
                return buyerInfoCell;
                break;
            case 2:
                normalCell.index = indexPath.row;
                [normalCell setDisplayLevel:6-indexPath.row];
                if (indexPath.row==_selectedRow) {
                    
                    [normalCell setSelectState:YES];
                }else{
                    
                    [normalCell setSelectState:NO];
                    [normalCell.selectButton setEnabled:NO];
                }
                
                return normalCell;
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
