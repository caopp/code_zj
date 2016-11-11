//
//  CPSGoodsDetailsPreviewTableViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
@interface CPSGoodsDetailsPreviewTableViewCell : CSPBaseTableViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *goodsScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *goodsPageControl;
@property (strong, nonatomic) IBOutlet UILabel *memberLevel;

@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtonS;
//@property(nonatomic,strong)NSArray *colorList;
@property (nonatomic,assign) NSInteger select_itm;
@property (nonatomic,copy)void (^downLoadButtonBlock)();

- (IBAction)downLoadButtonClick:(id)sender;


//@property (weak, nonatomic) IBOutlet UILabel *goodsColorLabel;


@property (weak, nonatomic) IBOutlet UILabel *batchNumLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleTitle;
@property (weak, nonatomic) IBOutlet UILabel *sampleTitleColor;

@property (weak, nonatomic) IBOutlet UILabel *samplePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *batchMsgLabel;

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limtMsgLabel;



@property (weak, nonatomic) IBOutlet UIButton *objectiveImageButton;

@property (weak, nonatomic) IBOutlet UIButton *referImageButton;

@property (nonatomic,copy)void (^objectiveImageButtonBlock)();

@property (nonatomic,copy)void (^referImageButtonBlock)();

- (IBAction)objectiveImageButtonClick:(id)sender;

- (IBAction)referImageButtonClick:(id)sender;

- (void)showObjectiveButton;

- (void)showReferButton;
//- (IBAction)colorChange:(UIButton *)sender;

@property(weak,nonatomic)IBOutlet UIImageView *goodsImageView;

@property(weak,nonatomic)IBOutlet UILabel *tipNoReferDataLabel;


@end
