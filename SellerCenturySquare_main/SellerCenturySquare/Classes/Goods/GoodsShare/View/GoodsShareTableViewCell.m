//
//  GoodsShareTableViewCell.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsShareTableViewCell.h"

@implementation GoodsShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _userHeadView.layer.masksToBounds = YES;
    _userHeadView.layer.cornerRadius = 21.0f;
    
}
-(void)configDto:(GoodsShareDTO *)dto{
    [_userHeadView sd_setImageWithURL:[NSURL URLWithString:dto.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    _userNameLabel.text = dto.userName;
    //_imageShareCount.text = [NSString stringWithFormat:@"窗口图%@张 参考图%@张",dto.wPicNum,dto.rPicNum];
    NSString *strW = [NSString stringWithFormat:@"窗口图%@张",dto.wPicNum];
    NSString *strP = [NSString stringWithFormat:@" 参考图%@张",dto.rPicNum];
    NSMutableAttributedString *attributeW = [self createStringWithString:strW withRange:NSMakeRange(3, [strW length]-4)];
     NSMutableAttributedString *attributeP = [self createStringWithString:strP withRange:NSMakeRange(4, [strP length]-5)];
     [attributeW appendAttributedString:attributeP];
    _imageShareCount.attributedText = attributeW;
    _shareImgState.text =  [self returnStatus:dto.status];
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:dto.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
    _goodsNameLabel.text = dto.goodsName;
    _goodsNoLabel.text  = [NSString stringWithFormat:@"货号：%@",dto.goodsWillNo];
    _goodsColorLabel.text = [NSString stringWithFormat:@"颜色：%@",dto.color];;
    NSString *strPrice = [NSString stringWithFormat:@"零售价：￥%@",dto.retailPrice];
    _goodsPriceLabel.attributedText = [self createStringWithString:strPrice withRange:NSMakeRange(4, [strPrice length]-4)];
    NSString *strDeduct =[dto.commPercent doubleValue]==0? @"提成：无":[NSString stringWithFormat:@"提成：%.2f%@",[dto.commPercent floatValue]*100,@"%"];
    _goodsDeductLabel.attributedText = [self createStringWithString:strDeduct withRange:NSMakeRange(3, [strDeduct length] -3)];
    _timeLabel.text = [NSString stringWithFormat:@"提交时间：%@",dto.createDate];
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
