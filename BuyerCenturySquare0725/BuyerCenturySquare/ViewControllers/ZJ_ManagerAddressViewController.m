//
//  ZJ_ManagerAddressViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_ManagerAddressViewController.h"
#import "AddressTextField.h"
#import "CustomTextView.h"
#import "HZAreaPickerView.h"
#import "ZJ_ManagerAddressView.h"
#import "CustomBarButtonItem.h"
#import "CSPAddressMangementViewController.h"
#import "ZJ_ManagerAddressCell.h"
#import "AdressListModel.h"

#import "KeyboardToolBar.h"
#import "KeyboardToolBarTextField.h"
//采用百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

//采用百度地图定位
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ZJ_ManagerAddressViewController ()<UITextFieldDelegate,ZJ_ManagerAddressViewDelegate,BMKMapViewDelegate, BMKPoiSearchDelegate,UITextViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,HZAreaPickerDelegate,UIAlertViewDelegate,BMKSuggestionSearchDelegate,UIScrollViewDelegate>
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
    //
    ZJ_ManagerAddressView *managerView;
    //
    NSArray *provinces, *cities, *areas;
    //
    AdressListModel *consigneeDTO;
    
    //添加手势
    UITapGestureRecognizer *tapGesture;
    
    //添加bool
    BOOL isOK;
    
     UIButton *footerButton;
}

#define heightFrame 40
#define weightFrame 80
#define textHeight 30
#define TIME 0.6
@property (strong, nonatomic)UIScrollView *scrollView;
//
@property (nonatomic, strong) CLLocationManager *locMgr;
//
@property (nonatomic,strong)NSMutableArray *detailAddressStr;
//
@property (strong, nonatomic)ConsigneeAddressDTO *addressDTO;
//
@property (strong, nonatomic)UITableView *tableView;
//
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
//
@property (strong, nonatomic) NSString *areaValue, *cityValue;
//
@property (strong ,nonatomic) UIButton *saveButton;



@end

@implementation ZJ_ManagerAddressViewController
@synthesize areaValue=_areaValue, cityValue=_cityValue;

@synthesize locatePicker=_locatePicker;

//采用百度地图
-(void)viewWillAppear:(BOOL)animated {
    //定位
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poisearch.delegate = self;
    //＃进行tab隐藏
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
        //进行赋值(进入页面进行赋值)
     if (self.manageAddress == CSPModifyAddress) {
         //model进行初始化
         consigneeDTO = [[AdressListModel alloc]init];
         
         managerView.nameTextField.text = self.consigneeDTO.consigneeName;
     
         managerView.phoneTextField.text = self.consigneeDTO.consigneePhone;
     
         managerView.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.consigneeDTO.provinceName,self.consigneeDTO.cityName,self.consigneeDTO.countyName];
     
         managerView.addressTextView.text = self.consigneeDTO.detailAddress;
         
         cityNameStr = self.consigneeDTO.cityName;
         
         consigneeDTO.Id = self.consigneeDTO.Id;
         consigneeDTO.memberNo = self.consigneeDTO.memberNo;
         consigneeDTO.defaultFlag =  self.consigneeDTO.defaultFlag;
         consigneeDTO.provinceName = self.consigneeDTO.provinceName;
         consigneeDTO.cityName =  self.consigneeDTO.cityName;
         consigneeDTO.countyName = self.consigneeDTO.countyName;
         consigneeDTO.provinceNo = self.consigneeDTO.provinceNo;
         consigneeDTO.cityNo = self.consigneeDTO.cityNo;
         consigneeDTO.countyNo = self.consigneeDTO.countyNo;
     }
    
    //进行键盘通知
    [self registerForKeyboardNotifications];
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    
    //采用百度地图
    _poisearch = [[BMKSuggestionSearch alloc]init];
    //百度地图定位
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //添加手势
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overEditor)];
    //不加会屏蔽到TableView的点击事件等
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    
}

#pragma mark ====page 添加手势，编辑结束=====
-(void)overEditor{
    
    [self.view endEditing:YES];
    
    if (managerView.addressTextView) {
        
        [UIView animateWithDuration:TIME animations:^{
            
            managerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 190);           //
            managerView.roundLabel.hidden = YES;
            managerView.fourLabel.hidden  = NO;
            managerView.thridLabel.hidden = NO;
            
        }];
    }
}

#pragma UI

-(void)makeUI
{

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
    
    //背景是scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    managerView = [[[NSBundle mainBundle]loadNibNamed:@"ManagerAddressView" owner:nil options:nil]lastObject];
    managerView.delegate = self;
    managerView.nameTextField.delegate = self;
    managerView.phoneTextField.delegate = self;
    managerView.cityTextField.delegate = self;
    managerView.addressTextView.delegate = self;
    managerView.roundLabel.hidden = YES;
    managerView.cityTextField.deleteButton.hidden = YES;
    
    
     //进行光标显示
    [managerView.nameTextField becomeFirstResponder];
    
    managerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 190);
    
//    [KeyboardToolBarTextField registerKeyboardToolBar:managerView.nameTextField];
//    
//    [KeyboardToolBarTextField registerKeyboardToolBar:managerView.phoneTextField];
//
//    [KeyboardToolBar registerKeyboardToolBar:managerView.addressTextView];
    
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.scrollView addSubview:managerView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, self.scrollView.frame.size.width,200) style:(UITableViewStyleGrouped)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
    
    //
    self.saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveButton.frame = CGRectMake(0,self.view.frame.size.height - 50 - 64, self.view.frame.size.width, 50);
    [self.saveButton setFont:[UIFont systemFontOfSize:16]];
    [self.saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    self.saveButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.saveButton];
    [self.saveButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.saveButton addTarget:self action:@selector(saveAddressInfo) forControlEvents:(UIControlEventTouchUpInside)];
    
        
}

#pragma sel
-(void)didClickPostionBtnAction
{
    //进行取消
    [self.view endEditing:YES];
    
    if([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locMgr requestAlwaysAuthorization]; // 永久授权
        [self.locMgr requestWhenInUseAuthorization]; //使用中授权
    }
    
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case 0:
        {
            [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case 1:
        {
            [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case 2:
        {
           [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case 3:
        {
           [self.view makeMessage:@"请打开“定位服务”来允许叮咚欧品确定您的位置。" duration:2.0f position:@"center"];
        }
            break;
        case 4:
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
        showmeg = [NSString stringWithFormat:@"%@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district];
        
        cityNameStr = result.addressDetail.city;
        //
        NSString *provinceID,*cityID,*areaID;
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data.plist" ofType:nil]];

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
        
        managerView.cityTextField.text = showmeg;

        if (self.manageAddress == CSPModifyAddress) {
            
            consigneeDTO.provinceName = result.addressDetail.province;
            consigneeDTO.cityName = result.addressDetail.city;
            consigneeDTO.countyName = result.addressDetail.district;
            consigneeDTO.provinceNo = [NSNumber numberWithDouble:provinceID.doubleValue];
            consigneeDTO.cityNo = [NSNumber numberWithDouble:cityID.doubleValue];
            consigneeDTO.countyNo = [NSNumber numberWithDouble:areaID.doubleValue];;
            
        }else{
            
            self.addressDTO.provinceNo = [NSNumber numberWithDouble:provinceID.doubleValue];
            self.addressDTO.cityNo = [NSNumber numberWithDouble:cityID.doubleValue];
            self.addressDTO.countyNo = [NSNumber numberWithDouble:areaID.doubleValue];
        }

    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma textview  SEL
- (void)textViewDidChange:(UITextView *)textView {
    
    self.tableView.hidden = NO;
    tapGesture.enabled = NO;
    
    curPage = 0;
    //城市检索
    
    BMKSuggestionSearchOption *citySearchOption = [[BMKSuggestionSearchOption alloc]init];
    
    citySearchOption.cityname = cityNameStr;
    
    citySearchOption.keyword = textView.text;
    
//    NSLog(@"textView.text ==== %@",textView.text);
    
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (managerView.addressTextView == textView) {
        
        [UIView animateWithDuration:TIME animations:^{
            
            managerView.center = CGPointMake(managerView.center.x, managerView.center.y - 130);
            //
            managerView.roundLabel.hidden = NO;
            managerView.fourLabel.hidden  = YES;
            managerView.thridLabel.hidden = YES;

        }];
    }
}



#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(AddressTextField *)textField
{
    
    if ( managerView.cityTextField == textField) {
        
        
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:titlePath];
        
        
        [managerView.cityTextField resignFirstResponder];
        
        if ([managerView.cityTextField.text isEqualToString:@""] || managerView.cityTextField.text == nil) {
            
            [self didClickPostionBtnAction];
            
        }

        if (arr.count != 0) {
            //进行初始化
            self.locatePicker = [[HZAreaPickerView alloc] init];
            
            self.locatePicker.delegate = self;
            
        }else
        {
            return NO;
        }
        textField.inputView = self.locatePicker;

      

     
        

    }
    return YES;
}
//编辑结束
-(void)viewEditorOver
{
    [self.view endEditing:YES];
}


#pragma HZAreaPickerViewDelegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (![picker.locate.state isEqualToString:@""]) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }else
    {
        self.areaValue = @"";
    }

    managerView.cityTextField.text = self.areaValue;
    
    if (self.manageAddress == CSPModifyAddress) {
        
        consigneeDTO.provinceName = picker.locate.state;
        consigneeDTO.cityName = picker.locate.city;
        consigneeDTO.countyName = picker.locate.district;
        consigneeDTO.provinceNo = picker.locate.stateId;
        consigneeDTO.cityNo = picker.locate.cityId;
        consigneeDTO.countyNo = picker.locate.districtId;
        cityNameStr = picker.locate.city;
        
    }else{
        
        self.addressDTO.provinceNo = picker.locate.stateId;
        self.addressDTO.cityNo = picker.locate.cityId;
        self.addressDTO.countyNo = picker.locate.districtId;
        cityNameStr = picker.locate.city;
        
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
    
    if (self.detailAddressStr.count == 0) {
        tapGesture.enabled = YES;
    }


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



#pragma mark 返回 sel
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




#pragma mark  table  sel
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.detailAddressStr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJ_ManagerAddressCell * managerCell = (ZJ_ManagerAddressCell *)[tableView dequeueReusableCellWithIdentifier:@"ZJ_ManagerAddressCell"];
    
    if (managerCell == NULL) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ZJ_ManagerAddressCell" owner:self options:nil] ;
        managerCell = [nib objectAtIndex:0];
    }
    
    if (self.detailAddressStr.count != 0) {
        tapGesture.enabled = NO;
    }
    
    NSString *strDetailAddressStr = self.detailAddressStr[indexPath.row];
    
    NSRange range = [self.detailAddressStr[indexPath.row] rangeOfString: managerView.addressTextView.text];
    
    if (range.length==0) {
        
        range = [self.detailAddressStr[indexPath.row] rangeOfString:[managerView.addressTextView.text lowercaseString]];
        
    }
    if (range.length>0) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:strDetailAddressStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x666666 alpha:1]}];
    
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0xfd4f57 alpha:1] range:range];
        managerCell.nameLabel.attributedText = str;
    }else{
        managerCell.nameLabel.text = self.detailAddressStr[indexPath.row];
        managerCell.nameLabel.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
        ;
        
    }
    
    return managerCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    managerView.addressTextView.text = self.detailAddressStr[indexPath.row];
    
    consigneeDTO.detailAddress = managerView.addressTextView.text;
    
    self.detailAddressStr = nil;
    
    self.tableView.hidden = YES;
    
    tapGesture.enabled = YES;
    
    [self.tableView reloadData];
    
    if (managerView.addressTextView) {
        
        [UIView animateWithDuration:TIME animations:^{
            
            managerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 190);           //
            managerView.roundLabel.hidden = YES;
            managerView.fourLabel.hidden  = NO;
            managerView.thridLabel.hidden = NO;
            
        }];
    }
    [self.view endEditing:YES];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.detailAddressStr.count >= 6) {
        return 0.01;
        
    }else{
        return 150;
        
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (!footerButton) {
        footerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        if (self.detailAddressStr.count >= 6) {
            footerButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        }else{
            footerButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        }
        
        
        footerButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        footerButton.backgroundColor = [UIColor clearColor];
        [footerButton addTarget:self action:@selector(overEditor) forControlEvents:UIControlEventTouchUpInside];
    }
    return footerButton;
}


#pragma mark 键盘sel
-(void)hideKeyboard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:TIME animations:^{
        managerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 190);
      
        managerView.roundLabel.hidden = YES;
        managerView.fourLabel.hidden  = NO;
        managerView.thridLabel.hidden = NO;
        
    }];
}



#pragma mark-键盘处理的方法
- (void)registerForKeyboardNotifications
{
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    
    CGFloat keyboardY = self.view.frame.size.height-kbSize.height - 60;
    
    self.tableView.frame = CGRectMake(0, 60, self.view.frame.size.width, keyboardY);
   
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    self.tableView.hidden = YES;
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:TIME animations:^{
        managerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 190);
        
        managerView.roundLabel.hidden = YES;
        managerView.fourLabel.hidden  = NO;
        managerView.thridLabel.hidden = NO;
        
    }];
    
}








-(void)saveAddressInfo
{
    
    //姓名
     if (self.manageAddress == CSPModifyAddress) {
     
         consigneeDTO.consigneeName = managerView.nameTextField.text;
         
         consigneeDTO.consigneePhone = managerView.phoneTextField.text;
         
         consigneeDTO.detailAddress = managerView.addressTextView.text;
         

     }else{
     
         self.addressDTO.consigneeName = managerView.nameTextField.text;
         self.addressDTO.consigneePhone =  managerView.phoneTextField.text;
         
         self.addressDTO.detailAddress = managerView.addressTextView.text;
     
     }
  
    if (self.manageAddress == CSPModifyAddress) {
        //校验姓名
        if ([consigneeDTO.consigneeName isEqualToString:@""]) {
            [self.view makeMessage:@"姓名不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkUserNameFormat:consigneeDTO.consigneeName]) {
            [self.view makeMessage:@"请使用中文或英文输入姓名" duration:2 position:@"center"];
            return;
        }
        if ([CSPUtils countWord:self.consigneeDTO.consigneeName]>10) {
            [self.view makeMessage:@"姓名不得超过10个字" duration:2 position:@"center"];
            return;
        }
        //校验手机号
        if ([consigneeDTO.consigneePhone isEqualToString:@""]) {
            [self.view makeMessage:@"手机号码不能为空" duration:2 position:@"center"];
            return;
        }
        if (![CSPUtils checkMobileNumber:consigneeDTO.consigneePhone]) {
            [self.view makeMessage:@"手机号码格式错误" duration:2 position:@"center"];
            return;
        }
        
        //校验省市区
        if ([consigneeDTO.provinceName isEqualToString:@""]) {
            [self.view makeMessage:@"请选择省市区" duration:2 position:@"center"];
            return;
        }
        
        //校验详细地址
        if (![CSPUtils checkDetailAddressLength:consigneeDTO.detailAddress]) {
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
            [self.view makeMessage:@"请使用中文或英文输入姓名" duration:2 position:@"center"];
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
    
    
    
   

    self.saveButton.selected = NO;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}


#pragma mark --
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
    
        
        
        if (self.manageAddress == CSPModifyAddress) {
            
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HttpManager sendHttpRequestForConsigneeUpdateWithConsigneeDTO:consigneeDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                DebugLog(@"%@", responseObject);
                
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

                

                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    self.saveButton.selected = YES;


                    for (UIViewController *vcHome in self.navigationController.viewControllers) {
                        if ([vcHome isKindOfClass:[CSPAddressMangementViewController class]]) {
                            [self.navigationController popToViewController:vcHome animated:YES];
                        }
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"error ***********= %@",[NSString stringWithFormat:@"%@",error]);
                
            }];
        }else{
            
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HttpManager sendHttpRequestForAddConsignee:self.addressDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.progressHUD hide:YES];
                

                DebugLog(@"%@", responseObject);
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"dic = %@",dic);
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    self.saveButton.selected = YES;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error ***********= %@",[NSString stringWithFormat:@"%@",error]);
                [MBProgressHUD hideHUDForView:self.view animated:YES];


            }];
            
        }

    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    return YES;
}










@end
