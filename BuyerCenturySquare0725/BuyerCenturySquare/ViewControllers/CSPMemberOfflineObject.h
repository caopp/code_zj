//
//  CSPMemberOfflineObject.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CSPMemberOfflineObjectDelegate <NSObject>

- (void)offLineDidSelectAtRow:(NSIndexPath *)indexPath;

@end


@interface CSPMemberOfflineObject : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)id<CSPMemberOfflineObjectDelegate> delegate;

@end
