//
//  UpLoadPhotosViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "UpLoadPhotosViewController.h"
#import "Masonry.h"
#import "UIColor+UIColor.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIImage+Compression.h"
#import "GUAAlertView.h"
#import "AuditStatusViewController.h"
#import "PhotoPreviewController.h"
#import "ReleaseTestOnceView.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define mainScreen [UIScreen mainScreen].bounds.size


@interface UpLoadPhotosViewController ()<UITextViewDelegate, ELCImagePickerControllerDelegate,MJPhotoBrowserDelegate ,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIButton *photoBtn;
    UIImageView *recordImage;
    UIImageView *nextRecord;
    
    UILabel *photoLabel;
    int next;
    NSString *recordContent;
    GUAAlertView *alert;
    
    
    BOOL isUp;
    
    
}
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UITextView *textViewField;
@property (nonatomic ,strong)UIView *showImageView;
@property (nonatomic ,strong)NSMutableArray *photoOriginally;
@property (nonatomic ,strong)UIImagePickerController *imagePickerController;
@property (nonatomic ,strong)NSMutableString *imageStr;
@property (nonatomic ,strong)NSMutableArray *dataImageArr;

@property (nonatomic ,strong)UIButton *bottomBtn;





@end

@implementation UpLoadPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.releaseType isEqualToString:@"1"]) {
        self.title = @"发测评";
    }else if ([self.releaseType isEqualToString:@"0"])
    {
        self.title = @"发资讯";
    }

    [self customBackBarButton];


    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [self barButtonWithtTitle:@"取消" font:[UIFont systemFontOfSize:16]];
    
    self.dataImageArr = [[NSMutableArray alloc] init];
    
    self.photoOriginally = [[NSMutableArray alloc] init];
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.navigationController.view addSubview:self.progressHUD];

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(elcImagePickerControllerDidCancel:) name:@"cacelPhotoPage" object:nil];
   
    

    [self setUI];
    
    if (self.releaseType.integerValue ==1 &&[self.mark isEqualToString:@"show"]) {
        ReleaseTestOnceView *releaseView = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseTestOnceView" owner:self options:nil]lastObject];
        releaseView.blockTest = ^(ReleaseTestOnceView *view)
        {
            [view removeFromSuperview];
            
        };
        [self.view addSubview:releaseView];
        
        [releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            
        }];
        
    }
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

//取消按钮的点击方法
 - (void)rightButtonClick:(UIButton *)sender
{
    [self. textViewField resignFirstResponder];
    
    if (alert) {
        [alert removeFromSuperview];
        
    }
    alert = [GUAAlertView alertViewWithTitle:@"确定放弃编辑？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        self.progressHUD.hidden = YES;
        
    } dismissAction:^{
        
    }];
    [alert show];
    
}


- (void)progressHUDShowWithString:(NSString *)string{
    
    [self.progressHUD show:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.progressHUD.labelText = string;
}
//sendHttpRequestForeleasedMeasurementContent
- (void)viewWillAppear:(BOOL)animated
{
    self.bottomBtn.userInteractionEnabled = YES;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(updateReferImageAndContent) name:@"FINISHUPDATA" object:nil];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FINISHUPDATA" object:nil];
//    self.navigationController.navigationBar.translucent = YES;

}

#pragma mark - ViewDidLoad

- (void)setUI
{
    
    //创建一个滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.userInteractionEnabled = YES;
    
    //布局
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
        make.width.equalTo(self.view);
    }];
    self.scrollView = scrollView;
    
    //设置滚动视图的子视图
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
    }];
    
    
    //输入框提示文字
    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(15);
        make.left.equalTo(scrollView).offset(15);
        
    }];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"文字: 最多140字";
    
    //输入框
    self.textViewField = [[UITextView alloc] init];
    self.textViewField.delegate = self;
    self.textViewField.scrollEnabled = NO;
    self.textViewField.userInteractionEnabled = YES;
    
    self.textViewField.font = [UIFont systemFontOfSize:13];
    
    
    [scrollView addSubview:self.textViewField];
    //布局
    [self.textViewField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@140);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    //设置边框颜色
    self.textViewField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    self.textViewField.layer.borderWidth = 1;
    self.textViewField.layer.cornerRadius = YES;
    self.textViewField.userInteractionEnabled = YES;

    //照片提示文字
    photoLabel = [[UILabel alloc] init];
    [contentView addSubview:photoLabel];
    
    //布局
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(self.textViewField.mas_bottom).offset(15);
        make.width.equalTo(self.view.mas_width);
        
        
    }];
    photoLabel.text = @"图片: 最多9张";
    photoLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //字体显示
    photoLabel.font = [UIFont systemFontOfSize:15];
    //更改显示内容
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photoLabel.mas_bottom).offset(500);
        
        
    }];
    
    self.showImageView = [[UIView alloc] init];
    [self.view addSubview:self.showImageView];
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoLabel.mas_bottom).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@200);
        
    }];
    
    //添加图片按钮
    photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showImageView addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImageView).offset(15);
        make.top.equalTo(self.showImageView.mas_top);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    [photoBtn addTarget:self action:@selector(addPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"Businesscircle_addPhoto"] forState:UIControlStateNormal];
    
    self.bottomBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.bottomBtn];
    
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@46);
        
        
    }];
    
    self.bottomBtn.backgroundColor = [UIColor blackColor];
    [self.bottomBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(upDataMessage:) forControlEvents:UIControlEventTouchUpInside];
    

    
}



/**
 *  显示相片的样式
 *
 *  @param type 样式
 */
- (void)showImagePickerPreferType:(UIImagePickerControllerSourceType)type {
    
    if(YES) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:type]) {
            sourceType = type;
        }
        self.imagePickerController.sourceType = sourceType;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

//选择相册初始化
- (UIImagePickerController*)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
    }
    return _imagePickerController;
}



/**
 *  删除、添加图片 重新布局
 */
- (void)againMaskUI
{
    if (self.showImageView.subviews.count) {
        recordImage = nil;
    }
    
    for (id imageView  in self.showImageView.subviews) {
        [imageView removeFromSuperview];
    }
    
    if (self.photoOriginally.count == 0) {
        
        photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.showImageView addSubview:photoBtn];
        [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.showImageView).offset(15);
            make.top.equalTo(self.showImageView.mas_top);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
            
        }];
        
        [photoBtn addTarget:self action:@selector(addPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"Businesscircle_addPhoto"] forState:UIControlStateNormal];
        
        
        return;
        
    }
    int i =0 ;
    next = 0;
    for (NSDictionary *photoDic in self.photoOriginally) {
        i++;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.showImageView addSubview:imageView];
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInPhoto:)];
        
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@80);
            if (!recordImage) {
                make.left.equalTo(self.showImageView.mas_left).offset(15);
                make.top.equalTo(self.showImageView.mas_top).offset(next);
                
            }else{
                make.top.equalTo(self.showImageView.mas_top).offset(next);
                
                make.left.equalTo(recordImage.mas_right).offset(5);
                
            }
            
        }];
        
        UIImage *thumbnailImage =[photoDic objectForKey:UIImagePickerControllerOriginalImage];;
        NSLog(@"photoOriginally = %@",self.photoOriginally);
        
        imageView.image = thumbnailImage;
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        recordImage =  imageView ;
        if (i == 4) {
            next = 90;
            
            
            recordImage = nil;
        }else if (i ==8)
        {
            next = 180;
            recordImage = nil;
            
        }
        
        if (i == (self.photoOriginally.count)) {
            if (i==9) {
                return;
                
            }
            //添加图片按钮
            photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.showImageView addSubview:photoBtn];
            
            [photoBtn addTarget:self action:@selector(addPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
            [photoBtn setBackgroundImage:[UIImage imageNamed:@"Businesscircle_addPhoto"] forState:UIControlStateNormal];
            [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@80);
                make.height.equalTo(@80);
                if (!recordImage) {
                    
                    make.left.equalTo(self.showImageView.mas_left).offset(15);
                    make.top.equalTo(self.showImageView.mas_top).offset(next);
                    
                }else{
                    make.top.equalTo(self.showImageView.mas_top).offset(next);
                    if (i ==9) {
                        [photoBtn removeFromSuperview];
                        
                        
                    }else {
                        make.left.equalTo(recordImage.mas_right).offset(5);
                    }
                }
                
            }];
        }
        
    }
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Click


- (void)addPhotoBtn:(UIButton* )btn
{
    
    [self.textViewField resignFirstResponder];
    
    
    UIActionSheet *actionTitle = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从手机中选择" otherButtonTitles:@"拍照", nil];
    [actionTitle showInView:self.view];
    
}





/**
 *  按钮点击放大
 */
- (void)zoomInPhoto:(UITapGestureRecognizer *)tap
{
    
    UIImageView *tapImageView = (UIImageView *)tap.view;
    
    
    PhotoPreviewController *previewVC = [[PhotoPreviewController alloc]init];
    
    previewVC.intoNum = tapImageView.tag;//!选中的是第几张图片
    
    previewVC.dataArray = self.photoOriginally;//!显示的数据
    
    //!因为把这个数组对象传到下一个界面，下一个界面直接对这个数组对象删除，间接更改了这边的数组
    previewVC.delegateBlock = ^(){
    
        //!删除、添加图片 重新布局
        [self againMaskUI];
    
    };
    
    [self.navigationController pushViewController:previewVC animated:YES];
    
}

//发布
- (void)upDataMessage:(UIButton *)btn
{
    
    
    if (self.textViewField.text.length ==0 &&self.photoOriginally.count==0 ) {
        
        if (alert) {
            [alert removeFromSuperview];
            
        }
        alert = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"内容不能为空" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            
            
        } dismissAction:^{
            
        }] ;
        [alert show];
        
        return;
    }
    
    if (alert) {
        [alert removeFromSuperview];
        
    }
    
    alert = [GUAAlertView alertViewWithTitle:@"确定发布" withTitleClor:nil message:@"发布的内容需经过平台审核后,才会显示在商圈中。" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [self progressHUDShowWithString:@"发布中"];
        
        
        if (self.photoOriginally.count == 0) {
            
            [self updateReferImageAndContent];
            
        }else{
            [self uploadReferImage];
            
        }
        
    } dismissAction:^{
        
    }] ;
    [alert show];
    
    
    
}



#pragma mark - delegate

#pragma mark ELCImagePickerControllerDelegate

//完成图片选择
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.photoOriginally addObjectsFromArray:info];
    [self againMaskUI];
    
}

//取消图片
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark  UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%lu",(long)buttonIndex);
    
    NSString *titleStr;
    if (buttonIndex == 0) {
        
        titleStr = @"请在iPhone“设置-隐私-照片”中允许访问照片";
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
        {
            //无权限
            [self.view makeMessage:titleStr duration:2.0 position:@"center"];
            
            return;
            
        }
    
        
    }else if (buttonIndex==1)
    {
        titleStr = @"请在iPhone“设置-隐私-相机”中允许访问相机";
        
        //!相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized )
        {
            
            [self.view makeMessage:titleStr duration:2.0 position:@"center"];
            
            return;
            
        }

        
    }

    if (buttonIndex == 0) {
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        //限制选中的个数
        elcPicker.maximumImagesCount = 9-self.photoOriginally.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = YES;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //模态出来控制页面
        [self presentViewController:elcPicker animated:YES completion:nil];
        
        
    }else if (buttonIndex==1)
    {
        [self showImagePickerPreferType:UIImagePickerControllerSourceTypeCamera];
        
        
    }
    
}



#pragma mark UIImagePickerControllerDelegate


//拍摄完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [self.photoOriginally addObject:info];
    [self againMaskUI];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//取消相册方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//防止图片旋转的方法

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

#pragma mark UITextViewDelegate 

//监测字符
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length >= 140)
         {
        textView.text = recordContent;
        return;
    }
    recordContent = textView.text;
    
}



#pragma mark -MJPhotoBrowserDelegate

- (void)photoBrowserDeletePhoto:(UIImageView *)image
{
    
    for (int i = 0; i<self.photoOriginally.count; i++) {
        NSDictionary *dic = self.photoOriginally[i];
        
        UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
        
        if (image.image  == img) {
            [self.photoOriginally removeObjectAtIndex:i];
            [self againMaskUI];
        }
    }
}



#pragma mark - HTTPRequest
#pragma mark-确定发布
- (void)uploadReferImage{

    //!标志正在发布，等发布完毕，或者失败再标志为没有发布
    isUp = YES;
    //!轮流取每张
    NSDictionary *photoDic =[self.photoOriginally objectAtIndex:0];
    UIImage *image = photoDic[UIImagePickerControllerOriginalImage];
//    UIImage *image = [UIImage imageNamed:@"1_1.jpg"];
    
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);

    //设置image的尺寸
    CGSize imagesize = image.size;
    
    CGFloat proportion = (CGFloat)mainScreen.width/(CGFloat)imagesize.width;
    
    DebugLog(@"width = %f height = %f",mainScreen.width,mainScreen.height);
    DebugLog(@"Ywidth = %f Yheight = %f",image.size.width,image.size.height);
    
    imagesize.height = image.size.height * proportion * 2;
    imagesize.width  = mainScreen.width * 2;
    
    
    //对图片大小进行压缩--
    image = [self imageWithImage:image scaledToSize:imagesize];

    
    image = [UIImage reduceImage:image percent:0.00001f] ;
    image = [self fixOrientation:image];
    
    
    
    
    
    NSData *imageData = [self getDataWithImage:image];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    NSLog(@"%@",NSHomeDirectory());
    
//    NSString*filepath=[NSHomeDirectory() stringByAppendingPathComponent:@"fmdb"];
    

    

    
    
    //发布参考图时不需要orderCode
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"7" orderCode:nil goodsNo:nil file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        DebugLog(@"responseDic = %@", responseDic);
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            NSString *dataImage =  [[responseDic[@"data"] componentsSeparatedByString:@";"] objectAtIndex:0];
            [self.dataImageArr addObject:dataImage];
            //            //删除第一条
            [self.photoOriginally removeObjectAtIndex:0];
            
            if (self.photoOriginally.count) {
                
                [self uploadReferImage];
                
            }else{
                
                //!标志为没有在发布
                isUp = NO;
                
                
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"FINISHUPDATA" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
            
        }else{
            
            //!标志为没有在发布
            isUp = NO;
            

            
            [self alertViewWithTitle:@"发布失败" message:[responseDic objectForKey:ERRORMESSAGE]];

            
            self.progressHUD.hidden = YES;
            [self.dataImageArr removeAllObjects];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        self.bottomBtn.userInteractionEnabled = YES ;

        [self tipRequestFailureWithErrorCode:error.code];
        //!标志为没有在发布
        isUp = NO;
    }];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}



//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}




- (void)updateReferImageAndContent
{
    NSString *imgUrl = nil;

    if (self.dataImageArr.count!=0) {

    NSLog(@"dataImageArr = %@",self.dataImageArr);
    
    
    
    for (int i = 0; i<self.dataImageArr.count; i++) {
        
        if ( i ==0) {
            imgUrl = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dataImageArr[i]]];
            
            //            [imgUrl stringByAppendingString:[NSString stringWithFormat:@"%@",self.dataImageArr[i]]];
            
        }else {
            imgUrl =    [imgUrl stringByAppendingString:[NSString stringWithFormat:@",%@",self.dataImageArr[i]]];
            
        }
        
    }
}
    
    if (!imgUrl|| [imgUrl isEqualToString:@""]) {
        imgUrl = @"";
        
    }
    
    DebugLog(@"我也是醉了：－－－－－－ %@", self.textViewField.text);
    
    [HttpManager sendHttpRequestForeleasedMeasurementContent:self.textViewField.text topicType:self.releaseType imgUrls:imgUrl success:^(AFHTTPRequestOperation *operation, id reqeustObject) {
        NSDictionary *responseDic = [self conversionWithData:reqeustObject];
        DebugLog(@"responseDic = %@", responseDic)
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            //发布成功
            [self progressHUDHiddenTipSuccessWithString:@"发布成功"];
//            zone/cpDetail.html?id=后台返回的id
            NSString *url;
            if ([self.releaseType isEqualToString:@"1"]) {
                url = [NSString stringWithFormat:@"zone/cpDetail.html?id=%@&from=default",responseDic[@"data"][@"id"]];
                
                [self.delegate UpLoadPhotosUrl:url];
            }else if ([self.releaseType isEqualToString:@"0"])
            {
                url = [NSString stringWithFormat:@"zone/zxDetail.html?id=%@&from=default",responseDic[@"data"][@"id"]];

                [self.delegate UpLoadPhotosUrl:url];
            }
            
            [self.delegate UpLoadPhotosLoading:YES];
            
            if (url.length != 0) {
//                AuditStatusViewController *auditVC = [[AuditStatusViewController alloc] init];
//                auditVC.requestUrl = url;
//                [self.navigationController pushViewController:auditVC animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else
            {
                self.bottomBtn.userInteractionEnabled = YES;
  
            }
      
            

        }else {
            [self alertViewWithTitle:@"发布失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            self.progressHUD.hidden = YES;
            

            self.bottomBtn.userInteractionEnabled = YES;
            
        }
        
    } failure:^(AFHTTPRequestOperation *opeation, NSError *error) {
        [self alertViewWithTitle:@"发布失败" message:nil];
        
            self.progressHUD.hidden = YES;
        self.bottomBtn.userInteractionEnabled = YES ;
        
        DebugLog(@"失败");
        
    }];
    
}

- (void)dealloc
{


    

}




@end
