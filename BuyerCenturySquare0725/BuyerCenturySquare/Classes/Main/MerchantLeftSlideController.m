//
//  MerchantLeftSlideController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantLeftSlideController.h"

#import "MerchantLeftSlideCell.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

#import "MerchantHotLabelDTO.h"

@interface MerchantLeftSlideController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView * _tableView;


}
@property(nonatomic,strong)NSArray * classDataArray;


@end

@implementation MerchantLeftSlideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建界面
    [self createUI];

    //!请求数据
    [self requestData];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //!为了防止贱贱的用户多次点击cell 导致跳多个页面，所以点击完之后先让tableView不可以再点击,这里需要打开
    _tableView.userInteractionEnabled = YES;


}
#pragma mark 创建界面
-(void)createUI{
    
    //!status部分
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithHexValue:0x2d2d2d alpha:1];
    [self.view addSubview:statusView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame) , self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundColor:[UIColor colorWithHexValue:0x333333 alpha:1]];
    [self.view addSubview:_tableView];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.classDataArray.count + 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MerchantLeftSlideCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MerchantLeftSlideCell" owner:self options:nil]lastObject];
        
        //!选中的背景
        UIView * selectBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectBgView.backgroundColor = [UIColor colorWithHexValue:0x2d2d2d alpha:1];
        cell.selectedBackgroundView = selectBgView;
        
        
        
    }
    if (self.classDataArray.count) {
        
        if (indexPath.row == 0) {
            
            cell.classNameLabel.text = @"全部商家";
            
            //!分割线不隐藏
            cell.leftFilterLabel.hidden = NO;
            cell.rightFilterLabel.hidden = NO;
            //!选中的背景颜色
            cell.contentView.backgroundColor = [UIColor colorWithHexValue:0x2d2d2d alpha:1];

            
        }else{
        
            MerchantHotLabelDTO * hotDTO = self.classDataArray[indexPath.row - 1];
            
            cell.classNameLabel.text = hotDTO.labelCategory;
            
            //!分割线隐藏
            cell.leftFilterLabel.hidden = YES;
            cell.rightFilterLabel.hidden = YES;

            //!未选中的设置背景
            cell.contentView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            
            
        }
        

    }
    
    
    return cell;

}


#pragma mark 请求数据
-(void)requestData{

    [HttpManager sendHttpRequestForHotLabelListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:CODE] isEqualToString:@"000"]) {
            
            if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];

                for (NSDictionary * labelDic in dic[@"data"]) {
                    
                    MerchantHotLabelDTO * hotLabel = [[MerchantHotLabelDTO alloc]initWithDictionary:labelDic];
                    
                    [tempArray addObject:hotLabel];
                    
                }
                
                //!按id排序
                NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
                
                NSArray * sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                
                self.classDataArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
                
                [_tableView reloadData];
                
            }
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        
    }];
    
    
    /*
    //请求所有分类数据  0查询商家
    [HttpManager sendHttpRequestForGetCategoryListWithMerchantNo:@"" withQueryType:@"0"  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:CODE] isEqualToString:@"000"]) {
            //创建数据模型
           CommodityClassification * commoditClassData = [[CommodityClassification alloc] initWithDictionaries:[dic objectForKey:@"data"]];
            
            //!按id排序
            NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"id" ascending:YES];
            
            NSArray * sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            self.classDataArray = [commoditClassData.primaryCategory sortedArrayUsingDescriptors:sortDescriptors];
            
            
//            self.classDataArray = commoditClassData.primaryCategory;
            
            
            
            [_tableView reloadData];

            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
        
    
    }];
     */



}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 60;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //!先把已经选择的“全部商家”颜色改变回来
    NSIndexPath * allMerchantIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MerchantLeftSlideCell * allMerchantCell = [tableView cellForRowAtIndexPath:allMerchantIndexPath];

    allMerchantCell.contentView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    
    
    
    //!收起侧拉出来的框
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *vc = appDelegate.viewController;
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController pushFrontViewController:vc animated:YES];
    
    
    
    if (indexPath.row != 0) {
        
        //!发送通知，跳转到对应的商家列表
        MerchantHotLabelDTO * hotDTO = self.classDataArray[indexPath.row - 1];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MerchantSearchResult" object:nil userInfo:@{@"categoryNo":hotDTO.categoryNo,@"categoryName":hotDTO.labelCategory}];

        
    }
    
    //!为了防止贱贱的用户多次点击cell 导致跳多个页面，所以点击完之后先让tableView不可以再点击
   _tableView.userInteractionEnabled = NO;
    
    
}


//!去除底部的线
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{


    UIView * footerView = [[UIView alloc]init];
    
    footerView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    
    return footerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 0.0001;

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
