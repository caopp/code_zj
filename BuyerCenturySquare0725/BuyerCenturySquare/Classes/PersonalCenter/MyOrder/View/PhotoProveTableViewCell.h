//
//  PhotoProveTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplyDTO.h"


@interface PhotoProveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imagePhotoView;
@property (nonatomic ,strong) RefundApplyDTO *refundApp;
@property (nonatomic ,strong) NSArray *picsStr;

@end
