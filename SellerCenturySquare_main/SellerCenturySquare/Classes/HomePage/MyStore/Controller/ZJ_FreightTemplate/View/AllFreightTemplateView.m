//
//  AllFreightTemplateView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllFreightTemplateView.h"
#import "HttpManager.h"
//新建模版控制器
#import "NewTemplateViewController.h"
#import "FreightTemplateCell.h"
//#import "MailView.h"

#import "FreightplateMailView.h"
#import "FreightTempModel.h"
#import "FreightTempListModel.h"
#import "GUAAlertView.h"
//查看运费模版详情页面
#import "LookFreightTemplateViewController.h"

#import "CourierViewController.h"


#import "ZJ_TemplateiewController.h"

#import "AllFreightTemplateCell.h"

#import "FreightTemplateIntroduce.h"
@interface AllFreightTemplateView ()<UITableViewDataSource,UITableViewDelegate,FreightTemplateCellDelegate,FreightplateMailViewDelegate,AllFreightTemplateCellDelegate>
{
    //设置全局变量
    NSInteger lineNum;
    NSInteger section;
    
    FreightplateMailView *maiLView;
    
    NSString *isDefaultStr;
    //详情介绍
    FreightTemplateIntroduce *introduce;
}
//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;

//新建模版按钮
@property(nonatomic,strong)UIButton *templateButton;
//建立table
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UINavigationController *nav;
@end

@implementation AllFreightTemplateView


-(id)initWithFrame:(CGRect)frame nav:(UINavigationController *)nav
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.nav = nav;
        
        //设置UI
        [self makeUI];
        
        //进行数据刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataAllFreight) name:@"DataRefreshNotification" object:nil];
        
    }
    return self;
}

//重新刷新请求
-(void)refurbishAllFreightTemplateListDic:(NSNotification *)templateListDic
{
    FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
    
    freightTempListModel.freightTempDTOList = [templateListDic.userInfo objectForKey:@"data"];
    
    _infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
        
        [freightTempModel setDictFrom:dic];
        
    }
     [self.tableView reloadData];
}

//设置UI
-(void)makeUI
{
    //创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64 - 49) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    
    //创建模版按钮
    self.templateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.templateButton.frame = CGRectMake(0, self.frame.size.height - 49 - 64, self.frame.size.width, 49);
    self.templateButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [self.templateButton setTitle:@"新建模版" forState:(UIControlStateNormal)];
    
    [self.templateButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self addSubview:self.templateButton];
    
    //添加观察者
    [self.templateButton addTarget:self action:@selector(setNewTemplateButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark =============设置tableView代理方法===============

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"AllFreightTemplateCell";
    
    AllFreightTemplateCell * cell = (AllFreightTemplateCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == NULL) {
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AllFreightTemplateCell" owner:self options:nil] ;
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.delegate = self;
    
    cell.deleteButton.tag = indexPath.row;
    cell.ToViewButton.tag = indexPath.row;
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    [freightTempModel setDictFrom:_infoListArr[indexPath.row]];
    
    cell.freightTemplateName.text = freightTempModel.templateName;
    
    if ([freightTempModel.templateName isEqualToString:@"包邮"]) {
        cell.deleteButton.hidden = YES;
        cell.ToViewButton.hidden = YES;
        cell.PackageMailLabel.hidden = NO;
    }else
    {
        cell.deleteButton.hidden = NO;
        cell.ToViewButton.hidden = NO;
        cell.PackageMailLabel.hidden = YES;
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    NSDictionary *dictionary = _infoListArr[indexPath.row];
    [freightTempModel setDictFrom:dictionary];
    
    LookFreightTemplateViewController *lookFreightTemplateVC = [[LookFreightTemplateViewController alloc]init];
    
    lookFreightTemplateVC.Id = freightTempModel.Id;
    lookFreightTemplateVC.isDefault = freightTempModel.isDefault;
    
    lookFreightTemplateVC.lookTitle = freightTempModel.templateName;
    [self.nav pushViewController: lookFreightTemplateVC animated:YES];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  SCREEN_HIGHT - 64 - 49;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (!introduce ) {
        introduce = [[[NSBundle mainBundle]loadNibNamed:@"FreightTemplateIntroduce" owner:self options:nil]lastObject];
    }
   return introduce;
}


#pragma mark ======方法===

//模板进行查看
-(void)toViewFreightTemplateButton:(UIButton *)button
{
    section = button.tag;
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    NSDictionary *dictionary = _infoListArr[section];
    [freightTempModel setDictFrom:dictionary];
    
    LookFreightTemplateViewController *lookFreightTemplateVC = [[LookFreightTemplateViewController alloc]init];
    lookFreightTemplateVC.Id = freightTempModel.Id;
    lookFreightTemplateVC.lookTitle = freightTempModel.templateName;
    [self.nav pushViewController: lookFreightTemplateVC animated:YES];
    
}

//模板进行删除
-(void)deleteFreightTemplateButton:(UIButton *)button templateCell:(AllFreightTemplateCell *)templateCell
{
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    NSDictionary *dictionary = _infoListArr[button.tag];
    
    [freightTempModel setDictFrom:dictionary];

    //首先确认是批发端模板或者是零售端模板
    if ([freightTempModel.isWholesale isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //是不是批发端默认模板
        if ([freightTempModel.isWholesaleDefault isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            //批发模板进行弹框通知
            NSNotification *notification = [[NSNotification alloc]initWithName:@"WholesaleTemplateName" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
          
        }else
        {
            //对批发端不是默认模板进行删除
            [self dataID:freightTempModel.Id];
        }
    }else if ([freightTempModel.isRetail isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        //对零售模板进行判断
        
        if ([freightTempModel.isRetailDefault isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSNotification *notification = [[NSNotification alloc]initWithName:@"RetailTemplateName" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
          
        }else
        {
            //对批发端不是默认模板进行删除
            [self dataID:freightTempModel.Id];
        }
    }else
    {
        //对批发端不是默认模板进行删除
        [self dataID:freightTempModel.Id];

    }
}

//进行弹出框显示
-(void)dataID:(NSNumber *)templateDataID
{
    GUAAlertView *alert = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定删除运费模版?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self buttonTouchedAction:^{
        
        //删除运费模版
        [self deleteRequestForFreightTemplateDataID:templateDataID];
        
    } dismissAction:^{
        
    }];
    [alert show];

}

#pragma mark ======cell中代理方法=======
-(void)selectedBtn:(UIButton *)btn
{
    [self setDefaultBtn:btn];
}

#pragma marK ======删除运费模版=========

-(void)deleteRequestForFreightTemplateDataID:(NSNumber *)templateDataID
{
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"showDeleteFreightName" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];

    
    [HttpManager sendHttpRequestForFreightTemplateID:templateDataID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSNotification *notification = [[NSNotification alloc]initWithName:@"hideDeleteFreightName" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            
            [_infoListArr removeObjectAtIndex:section];
            //获取数据列表接口
            [self getDataAllFreight];
            

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error ===  %@",error);
        
    }];
    
}
#pragma mark ================新建观察者
-(void)setNewTemplateButtonAction
{
    ZJ_TemplateiewController  *templateiewC = [[ZJ_TemplateiewController alloc]init];
    templateiewC.templatemanage = 1;
    [self.nav pushViewController:templateiewC animated:YES];
    
}

#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.nav.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.nav popViewControllerAnimated:YES];
}

//获取数据列表接口
-(void)getDataAllFreight
{
    
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"ShowAllFreightName" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [HttpManager  sendHttpRequestForUpdateGetFreightTemplateListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _infoListArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSNotification *notification = [[NSNotification alloc]initWithName:@"HideAllFreightName" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            
            FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
            
            freightTempListModel.freightTempDTOList = [dic objectForKey:@"data"];
            
            _infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
            
            FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
            
            for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
                
                [freightTempModel setDictFrom:dic];
                
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


//进行通知删除
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DataRefreshNotification" object:nil];
}

@end
