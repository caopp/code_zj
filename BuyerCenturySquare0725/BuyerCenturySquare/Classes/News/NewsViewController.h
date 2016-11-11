//
//  NewsViewController.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 15/12/22.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSegmentView.h"
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, CSPNewsStyle) {
    
    CSPNewsStyleTime,
    CSPNewsStyleShop,
    
};
@interface NewsViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *newsTableView;
@property (strong, nonatomic) IBOutlet SMSegmentView *segment;
@property(nonatomic,assign)CSPNewsStyle observe;
@end
