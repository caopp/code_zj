//
//  CSPAdvancePaymentRecordTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAdvancePaymentRecordTableViewController.h"
#import "CSPIntegrationTableViewCell.h"
#import "CSPAdvancePaymentTableViewCell.h"
#import "GetPaymentsRecordsDTO.h"
#import "REMenu.h"
#import "SDRefresh.h"

@interface CSPAdvancePaymentRecordTableViewController ()<REMenuDelegate>

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) UIButton* titleButton;
@property (strong, nonatomic) GetPaymentsRecordsDTO *getPaymentsRecordsDTO;
@property (nonatomic, weak)   SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak)   SDRefreshFooterView *refreshFooter;

@end

@implementation CSPAdvancePaymentRecordTableViewController


#pragma mark -
#pragma mark Getter and Setter

- (GetPaymentsRecordsDTO*)getPaymentsRecordsDTO {
    if (!_getPaymentsRecordsDTO) {
        _getPaymentsRecordsDTO = [[GetPaymentsRecordsDTO alloc]init];
        _getPaymentsRecordsDTO.paymentsRecordsDTOList = [[NSMutableArray alloc]init];
    }
    return _getPaymentsRecordsDTO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预付货款收支记录";
    
    [self addCustombackButtonItem];

    REMenuItem *item1 = [[REMenuItem alloc] initWithTitle:@"全部" subtitle:nil image:nil highlightedImage:nil action:^(REMenuItem *item){
        NSAttributedString* title = [[NSAttributedString alloc]initWithString:@"预付货款收支记录" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
        
        SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
        
        [refreshHeader addToScrollView:self.tableView];
        self.refreshHeader = refreshHeader;
        
        __weak CSPAdvancePaymentRecordTableViewController * weakSelf = self;
        refreshHeader.beginRefreshingOperation = ^{
            
            NSString *type =@"";
            [weakSelf loadNewLetterListWithType:type];
        };
        
        // 进入页面自动加载一次数据
        [refreshHeader beginRefreshing];
        
        SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
        [refreshFooter addToScrollView:self.tableView];
        self.refreshFooter = refreshFooter;
        
        refreshFooter.beginRefreshingOperation = ^{
                
            NSString *type =@"";
            [weakSelf loadMoreLetterListWithType:type];
        };
       
    }];
    REMenuItem *item2 = [[REMenuItem alloc] initWithTitle:@"充值记录" subtitle:nil image:nil highlightedImage:nil action:^(REMenuItem *item){
        NSAttributedString* title = [[NSAttributedString alloc]initWithString:@" 充值记录" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
        
        SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
        
        [refreshHeader addToScrollView:self.tableView];
        self.refreshHeader = refreshHeader;
        
        __weak CSPAdvancePaymentRecordTableViewController * weakSelf = self;
        refreshHeader.beginRefreshingOperation = ^{
                
            NSString *type =@"1";
            [weakSelf loadNewLetterListWithType:type];
        };
        
        // 进入页面自动加载一次数据
        [refreshHeader beginRefreshing];
        
        SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
        [refreshFooter addToScrollView:self.tableView];
        self.refreshFooter = refreshFooter;
        
        refreshFooter.beginRefreshingOperation = ^{
                
            NSString *type =@"1";
            [weakSelf loadMoreLetterListWithType:type];
        };
        
    }];
    
    
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.titleButton = [[UIButton alloc]initWithFrame:titleView.bounds];
    NSAttributedString* title = [[NSAttributedString alloc]initWithString:@"预付货款收支记录" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(navigationTitleItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:self.titleButton];
    
    self.navigationItem.titleView = titleView;
    
    [self setupMenuWithItems:@[item1,item2]];
    
    SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPAdvancePaymentRecordTableViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        NSString *type =@"";
        [weakSelf loadNewLetterListWithType:type];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
    SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
            
        NSString *type =@"";
        [weakSelf loadMoreLetterListWithType:type];
    };
}

- (void)setupMenuWithItems:(NSArray*)items {
    
    self.menu = [[REMenu alloc] initWithItems:items];
    self.menu.delegate = self;
    
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
        
    }
    
    self.menu.backgroundColor = HEX_COLOR(0x666666F9);
    self.menu.backgroundAlpha = 1;
    self.menu.highlightedBackgroundColor = HEX_COLOR(0x99999933);
    self.menu.highlightedTextColor = HEX_COLOR(0xFFFFFFFF);
    self.menu.highlightedSeparatorColor = HEX_COLOR(0x99999966);
    self.menu.textColor = HEX_COLOR(0x999999FF);
    self.menu.separatorColor = HEX_COLOR(0x99999966);
    self.menu.separatorHeight = 0.5f;
    
    self.menu.font = [UIFont systemFontOfSize:15.0f];
    
    self.menu.itemHeight = 40.0f;
    
    // Blurred background in iOS 7
    //
    //self.menu.liveBlur = YES;
    //self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    //    self.menu.delegate = self;
    
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
    
}

- (void)navigationTitleItemClicked:(id)sender {
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.getPaymentsRecordsDTO.paymentsRecordsDTOList.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.

        if (section == 0) {
            return 1;
        }else{
            return self.getPaymentsRecordsDTO.paymentsRecordsDTOList.count ;
        }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPIntegrationTableViewCell *integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    CSPAdvancePaymentTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAdvancePaymentTableViewCell"];
    
    if (!integrationCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPIntegrationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPIntegrationTableViewCell"];
        integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    }
    
    if (!otherCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPAdvancePaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPAdvancePaymentTableViewCell"];

    }
    

    PaymentsRecordsDTO *otherMonthDTO;
        
        if (indexPath.section == 0) {
            integrationCell.titleLabel.text = @"预付货款余额";
            if (self.balance == nil) {
                integrationCell.integrationLabel.text = @"";
            }else{
                integrationCell.integrationLabel.text = [NSString stringWithFormat:@"￥%@",[CSPUtils stringFromNumber:self.balance]] ;
            }

//            integrationCell.integrationLabel.text = [CSPUtils stringFromNumber:self.balance];
            integrationCell.enterImageView.hidden = YES;
            return integrationCell;
        }else{
            NSMutableDictionary *otherDic = self.getPaymentsRecordsDTO.paymentsRecordsDTOList[indexPath.row];
            otherMonthDTO = [[PaymentsRecordsDTO alloc]init];
            [otherMonthDTO setDictFrom:otherDic];
            otherCell.serialNumberLabel.text = [NSString stringWithFormat:@"流水:%@",otherMonthDTO.recordId.stringValue];
            if ([otherMonthDTO.businessType isEqualToString:@"topup"]) {
                otherCell.orderNumberLabel.text = @"充值";
                otherCell.accountNumberLabel.text = [NSString stringWithFormat:@"+%@",[CSPUtils stringFromNumber:otherMonthDTO.amount]] ;
            }else if([otherMonthDTO.businessType isEqualToString:@"pay"])
            {
                otherCell.orderNumberLabel.text = [NSString stringWithFormat:@"采购单:%@",otherMonthDTO.outBizNo];
               otherCell.accountNumberLabel.text = [NSString stringWithFormat:@"-%@",[CSPUtils stringFromNumber:otherMonthDTO.amount]] ;
            }else
            {
                
            }
            
            otherCell.dateLabel.text = otherMonthDTO.createTime;
            
            return otherCell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
            return 128;
        }else
        {
            return 52;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        if (section == 0) {
            return 1;
        }else
        {
            return 10;
        }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}

#pragma mark -
#pragma mark Private Methods
- (void)getPaymentRecordsWith:(NSString *)type PageNo:(NSNumber*)pageNo  complete:(void (^)(NSNumber* totalCount, NSArray* listArray))complete {
    
    [HttpManager sendHttpRequestForGetPaymentsRecords:type pageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPaymentsRecordsDTO *getPaymentsRecordsDTO = [[GetPaymentsRecordsDTO alloc ]init];
                //                PaymentsRecordsDTO *paymentsRecordsDTO = [[PaymentsRecordsDTO alloc ]init];
                
                [getPaymentsRecordsDTO setDictFrom:[dic objectForKey:@"data"]];
                
//                self.listArray = getPaymentsRecordsDTO.paymentsRecordsDTOList;
                self.balance = getPaymentsRecordsDTO.balance;
                complete(getPaymentsRecordsDTO.totalCount,getPaymentsRecordsDTO.paymentsRecordsDTOList);
                [self.refreshHeader endRefreshing];
                [self.refreshFooter endRefreshing];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
        [self.refreshFooter endRefreshing];
        
    }];
    
}

- (void)loadNewLetterListWithType:(NSString *)type{
    [self getPaymentRecordsWith:type PageNo:@1 complete:^(NSNumber *totalCount, NSArray *listArray) {
        self.getPaymentsRecordsDTO.totalCount = totalCount;
        [self.getPaymentsRecordsDTO.paymentsRecordsDTOList removeAllObjects];
        [self.getPaymentsRecordsDTO.paymentsRecordsDTOList addObjectsFromArray:listArray];
        [self.tableView reloadData];
        
        [self.refreshHeader endRefreshing];
    }];
    
}

- (void)loadMoreLetterListWithType:(NSString *)type {
//    if ([self.tableView.footer isRefreshing]) {
//        NSLog(@"isRefreshing");
//    }
    if (self.getPaymentsRecordsDTO.totalCount.integerValue <= self.getPaymentsRecordsDTO.paymentsRecordsDTOList.count) {
        [self.refreshFooter endRefreshing];
        return;
    }
    
    NSNumber * pageNo = [NSNumber numberWithInteger:(self.getPaymentsRecordsDTO.paymentsRecordsDTOList.count /pageSize) + 1];
    [self getPaymentRecordsWith:type PageNo:pageNo complete:^(NSNumber *totalCount, NSArray *listArray) {
        self.getPaymentsRecordsDTO.totalCount = totalCount;
        [self.getPaymentsRecordsDTO.paymentsRecordsDTOList addObjectsFromArray:listArray];
        
        [self.tableView reloadData];
        
        [self.refreshFooter endRefreshing];
    }];
}

@end
