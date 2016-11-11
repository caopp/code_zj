//
//  UpImageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "UpImageTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation UpImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}


- (IBAction)upImageBtnClick:(id)sender {
    
    UIButton * selectBtn = sender;
    if (self.selectImageBlock) {
        
        self.selectImageBlock(selectBtn.tag - 200);
    }
    
    
}
- (IBAction)deleteImageClick:(id)sender {
    
    UIButton * deleteBtn = sender;
    if (self.deleteImageBlock) {
        
        self.deleteImageBlock(deleteBtn.tag - 600);
    }
    
    
}



//!根据图片张数 显示按钮的个数
-(void)setImageBtnNumWithArray:(NSMutableArray *)imageArray{

    //!先把所有按钮隐藏
    for (int i = 0 ; i < 5; i++) {
        
        UIButton * imageBtn = (UIButton *)[self viewWithTag:(200+i)];
        imageBtn.hidden = YES;
        
        UIButton * delBtn = (UIButton *)[self viewWithTag:(600+i)];
        delBtn.hidden = YES;
        
        //!让图片显示中间部分
        imageBtn.imageView.clipsToBounds = YES;
        imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;

        imageBtn.userInteractionEnabled = YES;

    }
    
    //!显示有图片的按钮
    for (int i = 0 ; i< imageArray.count; i++) {
        
        
        UIButton * imageBtn = (UIButton *)[self viewWithTag:(200+i)];
        imageBtn.hidden = NO;
        
        
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:nil];

        UIButton * delBtn = (UIButton *)[self viewWithTag:(600+i)];
        delBtn.hidden = NO;
    
        imageBtn.userInteractionEnabled = NO;//!让有图片的时候不可以点击

    }

    //!显示最后一张图片
    if (imageArray.count != 5) {
        
        UIButton * btn = (UIButton *)[self viewWithTag:(200 + imageArray.count)];

        btn.hidden = NO;
        
    }
    
    //!有两行
    if (imageArray.count >= 3) {
        
        self.upImageBackViewHight.constant = 165;
    
    }else{
    
        self.upImageBackViewHight.constant = 165 - 80;//!80是一张图片在cell上面的高度
    }
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
