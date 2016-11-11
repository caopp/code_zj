//
//  CenterNormalShopMessageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CenterNormalShopMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
@interface CenterNormalShopMessageTableViewCell ()
/**
 * 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPhotoImage;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
/**
 *  商品颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsColorLab;
/**
 *  商品尺码
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLab;
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

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *shootExpressSingleBtn;
@property (weak, nonatomic) IBOutlet UIButton *entryExpressSingleBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;



- (IBAction)selectShootExpressSingleBtn:(id)sender;
- (IBAction)selectEntryExpressSingleBtn:(id)sender;
- (IBAction)selectMergeOrderBtn:(id)sender;


@end


@implementation CenterNormalShopMessageTableViewCell

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
    if (btn.selected) {
        self.recordListDto.checkBtn = @"YES";
    }else
    {
        self.recordListDto.checkBtn = @"NO";
    }
    if (self.recordMemberDto.orderList.count > 0) {
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
    
    self.hidePart = hideView;

    
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
    self.recordListDto = orderLsitDto;
    
    
    
    if ([orderLsitDto.checkBtn isEqualToString:@"YES"]) {
        self.MergeOrderBtn.selected = YES;
        
    }else
    {
        self.MergeOrderBtn.selected = NO;
    }
    
    
    [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:orderLsitDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    
    if ([orderLsitDto.checkBtn isEqualToString:@"YES"]) {
        self.MergeOrderBtn.selected = YES;
        
    }else if ([orderLsitDto.checkBtn isEqualToString:@"NO"])
    {
        self.MergeOrderBtn.selected = NO;
    }
    
    self.goodsNameLab.text = orderLsitDto.goodsName;
    self.goodsColorLab.text = orderLsitDto.color;
    
//    
//    NSMutableAttributedString* markRMBString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:9]}];
//    
//    
    //价格
//    NSMutableAttributedString *markRMBString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:9]}];
    
    NSMutableAttributedString *markRMBString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont systemFontOfSize:9]}];

    

        NSMutableAttributedString* contentString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",orderLsitDto.price.doubleValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:15]}];
    [markRMBString  appendAttributedString:contentString];

    self.goodsPriceLab.attributedText = markRMBString;
    
    
    
    NSMutableAttributedString* goodsNumbLabStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"x%ld",orderLsitDto.quantity.integerValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:13]}];
    self.goodsNumbLab.attributedText = goodsNumbLabStr;
    
    
    if (orderLsitDto.totalAmount.integerValue == 0) {
        self.orderTypeLab.text = @"【期货单】";
    }else{
        self.orderTypeLab.text = @"【现货单】";
    }
    
    self.orderNumbLab.text = orderLsitDto.orderCode;
    self.goodsTotalNumLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderLsitDto.totalQuantity.integerValue];
    self.paymentStateLab.text = @"实付";
    
    //订单总价
    self.totalPriceLab.text = [NSString stringWithFormat:@"¥ %.2f",orderLsitDto.originalTotalAmount.doubleValue];
    
    
    
//    NSMutableAttributedString* paymarkRMBString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:11]}];
    NSMutableAttributedString* paymarkRMBString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];

    
    NSMutableAttributedString* paymentStateLabStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",orderLsitDto.paidTotalAmount.doubleValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:18]}];
    [paymarkRMBString  appendAttributedString:paymentStateLabStr];
    
    self.paymentMoneyLab.attributedText = paymarkRMBString;

    

    
    
    
    [self.sizesView removeFromSuperview];

    self.sizesView = [[UIView alloc] init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat sizesViewWidth = CGRectMake(CGRectGetMaxX(self.goodsSizeLab.frame), CGRectGetMinY(self.goodsSizeLab.frame), width-CGRectGetMaxX(self.goodsSizeLab.frame)-15, 30).size.width;
    
    [self addSubview:self.sizesView];
    CGFloat height = 0;
    
//    self.bottomViewHeight.constant = 0;
//    self.bottomViewCell.hidden = YES;
//    
//    self.topViewHeight.constant = 30;
//    self.topViewCell.hidden =NO;
    
    if (self.bottomViewCell.hidden &&!self.topViewCell.hidden) {
       
        height = 30;
        
//        self.hidePart = nil;
        
    }
    if ([self.hidePart isEqualToString:@"show"]) {
        height = 30;
        self.hidePart = nil;
    }

    self.sizesView.frame = CGRectMake(CGRectGetMaxX(self.goodsSizeLab.frame), CGRectGetMinY(self.goodsSizeLab.frame)+height, sizesViewWidth, 30);
    
//    [_sizesView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.goodsSizeLab.mas_top);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.left.equalTo(self.goodsSizeLab.mas_right).offset(5);
//        make.bottom.equalTo(self.bottomViewCell.mas_top).offset(-10);
//        
//    }];
    
    
    
    NSArray *sizesArr = [orderLsitDto.sizes componentsSeparatedByString:@","];
    if (sizesArr.count>0) {
        UILabel *recordLab;
        CGFloat recordShowTag = 1.0;
        CGFloat labY = 0.0;

        for (int i = 0; i<sizesArr.count; i++) {
            
            NSString *sizeStrs = sizesArr[i];
            NSArray *arrSize = [sizeStrs componentsSeparatedByString:@":"];
            
            
       NSString*sizeStr =      [NSString stringWithFormat:@"%@ x %@",[arrSize firstObject],[arrSize lastObject]];
            CGSize strSize = [self accordingContentFont:sizeStr];
            UILabel *label = [[UILabel alloc] init];
        
//            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            label.font = [UIFont systemFontOfSize:13];

            label.textColor = [UIColor colorWithHex:0x999999];
            label.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
            label.layer.borderWidth = 0.5f;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;

            [self.sizesView addSubview:label];
            label.text = sizeStr;
            
            
            if (recordLab) {
                if (CGRectGetMaxX(recordLab.frame)+(strSize.width+10)>sizesViewWidth) {
                    labY = labY + 23;
                    recordShowTag = 0;
                }
                label.frame = CGRectMake(CGRectGetMaxX(recordLab.frame)*recordShowTag+10, labY, strSize.width+10, strSize.height+4);
                recordShowTag = 1;
            }else
            {
                label.frame = CGRectMake(10, 0, strSize.width+10, strSize.height+4);
                
            }
            recordLab = label;
            
            if (sizesArr.count== (i+1)) {
                
                
                CGRect frame = self.sizesView.frame;
                
      
                
                    frame.size.height = CGRectGetMaxY(recordLab.frame);


//            [_sizesView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(CGRectGetMaxY(recordLab.frame)));
//                
//            }];
                self.sizesView.frame = frame;
            }
        }
    }
}



- (void)setMemberListDto:(MemberListDTO *)memberListDto
{
    [super setMemberListDto:memberListDto];
    
    self.recordMemberDto  = memberListDto;
    
}




- (CGSize)accordingContentFont:(NSString *)str
{
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}

@end
















