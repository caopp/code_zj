//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicChooseView.h"
#import "ConversationWindowViewController.h"
#import "GetShopGoodsListDTO.h"

@class UUInputFunctionView;

@protocol UUInputFunctionViewDelegate <NSObject>

// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image withUrl:(NSString *)url;

@optional
// audio
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

- (void)SendGoods:(UUInputFunctionView *)funcView withGoods:(NSMutableArray *)goods;

@end

@interface UUInputFunctionView : UIView <UIImagePickerControllerDelegate,UINavigationControllerDelegate, PicChooseDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UIButton *btnPlus;
@property (nonatomic, retain) UIButton *btnEmoj;
@property (nonatomic, retain) UITextView *TextViewInput;
@property (nonatomic ,strong) NSString *promptContent;
@property (nonatomic,copy)void (^TextViewChangeBlock)(float f);

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, retain) ConversationWindowViewController *superVC;

@property (nonatomic, assign) id<UUInputFunctionViewDelegate>delegate;

@property (nonatomic,strong) GetShopGoodsListDTO *getShopGoodsListDTO;


- (id)initWithSuperVC:(ConversationWindowViewController *)superVC withIsCustomerConversation:(BOOL)isCustomer;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

- (void)showKeyBoardhiddenAdd:(BOOL)hide;

@end
