//
//  CPSChooseUploadReferImageCollectionViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSChooseUploadReferImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *referImageView;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

- (IBAction)selectedClick:(id)sender;
@end
