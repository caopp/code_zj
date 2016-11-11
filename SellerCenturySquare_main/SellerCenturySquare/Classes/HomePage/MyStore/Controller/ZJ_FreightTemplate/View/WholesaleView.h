//
//  WholesaleView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WholesaleViewLoad) {
    NormalTableViewLoad            = 0,
    EditorTableViewLoad            = 1,
};

@interface WholesaleView : UIView

@property (nonatomic,assign)WholesaleViewLoad viewLoad;

-(id)initWithFrame:(CGRect)frame nav:(UINavigationController *)nav;
@end
