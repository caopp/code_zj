//
//  BaseTableViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marco.h"
@interface BaseTableViewController : UITableViewController

- (NSArray *)siftImagesFromImageList:(NSArray *)imageList withType:(CSPImageListType)type;

-(void)addCustombackButtonItem;
@end
