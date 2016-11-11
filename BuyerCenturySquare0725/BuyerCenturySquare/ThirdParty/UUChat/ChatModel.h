//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
#import "ECMessage.h"

@class UUMessageFrame;

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

@property (nonatomic, strong) NSString *previousTime;

- (void)populateRandomDataSource;

- (UUMessageFrame *)addSpecifiedItem:(NSDictionary *)dic withIsHistory:(BOOL)isHistory;

- (UUMessageFrame *)addOtherItem:(NSDictionary *)dic withIsHistory:(BOOL)isHistory;

- (UITableViewCell *)addOrderItem:(ECMessage *)message withIsHistory:(BOOL)isHistory;
@end
