//
//  BottomSendGoodsTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomSendGoodsTableViewCell : UITableViewCell


/**
 *  拍摄快递单发货
 */
@property (weak, nonatomic) IBOutlet UIButton *photoMailBtn;
/**
 *  录入快递单发货
 */
@property (weak, nonatomic) IBOutlet UIButton *entryMailBtn;


/**
 *  点击拍摄快递单发货
 */
- (IBAction)selectPhotoMailBtn:(id)sender;

/**
 *  点击录入快递单发货
 */
- (IBAction)selectEntryMailBtn:(id)sender;


@end
