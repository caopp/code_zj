//
//  CPSGoodsDetailsEditViewControllerCellID0.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/27.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSGoodsDetailsEditViewControllerCellID0 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *goodName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodNameHight;

-(void)getGoodName:(NSString *)goodName;


@end
