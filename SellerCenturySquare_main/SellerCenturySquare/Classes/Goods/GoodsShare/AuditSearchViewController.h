//
//  AuditSearchViewController.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "SDRefresh.h"
typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeSeller = 1,
    SearchTypeGoods = 2,
};

@interface AuditSearchViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,assign)SearchType searchType;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@end
