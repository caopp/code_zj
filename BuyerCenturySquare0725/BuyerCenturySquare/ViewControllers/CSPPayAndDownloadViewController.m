//
//  CSPPayAndDownloadViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPayAndDownloadViewController.h"
#import "CSPMemberVIPViewController.h"
#import "CSPAmountControlView.h"
#import "CustomBarButtonItem.h"
#import "PayDownloadDTO.h"
#import "SingleSku.h"
#import "SkuDTO.h"
#import "CSPAmountControlView.h"
#import "SkuListDTO.h"
#import "OrderAddDTO.h"
#import "CSPPayAvailabelViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "PrepaiduUpgradeViewController.h"

@interface CSPPayAndDownloadViewController ()<CSPSkuControlViewDelegate>

{
    PayDownloadDTO* payDownloadDTO_;
    SkuListDTO *skuListDTO;
    NSInteger totalCount;
}
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadNumImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *buytitleLabel;
@property (weak, nonatomic) IBOutlet CSPSkuControlView *amountView;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
- (IBAction)buyButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet CustomBarButtonItem *rightButton;
- (IBAction)rightButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;



@property (nonatomic, strong)PayDownloadDTO* payDownloadDTO;
@property (nonatomic, strong)OrderAddDTO *orderAddDTO;

@end

@implementation CSPPayAndDownloadViewController
@synthesize payDownloadDTO = payDownloadDTO_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"付费下载";
    [self addCustombackButtonItem];
    self.amountView.delegate = self;
    
    self.buyCountLabel.numberOfLines = 0;
    self.buyCountLabel.adjustsFontSizeToFitWidth = YES;

    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    
    [HttpManager sendHttpRequestForPayDownloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                self.payDownloadDTO = [[PayDownloadDTO alloc] init];
                
                [self.payDownloadDTO setDictFrom:[dic objectForKey:@"data"]];
                
                //                self.payDownloadDTO.authFlag = @"1";
                //                self.payDownloadDTO.buyDownloadPrice = [NSNumber numberWithInt:50];
                //                self.payDownloadDTO.buyDownloadQty = [NSNumber numberWithInt:10];
                //                self.levelImageView.image
                //                self.downloadNumImageView.image
                
                self.levelLabel.text = [NSString stringWithFormat:@"V%@",self.payDownloadDTO.level.stringValue];
                self.leftCountLabel.text = self.payDownloadDTO.downloadNum.stringValue;
                if ([self.payDownloadDTO.authFlag isEqualToString:@"0"]) {
                    self.titleLabel.text = [NSString stringWithFormat:@"V%@会员购买商品图20次下载权限",self.payDownloadDTO.buyLevel.stringValue];
                    self.moneyLabel.text = @"50";
                    
                    self.buytitleLabel.text = @"您的等级暂无下载权限";
                    self.buytitleLabel.frame = CGRectMake(self.buytitleLabel.frame.origin.x, self.buytitleLabel.frame.origin.y, 200, self.buytitleLabel.frame.size.height);
                    self.buyCountLabel.hidden = YES;
                    self.buyButton.enabled = NO;
                    self.buyButton.backgroundColor = [UIColor grayColor];
                    
                    self.amountView.titleLabel.backgroundColor = [UIColor grayColor];
                    self.amountView.batchNumLimit = 1;
                    self.amountView.layer.borderColor = [UIColor grayColor].CGColor;
                    
                    [self.amountView zoneGoodsInit];
                    self.amountView.userInteractionEnabled = NO;
                    
//                    [self.buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    
                    
                    
                }else{
                    self.titleLabel.text = [NSString stringWithFormat:@"V%@会员购买商品图%@次下载权限",self.payDownloadDTO.level.stringValue,self.payDownloadDTO.buyDownloadQty.stringValue];
                    self.moneyLabel.text = self.payDownloadDTO.buyDownloadPrice.stringValue;
                    
                    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.payDownloadDTO.skuNo, @"skuNo",@"数量",@"skuName",nil];
                    
                    SingleSku *basicSku = [[SingleSku alloc]initWithDictionary:dic];
                    totalCount = 1;
                    basicSku.value = 1;
                    self.amountView.skuValue = basicSku;
                    self.buyCountLabel.text = [NSString stringWithFormat:@"%@次/￥%@",self.payDownloadDTO.buyDownloadQty.stringValue,self.payDownloadDTO.buyDownloadPrice.stringValue];
                    
                }
                
                
            }
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        
    }];
}



- (IBAction)buyButtonClicked:(id)sender {
    
    NSNumber *piece =[[NSNumber alloc] initWithInteger:totalCount];
    NSString *goodsNo =self.payDownloadDTO.goodsNo;
    NSString *skuNo  =self.payDownloadDTO.skuNo;
    NSNumber *servieType = [NSNumber numberWithInteger:3];
    
    
    [self progressHUDShowWithString:@""];
    
    [HttpManager sendHttpRequestForaddVirtualOrder:piece goodsNo:goodsNo skuNo:skuNo serviceType:servieType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        [self progressHUDHiddenWidthString:@""];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            

            self.orderAddDTO = [[OrderAddDTO alloc] init];
            
            [self.orderAddDTO setDictFrom:[dic objectForKey:@"data"]];
            
            
            CSPPayAvailabelViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.orderAddDTO = self.orderAddDTO;
            destViewController.isAvailable = NO;
            [self.navigationController pushViewController:destViewController animated:YES];
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        [self progressHUDHiddenWidthString:@""];
    }];

 
}
#pragma mark 会员特权 h5
- (IBAction)rightButtonClicked:(id)sender {
    
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    //bool值进行名字判断
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    

}

#pragma mark--
#pragma CSPSkuControlViewDelegate
- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue
{
    SingleSku *single = (SingleSku *)skuValue;
    totalCount = single.value;
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"%ld次/￥%0.2lf",self.payDownloadDTO.buyDownloadQty.intValue *totalCount,self.payDownloadDTO.buyDownloadPrice.doubleValue*totalCount];
    
}
@end
