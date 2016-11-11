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
    [self addCustombackButtonItem];

    switch (self.Service) {
        case CSPOnlineNewsCheck:
            self.title = @"商品上新查看";
            break;
        case CSPOnlineGoodsCollection:
            self.title = @"商品收藏";
            break;
        case CSPOnlineGoodsShare:
            self.title = @"商品分享";
            break;
        case CSPOnlineGoodsPictureLook:
            self.title = @"商品图片查看";
            break;
        case CSPOnlineGoodsPictureFree:
            self.title = @"商品图片免费下载";
            break;
        case CSPOnlineGoodsPicturePay:
            self.title = @"购买商品图片";
            break;
        case CSPOfflineAdviseSupplier:
            self.title = @"推荐优质供应商";
            break;
        case CSPOfflineGuidance:
            self.title = @"开店指导";
            break;
        case CSPOfflineBuyerAdvise:
            self.title = @"买手推荐";
            break;
            
        default:
            break;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPGoodsNewTopTableViewCell *goodNewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsNewTopTableViewCell"];

    if (!goodNewCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsNewTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsNewTopTableViewCell"];
        goodNewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsNewTopTableViewCell"];
    }

        switch (self.Service) {
            case CSPOnlineNewsCheck:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_查看实时上新可查看状态.png"];
                goodNewCell.titleLabel.text = @"商品上新查看";
                goodNewCell.detailLabel.text = @"实时浏览订购最新上架商品，快速拿到一手货源。级别越高可越早看到新品。";
                
                break;
            case CSPOnlineGoodsCollection:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_可收藏状态.png"];
                goodNewCell.titleLabel.text = @"商品收藏";
                goodNewCell.detailLabel.text = @"一键收藏商品，方便快速选货，在个人中心-商品收藏列表，统一查阅订购。";
                goodNewCell.v1Label.text = @"无";
                goodNewCell.v2Label.text = @"无";
                goodNewCell.v3Label.text = @"有";
                goodNewCell.v4Label.text = @"有";
                goodNewCell.v5Label.text = @"有";
                goodNewCell.v6Label.text = @"有";
                break;
            case CSPOnlineGoodsShare:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数10次可分享状态.png"];
                goodNewCell.titleLabel.text = @"商品分享";
                goodNewCell.detailLabel.text = @"无限次将商品分享到朋友圈，转发内容隐藏价格，仅含商品图片，高效快速推广。";
                goodNewCell.v1Label.text = @"无";
                goodNewCell.v2Label.text = @"无";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无限次分享";
                goodNewCell.v6Label.text = @"无限次分享";
                break;
            case CSPOnlineGoodsPictureLook:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_查看详情图可查看状态.png"];
                goodNewCell.titleLabel.text = @"商品图片查看";
                goodNewCell.detailLabel.text = @"图片统一标准拍摄，无过度修片，展示商品本真质量。查看窗口图、客观图，全面了解商品细节。";
                goodNewCell.v1Label.text = @"窗口图";
                goodNewCell.v2Label.text = @"窗口图";
                goodNewCell.v3Label.text = @"窗口图、客观图、参考图";
                goodNewCell.v4Label.text = @"窗口图、客观图、参考图";
                goodNewCell.v5Label.text = @"窗口图、客观图、参考图";
                goodNewCell.v6Label.text = @"窗口图、客观图、参考图";
                break;
            case CSPOnlineGoodsPictureFree:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数20次可下载状态.png"];
                goodNewCell.titleLabel.text = @"商品图片免费下载";
                goodNewCell.detailLabel.text = @"1、每月赠送免费下载次数，当月使用不完，不清零可累积。级别越高每月赠送次数越多。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、一个商品的【窗口图】和【客观图】可分开下载，下载后，各扣减1个下载次数。\n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";
                goodNewCell.detailLabelHeightConstraint.constant = 100;
                goodNewCell.v1Label.text = @"无下载权限";
                goodNewCell.v2Label.text = @"无下载权限";
                goodNewCell.v3Label.text = @"无下载权限";
                goodNewCell.v4Label.text = @"20次/月";
                goodNewCell.v5Label.text = @"40次/月";
                goodNewCell.v6Label.text = @"60次/月";
                break;
            case CSPOnlineGoodsPicturePay:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载20次¥30可下载状态.png"];
                goodNewCell.titleLabel.text = @"购买商品图片";
                goodNewCell.detailLabel.text= @"1、付费购买商品图片，等级越高越便宜。使用不完，不清零可累积。\n2、图片下载后，请到您的“手机相册”中查阅即可。\n3、一个商品的【窗口图】和【客观图】可分开下载，下载后，各扣减1个下载次数。 \n4、重复下载同1个商品，将累加计算下载次数。下载后的图片请妥善保管。";
                goodNewCell.detailLabelHeightConstraint.constant = 100;
                goodNewCell.v1Label.text = @"无下载权限";
                goodNewCell.v2Label.text = @"无下载权限";
                goodNewCell.v3Label.text = @"无下载权限";
                goodNewCell.v4Label.text = @"20次/￥50";
                goodNewCell.v5Label.text = @"20次/￥40";
                goodNewCell.v6Label.text = @"20次/￥30";
                break;
                
            case CSPOfflineAdviseSupplier:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_优秀供应商可点击状态.png"];
                goodNewCell.titleLabel.text = @"推荐优质供应商";
                goodNewCell.detailLabel.text = @"供应商需具有一定企业实力及各自品牌风格，款式及工艺均经过专业设计师、工艺师及买手等鉴定。所有原材料均经过纺织品安全检测，保证款式新颖度及货品质量。";
                goodNewCell.v1Label.text = @"无";
                goodNewCell.v2Label.text = @"无";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"有";
                goodNewCell.v6Label.text = @"有";
                break;
                
            case CSPOfflineGuidance:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_开店指导可点击状态.png"];
                goodNewCell.titleLabel.text = @"开店指导";
                goodNewCell.detailLabel.text = @"由专业人员实地勘察，评估当地消费主力、购买力水平及市场需求并作出分析，选出合适的地段、铺位，协助开店、上货、补货以及后期的跟踪指导服务。";
                goodNewCell.v1Label.text = @"无";
                goodNewCell.v2Label.text = @"无";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"有";
                break;
                
            case CSPOfflineBuyerAdvise:
                goodNewCell.titleImageView.image = [UIImage imageNamed:@"08_会员等级权限_买手推荐可点击状态.png"];
                goodNewCell.titleLabel.text = @"买手推荐";
                goodNewCell.detailLabel.text = @"专业级买手推荐，掌握全球流行信息，实时把控销售数据，进行信息预测、资源整合，平衡库存，满足不同消费者的需求。";
                goodNewCell.v1Label.text = @"无";
                goodNewCell.v2Label.text = @"无";
                goodNewCell.v3Label.text = @"无";
                goodNewCell.v4Label.text = @"无";
                goodNewCell.v5Label.text = @"无";
                goodNewCell.v6Label.text = @"有";
                break;
                
            default:
                break;
        }

    return goodNewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0;
//    }else
//    {
//        return 10;
//    }
//}

@end
