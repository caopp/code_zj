//
//  GoodsTemplateViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsTemplateViewController.h"
#import "HttpManager.h"
#import "FreightTempModel.h"
#import "FreightTempListModel.h"
#import "GoodsTemplateViewCell.h"
#import "LookFreightTemplateViewController.h"
@interface GoodsTemplateViewController ()<UITableViewDataSource,UITableViewDelegate,GoodsTemplateViewCellDelegate>
//建立table
@property(nonatomic,strong)UITableView *tableView;
//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;
@end

@implementation GoodsTemplateViewController

//收货地址信息
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取数据列表接口
    [self getData];
    
}
//获取数据列表接口
-(void)getData
{
    
    [HttpManager sendHttpRequestForUpdateGetFreightTemplateListPageNo:nil pageSize:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _infoListArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
            
            freightTempListModel.freightTempDTOList = [dic objectForKey:@"data"];
            
            _infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
            
            NSLog(@"数据请求成功");
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==== %@",error);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"运费模版";
    
    //设置返回按钮
    [self customBackBarButton];
    //设置UI
    [self makeUI];
    
}

//设置UI
-(void)makeUI
{
    //创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    [self.view addSubview:self.tableView];

}

#pragma mark =============设置tableView代理方法===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _infoListArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellID = @"GoodsTemplateViewCell";
    GoodsTemplateViewCell * cell = (GoodsTemplateViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == NULL) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsTemplateViewCell" owner:self options:nil] ;
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.delegate = self;
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    [freightTempModel setDictFrom:_infoListArr[indexPath.section]];
    
    cell.templateNameLabel.text = freightTempModel.templateName;

    cell.selectedButton.tag = indexPath.section;
    
    
    NSLog(@"self.goodsTemplateID === %@",self.goodsTemplateID);
    //模版为空的话进行处理
    if ([self.goodsTemplateID isEqualToString:@""]) {
        
        if ([freightTempModel.isDefault isEqualToString:@"0"]) {
            
            cell.selectedButton.selected = YES;
            
        }
        if ([freightTempModel.isDefault isEqualToString:@"2"]) {
            if ([freightTempModel.sysDefault isEqualToString:@"0"]) {
                cell.selectedButton.selected = YES;
            }
        }
        
    }
    
    //更改模版（模版不为控进行处理）
    
    NSLog(@"self.goodsTemplateID == %@",self.goodsTemplateID);
    
    if (![self.goodsTemplateID isEqualToString:@""]) {
        
        if (self.goodsTemplateID == [NSString stringWithFormat:@"%@",freightTempModel.Id]) {
            cell.selectedButton.selected = YES;
        }else
        {
            cell.selectedButton.selected = NO;
        }
    }
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    LookFreightTemplateViewController *lookVC = [[LookFreightTemplateViewController alloc]init];
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    lookVC.lookManager = goodsLookManager;
    
    [freightTempModel setDictFrom:_infoListArr[indexPath.section]];
    
    lookVC.goodID = freightTempModel.Id;
    
    lookVC.isDefault = freightTempModel.isDefault;

    lookVC.productTitle = freightTempModel.templateName;
    
    [self.navigationController pushViewController:lookVC animated:YES];
    
}

#pragma sel 
//添加设置默认接口
-(void)selectedBtn:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
   
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    [freightTempModel setDictFrom:_infoListArr[btn.tag]];
    
    NSLog(@"_infoListArr ==== %@",_infoListArr);
    
    
    //进行模板设置

    if ([[NSString stringWithFormat:@"%@",freightTempModel.Id] isEqualToString:@""]) {
        
        [self getTemplateDataDefalt:@"0"  goodsTemplateID:freightTempModel.Id templateName:freightTempModel.templateName];
        
    }else
    {
        [self getTemplateDataDefalt:@"1"  goodsTemplateID:freightTempModel.Id templateName:freightTempModel.templateName];
    }
  
}

#pragma data

-(void)getTemplateDataDefalt:(NSString *)isDefault  goodsTemplateID:(NSNumber *)goodsTemplateID templateName:(NSString *)templateName
{
    
    //设置默认请求
    [HttpManager sendHttpRequestForFtGoodsNo:self.goodNo  ftTemplateId:goodsTemplateID isDefault:isDefault success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.goodsTemplateID = [NSString stringWithFormat:@"%@",goodsTemplateID];
            
            self.templateBlock(templateName,self.goodsTemplateID);
    
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
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
