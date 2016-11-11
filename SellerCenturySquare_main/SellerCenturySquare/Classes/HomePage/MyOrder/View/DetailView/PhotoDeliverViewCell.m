//
//  PhotoDeliverViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PhotoDeliverViewCell.h"
#import "UUImageAvatarBrowser.h"

@implementation PhotoDeliverViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.timeLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    [self.fliterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//!num:数组中的第几个值
-(void)configData:(OrderDeliveryDTO *)deliverDTO withNum:(NSInteger)num{
    

    if (num == 0) {
        
        [self.timeLabel removeFromSuperview];
        
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"第%ld次发货时间：%@",(long)num + 1,deliverDTO.createTime];//!数组是从0开始的，第0次 即 第1次
    
    [self.deliverImageView sd_setImageWithURL:[NSURL URLWithString:deliverDTO.deliveryReceiptImage] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];


    //!快递单图片轻击事件
    UITapGestureRecognizer * tapGesutre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    self.deliverImageView.userInteractionEnabled = YES;
    [self.deliverImageView addGestureRecognizer:tapGesutre];
    

}

-(void)tapImageView:(UITapGestureRecognizer *)sender{

    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    UIImageView * imageView = (UIImageView *)tap.view;
    
    if (imageView.image) {
       
        [UUImageAvatarBrowser showImage:imageView];
 
        
    }
    
    

}


@end
