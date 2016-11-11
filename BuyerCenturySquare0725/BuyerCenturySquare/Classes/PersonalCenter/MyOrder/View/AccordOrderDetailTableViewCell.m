//
//  AccordOrderDetailTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AccordOrderDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UUImageAvatarBrowser.h"



@interface AccordOrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *showTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTimeViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *mailImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeLabTop;
@property (weak, nonatomic) IBOutlet UILabel *lineViewLab;

@end


@implementation AccordOrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageTap:)];
    self.mailImageView.userInteractionEnabled = YES;
    [self.mailImageView addGestureRecognizer:tap];
    self.cancelOrderTimeLab.hidden = YES;
    self.mailImageView.hidden = YES;
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//顶部head
- (void)setDetailDto:(OrderDetailDTO *)detailDto
{

    if (detailDto) {
        UILabel *recordLab;
        
        
        if ([self.orderType isEqualToString:@"header"]) {
            
        
        if (detailDto.mailTimesArr.count>0) {
            for (int i = 0 ; i<detailDto.mailTimesArr.count; i++) {
                
                if (i == 0) {
                    NSString *OrderTime =  detailDto.mailTimesArr[i];
                    
                    if ( detailDto.status ==3) {
                        
                        if (![detailDto.refundStatus isEqual:@""] ||[detailDto.refundStatus isKindOfClass:[NSNumber class]]) {

                            self.orderTimeLab.text = detailDto.mailTimesArr[i];
                            recordLab = self.orderTimeLab;
                        
                        }else
                        {
                            NSString *lastTimesStr = [OrderTime substringFromIndex:10];
                            NSString *fixTimeStr = [OrderTime substringToIndex:10];
                            NSMutableAttributedString * fixstr = [[NSMutableAttributedString alloc]initWithString:fixTimeStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x999999 alpha:1]}];
                            
                            NSMutableAttributedString * laststr = [[NSMutableAttributedString alloc]initWithString:lastTimesStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xef6c64 alpha:1]}];
                            [fixstr appendAttributedString:laststr];
                            
                            self.orderTimeLab.attributedText = fixstr;
                            
                            recordLab = self.orderTimeLab;
                        }
                        
                    }else
                    {

                        if (detailDto.status == 1) {
                            self.cancelOrderTimeLab.hidden = NO;

                            self.orderTimeLab.text = [NSString stringWithFormat:@"请在下单后72小时内付款\n%@",detailDto.mailTimesArr[i]];
                           self.showTimeViewHeight.constant = 50;
                            [self countDown:detailDto.createTime];
                            
                            
                        }else
                        {
                            self.orderTimeLab.text = detailDto.mailTimesArr[i];
                        }
                        recordLab = self.orderTimeLab;

                        
                        
                    }
                    
                }else
                {
                    if (recordLab) {
                        
                        NSString *contentTime = [NSString stringWithFormat:@"\n%@",detailDto.mailTimesArr[i]];
                        NSMutableAttributedString * appStr = [[NSMutableAttributedString alloc]initWithString:contentTime attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x999999 alpha:1]}];

                        
//                        recordLab.text = contentTime;
                        NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] init];
                        [temp appendAttributedString:self.orderTimeLab.attributedText];
                        [temp appendAttributedString:appStr];
                        
                        self.orderTimeLab.attributedText = temp;
                        
                        
                        
                        UILabel *label = [[UILabel alloc] init];
                        CGSize size = [self accordingContentFont:detailDto.mailTimesArr[i]];
                        
                        if (detailDto.status == 1) {
                            label.frame = CGRectMake(0, CGRectGetMaxY(recordLab.frame),self.showTimeView.frame.size.width,size.height+15);

                        }else
                        {
                            label.frame = CGRectMake(0, CGRectGetMaxY(recordLab.frame),self.showTimeView.frame.size.width,size.height);

                        }
                        
//                        [self.showTimeView addSubview:label];
                        label.text =  detailDto.mailTimesArr[i];
                        label.font = [UIFont systemFontOfSize:12];
                        
                        label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                        recordLab = label;
                        
                    }
                    if (detailDto.mailTimesArr.count == (i+1)) {
                        CGFloat viewHeight =CGRectGetMaxY(recordLab.frame);
                        self.showTimeViewHeight.constant = viewHeight;
                    }
                }
            }
        }
            
        }
        self.lineViewLab.hidden = YES;
    }
}

- (void)setDeliverDto:(OrderDeliveryDTO *)deliverDto
{
    self.lineViewLab.hidden = NO;
    if (deliverDto) {
        
        
        if ([self.changeTop isEqualToString:@"YES"]) {
            //隐藏时间的View
            self.showTimeView.hidden = YES;
            //显示时间的Label
            self.orderTimeLab.hidden = YES;
            
            self.orderTimeLabTop.constant = -10;
            
        }else
        {
            //显示时间的View
            self.orderTimeLab.hidden = NO;
            //显示时间的Label
            self.orderTimeLabTop.constant = 0;
            
        }
        
        //时间
        self.orderTimeLab.text = [NSString stringWithFormat:@"第%ld次发货时间: %@",(long)self.number,deliverDto.createTime];
        
        //拍照发货的图片
        
        if (deliverDto.deliveryReceiptImage.length>0) {
            self.mailImageView.hidden = NO;
            [self.mailImageView sd_setImageWithURL:[NSURL URLWithString:deliverDto.deliveryReceiptImage] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];
        }
        
        
        
    }
}
- (void)showImageTap:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImageView *tapImage = (UIImageView *)tap.view;
    [UUImageAvatarBrowser showImage:tapImage];
    
    
}

- (CGSize)accordingContentFont:(NSString *)str
{
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(400, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}

//底部footer
- (void)setDetailFooterDto:(OrderDetailDTO *)detailFooterDto
{
    self.lineViewLab.hidden = YES;

    if (detailFooterDto.mailEndTimesArr.count>0) {
                UILabel *recordLab;
        for (int i = 0 ; i<detailFooterDto.mailEndTimesArr.count; i++) {
            
            if (i == 0) {
                
                if (detailFooterDto.status == 1) {
                    self.cancelOrderTimeLab.hidden = NO;
                    self.orderTimeLab.text = [NSString stringWithFormat:@"请在下单后72小时内付款/n%@",detailFooterDto.mailEndTimesArr[i]];
                }else
                {
                    self.orderTimeLab.text = detailFooterDto.mailEndTimesArr[i];
                }
                recordLab = self.orderTimeLab;
            }else
            {
                if (recordLab) {
                    
                    
                    NSString *contentTime = [NSString stringWithFormat:@"\n%@",detailFooterDto.mailEndTimesArr[i]];
                    NSMutableAttributedString * appStr = [[NSMutableAttributedString alloc]initWithString:contentTime attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x999999 alpha:1]}];
                    
                    
                    //                        recordLab.text = contentTime;
                    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] init];
                    [temp appendAttributedString:self.orderTimeLab.attributedText];
                    [temp appendAttributedString:appStr];
                    
                    self.orderTimeLab.attributedText = temp;
                    
                    

                    UILabel *label = [[UILabel alloc] init];
                    CGSize size = [self accordingContentFont:detailFooterDto.mailEndTimesArr[i]];
                    label.frame = CGRectMake(0, CGRectGetMaxY(recordLab.frame),self.showTimeView.frame.size.width,size.height);
                    
//                    [self.showTimeView addSubview:label];
                    label.text =  detailFooterDto.mailEndTimesArr[i];
//                    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                    label.font = [UIFont systemFontOfSize:12];

                    label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                    
                    recordLab = label;
                    
                    
                }
                if (detailFooterDto.mailEndTimesArr.count == (i+1)) {
                    CGFloat viewHeight =CGRectGetMaxY(recordLab.frame);
                    self.showTimeViewHeight.constant = viewHeight;
                    
                    
                }
            }
        }
    }
}

#pragma mark 倒计时
-(void)countDown:(NSString  *)createTime{
    
    
    //!当前时间和下单时间相差72个小时以内，可以倒计时
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * createDate = [dateFormatter dateFromString:createTime];
    
    NSTimeInterval outTime = [nowDate timeIntervalSinceDate:createDate];//!得到当前时间和下单时间的间隔(已经过了的时间)
    
    int second72 = 72*60*60;//!把72小时转换成秒
    
    int remainSecond =  outTime - second72;//!查看间隔时间是否超过72小时
    
    if (remainSecond >= 0) {//!时间刚好相等，订单已经失效：0小时0分
        
        [self setRemainTime:@"0小时0分"];
        
    }else{//!倒计时
        
        timeInterval = second72 - outTime;//!总时间 - 已经过来的时间 = 剩下的秒数
        
        __block int timeout = timeInterval; // 要倒计时的时间
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setRemainTime:@"0小时0分"];
                    
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int hour = timeout/(60*60);//!剩下的秒数转化为小时
                    int seconds = timeout%(60*60);//!转化成小时剩下的秒数
                    int min = seconds/60;//!剩下的秒数转换成分钟
                    
                    [self setRemainTime:[NSString stringWithFormat:@"%d小时%d分",hour,min]];
                    
                });
                
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
        
        
    }
    
    
}
-(void)setRemainTime:(NSString *)remainTime{
    
    NSMutableAttributedString * remainLastStr = [[NSMutableAttributedString alloc]initWithString:@""];
    
    NSMutableAttributedString * remainStr = [[NSMutableAttributedString alloc]initWithString:@"还剩" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexValue:0x999999 alpha:1]}];
    
    NSMutableAttributedString * remainTimeStr = [[NSMutableAttributedString alloc]initWithString:remainTime attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexValue:0xf74a55 alpha:1]}];
    
    [remainLastStr appendAttributedString:remainStr];
    [remainLastStr appendAttributedString:remainTimeStr];
    
    self.cancelOrderTimeLab.attributedText = remainLastStr;
    
    
}



@end
