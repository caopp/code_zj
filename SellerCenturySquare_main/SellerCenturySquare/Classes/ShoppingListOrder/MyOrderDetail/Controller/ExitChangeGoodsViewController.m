//
//  ExitChangeGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExitChangeGoodsViewController.h"
#import "Masonry.h"
#import "RefundProjectTableViewCell.h"
#import "PhotoProveTableViewCell.h"
#import "RefundApplyDTO.h"
#import "BottomPhotoProveView.h"
#import "BottomPhotoProveView.h"
#import "MakeSureExitMoneyAndChangeGoodsView.h"
#import "JustExitMoneyView.h"
#import "MakeSureExitMoneyView.h"
#import "LoginDTO.h"
#import "PhotoAndCamerSelectView.h"
#import "ExpressDeliverViewController.h"
#import "OrderDetaillViewController.h"
#import "GUAAlertView.h"

@interface ExitChangeGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *titleArr;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *bottomBtn;
@property (nonatomic ,strong) RefundApplyDTO *refundDto;
@property (nonatomic ,strong) NSMutableArray *contentArr;
@property (nonatomic ,strong) MakeSureExitMoneyAndChangeGoodsView *makeSureView;
@property (nonatomic ,strong) JustExitMoneyView *justEixtView;//
@property (nonatomic ,strong) MakeSureExitMoneyView *makeSureMoneyView;
@property (nonatomic ,strong) UIView *blackAlphaView;
//!拍照发货
//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;






@end

@implementation ExitChangeGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  customBackBarButton];
    self.title = @"退/换货详情";
    
    
    self.titleArr = [[NSMutableArray alloc] init];
    self.contentArr = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    [self requestExitChangeGoodsDetail];
    
    [self initPhotoView];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return  self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"RefundProjectTableViewCellId";
    static NSString *cellExit = @"PhotoProveTableViewCellId";
    
    if (indexPath.row == self.titleArr.count-1) {
        
        if ([self.contentArr.lastObject isEqualToString:@"未上传"]) {
            
            RefundProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundProjectTableViewCell" owner:nil options:nil] lastObject];
                
            }
            cell.promptTypeLab.text = self.titleArr[indexPath.row];
            cell.prompContentLab.text = self.contentArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;

        }
        
        PhotoProveTableViewCell *cellExiTView = [tableView dequeueReusableCellWithIdentifier:cellExit];
        if (!cellExiTView) {
            cellExiTView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoProveTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        cellExiTView.refundApp = self.refundDto;
        cellExiTView.selectionStyle = UITableViewCellSelectionStyleNone;

        return cellExiTView;

        
        
    }
    RefundProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundProjectTableViewCell" owner:nil options:nil] lastObject];
        
    }
    cell.promptTypeLab.text = self.titleArr[indexPath.row];
    cell.prompContentLab.text = self.contentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.refundDto.refundType.integerValue == 2) {
        if (_refundDto.refundStatus.integerValue == 4) {
            UIView *headView = [[UIView alloc] init];
            headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            UILabel *headLab = [[UILabel alloc] init];
            
            
            
            headLab.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            headLab.text = @"等待采购商确认收货";
            headLab.font = [UIFont systemFontOfSize:13];
            
            headLab.textAlignment = NSTextAlignmentCenter;
            headLab.backgroundColor = [UIColor redColor];
            headLab.textColor = [UIColor whiteColor];
            [headView addSubview:headLab];
            return headView;

        }
        
    }
    return nil;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.titleArr.count -2)== indexPath.row) {
        if ([self.titleArr[indexPath.row] isEqualToString:@"补充说明:"]) {
            CGFloat height = [self accordingContentFont:self.contentArr[indexPath.row]].height+29;
            
            
            if (height<45) {
                return 45;
            }
            
            
            return  height;
            
            
        }
    }

    
    if (self.titleArr.count-1 == indexPath.row) {
        
        if ([self.contentArr.lastObject isEqualToString:@"未上传"]) {
            return 45;
        }
        if (self.refundDto) {
            
            
            //        for (NSString *refund in refundApp.pics) {
            //            NSLog(@"%@",refund);
            //        }
            NSArray *picsStr = [self.refundDto.pics componentsSeparatedByString:@","];
            NSLog(@"%@",picsStr);
            CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width-115;
            int recordIntX = 0;
            int recordIntY = 0;
            CGFloat recordImageX = 0.0;
            CGFloat recordImageY = 0.0;
            CGRect recordImageRect;
            
            for (int i = 0; i < picsStr.count; i++) {
                
                if (recordImageX>viewWidth-80) {
                    recordIntX = 0;
                    recordIntY++;
                }
                
                CGRect rect = CGRectMake(80*recordIntX, 80*recordIntY, 70, 70);
                
                recordIntX++;
                recordImageRect = rect;
                //            [self.imagePhotoView addSubview:image];
                
                recordImageX = CGRectGetMaxX(recordImageRect);
                recordImageY = CGRectGetMaxY(recordImageRect);
            }
            return recordImageY+20;
        }
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //!退换货类型：0-退货退款 1-仅退款 2-换货

    if (self.refundDto.refundType.integerValue == 2) {
        if (_refundDto.refundStatus.integerValue == 4) {
            return 30;
        }
        
    }
    
    return 0.005;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    BottomPhotoProveView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomPhotoProveView" owner:self options:nil] lastObject];
//    bottomView.refundApp = self.refundDto;
//    return bottomView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    if (self.refundDto) {
//        //        for (NSString *refund in refundApp.pics) {
//        //            NSLog(@"%@",refund);
//        //        }
//        NSArray *picsStr = [self.refundDto.pics componentsSeparatedByString:@","];
//        NSLog(@"%@",picsStr);
//        CGFloat viewWidth = self.view.frame.size.width - 97;
//        int recordIntX = 0;
//        int recordIntY = 0;
//        CGFloat recordImageX = 0.0;
//        CGFloat recordImageY = 0.0;
//        CGRect recordImageRect;
//        
//        for (int i = 0; i < picsStr.count; i++) {
//            
//            if (recordImageX>viewWidth) {
//                recordIntX = 0;
//                recordIntY++;
//            }
//            
//           CGRect rect = CGRectMake(80*recordIntX, 80*recordIntY, 70, 70);
//            
//            recordIntX++;
//            recordImageRect = rect;
////            [self.imagePhotoView addSubview:image];
//            
//            recordImageX = CGRectGetMaxX(recordImageRect);
//            recordImageY = CGRectGetMaxY(recordImageRect);
//        }
//        return recordImageY+20;
//    }
//
//    
//    return 0;
//}
//

//修改退换货内容
- (void)changeExitChangeGoodsContent:(UIButton*)btn
{
    
}


- (void) exitChangeGoodsDeal
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForRefundDealOrderCode:self.detailDto.orderCode refundNo:self.detailDto.refundNo dealBy:[LoginDTO sharedInstance].merchantAccount dealReamark:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSLog(@"处理成功");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:@{@"name":@"haha"}];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshOrderList" object:self userInfo:@{@"orderCode":self.refundDto.orderCode}];
            
            [self backBarButtonClick:nil];
            
            [self requestExitChangeGoodsDetail];
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        
        [self.view makeMessage:webErrorAlert duration:2.0 position:@"center"];
        
    }];
    
}



#pragma mark 拍照发货
-(void)takePhotoSendGoods{
    
    
    //!显示选择的view
    self.blackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    
    [self.view bringSubviewToFront:self.blackAlphaView];
    [self.view bringSubviewToFront:self.photoAndCamerSelectView];
    
}
//!创建拍照发货 选择相册 相机的view
-(void)initPhotoView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 ;//!50是底部的高度
    float selectHight = 106;
    
    //!透明的view
    self.blackAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight - selectHight)];
    
    [self.blackAlphaView setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:0.25]];
    [self.view addSubview:self.blackAlphaView];
    
    
    UITapGestureRecognizer * selectHideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePhotoSelectView)];
    [self.blackAlphaView addGestureRecognizer:selectHideTap];
    
    
    //!相册选择的view
    self.photoAndCamerSelectView= [[[NSBundle mainBundle]loadNibNamed:@"PhotoAndCamerSelectView" owner:self options:nil]lastObject];
    [self.photoAndCamerSelectView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.photoAndCamerSelectView];
    
    [self.photoAndCamerSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.blackAlphaView.mas_bottom);
        //        make.bottom.equalTo(@50);//!50是底部的高度
        make.height.equalTo(@106);
        
    }];
    
    __weak ExitChangeGoodsViewController * orderVC = self;
    //!拍照发货的事件
    self.photoAndCamerSelectView.photoBlock = ^(){
        
        //!相机的时候，传yes
        [orderVC showPhoto:NO];
        
    };
    
    self.photoAndCamerSelectView.camerBlock = ^(){
        
        
        [orderVC showPhoto:YES];
        
    };
    
    //!先隐藏，点击拍照发货的时候显示
    self.blackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
    
}
//!隐藏相册选择的view 以及上半部分的灰色半透明部分
-(void)hidePhotoSelectView{
    
    self.blackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
}
//!掉起相册 相机:isCamer=yes
-(void)showPhoto:(BOOL)isCamer{
    
    //待发货
    //拍照发货
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.translucent = NO;
    //如果选择的是相机，则判断是否可以吊起相机
    if (isCamer && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    
    
    //!吊起相机、相册的时候 修改状态栏的颜色，在这个界面将要出现的时候改回白色
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    
}
#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self progressHUDShowWithString:@"上传中"];
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //隐藏拍照发货选中的View
        [self hidePhotoSelectView];
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0000001f);
        
        //上传图片,修改
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"5" orderCode:_orderCode goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"%@",responseDic);
            [self progressHUDTipWithString:@"发货成功"];
            [NSThread sleepForTimeInterval:1];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshOrderList" object:self userInfo:@{@"orderCode":self.refundDto.orderCode}];

            
            [self  backBarButtonClick:nil];
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {//!拍照发货成功

                
            }else{
                
                [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
            
            
        }];
        
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];
    
}


#pragma mark 录入快递单发货
-(void)takeExpressSendGoods{
    
    __weak ExitChangeGoodsViewController * vc = self;
    ExpressDeliverViewController * expressVC = [[ExpressDeliverViewController alloc]init];
    expressVC.orderCode = self.detailDto.orderCode;
    expressVC.takeExpressSuccessBlock = ^(){//!发货成功
        
        //!修改成功，调用block，让列表改变
//        [self toRefreshOrderList];
        
        //!请求并刷新数据
//        [vc requestExitChangeGoodsDetail];
        
        [self backBarButtonClick:nil];
        
    };
    [self.navigationController pushViewController:expressVC animated:YES];
    
}


#pragma mark -  request 

- (void)requestExitChangeGoodsDetail
{
    [HttpManager sendHttpRequestForRefundDetailOrderCode:self.orderCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            self.refundDto = [[RefundApplyDTO alloc] init];
            [self.refundDto setDictFrom:dic[@"data"]];
            
            
            //第零行 申请服务
            NSString *applyService;
            if ([self.refundDto.refundType isKindOfClass:[NSNumber class]]) {
                
                
                if (self.refundDto.refundType.integerValue == 0) {
                    applyService = @"退货退款";
                    [self.titleArr removeAllObjects];
                    [self.contentArr removeAllObjects];
                    NSArray *arrList = @[@"申请服务:",@"退货原因:",@"退款金额:",@"补充说明:",@"图片凭证:"];
                    NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未填写",@"未上传" ];
                    [self.titleArr addObjectsFromArray:arrList];
                    [self.contentArr addObjectsFromArray:arrTitle];
                    
                    
                    if (self.refundDto.refundStatus.integerValue == 0) {
                        
                        if (!self.makeSureView) {
                            self.makeSureView = [[[NSBundle mainBundle] loadNibNamed:@"MakeSureExitMoneyAndChangeGoodsView" owner:nil options:nil] lastObject];
                            self.makeSureView.blockMakeSureExitMoneyAndChangeGoodsView = ^()
                            {
                                
                                NSString *moneyStr = [NSString  stringWithFormat:@"退款金额:￥%.2f",self.refundDto.refundFee.doubleValue ];
                                
                                GUAAlertView * alert = [GUAAlertView alertViewWithTitle:@"确定退款？" withTitleClor:nil message:moneyStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                                    
                                    [self exitChangeGoodsDeal];

                                    
                                } dismissAction:^{
                                    
                                }];
                                alert.changeNum = (moneyStr.length - 5);
                                alert.changeIndex = 5;
                                alert.changeColor = [UIColor redColor];
                                [alert show];
                                
                            };
                            [self.view addSubview:self.makeSureView];
                            [self.makeSureView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(self.view.mas_bottom);
                                make.left.equalTo(self.view.mas_left);
                                make.right.equalTo(self.view.mas_right);
                                make.height.equalTo(@49);
                            }];
                            
                            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                            }];
                            
                        }
                    }else
                    {
                        if (self.makeSureView) {
                            [self.makeSureView removeFromSuperview];
                            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(self.view.mas_bottom);
                            }];
                            
                            
                            
                        }
                    }
                    
                    
                }else if (self.refundDto.refundType.integerValue == 1)
                {
                    applyService = @"仅退款";
                    
                    [self.titleArr removeAllObjects];
                    [self.contentArr removeAllObjects];
                    NSArray *arrList = @[@"申请服务:",@"货物状态:",@"退款原因:",@"退款金额:",@"补充说明:",@"图片凭证:"];
                    NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未填写",@"未填写" ,@"未上传"];
                    [self.titleArr addObjectsFromArray:arrList];
                    [self.contentArr addObjectsFromArray:arrTitle];
                    
                    //处理中
                    if (self.refundDto.refundStatus.integerValue == 2) {
                        //                    0-未收到货
                        if (self.refundDto.goodsStatus.integerValue  == 0&&self.orderStatus.integerValue == 2) {
                            if (!self.justEixtView) {
                                self.justEixtView = [[[NSBundle mainBundle] loadNibNamed:@"JustExitMoneyView" owner:nil options:nil] lastObject];
                                
                                self.justEixtView.blockJustExitMoneyView = ^(NSString *type)
                                {
                                    if ([type isEqualToString:@"0"]) {//拍照发货
                                        
                                        [self takePhotoSendGoods];
                                    }else if ([type isEqualToString:@"1"])
                                    {
                                        [self takeExpressSendGoods];
                                        
                                    }else if ([type isEqualToString:@"2"])
                                    {
                                        NSString *moneyStr = [NSString  stringWithFormat:@"退款金额:￥%.2f",self.refundDto.refundFee.doubleValue ];
                                        
                                        GUAAlertView * alert = [GUAAlertView alertViewWithTitle:@"确定退款？" withTitleClor:nil message:moneyStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                                            
                                            [self exitChangeGoodsDeal];
                                            
                                            
                                        } dismissAction:^{
                                            
                                        }];
                                        alert.changeNum = (moneyStr.length - 5);
                                        alert.changeIndex = 5;
                                        alert.changeColor = [UIColor redColor];
                                        [alert show];
                                        
                                        
                                    }
                                    
                                    
                                    //
                                };
                                [self.view addSubview:self.justEixtView];
                                
                                [self.justEixtView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.bottom.equalTo(self.view.mas_bottom);
                                    make.left.equalTo(self.view.mas_left);
                                    make.right.equalTo(self.view.mas_right);
                                    make.height.equalTo(@49);
                                    
                                }];
                                
                                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                                }];
                                
                            }
                        }else if (self.refundDto.goodsStatus.integerValue == 1||((self.refundDto.goodsStatus.integerValue == 1||self.refundDto.goodsStatus.integerValue == 0)&&self.orderStatus.integerValue == 3))//1 收到货
                        {
                            
                            if (!self.makeSureView) {
                                
                            
                            self.makeSureMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"MakeSureExitMoneyView" owner:nil options:nil] lastObject];
                            self.makeSureMoneyView.blockMakeSureExitMoneyView = ^()
                            {
                                [self exitChangeGoodsDeal];
                            };
                            [self.view addSubview:self.makeSureMoneyView];
                            
                            [self.makeSureMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(self.view.mas_bottom);
                                make.left.equalTo(self.view.mas_left);
                                make.right.equalTo(self.view.mas_right);
                                make.height.equalTo(@49);
                                
                            }];
                            
                            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                            }];
                            }
                            
                        }
                        
                    }
                    else
                    {
                        if (self.makeSureView) {
                            [self.makeSureView removeFromSuperview];
                            
                        }
                        
                        if (self.justEixtView) {
                            [self.justEixtView removeFromSuperview];
                            
                        }
                        
                        if(self.makeSureMoneyView)
                        {
                            [self.makeSureMoneyView removeFromSuperview];
                            
                        }
                        
                        
                        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                        }];
                        
                        
                    }
                    
                    
                    
                }else if (self.refundDto.refundType.integerValue == 2)
                {
                    applyService = @"换货";
                    
                    [self.titleArr removeAllObjects];
                    [self.contentArr removeAllObjects];
                    NSArray *arrList = @[@"申请服务:",@"换货原因:",@"补充说明:",@"图片凭证:"];
                    NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未上传" ];
                    
                    
//                    [self.titleArr addObjectsFromArray:arrTitle];

                    [self.titleArr addObjectsFromArray:arrList];
                    [self.contentArr addObjectsFromArray:arrTitle];
                    
                    
                    
                }
                
            }
            
            //货物状态
            NSString*changeGoodsResion;
            if ([self.refundDto.goodsStatus isKindOfClass:[NSNumber class]]) {
                if (self.refundDto.goodsStatus.integerValue == 0) {
                    changeGoodsResion = @"未收到货 ";
                }else if (self.refundDto.goodsStatus.integerValue == 1)
                {
                    changeGoodsResion = @"已收到货";
                }
            }
            
           
            
            
            
            //            第一行 退货原因  //换货原因
            NSString *exitGoodsResion;
            if ([self.refundDto.refundReason isKindOfClass:[NSNumber class]]) {
                switch (self.refundDto.refundReason.integerValue) {
                    case 0:
                        exitGoodsResion = @"质量问题";
                        break;
                    case 1:
                        exitGoodsResion = @"尺码问题";
                        break;
                    case 2:
                        exitGoodsResion = @"少件/破损";
                        break;
                        
                    case 3:
                        exitGoodsResion = @"卖家发错货";
                        break;
                    case 4:
                        exitGoodsResion = @"未按约定时间发货";
                        break;
                    case 5:
                        exitGoodsResion = @"多拍/拍错/不想要";
                        break;
                    case 6:
                        exitGoodsResion = @"快递/物流问题";
                        break;
                        
                    case 7:
                        exitGoodsResion = @"空包裹/少货";
                        break;
                    case 8:
                        exitGoodsResion = @"其他";
                        break;
                        
                    default:
                        break;
                }
                
         
            }
            
            
            //退款金额
            NSString *exitMoney;
            
            if ([self.refundDto.refundFee isKindOfClass:[NSNumber class]]) {
                exitMoney = [NSString stringWithFormat:@"￥%.2f",self.refundDto.refundFee.doubleValue];
                
            }
            
            
            // 补充说明
            NSString * moreInstruction;
            if ([self.refundDto.remark isKindOfClass:[NSString class]]) {
                
                if (self.refundDto.remark.length>0) {
                    
                    
                    moreInstruction = self.refundDto.remark;
                }
                
            }
            //上传凭证
            NSString *photoStr;
            if ([self.refundDto.pics isKindOfClass:[NSString class]]) {
                photoStr = [NSString stringWithFormat:@"%@",self.refundDto.pics];
           
            }
            
            
            NSArray *contentArr = self.titleArr;
            for (int i = 0; i<self.titleArr.count; i++) {
                NSString *content = contentArr[i];
                if ([content isEqualToString:@"申请服务:"]) {
                    if (applyService.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:applyService];
                    }

                }else if ([content isEqualToString:@"货物状态:"])
                {
                    if (changeGoodsResion.length>0) {
                        [self.contentArr  replaceObjectAtIndex:i withObject:changeGoodsResion];
                    }
                }else if ([content isEqualToString:@"退款原因:"])
                {
                    if (exitGoodsResion.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    }
                }else if ([content isEqualToString:@"退货原因:"])
                {
                    if (exitGoodsResion.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    }

                }else if ([content isEqualToString:@"退款金额:"])
                {
                    if (exitMoney.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitMoney];
                    }
                }else if ([content isEqualToString:@"补充说明:"])
                {
                    if (moreInstruction.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:moreInstruction];
                    }
                }else if ([content isEqualToString:@"图片凭证:"])
                {
                    if (photoStr.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:photoStr];
                    }
                }else if ([content isEqualToString:@"换货原因:"])
                {
                    if (moreInstruction.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    }
                }
            }
            
            
            
            
            [self.tableView reloadData];
            
            
        }else
        {
            DebugLog(@"%@", dic[@"errorMessage"]);
        }
        
        //        0-质量问题 1-尺码问题 2-少件/破损 3-卖家发错货 4-未按约定时间发货5-多拍/拍错/不想要6-快递/物流问题7-空包裹/少货8-其他
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[OrderDetaillViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
    

}


- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 105;
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return size;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
