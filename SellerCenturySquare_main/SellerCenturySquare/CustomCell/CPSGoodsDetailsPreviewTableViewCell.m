//
//  CPSGoodsDetailsPreviewTableViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSGoodsDetailsPreviewTableViewCell.h"
#import "GetGoodsInfoListDTO.h"
#import "UIColor+UIColor.h"
@implementation CPSGoodsDetailsPreviewTableViewCell

- (void)awakeFromNib{
    
    self.goodsScrollView.delegate = self;
    
    self.tipNoReferDataLabel.textColor = HEX_COLOR(0x999999FF);
   CGRect rect =  self.priceLabel.frame;
    rect.origin.y -= 30;
    self.priceLabel.frame = rect;
    _memberLevel.layer.cornerRadius = 4.0f;
    _memberLevel.layer.masksToBounds = YES;

}

#pragma mark-下载图片
- (IBAction)downLoadButtonClick:(id)sender {
    
    self.downLoadButtonBlock();
}

- (IBAction)objectiveImageButtonClick:(id)sender{
    
    self.objectiveImageButtonBlock();
}

- (IBAction)referImageButtonClick:(id)sender{
    
    self.referImageButtonBlock();
}

- (void)showReferButton{
    
    self.referImageButton.backgroundColor = [UIColor whiteColor];
    
    [self.referImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.objectiveImageButton.backgroundColor = [UIColor blackColor];
    
    [self.objectiveImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)showObjectiveButton{
    self.objectiveImageButton.backgroundColor = [UIColor whiteColor];
    
    [self.objectiveImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.referImageButton.backgroundColor = [UIColor blackColor];
    
    [self.referImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = self.goodsScrollView.frame.size.width;
    
    int page = floor((self.goodsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.goodsPageControl.currentPage = page;
}



//-(void)setColorList:(NSMutableArray *)colorList{
//    NSInteger colorListCount = colorList.count;
//    
//    [_colorButtonS enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
//        
//        if (idx<colorListCount) {
//            [obj setHidden:NO];
//            GetGoodsInfoListDTO *goodsInfoDetails = [colorList objectAtIndex:idx];
//            [obj setTitle:goodsInfoDetails.color forState:UIControlStateNormal];
//            if (idx == _select_itm) {
//                UIImage *img= [UIImage imageNamed:@"color_normal"];
//                img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
//                obj.backgroundColor = [UIColor whiteColor];
//                [obj setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
//                [obj setBackgroundImage:img forState:UIControlStateNormal];
//            }
//
//        }else{
//            [obj setHidden:YES];
//        }
//        
//    }];
//    
//}

@end
