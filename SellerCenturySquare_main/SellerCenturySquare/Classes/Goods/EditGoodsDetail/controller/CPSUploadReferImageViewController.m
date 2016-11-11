//
//  CPSUploadReferImageViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSUploadReferImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "CPSChooseUploadReferImageViewController.h"
#import "GUAAlertView.h"

@interface CPSUploadReferImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>

//!从相册选择 按钮
@property (weak, nonatomic) IBOutlet UIButton *choicePhotoBtn;

//!拍照 按钮
@property (weak, nonatomic) IBOutlet UIButton *takePhtotButton;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterLabelHight;



@property (weak, nonatomic) IBOutlet UILabel *uploadClauseLabel;

- (IBAction)chooseImageButtonClick:(id)sender;

- (IBAction)takePhotoButtonClick:(id)sender;

@end

@implementation CPSUploadReferImageViewController
{
    
    GUAAlertView *customerAlertView;
    

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"上传参考图";
    
    [self customBackBarButton];
    
    self.uploadClauseLabel.text = @"严禁上传一下类型的图片，如多次违规将清退账号。\n\n1、请勿上传与货品参考图无关的图片。\n2、严禁上传含有暴力、色情等低俗信息内容的图片。";
    
    
    //!去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.takePhtotButton.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.takePhtotButton.layer.borderWidth = 1.0f;
    
    //!削圆角
    self.takePhtotButton.layer.masksToBounds = YES;
    self.takePhtotButton.layer.cornerRadius = 2;
    
    self.choicePhotoBtn.layer.masksToBounds = YES;
    self.choicePhotoBtn.layer.cornerRadius = 2;
    //!分割线的颜色、高度
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    self.filterLabelHight.constant = 0.5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-选择照片
- (IBAction)chooseImageButtonClick:(id)sender {
    
    //判断是否有相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
        
        picker.navigationBar.barStyle = UIBarStyleBlack;
        
        picker.navigationBar.translucent = NO;
        
        picker.maximumNumberOfSelection = 10;
        
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        
        picker.showEmptyGroups = NO;
        
        picker.delegate = self;
        
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
            
            if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
                
                NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
                
                return duration >= 5;
                
            }else{
                
                return  YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        
        if (customerAlertView) {
            
            [customerAlertView removeFromSuperview];
            
        }
        customerAlertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"缺少相册" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:nil dismissAction:nil];
        [customerAlertView show];
        
    }
    
    
}

#pragma mark - ZYQAssetPickerControllerDelegate
/**
 *  得到选取的照片
 *
 *  @param picker ZYQAssetPickerController
 *  @param assets 选取的照片保存在数组assets中
 */
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    
    if (!assets.count) {
        
        //如果没选择图片就不跳转
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    //push到上传页面
    CPSChooseUploadReferImageViewController *chooseUploadReferImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSChooseUploadReferImageViewController"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for ( ALAsset *asset in assets) {
        
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [array addObject:tempImg];
    }
    
    chooseUploadReferImageViewController.referImageArray = array;
    
    chooseUploadReferImageViewController.goodsNo = self.goodsNo;
    
    [self.navigationController pushViewController:chooseUploadReferImageViewController animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    DebugLog(@"assets = %@", assets);
}

#pragma mark-拍照
- (IBAction)takePhotoButtonClick:(id)sender {
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
//        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        
        //如果没有提示用户
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缺少摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        
//        [alert show];
        
        if (customerAlertView) {
            
            [customerAlertView removeFromSuperview];
            
        }
        customerAlertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"缺少摄像头" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:nil dismissAction:nil];
        [customerAlertView show];
        
        
        
    }
}

#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [self fixOrientation:image];
    
    //push到上传页面
    CPSChooseUploadReferImageViewController *chooseUploadReferImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSChooseUploadReferImageViewController"];
    
    chooseUploadReferImageViewController.goodsNo = self.goodsNo;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    [array addObject:image];
    
    chooseUploadReferImageViewController.referImageArray = array;
    
    [self.navigationController pushViewController:chooseUploadReferImageViewController animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
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
@end
