//
//  CSPVerifyInvitationViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPVerifyInvitationViewController.h"
#import "CustomTextField.h"
#import "LoginDTO.h"
#import "AppDelegate.h"
#import "CustomTextField4.h"
#import "EnlargeImageView.h"
#import "UserOtherInfo.h"
#import "SaveUserIofo.h"

#define time 0.5
@interface CSPVerifyInvitationViewController ()<ELCImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,EnlargeImageViewDelegate>
{
    UITableView *_tableView;
    ApplyInfoDTO* applyInfoDTO;
    UIView *headerView;
    UIView *footerView;
    //!是否展开平台类型
    BOOL isShow;
    

    
}
@property (nonatomic,strong)UIView *tapView;

@property (nonatomic,strong)EnlargeImageView *enlargeImage;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet CustomTextField *checkCodeText;

@property (strong, nonatomic) IBOutlet UIButton *storeButton;

@property (strong, nonatomic) IBOutlet UIButton *netWordButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *distanceLength;

@property (strong, nonatomic) IBOutlet UILabel *netWordLabel;

@property (strong,nonatomic)UILabel *storeLabel;

@property (strong ,nonatomic) CustomTextField *businessLicenseText;

@property (strong ,nonatomic) UIButton *uploadImageButton;

@property (strong ,nonatomic) UILabel *descriptionLabel;

@property (nonatomic,strong) CustomTextField4 *onlineStoreText;

@property (strong ,nonatomic) UIImageView *image;

@property (strong,nonatomic)UILabel *thirdPartiesaTitleLabel;
@property (strong,nonatomic)NSMutableArray *valueDicArr;
@property (strong,nonatomic)NSMutableArray *labelDicArr;

@property (strong,nonatomic)NSString *imageUrl;
//第三方按钮
@property (strong,nonatomic)UIButton *thirdPartiesaButton;



//进行验证按钮

@property (strong,nonatomic)UIButton *verifityButton;

//进行验证描述

@property (strong,nonatomic)UILabel *descriptionVerifityLabel;


@end

@implementation CSPVerifyInvitationViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MyUserDefault removeCodeStorename];
    [MyUserDefault removeCodeStore];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份验证";
    

    [self addCustombackButtonItem];
    
    //建立简体
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(elcImagePickerControllerDidCancel:) name:@"cacelPhotoPage" object:nil];
    
    applyInfoDTO = [[ApplyInfoDTO alloc]init];
    
    //设置UI
    [self makeUI];
    //设置网络请求
    [self netWorkRequest];
    //网络请求创建空间
    self.labelDicArr = [NSMutableArray arrayWithCapacity:0];
    self.valueDicArr = [NSMutableArray arrayWithCapacity:0];
    self.enlargeImage = [[EnlargeImageView alloc]init];
    self.enlargeImage.delegate = self;
}


#pragma mark ================进行删除=================
-(void)deleteImageView:(NSInteger )imageViewTag
{
    if (self.image.tag == imageViewTag) {
        self.image.hidden = YES;
        self.image.image = [UIImage imageNamed:@""];
        [UIView animateWithDuration:time animations:^{
            
            
            self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, 161, self.netWordButton.frame.size.width, self.netWordButton.frame.size.height);
            
            self.netWordLabel.frame = CGRectMake(self.netWordLabel.frame.origin.x, 161, self.netWordLabel.frame.size.width, self.netWordLabel.frame.size.height);
            
        }];

        
    }
}


#pragma mark ===============照相照片============
//打开本地相册
-(void)didClickPhotoAction
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.navigationBar.translucent = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}


//拍照
-(void)didClickCameraAction
{
    
    UIImagePickerControllerSourceType souceType =UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker =[[UIImagePickerController alloc]init];
        picker.delegate =self;
        picker.allowsEditing = YES; //拍照后的照片可以呗编辑
        picker.sourceType  = souceType; //相机类型
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        MyLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    //改变网络分销frame
    [UIView animateWithDuration:time animations:^{
        
        
        self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, 241, self.netWordButton.frame.size.width, self.netWordButton.frame.size.height);
        
        self.distanceLength.constant = 159;
        self.netWordLabel.frame = CGRectMake(self.netWordLabel.frame.origin.x, 241, self.netWordLabel.frame.size.width, self.netWordLabel.frame.size.height);
        
    }];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转化成NSDAta
        UIImage *image1 = [info objectForKey:@"UIImagePickerControllerEditedImage"]; //编辑后的图
        //设置image的尺寸
        CGSize imagesize = image1.size;

        
        if (imagesize.width < 500) {
            
            [self imageWithImageScale:image1 scaledToSize:imagesize];
            
        }else
        {
            CGFloat proportion = (CGFloat)[UIScreen mainScreen].bounds.size.width/(CGFloat)imagesize.width;
            
            imagesize.height =image1.size.height * proportion*2;
            imagesize.width  = [UIScreen mainScreen].bounds.size.width*2;
            
            //对图片大小进行压缩--
            image1 = [self imageWithImage:image1 scaledToSize:imagesize];

        }
        
        
        
        
        
        NSData *data;
        if (UIImagePNGRepresentation(image1)==nil) {
            data =UIImageJPEGRepresentation(image1, 1);
        }else{
            data = UIImagePNGRepresentation(image1);
        }
        
        self.image.image = [UIImage imageWithData:data];
        [self setbuttonImage:self.image.image];
        
            UITapGestureRecognizer  *IdCardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addIdCardImageGesture)];
            [self.image addGestureRecognizer:IdCardGesture];
            
               [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}






#pragma mark ==================添加手势=============
-(void)addIdCardImageGesture
{
    
    [_enlargeImage showImage:self.image tag:self.image.tag];
    [self.checkCodeText resignFirstResponder];
    [self.businessLicenseText resignFirstResponder];
    
}

-(void)setbuttonImage:(UIImage *)image
{
    [self.businessLicenseText resignFirstResponder];
    [self.checkCodeText resignFirstResponder];
    [self.onlineStoreText resignFirstResponder];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:@"1" orderCode:@"" goodsNo:@"" file:UIImageJPEGRepresentation(image, 1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSLog(@"success to upload id card image");
            [self.view makeToast:@"上传照片成功" duration:2.0f position:@"center"];
            
            
            
            self.imageUrl = dic[@"data"];
            
            
        } else {
            [self.view makeToast:@"上传照片失败" duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error ==== %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
    
    [UIView animateWithDuration:time animations:^{
        self.tapView.center = CGPointMake(self.tapView
                                          .center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
    }];
    
}



//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    CGFloat width = newSize.width * 0.67;
    CGFloat height = newSize.height * 0.67;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImageScale:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    CGFloat width = newSize.width * 0.67;
    CGFloat height = newSize.height * 0.67;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


#pragma mark -------设置网络请求-------
-(void)netWorkRequest
{
    
    [HttpManager sendHttpRequestForThirdPartiesType:@"other_platform" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dicArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if (self.labelDicArr != nil) {
            [self.labelDicArr removeAllObjects];
        }
        
        if ([[dicArr objectForKey:@"code"]isEqualToString:@"000"]) {
            
            for (NSDictionary *Dic in dicArr[@"data"]) {
                
                [self.labelDicArr addObject:Dic[@"label"]];
                [self.valueDicArr addObject:Dic[@"value"]];
                
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.netWordButton.frame.origin.x + 10, 140, self.view.frame.size.width - 96, 41 * self.labelDicArr.count + 41*2) style:UITableViewStylePlain];
                
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.showsVerticalScrollIndicator = NO;
                _tableView.scrollEnabled = NO;
                _tableView.hidden = YES;
                _tableView.backgroundColor = [UIColor clearColor];
                //不要分割线
                [self.scrollView addSubview:_tableView];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)makeUI
{
    //scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height- 64)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.5);
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
    
    self.checkCodeText = [[CustomTextField alloc]initWithFrame:CGRectMake(48, 14, self.view.frame.size.width - 96, 30)];
    self.checkCodeText.placeholder = @"请输入邀请码";
    self.checkCodeText.delegate = self;
    [self.checkCodeText becomeFirstResponder];

    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
    self.checkCodeText.font = [UIFont systemFontOfSize:13];
    self.checkCodeText.textColor = LGClickColor;
    [self.scrollView addSubview:self.checkCodeText];
    
    
    //实体店按钮
    self.storeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.storeButton.frame = CGRectMake(28 + 10, self.checkCodeText.frame.origin.y+self.checkCodeText.frame.size.height + 23, 15 + 20, 17);
//    [self.storeButton setBackgroundImage:[UIImage imageNamed:@"02_注册_未选中"] forState:(UIControlStateNormal)];
    
    [self.storeButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.storeButton];
    [self.storeButton addTarget:self action:@selector(didClickStoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.storeButton.backgroundColor = [UIColor]
    
    
    
    
    //上传营业执照并上传图片
    self.businessLicenseText = [[CustomTextField alloc]initWithFrame:CGRectMake(self.storeButton.frame.origin.x + 10, self.storeButton.frame.origin.y + 15 + 11, self.view.frame.size.width - 96 -49, 30)];
    
    self.businessLicenseText.hidden = YES;
    self.businessLicenseText.placeholder = @"输入营业执照号并上传图片";
    self.businessLicenseText.font = [UIFont systemFontOfSize:13];
    [self.businessLicenseText setTextColor:LGClickColor];
    [self.scrollView addSubview:self.businessLicenseText];
    
    
    //实体店label
    self.storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.storeButton.frame.origin.x + self.storeButton.frame.size.width, self.storeButton.frame.origin.y, 132, 15)];
    self.storeLabel.text = @"实体店";
    [self.scrollView addSubview:self.storeLabel];
    self.storeLabel.font = [UIFont systemFontOfSize:15];
    [self.storeLabel setTextColor:LGClickColor];
    
    
    
    
    //网络分销按钮
    self.netWordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, self.storeButton.frame.origin.y + self.storeButton.frame.size.height + 20, 15 + 20, 17);
    [self.scrollView addSubview:self.netWordButton];
    [self.netWordButton addTarget:self action:@selector(didClickNetWorkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.netWordButton setBackgroundImage: [UIImage imageNamed:@"02_注册_未选中"] forState:(UIControlStateNormal)];
    [self.netWordButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];

    
    
    //网络分销label
    self.netWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.netWordButton.frame.origin.x + self.netWordButton.frame.size.width , self.netWordButton.frame.origin.y, 132, 15)];
    self.netWordLabel.text = @"网络分销";
    self.netWordLabel.font = [UIFont systemFontOfSize:15];
    [self.netWordLabel setTextColor:LGClickColor];
    [self.scrollView addSubview:self.netWordLabel];
    

    //选择图片按钮
    self.uploadImageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadImageButton.frame = CGRectMake(self.businessLicenseText.frame.origin.x + self.businessLicenseText.frame.size.width + 19, self.businessLicenseText.frame.origin.y, 30, 30);
    self.uploadImageButton.hidden = YES;
    [self.uploadImageButton setBackgroundImage:[UIImage imageNamed: @"02_注册_申请资料_添加（100%）"] forState:(UIControlStateNormal)];
    [self.scrollView addSubview:self.uploadImageButton];
    [self.uploadImageButton addTarget:self action:@selector(showImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.businessLicenseText.frame.origin.x, self.businessLicenseText.frame.origin.y + self.businessLicenseText.frame.size.height + 11, self.view.frame.size.width - 96, 9)];
    self.descriptionLabel.text = @"如无营业执照可拍摄店面照片进行上传";
    self.descriptionLabel.hidden = YES;
    self.descriptionLabel.textAlignment = NSTextAlignmentRight;
    self.descriptionLabel.font = [UIFont systemFontOfSize:9];
    [self.descriptionLabel setTextColor:LGClickColor];
    [self.scrollView addSubview:self.descriptionLabel];
    
    
    
    //图片显示
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(self.businessLicenseText.frame.origin.x, self.descriptionLabel.frame.origin.y +18 , 74, 50)];
    self.image.hidden = YES;
    self.image.tag = 4000;
    [self.scrollView addSubview:self.image];
    //图片上添加手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAddGesture)];
    [self.image addGestureRecognizer:gesture];

    
    
    
    //进行验证按钮
    self.verifityButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.verifityButton.frame = CGRectMake(48, self.view.frame.size.height - 94-64, self.view.frame.size.width - 96, 43);
    self.verifityButton.layer.borderWidth = 1;
    self.verifityButton.layer.cornerRadius = 4;
    self.verifityButton.layer.borderColor = LGButtonColor.CGColor;
    [self.verifityButton setTitle:@"验证" forState:(UIControlStateNormal)];
    self.verifityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.verifityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.verifityButton addTarget:self action:@selector(didClickVerifityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.verifityButton];
    
    

    //进行验证描述
    self.descriptionVerifityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 41 -64, self.view.frame.size.width, 11)];
    self.descriptionVerifityLabel.text = @"收到叮咚欧品和朋友的邀请，可凭短信中的邀请码在此验证";
    self.descriptionVerifityLabel.font = [UIFont systemFontOfSize:11];
    self.descriptionVerifityLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionVerifityLabel.textColor = LGButtonColor;
    [self.scrollView addSubview:self.descriptionVerifityLabel];
    

}

#pragma mark ------显示图片上添加手势,放大图片-------
-(void)imageAddGesture
{
    [_enlargeImage showImage:self.image tag:self.image.tag];
}



#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isShow) {
        
        return self.labelDicArr.count;
    }else{
    
    
        return 0;
        
    }
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 42;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
        footerView.backgroundColor = [UIColor clearColor];
        
        
        self.onlineStoreText = [[CustomTextField4 alloc]initWithFrame:CGRectMake(footerView.frame.origin.x, 11, self.view.frame.size.width, 30)];
        self.onlineStoreText.delegate = self;
        [footerView addSubview:self.onlineStoreText];
        
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineStoreTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
        
        
        if ([MyUserDefault defaultLoadAppSetting_codeStorename] == nil) {
            self.onlineStoreText.placeholder = @"请选择";
        }else
        {
            
            self.onlineStoreText.placeholder = [MyUserDefault defaultLoadAppSetting_codeStorename];
        }
        

        self.onlineStoreText.font = [UIFont systemFontOfSize:13];
        self.onlineStoreText.textColor = LGClickColor;
 
    }
    return footerView;
    
}

//监测邀请码最多输入20个字

-(BOOL)checkCodeTextChanged
{
    if (![self checkCodeTextChangedToTwenty]) {
        return NO;
    }
    
    return YES;
}
-(BOOL)checkCodeTextChangedToTwenty
{
    if (self.checkCodeText.text.length>=20) {
        
        [self.view makeToast:@"最多输入20个字" duration:2.0f position:@"center"];
        
        self.checkCodeText.text = [self.checkCodeText.text substringToIndex:20];
        return NO;
    }
    return YES;

}


//监测所得到的textfield中副本所输入的个数
-(BOOL)onlineStoreTextChanged{
    
    
    if (![self enterUpToTwenty]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)enterUpToTwenty
{
    if (self.onlineStoreText.text.length>=20) {
        
        [self.view makeToast:@"最多输入20个字" duration:2.0f position:@"center"];
        
          self.onlineStoreText.text = [self.onlineStoreText.text substringToIndex:20];
        return NO;
    }
    return YES;
}


//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
   
    if (!headerView) {
    
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 96, 41)];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.layer.borderWidth = 1;
        headerView.layer.borderColor = LGClickColor.CGColor;
        
        self.thirdPartiesaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, headerView.frame.size.width - 60, 15)];
        
        self.thirdPartiesaTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.thirdPartiesaTitleLabel.textColor = LGClickColor;
        
        if ([MyUserDefault defaultLoadAppSetting_codeStore] == nil) {
            self.thirdPartiesaTitleLabel.text = @"请选择";
        }else
        {
            self.thirdPartiesaTitleLabel.text = [MyUserDefault defaultLoadAppSetting_codeStore];
        }
        
        
        [headerView addSubview:self.thirdPartiesaTitleLabel];
        
        self.thirdPartiesaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.thirdPartiesaButton.frame = CGRectMake(self.view.frame.size.width - 96 - 40,0 ,40 ,44);
        self.thirdPartiesaButton.tag = 100+section;
        [self.thirdPartiesaButton addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.thirdPartiesaButton setImage:[UIImage imageNamed: @"down"] forState:(UIControlStateNormal)];
        
       
        
    
        [headerView addSubview:self.thirdPartiesaButton];
    }

    
    return headerView;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = self.labelDicArr[indexPath.row];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = LGClickColor.CGColor;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([self.labelDicArr[indexPath.row] isEqualToString:@"淘宝"] || [self.labelDicArr[indexPath.row] isEqualToString:@"天猫"] || [self.labelDicArr[indexPath.row] isEqualToString:@"京东"]) {
        
        self.onlineStoreText.placeholder = @"输入网店名称";
        
        [MyUserDefault defaultSaveAppSetting_codeStorename:self.onlineStoreText.placeholder];
        
        self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
        
        [MyUserDefault defaultSaveAppSetting_codeStore:self.thirdPartiesaTitleLabel.text];
        
    }
    
    if ([self.labelDicArr[indexPath.row] isEqualToString:@"微商"]) {
        self.onlineStoreText.placeholder = @"输入微信号";
        self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
        
       [MyUserDefault defaultSaveAppSetting_codeStorename:self.onlineStoreText.placeholder];
        [MyUserDefault defaultSaveAppSetting_codeStore:self.thirdPartiesaTitleLabel.text];

    }
    
    if ([self.labelDicArr[indexPath.row] isEqualToString:@"其他平台"]) {
        
        self.onlineStoreText.placeholder = @"输入平台名称";
        self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
        [MyUserDefault defaultSaveAppSetting_codeStorename:self.onlineStoreText.placeholder];
        [MyUserDefault defaultSaveAppSetting_codeStore:self.thirdPartiesaTitleLabel.text];

    }
    
    self.onlineStoreText.text = @"";
    
    //!改变网络分销平台选择 的展开情况
    [self changeNetFrame];
}

-(void)doButton:(UIButton *)sender
{
//    sender.selected =! sender.selected;
    
    //!改变网络分销平台选择 的展开情况
    [self changeNetFrame];
}
//!改变网络分销平台选择 的展开情况
-(void)changeNetFrame{
    isShow = !isShow;
    [_tableView reloadData];
}

#pragma mark ------代理方法------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.onlineStoreText) {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 130);
        }];
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.checkCodeText) {
        
        if ([self.checkCodeText.text length] > 20) {
            
            textField.text = [self.checkCodeText.text substringToIndex:20];
            
            [self.view makeToast:@"最多输入20个字"duration:2.0 position:@"center"];
            
            return NO;
            
        }
        
    }

    if (textField == self.onlineStoreText) {
        
        if ([string isEqualToString:@"\n"]){
            return YES;
        }
         NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (self.onlineStoreText == textField)
        {
            if ([aString length] > 20) {
                
                textField.text = [aString substringToIndex:20];
                
                if ([self.thirdPartiesaTitleLabel.text  isEqualToString:@"请选择"]) {
                     [self.view makeToast:@"不能超过20个字" duration:2.0 position:@"center"];
                    
                }else
                {
                 [self.view makeToast:[NSString stringWithFormat:@"%@不能超过20个字",self.onlineStoreText.placeholder] duration:2.0 position:@"center"];
                }
                
                return NO;
            }
        }
    }
    
    
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{

   
}


//显示图片
-(void)showImageAction
{

    [self showPhotoWithCameratTag];
         self.image.hidden = NO;
    
    self.image.userInteractionEnabled = YES;
    
    
    
    if (self.image.image) {
        //改变网络分销frame
        [UIView animateWithDuration:time animations:^{
        
            self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, 241, self.netWordButton.frame.size.width, self.netWordButton.frame.size.height);
            
            self.distanceLength.constant = 159;
            self.netWordLabel.frame = CGRectMake(self.netWordLabel.frame.origin.x, 241, self.netWordLabel.frame.size.width, self.netWordLabel.frame.size.height);
            
        }];
    }
}


-(void)showPhotoWithCameratTag
{
    [self.tapView removeFromSuperview];
    
    
    self.tapView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, 106)];
    
    self.tapView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tapView];
    
    UIButton *phonoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    phonoButton.frame = CGRectMake(65, 16, 59, 59);
    [phonoButton setImage:[UIImage imageNamed:@"photo"] forState:(UIControlStateNormal)];
    [self.tapView addSubview:phonoButton];
    
    [phonoButton addTarget:self action:@selector(didClickPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *phonoLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 83, 59, 14)];
    [self.tapView addSubview:phonoLabel];
    phonoLabel.text = @"照片";
    phonoLabel.textAlignment = NSTextAlignmentCenter;
    phonoLabel.font = [UIFont systemFontOfSize:14];
    
    
    phonoLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    UIButton *cameraButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cameraButton.frame = CGRectMake(self.view.frame.size.width - 124, 16, 59, 59);
    [cameraButton setImage:[UIImage imageNamed:@"camera"] forState:(UIControlStateNormal)];
    [self.tapView addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(didClickCameraAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *cameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 124, 83, 59, 14)];
    [self.tapView addSubview:cameraLabel];
    cameraLabel.text = @"拍照";
    cameraLabel.font = [UIFont systemFontOfSize:14];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    /**
     *  动画生成
     */
    [UIView animateWithDuration:time animations:^{
        self.tapView.center = CGPointMake(self.tapView.center.x, self.tapView.center.y - self.tapView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//点击实体店按钮进行事件

- (void)didClickStoreButtonAction:(id)sender {
    
    [MyUserDefault removeCodeStorename];
    self.thirdPartiesaTitleLabel.text = @"请选择";
    self.onlineStoreText.placeholder = @"请选择";

    self.onlineStoreText.text = @"";
    [_tableView  reloadData];
    
    [self.view endEditing:YES];
    [self.checkCodeText resignFirstResponder];
    [self.businessLicenseText resignFirstResponder];
    
    self.image.hidden = YES;
    
    applyInfoDTO.shopType = @"0";
//    [self.storeButton setBackgroundImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:(UIControlStateNormal)];
//    [self.netWordButton setBackgroundImage:[UIImage imageNamed:@"02_注册_未选中"] forState:(UIControlStateNormal)];
    
    
    [self.storeButton setImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:UIControlStateNormal];
    [self.netWordButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];
    self.storeButton.selected = YES;
    self.netWordButton.selected = NO;
    
    
   
    
    
    
    self.businessLicenseText.hidden = NO;
    self.uploadImageButton.hidden = NO;
    self.descriptionLabel.hidden = NO;
    _tableView.hidden = YES;
    [UIView animateWithDuration:time animations:^{
        
        
        self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, 161, self.netWordButton.frame.size.width, self.netWordButton.frame.size.height);
        
        self.netWordLabel.frame = CGRectMake(self.netWordLabel.frame.origin.x, 161, self.netWordLabel.frame.size.width, self.netWordLabel.frame.size.height);
        
    }];
    
    
}

//点击网络分销进行事件

- (IBAction)didClickNetWorkButtonAction:(id)sender {
    
    
    
    //!点击实体店的时候，网络分销 的平台展开为no  网络平台不展开
    isShow = NO;
    
    [_tableView reloadData];

    [self.view endEditing:YES];

    self.businessLicenseText.text = nil;
    self.storeButton.selected = NO;
    self.netWordButton.selected = YES;
    
    self.image.hidden = YES;
    
    applyInfoDTO.shopType = @"1";
//    [self.storeButton setBackgroundImage:[UIImage imageNamed:@"02_注册_未选中"] forState:(UIControlStateNormal)];
//    [self.netWordButton setBackgroundImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:(UIControlStateNormal)];
    
    
    [self.storeButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];
    [self.netWordButton setImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:UIControlStateNormal];
    
    self.businessLicenseText.hidden = YES;
    self.uploadImageButton.hidden = YES;
    self.descriptionLabel.hidden = YES;
    _tableView.hidden = NO;
    
    
    [UIView animateWithDuration:time animations:^{
        
        
        self.netWordButton.frame = CGRectMake(self.storeButton.frame.origin.x, 105, self.netWordButton.frame.size.width, self.netWordButton.frame.size.height);
        
        
        self.netWordLabel.frame = CGRectMake(self.netWordLabel.frame.origin.x, 105 , self.netWordLabel.frame.size.width, self.netWordLabel.frame.size.height);
        
    }];
    
}




#pragma mark --------进行校验----

#pragma mark -------所有的校验在此方法中进行------
- (BOOL)checkInputValues {
    
    if (![self verifyInvitationCode]) {
        return NO;
    }
   
    if (![self verifyShopType]) {
        return NO;
    }
    
    
    
    
    
//    if (self.storeButton.selected == YES) {
//        if (![self verifyStore]) {
//            return NO;
//        }
//    }else if(self.netWordButton.selected == YES )
//    {
//        if (![self verifyNetWork]) {
//            return NO;
//        }
//
//    }
    
    if (self.netWordButton.selected == YES) {
        
        if (![self verifyThirdPartiesaTitle]) {
            return NO;
        }
    }
    
    
    return YES;
}



//第三平台类型的选择
-(BOOL)verifyThirdPartiesaTitle
{
    
    if ([self.thirdPartiesaTitleLabel.text isEqualToString:@"请选择"]) {
        
        [self.view makeToast:@"请选择平台类型" duration:2.0 position:@"center"];
        
        return NO;
    }

    return YES;
}



-(BOOL)verifyInvitationCode
{
    
    if (self.checkCodeText.text.length < 1) {
        
        [self.view makeToast:@"请输入贵宾码" duration:2.0f position:@"center"];
        
        return NO;
    }
    return YES;
}


-(BOOL)verifyShopType
{
    if (self.storeButton.selected == NO && self.netWordButton.selected == NO) {
        
        [self.view makeToast:@"请选择销售类型" duration:2.0f position:@"center"];

        return NO;
    }
    return YES;
}


//-(BOOL)verifyStore
//{
//
//    if (self.storeButton.selected == YES && self.netWordButton.selected == NO) {
//        
//        if ([self.businessLicenseText.text isEqualToString:@""]) {
//            [self.view makeToast:@"请输入营业执照号" duration:2.0f position:@"center"];
//            return NO;
//        }
//        
//    }
//    return YES;
//}

//-(BOOL)verifyNetWork
//{
//    if ([self.onlineStoreText.text isEqualToString:@""]) {
//        [self.view makeToast:@"请输入网点名称" duration:2.0f position:@"center"];
//        return NO;
//    }
//    return YES;
//
//}








//对营业执照以及图片进行校验

#pragma mark -----进行验证请求---
/**
 *  按钮进行提交
 *
 *  @param sender 进行验证码的申请。通过判断code返回的值，来进行判断是否验证成功。
 */
-(void)didClickVerifityAction
{

    [self.checkCodeText resignFirstResponder];
    [self.businessLicenseText resignFirstResponder];
    [self.onlineStoreText resignFirstResponder];
    
    self.verifityButton.selected = NO;
    
    
    
    if ([self checkInputValues]) {
        
        NSString *netType = @"";
        
        //!如果选择实体店
        if (self.storeButton.selected) {
            
            if ([self.businessLicenseText.text isEqualToString:@""]) {
                self.businessLicenseText.text = @"";
            }
            
            if (!self.imageUrl) {
                self.imageUrl = @"";
            }
            
            self.onlineStoreText.text = @"";
            netType = @"";
            
        }else{
        
            netType = self.thirdPartiesaTitleLabel.text;
            
            if ([self.onlineStoreText.text isEqualToString:@""]) {
                self.onlineStoreText.text = @"";
            }
            
            
            self.businessLicenseText.text = @"";
            self.imageUrl = @"";
        }
        
       
        
        [HttpManager sendHttpRequestForVerifyRegisterKeyCode:self.checkCodeText.text mobilePhone:[LoginDTO sharedInstance].memberAccount shopType:applyInfoDTO.shopType shopName:self.onlineStoreText.text otherPlatform:netType businessLicenseNo:self.businessLicenseText.text businessLicenseUrl:self.imageUrl success:^(AFHTTPRequestOperation *operation, id responseObject)

        {
        
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            self.verifityButton.selected = YES;

            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                [self.view makeToast:@"邀请码验证通过" duration:2.0f position:@"center"];

                

                NSMutableDictionary *h5Dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                             
                                                                                             @"tokenId":[LoginDTO sharedInstance].tokenId,
                                                                                             
                                                                                             @"memberNo":[LoginDTO sharedInstance].memberNo,
                                                                                             
                                                                                             }];

                //保存信息到plist文件中  h5交互需要用到
                SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
                [saveIofo addIofoDTO:h5Dic];
                
                
                //用户通过后进行其他地方登录
                //聊天登录
                UserOtherInfo *userOtherIofo = [[UserOtherInfo alloc]init];
                [userOtherIofo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_loginPhone] password:[MyUserDefault defaultLoadAppSetting_loginPassword]];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];

//                //验证成功后进行页面跳转
//                //更新window rootViewController
//                AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//                
//                [delegate updateRootViewController];
        
                
            } else {
                
                //进行判断邀请码是否过期或者是言情吗错误
                [self.view makeToast:[NSString stringWithFormat:@"%@", [dic objectForKey:@"errorMessage"]]  duration:2.0 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
            self.verifityButton.selected = YES;

        }];
    }
}

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.tapView.center =
        CGPointMake(self.tapView.center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
        
    }];
    //整个页面从心返回原来的位置
    [UIView  animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    

    self.tapView.hidden = YES;
    
}



//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//    [UIView animateWithDuration:time animations:^{
//        self.tapView.center =
//        CGPointMake(self.tapView.center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
//    }];
//    //整个页面从心返回原来的位置
//    [UIView  animateWithDuration:time animations:^{
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//    }];
//    
//}



@end
