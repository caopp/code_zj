//
//  NameCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "NameCell.h"
#import "Toast+UIView.h"

@implementation NameCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO{

    
    _goodsInfoDTO = goodsInfoDTO;
    
    [self.defaultImageView sd_setImageWithURL:[NSURL URLWithString:goodsInfoDTO.defaultPicUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
    
    //!限制50个字
    [self.goodsNameTextView setText:goodsInfoDTO.goodsName];

    self.goodsNameTextView.delegate = self;
    [self.goodsNameTextView sizeToFit];
    
}

- (IBAction)editGoodsNameBtnClick:(id)sender {
    
    
    [self changeEditStatus];
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{

    [self changeEditStatus];

}
-(void)textViewDidEndEditing:(UITextView *)textView{

    [self changeEditStatus];

}
-(void)textViewDidChange:(UITextView *)textView{


    if ([textView.text length] >30) {
        

        self.goodsNameTextView.text = [self.goodsNameTextView.text substringToIndex:30];
        
        //!显示提示
        if (self.nameCellShowAlerrMessageBlock) {
            
            self.nameCellShowAlerrMessageBlock(@"商品名称需要在30字以内");
            
        }
        
        [self.goodsNameTextView resignFirstResponder];
        
    }
    

}

-(void)changeEditStatus{
    
    
    if (self.isEdit) {
        
        [self.goodsNameTextView resignFirstResponder];
        [self.goodsNameTextView setBackgroundColor:[UIColor whiteColor]];
        self.isEdit = NO;
        
        _goodsInfoDTO.goodsName = self.goodsNameTextView.text;

        
    }else{
        
        
        [self.goodsNameTextView becomeFirstResponder];
        
        [self.goodsNameTextView setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
        
        self.isEdit = YES;
        

    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
