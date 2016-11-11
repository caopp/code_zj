//
//  PhotoAlbumViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/11.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"





@interface PhotoAlbumViewController : UIViewController<ELCAssetDelegate>


@property (nonatomic, weak) id <ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, strong) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;
//设置title名字
@property (nonatomic, strong) NSString *titlePT;

@property(nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (int)totalSelectedAssets;

- (void)preparePhotos;

- (void)doneAction:(id)sender;




@end
