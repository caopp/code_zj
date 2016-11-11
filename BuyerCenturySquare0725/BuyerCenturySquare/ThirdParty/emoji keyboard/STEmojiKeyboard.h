//
//  STEmojiKeyboard.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STEmojiKeySendDelegate <NSObject>

- (void)sendClick;

@end


@interface STEmojiKeyboard : UIView <UIInputViewAudioFeedback>

@property (nonatomic, assign) id<STEmojiKeySendDelegate> delegate;

+ (instancetype)keyboard;
@property (strong, nonatomic) id<UITextInput> textView;
@end


