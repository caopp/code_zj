//
//  CSPGoodsNewCheckTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsNewCheckTableViewController.h"
#import "CSPGoodsNewTopTableViewCell.h"

@interface CSPGoodsNewCheckTableViewController ()

@end

@implementation CSPGoodsNewCheckTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    switch (self.Service) {
        case CSPOnlineNewsCheck:
            self.title = @"店铺置顶";
            break;
        case CSPOnlineGoodsCollection:
            self.title = @"采购商分级";
            break;
        case CSPOnlineGoodsShare:
            self.title = @"采购商黑名单";
            break;
        case CSPOnlineGoodsPictureLook:
            self.title = @"商品图片免费下载";
            break;
        case CSPOnlineGoodsPictureFree:
            self.title = @"购买商品图片";
            break;
        case CSPOnlineGoodsPicturePay:
            self.title = @"限制采购商下载";
            break;
        case CSPOfflineAdviseSupplier:
            self.title = @"每月免费上架商品";
            break;
        case CSPOfflineGuidance:
            self.title = @"额外付费上架商品";
            break;
        case CSPOfflineBuyerAdvise:
            self.title = @"买手推荐";
            break;
            
        default:
            break;
    }

    [self customBackBarButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPGoodsNewTopTableViewCell *goodNewCell;
    
    if (indexPath.row == 0) {
        
        goodNewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsNewTopTableViewCell"];
        
        if (!goodNewCell){
            
            goodNewCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsNewTopTableViewCell" owner:self options:nil]firstObject];
        }
        
        switch (self.Service) {
                
            case CSPOnlineNewsCheck:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_设置采购商等级介绍_店铺置顶可点击状态.png"];
                goodNewCell.titleLabel.text = @"店铺置顶";
                goodNewCell.detailLabel.text = @"在邀请的采购商的商家列表置顶本店。";
                
                break;
                
            case CSPOnlineGoodsCollection:
                
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_采购商分级选中状态.png"];
                
                goodNewCell.titleLabel.text = @"采购商分级";
                
                goodNewCell.detailLabel.text = @"1、可对与本店有交易的采购商，按平台级别权限对应本店权限进行升降级管理。\n2、采购商的本店等级不可降至其平台等级以下。\n3、调整等级仅当月有效。次月仍将按采购商的\"消费积分\"和\"预付货款\"进行级别评定。";
                
                break;
                
            case CSPOnlineGoodsShare:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_采购商黑名单选中状态.png"];
                goodNewCell.titleLabel.text = @"采购商黑名单";
                goodNewCell.detailLabel.text = @"加入黑名单后，采购商将不可见本店的所有内容，不可查阅、下载、购买本店的所有商品。";
                break;
                
            case CSPOnlineGoodsPictureLook:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_免费下载图片次数0.png"];
                goodNewCell.titleLabel.text = @"图片免费下载";
                goodNewCell.detailLabel.text = @"1、每月赠送免费下载次数，当月使用不完，不清零可累积。级别越高每月赠送次数越多。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、一个商品的【窗口图】和【客观图】可分开下载，下载后，各扣减1个下载次数。\n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";

                break;
            case CSPOnlineGoodsPictureFree:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"付费下载图片次数200"];
                goodNewCell.titleLabel.text = @"购买商品图片";
                goodNewCell.detailLabel.text = @"1、付费购买商品图片，等级越高越便宜。使用不完，不清零可累积。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、一个商品的【窗口图】和【客观图】可分开下载，下载后，各扣减1个下载次数。\n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";

                break;
            case CSPOnlineGoodsPicturePay:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_限制采购商下载选中状态.png"];
                goodNewCell.titleLabel.text = @"限制采购商下载";
                goodNewCell.detailLabel.text = @"设置与本店无交易的采购商\n不可下载本店7日内新款商品图片";

                break;
                
            case CSPOfflineAdviseSupplier:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_每月免费上架20.png"];
                goodNewCell.titleLabel.text = @"每月免费上架商品";
                goodNewCell.detailLabel.text = @"1、由平台方全流程完成的照片拍摄、图片处理、详情页编辑工作内容。\n2、以月为单位计算数量。本月未用完数量，可累积。";
                break;
                
            case CSPOfflineGuidance:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_额外付费上架¥200.png"];
                goodNewCell.titleLabel.text = @"额外付费上架商品";
                goodNewCell.detailLabel.text = @"除每月免费赠送的上架商品数量，如需额外上架商品，可单独付费，等级越高越便宜。使用不完，不清零可累积。";

                break;
                
            case CSPOfflineBuyerAdvise:

                break;
                
            default:
                break;
        }
 
    }else{
        
        goodNewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsNewTopTableViewCell0"];
        
        if (!goodNewCell)
        {
            
            goodNewCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsNewTopTableViewCell" owner:self options:nil]lastObject];
        }
        
        switch (self.Service) {
                
            case CSPOnlineNewsCheck:
                goodNewCell.v1Label.text = @"有";
                goodNewCell.v2Label.text = @"有";
                goodNewCell.v3Label.text = @"有";
                goodNewCell.v4Label.text = @"有";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                
                break;
                
            case CSPOnlineGoodsCollection:
                goodNewCell.v1Label.text = @"有";
                goodNewCell.v2Label.text = @"有";
                goodNewCell.v3Label.text = @"有";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                
                break;
                
            case CSPOnlineGoodsShare:
                
                goodNewCell.v1Label.text = @"有";
                goodNewCell.v2Label.text = @"有";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                
                break;
                
            case CSPOnlineGoodsPictureLook:
             
                goodNewCell.v1Label.text = @"无限下载/月";
                goodNewCell.v2Label.text = @"30/月";
                goodNewCell.v3Label.text = @"10/月";
                goodNewCell.v4Label.text = @"5/月";
                goodNewCell.v5Label.text = @"无下载权限";
                goodNewCell.v6Label.text = @"无下载权限";

                break;
            case CSPOnlineGoodsPictureFree:
                
                goodNewCell.v1Label.text = @"无限下载/月";
                goodNewCell.v2Label.text = @"20次/￥200";
                goodNewCell.v3Label.text = @"20次/￥300";
                goodNewCell.v4Label.text = @"20次/￥500";
                goodNewCell.v5Label.text = @"无下载权限";
                goodNewCell.v6Label.text = @"无下载权限";
              
                break;
            case CSPOnlineGoodsPicturePay:
                
                goodNewCell.v1Label.text = @"有";
                goodNewCell.v2Label.text = @"有";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                
                break;
                
            case CSPOfflineAdviseSupplier:
                
                goodNewCell.v1Label.text = @"50/月";
                goodNewCell.v2Label.text = @"30/月";
                goodNewCell.v3Label.text = @"20/月";
                goodNewCell.v4Label.text = @"10/月";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                break;
                
            case CSPOfflineGuidance:
                
                goodNewCell.v1Label.text = @"￥100/款";
                goodNewCell.v2Label.text = @"￥150/款";
                goodNewCell.v3Label.text = @"￥200/款";
                goodNewCell.v4Label.text = @"￥300/款";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"无";
                
                break;
                
            case CSPOfflineBuyerAdvise:
              
                break;
                
            default:
                break;
        }

    }

    return goodNewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        //计算高度
        
        NSString *description;
        
        switch (self.Service) {
                
            case CSPOnlineNewsCheck:
                
                description = @"在邀请的采购商的商家列表置顶本店。";
                
                break;
                
            case CSPOnlineGoodsCollection:
                
                description = @"1、可对与本店有交易的采购商，按平台级别权限对应本店权限进行升降级管理。\n2、采购商的本店等级不可降至其平台等级以下。\n3、调整等级仅当月有效。次月仍将按采购商的\"消费积分\"和\"预付货款\"进行级别评定。";
                
                break;
                
            case CSPOnlineGoodsShare:
                
                description = @"加入黑名单后，采购商将不可见本店的所有内容，不可查阅、下载、购买本店的所有商品。";
                
                break;
                
            case CSPOnlineGoodsPictureLook:
                
                description = @"1、每月赠送免费下载次数，当月使用不完，不清零可累积。级别越高每月赠送次数越多。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、每1次下载权限，可下载1个商品的【窗口图】及【详情图】，【窗口图】和【详情图】可分开下载。\n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";
                
                break;
                
            case CSPOnlineGoodsPictureFree:
                
                description = @"1、付费购买商品图片，等级越高越便宜。使用不完，不清零可累积。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、每1次下载权限，可下载1个商品的【窗口图】及【详情图】，【窗口图】和【详情图】可分开下载。\n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";
                
                break;
                
            case CSPOnlineGoodsPicturePay:
                
                description = @"设置与本店无交易的采购商\n不可下载本店7日内新款商品图片";
                
                break;
                
            case CSPOfflineAdviseSupplier:
                
                description = @"1、由平台方全流程完成的照片拍摄、图片处理、详情页编辑工作内容。\n2、以月为单位计算数量。本月未用完数量，可累积。";
                
                break;
                
            case CSPOfflineGuidance:
                
                description = @"除每月免费赠送的上架商品数量，如需额外上架商品，可单独付费，等级越高越便宜。使用不完，不清零可累积。";
                
                break;
                
            case CSPOfflineBuyerAdvise:
                
                break;
                
            default:
                break;
        }
        
        float leading = 15.0f;
        float trailing = 15.0f;
        float top = 101.0f;
        float buttom = 13.0f;
        
        float width = tableView.frame.size.width-leading-trailing;
        
        
        NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:HEX_COLOR(0x999999FF)};

      
        NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:description attributes:attributesDic];
        
        CGSize constraint = CGSizeMake(width, MAXFLOAT);
        
        CGRect rect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
        
        return rect.size.height+top+buttom;
        
    }else{
        
         return 392;
    }
}

@end
