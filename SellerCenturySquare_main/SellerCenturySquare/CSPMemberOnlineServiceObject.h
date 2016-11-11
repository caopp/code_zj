//
//  CSPMemberOnlineServiceObject.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CSPMemberOnlineObjectDelegate <NSObject>

- (void)onLineDidSelectAtRow:(NSIndexPath *)indexPath;

@end

@interface CSPMemberOnlineServiceObject : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)id<CSPMemberOnlineObjectDelegate> delegate;

@end
