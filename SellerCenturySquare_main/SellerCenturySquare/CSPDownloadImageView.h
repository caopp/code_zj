//
//  CSPDownloadImageView.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface DownloadImgaeViewDTO : NSObject
@property(nonatomic,copy)NSString *goodsNo;
@property(nonatomic,copy)NSString *downloadURL;
@property(nonatomic,copy)NSString *imageItems;
@property(nonatomic,assign)NSInteger imgaeType;
@property(nonatomic,copy)NSString *picSize;

- (id)initWithGoodsNo:(NSString *)goodsNo downloadURL:(NSString *)downloadURL imageItems:(NSString *)imageItems imageType:(NSInteger)imageType picSize:(NSString *)picSize;
@end


typedef void(^DownLoadBlock)();

@interface CSPDownloadImageView : CSPBaseCustomView

@property(nonatomic,copy)DownLoadBlock downLoadBlock;

@property (weak, nonatomic) IBOutlet UILabel *windowImageInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectiveImageInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedWindownImageButton;

@property (weak, nonatomic) IBOutlet UIButton *selectedObjectImgaeButton;

- (IBAction)selectedWindownImageButtonClick:(id)sender;

- (IBAction)selectedObjectImageButtonClick:(id)sender;


- (IBAction)downloadButtonClick:(id)sender;

//@property (nonatomic,copy)void (^downloadObjectiveImageBlock)();
//
//@property (nonatomic,copy)void (^downLoadReferImageBlock)();

//@property (nonatomic,copy)void (^downLoadBlock)();

- (void)showDownloadImageViewWithWindownDownloadImageViewDTO:(DownloadImgaeViewDTO *)windowDownloadImageViewDTO ObjectDownloadImageViewDTO:(DownloadImgaeViewDTO *)objectDownloadImageViewDTO downloadBlock:(DownLoadBlock)downloadBlock;

@end
