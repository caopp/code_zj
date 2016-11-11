//
//  CSPDownloadImageView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDownloadImageView.h"

@implementation DownloadImgaeViewDTO

- (id)initWithGoodsNo:(NSString *)goodsNo downloadURL:(NSString *)downloadURL imageItems:(NSString *)imageItems imageType:(NSInteger)imageType picSize:(NSString *)picSize{
    self = [self init];
    if (self) {
        self.goodsNo = goodsNo;
        self.downloadURL = downloadURL;
        self.imageItems = imageItems;
        self.imgaeType = imageType;
        self.picSize = picSize;
        return self;
    }else{
        return nil;
    }
}

@end

@implementation CSPDownloadImageView

- (void)awakeFromNib{
    
    [self viewWithTag:101].backgroundColor = HEX_COLOR(0x666666F2);
    
    [self viewWithTag:102].backgroundColor = HEX_COLOR(0x999999FF);
    
    [self viewWithTag:103].backgroundColor = HEX_COLOR(0x666666F2);
    
}

#pragma mark-选择窗口图
- (IBAction)selectedWindownImageButtonClick:(id)sender{
    self.selectedWindownImageButton.selected = !self.selectedWindownImageButton.selected;

}

#pragma mark-选择客观图
- (IBAction)selectedObjectImageButtonClick:(id)sender{
    self.selectedObjectImgaeButton.selected = !self.selectedObjectImgaeButton.selected;

}


#pragma mark-下载
- (IBAction)downloadButtonClick:(id)sender{
    self.downLoadBlock();
}

- (void)showDownloadImageViewWithWindownDownloadImageViewDTO:(DownloadImgaeViewDTO *)windowDownloadImageViewDTO ObjectDownloadImageViewDTO:(DownloadImgaeViewDTO *)objectDownloadImageViewDTO downloadBlock:(DownLoadBlock)downloadBlock{
    NSString *windowSize = windowDownloadImageViewDTO.picSize.integerValue/1024.0 >1?[NSString stringWithFormat:@"商品窗口图(%@张/%.2fMB)",windowDownloadImageViewDTO.imageItems,windowDownloadImageViewDTO.picSize.integerValue/1024.0]:[NSString stringWithFormat:@"商品窗口图(%@张/%.2fKB)",windowDownloadImageViewDTO.imageItems,[windowDownloadImageViewDTO.picSize floatValue]];
    NSString *objectiveSize =objectDownloadImageViewDTO.picSize.integerValue/1024.0>1?[NSString stringWithFormat:@"商品客观图(%@张/%.2fMB)",objectDownloadImageViewDTO.imageItems,objectDownloadImageViewDTO.picSize.integerValue/1024.0]:[NSString stringWithFormat:@"商品客观图(%@张/%.2fKB)",objectDownloadImageViewDTO.imageItems,objectDownloadImageViewDTO.picSize.integerValue/1024.0];
    self.windowImageInfoLabel.text = windowSize;//[NSString stringWithFormat:@"商品窗口图(%@张/%.2fMB)",windowDownloadImageViewDTO.imageItems,windowDownloadImageViewDTO.picSize.integerValue/1024.0];
    
    self.objectiveImageInfoLabel.text = objectiveSize;//[NSString stringWithFormat:@"商品客观图(%@张/%.2fMB)",objectDownloadImageViewDTO.imageItems,objectDownloadImageViewDTO.picSize.integerValue/1024.0];
    
    self.downLoadBlock = downloadBlock;
}
@end
