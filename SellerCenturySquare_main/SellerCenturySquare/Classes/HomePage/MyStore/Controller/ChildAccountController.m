//
//  ChildAccountController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ChildAccountController.h"
#import "ChildAccountManagementCell.h"
#import "Masonry.h"

#import "AddChildAccountController.h"
#import "ChangeAccountController.h"
#import "HttpManager.h"
#import "MyUserDefault.h"
#import "ChildAccountZoneView.h"
#import "AddChildAccountController.h"

#import "MJRefresh.h"




@interface ChildAccountController ()<UITableViewDataSource ,UITableViewDelegate ,MBProgressHUDDelegate ,ChildAccountZoneViewDelegate>

//列表
@property (nonatomic ,strong) UITableView *tableView;

//接收子账号的数据
@property (nonatomic ,strong) NSArray *accountsArr;
//底部的View
@property (nonatomic ,strong) UIView *bottomView;

//下拉刷新
@property (nonatomic ,strong) MJRefreshComponent *pullDownRefresh;

@end

@implementation ChildAccountController
- (void)viewWillAppear:(BOOL)animated
{
    
    if (self.accountsArr.count !=0) {
        //采购车功能需要 每次进来都需要刷新一次
        [self.tableView.header beginRefreshing];
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //左按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tintColor = [UIColor blackColor];
    
    leftBtn.frame = CGRectMake(0, 0, 10,18);
    
    [leftBtn setImage:[UIImage imageNamed:@"nav_retrun_btn"] forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(popNavVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    

    //背景色
    self.view.backgroundColor = [UIColor colorWithRed:255/225.0f green:255/255.0f blue:255/225.0f alpha:1];

    [self requestNetData];
    
}

- (void)popNavVC:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  创建UI
 */
- (void)makeUI{
    
    //添加新的子账号
    [self addAccountView];

    //创建列表
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //添加
    [self.view addSubview:self.tableView];
    //布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
        
    }];

    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

/**
 *  解析后台数据
 *
 *  @param data 后台原始数据
 *
 *  @return 解析后的数据
 */
- (NSDictionary *)conversionWithData:(NSData *)data{
    
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}


/**
 *  设置添加子账号的view
 */
- (void)addAccountView
{
    //谁在底部视图
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    //背景
    bottomView.backgroundColor =  [UIColor colorWithRed:255/225.0f green:255/255.0f blue:255/225.0f alpha:1];
    [self.view addSubview:bottomView];
    
    //布局
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.height.equalTo(@123);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    //设置边界线
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1];
    [bottomView addSubview:lineLabel];
    //布局
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    //设置提示1
    UILabel *promptOne = [[UILabel alloc] init];
    promptOne.text = NSLocalizedString(@"childAccountpromptOne", @"1: 最多可增加10个子账号");
    
    [bottomView addSubview:promptOne];
    
    
    promptOne.font = [UIFont systemFontOfSize:13];
    promptOne.textColor = [UIColor colorWithRed:102/225.0f green:102/255.0f blue:102/225.0f alpha:1];
    
    
    [promptOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(20);
        make.left.equalTo(bottomView.mas_left).offset(15);
        
    }];
    //提示2
    UILabel *prompTwo = [[UILabel alloc] init];
    [bottomView addSubview:prompTwo];
    prompTwo.text = NSLocalizedString(@"childAccountpromptTwo", @"2: 子账号权限: 客服询单、采购单管理、商品推荐");
    prompTwo.font = [UIFont systemFontOfSize:13];
    prompTwo.textColor = [UIColor colorWithRed:102/225.0f green:102/255.0f blue:102/225.0f alpha:1];
    //布局
    [prompTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptOne.mas_bottom).offset(9);
        make.left.equalTo(promptOne.mas_left);
        
    }];
    
    
    //添加子账号按钮
    UIButton *addAccountBtn = [[UIButton alloc] init];
    addAccountBtn.backgroundColor = [UIColor blackColor];
    addAccountBtn.titleLabel.font = [UIFont  systemFontOfSize:13];
    
    [bottomView addSubview:addAccountBtn];
    
    //按钮标题
    [addAccountBtn setTitle:NSLocalizedString(@"childAccountAddBtn", @"+ 新添加子账号") forState:UIControlStateNormal];
    
    //按钮点击事件
    [addAccountBtn addTarget:self action:@selector(addAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //布局
    [addAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@46);
    }];
    
}

/**
 *  addAccountBtn按钮的点击事件
 *
 *  @param btn
 */
- (void)addAccountBtn:(UIButton *)btn
{
    
    if (self.accountsArr.count>=10) {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多添加10个子账号" preferredStyle:UIAlertControllerStyleAlert];
//        alertVC sh
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多添加10个子账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alertView show];
        
        
    }else{
        //跳转到添加页面
        AddChildAccountController *childVC = [[AddChildAccountController alloc] init];
        childVC.dataArr = self.accountsArr;
        
        [self.navigationController pushViewController:childVC animated:YES];
    }
   }

/**
 *  下拉刷新
 */
- (void)headRefresh
{
    ChildAccountController *weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestNetData];
        
    }];
    
}

#pragma mark -TableView  Delegate && DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.accountsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    ChildAccountManagementCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChildAccountManagementCell" owner:nil options:nil] lastObject];
    }
    
 tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *dict = self.accountsArr[indexPath.row];
    [cell  accountAllDict:dict];
    
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeAccountController *changeAccountVC = [[ChangeAccountController alloc] init];
    
    changeAccountVC.dataDict = self.accountsArr[indexPath.row];
    [self.navigationController pushViewController:changeAccountVC animated:YES];
    
}
/**
 *  请求数据
 */

- (void)requestNetData{
    

    [HttpManager sendHttpRequestForShowChildAccountPageNo:0 pageSize:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict =    [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self.tableView.header endRefreshing];
        
        if ([dict[@"code"] isEqualToString:@"000"]) {
            
            self.accountsArr = dict[@"data"];
            if (self.accountsArr.count !=0) {
                //标题
                NSString *str = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"childAccountManager", @"子账号管理"),self.accountsArr.count] ;
                
                self.title = str;


                if (!self.tableView) {
                    //创建TableView显示目前所有的子账号
                    [self makeUI];
                    
                    
                    //下拉刷新
                    [self headRefresh];
                    
                    //设置错误和成功提示
                    self.progressHUD.delegate = self;
                    [self.view bringSubviewToFront:self.progressHUD];
                    
           

                    
                }else
                {
                    [self.tableView reloadData];
 
                }
                

               
            }else
            {
                
                //标题
                NSString *str = [NSString stringWithFormat:@"%@",NSLocalizedString(@"childAccountManager", @"子账号管理")] ;
                
                self.title = str;
                

                ChildAccountZoneView *childZone = [[[NSBundle mainBundle] loadNibNamed:@"ChildAccountZoneView" owner:nil options:nil] lastObject];
                childZone.delegate = self;
                
                childZone.frame =  self.view.frame;
                [self.view addSubview:childZone];
                
                
                
            }

            
            
        }
        
    } failure:^(AFHTTPRequestOperation *opeation, NSError *error) {
        
        [self.tableView.header endRefreshing];
        
        
    }];
    

}

- (void)childAccountZoneAddChildAccount
{
    
    AddChildAccountController *addChild = [[AddChildAccountController alloc] init];
    addChild.block = ^()
    {
        [self requestNetData];
        
    };
    
    [self.navigationController pushViewController:addChild animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
