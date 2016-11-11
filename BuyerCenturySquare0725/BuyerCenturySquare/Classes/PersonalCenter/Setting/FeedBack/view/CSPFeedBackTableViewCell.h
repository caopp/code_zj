//
//  CSPFeedBackTableViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

@interface CSPFeedBackTableViewCell : CSPBaseTableViewCell<UITextViewDelegate>



@property (weak, nonatomic) IBOutlet UILabel *feedBackTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;


@property (nonatomic,copy) void (^alertBlock) ();

@end
