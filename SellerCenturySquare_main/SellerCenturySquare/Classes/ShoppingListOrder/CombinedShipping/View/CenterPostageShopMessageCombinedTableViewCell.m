//
//  CenterPostageShopMessageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CenterPostageShopMessageCombinedTableViewCell.h"

@interface CenterPostageShopMessageCombinedTableViewCell ()

/**
 * 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPhotoImage;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;

/**
 *  商品单价
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumbLab;

/**
 *  选择采购单
 */
@property (weak, nonatomic) IBOutlet UIButton *MergeOrderBtn;

/**
 *  采购单类型：0-期货 ;1-现货
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLab;

/**
 *  采购单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumbLab;

/**
 *  采购单状态： 采购单状态0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

/**
 *  商品总件数
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumLab;

/**
 *  订单总价
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabl;

/**
 *  付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *paymentStateLab;

/**
 *  付款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *paymentMoneyLab;

/**
 *  拍摄快递单发货
 *
 *  @param sender
 */
- (IBAction)selectPhotoSendGoodsBtn:(id)sender;

/**
 *  录入快递单发货
 *
 *  @param sender
 */
- (IBAction)selectEntrySendGoodsBtn:(id)sender;

/**
 *  选择商品采购单
 *
 *  @param sender
 */
- (IBAction)selectMergeOrderBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *shootExpressSingleBtn;
@property (weak, nonatomic) IBOutlet UIButton *entryExpressSingleBtn;



- (IBAction)selectShootExpressSingleBtn:(id)sender;
- (IBAction)selectEntryExpressSingleBtn:(id)sender;



@end



@implementation CenterPostageShopMessageCombinedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)selectShootExpressSingleBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectShootExpressSingle:orderListDto:)]) {
        [self.delegate myOrderParentSelectShootExpressSingle:self orderListDto:self.recordListDto];
    }

}
- (IBAction)selectEntryExpressSingleBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectEntryExpressSingle:orderListDto:)]) {
        [self.delegate myOrderParentSelectEntryExpressSingle:self orderListDto:self.recordListDto];
    }

}
- (IBAction)selectMergeOrderBtn:(id)sender {
    
    
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    //选中
    if (btn.selected) {
        self.recordListDto.checkBtn = @"YES";
    }else
    {
        self.recordListDto.checkBtn = @"NO";
    }
    
    if (self.recordMemberDto.orderList.count > 0) {
        //是否改变
        NSString *isChange;
        int j = 0;
        int k = 0;
        for (OrderListDTO *listDto in self.recordMemberDto.orderList) {
            if ([listDto.numb isEqualToString:@"first"]||[listDto.numb isEqualToString:@"own"]) {
                
                k ++;
                if ([listDto.checkBtn isEqualToString:@"NO"]) {
                    isChange = @"NO";
                }
                if ([listDto.checkBtn isEqualToString:@"YES"]) {
                    j++;
                    
                }
            }
        }
        if (j == k) {
            isChange = @"YES";
        }
        if ([isChange isEqualToString:@"YES"]) {
            self.recordMemberDto.headCheckBtn = @"YES";
        }else if([isChange isEqualToString:@"NO"])
        {
            self.recordMemberDto.headCheckBtn = @"NO";
        }
        
        
        
    }

    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectOrderList:memberListDto:)]) {
        [self.delegate myOrderParentSelectOrderList:self.recordListDto memberListDto:self.recordMemberDto];
    }
    
}

- (void)setHideView:(NSString *)hideView
{
    [super setHideView:hideView];
    
    
    
    
    if ([hideView isEqualToString:@"top"]) {
        self.topViewHeight.constant =0 ;
        self.topViewCell.hidden = YES;
        
        self.bottomViewHeight.constant = 88;
        self.bottomViewCell.hidden = NO;
        
        
        
    }else if ([hideView isEqualToString:@"bottom"]) {
        self.bottomViewHeight.constant = 0;
        self.bottomViewCell.hidden = YES;
        
        self.topViewHeight.constant = 30;
        self.topViewCell.hidden =NO;
        
        
    }else if([hideView isEqualToString:@"all"])
    {
        self.topViewHeight.constant = 0;
        self.bottomViewHeight.constant = 0;
        self.bottomViewCell.hidden = YES;
        self.topViewCell.hidden = YES;
        
    }else if([hideView  isEqualToString:@"show"])
    {
        self.topViewHeight.constant = 30;
        self.bottomViewHeight.constant = 88;
        self.bottomViewCell.hidden = NO;
        self.topViewCell.hidden =NO;
    }
    
}
- (void)setOrderLsitDto:(OrderListDTO *)orderLsitDto
{
    [super setOrderLsitDto:orderLsitDto];
    self.recordListDto  = orderLsitDto;
    
    
    if ([orderLsitDto.checkBtn isEqualToString:@"YES"]) {
        self.MergeOrderBtn.selected = YES;
        
    }else
    {
        self.MergeOrderBtn.selected = NO;
    }
    
    

    
    //    sd_setImageWithURL
    [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:orderLsitDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //价格
//    NSMutableAttributedString *markRMBString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:9]}];
    NSMutableAttributedString *markRMBString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont systemFontOfSize:9]}];

    
    
    NSMutableAttributedString* contentString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",orderLsitDto.price.doubleValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:15]}];
    [markRMBString  appendAttributedString:contentString];
    
    self.goodsPriceLab.attributedText = markRMBString;
    
    
    
    NSMutableAttributedString* goodsNumbLabStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"x%ld",orderLsitDto.quantity.integerValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:13]}];
    self.goodsNumbLab.attributedText = goodsNumbLabStr;
    
    if (orderLsitDto.type.integerValue == 0) {
        self.orderTypeLab.text = @"【期货单】";
        self.orderTypeLab.textColor = [UIColor colorWithHex:0xeb301f alpha:1];
    }else{
        self.orderTypeLab.text = @"【现货单】";
        self.orderTypeLab.textColor = [UIColor colorWithHex:0x09bb07 alpha:1];
    }
    self.orderNumbLab.text = orderLsitDto.orderCode;
    self.goodsTotalNumLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderLsitDto.totalQuantity.integerValue];
    self.paymentStateLab.text = @"实付";
    
    //订单总价
    self.totalPriceLabl.text = [NSString stringWithFormat:@"¥ %2.f",orderLsitDto.originalTotalAmount.doubleValue];
    
    self.goodsNameLab.text = [NSString stringWithFormat:@"%@",orderLsitDto.goodsName];
    
    
//    NSMutableAttributedString* paymarkRMBString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:11]}];
    NSMutableAttributedString* paymarkRMBString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];

    
    NSMutableAttributedString* paymentStateLabStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",orderLsitDto.paidTotalAmount.doubleValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:18]}];
    [paymarkRMBString  appendAttributedString:paymentStateLabStr];
    
    self.paymentMoneyLab.attributedText = paymarkRMBString;
    
    
}
- (void)setMemberListDto:(MemberListDTO *)memberListDto
{
    [super setMemberListDto:memberListDto];
    
    self.recordMemberDto  = memberListDto;
    
}





@end
