//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "SvGifView.h"
#import "UIImageView+WebCache.h"
#import "GetMerchantInfoDTO.h"
#import "HttpManager.h"
@interface UUMessageCell ()<UUAVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
    
    SvGifView * loadingGifView;
    
    NSIndexPath * cellIndexPath;
}
@end

@implementation UUMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellIndexPath = indexPath;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [[UIImageView alloc] init];
        self.btnHeadImage.layer.cornerRadius = (ChatIconWH - 4) / 2;
        self.btnHeadImage.layer.masksToBounds = YES;
//        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
//        self.labelNum = [[UILabel alloc] init];
//        self.labelNum.textColor = [UIColor grayColor];
//        self.labelNum.textAlignment = NSTextAlignmentCenter;
//        self.labelNum.font = ChatTimeFont;
//        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;
        
        self.messageStatus = UUMessageStatusSuccess;
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}


- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.type == UUMessageTypeVoice) {
        if(!contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
            audio = [UUAVAudioPlayer sharedInstance];
            audio.delegate = self;
            //        [audio playSongWithUrl:voiceURL];
            [audio playSongWithData:songData];
        }else{
            [self UUAVAudioPlayerDidFinishPlay];
        }
    }
    //show the picture
    else if (self.messageFrame.message.type == UUMessageTypePicture)
    {
        if (self.btnContent.backImageView) {
            [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.type == UUMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}


//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH - 4, ChatIconWH - 4);
    if (message.from == UUMessageFromMe) {
        if ([[GetMerchantInfoDTO sharedInstance].iconUrl length]&&[GetMerchantInfoDTO sharedInstance].iconUrl) {
           
            [self.btnHeadImage sd_setImageWithURL:[NSURL URLWithString:[GetMerchantInfoDTO sharedInstance].iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
        }else{
            [self.btnHeadImage setImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
        }
      

        //[self.btnHeadImage setImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    }else{
        [self.btnHeadImage sd_setImageWithURL:[NSURL URLWithString:message.strIcon] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
//        if (message.strIcon == nil || [message.strIcon isEqualToString:@""] || message.strIcon.length == 0) {
//            [self.btnHeadImage setImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
//        }else {
//            
//            [self.btnHeadImage sd_setImageWithURL:[NSURL URLWithString:message.strIcon] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
//        }
//        
    }

    // 3、设置下标
//    self.labelNum.text = message.strName;
//    if (messageFrame.nameF.origin.x > 160) {
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentRight;
//    }else{
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentLeft;
//    }

    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;
    
    if (message.from == UUMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 15, 30)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 15, 20)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    
    if (self.messageStatus != UUMessageStatusSuccess) {
        
        //根据信息状态改变提示
        if (self.messageStatus == UUMessageStatusOn) {
            NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"messageLoading" withExtension:@"gif"];
            CGRect btnContentFrame = self.btnContent.frame;
            CGFloat y = btnContentFrame.origin.y + btnContentFrame.size.height - 17;
            if (message.from == UUMessageFromMe) {
                loadingGifView = [[SvGifView alloc] initWithCenter:CGPointMake(0, 0) fileURL:fileUrl withX:btnContentFrame.origin.x - 20 withY:y];
            }else {
                loadingGifView = [[SvGifView alloc] initWithCenter:CGPointMake(0, 0) fileURL:fileUrl withX:btnContentFrame.origin.x + btnContentFrame.size.width + 5 withY:y];
            }
            loadingGifView.backgroundColor = [UIColor clearColor];
            loadingGifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self.contentView addSubview:loadingGifView];
            [loadingGifView startGif];
        }else {
            
            CGRect btnContentFrame = self.btnContent.frame;
            CGFloat y = btnContentFrame.origin.y + btnContentFrame.size.height - 22;
            UIButton * iconButton = [[UIButton alloc] initWithFrame:CGRectMake(btnContentFrame.origin.x - 36 ,y, 22, 22)];
            [iconButton setBackgroundImage:[UIImage imageNamed:@"chat_warning"] forState:UIControlStateNormal];
            
            if(self.messageStatus == UUMessageStatusFailure) {
                [iconButton addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if (self.messageStatus == UUMessageStatusForbid) {
                [iconButton addTarget:self action:@selector(forbidAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if (self.messageStatus == UUMessageStatusPicError) {
                [iconButton addTarget:self action:@selector(reReceiveAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self.contentView addSubview:iconButton];
        }
        
        
        
        
    }

    switch (message.type) {
        case UUMessageTypeText:
            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
            break;
        case UUMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.backImageView.image = message.picture;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case UUMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
            songData = message.voice;
//            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        }
            break;
            
        default:
            break;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.layer.masksToBounds = YES;
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

//重发按钮监听
- (void)reSendAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(messageReSend:withIndexPath:)])  {
        [self.delegate messageReSend:self withIndexPath:cellIndexPath];
    }
}

//禁言按钮监听
- (void)forbidAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(messageReSend:withIndexPath:)])  {
        [self.delegate messageforbid:self withIndexPath:cellIndexPath];
    }
}

//接受图片失败,重新接受
- (void)reReceiveAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receivePic:withIndexPath:)])  {
        [self.delegate receivePic:self withIndexPath:cellIndexPath];
    }
}

@end



