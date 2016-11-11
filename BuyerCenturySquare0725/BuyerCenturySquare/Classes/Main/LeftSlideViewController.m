//
//  LeftSlideViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LeftSlideViewController.h"
#import "CommodityClassification.h"
#import "CommodityClassificationDTO.h"
#import "GoodsClassViewController.h"
#import "SWRevealViewController.h"
#import "CSPBlackNavigationController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
//一级分类
#import "REMenuItem.h"
#import "ChannelDTO.h"
#import "MerchantLeftSlideCell.h"

@interface LeftSlideViewController ()<UITableViewDataSource ,UITableViewDelegate>
{

    NSIndexPath * firstSelectPath;

}

@property (nonatomic ,strong) CommodityClassification *commoditClassData;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *firstDataArr;//!第一组

@property (nonatomic,strong) NSMutableArray * channelArray;

@end

@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstDataArr = @[@"商品分类",@"全部商品"];

    //!status部分
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    [self.view addSubview:statusView];
    
    
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame), self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    //设置tableView的背景颜色
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    
    
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //去掉横线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加到主视图中
    [self.view addSubview:self.tableView];
    
    //!请求数据
    [self requestData];

}

#pragma mark - delegate&&dataSource
//section的
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;//!商品分类、频道
    
    
}

//cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {//!商品分类
        
        return self.firstDataArr.count;
        
    }else{//!频道
    
        return self.channelArray.count;
    }
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    MerchantLeftSlideCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {

        cell = [[[NSBundle mainBundle]loadNibNamed:@"MerchantLeftSlideCell" owner:self options:nil]lastObject];

        //!选中的背景
        UIView * selectBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectBgView.backgroundColor = [UIColor colorWithHexValue:0x2d2d2d alpha:1];
        cell.selectedBackgroundView = selectBgView;
        

        //!未选中的设置背景
        cell.contentView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        
    }
    //!默认隐藏
    cell.leftFilterLabel.hidden = YES;
    cell.rightFilterLabel.hidden = YES;
    
    if (indexPath.section == 0) {//!商品
        
        cell.classNameLabel.text = [self.firstDataArr objectAtIndex:indexPath.row];
        //!判断是否是该段的最后一行，是的话显示分割线
        if (indexPath.row == self.firstDataArr.count - 1) {
            
            cell.leftFilterLabel.hidden = NO;
            cell.rightFilterLabel.hidden = NO;

        }
        
    }else if (indexPath.section == 1){//!频道
    
        if (self.channelArray.count) {
            
            ChannelDTO *  channelDTO = self.channelArray[indexPath.row];
            cell.classNameLabel.text = channelDTO.channelName;

        }
        
        //!判断是否是该段的最后一行，是的话显示分割线
        if (indexPath.row == self.channelArray.count - 1 ) {
            
            cell.leftFilterLabel.hidden = NO;
            cell.rightFilterLabel.hidden = NO;
            
        }

    }
    
    //!如果是当前选中的类别，就把当前选中类别的的文字颜色修改
    if ([self.selectClassName isEqualToString:cell.classNameLabel.text]) {
        
        //!选中的背景颜色
        cell.contentView.backgroundColor = [UIColor colorWithHexValue:0x2d2d2d alpha:1];
        
        firstSelectPath = indexPath;
        
    }
    
    
    
    
    
    return cell;
}

//底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

//头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
    
}

//cell的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //!改变进入界面选中的那一行
    if (firstSelectPath) {
        
        UITableViewCell * firstCell = [tableView cellForRowAtIndexPath:firstSelectPath];
        
        //!未选中的颜色
        firstCell.contentView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];

        
    }
    
    //!选中的那一行
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //1、收回侧拉框
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *vc = appDelegate.viewController;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController pushFrontViewController:vc animated:YES];
    
    //2、判断如果点击的是 和进来的时候的同一个选项，那就不进行 跳转的操作
    if ([self.selectClassName isEqualToString:cell.textLabel.text]) {
        
        return ;
    }
    
    
    if (indexPath.section == 0) {//!商品
        
        if (indexPath.row == 0) {//!商品分类
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"className" object:nil];

        }else if (indexPath.row == 1){//!全部商品
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allGoodsList" object:nil];

        }
        
    }else if (indexPath.section == 1){//!频道
    
        ChannelDTO * channelDTO = self.channelArray[indexPath.row];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"intoChannel" object:nil userInfo:@{@"id":channelDTO.ids,@"channelName":channelDTO.channelName,@"channelImg":channelDTO.channelImg}];
        
    
    }
    
    //!为了防止贱贱的用户多次点击cell 导致跳多个页面，所以点击完之后先让tableView不可以再点击
    _tableView.userInteractionEnabled = NO;
    
    
   

}
#pragma mark 请求数据
-(void)requestData{

    
    [HttpManager sendHttpRequestFoChannelListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:CODE] isEqualToString:@"000"]) {
          
            self.channelArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * channelDic in dic[@"data"]) {
                
                ChannelDTO * channelDTO = [[ChannelDTO alloc]initWithDictionary:channelDic];
                [self.channelArray addObject:channelDTO];
                
            }
        
            [_tableView reloadData];
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        
        
        
    }];
    
    
    

}

-(void)viewWillAppear:(BOOL)animated{

    [_tableView reloadData];
    
    //!为了防止贱贱的用户多次点击cell 导致跳多个页面，所以点击完之后先让tableView不可以再点击,这里需要打开
    _tableView.userInteractionEnabled = YES;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
