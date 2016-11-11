//
//  CSPApplyEditeViewController.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/11.
//  Copyright © 2016年 pactera. All rights reserved.
//
@import AssetsLibrary;
#import <MobileCoreServices/UTCoreTypes.h>

#import"CSPApplyDataTableViewController.h"
#import "CSPCodeVerifyViewController.h"
#import "CustomButton.h"
#import "CustomTextApplyField.h"
#import "HZAreaPickerView.h"
#import "CSPUtils.h"
#import "ConsigneeAddressDTO.h"
#import "NoInviteCodeInfoView.h"
#import "EnlargeImageModel.h"
#import "CustomTextApplyView.h"
#import "EnlargeImageView.h"
#import "CustomTextShopView.h"
#import "LoginDTO.h"
#import "UIImageView+WebCache.h"
//采用百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


//采用百度地图定位
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "ZJ_ManagerAddressCell.h"
#define MAX_INPUT_LENGTH 60
#define  distance 11
#define  time 0.5
#define timeNet 0.2
#define scrollViewLineLength  41
#define decimal 1


typedef NS_ENUM(NSInteger, UploadImageStyle) {
    UploadImageStyleNone,
    UploadImageStyleIdCard,
    UploadImageStyleBusinessLicense,
};


#import "CSPApplyEditeViewController.h"

@interface CSPApplyEditeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, HZAreaPickerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,EnlargeImageViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,BMKMapViewDelegate, BMKSuggestionSearchDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate>
{
    //采用百度地图
    BMKMapView* _mapView;
    BMKSuggestionSearch* _poisearch;
    int curPage;
    
    //百度地图定位
    BMKGeoCodeSearch* _geocodesearch;
    BMKLocationService* _locService;
    //省市区名字
    NSString *cityNameStr;
    NSArray *provinces, *cities, *areas;
    
    ApplyInfoDTO* applyInfoDTO;
    UITableView *_tableView;
    
    UIView *headerView;
    UIView *footerView;
    
    //判断第三方是否展开
    BOOL isShow;
    UIButton *buttonSubmit;
    
    BOOL isIdcardImg;
    NSData *dataIdCard;
    NSData *dataStore;
    
}

@property (nonatomic,strong)NSMutableArray *detailAddressStr;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (strong, nonatomic)UIScrollView *scrollView;
//提示 重新提交
@property (strong, nonatomic)UILabel *labelAlert;
//推荐人邀请码
@property (strong, nonatomic)CustomTextApplyField *codeTextField;
//名字
@property (strong, nonatomic)CustomTextApplyField *nameTextField;
//男
@property (strong ,nonatomic)UIButton *manButton;
//女
@property (strong ,nonatomic)UIButton *womanButton;
//电话号码
@property (strong, nonatomic)CustomTextApplyField *phoneNumTextField;
//省市区
@property (strong, nonatomic)CustomTextApplyField *cityTextField;
//详细地址
@property (strong, nonatomic)CustomTextApplyView *detailTextView;
//地点选择
@property (nonatomic,strong) HZAreaPickerView* locatePicker;
//model类
@property (nonatomic,strong) HZLocation* location;
//详细地址label
@property (strong, nonatomic)UILabel  *detailLabel;
//详细地址labelLine
@property (strong,nonatomic)UILabel *detailLineLabel;
//电话号码
@property (strong, nonatomic)CustomTextApplyField *fixedLineTextField;
//身份证号码
@property (strong, nonatomic)CustomTextApplyField *idCardTextField;
//上传身份证照片
@property (strong, nonatomic)UILabel *labelIdCard;
//上传身份证照片按钮
@property (strong,nonatomic)UIButton *uploadIdCardImageButton;
//上传身份证图片
@property (strong,nonatomic)UIImageView *uploadIdCardImage;
//实体店按钮
@property (strong,nonatomic)UIButton *storeButton;
//实体店label
@property (strong,nonatomic)UILabel *storeLabel;
//营业执照号码
@property (strong,nonatomic)CustomTextApplyField *businessLicenseTextField;
//上传营业执照照片
@property (strong, nonatomic)UILabel *labelBusinessLicense;
//上传营业执照照片按钮
@property (strong,nonatomic)UIButton *uploadBusinessLicenseButton;
//上传营业执照照片
@property (strong,nonatomic)UIImageView *uploadBusinessLicenseImage;
//上传营业执照描述
@property (strong,nonatomic)UILabel *uploadBusinessLicenseLabel;
//网络营销button
@property (strong,nonatomic)UIButton *netWorkButton;
//网络营销label
@property(strong,nonatomic)UILabel *netWorkLabel;
@property (strong,nonatomic)NSMutableArray *valueDicArr;
@property (strong,nonatomic)NSMutableArray *labelDicArr;
//输入框内描述店铺内容
@property (strong,nonatomic)UITextView *inputBoxDescribeTextView;
//描述第三方名字
@property (strong,nonatomic)UILabel *thirdPartiesaTitleLabel;
//输入网点名字
@property (strong,nonatomic)CustomTextShopView *onlineStoreText;
//第三方按钮
@property (strong,nonatomic)UIButton *thirdPartiesaButton;

//改变的高度
@property (assign,nonatomic) NSInteger distanceLeght;
@property (nonatomic,strong)UIView *tapView;
@property (nonatomic, assign) UploadImageStyle uploadImageStyle;
//身份证url
@property (nonatomic, strong) NSString* idCardImageURL;
//营业执照url
@property (nonatomic, strong) NSString* businessLicenseImageURL;
//照相、照片
@property (nonatomic, strong)UIImagePickerController* imagePickerController;

@property (nonatomic,strong)EnlargeImageView *enlargeImage;

//设置输入框内容显示
@property (nonatomic,strong)UILabel *inputBoxDescribeLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *subminBtn;

@property (strong, nonatomic) UITableView *addressTableView;

@property (strong, nonatomic)UIPickerView *pickerThird;

@end

@implementation CSPApplyEditeViewController

-(void)allTextKeyboardRecycling
{
    [self.view endEditing:YES];
//    [self.codeTextField resignFirstResponder];
//    [self.nameTextField resignFirstResponder];
//    [self.phoneNumTextField resignFirstResponder];
//    [self.cityTextField resignFirstResponder];
//    [self.fixedLineTextField resignFirstResponder];
//    [self.idCardTextField  resignFirstResponder];
//    [self.businessLicenseTextField resignFirstResponder];
//    [self.onlineStoreText resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    buttonSubmit.hidden = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    //定位
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poisearch.delegate = self;
    [super viewWillAppear:animated];
    
    [MyUserDefault removestorename];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    buttonSubmit.hidden = YES;

    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
}


#pragma mark===================所有的校验在此方法中进行===============================
- (BOOL)checkInputValues {
  
    if (![self verifyCode]) {
        return NO;
    }
    if (![self verifySex]) {
        return NO;
    }
    
    if (![self verifyName]) {
        return NO;
    }
    
    if (![self verifyPhoneNumber]) {
        return NO;
    }
    if (![self verifyTelePhone]) {
        return NO;
    }
    
    
    if (![self verifyCity]) {
        return NO;
    }
    
    if (![self verifyDetailAddress]) {
        return NO;
    }
    
    if (![self verifyIdCardNumber]) {
        return NO;
    }
    
    if (![self verifyIdCardImage]) {
        return NO;
    }
    
    if (![self verifyShopType]) {
        return NO;
    }
    
    //选择网络营销
    if (self.netWorkButton.selected == YES) {
        if (![self verifyThirdPartiesaTitle]) {
            return NO;
        }
    }
    
    //    if (![self verifyDescriptionTextView]) {
    //        return NO;
    //    }
    
    return YES;
}

//进行地退吗判断

-(BOOL)verifyCode
{
   
    if (self.codeTextField.text.length !=7&&self.codeTextField.text.length >0) {
        
        [self.view makeToast:@"邀请码错误" duration:2.0f position:@"center"];
        return NO;
    }else {
        DataValidationResult result = [CSPUtils checkDataValidationForCode:self.codeTextField.text];
        if (result == DataValidationResultIllegal) {
            [self.view makeToast:@"邀请码仅可填写英文及数字" duration:2.0f position:@"center"];
            return NO;
        }

    }
    return YES;
}
//选择第三方必填
-(BOOL)verifyThirdPartiesaTitle
{
    if ([self.thirdPartiesaTitleLabel.text isEqualToString:@"请选择"]) {
        
        [self.view makeToast:@"请选择平台类型" duration:2 position:@"center"];
        
        return NO;
    }
    return YES;
}


-(BOOL)verifyStore
{
    
    if (self.storeButton.selected == YES && self.netWorkButton.selected == NO) {
        
        if ([self.businessLicenseTextField.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入营业执照号" duration:2.0f position:@"center"];
            return NO;
        }
        
    }
    return YES;
}
-(BOOL)verifyNetWork
{
    if ([self.thirdPartiesaTitleLabel.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入网点名称" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

-(BOOL)verifyShopType
{
    if (self.storeButton.selected == NO && self.netWorkButton.selected == NO) {
        
        [self.view makeToast:@"请选择销售类型" duration:2.0f position:@"center"];
        
        return NO;
    }
    return YES;
}



//对名字进行检验
- (BOOL)verifyName {
    DataValidationResult result = [CSPUtils checkDataValidationForUserName:self.nameTextField.text];
    if (result == DataValidationResultEmpty ||
        result == DataValidationResultTooShort) {
        [self.view makeToast:@"姓名不能为空" duration:2.0f position:@"center"];
        return NO;
    } else if (result == DataValidationResultTooLong) {
        [self.view makeToast:@"姓名不得超过10个字" duration:2.0f position:@"center"];
        return NO;
    } else if (result == DataValidationResultIllegal) {
        [self.view makeToast:@"请使用中文或英文输入姓名" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

//对电话号码进行检验
- (BOOL)verifyPhoneNumber {
    if (self.phoneNumTextField.text.length == 0) {
        [self.view makeToast:@"手机号码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if ([CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        return YES;
    }
    [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
    return NO;
}
//对电话号码进行检验
- (BOOL)verifyTelePhone {
    if (self.fixedLineTextField.text.length > 13) {
        [self.view makeToast:@"座机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}
//对城市进行检验
- (BOOL)verifyCity {
    if (self.cityTextField.text == nil) {
        [self.view makeToast:@"省市区不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}
//对详细地址进行检验
- (BOOL)verifyDetailAddress {
    
    if ([CSPUtils checkDetailAddressLength:self.detailTextView.text]) {
        return YES;
    }
    [self.view makeToast:@"详细地址长度必须为5~60字" duration:2.0f position:@"center"];
    return NO;
}
//对邮编进行检验
- (BOOL)verifyFixedLine {
    
    if (self.fixedLineTextField.text.length == 0) {
        [self.view makeToast:@"座机号码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if ([CSPUtils checkFixedLineNumber:self.fixedLineTextField.text]) {
        return YES;
    }
    [self.view makeToast:@"座机号码格式错误" duration:2.0f position:@"center"];
    return NO;
}
//对身份证号码进行校验
- (BOOL)verifyIdCardNumber {
    
//    if (self.idCardTextField.text.length == 0) {
//        [self.view makeToast:@"身份证号码不能为空" duration:2.0f position:@"center"];
//        
//        return NO;
//    }
    
    
    if (![CSPUtils checkUserIdCard:self.idCardTextField.text]&&self.idCardTextField.text.length > 0) {
        [self.view makeToast:@"身份证号码格式错误" duration:2.0f position:@"center"];
        
        return NO;
    }
    return YES;
}
//对营业号进行校验
- (BOOL)verifyBusinessLicense {
    if (self.businessLicenseTextField.text.length > 6) {
        return YES;
    }
    
    [self.view makeToast:@"营业执照号码格式错误" duration:2.0f position:@"center"];
    
    return NO;
}
//对上传身份证图片进行校验
- (BOOL)verifyIdCardImage {
    return YES;
//    if (self.idCardImageURL) {
//        return YES;
//    }
//    [self.view makeToast:@"身份证照不能为空" duration:2.0f position:@"center"];
//    return NO;
}
//对营业执照图片进行校验
- (BOOL)verifyBusinessLicenseImage {
    if (self.businessLicenseImageURL) {
        return YES;
    }
    [self.view makeToast:@"营业执照不能为空" duration:2.0f position:@"center"];
    return NO;
}

-(BOOL)verifyDescriptionTextView
{
    if (self.inputBoxDescribeTextView.text.length <= 6) {
        [self.view makeToast:@"内容最少6个字" duration:2.0f position:@"center"];
        return NO;
    }
    
    if (self.inputBoxDescribeTextView.text.length > 500) {
        [self.view makeToast:@"内容最多500个字" duration:2.0f position:@"center"];
        
        return NO;
    }
    
    return YES;
}

//进行性别判断

-(BOOL)verifySex
{
    if (self.womanButton.selected == NO && self.manButton.selected == NO) {
        [self.view makeToast:@"请选择性别" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}



-(BOOL)verifyStoreName
{
    
    if (self.onlineStoreText.text.length > 20) {
        [self.view makeToast:@"最长输入20个字" duration:2.0f position:@"center"];
        return NO;
    }
    
    return YES;
}


//进行地退吗判断


- (IBAction)submitInformition:(id)sender {
    
    
    [self allTextKeyboardRecycling];
    if ([self checkInputValues]) {
        //1、创建
        GUAAlertView *al=[GUAAlertView alertViewWithTitle:@"申请资料提交后不能修改" withTitleClor:nil message:@"是否提交申请" withMessageColor:nil oKButtonTitle:@"提交" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //[MBProgressHUD show];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (dataIdCard) {
                [self postImgApply:@"1"];
            }else if(dataStore){
                  [self postImgApply:@"2"];
            }else{
                [self prepareForCommitApply];
            }
            
            NSLog(@"右边按钮（第一个按钮）的事件");
            
        } dismissAction:^{
            NSLog(@"左边按钮（第二个按钮）的事件");
        }];
        //2、显示
        [al show];
    }
    
}
#pragma mark ==================返回===============
///**
// *  返回按钮
// */
//- (void)backBarButtonClick:(UIBarButtonItem *)sender{
//    
//   
//}

-(void)postImgApply:(NSString *)type{

    NSData *data = [type isEqualToString:@"1"]?dataIdCard:dataStore;
    
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:type orderCode:@"" goodsNo:@"" file:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self.nameTextField resignFirstResponder];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSLog(@"success to upload id card image");
            if ([type isEqualToString:@"1"]) {
              
                self.idCardImageURL = dic[@"data"];
                if (self.storeButton.selected&&dataStore) {
                    [self postImgApply:@"2"];
                }else{
                    [self prepareForCommitApply];
                }
                
            }else{
                
                self.businessLicenseImageURL = dic[@"data"];
                [self prepareForCommitApply];
                
            }
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self.view makeToast:@"上传照片失败" duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error ==== %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];


}
#pragma mark ==================提交申请资料请求方法===============
- (void)prepareForCommitApply {
    
    
    
    applyInfoDTO.mobilePhone = self.phoneNumTextField.text;
    applyInfoDTO.keyCode = [self.codeTextField.text length] > 0? self.codeTextField.text :@"";
    applyInfoDTO.memberName = self.nameTextField.text;
    applyInfoDTO.telephone = self.fixedLineTextField.text;
    if (![MyUserDefault isBlankNum:self.location.stateId] || ![MyUserDefault isBlankNum:self.location.cityId]  ||![MyUserDefault isBlankNum:self.location.districtId]) {
        applyInfoDTO.provinceNo = self.location.stateId;
        applyInfoDTO.cityNo = self.location.cityId;
        applyInfoDTO.countyNo = self.location.districtId;
    }
    
    applyInfoDTO.detailAddress = self.detailTextView.text;
    
    applyInfoDTO.identityNo =[self.idCardTextField.text length]?self.idCardTextField.text:@"";
    
    applyInfoDTO.identityPicUrl = [self.idCardImageURL length]?self.idCardImageURL:@"";
    
    if (self.businessLicenseTextField.text.length == 0) {
        
        applyInfoDTO.businessLicenseNo = @"";
        
    }else
    {
        applyInfoDTO.businessLicenseNo = self.businessLicenseTextField.text;
    }
    
    if (self.businessLicenseImageURL.length == 0) {
        applyInfoDTO.businessLicenseUrl = @"";
    }else
    {
        applyInfoDTO.businessLicenseUrl =self.businessLicenseImageURL;
        
    }
    
    if ([self.inputBoxDescribeTextView.text isEqual:nil]) {
        
        self.inputBoxDescribeTextView.text = @"";
        
    }else
    {
        
        applyInfoDTO.businessDesc = self.inputBoxDescribeTextView.text;
    }
    
    NSString *platform = [self.thirdPartiesaTitleLabel.text isEqualToString:@"请选择"]?@"":self.thirdPartiesaTitleLabel.text;
    
    if (_firstFlag) {
        [HttpManager sendHttpRequestForaddApplyInfoFirstWithApplyInfo:applyInfoDTO shopName:self.onlineStoreText.text whithPushCode:self.codeTextField.text otherPlatform:platform success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             
             if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                 CSPApplyDataTableViewController *cspApply = [[CSPApplyDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
                 [MemberInfoDTO sharedInstance].applyid = [[dic objectForKey:@"data"] objectForKey:@"id"];
                 [self.navigationController pushViewController:cspApply animated:YES];
                 
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             [self.view makeToast:[NSString stringWithFormat:@"上传申请资料失败, %@", @"errorMessage"] duration:2.0f position:@"center"];
         }];
        
    }else{
        [HttpManager sendHttpRequestForaddApplyInfoAgainWithApplyInfo:applyInfoDTO shopName:self.onlineStoreText.text otherPlatform:platform success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             
             if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                 
                 CSPApplyDataTableViewController *cspApply = [[CSPApplyDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
                 [MemberInfoDTO sharedInstance].applyid = [[dic objectForKey:@"data"] objectForKey:@"id"];
                 [self.navigationController pushViewController:cspApply animated:YES];
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             [self.view makeToast:[NSString stringWithFormat:@"上传补充申请资料失败, %@", @"errorMessage"] duration:2.0f position:@"center"];
         }];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttonSubmit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 12, 40, 20)];
    [self.navigationController.navigationBar addSubview:buttonSubmit];
    [buttonSubmit setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    buttonSubmit.titleLabel.font = [UIFont systemFontOfSize:12];
    [buttonSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [buttonSubmit addTarget:self action:@selector(submitInformition:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor =[UIColor whiteColor];
    applyInfoDTO = [[ApplyInfoDTO alloc]init];
    
    //网络请求创建空间
    self.labelDicArr = [NSMutableArray arrayWithCapacity:0];
    self.valueDicArr = [NSMutableArray arrayWithCapacity:0];
    //设置ui
    [self makeUI];
    //设置网络请求
    if ([LoginDTO sharedInstance].tokenId) {
        [self netWorkRequest];
    }
    applyInfoDTO.shopType = @"0";
    //添加按钮
    [self addCustombackButtonItem];
    //标题
    self.title = @"申请资料";
    //第一次进来后传值
    [self firstValue];
    //设置图片页面消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(elcImagePickerControllerDidCancel:) name:@"cacelPhotoPage" object:nil];
    self.enlargeImage = [[EnlargeImageView alloc]init];
    self.enlargeImage.delegate = self;
    
    //采用百度地图
    _poisearch = [[BMKSuggestionSearch alloc]init];
    //百度地图定位
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data.plist" ofType:nil]];
    
    
    
}

#pragma mark ===================进行第一次进来后传值===================
-(void)firstValue
{
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //赋值只是用一次
    if ([self.applyDefault.sex isEqualToString:@"1"]) {
        [self.manButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else if([self.applyDefault.sex isEqualToString:@"2"]){
        [self.womanButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.womanButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    self.nameTextField.text = _applyDefault.memberName;
    
    self.phoneNumTextField.text = _applyDefault.mobilePhone;
    
    self.cityTextField.text =self.applyDefault? [NSString stringWithFormat:@"%@ %@ %@",self.applyDefault.provinceName,self.applyDefault.cityName,self.applyDefault.countyName]:@"";
;
    self.fixedLineTextField.text = self.applyDefault.telephone;
    self.idCardTextField.text = self.applyDefault.identityNo;
 
    NSArray *arr = [self.cityTextField.text componentsSeparatedByString:@" "];
    if (arr.count >1) {
        cityNameStr = arr[1];
    }
    
    self.detailTextView.text = self.applyDefault.detailAddress;
    
    if (self.applyDefault.detailAddress.length) {
        self.detailLabel.hidden = YES;
    }
    //[self lenghtTextView:self.detailTextView];
    
    if ([self.applyDefault.identityPicUrl length]) {
         [self.uploadIdCardImage sd_setImageWithURL:[NSURL URLWithString:self.applyDefault.identityPicUrl]];
        UIButton *btn = [self.view viewWithTag:1200];
        btn.hidden = NO;
        self.uploadIdCardImage.userInteractionEnabled = YES;
       
    }
   
    self.idCardImageURL = self.applyDefault.identityPicUrl;
    
    self.inputBoxDescribeTextView.text = self.applyDefault.businessDesc;
    if ([self.applyDefault.businessDesc length]) {
        self.inputBoxDescribeLabel.hidden = YES;
    }
    
    if ([self.applyDefault.shopType intValue]==1) {
        [self.netWorkButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.thirdPartiesaTitleLabel.text = self.applyDefault.otherPlatform;
        self.onlineStoreText.text = self.applyDefault.shopName;
    
    }else{
    
        if ([self.applyDefault.businessLicenseUrl length]) {
            [self.uploadBusinessLicenseImage sd_setImageWithURL:[NSURL URLWithString:self.applyDefault.businessLicenseUrl]];
            UIButton *btn = [self.view viewWithTag:1201];
            btn.hidden = NO;
            self.uploadBusinessLicenseImage.userInteractionEnabled = YES;
            
        }
        
        self.businessLicenseTextField.text = self.applyDefault.businessLicenseNo;
        [self.storeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        //applyInfoDTO.businessLicenseUrl = self.applyDefault.businessLicenseUrl;
        self.businessLicenseImageURL = self.applyDefault.businessLicenseUrl;
        
    }
    applyInfoDTO.keyCode = [self.applyDefault.keyCode length]?self.applyDefault.keyCode:@"";
    applyInfoDTO.provinceNo = self.applyDefault.provinceNo;
    applyInfoDTO.cityNo = self.applyDefault.cityNo;
    applyInfoDTO.countyNo = self.applyDefault.countyNo;
    
    self.location = [[HZLocation alloc]init];
    
    self.location.stateId= applyInfoDTO.provinceNo;
    
    self.location.cityId = applyInfoDTO.cityNo;
    
    self.location.districtId = applyInfoDTO.countyNo ;
    
    //    });
}

//进行判断textview====设置长度进行判断=====

-(void)lenghtTextView:(UITextView *)textView
{
    
    if (textView.text.length > 0) {
        self.detailLabel.hidden = YES;
        [self.detailTextView setTextColor:FontTitleColor];
    }
}






#pragma mark ================进行删除=================
-(void)deleteImageView:(NSInteger )imageViewTag
{
    
    if (self.uploadIdCardImage.tag == imageViewTag) {
        self.uploadIdCardImage.hidden = YES;
        self.uploadIdCardImageButton.hidden = NO;
        self.idCardImageURL = @"";
        dataIdCard = nil;
    }
    
    if (self.uploadBusinessLicenseImage.tag == imageViewTag) {
        self.uploadBusinessLicenseImage.hidden = YES;
        self.uploadBusinessLicenseButton.hidden = NO;
        self.businessLicenseImageURL = @"";
        dataStore = nil;
    }
}


#pragma mark================(列表的展示数据)====================
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return self.labelDicArr.count+1;
   
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row) {
        return self.labelDicArr[row-1];
    }else{
        return @"请选择";
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row) {
        self.thirdPartiesaTitleLabel.text = self.labelDicArr[row-1];

    }else{
        self.thirdPartiesaTitleLabel.text = @"请选择";
    }
    self.onlineStoreText.text = @"";
    if (row ==4) {
        self.onlineStoreText.placeholder = @"请输入微信号";
    }else if(row == 5){
        self.onlineStoreText.placeholder = @"请输入平台名称";
    }else{
        self.onlineStoreText.placeholder = @"请输入网店名称";
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        CGRect rect = _pickerThird.frame;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerThird.frame =rect;
       
    }completion:^(BOOL finished) {
     _pickerThird.hidden = YES;
    }];
    
}
#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _addressTableView) {
        return self.detailAddressStr.count;
    }else{
        if (isShow) {
            return self.labelDicArr.count;
        }else{
            return 0;
        }
    }
    
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _addressTableView) {
        return 1;
    }else{
        return 41;
    }
    
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _addressTableView) {
        return 1;
    }else{
        return 41;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _addressTableView) {
        return nil;
    }else{
        if (!footerView) {
            footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 96, 41)];
            footerView.backgroundColor = [UIColor clearColor];
            
            
            self.onlineStoreText = [[CustomTextShopView alloc]initWithFrame:CGRectMake(footerView.frame.origin.x, 11, footerView.frame.size.width, 30)];
            
            [footerView addSubview:self.onlineStoreText];
            self.onlineStoreText.delegate = self;
            
            self.onlineStoreText.textColor = FontTitleColor;
            
            self.onlineStoreText.font = [UIFont systemFontOfSize:14];
            
            //通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineStoreTextChange) name:UITextFieldTextDidChangeNotification object:nil];
            
            if ([MyUserDefault defaultLoadAppSetting_storename] == nil) {
                self.onlineStoreText.placeholder = @"输入网店名称";
            }else
            {
                
                self.onlineStoreText.placeholder = [MyUserDefault defaultLoadAppSetting_storename];
            }
            
            
        }
        return footerView;
    }
    
    
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    //    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //
    //    void (^task)() = ^ {
    //        // 延迟操作执行的代码
    //
    //    };
    //    // 经过多少纳秒，由主队列调度任务异步执行
    //    dispatch_after(when, dispatch_get_main_queue(), task);
    //    // 先执行就是异步，后执行就是同步
    if (tableView == _addressTableView) {
        return nil;
    }else{
        if (!headerView) {
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 96, 41)];
            headerView.backgroundColor = [UIColor clearColor];
            headerView.layer.borderWidth = 1;
            headerView.layer.borderColor = FontTitleColor.CGColor;
            
            
            
            self.thirdPartiesaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 13, headerView.frame.size.width - 60, 15)];
            self.thirdPartiesaTitleLabel.textAlignment = NSTextAlignmentCenter;
            self.thirdPartiesaTitleLabel.textColor = FontTitleColor;
            self.thirdPartiesaTitleLabel.text = @"请选择";
            
            
            [headerView addSubview:self.thirdPartiesaTitleLabel];
            self.thirdPartiesaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.thirdPartiesaButton.frame = CGRectMake(self.view.frame.size.width - 96 - 40,0 ,40 ,44);
            self.thirdPartiesaButton.tag = 100+section;
            [self.thirdPartiesaButton addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //        [self.thirdPartiesaButton setBackgroundImage:[UIImage imageNamed: @"down"] forState:(UIControlStateNormal)];
            [self.thirdPartiesaButton setImage:[UIImage imageNamed: @"down"] forState:UIControlStateNormal];
            
            
            [headerView addSubview:self.thirdPartiesaButton];
            
            
        }
        
        return headerView;
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _addressTableView) {
        ZJ_ManagerAddressCell *managerCell = [tableView dequeueReusableCellWithIdentifier:@"ZJ_ManagerAddressCell"];
        if (!managerCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ZJ_ManagerAddressCell" bundle:nil] forCellReuseIdentifier:@"ZJ_ManagerAddressCell"];
            managerCell = [tableView dequeueReusableCellWithIdentifier:@"ZJ_ManagerAddressCell"];
        }
        managerCell.selectionStyle= UITableViewCellSelectionStyleNone;
        //managerCell.nameLabel.text = self.detailAddressStr[indexPath.row];
        NSString *strDetailAddressStr = self.detailAddressStr[indexPath.row];
        
        NSRange range = [self.detailAddressStr[indexPath.row] rangeOfString:self.detailTextView.text];
        if (range.length==0) {
            range = [self.detailAddressStr[indexPath.row] rangeOfString:[self.detailTextView.text lowercaseString]];
        }
        if (range.length>0) {
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:strDetailAddressStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x666666 alpha:1]}];
            
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0xeb301f alpha:1] range:range];
            managerCell.nameLabel.attributedText = str;
        }else{
            managerCell.nameLabel.text = self.detailAddressStr[indexPath.row];
            managerCell.nameLabel.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
            ;
            
        }
        
        // managerCell.nameLabel.textColor = [UIColor whiteColor];
        managerCell.backgroundColor = [UIColor clearColor];
        
        return managerCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        
        cell.textLabel.text = self.labelDicArr[indexPath.row];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = FontTitleColor.CGColor;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _addressTableView) {
        self.addressTableView.hidden = YES;
        self.detailLabel.hidden = YES;
        self.detailTextView.text = self.detailAddressStr[indexPath.row];
    }else{
        if ([self.labelDicArr[indexPath.row] isEqualToString:@"淘宝"] || [self.labelDicArr[indexPath.row] isEqualToString:@"天猫"] || [self.labelDicArr[indexPath.row] isEqualToString:@"京东"]) {
            
            self.onlineStoreText.tag = 200;
            self.onlineStoreText.placeholder = @"输入网店名称";
            
            [MyUserDefault defaultSaveAppSetting_storename:self.onlineStoreText.placeholder];
            
            self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
            
            
        }
        if ([self.labelDicArr[indexPath.row] isEqualToString:@"微商"]) {
            
            self.onlineStoreText.placeholder = @"输入微信号";
            self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
            
            [MyUserDefault defaultSaveAppSetting_storename:self.onlineStoreText.placeholder];
            
        }
        if ([self.labelDicArr[indexPath.row] isEqualToString:@"其他平台"]) {
            self.onlineStoreText.placeholder = @"输入平台名称";
            self.thirdPartiesaTitleLabel.text = self.labelDicArr[indexPath.row];
            [MyUserDefault defaultSaveAppSetting_storename:self.onlineStoreText.placeholder];
        }
        
        
        self.onlineStoreText.text = @"";
        
        //!改变tableview和底部控件的frame
        
        [self changeNetworFrame];
        
    }
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView !=self.addressTableView) {
          self.addressTableView.hidden = YES;
        [self.detailTextView resignFirstResponder];
    }
  
}

-(void)doButton:(UIButton *)sender
{
    if (!_pickerThird) {
        _pickerThird = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        _pickerThird.delegate = self;
        _pickerThird.dataSource = self;
        _pickerThird.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
        [self.view addSubview:_pickerThird];
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, _storeButton.frame.origin.y-distance);
        CGRect rect = _pickerThird.frame;
        rect.origin.y = SCREEN_HEIGHT-200-64;
        _pickerThird.frame =rect;
        
    }completion:^(BOOL finished) {
        _pickerThird.hidden = NO;
    }];
    //!改变tableview和底部控件的frame
    //[self changeNetworFrame];
    
}
//!改变tableview和底部控件的frame

-(void)changeNetworFrame{
    
    
    //!改变展开状态
    isShow = !isShow;
    
    //[_tableView reloadData];
    
    //!展开的时候
    if (isShow) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.inputBoxDescribeTextView.frame = CGRectMake(self.netWorkButton.frame.origin.x + 10, self.netWorkButton.frame.origin.y + self.netWorkButton.frame.size.height + 127 + self.labelDicArr.count *41 , self.fixedLineTextField.frame.size.width, 100);
            self.inputBoxDescribeLabel.frame = CGRectMake(self.inputBoxDescribeTextView.frame.origin.x, self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width, 50);
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.inputBoxDescribeTextView.frame = CGRectMake(self.netWorkButton.frame.origin.x  + 10, self.netWorkButton.frame.origin.y + self.netWorkButton.frame.size.height + 127 , self.fixedLineTextField.frame.size.width, 100);
            self.inputBoxDescribeLabel.frame = CGRectMake(self.inputBoxDescribeTextView.frame.origin.x, self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width, 50);
            
        }];
    }
}

-(void)setDeteilTextViewFrame
{
    
    
}

#pragma mark================(设置网络请求)====================
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
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark ====================设置UI=====================
-(void)makeUI
{
    
    //背景是scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -65)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
    float h ;
        if (_noPass) {
            self.codeTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(0,0, 0, 0)];

            self.labelAlert  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            self.labelAlert.font = [UIFont systemFontOfSize:14];
            self.labelAlert.text = @"您的资料未通过审核，可重新填写后提交!";
            self.labelAlert.textColor = [UIColor whiteColor];
            self.labelAlert.textAlignment = NSTextAlignmentCenter;
            self.labelAlert.backgroundColor = [UIColor colorWithHexValue:0xeb301f alpha:1];
            [self.scrollView addSubview:self.labelAlert];
            h = self.labelAlert.frame.size.height + self.labelAlert.frame.origin.y;

        }else{
            if (_firstFlag) {
                self.codeTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(0,distance, self.view.frame.size.width , 45)];
                self.codeTextField.placeholder = @"内推邀请码（非必填）";
                self.codeTextField.delegate = self;
                self.codeTextField.textColor = FontTitleColor;
                self.codeTextField.keyboardType = UIKeyboardTypeAlphabet;
                self.codeTextField.font = [UIFont systemFontOfSize:14];
                [self.scrollView addSubview:self.codeTextField];
                h = self.codeTextField.frame.size.height +self.codeTextField.frame.origin.y;
            }else{
                self.codeTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(0,0, 0, 0)];
                
            }
            
    }
    
    
    //姓名
    self.nameTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(0,distance + h, self.view.frame.size.width , 45)];
    self.nameTextField.placeholder = @"姓名";
    self.nameTextField.delegate = self;
    self.nameTextField.textColor = FontTitleColor;
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.nameTextField];
    
    //女
    self.womanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.womanButton.frame = CGRectMake(self.view.frame.size.width - 48 - 10, distance + h+10 , 42, 18);
    [self.womanButton setTitle:@"女" forState:(UIControlStateNormal)];
    self.womanButton.titleLabel.textColor = [UIColor whiteColor];
    self.womanButton.layer.borderWidth = 1;
    self.womanButton.layer.borderColor = LGButtonColor.CGColor;
    self.womanButton.layer.cornerRadius = 3.0;
    self.womanButton.layer.masksToBounds = YES;
    self.womanButton.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    
    self.womanButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.womanButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    
    [self.scrollView addSubview:self.womanButton];
    [self.womanButton addTarget:self action:@selector(setWonmanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //男
    self.manButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.manButton.frame = CGRectMake(self.view.frame.size.width - 48 - 10 - 42-5, distance + h+10, 42, 18);
    [self.manButton setTitle:@"男" forState:(UIControlStateNormal)];
    self.manButton.titleLabel.textColor = [UIColor whiteColor];
    self.manButton.layer.borderWidth = 1;
    self.manButton.layer.borderColor = LGButtonColor.CGColor;
    self.manButton.layer.cornerRadius = 3.0;
    self.manButton.layer.masksToBounds = YES;
    self.manButton.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    
    [self.scrollView addSubview:self.manButton];
    [self.manButton addTarget:self action:@selector(setManButtonAciotn) forControlEvents:UIControlEventTouchUpInside];
    
    self.manButton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [self.manButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    
    
    //手机号码
    self.phoneNumTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height + distance, self.view.frame.size.width, self.nameTextField.frame.size.height)];
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.textColor = FontTitleColor;
    self.phoneNumTextField.placeholder = @"手机号";
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.phoneNumTextField];
    
    
    
    //省市区
    self.cityTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(self.phoneNumTextField.frame.origin.x, self.phoneNumTextField.frame.origin.y + self.phoneNumTextField.frame.size.height +distance, self.phoneNumTextField.frame.size.width, self.phoneNumTextField.frame.size.height)];
    self.cityTextField.placeholder = @"省市区";
    self.cityTextField.delegate = self;
    self.cityTextField.textColor = FontTitleColor;
    self.cityTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.cityTextField];
    
    
    
    //详细地址
    self.detailTextView = [[CustomTextApplyView alloc]initWithFrame:CGRectMake(15, self.cityTextField.frame.origin.y + self.cityTextField.frame.size.height - 1 + 10 ,self.cityTextField.frame.size.width-30,44)];
    self.detailTextView.delegate = self;
    self.detailTextView.textColor = FontTitleColor;
    self.detailTextView.backgroundColor = [UIColor whiteColor];
    self.detailTextView.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.detailTextView];
    
    
    
    //详细地址label
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.detailTextView.frame.origin.y-3, self.detailTextView.frame.size.width+30, 45)];
    self.detailLabel.text = @"详细地址";
    self.detailLabel.textColor = PlaceholderTitleColor;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.detailLabel];
    
    
    
    //详细地址labelline
    self.detailLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.detailTextView.frame.origin.y + self.detailTextView.frame.size.height , self.detailTextView.frame.size.width+30, 1)];
    self.detailLineLabel.backgroundColor = LineColor;
    [self.scrollView addSubview:self.detailLineLabel];
    
    
    
    //座机电话
    self.fixedLineTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(self.detailLineLabel.frame.origin.x, self.detailLineLabel.frame.origin.y+distance + 1, self.detailLineLabel.frame.size.width, self.nameTextField.frame.size.height)];
    self.fixedLineTextField.placeholder = @"座机电话";
    self.fixedLineTextField.delegate = self;
    self.fixedLineTextField.textColor = FontTitleColor;
    self.fixedLineTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.fixedLineTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.fixedLineTextField];
    
    
    
    //身份证号码
    self.idCardTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(self.fixedLineTextField.frame.origin.x, self.fixedLineTextField.frame.origin.y+distance + self.fixedLineTextField.frame.size.height, self.fixedLineTextField.frame.size.width , self.fixedLineTextField.frame.size.height)];
    self.idCardTextField.placeholder = @"输入身份证";
    self.idCardTextField.delegate = self;
    self.idCardTextField.textColor = FontTitleColor;
    self.idCardTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.idCardTextField];
    
    self.labelIdCard =[[UILabel alloc] initWithFrame:CGRectMake(15, self.idCardTextField.frame.origin.y + self.idCardTextField.frame.size.height +distance, SCREEN_WIDTH, 10)];
    self.labelIdCard.font = [UIFont systemFontOfSize:10];
    self.labelIdCard.text = @"上传身份证照片";
    self.labelIdCard.textColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    [self.scrollView addSubview:self.labelIdCard];
    //上传身份证照片按钮
    self.uploadIdCardImageButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadIdCardImageButton.frame = CGRectMake(15, self.labelIdCard.frame.origin.y+self.labelIdCard.frame.size.height +distance , 70, 70);
    [self.scrollView addSubview:self.uploadIdCardImageButton];
    [self.uploadIdCardImageButton  setBackgroundImage:[UIImage imageNamed:@"pickImg"] forState:(UIControlStateNormal)];
    [self.uploadIdCardImageButton addTarget:self action:@selector(didClickUpLoadIdCardImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //上传身份证图片
    self.uploadIdCardImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.uploadIdCardImageButton.frame.origin.x, self.uploadIdCardImageButton.frame.origin.y , 70, 70)];
    //self.uploadIdCardImage.hidden = YES;
    self.uploadIdCardImage.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.uploadIdCardImage];
    self.uploadIdCardImage.tag = 1000;
    
    UIButton *buttonIdDe = [[UIButton alloc] initWithFrame:CGRectMake(60, -10, 20, 20)];
    [buttonIdDe addTarget:self action:@selector(delegateImg:) forControlEvents:UIControlEventTouchUpInside];
    buttonIdDe.tag = 1200;
    buttonIdDe.hidden = YES;
    [buttonIdDe setImage:[UIImage imageNamed:@"deButton"] forState:UIControlStateNormal];
    [self.uploadIdCardImage addSubview:buttonIdDe];
    
    
    //实体店按钮
    self.storeButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.storeButton.frame = CGRectMake(15, self.uploadIdCardImageButton.frame.origin.y + self.uploadIdCardImageButton.frame.size.height + 21 , 20, 20);
    [self.scrollView addSubview:self.storeButton];
    [self.storeButton addTarget:self action:@selector(didClickStoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.storeButton.selected = YES;
    
    
    
    
    //实体店label
    self.storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.storeButton.frame.origin.x + self.storeButton.frame.size.width+distance, self.storeButton.frame.origin.y + 3 , 80, 15)];
    self.storeLabel.text = @"实体店";
    self.storeLabel.textColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    self.storeLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.storeLabel];
    
    
    
    //营业执照号码
    self.businessLicenseTextField = [[CustomTextApplyField alloc]initWithFrame:CGRectMake(0, self.storeButton.frame.origin.y + self.storeButton.frame.size.height + distance+9, self.idCardTextField.frame.size.width, self.idCardTextField.frame.size.height)];
    //self.businessLicenseTextField.hidden = YES;
    self.businessLicenseTextField.placeholder = @"输入营业执照号";
    self.businessLicenseTextField.delegate = self;
    self.businessLicenseTextField.textColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    self.businessLicenseTextField.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.businessLicenseTextField];
    
    //上传营业执照描述
    self.uploadBusinessLicenseLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.businessLicenseTextField.frame.origin.y +self.businessLicenseTextField.frame.size.height + distance , self.fixedLineTextField.frame.size.width, 10)];
    //self.uploadBusinessLicenseLabel.hidden = YES;
    self.uploadBusinessLicenseLabel.text = @"上传营业执照或店铺图片";
    self.uploadBusinessLicenseLabel.textAlignment = NSTextAlignmentLeft;
    self.uploadBusinessLicenseLabel.textColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    self.uploadBusinessLicenseLabel.font = [UIFont systemFontOfSize:10];
    [self.scrollView addSubview:self.uploadBusinessLicenseLabel];
    
    //上传营业执照照片按钮
    self.uploadBusinessLicenseButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadBusinessLicenseButton.frame = CGRectMake(15, self.uploadBusinessLicenseLabel.frame.origin.y+self.uploadBusinessLicenseLabel.frame.size.height+distance , 70, 70);
    [self.scrollView addSubview:self.uploadBusinessLicenseButton];
    [self.uploadBusinessLicenseButton  setBackgroundImage:[UIImage imageNamed:@"pickImg"] forState:(UIControlStateNormal)];
    
    [self.uploadBusinessLicenseButton addTarget:self action:@selector(didClickUpLoadBusinessLicenseImageAction) forControlEvents:UIControlEventTouchUpInside];
    //self.uploadBusinessLicenseButton.hidden = YES;
    
    
    
    //上传营业执照照片
    self.uploadBusinessLicenseImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.uploadBusinessLicenseLabel.frame.origin.y+self.uploadBusinessLicenseLabel.frame.size.height+distance, 70, 70)];
    self.uploadBusinessLicenseImage.userInteractionEnabled = NO;
   // self.uploadBusinessLicenseImage.hidden = YES;
    [self.scrollView addSubview:self.uploadBusinessLicenseImage];
    self.uploadBusinessLicenseImage.tag = 2000;

    
    UIButton *buttonBusinessDe = [[UIButton alloc] initWithFrame:CGRectMake(60, -10, 20, 20)];
    [buttonBusinessDe addTarget:self action:@selector(delegateImg:) forControlEvents:UIControlEventTouchUpInside];
    buttonBusinessDe.tag = 1201;
    buttonBusinessDe.hidden = YES;
    [buttonBusinessDe setImage:[UIImage imageNamed:@"deButton"] forState:UIControlStateNormal];
    [self.uploadBusinessLicenseImage addSubview:buttonBusinessDe];
    
    //网络营销button
    self.netWorkButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.netWorkButton.frame = CGRectMake(self.storeLabel.frame.origin.x+self.storeLabel.frame.size.width , self.storeButton.frame.origin.y , 20, 20);
    
    [self.scrollView addSubview: self.netWorkButton];
    [self.netWorkButton addTarget:self action:@selector(didClickStoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.netWorkButton addTarget:self action:@selector(didClickNetWorkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.netWorkButton.backgroundColor = [UIColor redColor];
    
    
    
    
    
    //网络营销label
    self.netWorkLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.netWorkButton.frame.origin.x + self.netWorkButton.frame.size.width +distance, self.netWorkButton.frame.origin.y + 3 , 80, 15)];
    self.netWorkLabel.text = @"网络分销";
    self.netWorkLabel.textColor = [UIColor colorWithHexValue:0x333333 alpha:1];;
    self.netWorkLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.netWorkLabel];
    
    
//    //设置tableview
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.netWorkButton.frame.origin.x + 10, self.netWorkButton.frame.origin.y + 30, self.view.frame.size.width - 96, 41 * self.labelDicArr.count + 41*2) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.scrollEnabled = NO;
//    _tableView.hidden = YES;
//    _tableView.backgroundColor = [UIColor clearColor];
//    //不要分割线
//    [self.scrollView addSubview:_tableView];
    
    
    self.thirdPartiesaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.thirdPartiesaButton.frame = CGRectMake(15,self.storeButton.frame.origin.y + self.storeButton.frame.size.height + distance,123 ,30);
    self.thirdPartiesaButton.tag = 100;
    [self.thirdPartiesaButton addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    self.thirdPartiesaButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.thirdPartiesaButton.layer.borderWidth = 0.5f;
    self.thirdPartiesaButton.hidden = YES;
    //        [self.thirdPartiesaButton setBackgroundImage:[UIImage imageNamed: @"down"] forState:(UIControlStateNormal)];
//    [self.thirdPartiesaButton setImage:[UIImage imageNamed: @"down"] forState:UIControlStateNormal];
    
    UIImageView *imgDown = [[UIImageView alloc] initWithFrame:CGRectMake(self.thirdPartiesaButton.frame.size.width-15-9, 12.5, 9, 5)];
    imgDown.image = [UIImage imageNamed:@"arrowDown"];
    [self.thirdPartiesaButton addSubview:imgDown];
    
    [self.scrollView addSubview:self.thirdPartiesaButton];
    
    self.thirdPartiesaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 7, 90, 15)];
    self.thirdPartiesaTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.thirdPartiesaTitleLabel.font = [UIFont systemFontOfSize:14];
    self.thirdPartiesaTitleLabel.textColor = FontTitleColor;
    self.thirdPartiesaTitleLabel.text = @"请选择";
    [self.thirdPartiesaButton addSubview:self.thirdPartiesaTitleLabel];
    
    self.onlineStoreText = [[CustomTextShopView alloc]initWithFrame:CGRectMake(self.thirdPartiesaButton.frame.origin.x+self.thirdPartiesaButton.frame.size.width + 21, self.thirdPartiesaButton.frame.origin.y, SCREEN_WIDTH - 15-21 -self.thirdPartiesaButton.frame.origin.x -self.thirdPartiesaButton.frame.size.width, 30)];
    [self.scrollView addSubview:self.onlineStoreText];
    self.onlineStoreText.delegate = self;
    self.onlineStoreText.textColor = FontTitleColor;
    self.onlineStoreText.font = [UIFont systemFontOfSize:14];
    
        //输入框内描述店铺内容
    self.inputBoxDescribeTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, self.uploadBusinessLicenseImage.frame.origin.y + self.uploadBusinessLicenseImage.frame.size.height + 21, SCREEN_WIDTH - 30, 100)];
    self.inputBoxDescribeTextView.delegate = self;
    self.inputBoxDescribeTextView.layer.borderWidth = 1;
    self.inputBoxDescribeTextView.backgroundColor = [UIColor clearColor];
    self.inputBoxDescribeTextView.layer.borderColor = LineColor.CGColor;
    self.inputBoxDescribeTextView.textColor = FontTitleColor;
    [self.scrollView addSubview:self.inputBoxDescribeTextView];
    
    
    
    [self.storeButton setImage:[UIImage imageNamed:@"topup_unsel"] forState:(UIControlStateNormal)];
    [self.storeButton setImage:[UIImage imageNamed:@"topup_sel"] forState:(UIControlStateSelected)];
    [self.netWorkButton setImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
    [self.netWorkButton setImage:[UIImage imageNamed:@"topup_sel"] forState:UIControlStateSelected];
    
    
    //设置描述框中内容label显示
    self.inputBoxDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.inputBoxDescribeTextView.frame.origin.x+5, self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width, 80)];
    self.inputBoxDescribeLabel.backgroundColor = [UIColor clearColor];
    self.inputBoxDescribeLabel.alpha = 0.7;
    [self.scrollView addSubview:self.inputBoxDescribeLabel];
    self.inputBoxDescribeLabel.textColor = PlaceholderTitleColor;
   NSString *strInfo = @"简要介绍自己店铺的营业状况，如店铺数量、营业面积、营业额等。更加完整的资料将有利于审核的顺利通过";
    self.inputBoxDescribeLabel.numberOfLines = 0;
    self.inputBoxDescribeLabel.font = [UIFont systemFontOfSize:13];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strInfo];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strInfo length])];
    self.inputBoxDescribeLabel.attributedText = attributedString;
    
    [self createTable];
    
}


#pragma mark ===============设置男女按钮=================
-(void)setManButtonAciotn
{
    
    applyInfoDTO.sex = @"1";
    self.manButton.selected = YES;
    self.manButton.backgroundColor = [UIColor blackColor];;
    self.womanButton.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    

    
}
-(void)setWonmanButtonAction
{
    
   
    [self.womanButton.layer setBorderColor:LGButtonColor.CGColor];
    [self.manButton.layer setBorderColor:LGButtonColor.CGColor];
    
    applyInfoDTO.sex = @"2";
    self.womanButton.selected = YES;
    
    self.womanButton.backgroundColor = [UIColor blackColor];
    self.manButton.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    

    
    
}

-(void)delegateImg:(UIButton *)btn{
    btn.hidden = YES;
    if (btn.tag == 1200) {
         self.uploadIdCardImage.userInteractionEnabled = NO;
        self.uploadIdCardImage.hidden = YES;
        self.uploadIdCardImageButton.hidden = NO;
        self.idCardImageURL = @"";
        dataIdCard = nil;
    }else{
         self.uploadBusinessLicenseImage.userInteractionEnabled = YES;
        self.uploadBusinessLicenseImage.hidden = YES;
        self.uploadBusinessLicenseButton.hidden = NO;
        self.businessLicenseImageURL = @"";
        dataStore = nil;
    }
}

/**
 *  设置scrollview的大小
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 900);
    
}

#pragma mark ==================添加手势=============
-(void)addIdCardImageGesture
{
    
    [_enlargeImage showImage:self.uploadIdCardImage tag:self.uploadIdCardImage.tag];
    
}

-(void)addBusinessLicenseImageGesture
{
    [_enlargeImage showImage:self.uploadBusinessLicenseImage tag:self.uploadBusinessLicenseImage.tag];
}

#pragma mark ==================上传图片按钮，显示图片=============
-(void)didClickUpLoadIdCardImageAction
{
    isIdcardImg = YES;
    [self allTextKeyboardRecycling];
    
    self.uploadIdCardImageButton.selected = YES;
    [self showPhotoWithCameratTag];
}

-(void)didClickUpLoadBusinessLicenseImageAction
{
    isIdcardImg = NO;
    self.uploadBusinessLicenseButton.selected = YES;
    [self showPhotoWithCameratTag];
}

#pragma mark ==================点击按钮触发UI事件=============
//!实体店按钮
-(void)didClickStoreButtonAction
{
    
    applyInfoDTO.shopType = @"0";
    
    [MyUserDefault removeCodeStorename];
    self.thirdPartiesaTitleLabel.text = @"请选择";
    self.onlineStoreText.placeholder = @"输入网店名称";
    self.onlineStoreText.text = @"";
    
    
    //    [self.storeButton setImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:UIControlStateNormal];
    
    self.storeButton.selected =! self.storeButton.selected;
    
    self.netWorkButton.selected = YES;
    //    [self.netWorkButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];
    
    self.businessLicenseTextField.hidden = NO;
    self.uploadBusinessLicenseLabel.hidden = NO;
    self.uploadBusinessLicenseButton.hidden = NO;
    _tableView.hidden = YES;
    self.thirdPartiesaButton.hidden = YES;
    self.onlineStoreText.hidden = YES;
    self.storeButton.selected = YES;
    self.netWorkButton.selected = NO;
    
    //!点击实体店的时候，网络分销 的平台展开为no  网络平台不展开
    isShow = NO;
    
    
    
    [UIView animateWithDuration:time animations:^{

        //设置tableview
        _tableView.frame =CGRectMake(self.netWorkButton.frame.origin.x + 10, self.netWorkButton.frame.origin.y + 30, self.view.frame.size.width - 96, 41 * self.labelDicArr.count + 41*2);
        
        self.inputBoxDescribeTextView.frame = CGRectMake(15, self.uploadBusinessLicenseImage.frame.origin.y + self.uploadBusinessLicenseImage.frame.size.height + 21, SCREEN_WIDTH - 30, 100);
        
        self.inputBoxDescribeLabel.frame = CGRectMake(25 , self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width-10, 60);
    }];
}

-(void)didClickNetWorkButtonAction
{
    
    applyInfoDTO.shopType = @"1";
    dataStore = nil;
    self.businessLicenseTextField.text = nil;
    self.netWorkButton.selected =! self.netWorkButton.selected;
    
    self.businessLicenseImageURL = @"";
    //    [self.netWorkButton setImage:[UIImage imageNamed:@"02_注册_选中(反白)"] forState:UIControlStateNormal];
    //    [self.storeButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:UIControlStateNormal];
    
    
    self.businessLicenseTextField.hidden = YES;
    self.uploadBusinessLicenseLabel.hidden = YES;
    self.uploadBusinessLicenseButton.hidden = YES;
    self.uploadBusinessLicenseImage.hidden = YES;
    self.storeButton.selected = NO;
    _tableView.hidden = NO;
    self.thirdPartiesaButton.hidden = NO;
    self.onlineStoreText.hidden = NO;
    self.netWorkButton.selected = YES;
    
    [UIView animateWithDuration:time animations:^{
        
      
        //设置tableview
//        _tableView.frame =CGRectMake(15, self.netWorkButton.frame.origin.y + 30, 123, 41 * self.labelDicArr.count + 41*2);
        
        
        
        self.inputBoxDescribeTextView.frame = CGRectMake(15, self.thirdPartiesaButton.frame.origin.y + self.thirdPartiesaButton.frame.size.height +distance , SCREEN_WIDTH-30, 100);
        self.inputBoxDescribeLabel.frame = CGRectMake(25, self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width-10, 50);
        
    }];
    
//    if (self.thirdPartiesaButton.selected == YES) {
//        
//        self.inputBoxDescribeTextView.frame = CGRectMake(15, self.thirdPartiesaButton.frame.origin.y + self.thirdPartiesaButton.frame.size.height + 127 + self.labelDicArr.count *41 - 41 , SCREEN_WIDTH-30.frame.size.width, 100);
//        self.inputBoxDescribeLabel.frame = CGRectMake(15, self.inputBoxDescribeTextView.frame.origin.y + 5 , self.inputBoxDescribeTextView.frame.size.width, 50);
//    }
}


//省市区地址根据ID进行拼接
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker {
   
  
    
    if (![picker.locate.state isEqualToString:@""]) {
         self.location = picker.locate;
       self.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        cityNameStr = _location.city;
    }else
    {
        self.cityTextField.text = @"";
        cityNameStr = @"";
    }
    
    
}

#pragma mark ==================TextField 和 TextViewdelegate=============


//监测所得到的textfield中副本所输入的个数
-(BOOL)onlineStoreTextChange{
    
    
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
#pragma mark ------------TextField--------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //传递地址
    if (textField == self.cityTextField) {
        //加载数据（获取沙盒存储路径）
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
        NSMutableArray *provincesArray = [NSMutableArray arrayWithContentsOfFile:titlePath];
        if (provincesArray.count) {
            self.locatePicker = [[HZAreaPickerView alloc] init];
            self.locatePicker.delegate = self;
            textField.inputView = self.locatePicker;
            self.location = self.locatePicker.locate;
            if (self.cityTextField.text.length ==0) {
                [self postionBtnAction];
            }
        }else{
            [self postionBtnAction];
            return NO;
        }
       
        
        //self.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];
        
    }
    if (textField == self.phoneNumTextField)
    {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal);
        }];
        
    }
    if (textField == self.cityTextField)
    {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal * 2);
        }];
    }
    
    if (textField == self.fixedLineTextField)
    {
        
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal *4);
        }];
    }
    
    if (textField == self.idCardTextField)
    {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal *5);
        }];
        
    }
    if (textField == self.onlineStoreText) {
        
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal *7);
        }];
    }
    if (textField ==  self.businessLicenseTextField) {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal *9);
        }];
        
    }
    if (self.thirdPartiesaButton.selected == YES) {
        if (textField == self.onlineStoreText) {
            
            [UIView  animateWithDuration:time animations:^{
                self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal *10);
            }];
        }
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.onlineStoreText) {
        
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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


#pragma mark ------------TextView--------------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (self.detailTextView == textView) {
        self.detailLabel.textColor = PlaceholderTitleColor;
        self.detailLineLabel.backgroundColor = LineColor;
        self.detailTextView.textColor = FontTitleColor;
        self.detailLabel.hidden = YES;
        
    }
    if ( self.inputBoxDescribeTextView == textView) {
        self.inputBoxDescribeLabel.textColor = FontTitleColor;
        self.inputBoxDescribeTextView.textColor = FontTitleColor;
    }
    
    if (textView ==  self.inputBoxDescribeTextView ) {
        
        self.inputBoxDescribeLabel.hidden = YES;
    }else{
        self.addressTableView.hidden = NO;
        
    }
    
    
    if (textView == self.inputBoxDescribeTextView)
    {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, self.inputBoxDescribeTextView.frame.origin.y-20);
        }];
    }else{
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, self.detailTextView.frame.origin.y-distance);
        }];
        
    }
    
    if (self.thirdPartiesaButton.selected == YES)
    {
        
        if (textView == self.inputBoxDescribeTextView)
        {
            [UIView  animateWithDuration:time animations:^{
                self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * decimal * 13);
            }];
            
        }
    }
    
    
    
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //    if (self.detailTextView == textView) {
    //        if (self.detailTextView.text.length < 1) {
    //            self.detailLabel.hidden = NO;
    //        }
    //        if (self.detailTextView.text.length > 0) {
    //            self.detailLabel.hidden = YES;
    //        }
    //
    //    }
    
    //    if (self.inputBoxDescribeTextView == textView) {
    //        if (self.inputBoxDescribeTextView.text.length < 1) {
    //            self.inputBoxDescribeLabel.hidden = NO;
    //        }
    //        if (self.inputBoxDescribeTextView.text.length >0) {
    //            self.inputBoxDescribeLabel.hidden = YES;
    //        }
    //    }
    
    
    return YES;
}




-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.detailTextView == textView) {
        
        if (self.detailTextView.text.length < 1) {
            self.detailLabel.hidden = NO;
        }
        
        self.detailTextView.textColor = FontTitleColor;
        self.detailLineLabel.backgroundColor = LineColor;
        self.detailLabel.textColor = PlaceholderTitleColor;
    }
    
    if (self.inputBoxDescribeTextView == textView) {
        self.inputBoxDescribeTextView.textColor = FontTitleColor;
        self.inputBoxDescribeLabel.textColor = PlaceholderTitleColor;
        
    }
    if (textView.text.length < 1) {
        self.inputBoxDescribeLabel.hidden = NO;
    }
    
}



-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.detailTextView) {
        self.addressTableView.hidden = NO;
        [self citySearch];
        [UIView animateWithDuration:0.5 animations:^{
            
            CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
            CGRect frame = textView.frame;
            frame.size.height = size.height;
            textView.frame = frame;
            
            self.distanceLeght = frame.size.height;
            
            
//            self.detailLineLabel.frame = CGRectMake(0 , self.detailTextView.frame.origin.y + frame.size.height+20, self.detailTextView.frame.size.width+30, 1);
//            
//            //座机电话
//            self.fixedLineTextField.frame = CGRectMake(self.detailLineLabel.frame.origin.x, self.detailLineLabel.frame.origin.y+self.detailLineLabel.frame.size.height+ distance, self.detailLineLabel.frame.size.width, self.nameTextField.frame.size.height);
//            
//            self.idCardTextField.frame = CGRectMake(self.fixedLineTextField.frame.origin.x, self.fixedLineTextField.frame.origin.y+distance+ self.fixedLineTextField.frame.size.height, self.view.frame.size.width , self.fixedLineTextField.frame.size.height);
            
            
        }];
    }
}

-(void)hideKeyboard
{
//    NSLog(@"str===%@",[NSStringFromClass([touch.view class]));
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
//        //做自己想做的事
//        return NO;
//    }
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        CGRect rect = _pickerThird.frame;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerThird.frame =rect;
        
    }completion:^(BOOL finished) {
        _pickerThird.hidden = YES;
    }];
    self.addressTableView.hidden = YES;
    [UIView animateWithDuration:time animations:^{
        self.tapView.center = CGPointMake(self.tapView
                                          .center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
    }];
    //整个页面从心返回原来的位置
    [UIView  animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"str===%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }else if([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]){
        if (touch.view.tag ==1000) {
            [self addIdCardImageGesture];
            return NO;
        }else if (touch.view.tag ==2000){
            [self addBusinessLicenseImageGesture];
            return NO;
        }
    }
    
    return YES;
}
                      
                      
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//
//    [UIView animateWithDuration:time animations:^{
//        self.tapView.center = CGPointMake(self.tapView
//                                          .center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
//    }];
//    //整个页面从心返回原来的位置
//    [UIView  animateWithDuration:time animations:^{
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//    }];
//}



#pragma mark==================================照相机和相册动画UI-----
/**
 *  照片和照相按钮显示
 */
-(void)showPhotoWithCameratTag
{
    [self.tapView removeFromSuperview];
    
    
    self.tapView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, 106)];
    
    self.tapView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:time animations:^{
        self.tapView.center = CGPointMake(self.tapView
                                          .center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType]; //CVV
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转化成NSDAta
        UIImage *image1 = [info objectForKey:@"UIImagePickerControllerEditedImage"]; //编辑后的图
        
        //设置image的尺寸
        CGSize imagesize = image1.size;
        
        if (imagesize.width  < 500) {
            
            [self imageWithImageScaled:image1 scaledToSize:imagesize];
            
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
        if (isIdcardImg) {
            dataIdCard = data;
            self.uploadIdCardImage.image = [UIImage imageWithData:data];
            UIButton *btn = [self.view viewWithTag:1200];
            btn.hidden = NO;
            
            self.uploadIdCardImage.userInteractionEnabled = YES;
            self.uploadIdCardImage.hidden = NO;
            self.uploadIdCardImageButton.hidden = YES;
            self.uploadIdCardImageButton.selected = NO;
        }else {
            dataStore = data;
            self.uploadBusinessLicenseImage.image = [UIImage imageWithData:data];
            UIButton *btn = [self.view viewWithTag:1201];
            btn.hidden = NO;
            self.uploadBusinessLicenseImage.userInteractionEnabled = YES;
            self.uploadBusinessLicenseImage.hidden = NO;
            self.uploadBusinessLicenseButton.selected = NO;
            self.uploadBusinessLicenseButton.hidden = YES;

        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    
    
    [UIView animateWithDuration:time animations:^{
        self.tapView.center = CGPointMake(self.tapView
                                          .center.x, self.view.frame.size.height + self.tapView.frame.size.height/2);
    }];
    
    
    
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGFloat width = newSize.width * 0.67;
    CGFloat height = newSize.height * 0.67;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImageScaled:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGFloat width = newSize.width ;
    CGFloat height = newSize.height ;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}




- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        
    }
}

#pragma mark - 地址详细
-(void)createTable{
    self.addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.detailTextView.frame.origin.y +  self.detailTextView.frame.size.height +3, self.scrollView.frame.size.width,self.scrollView.frame.size.height -(self.detailTextView.frame.origin.y +  self.detailTextView.frame.size.height +3) ) style:(UITableViewStyleGrouped)];
    self.addressTableView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    self.addressTableView.hidden = YES;
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.addressTableView];
}

-(void)postionBtnAction
{
    //进行取消
    [self.view endEditing:YES];
    if([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locMgr requestAlwaysAuthorization]; // 永久授权
        [self.locMgr requestWhenInUseAuthorization]; //使用中授权
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"ewrew0");
            [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"ewrew1");
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"ewrew3");
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            //开始定位用户的位置
            [self.locMgr startUpdatingLocation];
        }
            break;
            
            
            
        default:
            break;
    }
    
}

//百度地图  数据 delegate  datasource
- (CLLocationManager *)locMgr
{
#warning 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
        
    }
    return _locMgr;
}
-(void)citySearch{
    //城市检索
    BMKSuggestionSearchOption *citySearchOption = [[BMKSuggestionSearchOption alloc]init];
    
    citySearchOption.cityname = cityNameStr;
    
    citySearchOption.keyword = self.detailTextView.text;
    
    
    BOOL flag = [_poisearch suggestionSearch:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

//获取百度地图数据数组
-(NSMutableArray *)detailAddressStr
{
    if (_detailAddressStr == nil) {
        _detailAddressStr = [NSMutableArray arrayWithCapacity:0];
    }
    return  _detailAddressStr;
}







#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //CLLocation中存放的是一些经纬度, 速度等信息. 要获取地理位置需要转换做地理位置编码.
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    NSLog(@"CLLocation----%@",loc);
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"didUpdateLocations------%f %f", coordinate.latitude, coordinate.longitude);
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){coordinate.latitude,coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
    
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district];
        
        
        cityNameStr = result.addressDetail.city;
        
        self.cityTextField.text = showmeg;
        
        [self locationValue:result];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate

- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    self.detailAddressStr = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSLog(@"keyList  ===  %@",result.keyList);
        
        //在此处理正常结果
        for (NSString *infoStr in result.keyList) {
            
            //添加model对象
            [self.detailAddressStr addObject:infoStr];
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
    [self.addressTableView reloadData];
    
    NSLog(@"_detailAddressStr  ===   %@",self.detailAddressStr);
}


-(void)locationValue:(BMKReverseGeoCodeResult *)result{
    //
    NSString *provinceID,*cityID,*areaID;
    
    if (![provinces isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary * provinceDic in provinces) {
        
        if ([result.addressDetail.province containsString:provinceDic[@"stateName"]]) {
            
            provinceID = provinceDic[@"stateId"];
            
            for (NSDictionary *cityDic in provinceDic[@"cities"]) {
                
                if ([result.addressDetail.city containsString:cityDic[@"cityName"]])
                {
                    
                    cityID = cityDic[@"cityId"];
                    
                    for (NSDictionary *areaDic in cityDic[@"areas"]) {
                        
                        if ([result.addressDetail.district containsString:areaDic[@"areaName"]]) {
                            
                            areaID = areaDic[@"areaId"];
                            
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"%@,%@,%@",provinceID,cityID,areaID);
    self.location.stateId = [NSNumber numberWithInteger:[provinceID integerValue]];
    self.location.cityId = [NSNumber numberWithInteger:[cityID integerValue]];
    self.location.districtId = [NSNumber numberWithInteger:[areaID integerValue]];
    
    
    
}


@end
