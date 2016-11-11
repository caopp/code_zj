//
//  CSPPayDownloadViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPPayDownloadViewController.h"
#import "CSPPayDownloadCell.h"
#import "GetPayMerchantDownloadDTO.h"
#import "SingleSku.h"
#import "OrderAddDTO.h"
#import "CSPPayAvailabelViewController.h"
#import "SecondaryViewController.h"
#import "TransactionRecordsViewController.h"
#import "ThreePageViewController.h"

@interface CSPPayDownloadViewController ()<UITableViewDataSource,UITableViewDelegate,CSPSkuControlViewDelegate,MBProgressHUDDelegate,SecondaryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

@property (strong,nonatomic)OrderAddDTO *orderAddDTO;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (IBAction)buyCountClick:(id)sender;

@property (strong,nonatomic)GetPayMerchantDownloadDTO *getPayMerchantDownload;

//!底部的view
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CSPPayDownloadViewController{
    
    NSInteger _totalCount;
    
    BOOL _isOrder;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"付费下载";
    
    [self customBackBarButton];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithTitle:@"商家特权" style:UIBarButtonItemStylePlain target:self action:@selector(intoBussinessVIP)];
    
    
    self.navigationItem.rightBarButtonItem = backBarButton;

    [self setExtraCellLineHidden:self.tableView];
    
    
    self.progressHUD.delegate = self;
    
    
    
}

//进入商家特权
- (void)intoBussinessVIP
{
   
    ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
    
    threePageVC.file = [HttpManager privilegesNetworkRequestWebView];
    
    [self.navigationController pushViewController:threePageVC animated:YES];
    
}




-(void)pushTransactionRecordsVC
{
    TransactionRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    
    [self requestPayDownLoad];
}

-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)requestPayDownLoad{
    
    [self progressHUDShowWithString:@"加载中"];
    
    [HttpManager sendHttpRequestForGetPayMerchantDownload:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                if (!self.getPayMerchantDownload) {
                    
                    self.getPayMerchantDownload = [[GetPayMerchantDownloadDTO alloc]init];
                }
                
                [self.getPayMerchantDownload setDictFrom:data];
                
            }
            
        }else{
            
            [self alertViewWithTitle:@"提示" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
        [self.tableView reloadData];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
    
}


#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPPayDownloadCell *cell;
    
    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PayDownloadCell0"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPPayDownloadCell" owner:self options:nil]objectAtIndex:indexPath.row];
            
            cell.butCountLabel.text = [self transformationData:self.getPayMerchantDownload.downloadNum];
            
            cell.gradeLabel.text = [NSString stringWithFormat:@"V%@",[self transformationData:self.getPayMerchantDownload.level]];
            
        }
    }else if (indexPath.row == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PayDownloadCell1"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPPayDownloadCell" owner:self options:nil]objectAtIndex:indexPath.row];
            
            if([[self transformationData:self.getPayMerchantDownload.level] floatValue] <= 3) {
                
                cell.tipDownLoadAuthorityLabel.text = [NSString stringWithFormat:@"V3会员购买商品图%d次下载权限",self.getPayMerchantDownload.buyDownloadQty.intValue];
            }else {
                
                cell.tipDownLoadAuthorityLabel.text = [NSString stringWithFormat:@"V%@会员购买商品图%d次下载权限",[self transformationData:self.getPayMerchantDownload.level],self.getPayMerchantDownload.buyDownloadQty.intValue];
            }
            
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
            
            cell.skuControllView.delegate = self;
            
            if (self.getPayMerchantDownload) {
                
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.getPayMerchantDownload.skuNo, @"skuNo",@"数量",@"skuName",nil];
                
                SingleSku *basicSku = [[SingleSku alloc]initWithDictionary:dic];
                
                basicSku.value = 1;
                
                _totalCount = 1;
                
                cell.skuControllView.skuValue = basicSku;
            }
            
            
            if ([[self transformationData:self.getPayMerchantDownload.level] floatValue] < 3) {
                
                NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc] initWithString:@"您的等级暂无下载权限" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                
                self.buyCountLabel.attributedText = prefix;
                
                [self.buyBtn setEnabled:NO];
                [self.buyBtn setBackgroundColor:[UIColor grayColor]];
                
            }else {
                
                NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc] initWithString:@"购买次数：" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]] attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x6f6087FF)}];
                
                self.buyCountLabel.attributedText = [self jointString:prefix suffix:buyCount];
                
                [self.buyBtn setEnabled:YES];
                [self.buyBtn setBackgroundColor:[UIColor blackColor]];
            }
        }
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PayDownloadCell2"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPPayDownloadCell" owner:self options:nil]objectAtIndex:indexPath.row];
            
            cell.illustrateLabel.text = @"介绍\n\n1、图片下载后，请到您的“手机相册”中查阅即可。\n\n2、一个商品的【窗口图】和【客观图】可分开下载，下载后，各扣减1个下载次数。\n\n3、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";
        }
    
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        return 77;
    }else if (indexPath.row == 1){
        return 200;
    }else{
        return 275;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
}

#pragma mark--
#pragma CSPSkuControlViewDelegate
- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue{

    SingleSku *single = (SingleSku *)skuValue;
    
    _totalCount = single.value;
    
    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc] initWithString:@"购买次数：" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld次/￥%0.2lf",self.getPayMerchantDownload.buyDownloadQty.intValue *_totalCount,self.getPayMerchantDownload.buyDownloadPrice.doubleValue*_totalCount] attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x6f6087FF)}];
    
    self.buyCountLabel.attributedText = [self jointString:prefix suffix:buyCount];
}

#pragma mark-
#pragma mark-支付
- (IBAction)buyCountClick:(id)sender {
    
    [self progressHUDShowWithString:@""];
    
    [HttpManager sendHttpRequestForaddVirtualOrder:[NSNumber numberWithInteger:_totalCount] goodsNo:self.getPayMerchantDownload.goodsNo skuNo:self.getPayMerchantDownload.skuNo serviceType:@"3" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                if (!self.orderAddDTO) {
                    
                    self.orderAddDTO = [[OrderAddDTO alloc]init];
                }
                
                [self.orderAddDTO setDictFrom:data];
            }
            
            _isOrder = YES;
            
            [self progressHUDHiddenTipSuccessWithString:@""];
            
        }else{
            
            if (responseDic[ERRORMESSAGE]) {
                
                [self alertViewWithTitle:@"提示" message:[responseDic objectForKey:ERRORMESSAGE]];

            }else{
                
                [self.view makeMessage:@"请求失败" duration:2 position:@"center"];
                
            
            }
        
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];

    }];
}


#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (_isOrder) {
        
        _isOrder = NO;
        
        //到支付页面
        CSPPayAvailabelViewController *payAvailabelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
        
        payAvailabelViewController.orderAddDTO = self.orderAddDTO;
        
        [self.navigationController pushViewController:payAvailabelViewController animated:YES];
    }
}
#pragma mark-
- (NSAttributedString *)jointString:(NSMutableAttributedString *)prefix suffix:(NSMutableAttributedString *)suffix {
    
    [prefix appendAttributedString:suffix];
    
    return prefix;
}
@end
