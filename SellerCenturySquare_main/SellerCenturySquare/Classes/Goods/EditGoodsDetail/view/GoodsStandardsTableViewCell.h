//
//  GoodsStandardsTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsStandardsTableViewCell;
@protocol GoodsStandardsDelegate <NSObject>

/**
 *  更改cell的内容
 *
 *  @param content 输入框的内容
 *  @param cell
 */
- (void)GoodsStandardsChangeContent:(NSString *)content currentCell:(GoodsStandardsTableViewCell*)cell;
/**
 *  获取当前的cell
 *
 *  @param cell
 */
- (void)GoodsStandardCurrentCell:(GoodsStandardsTableViewCell *)cell;


@end

@interface GoodsStandardsTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;

@property (nonatomic ,assign) id<GoodsStandardsDelegate>delegate;

@end
