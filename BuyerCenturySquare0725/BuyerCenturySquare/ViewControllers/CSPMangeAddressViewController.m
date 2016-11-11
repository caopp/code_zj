//
//  CSPMangeAdressViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMangeAddressViewController.h"
#import "CSPBaseTableViewCell.h"
#import "HZAreaPickerView.h"
#import "ConsigneeAddressDTO.h"
#import "CSPUtils.h"
#import "CustomBarButtonItem.h"
#import "CSPAddressMangementViewController.h"

//采用百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


//采用百度地图定位
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface CSPMangeAddressViewController ()<UITextFieldDelegate,HZAreaPickerDelegate,UITextViewDelegate,BMKMapViewDelegate, BMKPoiSearchDelegate,UITextViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>
{
    UITextField *inputTextField_;
    NSIndexPath * addressPath;//!详细地址行
    
    //采用百度地图
    BMKMapView* _mapView;
    BMKPoiSearch* _poisearch;
    int curPage;
    
    //百度地图定位
    BMKGeoCodeSearch* _geocodesearch;
    BMKLocationService* _locService;
    //省市区名字
    NSString *cityNameStr;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonClicked:(id)sender;

@property (strong,nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) NSString *areaValue, *cityValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong ,nonatomic) UITextView *inputTextView;
@property(nonatomic,strong)CLGeocoder *geocoder;

@property (strong, nonatomic)ConsigneeAddressDTO *addressDTO;
@property (nonatomic, strong) CLLocationManager *locMgr;


@property (nonatomic,strong)NSMutableArray *detailAddressStr;

-(void)cancelLocatePicker;
@end

@implementation CSPMangeAddressViewController
@synthesize areaValue=_areaValue, cityValue=_cityValue;
@synthesize locatePicker=_locatePicker,inputTextField= inputTextField_;


//获取百度地图数据数组
-(NSMutableArray *)detailAddressStr
{
    if (_detailAddressStr == nil) {
        _detailAddressStr = [NSMutableArray arrayWithCapacity:0];
    }
    return  _detailAddressStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustombackBtnItem];
    
    //#进行判断（主要判断是收货地址还是管理地址（根据两个按钮tag值）
    if (self.manageAddress == CSPModifyAddress) {
        self.title = @"管理收货地址";
    }else{
        //#新建收货地址（进行model初始化）
        self.title = @"新建收货地址";
        self.addressDTO = [[ConsigneeAddressDTO alloc]init];
        self.addressDTO.defaultFlag = @"1";
    }
    
    [self setExtraCellLineHidden:self.tableView];
    
    //线顶头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.userInteractionEnabled = YES;
    
    //#编辑结束
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packUpTheKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    
    //!观察地址输入内容改变的
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addressChanged) name:UITextViewTextDidChangeNotification object:nil];
    
}

/**
 *  设置后退按钮
 */
-(void)addCustombackBtnItem{

    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
    }
    
    
   NSArray *views = [otherCell subviews];
    for (UIView *v  in views) {
        
        if ([v isKindOfClass:[UITextField class]]) {
            [v removeFromSuperview];
        }
        if ([v isKindOfClass:[UILabel class] ]) {
            [v removeFromSuperview];
            
        }
        
    }
    
    //#进行标题进行设置
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-11)/2, 150, 14)];
    title.textColor = HEX_COLOR(0x666666FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    [otherCell addSubview:title];
    
    
    UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, (44-20)/2, self.view.frame.size.width-100-25, 20)];
    inputTextField.textColor = HEX_COLOR(0x666666FF);
    inputTextField.textAlignment = NSTextAlignmentLeft;
    inputTextField.adjustsFontSizeToFitWidth = YES;
//    inputTextField.font = [UIFont systemFontOfSize:14];
    title.font = [UIFont systemFontOfSize:14];

    [otherCell addSubview:inputTextField];
    inputTextField.tag = indexPath.row;
    inputTextField.delegate = self;
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 8 -15,(45-12)/2, 8, 12)];
    
    UIButton *positionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    positionBtn.backgroundColor = [UIColor yellowColor];
    positionBtn.frame = CGRectMake(10, 10, 30, 30);
    
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 50, 15)];
    cityLabel.backgroundColor = [UIColor redColor];
    cityLabel.font = [UIFont systemFontOfSize:14];
    
    arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChangeOneCI:)
     name:UITextFieldTextDidChangeNotification
     object:inputTextField];
    

    switch (indexPath.row) {
        case 0:
            title.text = @"收货人";
            if (self.manageAddress == CSPModifyAddress) {
                inputTextField.text = self.consigneeDTO.consigneeName;
                
                
                
            }else{
                
                
            
                inputTextField.text = self.addressDTO.consigneeName;

            }
            
            break;
        case 1:
            
            title.text = @"手机号";
            inputTextField.keyboardType = UIKeyboardTypeNumberPad;

            if (self.manageAddress == CSPModifyAddress) {
            
                inputTextField.text = self.consigneeDTO.consigneePhone;
           
            }else{
            
                inputTextField.text = self.addressDTO.consigneePhone;

            }
            break;
        case 2:
            
            if (self.manageAddress == CSPModifyAddress) {
           
                inputTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.consigneeDTO.provinceName,self.consigneeDTO.cityName,self.consigneeDTO.countyName];
                
            }else
            {
                inputTextField.text = self.areaValue;
            }

            [otherCell addSubview:arrowImageView];
            
            [positionBtn addTarget:self action:@selector(position) forControlEvents:(UIControlEventTouchUpInside)];
            
            cityLabel.text = @"省市区";
            [otherCell addSubview:cityLabel];
            [otherCell addSubview:positionBtn];
            
            break;

        case 3:
        {
            
            addressPath = indexPath;
            
            if (self.inputTextView ) {
                
                [self.inputTextView removeFromSuperview];
            }

            //!y：0
            self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(100, (44-25)/2, self.view.frame.size.width-100-25, 25)];
            
            
            self.inputTextView.textColor = HEX_COLOR(0x666666FF);
            self.inputTextView.textAlignment = NSTextAlignmentLeft;
//            self.inputTextView.font = [UIFont systemFontOfSize:14];
            self.inputTextView.font = [UIFont systemFontOfSize:14];

            [otherCell addSubview:self.inputTextView];
            self.inputTextView.tag = indexPath.row;
            self.inputTextView.delegate = self;
            title.text = @"详细地址";
          
            if (self.manageAddress == CSPModifyAddress) {//!修改
            
                 self.inputTextView.text = self.consigneeDTO.detailAddress;
            }else{//!新增
            
                self.inputTextView.text = self.addressDTO.detailAddress;
            
            }
            
            //!修改收货地址的位置
            if (self.consigneeDTO.detailAddress || self.addressDTO.detailAddress) {
                
                [self.inputTextView sizeToFit];//!关键、让textView自适应大小

                //!得到textView自适应以后的高度
                CGFloat textViewHight = self.inputTextView.frame.size.height;
                
                if (textViewHight < 44) {
                    
                    self.inputTextView.frame = CGRectMake(100, (44 - textViewHight)/2, self.view.frame.size.width-100-25, textViewHight);
                    
                    
                    //!修改左边title的高度
                    title.frame = CGRectMake(15, (44-11)/2, 150, 14);
                    
                }else{
                    
                    self.inputTextView.frame = CGRectMake(100, 0, self.view.frame.size.width-100-25, textViewHight);

                    
                    //! 修改左边title的高度、用cell的高度减去title的高度
                    title.frame = CGRectMake(15, (self.inputTextView.frame.size.height + 1 - 11)/2, 150, 14);

                }
                
                //!让textview居中
                CGFloat topCorrect = 8;
                
                self.inputTextView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
            
            }
            
        }
            break;
  
            break;
            
        default:
            break;
    }
    
    return otherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        
        
        //!判断textview自适应的大小是否 >44
        if (self.inputTextView.frame.size.height <44) {
            
            return 44;

        }else{
        
            return self.inputTextView.frame.size.height + 1;//!加1为了不让textview遮住cell的分割线

        }
    }
    
    return 44;
}



- (IBAction)saveButtonClicked:(id)sender {
    
    
    if (self.manageAddress == CSPModifyAddress) {
        //校验姓名
        if ([self.consigneeDTO.consigneeName isEqualToString:@""]) {
            [self.view makeMessage:@"姓名不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkUserNameFormat:self.consigneeDTO.consigneeName]) {
            [self.view makeMessage:@"姓名请使用中文或英文输入姓名" duration:2 position:@"center"];
            return;
        }
        if ([CSPUtils countWord:self.consigneeDTO.consigneeName]>10) {
            [self.view makeMessage:@"姓名不得超过10个字" duration:2 position:@"center"];
            return;
        }
        //校验手机号
        if ([self.consigneeDTO.consigneePhone isEqualToString:@""]) {
            [self.view makeMessage:@"手机号码不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkMobileNumber:self.consigneeDTO.consigneePhone]) {
            [self.view makeMessage:@"手机号码格式错误" duration:2 position:@"center"];
            return;
        }
        
        //校验省市区
        if ([self.consigneeDTO.provinceName isEqualToString:@""]) {
            [self.view makeMessage:@"请选择省市区" duration:2 position:@"center"];
            return;
        }
        
        //校验详细地址
        if (![CSPUtils checkDetailAddressLength:self.consigneeDTO.detailAddress]) {
            [self.view makeMessage:@"详细地址需在5-60字之间可输入中文、英文、数字、符号" duration:2 position:@"center"];
            return;
        }
 
    }else{
        
        //校验姓名
        if ([self.addressDTO.consigneeName isEqualToString:@""]) {
            [self.view makeMessage:@"姓名不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkUserNameFormat:self.addressDTO.consigneeName]) {
            [self.view makeMessage:@"姓名请使用中文或英文输入姓名" duration:2 position:@"center"];
            return;
        }
        if ([CSPUtils countWord:self.addressDTO.consigneeName]>10) {
            [self.view makeMessage:@"姓名不得超过10个字" duration:2 position:@"center"];
            return;
        }
        //校验手机号
        if ([self.addressDTO.consigneePhone isEqualToString:@""]) {
            [self.view makeMessage:@"手机号码不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkMobileNumber:self.addressDTO.consigneePhone]) {
            [self.view makeMessage:@"手机号码格式错误" duration:2 position:@"center"];
            return;
        }
        
        //校验省市区
        if ([self.addressDTO.provinceNo.stringValue isEqualToString:@""]||self.addressDTO.provinceNo == nil) {
            [self.view makeMessage:@"请选择省市区" duration:2 position:@"center"];
            return;
        }
        //校验详细地址
        
        if (![CSPUtils checkDetailAddressLength:self.addressDTO.detailAddress]) {
            [self.view makeMessage:@"详细地址需在5-60字之间可输入中文、英文、数字、符号" duration:2 position:@"center"];
            return;
        }
        
      
    }
    
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DebugLog(@"%@", textField.text);
    
    if (textField.tag == 2) {
        
        //加载数据（获取沙盒存储路径）
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:titlePath];
        
        if (arr.count != 0) {
            self.locatePicker = [[HZAreaPickerView alloc] init];
            self.locatePicker.delegate = self;
        }
        
    
        textField.inputView = self.locatePicker;
        self.inputTextField = textField;
 
        [self pickerDidChaneStatus:self.locatePicker];

    }
    DebugLog(@"%@", textField.text);

    
    self.inputTextField = textField;
    

    return YES;
    
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    
    UITextField *textField=[notification object];
    switch (textField.tag) {
        case 0:
            if (self.manageAddress == CSPModifyAddress) {
                
                self.consigneeDTO.consigneeName = textField.text;
                
            }else{
                
                self.addressDTO.consigneeName = textField.text;
                
            }
            
            break;
        case 1:
            if (self.manageAddress == CSPModifyAddress) {
                
                self.consigneeDTO.consigneePhone = textField.text;
                
            }else{
                
                self.addressDTO.consigneePhone = textField.text;
                
            }
            break;
        case 2:
            //            self.consigneeDTO.mobilePhone = textField.text;
            break;
        case 3:
            if (self.manageAddress == CSPModifyAddress) {
                self.consigneeDTO.detailAddress = textField.text;
            }else{
                self.addressDTO.detailAddress = textField.text;
            }
            break;
            
        default:
            break;
    }

    
}





#pragma mark --
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        

//     self.consigneeDTO.provinceNo = [NSNumber numberWithInteger:19];
//        
//       self.consigneeDTO.cityNo = [NSNumber numberWithInteger:235];
//        
//        self.consigneeDTO.countyNo = [NSNumber numberWithInteger:2188];
        [self progressHUDShowWithString:@"正在保存收货地址"];
        
        if (self.manageAddress == CSPModifyAddress) {
        

            
        [HttpManager sendHttpRequestForConsigneeUpdateWithConsigneeDTO:self.consigneeDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DebugLog(@"%@", responseObject);
            
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [self.progressHUD hide:YES];
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                for (UIViewController *vcHome in self.navigationController.viewControllers) {
                    if ([vcHome isKindOfClass:[CSPAddressMangementViewController class]]) {
                        [self.navigationController popToViewController:vcHome animated:YES];
                    }
                }
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert show];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.progressHUD hide:YES];
            NSLog(@"error ***********= %@",[NSString stringWithFormat:@"%@",error]);
            
        }];
        }else{
            
            
            
            
            [HttpManager sendHttpRequestForAddConsignee:self.addressDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.progressHUD hide:YES];
                
            DebugLog(@"%@", responseObject);
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"dic = %@",dic);
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error ***********= %@",[NSString stringWithFormat:@"%@",error]);
                [self.progressHUD hide:YES];
            }];

        }

        
    }
    
}

#pragma mark--
#pragma HZAreaPickerViewDelegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    self.inputTextField.text = self.areaValue;
    
    if (self.manageAddress == CSPModifyAddress) {
        
        self.consigneeDTO.provinceName = picker.locate.state;
        self.consigneeDTO.cityName = picker.locate.city;
        self.consigneeDTO.countyName = picker.locate.district;
        self.consigneeDTO.provinceNo = picker.locate.stateId;
        self.consigneeDTO.cityNo = picker.locate.cityId;
        self.consigneeDTO.countyNo = picker.locate.districtId;
   
    }else{
        
        self.addressDTO.provinceNo = picker.locate.stateId;
        self.addressDTO.cityNo = picker.locate.cityId;
        self.addressDTO.countyNo = picker.locate.districtId;
    
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
#pragma mark textView的代理方法

//!地址输入框输入内容改变
-(void)addressChanged{
    
    
    if (self.manageAddress == CSPModifyAddress) {//!修改
        
        self.consigneeDTO.detailAddress = self.inputTextView.text;

        
    }else{//!新增
        
        self.addressDTO.detailAddress = self.inputTextView.text;
        
    }
    
    
    
    if (self.inputTextView.text.length >60) {
        
        [self.view makeMessage:@"输入的内容需要在5-60个字之间" duration:2 position:@"center"];
        
        self.inputTextView.text = [self.inputTextView.text substringToIndex:60];
        
        
    }
    
    
    
    
}


//#编辑后进行刷新
-(void)textViewDidEndEditing:(UITextView *)textView{


//    [self.tableView reloadRowsAtIndexPaths:@[addressPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //    [self cancelLocatePicker];
    [self.inputTextField resignFirstResponder];
    
}
/**
 *  根据textview
 *
 *  @param value    输入内容
 *  @param fontSize
 *  @param width
 *
 *  @return
 */

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:14];
    
    
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}






- (void)packUpTheKeyboard
{
    [self.view endEditing:YES];
    
}


#pragma sel  地理位置反编码

-(void)position
{
       
    // 开始定位用户的位置
    [self.locMgr startUpdatingLocation];
    
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
      
      if (self.manageAddress == CSPModifyAddress) {

          self.consigneeDTO.provinceName = result.addressDetail.province;
          self.consigneeDTO.cityName = result.addressDetail.city;
          self.consigneeDTO.countyName = result.addressDetail.district;

      }else
      {
          self.consigneeDTO.provinceName = result.addressDetail.province;
          self.consigneeDTO.cityName = result.addressDetail.city;
          self.consigneeDTO.countyName = result.addressDetail.district;
          
      }
      

              UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
              [myAlertView show];
      
      [self.tableView reloadData];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}
//采用百度地图
-(void)viewWillAppear:(BOOL)animated {
    //定位
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
      _locService.delegate = self;
    _poisearch.delegate = self;
    //＃进行tab隐藏
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
    [super viewWillDisappear:animated];
    //#移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];
}

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
    
    [self.tableView reloadData];
}


@end
