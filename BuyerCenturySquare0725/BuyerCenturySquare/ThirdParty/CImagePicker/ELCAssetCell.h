//
//  AssetCell.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELCAssetCellDelegate <NSObject>
-(void)ELCAssetCellShowSelectNub:(NSString *)nub;


@end
@interface ELCAssetCell : UITableViewCell

@property (nonatomic, assign) BOOL alignmentLeft;
@property (nonatomic ,assign)id<ELCAssetCellDelegate>delegate;

- (void)setAssets:(NSArray *)assets;

@end

