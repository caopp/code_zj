//
//  RecommendPostScriptTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveGoodsRecommendModel.h"

@interface RecommendPostScriptTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) SaveGoodsRecommendModel *saveGoodsRecommendModel;

@end
