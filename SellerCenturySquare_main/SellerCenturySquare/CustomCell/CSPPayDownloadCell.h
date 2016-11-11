//
//  CSPPayDownloadCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "CSPAmountControlView.h"
@interface CSPPayDownloadCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *illustrateLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UILabel *butCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipDownLoadAuthorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet CSPSkuControlView *skuControllView;
@end
