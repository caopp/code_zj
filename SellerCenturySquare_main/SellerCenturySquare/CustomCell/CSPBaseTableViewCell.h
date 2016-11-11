//
//  CSPBaseTableViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPBaseTableViewCell : UITableViewCell
-(NSMutableAttributedString *)createStringWithString:(NSString *)strMode withRange:(NSRange)range;
@end
