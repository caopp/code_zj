//
//  LookFreightTemplateViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LookFreightTemplateViewController.h"
#import "LookFerightTempModel.h"
#import "LookFerightTempListModel.h"
#import "LookFreightTemplateCell.h"
#import "NewTemplateViewController.h"
#import "ZJ_TemplateiewController.h"
@interface LookFreightTemplateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
//设置可变数组队数据进行接受
@property (nonatomic,strong)NSMutableArray *arrList;
//选择类型字符串
@property (nonatomic,strong)NSString *type;
//新建模版按钮
@property(nonatomic,strong)UIButton *templateButton;

//模版的ID
@property (nonatomic,strong)NSNumber *templateID;

//模版名字
@property (nonatomic,strong)NSString *templateName;

@end

@implementation LookFreightTemplateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.lookManager == goodsLookManager) {
        
        [self getDataID:self.goodID];
    }else
    {
        [self getDataID:self.Id];

    }
}

-(NSMutableArray *)arrList
{
    if ( _arrList == nil) {
        _arrList = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.lookManager == goodsLookManager) {
        self.title = self.productTitle;
    }else
    {
        //题目
        self.title = self.lookTitle;
    }
    
    //设置返回按钮
    [self customBackBarButton];
    //设置UI
    [self makeUI];
}

#pragma mark =====获得data=====
-(void)getDataID:(NSNumber *)dataID
{

    [HttpManager sendHttpRequestForGetFreightTemplateInfo:dataID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
        
            LookFerightTempListModel * lookFerightTempListModel = [[LookFerightTempListModel alloc]init];
            
            lookFerightTempListModel.lookFerightTempDTOList = [[dic objectForKey:@"data"]objectForKey:@"settingList"];
            
            self.type = [[dic objectForKey:@"data"]objectForKey:@"type"];
            
            self.templateID = [[dic objectForKey:@"data"]objectForKey:@"id"];
            
            self.templateName = [[dic objectForKey:@"data"]objectForKey:@"templateName"];
            self.title = self.templateName;
            
            _arrList = [lookFerightTempListModel.lookFerightTempDTOList mutableCopy];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma  mark =========设置ui==========
-(void)makeUI
{
    self.tableView = [[UITableView alloc]init];
    
    if (self.lookManager ==  goodsLookManager) {
        
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 49 - 64);
    }else
    {
        if ([self.isDefault isEqualToString:@"2"]) {
           self.tableView.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 64);
        }else{
        self.tableView.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 49 - 64);
        }
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    // 创建模版按钮
    self.templateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    //进行浮框显示
    if ([self.isDefault isEqualToString:@"2"]) {
//        self.templateButton.frame = CGRectMake(0, self.view.frame.size.height  - 64, self.view.frame.size.width, 0);
        self.templateButton.hidden = YES;
        [self.templateButton setBackgroundColor:[UIColor clearColor]];
        
    }else
    {
        self.templateButton.frame = CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49);
        self.templateButton.hidden = NO;
    }

    self.templateButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    [self.templateButton setTitle:@"修改模版" forState:(UIControlStateNormal)];
    
    [self.templateButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    
    [self.templateButton addTarget:self action:@selector(joinNextPage) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.templateButton];

}


#pragma mark =====进入修改模板====
-(void)joinNextPage
{
    ZJ_TemplateiewController *templateiewVC = [[ZJ_TemplateiewController alloc]init];
    templateiewVC.templatemanage = 2;
    
    templateiewVC.templateID = self.templateID;
    
    templateiewVC.type = self.type;
    
    templateiewVC.lookList = _arrList;
    
    templateiewVC.templateName = self.templateName;
    
    [self.navigationController pushViewController:templateiewVC animated:YES];
}

#pragma mark ==========tableView代理方法==========
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    LookFreightTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[LookFreightTemplateCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LookFerightTempModel *lookFerightTempModel = [[LookFerightTempModel alloc]init];
    [lookFerightTempModel setDictFrom:_arrList[indexPath.row]];
    if (self.isDefault.integerValue == 2) {
        cell.cityLabel.hidden = YES;
    }else
    {
        cell.cityLabel.hidden = NO;
    }
    [cell getLookFreightTemplateCellData:lookFerightTempModel type:self.type selectedDefault:self.isDefault];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    LookFreightTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
           cell = [[LookFreightTemplateCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    LookFerightTempModel *lookFerightTempModel = [[LookFerightTempModel alloc]init];
    [lookFerightTempModel setDictFrom:_arrList[indexPath.row]];
    [cell getLookFreightTemplateCellData:lookFerightTempModel type:self.type selectedDefault:self.isDefault];
    NSLog(@"cell.numFloat %lf", cell.numFloat);
    return cell.numFloat + 9;
}


#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}

//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
