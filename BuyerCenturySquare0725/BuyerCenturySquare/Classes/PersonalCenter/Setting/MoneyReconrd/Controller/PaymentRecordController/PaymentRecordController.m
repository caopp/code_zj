//
//  PaymentRecordController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PaymentRecordController.h"
#import "PaymentRecordHeaderView.h"//!头部
#import "DealFlowRecordViewController.h"//!支付宝/微信充值记录
#import "BankCardRecordController.h"//!银行卡转账充值记录
#import "GetPayBalanceDTO.h"
#import "BalanceChargeViewController.h"//!充值
#import "LoginDTO.h"
#import "CCWebViewController.h"

@interface PaymentRecordController ()<UITableViewDataSource,UITableViewDelegate,DealFlowRecordViewControllerDelegate>
{

    UITableView *_tableView;
    NSArray *leftTitleArray ; //!左边数据的数组

    //!!支付宝/微信充值记录
    DealFlowRecordViewController * dealFlowVC;
    
    //!余额
    GetPayBalanceDTO * payBalanceDTO;
    
    BOOL isPay;
    
}

@end

@implementation PaymentRecordController

- (void)viewDidLoad {
    [super viewDidLoad];


    //!导航
    [self createNav];

    leftTitleArray = @[@"支付宝/微信充值记录",@"银行转账充值记录"];
    
    //!创建tableView
    [self createTableView];
    isPay = YES;
    

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    //!请求余额
    [self requestData];

    
}

#pragma mark 创建导航
-(void)createNav{
    
    self.title = @"预付货款充值记录";
    //!左导航
    [self addCustombackButtonItem];


    
}

#pragma mark 创建tableView
-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return leftTitleArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
        cell.accessoryView = [self accessView];

        [cell.textLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        
        //!分割线
        UILabel *filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
        [cell addSubview:filterLabel];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    cell.textLabel.text = leftTitleArray[indexPath.row];
    

    return cell;
}
//!tableViewCell 
-(UIView *)accessView{

    UIView * accessView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 12)];
    [accessView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *accImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, accessView.frame.size.width, accessView.frame.size.height)];

    [accImageView setImage:[UIImage imageNamed:@"10_设置_进入"]];
    [accessView addSubview:accImageView];
    

    return accessView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 115;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    PaymentRecordHeaderView * headerView = [[[NSBundle mainBundle]loadNibNamed:@"PaymentRecordHeaderView" owner:nil options:nil]lastObject];
    
    if (payBalanceDTO.totalAmount) {
        
        headerView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",payBalanceDTO.totalAmount.floatValue];

    }
    //!充值
    headerView.accountBtnClickBlock = ^(){

        
        [self rechargeClcik];
    
    };
    
    
    //!如果是苹果审核账号，则隐藏充值按钮
    if ([MyUserDefault loadIsAppleAccount]){
        
        headerView.accountBtn.hidden = YES;
        
    }

    
    return headerView;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
      [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row) {//!银行转账充值记录
        
        BankCardRecordController *bankVC = [[BankCardRecordController alloc]init];
        
        [self.navigationController pushViewController:bankVC animated:YES];
        

    }else{//!第0行：支付宝/微信支付记录
    
        
        CCWebViewController *webView = [[CCWebViewController alloc]init];
        webView.file = [HttpManager paymentRecordRequestWebView];
        webView.isPay = isPay;
        
        [self.navigationController pushViewController:webView animated:YES];
        

        /*
        dealFlowVC = [[DealFlowRecordViewController alloc]init];
        
        dealFlowVC.delegate = self;
    
        [self.navigationController pushViewController:dealFlowVC animated:YES];
        */
    }
    
    
}

//清除预付款交易记录缓存
-(void)removeDepositPrepaidPhoneRecordsCache
{
    [dealFlowVC.webView removeFromSuperview];
}

#pragma mark 请求余额
-(void)requestData{


    [HttpManager sendHttpRequestForGetPayBalance:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                /*
                 *  将请求过来的数据，封装到GetPayBalanceDT类里面 :
                 1.可用余额:availableAmount
                 2.被冻结的额度:freezeAmount
                 3.小B会员编号:memberNo
                 4.总共的余额(类型为Double,含冻结额度)
                 */
                payBalanceDTO = [[GetPayBalanceDTO alloc] init];
                
                [payBalanceDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [_tableView reloadData];
                
                
            }
            
            
        }else{
        
        
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];

        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];
        
    }];

    
}

#pragma mark  !充值
-(void)rechargeClcik{
    
    
    BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
    
    [self.navigationController pushViewController:balance animated:YES];

    
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
