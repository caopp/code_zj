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
#import "CPSBuyerDetailViewController.h"
#import "MemberInviteDTO.h"
#import "PurchaseController.h"//!采购商详情
#import "PrepaiduUpgradeViewController.h"//采购商详情
#import "ManageGoodsViewController.h"
@interface CSPLetterDetailViewController ()<TTTAttributedLabelDelegate>
{
    PrepaiduUpgradeViewController *prepaiduUpgrade;
}
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@end

@implementation CSPLetterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"站内信详情";
    
    if ([self.noticeStationDTO.listPic isEqualToString:@""]) {
        self.textImgBottomConstraint.active = NO;
        self.textTopConstraint.active = YES;
        self.textTopConstraint.constant = 84;
        self.titleImageView.hidden = YES;
    }else{
        self.textImgBottomConstraint.active = YES;
        self.textTopConstraint.active = NO;
        self.titleImageView.hidden = NO;
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.noticeStationDTO.listPic]];
    }
    self.titleLabel.text = self.noticeStationDTO.infoTitle;
//    self.contentLabel.text= self.noticeStationDTO.infoContent;
    self.timeLabel.text = self.noticeStationDTO.createDate;
    
    
    self.contentLabel.delegate = self;
    [self.contentLabel setText:self.noticeStationDTO.infoContent afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        return mutableAttributedString;
    }];
    NSRange range;
    
    if ([self.noticeStationDTO.businessType isEqualToString:@"13"]) {
        range = [self.noticeStationDTO.infoContent rangeOfString:@"查看新上架的商品 》"];
        
    }else if ([self.noticeStationDTO.businessType isEqualToString:@"12"]){
        range = [self.noticeStationDTO.infoContent rangeOfString:@"查看新发布的商品 》"];
        
    }else{
        range = [self.noticeStationDTO.infoContent rangeOfString:@"查看采购商资料"];
        
    }
  
    if (range.length>0) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.noticeStationDTO.infoContent substringWithRange:range]]];
        
        [self.contentLabel addLinkToURL:url withRange:range];
    }

    
    
    NSString *insideLetterId = self.noticeStationDTO.Id.stringValue;
    
    
    [HttpManager sendHttpRequestForGetUpdateNoticeStatus:insideLetterId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B站内信阅读状态修改接口  返回正常编码");
            
        }else{
            
            NSLog(@"大B站内信阅读状态修改接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetUpdateNoticeStatus 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

    [self customBackBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.noticeStationDTO.listPic isEqualToString:@""]) {
        self.textImgBottomConstraint.active = NO;
        self.textTopConstraint.active = YES;
        self.textTopConstraint.constant = 84;
        self.titleImageView.hidden = YES;
    }else{
        self.textImgBottomConstraint.active = YES;
        self.textTopConstraint.active = NO;
        self.titleImageView.hidden = NO;
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.noticeStationDTO.listPic]];
    }
   [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    //!采购商详情
    if ([self.noticeStationDTO.businessType isEqualToString:@"1"]) {
        
//        MemberInviteDTO *dto = [[MemberInviteDTO alloc]init];
//        dto.memberNo = self.noticeStationDTO.businessNo;
        
        
//        PurchaseController *purchVC = [[PurchaseController alloc]init];
//        purchVC.memberNo = self.noticeStationDTO.businessNo;
//        
//        [self.navigationController pushViewController:purchVC animated:YES];
//
//        CPSBuyerDetailViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSBuyerDetailViewController"];
//        nextVC.memberDTO = dto;
//        nextVC.isInBlackList = NO;
//        [self.navigationController pushViewController:nextVC animated:YES];
// 
       
        prepaiduUpgrade = [[PrepaiduUpgradeViewController alloc]init];
        
        NSString *file = [HttpManager fromMessageToPurchaseMemberNo:self.noticeStationDTO.businessNo];
        
        prepaiduUpgrade.file = file;
        
        [self.navigationController pushViewController:prepaiduUpgrade animated:YES];
        
    }
    //新上商品
    if ([self.noticeStationDTO.businessType isEqualToString:@"12"]) {
        
      
        ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
        
        //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
        
        //!全部_在售、新发布 的时候， 看 全部_在售
        
        managerGoodsVC.type = @"-1";
        
        managerGoodsVC.isIntoNews = YES;
        
        [self.navigationController pushViewController:managerGoodsVC animated:YES];
        
    }
    //新上架
    if ([self.noticeStationDTO.businessType isEqualToString:@"13"]) {
        
        
        ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
        
        //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
        
        //!全部_在售、新发布 的时候， 看 全部_在售
        
   
        
        [self.navigationController pushViewController:managerGoodsVC animated:YES];
        
    }

}



@end
