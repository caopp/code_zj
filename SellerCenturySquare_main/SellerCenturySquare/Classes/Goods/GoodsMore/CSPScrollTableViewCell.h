//
//  CSPScrollTableViewCell.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsMoreDTO.h"
#import "PhotoBrowserVM.h"
@interface CSPScrollTableViewCell : CSPBaseTableViewCell<MJPhotoBrowserDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *imgScroll;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scrollSegment;
@property (strong,nonatomic)GoodsMoreDTO *dtoMode;
-(void)loadMode:(GoodsMoreDTO *)dto;
@end
