//
//  GoodsManageTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsManageTableViewCell.h"

@implementation GoodsManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.newsSaleNumLabel setTextColor:[UIColor colorWithHex:0xfd4f57]];

    
    [self.wholesaleLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [self.retailLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [self.newsSaleLabel setTextColor:[UIColor colorWithHex:0x666666]];

    //!分割线
    [self.headerFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc]];
    
    [self.rightFilter setBackgroundColor:[UIColor colorWithHex:0xc8c7cc]];
    
    [self.leftFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc]];

    
}
-(void)configData:(GoodsMainDTO *)mainDTO{

    
    //!批发_在售 数量
    
    self.wholesaleNumLabel.text = [NSString stringWithFormat:@"%d", [mainDTO.wholesaleNum intValue]];
    
    //!零售_在售 数量
    self.retailNumLabel.text = [NSString stringWithFormat:@"%d",[mainDTO.retailNum intValue]];
    
    //!新发布 数量
    self.newsSaleNumLabel.text = [NSString stringWithFormat:@"%d",[mainDTO.newsGoodsNum intValue]];
    
    

}



//!批发_在售
- (IBAction)wholesaleClick:(id)sender {
    
    if (self.intGoodsManageVC) {
        
        self.intGoodsManageVC(1);
        
    }
    
    
}

//!零售_在售
- (IBAction)retailClick:(id)sender {
    
    if (self.intGoodsManageVC) {
        
        self.intGoodsManageVC(2);
        
    }
    
}

//!新发布
- (IBAction)newGoodsClick:(id)sender {
    
    if (self.intGoodsManageVC) {
        
        self.intGoodsManageVC(3);
        
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
