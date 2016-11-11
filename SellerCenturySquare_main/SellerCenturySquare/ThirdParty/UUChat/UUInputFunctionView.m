//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#define DefaultThumImageHigth 90.0f
#define DefaultPressImageHigth 960.0f

#import "UUInputFunctionView.h"
#import "UUProgressHUD.h"
#import "ACMacros.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "CommonTools.h"
#import "STEmojiKeyboard.h"
#import "ReferralsGoodsView.h"
#import "ChatManager.h"
#import "AppDelegate.h"
@interface UUInputFunctionView ()<UITextViewDelegate, ReferralsGoodsDelegate, STEmojiKeySendDelegate>
{
    BOOL isbeginVoiceRecord;
    BOOL isPicInput;
    BOOL isEmojInput;
    BOOL isGoodsInput;
    NSInteger playTime;
    NSTimer *playTimer;
    
    UILabel *promptLabel;
    UILabel *placeHold;
    PicChooseView * picView;
    STEmojiKeyboard *keyboard;
    ReferralsGoodsView * referralsGoodsView;
    float textFloat;
    UITapGestureRecognizer *tap;
}
@end

@implementation UUInputFunctionView


- (id)initWithSuperVC:(ConversationWindowViewController *)superVC withIsCustomerConversation:(BOOL)isCustomer
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height - 50 - 64, Main_Screen_Width, 50);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        
        //添加按钮
        self.btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnPlus.frame = CGRectMake(Main_Screen_Width - 43, 9, 28, 28);
        [self.btnPlus setTitle:@"" forState:UIControlStateNormal];
        [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateNormal];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateHighlighted];
        [self.btnPlus addTarget:self action:@selector(choosePic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnPlus];
        self.btnPlus.hidden = NO;
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(15, 9, Main_Screen_Width - 106, 30)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.font = [UIFont systemFontOfSize:16];
        self.TextViewInput.returnKeyType = UIReturnKeySend;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];

        
        
        
        promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
        promptLabel.enabled = NO;
        promptLabel.text = @"我也说一句";
        promptLabel.font =  [UIFont systemFontOfSize:15];
        promptLabel.textColor = [UIColor lightGrayColor];
        [self.TextViewInput addSubview:promptLabel];
        
        
        //表情按钮
        self.btnEmoj = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width- 81, 9, 28, 28)];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateNormal];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateHighlighted];
        [self.btnEmoj addTarget:self action:@selector(emojInput:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnEmoj];
        
        keyboard = [STEmojiKeyboard keyboard];
        keyboard.textView = self.TextViewInput;
        keyboard.delegate = self;
        
        isPicInput = NO;
        isEmojInput = NO;
        isGoodsInput = NO;
        
        [self textViewDidEndEditing:self.TextViewInput];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        if ([BigBOrSmallB isEqualToString:@"SmallB"]) {
            picView = [[PicChooseView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 106) withtype:PlusType_Two];
            picView.delegate = self;
        }else {
            
            if (!isCustomer) {
                
                picView = [[PicChooseView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 106) withtype:PlusType_Two];
                picView.delegate = self;
            }else {
                
                picView = [[PicChooseView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 106) withtype:PlusType_Two];
                picView.delegate = self;
            }
        }
        
        [self queryGoods];
        
    }
    return self;
}

- (void)sendClick {
    
    //收缩键盘
    // [self.TextViewInput resignFirstResponder];
    isEmojInput = NO;
    [self sendMessage:nil];
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    //    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
    if (playTimer) {
        //        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
        //        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
    [UUProgressHUD dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)failRecord
{
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender {
    textFloat = 50 - 14;
    CGRect frame = self.frame;
    frame.origin.y -= textFloat+14-frame.size.height;
    CGRect frameText = self.TextViewInput.frame;
    frameText.size.height +=textFloat+14-frame.size.height;
    self.TextViewInput.frame = frameText;
    if (self.TextViewChangeBlock) {
        self.TextViewChangeBlock(textFloat+14-frame.size.height);
        
        
    }
    
    frame.size.height = textFloat +14;
    
    self.frame = frame;
    
    //  NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *resultStr = self.TextViewInput.text;
    NSLog(@"resultStr===%@",resultStr);
    if (resultStr.length > 0) {
        [self.delegate UUInputFunctionView:self sendMessage:resultStr];
    }
}

//图片
- (void)choosePic:(UIButton *)sender {
    
    //收缩键盘
    [self.TextViewInput resignFirstResponder];
    
    if (!isPicInput) {
        self.TextViewInput.inputView = picView;
        self.TextViewInput.inputAccessoryView = nil;
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateNormal];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateHighlighted];
        [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_键盘"] forState:UIControlStateNormal];
        [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_键盘"] forState:UIControlStateHighlighted];
        isEmojInput = NO;
        isGoodsInput = NO;
    }
    
    isPicInput = !isPicInput;
    
    [self.TextViewInput becomeFirstResponder];
}

//表情键盘
- (void)emojInput:(UIButton *)sender {
    
    //收缩键盘
    [self.TextViewInput resignFirstResponder];
    
    if (!isEmojInput) {
        self.TextViewInput.inputView = keyboard;
        self.TextViewInput.inputAccessoryView = nil;
        [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateNormal];
        [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateHighlighted];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_键盘"] forState:UIControlStateNormal];
        [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_键盘"] forState:UIControlStateHighlighted];
        isPicInput = NO;
        isGoodsInput = NO;
    }
    
    isEmojInput = !isEmojInput;
    
    [self.TextViewInput becomeFirstResponder];
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.showThridKeyboard = YES;
    return YES;
}


- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [promptLabel setHidden:NO];
    }else{
        [promptLabel setHidden:YES];
    }
    if (textFloat ==textView.contentSize.height) {
        
    }else{
        textFloat = textView.contentSize.height;
        CGRect frame = self.frame;
        frame.origin.y -= textFloat+14-frame.size.height;
        CGRect frameText = self.TextViewInput.frame;
        frameText.size.height +=textFloat+14-frame.size.height;
        self.TextViewInput.frame = frameText;
        if (self.TextViewChangeBlock) {
            self.TextViewChangeBlock(textFloat+14-frame.size.height);
            
            
        }
        
        frame.size.height = textFloat +14;
        
        self.frame = frame;
        
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.TextViewInput.keyboardType = UIKeyboardTypeDefault;
    self.TextViewInput.inputView = nil;
    [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateNormal];
    [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateHighlighted];
    [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateNormal];
    [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateHighlighted];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [self sendMessage:nil];
        // [self.TextViewInput resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - picDelegate
- (void)buttonAction:(NSInteger)index {
    
    if (index == 0) {
        [self openPicLibrary];
    }else if (index == 1) {
        [self addCarema];
    }else if (index == 2) {
        if (referralsGoodsView == nil) {
            referralsGoodsView = [[ReferralsGoodsView alloc] initWithDic:_getShopGoodsListDTO];
            referralsGoodsView.delegate = self;
        }
        //收缩键盘
        [self.TextViewInput resignFirstResponder];
        
        if (!isGoodsInput) {
            self.TextViewInput.inputView = referralsGoodsView;
            self.TextViewInput.inputAccessoryView = nil;
            self.TextViewInput.selectable = NO;
            
            [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateNormal];
            [self.btnEmoj setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_表情"] forState:UIControlStateHighlighted];
            [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateNormal];
            [self.btnPlus setBackgroundImage:[UIImage imageNamed:@"10_商品询单对话_添加"] forState:UIControlStateHighlighted];
            
            
            [self.TextViewInput  addGestureRecognizer:tap];
            
            
            isPicInput = NO;
            isEmojInput = NO;
            
            
        }else
        {
            [self.TextViewInput removeGestureRecognizer:tap];
            self.TextViewInput.editable = YES;
            
        }
        
        isGoodsInput = !isGoodsInput;
        
        [self.TextViewInput becomeFirstResponder];
    }
}


- (void)tap
{
    NSLog(@"点我了");
}
-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [self.superVC presentViewController:picker animated:YES completion:nil];
        [[picker navigationBar] setTintColor:[UIColor colorWithRed:78.0/255.0 green:148.0/255.0 blue:201.0/255.0 alpha:1]];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString* ext = imageURL.pathExtension.lowercaseString;
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([ext isEqualToString:@"gif"]) {
        [self saveGifToDocument:imageURL];
    } else {
        NSString *imagePath = [self saveToDocument:orgImage];
        [self.superVC dismissViewControllerAnimated:YES completion:^{
            [self.delegate UUInputFunctionView:self sendPicture:orgImage withUrl:imagePath];
        }];
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    //    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
    //        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
    //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    //    }
    viewController.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [viewController.view addSubview:statusBarView];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveGifToDocument:(NSURL *)srcUrl {
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset) {
        
        if (asset != nil) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *imageBuffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:(unsigned long)rep.size error:nil];
            NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
            
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
            NSString* fileName =[NSString stringWithFormat:@"%@.gif", [formater stringFromDate:[NSDate date]]];
            NSString* filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
            
            [imageData writeToFile:filePath atomically:YES];
            
            //            ECImageMessageBody *mediaBody = [[ECImageMessageBody alloc] initWithFile:filePath displayName:filePath.lastPathComponent];
            //            [self sendMediaMessage:mediaBody];
        } else {
        }
    };
    
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:srcUrl
                  resultBlock:resultBlock
                 failureBlock:^(NSError *error){
                 }];
}

-(NSString*)saveToDocument:(UIImage*)image {
    
    UIImage* fixImage = [self fixOrientation:image];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString* fileName =[NSString stringWithFormat:@"%@.jpg", [formater stringFromDate:[NSDate date]]];
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //图片按0.5的质量压缩－》转换为NSData
    CGSize pressSize = CGSizeMake((DefaultPressImageHigth/fixImage.size.height) * fixImage.size.width, DefaultPressImageHigth);
    UIImage * pressImage = [CommonTools compressImage:fixImage withSize:pressSize];
    NSData *imageData = UIImageJPEGRepresentation(pressImage, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    
    CGSize thumsize = CGSizeMake((DefaultThumImageHigth/fixImage.size.height) * fixImage.size.width, DefaultThumImageHigth);
    UIImage * thumImage = [CommonTools compressImage:fixImage withSize:thumsize];
    NSData * photo = UIImageJPEGRepresentation(thumImage, 0.5);
    NSString * thumfilePath = [NSString stringWithFormat:@"%@.jpg_thum", filePath];
    [photo writeToFile:thumfilePath atomically:YES];
    
    return filePath;
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage), 0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:              CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);              break;
    }       // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//推介商品发送按钮
- (void)sendButtonAction:(NSMutableArray *)sendGoodsArray {
    
    //收缩键盘
    [self.TextViewInput resignFirstResponder];
    referralsGoodsView = nil;
    
    if(self.delegate) {
        [self.delegate SendGoods:self withGoods:sendGoodsArray];
    }
}

//请求该商店的商品
- (void) queryGoods {
    [HttpManager sendHttpRequestForGetGoodsByChat:[ChatManager shareInstance].memberNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSArray *arr = [dic objectForKey:@"data"];
            NSMutableArray *shopList = [[NSMutableArray alloc]init];
            for(NSDictionary *shopGoodsDic in arr){
                
                ShopGoodsDTO *shopGoodsDTO = [[ShopGoodsDTO alloc ]init];
                [shopGoodsDTO setDictFrom:shopGoodsDic];
                
                [shopList addObject:shopGoodsDTO];
            }
            
            _getShopGoodsListDTO = [[GetShopGoodsListDTO alloc] init];
            _getShopGoodsListDTO. ShopGoodsDTOList= shopList;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

- (void)showKeyBoardhiddenAdd:(BOOL)hide
{
    
    if (hide) {
        self.btnPlus.hidden = hide;
        //        self.btnEmoj.hidden = hide;
        [self.TextViewInput becomeFirstResponder];
    }else
    {
        //        [self.TextViewInput  canBecomeFirstResponder];
        
        [self.TextViewInput resignFirstResponder];
        //         self.btnEmoj.hidden = NO;
        //        self.btnPlus.hidden = NO;
    }
    
}

- (void)setPromptContent:(NSString *)promptContent
{
    if (self.TextViewInput.text.length !=0) {
        [promptLabel setHidden:YES];
        
        
    }else
    {
        [promptLabel setHidden:NO];
        
    }
    promptLabel.text = promptContent;
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

@end
