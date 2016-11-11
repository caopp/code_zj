//
//  CSPLetterDetailViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPLetterDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "TTTAttributedLabel.h"
#import "CSPOrderDetailViewController.h"
#import "MerchantListDetailsDTO.h"
#import "MerchantDeatilViewController.h"
#import "MerchantListDTO.h"
#import "MyOrderDetailViewController.h"
#import "ShowApplyMeth.h"
@interface CSPLetterDetailViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelConstraint;
@end

@implementation CSPLetterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"站内信详情";
    [self addCustombackButtonItem];

    self.titleLabel.text = self.memberNoticeDTO.infoTitle;
//    self.contentLabel.text= self.memberNoticeDTO.infoContent;
    self.contentLabel.delegate = self;
    [self.contentLabel setText:self.memberNoticeDTO.infoContent afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        return mutableAttributedString;
    }];
    NSString *order;
    if ([self.memberNoticeDTO.infoContent hasSuffix:@"查看采购单"]) {
        order = @"查看采购单";
    }else{
        order = @"查看订单";
    }
    
    NSRange range = [self.memberNoticeDTO.infoContent rangeOfString:order];
    NSRange range1 = [self.memberNoticeDTO.infoContent rangeOfString:@"进入店铺"];
     NSRange range2 = [self.memberNoticeDTO.infoContent rangeOfString:@"查看申请资料 》"];
    if (range.length>0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.memberNoticeDTO.infoContent substringWithRange:range]]];
        [self.contentLabel addLinkToURL:url withRange:range];
    }
    if (range1.length>0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.memberNoticeDTO.infoContent substringWithRange:range1]]];
        [self.contentLabel addLinkToURL:url withRange:range1];
    }
   
    if (range2.length>0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.memberNoticeDTO.infoContent substringWithRange:range2]]];
        [self.contentLabel addLinkToURL:url withRange:range2];
    }
    
    self.timeLabel.text = self.memberNoticeDTO.sendTime;
    
    NSString *insideLetterId = self.memberNoticeDTO.Id.stringValue;
    
    [HttpManager sendHttpRequestForUpdateNoticeStatusWithInsideLetterID:insideLetterId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"已阅读" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            
//            [alert show];
            //参数需要保存
            
        }else{
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

-(void)viewWillLayoutSubviews{
    
    if ([self.memberNoticeDTO.listPic isEqualToString:@""]) {
        
        self.imageViewConstraint.constant = 28;
        self.titleLabelConstraint.constant = 30;
        self.titleImageView.hidden = YES;
        }else{
            [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.memberNoticeDTO.listPic]placeholderImage:[UIImage imageNamed:@"merchant_placeholder"]];
            
            if (self.view.frame.size.width == 320) {
                self.imageViewConstraint.constant = 143;
                self.titleLabelConstraint.constant = 145;
            }else if (self.view.frame.size.width == 414){
                self.imageViewConstraint.constant = 168;
                self.titleLabelConstraint.constant = 170;
                
            }else{
                self.imageViewConstraint.constant = 153;
                self.titleLabelConstraint.constant = 155;
            }
        }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if ([self.memberNoticeDTO.businessType isEqualToString:@"3"]) {
//        CSPOrderDetailViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPOrderDetailViewController"];
//        
//   
//        
//        nextVC.orderCode = self.memberNoticeDTO.businessNo;
//        [self.navigationController pushViewController:nextVC animated:YES];
        MyOrderDetailViewController *myorderVC = [[MyOrderDetailViewController alloc] init];
        
        myorderVC.orderState = 3;
        
        myorderVC.orderCode = self.memberNoticeDTO.businessNo;
        
        [self.navigationController pushViewController:myorderVC animated:YES];
        
    }else if ([self.memberNoticeDTO.businessType isEqualToString:@"2"]){
        
        
        [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:self.memberNoticeDTO.businessNo pageNo:@1 pageSize:@20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                NSDictionary* dataDict = [dic objectForKey:@"data"];
                
                MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
                
                if (merchantListDTO.merchantList.count > 0) {
                    MerchantListDetailsDTO* merchantDetails = [merchantListDTO.merchantList firstObject];
                   
                    MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
                    detailVC.merchantNo = merchantDetails.merchantNo;
                    [self.navigationController pushViewController:detailVC animated:YES];
                    
                    
                } else {
                    [self.view makeMessage:@"查询商家列表失败,查看服务器"  duration:2.0f position:@"center"];

                    
                 
                }
                
            } else {
                [self.view makeMessage:@"查询信息失败,查看服务器"  duration:2.0f position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
              [self.view makeMessage:@"网络连接异常"  duration:2.0f position:@"center"];
        }];
 //7:申请资料审核通过 8:申请资料审核未通过9:申请资料修改审核通过10:申请资料修改审核未通过

    }else if([self.memberNoticeDTO.businessType isEqualToString:@"7"]||[self.memberNoticeDTO.businessType isEqualToString:@"9"]||[self.memberNoticeDTO.businessType isEqualToString:@"10"]){
        ShowApplyMeth *showAppleyMeth = [[ShowApplyMeth alloc] init];
        NSString *type = [self.memberNoticeDTO.businessType isEqualToString:@"7"]?@"1":@"2";
        [showAppleyMeth showApplyDataTable:self withApplyId:self.memberNoticeDTO.businessNo withType:type];
    }else if([self.memberNoticeDTO.businessType isEqualToString:@"8"]){
        ShowApplyMeth *showAppleyMeth = [[ShowApplyMeth alloc] init];
        [showAppleyMeth getApplyData:self withApplyId:self.memberNoticeDTO.businessNo];
        
    }
    
}




@end
