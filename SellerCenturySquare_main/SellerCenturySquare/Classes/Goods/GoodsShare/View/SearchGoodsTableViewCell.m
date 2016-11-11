//
//  SearchGoodsTableViewCell.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchGoodsTableViewCell.h"

@implementation SearchGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loadDTO:(GoodsShareDTO *)dto{
    _updateLabel.hidden = YES;
    _commPercentLabel.hidden = YES;
    _startsLabel.hidden = YES;
   // _shareCountLabel.text = [NSString stringWithFormat:@"商品被分享%@次，审核通过%@次",dto.shareNum,dto.auditPassNum];
   [_shareImgView sd_setImageWithURL:[NSURL URLWithString:dto.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
    _goodsNameLabel.text = dto.goodsName;
    _goodsWillNoLabel.text = [NSString stringWithFormat:@"货号：%@",dto.goodsWillNo];
    _goodsColorLabel.text = [NSString stringWithFormat:@"颜色：%@",dto.color];
    NSString *strPrice = [NSString stringWithFormat:@"零售价：￥%@",dto.retailPrice];
    NSString *strW = [NSString stringWithFormat:@"商品被分享%@次，",dto.shareNum];
    NSString *strP = [NSString stringWithFormat:@"审核通过%@次",dto.auditPassNum];
    NSMutableAttributedString *attributeW = [self createStringWithString:strW withRange:NSMakeRange(5, [strW length]-7)];
    NSMutableAttributedString *attributeP = [self createStringWithString:strP withRange:NSMakeRange(4, [strP length]-5)];
    [attributeW appendAttributedString:attributeP];
    _shareCountLabel.attributedText = attributeW;
    _goodsPriceLabel.attributedText = [self createStringWithString:strPrice withRange:NSMakeRange(4, [strPrice length]-4)];
    
}
-(void)loadMemberDTO:(GoodsShareDTO *)dto{
    _updateLabel.hidden = NO;
    _commPercentLabel.hidden = NO;
    _startsLabel.hidden = NO;
//    _shareCountLabel.text = [NSString stringWithFormat:@"分享:窗口图%@张，参考图%@张",dto.wPicNum,dto.rPicNum];
    
    NSString *strW = [NSString stringWithFormat:@"窗口图%@张",dto.wPicNum];
    NSString *strP = [NSString stringWithFormat:@" 参考图%@张",dto.rPicNum];
    NSMutableAttributedString *attributeW = [self createStringWithString:strW withRange:NSMakeRange(3, [strW length]-4)];
    NSMutableAttributedString *attributeP = [self createStringWithString:strP withRange:NSMakeRange(4, [strP length]-5)];
    [attributeW appendAttributedString:attributeP];
    _shareCountLabel.attributedText = attributeW;
    
    [_shareImgView sd_setImageWithURL:[NSURL URLWithString:dto.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
    _goodsNameLabel.text = dto.goodsName;
    _goodsWillNoLabel.text = [NSString stringWithFormat:@"货号：%@",dto.goodsWillNo];
    _goodsColorLabel.text = [NSString stringWithFormat:@"颜色：%@",dto.color];
    NSString *strPrice = [NSString stringWithFormat:@"零售价：￥%@",dto.retailPrice];
    NSString *strDeduct =[dto.commPercent doubleValue]!=0? [NSString stringWithFormat:@"提成：%.2f%@",[dto.commPercent floatValue]*100,@"%"]:@"提成：无";
    _updateLabel.text = [NSString stringWithFormat:@"提交时间：%@",dto.createDate];
    _startsLabel.text = [self returnStatus:dto.status];
    
    _goodsPriceLabel.attributedText = [self createStringWithString:strPrice withRange:NSMakeRange(4, [strPrice length]-4)];
    _commPercentLabel.attributedText = [self createStringWithString:strDeduct withRange:NSMakeRange(3, [strDeduct length] -3)];
}
-(NSString *)returnStatus:(NSNumber *)status{
    switch ([status intValue]) {
        case 1:
            return @"待审核";
            break;
        case 2:
            return @"审核通过";
            break;
        case 3:
            return @"审核未通过";
            break;
        default:
            break;
    }
    return @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
