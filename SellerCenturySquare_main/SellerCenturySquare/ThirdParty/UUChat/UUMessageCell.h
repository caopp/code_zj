//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "UUMessage.h"
@class UUMessageFrame;
@class UUMessageCell;

@protocol UUMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
- (void)messageReSend:(UUMessageCell *)cell withIndexPath:(NSIndexPath *)indexPath;
- (void)messageforbid:(UUMessageCell *)cell withIndexPath:(NSIndexPath *)indexPath;
- (void)receivePic:(UUMessageCell *)cell withIndexPath:(NSIndexPath *)indexPath;
@end


@interface UUMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIImageView *btnHeadImage;

@property (nonatomic, assign)MessageStatus messageStatus;

@property (nonatomic, retain)UUMessageContentButton *btnContent;

@property (nonatomic, retain)UUMessageFrame *messageFrame;

@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;

@property (nonatomic,retain)NSString *memberNo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath;

@end

