//
//  BatchTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BatchTableViewCell.h"

@implementation BatchTableViewCell


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.windowSizeLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    [self.objectSizeLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    

}


-(void)configData:(CSPDownLoadImageDTO *)downLoadImageDTO withEditStatus:(BOOL)editStatus{

    nowDownLoadImageDTO = downLoadImageDTO;
    
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:downLoadImageDTO.picListSmall] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    
    //!先把窗口图、客观图对应的控件都隐藏
    self.windowNumLabel.hidden = YES;
    self.windowSizeLabel.hidden = YES;
    self.windowBtn.hidden = YES;
    
    self.objectNumLabel.hidden = YES;
    self.objectSizeLabel.hidden = YES;
    self.objectBtn.hidden = YES;
    
    NSArray * zipList = downLoadImageDTO.zipsList;
    for (CSPZipsDTO * zipDTO in zipList) {
        
        //!窗口图：0，客观图：1
        if ([zipDTO.picType isEqualToString:@"0"]) {
            
            self.windowNumLabel.hidden = NO;
            self.windowSizeLabel.hidden = NO;
            self.windowBtn.hidden = NO;
            
            
            self.windowNumLabel.text = [NSString stringWithFormat:@"窗口图(%@张)",zipDTO.qty];
            self.windowSizeLabel.text = [self getPicSize:[zipDTO.picSize intValue]];
            
        
            
        }else{//!客观图
        
            self.objectNumLabel.hidden = NO;
            self.objectSizeLabel.hidden = NO;
            self.objectBtn.hidden = NO;
        
            self.objectNumLabel.text = [NSString stringWithFormat:@"客观图(%@张)",zipDTO.qty];
            self.objectSizeLabel.text = [self getPicSize:[zipDTO.picSize intValue]];
            
        }
    
        
    }
    
    
    
    

    self.isEditing = editStatus;

    //!按钮的显示
    if (self.isEditing) {//编辑状态
        
        //!窗口图 按钮
        [self.windowBtn setTitle:@"" forState:UIControlStateNormal];
        [self.windowBtn setImage:[UIImage imageNamed:@"04_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];
        [self.windowBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_选中"] forState:UIControlStateSelected];
        
        //!客观图 按钮
        [self.objectBtn setTitle:@"" forState:UIControlStateNormal];
        [self.objectBtn setImage:[UIImage imageNamed:@"04_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];
        [self.objectBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_选中"] forState:UIControlStateSelected];
        
        //!改变选中状态
        self.windowBtn.selected = downLoadImageDTO.selectWindow;
        self.objectBtn.selected = downLoadImageDTO.selectObject;
        
        
    }else{
        
        //!窗口图 按钮
        [self.windowBtn setTitle:@"下载" forState:UIControlStateNormal];
        self.windowBtn.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:1].CGColor;
        self.windowBtn.layer.borderWidth = 1;
        [self.windowBtn setTitleColor:[UIColor colorWithHex:0x999999 alpha:1] forState:UIControlStateNormal];
        
        
        [self.windowBtn setImage:nil forState:UIControlStateNormal];
        [self.windowBtn setImage:nil forState:UIControlStateSelected];
        
        //!客观图 按钮
        [self.objectBtn setTitle:@"下载" forState:UIControlStateNormal];
        self.objectBtn.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:1].CGColor;
        self.objectBtn.layer.borderWidth = 1;
        [self.objectBtn setTitleColor:[UIColor colorWithHex:0x999999 alpha:1] forState:UIControlStateNormal];
        
        
        [self.objectBtn setImage:nil forState:UIControlStateNormal];
        [self.objectBtn setImage:nil forState:UIControlStateSelected];
        
    }



}

/*
 不满足1MB，显示为kb
 不满足1GB，显示mb
 不满足1TB,显示G
 
 fileContentSize 单位:kb
 1T = 1024G
 1G = 1024MB
 1MB = 1024kb
 
 */
-(NSString *)getPicSize:(int)fileContentSize{
    
    NSString * sizeStr = @"";
    
    // 1T = 1024G = 1024 * 1024 MB = 1024*1024*1024 kb = 1024*1024*1024*1024 b
    double tbSize = pow(CONVERT, 3);
    double gbSize = pow(CONVERT, 2);
    double mbSize = pow(CONVERT, 1);
//    double kbSize = CONVERT;
    
    if (fileContentSize>=tbSize) {//!大于T
        
        sizeStr = [NSString stringWithFormat:@"%.2fTB",fileContentSize/tbSize];
        
    }else if (fileContentSize>=gbSize){//!大于GB
        
        sizeStr = [NSString stringWithFormat:@"%.2fGB",fileContentSize/gbSize];
        
    }else if (fileContentSize>=mbSize){
        
        sizeStr = [NSString stringWithFormat:@"%.2fMB",fileContentSize/mbSize];
        
    }else{
        
        sizeStr = [NSString stringWithFormat:@"%.2dkb",fileContentSize];
        
    }
    
    
    return sizeStr;
    
    
}


- (IBAction)windowBtnClick:(id)sender {
    
    //!编辑的时候
    if (self.isEditing) {
        
        self.windowBtn.selected = !self.windowBtn.selected;
        
        nowDownLoadImageDTO.selectWindow = self.windowBtn.selected;//!记录里面的选中状态 == 按钮的选中状态
        
        if (self.changeSelectStatusInEditing) {
            
            self.changeSelectStatusInEditing(self.windowBtn.selected);
            
        }
        
        
    }else{//!非编辑的时候，进行下载
        
        if (self.downloadBlock) {
            
            self.downloadBlock(@"0"); //!窗口图：0，客观图：1
            
        }
    
    }

    
}

- (IBAction)objectBtnClick:(id)sender {
    
    //!编辑的时候
    if (self.isEditing) {
        
        self.objectBtn.selected = !self.objectBtn.selected;
        
        nowDownLoadImageDTO.selectObject = self.objectBtn.selected;//!记录里面的选中状态 == 按钮的选中状态

        if (self.changeSelectStatusInEditing) {
            
            self.changeSelectStatusInEditing(self.objectBtn.selected);
            
        }

        
    }else{//!非编辑的时候，进行下载
        
        if (self.downloadBlock) {
            
            self.downloadBlock(@"1"); //!窗口图：0，客观图：1
            
        }
        
    }
    
}


@end
