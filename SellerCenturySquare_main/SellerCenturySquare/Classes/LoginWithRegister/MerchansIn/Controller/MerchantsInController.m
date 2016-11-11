//
//  MerchantsInController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/29.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MerchantsInController.h"
#import "MerchantsInTextField.h"
#import "HZAreaPickerView.h"
#import "HZLocation.h"
#import "CSPUtils.h"
#import "GUAAlertView.h"
#import "MBProgressHUD+Add.h"
#import "CustomTextField.h"
#import "CityPropValueDefault.h"

@interface MerchantsInController ()<UITextFieldDelegate,HZAreaPickerDelegate>
{
    //!背景图片
    UIImageView *bgImageView;
    //!背景sc
    UIScrollView *bgScrollerView;
    
    //!palceholder 内容
    NSArray *placeHolderTextArray;
    
    
    //!性别下面的横线
    UIView * sexLineView;
    
    //!记录要上传的数据

    //!商家名称
    NSString *merchantName;
    
    //!档口位置
    NSString * stallLoc;
    
    //!姓名
    NSString *name;
    
    //!性别
    NSString *sexStr;
    
    //!手机号
    NSString *phone;
    
    
    BOOL cityIsRequest;
    
}
//!地址
@property (nonatomic,strong) HZAreaPickerView* locatePicker;
//!记录选中的省市区
@property (nonatomic,strong) HZLocation* hzLocation;


@end

@implementation MerchantsInController

- (void)viewDidLoad {
    [super viewDidLoad];

    //!创建导航
    [self createNav];
    
    placeHolderTextArray = @[@"商家/品牌名称",@"省市区",@"档口位置",@"联系人姓名",@"手机号"];
    
    //!创建界面
    [self createUI];
}
#pragma mark 创建导航
-(void)createNav{
    

    self.title = @"商家入驻";

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    

}
-(void)leftBarButtonClick{

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 创建界面
-(void)createUI{

    //!背景
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)];
    [bgImageView setImage:[UIImage imageNamed:@"LoginBackground"]];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];

    //!sc
    float navHight = self.navigationController.navigationBar.frame.size.height +20;
    
    bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, SCREEN_HIGHT- navHight)];

    bgScrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
    
    [self.view addSubview:bgScrollerView];
    
    
    CGFloat width = SCREEN_WIDTH - 40*2;
    CGFloat x = 40;
    CGFloat hight = 43;
    
    //!叮咚欧品-最懂你的快时尚欧美女装批发平台
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 20, width, 15)];

    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    
    [headerLabel setAttributedText:[self getStr:@"叮咚欧品-最懂你的快时尚欧美女装批发平台"]];
    
    [bgScrollerView addSubview:headerLabel];
    
    
    //!创建输入框
    for (int i=0; i< 5 ; i++) {
        
        MerchantsInTextField * textField = [[MerchantsInTextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(headerLabel.frame)+ 25 + hight *i, width, 18)];
        textField.placeholder = placeHolderTextArray[i];
        textField.delegate = self;
        textField.tag =200+i;
        [bgScrollerView addSubview:textField];
        
        //!省市区
        if (i == 1) {
            
            NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
            NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:titlePath];

          if (arr.count != 0) {
                //进行初始化
            self.locatePicker = [[HZAreaPickerView alloc] init];
                
            self.locatePicker.delegate = self;

            textField.inputView = self.locatePicker;

           }
        
        }
        
        //!姓名行
        if (i == 3) {
            
            CGFloat nameTextY = CGRectGetMaxY(headerLabel.frame)+ 25 + hight *i;
            
            textField.frame = CGRectMake(x, nameTextY, width -88 , 18);
            
            //!创建性别view
            [self cretaeSexView:CGRectGetMaxX(textField.frame) withY:nameTextY -5 withWith:88 withHight:18+5];
            
            
        }
        
        //!手机号行
        if (i == 4) {
            
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    
    //!以上信息均为必填项
    UILabel *mustLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(headerLabel.frame)+25+ hight*5, width, 15)];
    
    [mustLabel setTextAlignment:NSTextAlignmentLeft];
    
    [mustLabel setAttributedText:[self getStr:@"以上信息均为必填项"]];
    
    [bgScrollerView addSubview:mustLabel];
    
    
    //!收到您的申请后，叮咚欧品将有专业客服协助您办理商家入驻的相关事宜
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(mustLabel.frame)+25, width, 50)];
    
    [alertLabel setTextAlignment:NSTextAlignmentLeft];
    
    [alertLabel setAttributedText:[self getStr:@"收到您的申请后，叮咚欧品将有专业客服协助您办理商家入驻的相关事宜。"]];
    alertLabel.numberOfLines = 0;
    
    [bgScrollerView addSubview:alertLabel];
    
    
    //!客服:0755-2354 6190
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(alertLabel.frame)+ 25, width, 15)];
    
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    
    [phoneLabel setAttributedText:[self getStr:@"客服:4008-555-213"]];
    
    [bgScrollerView addSubview:phoneLabel];
    
    
   
    //!提交
    UIButton *submitBtn = [self cretateBtn:CGRectMake(x, CGRectGetMaxY(phoneLabel.frame)+25, width, 45) withTitle:@"提交" withTag:0 withAction:@selector(submitBtnClick) withCornerRadius:0];
    [bgScrollerView addSubview:submitBtn];
    
    //!隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [bgScrollerView addGestureRecognizer:tap];
    
    
}
-(void)hideKeyBoard{

    [self.view endEditing:YES];

}

//!创建性别view
-(void)cretaeSexView:(CGFloat )x withY:(CGFloat )y withWith:(CGFloat )width withHight:(CGFloat)hight{

    UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, hight)];
    
    UIButton *manBtn = [self cretateBtn:CGRectMake(0, 0, 42, hight-3) withTitle:@"男" withTag:101 withAction:@selector(sexBtnClick:) withCornerRadius:0.5];
    [sexView addSubview:manBtn];

    
    UIButton *womanBtn = [self cretateBtn:CGRectMake(CGRectGetMaxX(manBtn.frame)+2, 0, 42, hight-3) withTitle:@"女" withTag:102 withAction:@selector(sexBtnClick:) withCornerRadius:0.5];
    [sexView addSubview:womanBtn];

    sexLineView = [[UIView alloc]initWithFrame:CGRectMake(0, hight-1, width, 1)];
    
    //!设置性别底部横线的颜色 正常
    [self setSexLineColorNormal];

    
    [sexView addSubview:sexLineView];
    
    
    [bgScrollerView addSubview:sexView];
    
    
    
}
//!设置性别底部横线的颜色 正常
-(void)setSexLineColorNormal{

    [sexLineView setBackgroundColor:[UIColor colorWithHexValue:0xffffff alpha:0.7]];
    sexLineView.alpha = 0.3;
    
}
//!设置性别底部横线的颜色 选中
-(void)setSexLineColoSelect{
    
    [sexLineView setBackgroundColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    sexLineView.alpha = 1;
    
}

-(UIButton *)cretateBtn:(CGRect)frame withTitle:(NSString *)title withTag:(NSInteger)tag withAction:(SEL)action withCornerRadius:(CGFloat )radius{

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    
    if (radius !=0 ) {
        
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        
    }
   
    btn.layer.borderColor = [UIColor colorWithHexValue:0xffffff alpha:0.7].CGColor;
    btn.layer.borderWidth = 1;
    btn.tag =tag;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return btn;

    
}



-(void)sexBtnClick:(UIButton *)sexBtn{

    //!改变选中btn的背景
    sexBtn.selected = YES;
    
    [sexBtn setBackgroundColor:[UIColor colorWithHexValue:0xffffff alpha:0.7]];

    
    //!要改变btn的tag
    NSInteger changeInteger = 0;
    //!男
    if (sexBtn.tag == 101) {
    
        changeInteger = 102;
        sexStr = @"1";
        
    }else{//!女
    
        changeInteger = 101;
        sexStr = @"2";

    }
    
    //!改变未选择btn的背景
    
    //!获取性别女
    UIButton *changeSexBtn = (UIButton *)[bgScrollerView viewWithTag:changeInteger];
    [changeSexBtn setBackgroundColor:nil];



}
-(NSAttributedString *)getStr:(NSString *)attributeStr{

    NSAttributedString * changeStr = [[NSAttributedString alloc]initWithString:attributeStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xffffff alpha:0.7]}];

    return changeStr;

}

#pragma mark textfiled代理

-(void)textFieldDidEndEditing:(UITextField *)textField{

    NSInteger textFieldTag = textField.tag -200;
    
    switch (textFieldTag) {
        case 0://!商家名称
        {
        
            merchantName = textField.text;
        
        }
            break;
        case 2://!档口位置
        {
            
            stallLoc = textField.text;
            
        }
            break;

        case 3://!姓名
        {
            
            name = textField.text;
            
            //!设置性别底部横线的颜色 正常
            [self setSexLineColorNormal];
         
            
        }
            break;

        case 4://!商家联系方式
        {
            
            phone = textField.text;
            
        }
            break;
            
        default:
            break;
    
    }
    
    //!标志为未请求
    cityIsRequest = NO;
    

}



-(void)textFieldDidBeginEditing:(UITextField *)textField{

    NSInteger textFieldTag = textField.tag -200;
    
    if (textFieldTag == 1) {
        
        self.locatePicker.hidden = YES;

        if (!cityIsRequest) {//!没有 判断完城市是否请求回来了
            
            [textField endEditing:YES];
        
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            CityPropValueDefault * cityDefault = [CityPropValueDefault shareManager];
            
            [cityDefault getInfoHasData:^{//!有数据
                
                DebugLog(@"hasData");
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                cityIsRequest = YES;
                
                [textField becomeFirstResponder];
                
                
            } requestSuccess:^{
                
                DebugLog(@"success");
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                cityIsRequest = YES;
                
                //!移除原来的
                [self.locatePicker removeFromSuperview];
                self.locatePicker = nil;
                
                //!创建新的
                self.locatePicker = [[HZAreaPickerView alloc]init];
                
                self.locatePicker.delegate = self;
                textField.inputView = self.locatePicker;
                
                [textField becomeFirstResponder];
                
                
            } requestFailed:^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               
                [self.view makeMessage:@"请求省市区失败" duration:2.0 position:@"center"];
                
                DebugLog(@"failed");
                
                [textField resignFirstResponder];

                
            }];
        
            
        }else{//!判断完城市是否请求回来了
            
            self.locatePicker.hidden = NO;

        }
        
       

        
    }
    
    if (textFieldTag == 3) {
        
        //!姓名
        name = textField.text;
        
        //!设置性别底部横线的颜色 选中
        [self setSexLineColoSelect];
        
    }
    
    
    
}

#pragma mark 省市区代理
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    
    self.hzLocation = picker.locate;
    
    MerchantsInTextField * cityTextField = (MerchantsInTextField*)[bgScrollerView viewWithTag:201];

    if (![self.hzLocation.state isEqualToString:@""]) {
          cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.hzLocation.state, self.hzLocation.city, self.hzLocation.district];
    }else
    {
        cityTextField.text = @"";
    }
    
//    cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.hzLocation.state, self.hzLocation.city, self.hzLocation.district];
   
}

#pragma mark 提交
-(void)submitBtnClick{

    //!商家名称
    //!判断数据是否合法 允许输入中文、英文、数字，减号和下划线  30个字
    NSString * regex = @"[\u4e00-\u9fa5a-zA-Z0-9-_]{1,30}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    [self.view endEditing:YES];

    if (!merchantName.length) {
        
        [self.view makeMessage:@"请输入商家/品牌名称" duration:2.0 position:@"center"];
        
        return;
    }
    
    if (merchantName.length>30) {
        
        [self.view makeMessage:@"最多填写30个字" duration:2.0 position:@"center"];
        return;
    }
    
    BOOL merchantIsMatch = [pred evaluateWithObject:merchantName];

    if (!merchantIsMatch) {
        
        [self.view makeMessage:@"仅可输入中文、英文、数字、减号和下划线" duration:2.0 position:@"center"];
    
        return;
    }
   
    
    
    //!省市区
    if (!self.hzLocation) {
        
        [self.view makeMessage:@"必须选择省市区" duration:2.0 position:@"center"];

        return ;
    }
    
    if ([self.hzLocation.state isEqualToString:@""]) {//! 用户选择“请选择”的时候，这个值为空
        
        [self.view makeMessage:@"必须选择省市区" duration:2.0 position:@"center"];
        
        return ;
    }

    //!档口位置 	允许输入中文、英文、数字，减号和下划线  50个字
    
    
    if (!stallLoc.length) {
        
        [self.view makeMessage:@"请输入档口位置" duration:2.0 position:@"center"];
        
        return;
    }
    
    if (stallLoc.length>50) {
        
        [self.view makeMessage:@"最多填写50个字" duration:2.0 position:@"center"];
        return;
    }

    NSString * stallRegex = @"[\u4e00-\u9fa5a-zA-Z0-9-_]{1,50}";
    
    NSPredicate *stallPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stallRegex];

    BOOL stallLocIsMatch = [stallPred evaluateWithObject:stallLoc];

    if (!stallLocIsMatch) {
        
        [self.view makeMessage:@"仅可输入中文、英文、数字、减号和下划线" duration:2.0 position:@"center"];
        return;
    }
    
    
    //!姓名 A.	允许输入中文及英文
    NSString * nameRegex = @"[\u4e00-\u9fa5a-zA-Z]{1,10}";
    
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    if (!name) {
        
        [self.view makeMessage:@"请输入姓名" duration:2.0 position:@"center"];
        
        return;
    }
    
    if (name.length>10) {
        
        [self.view makeMessage:@"最多填写10个字" duration:2.0 position:@"center"];
        return;
    }
    
    BOOL nameMatch = [namePred evaluateWithObject:name];
    if (!nameMatch) {
        
        [self.view makeMessage:@"请使用中文或英文输入姓名" duration:2.0 position:@"center"];
        return;
    }
    
    //!性别
    if (!sexStr) {
        
        [self.view makeMessage:@"请选择性别" duration:2.0 position:@"center"];
        
        return;
        
    }
    
    //手机号
    if (phone.length<11) {
        
        [self.view makeMessage:@"请补全手机号" duration:2.0 position:@"center"];
        
        return;
    
    }
    
    if (![CSPUtils checkMobileNumber:phone]) {
        
        [self.view makeMessage:@"手机号码格式错误" duration:2.0 position:@"center"];
        
        return;
        
    }
    
    //!请求数据
    GUAAlertView *al = [GUAAlertView alertViewWithTitle:@"确定提交申请?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
       
        [self requestInfo];
        
    } dismissAction:^{
        
    }];
    
    [al show];
    

}
//!提交请求
-(void)requestInfo{

    NSMutableDictionary * upDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [upDic setObject:merchantName forKey:@"merchantName"];
    
    [upDic setObject:self.hzLocation.stateId forKey:@"provinceNo"];
    
    [upDic setObject:self.hzLocation.cityId forKey:@"cityNo"];

    [upDic setObject:self.hzLocation.districtId forKey:@"countyNo"];

    [upDic setObject:stallLoc forKey:@"stallLocation"];
    
    [upDic setObject:name forKey:@"contactName"];
    
    [upDic setObject:phone forKey:@"contactPhone"];
    
    [upDic setObject:sexStr forKey:@"sex"];

    [MBProgressHUD showMessag:@"正在提交" toView:self.view];
    
    [HttpManager sendHttpRequestForMerchantApplyAdd:upDic success:^(AFHTTPRequestOperation *operation, id reqeustObject) {
        
        [MBProgressHUD hideHUDForView:self.view  animated:NO];

        NSDictionary *dic =    [NSJSONSerialization JSONObjectWithData:reqeustObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            
            [self.view makeMessage:@"提交成功" duration:2.0 position:@"center"];
            
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popVC) userInfo:nil repeats:NO];
            
            
        }else{
        
            [self.view makeMessage:@"未提交成功，请重试。" duration:2.0 position:@"center"];

        }
        
        
        
    } failure:^(AFHTTPRequestOperation *opeation, NSError *error) {
       
        [MBProgressHUD hideHUDForView:self.view  animated:NO];

        [self.view makeMessage:@"未提交成功，请重试。" duration:2.0 position:@"center"];

        
        
    }];
    
    
}
//!返回上一个界面
-(void)popVC{

    [self.navigationController popToRootViewControllerAnimated:YES];


}

//编辑结束(省市区)
-(void)viewEditorOver
{
    [self.view endEditing:YES];
    
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
