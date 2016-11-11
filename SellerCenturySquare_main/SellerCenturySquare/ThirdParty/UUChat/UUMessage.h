//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 , // 文字
    UUMessageTypePicture  = 1 , // 图片
    UUMessageTypeVoice    = 2   // 语音
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};

typedef NS_ENUM(NSInteger, MessageStatus) {
    UUMessageStatusOn    = 0,         // 信息发送中
    UUMessageStatusSuccess = 1,       // 信息发送成功
    UUMessageStatusFailure = 2,       // 信息发送失败
    UUMessageStatusForbid = 3,        // 被禁言
    UUMessageStatusPicError = 4,      // 图片获取失败
};

@interface UUMessage : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;

@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *remotePath;

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;

@property (nonatomic, assign) BOOL showDateLabel;
@property (nonatomic, assign) MessageStatus messageStatus;

- (void)setWithDict:(NSDictionary *)dict withStaus:(MessageStatus)status;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
