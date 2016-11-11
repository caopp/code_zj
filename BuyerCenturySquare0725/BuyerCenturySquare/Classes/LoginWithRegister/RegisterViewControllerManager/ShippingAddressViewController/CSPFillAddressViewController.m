//
//  CSPSignUpAddressViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPFillAddressViewController.h"
#import "CustomTextField.h"
#import "CSPUtils.h"
#import "ConsigneeAddressDTO.h"
#import "HZAreaPickerView.h"
#import "CustomBarButtonItem.h"
#import "EnlargeImageModel.h"

#import "CSPCheckInvitationViewController.h"
#import "CSPFillApplicationViewController.h"
#import "CustomTextView.h"
#import "CSPWaitCertifyViewController.h"
#import "LoginDTO.h"
//采用百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


//采用百度地图定位
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "ZJ_ManagerAddressCell.h"
#define MAX_INPUT_LENGTH 60
@interface CSPFillAddressViewController () <HZAreaPickerDelegate, UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,BMKMapViewDelegate, BMKSuggestionSearchDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate>
{
    //UIView *view;
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
   }
@property (strong, nonatomic) IBOutlet UILabel *detailAderessLabel;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic,strong)NSMutableArray *detailAddressStr;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet CustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *cityTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *postalCode;

@property (strong, nonatomic) IBOutlet CustomTextView *textView;

@property(strong,nonatomic)UITextField *detailAddressTextField;

//设置线条
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong,nonatomic)UILabel *textViewLabelLine;
@property(strong,nonatomic)UIButton *deleteBtn;

//设置输入框显示的内容Label
@property (strong,nonatomic)UILabel *inputContentLabel;

//PopUpView
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic,strong) HZAreaPickerView* locatePicker;

@property (nonatomic,strong) HZLocation* location;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation CSPFillAddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    //定位
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poisearch.delegate = self;
    [super viewWillAppear:animated];
  
    
    [self.textView setTextColor:LGNOClickColor];
    self.lineLabel.backgroundColor = PlaceholderColor;
//    self.lineLabel.alpha = 0.7;
    
    
    [self.detailAderessLabel setTextColor:PlaceholderColor];

    
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    tapGr.delegate = self;
    [self.baseScrollView addGestureRecognizer:tapGr];
    
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"str===%@",NSStringFromClass([touch.view class]) );
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
    [super viewWillDisappear:animated];
}
-(void)hideKeyboard:(UIGestureRecognizer *)tap{
  
        [self.view endEditing:YES];
        self.tableView.hidden = YES;
        self.saveButton.hidden = NO;
    
}


//设置UI
-(void)makeUI
{
    //设置textview
    self.textView  = [[CustomTextView alloc]initWithFrame:CGRectMake(48, 123 + 10 , self.view.frame.size.width - 96 , 30)];
    self.textView.delegate = self;
    self.textView.textColor = LGNOClickColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.font = [UIFont systemFontOfSize:13];
    [self.baseScrollView addSubview:self.textView];
    
    
    
    //输入显示代替字符
    self.inputContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, self.textView.frame.origin.y+ 8, 60, 13)];
    self.inputContentLabel.textColor = LGNOClickColor;
    self.inputContentLabel.font = [UIFont systemFontOfSize:13];
    [self.baseScrollView addSubview:self.inputContentLabel];
    self.inputContentLabel.text = @"详细地址";
    
    
    
    //设置textView下面的线条
    self.textViewLabelLine = [[UILabel  alloc]initWithFrame:CGRectMake(self.inputContentLabel.frame.origin.x , self.textView.frame.origin.y +  self.textView.frame.size.height , self.textView.frame.size.width, 1)];
    
    self.textViewLabelLine.backgroundColor = PlaceholderColor;
//    self.textViewLabelLine.alpha = 0.7;
    [self.baseScrollView addSubview:self.textViewLabelLine];

    self.deleteBtn  = [[UIButton alloc] initWithFrame:CGRectMake(self.textView.frame.size.width-13, self.textView.frame.size.height-20, 13, 13)];
     [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"01_登录_删除"] forState:UIControlStateNormal];
    self.deleteBtn.hidden = YES;
    [self.deleteBtn addTarget:self action:@selector(deleteTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.textView addSubview:self.deleteBtn];
    
    //设置button按钮
    self.saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveButton.frame = CGRectMake(self.textViewLabelLine.frame.origin.x, self.textViewLabelLine.frame.origin.y + self.textViewLabelLine.frame.size.height + 23, self.textViewLabelLine.frame.size.width, 43);
    [self.baseScrollView  addSubview:self.saveButton];
    
    [self.saveButton setTitle:_isRigst?@"提交":@"保存" forState:(UIControlStateNormal)];
    [self.saveButton setTitleColor:LGClickColor forState:(UIControlStateNormal)];
    
    self.saveButton.font = [UIFont systemFontOfSize:15];
    self.saveButton.layer.borderColor = LGButtonColor.CGColor;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.cornerRadius = 3;
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.textViewLabelLine.frame.origin.x-15, self.textView.frame.origin.y +  self.textView.frame.size.height +3, self.baseScrollView.frame.size.width-25,self.baseScrollView.frame.size.height -(self.textView.frame.origin.y +  self.textView.frame.size.height +3)-60 ) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.tableView];
    
    
    
}









- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"填写收货地址";
    
    //[self.navigationItem setHidesBackButton:YES];

    self.cityTextField.delegate = self;

    
    self.textView.delegate = self;

    self.lineLabel.hidden = YES;
    
    
    [self addCustombackButtonItem];
    LoginDTO *loginDto = [LoginDTO sharedInstance];
    _phoneNumTextField.text = loginDto.memberAccount;
    
    
    //采用百度地图
    _poisearch = [[BMKSuggestionSearch alloc]init];
    //百度地图定位
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data.plist" ofType:nil]];
    //设置UI
    [self makeUI];
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    self.textView.textColor = LGClickColor;
//    self.lineLabel.backgroundColor = LGClickColor;
//    self.detailAderessLabel.textColor = LGClickColor;
//    
//    return  YES;
//}
//-(BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    self.textView.textColor = LGNOClickColor;
//    self.lineLabel.backgroundColor = LGNOClickColor;
//    self.detailAderessLabel.textColor = LGNOClickColor;
//    
//    return YES;
//}




//-(void)addCustombackButtonItem{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * NextStep
 */
- (IBAction)nextStepButtonClicked:(id)sender {
//    [self showSaveSuccessdTipView:NO];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



/**
 * Save button on base scroll view clicked
 */
- (void)saveButtonClicked{
    

    //1、创建
    [[GUAAlertView alertViewWithTitle:@"温馨提示" withTitleClor:nil message:@"是否保存收货地址" withMessageColor:nil oKButtonTitle:@"保存" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        if (self.saveButton!=nil) {
           
                [self prepareForCommitConsigneeAddress];
                
                self.saveButton.selected = NO;
            
            
        }
        
    } dismissAction:^{
        
        //进入修改登录密码页面
        NSLog(@"左边按钮（第二个按钮）的事件");
        
        
    }]show];
    

    
    
   
    
    
}

- (BOOL)verifyUserName {
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


- (BOOL)verifyPhoneNumber {
    if (self.phoneNumTextField.text.length  == 0) {
        [self.view makeToast:@"手机号码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if (![CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}


- (BOOL)verifyCityName {
    if (self.location == nil) {
        [self.view makeToast:@"省市区不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

- (BOOL)verifyDetailAddress {
    if (![CSPUtils checkDetailAddressLength:self.textView.text]) {
        [self.view makeToast:@"详细地址需在5-60字之间" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}
- (IBAction)showLocation:(id)sender {
    [self postionBtnAction];
}

- (void)prepareForCommitConsigneeAddress {
    

    //进行页面跳转
//    CSPCheckInvitationViewController *checkInvitationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPCheckInvitationViewController"];
//    
//    [self.navigationController pushViewController:checkInvitationVC animated:YES];
    
    if (![self verifyUserName]) {
        return;
    }

    if (![self verifyPhoneNumber]) {
        return;
    }

    if (![self verifyCityName]) {
        return;
    }
    if (![self verifyDetailAddress]) {
        return;
    }

    ConsigneeAddressDTO* consigneeAddressDTO = [[ConsigneeAddressDTO alloc]init];
    consigneeAddressDTO.consigneeName = self.nameTextField.text;
    consigneeAddressDTO.consigneePhone = self.phoneNumTextField.text;
    
    consigneeAddressDTO.provinceNo = self.location.stateId;
    consigneeAddressDTO.cityNo = self.location.cityId;
    consigneeAddressDTO.countyNo = self.location.districtId;
    
    consigneeAddressDTO.detailAddress = self.textView.text;
    
    consigneeAddressDTO.defaultFlag = @"0";
    
    consigneeAddressDTO.tokenId = [MyUserDefault defaultLoadAppSetting_token];
    
    consigneeAddressDTO.merberNo = [MyUserDefault defaultLoadAppSetting_merchantNo];
     consigneeAddressDTO.joinType = [self retunJoinType];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpManager sendHttpRequestForAddConsignee:consigneeAddressDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            /**
             *  用户注册成功后，进行信息保存
             */
            //保存名字
            [MyUserDefault defaultSaveAppSetting_name:consigneeAddressDTO.consigneeName];
            
            //保存电话号码
            [MyUserDefault  defaultSaveAppSetting_phone:consigneeAddressDTO.consigneePhone];
            
            [MyUserDefault defaultSaveAppSetting_areaDetail:self.cityTextField.text];

            //省id
            [MyUserDefault defaultSaveAppSetting_stateId:consigneeAddressDTO.provinceNo];
            
            //市id
            [MyUserDefault defaultSaveAppSetting_cityId:consigneeAddressDTO.cityNo];
            
            //区ID
            [MyUserDefault defaultSaveAppSetting_districtId:consigneeAddressDTO.countyNo];
            
            //详细地址
            [MyUserDefault defaultSaveAppSetting_area:consigneeAddressDTO.detailAddress];
            
            
//            //进行页面跳转
//            CSPCheckInvitationViewController *checkInvitationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPCheckInvitationViewController"];
//            
//            [self.navigationController pushViewController:checkInvitationVC animated:YES];
            
            
            if (_isRigst) {
                CSPWaitCertifyViewController *waitCertifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPWaitCertifyViewController"];
                [self.navigationController pushViewController:waitCertifyVC animated:YES];
            }else{
                //添加测试
                CSPFillApplicationViewController *fillApplicationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillApplicationViewController"];
                
                
                [self.navigationController pushViewController:fillApplicationVC animated:YES];
            }
            
        
            //提交的时候所有键盘进行隐藏
            [self.cityTextField resignFirstResponder];
            [self.nameTextField resignFirstResponder];
            [self.phoneNumTextField resignFirstResponder];
            [self.detailAddressTextField resignFirstResponder];
            
            self.saveButton.hidden = NO;
            
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"保存收货地址失败" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark -----TextView delegate-----

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length) {
        self.inputContentLabel.hidden = YES;
    }else{
        self.inputContentLabel.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        CGRect frame = textView.frame;
        frame.size.height = size.height;
        textView.frame = frame;
        
        self.textViewLabelLine.frame = CGRectMake(self.inputContentLabel.frame.origin.x , self.textView.frame.origin.y +  self.textView.frame.size.height - 5, self.textView.frame.size.width, 1);
        
        self.saveButton.frame = CGRectMake(self.textViewLabelLine.frame.origin.x, self.textView.frame.origin.y +  self.textView.frame.size.height + 23, self.textViewLabelLine.frame.size.width, 43);
        self.deleteBtn.frame = CGRectMake(self.textView.frame.size.width-13,  self.textView.frame.size.height-20, 13, 13);
        
    }];
    [self citySearch];
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]&&textView.text.length ==range.length) {
        self.inputContentLabel.hidden = NO;
    }else{
        self.inputContentLabel.hidden = YES;
    }
    
    if (![text isEqualToString:@"/n"]) {
        self.detailAderessLabel.hidden = YES;
    }
    
    //    if (textView.text.length < 17) {
    //        [UIView animateWithDuration:0.3 animations:^{
    //            self.saveButton.frame = CGRectMake(self.saveButton.frame.origin.x, 250, self.saveButton.frame.size.width, self.saveButton.frame.size.height);
    //
    //
    //            self.lineLabel.frame = CGRectMake(self.lineLabel.frame.origin.x, 237 , self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    //
    //        }];
    //    }
    
    //    if (textView.text.length > 17 &&  textView.text.length < 60) {
    //            [UIView animateWithDuration:0.3 animations:^{
    //
    //            self.saveButton.frame = CGRectMake(self.saveButton.frame.origin.x, 300, self.saveButton.frame.size.width, self.saveButton.frame.size.height);
    //
    //                self.lineLabel.frame = CGRectMake(self.lineLabel.frame.origin.x, 237 + 50, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    //
    //        } completion:^(BOOL finished) {
    //
    //        }];
    //     }
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH) {
            [self.view makeToast:@"详细地址需在5-60字之间" duration:2.0f position:@"center"];
            return NO;
        }
        else {
            return YES;
        }
    }
    
    
    
    
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
       // self.inputContentLabel.hidden = YES;
    self.textView.textColor = LGClickColor;
    self.textViewLabelLine.backgroundColor = LGClickColor;
    //self.inputContentLabel.textColor = LGClickColor;

    self.baseScrollView.contentOffset = CGPointMake(0, 130);
    self.tableView.hidden = NO;
    self.saveButton.hidden = YES;
    self.deleteBtn.hidden = NO;

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    
    self.baseScrollView.contentOffset = CGPointMake(0, 0);
    if (textView.text.length > 0) {
        //self.inputContentLabel.hidden = YES;
    }else
    {
    
        //self.inputContentLabel.hidden = NO;
        self.inputContentLabel.textColor = LGNOClickColor;

    }
    self.textViewLabelLine.backgroundColor = PlaceholderColor;
    
    self.textView.textColor = LGButtonColor;
   
    self.deleteBtn.hidden = YES;

}


-(void)deleteTextView{
    self.textView.text = @"";
    self.inputContentLabel.hidden = NO;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.cityTextField]) {
        self.locatePicker = [[HZAreaPickerView alloc] init];
        self.locatePicker.delegate = self;
        textField.inputView = self.locatePicker;

        self.location = self.locatePicker.locate;
        NSString *cityText = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];;
        if ([cityText length]>20) {
            self.cityTextField.font = [UIFont systemFontOfSize:10];
        }else{
            self.cityTextField.font = [UIFont systemFontOfSize:14];
        }
        self.cityTextField.text = cityText;
        cityNameStr= self.location.city;
        
    }

    return YES;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker {
    self.location = picker.locate;
    NSString *cityText = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];
    if ([cityText length]>18) {
        self.cityTextField.font = [UIFont systemFontOfSize:10];
    }else{
        self.cityTextField.font = [UIFont systemFontOfSize:14];
    }
    self.cityTextField.text = cityText;
    cityNameStr = self.location.city;
}






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.cityTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.detailAddressTextField resignFirstResponder];
    [self.textView resignFirstResponder];
}
-(NSString *)retunJoinType{
//   LoginDTO *loginDTO = [LoginDTO sharedInstance];
//    if (loginDTO.joinType&&[loginDTO.joinType length]&&![loginDTO.status isEqualToString:@"0"]) {
//        return loginDTO.joinType;
//    }
    if (_isRigst) {
        return @"2";
    }else{
        return @"5";
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
    
    citySearchOption.keyword = self.textView.text;
    
    
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

#pragma sel
#pragma sel
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
        showmeg = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district];
        
        
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
    [self.tableView reloadData];
    
    NSLog(@"_detailAddressStr  ===   %@",self.detailAddressStr);
}



-(void)locationValue:(BMKReverseGeoCodeResult *)result{
    //
    NSString *provinceID,*cityID,*areaID;
    
    
    
    for (NSDictionary * provinceDic in provinces) {
        
       
        
        if ([result.addressDetail.province containsString:provinceDic[@"stateName"]]) {
            
            provinceID = provinceDic[@"stateId"];
            
            for (NSDictionary *cityDic in provinceDic[@"cities"]) {
                
                if ([result.addressDetail.city isEqualToString:cityDic[@"cityName"]])
                {
                    
                    cityID = cityDic[@"cityId"];
                    
                    for (NSDictionary *areaDic in cityDic[@"areas"]) {
                        
                        if ([result.addressDetail.district isEqualToString:areaDic[@"areaName"]]) {
                            
                            areaID = areaDic[@"areaId"];
                            
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"%@,%@,%@",provinceID,cityID,areaID);
    if (!self.location) {
        self.location = [HZLocation new];
    }
    self.location.stateId = [NSNumber numberWithInteger:[provinceID integerValue]];
    self.location.cityId = [NSNumber numberWithInteger:[cityID integerValue]];
    self.location.districtId = [NSNumber numberWithInteger:[areaID integerValue]];
    
    
    
}


#pragma mark  table  sel
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.detailAddressStr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJ_ManagerAddressCell *managerCell = [tableView dequeueReusableCellWithIdentifier:@"ZJ_ManagerAddressCell"];
    if (!managerCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ZJ_ManagerAddressCell" bundle:nil] forCellReuseIdentifier:@"ZJ_ManagerAddressCell"];
        managerCell = [tableView dequeueReusableCellWithIdentifier:@"ZJ_ManagerAddressCell"];
    }
    managerCell.selectionStyle= UITableViewCellSelectionStyleNone;
    //self.textView.text
    
    NSString *strDetailAddressStr = self.detailAddressStr[indexPath.row];
    
    NSRange range = [self.detailAddressStr[indexPath.row] rangeOfString:self.textView.text];
    if (range.length==0) {
        range = [self.detailAddressStr[indexPath.row] rangeOfString:[self.textView.text lowercaseString]];
    }
    if (range.length>0) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:strDetailAddressStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x999999 alpha:1]}];
        
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
        managerCell.nameLabel.attributedText = str;
    }else{
        managerCell.nameLabel.text = self.detailAddressStr[indexPath.row];
        managerCell.nameLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
;

    }
   
   // managerCell.nameLabel.text = self.detailAddressStr[indexPath.row];
    managerCell.backgroundColor = [UIColor clearColor];
  
    
    return managerCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard:nil];
    self.tableView.hidden = YES;
    self.saveButton.hidden = NO;
    _inputContentLabel.hidden = YES;
    self.textView.text = self.detailAddressStr[indexPath.row];
    
 
    
}








@end
