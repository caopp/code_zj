//
//  CSPOrderViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderViewController.h"
#import "CSPOrderSegmentView.h"
#import "CSPOrderModeControl.h"
#import "OrderAddDTO.h"
#import "CSPPayAvailabelViewController.h"
#import "ConversationWindowViewController.h"
#import "CSPOrderDetailViewController.h"
#import "OrderGroupListDTO.h"
#import "CustomBarButtonItem.h"
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"
#import "CSPGoodsViewController.h"
#import "MerchantDeatilViewController.h"
#import "MyOrderDetailViewController.h"

@interface CSPOrderViewController () <CSPOrderModeControlDelegate>
{
    UIButton * leftBackBtn;//!导航左按钮
    
}


@property (weak, nonatomic) IBOutlet CSPOrderSegmentView* segmentView;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIView *invalidView;
@property (nonatomic ,strong) OrderAddDTO *orderAddDTO;

@property (nonatomic, strong) CSPOrderModeControl* orderModeControl;

@end

@implementation CSPOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的采购单";
    
    leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBackBtn.frame = CGRectMake(0, 0, 10, 18);
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    [leftBackBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];
    
   
    //设置显示tableviewCell
    
    self.orderModeControl = [[CSPOrderModeControl alloc]initWithTableView:self.tableView];
    self.orderModeControl.view = self.view;

    
    self.orderModeControl.delegate = self;
    self.segmentView.delegate = self.orderModeControl;
    
    [self selectSegmentWithCurrentOrderMode];
    
    [self.view bringSubviewToFront:self.invalidView];
    
    [self.invalidView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:personalCenterRefresh object:nil];
    
    [self.orderModeControl refreshOrder];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)prepareToPayForOrder:(NSString*)orderCode {
    
    
    [HttpManager sendHttpRequestForConfirmPay:orderCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.orderAddDTO = [[OrderAddDTO alloc] init];
            [self.orderAddDTO setDictFrom:[dic objectForKey:@"data"]];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CSPPayAvailabelViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.orderAddDTO = self.orderAddDTO;
            destViewController.isAvailable = YES;
            [self.navigationController pushViewController:destViewController animated:YES];
            
        }else{
            //            if (alertView) {
            //                [alertView removeFromSuperview];
            //
            //            }
            //            alertView = [GUAAlertView alertViewWithTitle:@"请求失败" withTitleClor:nil message:[dic objectForKey:@"errorMessage"]  withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //
            //            } dismissAction:^{
            //
            //            }];
            //            [alertView show];
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
//    CSPPayAvailabelViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
//    destViewController.orderCode = orderCode;
//    destViewController.isAvailable = YES;
//
//    [self.navigationController pushViewController:destViewController animated:YES];
}

//跳转到客服对话
- (void)enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString *)merchantNo {
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];
            NSNumber *isExit = dic[@"data"][@"isExit"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantName jid:jid withMerchantNo:merchantNo];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;
            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

         
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

//跳转到商品列表
- (void)CSPOrderModeJumpNextMerchanName:(NSString *)name merchanNo:(NSString *)No
{
    
    MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
    detailVC.merchantNo = No;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
//    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:No pageNo:@1 pageSize:@20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSDictionary* dataDict = [dic objectForKey:@"data"];
//            
//            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
//            MerchantListDetailsDTO* merchantDetails = [merchantListDTO.merchantList firstObject];
//            CSPGoodsViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsViewController"];
//            destViewController.merchantDetail = merchantDetails;
//            destViewController.style = CSPGoodsViewStyleSingleMerchant;
//            
//            [self.navigationController pushViewController:destViewController animated:YES];
//            
//            
//        } else {
//            
//            [self.view makeMessage:[NSString stringWithFormat:@"查询商家信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
//            
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
//    }];

}

- (void)selectedOrderGroup:(OrderGroup*)orderGroupInfo {

//    MyOrderDetailViewController *orderDetailVC = [[MyOrderDetailViewController alloc] init];
//    orderDetailVC.orderCode = orderGroupInfo.orderCode;
//    [self.navigationController pushViewController:orderDetailVC animated:YES];

    
    CSPOrderDetailViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPOrderDetailViewController"];
    destViewController.orderCode = orderGroupInfo.orderCode;

    [self.navigationController pushViewController:destViewController animated:YES];
}

- (void)withoutAnyOrder {
    [self.invalidView setHidden:NO];
}

- (void)setOrderMode:(CSPOrderMode)orderMode {
    _orderMode = orderMode;
}

- (void)selectSegmentWithCurrentOrderMode {
    switch (self.orderMode) {
        case CSPOrderModeAll:
            [self.segmentView selectSegmentAtIndex:0];
            break;
        case CSPOrderModeToPay:
            [self.segmentView selectSegmentAtIndex:1];
            break;
        case CSPOrderModeToDispatch:
            [self.segmentView selectSegmentAtIndex:2];
            break;
        case CSPOrderModeToTakeDelivery:
            [self.segmentView selectSegmentAtIndex:3];
            break;
        case CSPOrderModeDealCanceled:
            [self.segmentView selectSegmentAtIndex:4];
            break;
        case CSPOrderModeOrderCanceled:
            [self.segmentView selectSegmentAtIndex:5];
            break;
        case CSPOrderModeDealCompleted:
            [self.segmentView selectSegmentAtIndex:6];
            break;
        default:
            
            
            break;
    }
}


- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)toChooseGoodsButtonClicked:(id)sender {
    self.rdv_tabBarController.selectedIndex = 1;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
