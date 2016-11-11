//
//  CSMoneyReconrdViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/18.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CSMoneyReconrdViewController.h"
#import "CustomBarButtonItem.h"
#import "CSPConsumptionPointsRecordTableViewController.h"
#import "CSPAdvancePaymentRecordTableViewController.h"
#import "DealFlowViewController.h"
#import "DownloadedRecordsViewController/DownloadedRecordsViewController.h"
#import "ScoreRecordViewController.h"
#import "AdvancePaymentRecordsViewController.h"
#import "DealFlowRecordViewController.h"
#import "PaymentRecordController.h"//!预付货款充值记录
#import "MembershipGradeRulesViewController.h"
#import "MoneyReconrdCell.h"
#import "CCWebViewController.h"

@interface CSMoneyReconrdViewController ()<UITableViewDataSource,UITableViewDelegate,AdvancePaymentRecordsViewControllerDelegate,DealFlowRecordViewControllerDelegate,ScoreRecordViewControllerDelagate,CCWebViewControllerDelegate>
{
    NSArray *imageNameArray;// !图片名字
    NSArray *titleArray; // !每行名称
    //清除交易流水缓存
    AdvancePaymentRecordsViewController *advancePaymentRecordsVC;
    
    //清除预付款充值记录缓存
    DealFlowRecordViewController *dealFlowVC;
    //清除消费积分记录缓存
    ScoreRecordViewController *scoreRecordVC;
    
    BOOL isFlow;
    
    BOOL isRecond;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation CSMoneyReconrdViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark 组合数据

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isFlow = YES;
    isRecond = YES;
    
    //设置title
    self.title = @"资金交易记录";
    
    [self addCustombackButtonItem];
    
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xef0f0f0 alpha:1];

//    self.tableView.backgroundColor = [UIColor clearColor];
    
//    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //线顶头
    /*
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
     */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick) target:self]];
    
}

-(void)backBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //!如果是苹果审核账号，去除下载次数购买记录行
    if ([MyUserDefault loadIsAppleAccount]) {
        
        return 2;
    }
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 9;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        
            return 2;
            
            break;
            
            case 1:
            return 1;
            break;
            
            case 2:
            return 1;
            break;
        default:
            break;
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 9)];
    view.backgroundColor = [UIColor colorWithHexValue:0xef0f0f0 alpha:1];
    return view;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyReconrdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[MoneyReconrdCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        //设置cell text的字体样式
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
        
    }
      switch (indexPath.section) {
         case 0:
            if (indexPath.row == 0) {
               cell.textLabel.text = @"交易流水";
               

            }else
            {
                cell.textLabel.text = @"预付货款充值记录";
                cell.lineLabel.hidden = YES;
            }
            break;
        case 1:
            cell.textLabel.text = @"消费积分记录";
              cell.lineLabel.hidden = YES;

            break;
            
         case 2:
            
            cell.textLabel.text = @"下载次数购买记录";
              cell.lineLabel.hidden = YES;

            break;
        default:
            break;
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                case 0://!交易流水
                {
                    
                    //!如果是苹果审核账号，交易流水进行更改
                    if ([MyUserDefault loadIsAppleAccount]) {
                                                
                        MembershipGradeRulesViewController *membership = [[MembershipGradeRulesViewController alloc]init];
                        [self.navigationController pushViewController:membership animated:YES];
                       
                    }else
                    {
                        
                        CCWebViewController *webView = [[CCWebViewController alloc]init];
                        webView.file = [HttpManager advancePaymentRequestWebView];
                        webView.isOK = isFlow;
                        
                    
                        [self.navigationController pushViewController:webView animated:YES];
                        
                        
//                        advancePaymentRecordsVC = [[AdvancePaymentRecordsViewController alloc]init];
//                        advancePaymentRecordsVC.delegate = self;
//                        [self.navigationController pushViewController:advancePaymentRecordsVC animated:YES];
                        
                    }

                }
                    break;
                    
                    case 1://!预付货款充值记录
                    
                {
//                    dealFlowVC = [[DealFlowRecordViewController alloc]init];
//                    dealFlowVC.delegate = self;
//                    [self.navigationController pushViewController:dealFlowVC animated:YES];
                    
                    PaymentRecordController *payVC = [[PaymentRecordController alloc]init];
                    [self.navigationController pushViewController:payVC animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        case 1:
        {
            
            CCWebViewController *webView = [[CCWebViewController alloc]init];
            webView.delegate =  self;
            webView.isRecond = isRecond;
            
            webView.file = [HttpManager scoreRecordRequestWebView];
            
             [self.navigationController pushViewController:webView animated:YES];
            
           
//            scoreRecordVC = [[ScoreRecordViewController alloc]init];
            
//            scoreRecordVC.delegate = self;
//            [self.navigationController pushViewController:scoreRecordVC animated:YES];
//            CSPConsumptionPointsRecordTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsRecordTableViewController"];
//            [self.navigationController pushViewController:nextVC animated:YES];
            
            
        }
            
            break;
        case 2:
        {

            DownloadedRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadedRecordsViewController"];
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }
               default:
            
            break;
    }
}


//进行交易流水缓存清除
-(void)removeTradingWaterCache
{
    [advancePaymentRecordsVC.webView removeFromSuperview];
}


//清除预付款交易记录缓存
-(void)removeDepositPrepaidPhoneRecordsCache
{
    [dealFlowVC.webView removeFromSuperview];
}


//清除消费积分记录缓存
-(void)removeScoreRecordCache
{
    [scoreRecordVC.webView removeFromSuperview];
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

@end
