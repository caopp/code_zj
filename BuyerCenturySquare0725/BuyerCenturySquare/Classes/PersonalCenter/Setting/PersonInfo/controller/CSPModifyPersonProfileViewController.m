//
//  CSPModifyPersonProfileViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPModifyPersonProfileViewController.h"
#import "CSPBaseTableViewCell.h"
#import "HZAreaPickerView.h"
#import "CSPModifyProfileCell.h"
#import "CSPUtils.h"
#import "PersonIofoTextField.h"


@interface CSPModifyPersonProfileViewController ()<UITextFieldDelegate,HZAreaPickerDelegate,UITextViewDelegate>
{

    //!正在输入的textview
    PersonIofoTextField *inputTextView_;
    
    BOOL isMale;
    
    UITextView *nickNameField;
    UITextView *nameField;
    UITextView *phoneField;
    UITextView *homePhoneField;
    UITextView *weiChatField;
    UITextView *locField;
    UITextView *detailAddressField;
    UITextView *postageField;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
- (IBAction)saveButtonClicked:(id)sender;

@property (strong,nonatomic)PersonIofoTextField *inputTextView;
@property (strong, nonatomic) NSString *areaValue, *cityValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

-(void)cancelLocatePicker;

@end

@implementation CSPModifyPersonProfileViewController
@synthesize areaValue=_areaValue, cityValue=_cityValue;
@synthesize locatePicker=_locatePicker,inputTextView= inputTextView_;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    //@继承父类返回按钮
    [self addCustombackButtonItem];
    
    //@首次进来默认性别
    if ([[MemberInfoDTO sharedInstance].sex isEqualToString:@"1"]) {
        isMale = YES;
    }else if([[MemberInfoDTO sharedInstance].sex isEqualToString:@"2"]){
        isMale = NO;
    }else {
        [MemberInfoDTO sharedInstance].sex = @"2";
    }
    
    [self setExtraCellLineHidden:self.tabelView];
    
    //@tableView 左右有像素15，以下方法出去像素
    if ([self.tabelView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tabelView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tabelView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tabelView setLayoutMargins:UIEdgeInsetsZero];
    }

    self.tabelView.scrollEnabled = NO;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardKey)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tabelView addGestureRecognizer:tapGr];
    
    //设置背景颜色保存按钮
    [_exitButton setBackgroundColor:[UIColor colorWithHexValue:0x1a1a1a alpha:1]];
    _exitButton.font = [UIFont systemFontOfSize:16];
    
    //设置中心
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTextFieldDic:) name:@"PersonIofoTextFieldName" object:nil];
    
   
    
}

-(void)getTextFieldDic:(NSNotification *)useIofoDic
{

    NSIndexPath *indexPath = useIofoDic.userInfo[@"text_row"];
    
    
    switch (indexPath.row) {
        case 0:
            
            [MemberInfoDTO sharedInstance].nickName = @"";
            
            break;
        case 1:
            
            [MemberInfoDTO sharedInstance].memberName = @"";
            break;
        case 2:
            [MemberInfoDTO sharedInstance].mobilePhone = @"";
            break;
        case 3:
            [MemberInfoDTO sharedInstance].telephone = @"";
            break;
        case 4:
            [MemberInfoDTO sharedInstance].wechatNo = @"";
            break;
        case 5:
            
            break;
        case 6:
            [MemberInfoDTO sharedInstance].detailAddress = @"";
            
            break;
        case 7:
            [MemberInfoDTO sharedInstance].postalCode = @"";
            break;
            
        default:
            break;
    }

    
    
}
//@编辑结束（所有键盘进行隐藏）
-(void)hideKeyboardKey{
    [self.view endEditing:YES];
}

#pragma mark ----@tableView 代理方法----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 8;
}
- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];

    [self.tabelView endEditing:YES];
   
    [self.inputView resignFirstResponder];
    
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
    
    CSPModifyProfileCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPModifyProfileCell"];

    if (!otherCell) {
        
        otherCell = [[CSPModifyProfileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSPModifyProfileCell"];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-14)/2, 150, 14)];//!原本是14，为了让g之类的字母能显示全，所以改成了18
        //        title.text = @"座机电话";
        title.textColor = HEX_COLOR(0x999999FF);
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:14];
        title.tag =100;
        [otherCell addSubview:title];
        
        
        otherCell.maleButton.frame = CGRectMake(self.view.frame.size.width-40-50-15, (45-20)/2, 40, 20);
        otherCell.femaleButton.frame = CGRectMake(self.view.frame.size.width-40-15, (45-20)/2, 40, 20);
        
        [otherCell.maleButton addTarget:self action:@selector(maleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [otherCell.femaleButton addTarget:self action:@selector(femaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *titleLabel = (UILabel *)[otherCell viewWithTag:100];
    

    //!得到先前的
    PersonIofoTextField *oldTextView = (PersonIofoTextField *)[otherCell viewWithTag:indexPath.row];
    if (oldTextView) {
        [oldTextView removeFromSuperview];
    }
    
    
    //!填写的textview
    PersonIofoTextField * inputTextView = [[PersonIofoTextField alloc]initWithFrame:CGRectMake(90, (44-25)/2, self.view.frame.size.width-80-25, 18+7)];
    inputTextView.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    inputTextView.textAlignment = NSTextAlignmentLeft;
    inputTextView.font = [UIFont systemFontOfSize:14];
    inputTextView.delegate = self;
    inputTextView.tag = indexPath.row;
    [otherCell addSubview:inputTextView];
    inputTextView.text_row = indexPath;
    
    
    //!改变输入的内容的时候发出通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textViewTextDidChangeOneCI:)
     name:UITextFieldTextDidChangeNotification
     object:inputTextView];
    
    
    //!得到先前的
    UITextView *oldTextView1 = (UITextView *)[otherCell viewWithTag:indexPath.row];
    if (oldTextView) {
        [oldTextView1 removeFromSuperview];
    }
    
     
    //!填写的t extview
    UITextView * inputTextView1 = [[UITextView alloc]initWithFrame:CGRectMake(100, 6, self.view.frame.size.width-100-25, 32)];
    inputTextView1.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    inputTextView1.textAlignment = NSTextAlignmentLeft;
    inputTextView1.delegate = self;
    inputTextView1.tag = indexPath.row;
    inputTextView1.font = [UIFont systemFontOfSize:14];
  
    //!改变输入的内容的时候发出通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textViewTextDidChangeOne:)
     name:UITextViewTextDidChangeNotification
     object:inputTextView1];


    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 8 -15,(45-12)/2, 8, 12)];
    arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];

    inputTextView.deleteButton.hidden = NO;

    //!详细地址。计算textview的高度
    switch (indexPath.row) {
        case 0:
            titleLabel.text = @"昵称";
            inputTextView.text = [MemberInfoDTO sharedInstance].nickName;
            [inputTextView becomeFirstResponder];

            break;
        case 1:
            titleLabel.text = @"姓名";
            inputTextView.text = [MemberInfoDTO sharedInstance].memberName;
            inputTextView.frame = CGRectMake(90, (44-25)/2, self.view.frame.size.width-80-50-42-20, 25);
            
            otherCell.maleButton.hidden = NO;
            otherCell.femaleButton.hidden = NO;
            if (isMale == YES) {
                [otherCell.maleButton setBackgroundColor:[UIColor blackColor]];
                [otherCell.femaleButton setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
            }else
            {
                [otherCell.maleButton setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
                [otherCell.femaleButton setBackgroundColor:[UIColor blackColor]];
            }

            break;
        case 2:
            
            titleLabel.text = @"手机号";
            inputTextView.text = [MemberInfoDTO sharedInstance].mobilePhone;
            inputTextView.keyboardType = UIKeyboardTypeNumberPad;
            inputTextView.placeholder = @"（仅为联系方式，非登录账号修改。）";

            break;
            
        case 3:
            
            titleLabel.text = @"座机号码";
            inputTextView.text = [MemberInfoDTO sharedInstance].telephone;
            inputTextView.keyboardType = UIKeyboardTypeNumberPad;

            break;
            
        case 4:
            titleLabel.text = @"微信";
            inputTextView.text = [MemberInfoDTO sharedInstance].wechatNo;

            break;
        case 5:
            titleLabel.text = @"省市区";
            
            
            [otherCell addSubview:arrowImageView];
            inputTextView.text = [NSString stringWithFormat:@"%@ %@ %@",[MemberInfoDTO sharedInstance].provinceName, [MemberInfoDTO sharedInstance].cityName,[MemberInfoDTO sharedInstance].countyName];
            inputTextView.deleteButton.hidden = YES;
            
            
            break;

        case 6:
            
            titleLabel.text = @"详细地址";
            inputTextView1.text = [MemberInfoDTO sharedInstance].detailAddress;
            
            inputTextView.hidden = YES;
            [otherCell addSubview: inputTextView1];

//            [self changeTextViewFrame:inputTextView withContent:inputTextView.text];

            break;
            
        case 7:
            titleLabel.text = @"邮编";
            inputTextView.text = [MemberInfoDTO sharedInstance].postalCode;
            inputTextView.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
            
        default:
            break;
    }
    
    return otherCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString * sizeStr = @"";
//    //!昵称。详细地址。计算textview的高度
//    if (indexPath.row == 0) {//!昵称
//       
////        sizeStr = [MemberInfoDTO sharedInstance].nickName;
//        
//    }else if (indexPath.row == 6){//!详细地址
//    
//        sizeStr = [MemberInfoDTO sharedInstance].detailAddress;
//    }
//    
//    if (![sizeStr isEqualToString:@""]) {
//        
//        CGSize size = [self getDetailSize:sizeStr];
//        
//        if (size.height<25) {
//            
//            return 44;
//            
//        }else{
//            
//            return 44 -  25 +size.height+30;
//            
//        }
//    }
    
    return 44;
}

//!改变textView的高度
-(void)changeTextViewFrame:(PersonIofoTextField *)textView withContent:(NSString *)textContent{

    CGSize contentSize = [self getDetailSize:textContent];
    if (contentSize.height >25) {
        
        textView.frame = CGRectMake(100, (44-25)/2, self.view.frame.size.width-100-25, contentSize.height + 30);
        
    }else{
    
        textView.frame = CGRectMake(100, (44-25)/2, self.view.frame.size.width-100-25, 25);
        
    }
}

//!计算内容的高度，动态改变高度
-(CGSize )getDetailSize:(NSString *)str{
    
    
    CGSize detailSize = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-100-25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return detailSize;

}
- (void)maleButtonClicked:(UIButton *)sender
{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];

    UITableViewCell *cell = [self.tabelView cellForRowAtIndexPath:index];
    
    CSPModifyProfileCell *profileCell = (CSPModifyProfileCell*)cell;
    
    [profileCell.maleButton setBackgroundColor:[UIColor blackColor]];
    [profileCell.femaleButton setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
    isMale = NO;
    [MemberInfoDTO sharedInstance].sex = @"1";
}

- (void)femaleButtonClicked:(UIButton *)sender
{

    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    
    UITableViewCell *cell = [self.tabelView cellForRowAtIndexPath:index];
    
    CSPModifyProfileCell *profileCell = (CSPModifyProfileCell*)cell;
    
    [profileCell.femaleButton setBackgroundColor:[UIColor blackColor]];
    [profileCell.maleButton setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
    isMale = YES;
    [MemberInfoDTO sharedInstance].sex = @"2";
    
}

- (IBAction)saveButtonClicked:(id)sender {
    
    if (![CSPUtils checkNickName: [MemberInfoDTO sharedInstance].nickName] && ![[MemberInfoDTO sharedInstance].nickName isEqualToString:@""]) {
        [self.view makeMessage:@"昵称请使用中文、英文或数字的组合" duration:2 position:@"center"];
        return;
    }
    
    if ([CSPUtils countWord:[MemberInfoDTO sharedInstance].nickName]>10) {
        [self.view makeMessage:@"昵称不得超过10个字" duration:2 position:@"center"];
        return;
    }
    
//    if (![CSPUtils checkUserNameFormat:[MemberInfoDTO sharedInstance].memberName] && [[MemberInfoDTO sharedInstance].memberName isEqualToString:@""]) {
//        
//        [self.view makeMessage:@"姓名请使用中文或英文输入姓名" duration:2 position:@"center"];
//        return;
//    }
    
    if ([MemberInfoDTO sharedInstance].memberName == nil || [[MemberInfoDTO sharedInstance].memberName isEqualToString:@""]) {
        
        [self.view makeMessage:@"姓名不能为空" duration:2 position:@"center"];
        return;
    }
    

    if (![CSPUtils checkCharacterFormat:[MemberInfoDTO sharedInstance].memberName]) {
        [self.view makeMessage:@"姓名不得超过10个字" duration:2 position:@"center"];
        return;
    }

    if (![CSPUtils checkUserName:[MemberInfoDTO sharedInstance].memberName]) {
        
        [self.view makeMessage:@"请使用中文或英文输入" duration:2.0f position:@"center"];
        return;
    }

    
//    if ([CSPUtils countWord:[MemberInfoDTO sharedInstance].memberName]>10) {
//        
//        [self.view makeMessage:@"姓名不得超过10个字" duration:2 position:@"center"];
//        return;
//    }
    
    //校验手机号
    if ([[MemberInfoDTO sharedInstance].mobilePhone isEqualToString:@""]) {
        [self.view makeMessage:@"手机号码不能为空" duration:2 position:@"center"];
        return;
    }
    
    if (![CSPUtils checkMobileNumber:[MemberInfoDTO sharedInstance].mobilePhone] ) {
        
        [self.view makeMessage:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    
    }
    
    if ([CSPUtils countWord:[MemberInfoDTO sharedInstance].telephone]>6 && ![[MemberInfoDTO sharedInstance].telephone isEqualToString:@""]) {
        
        [self.view makeMessage:@"座机号码格式错误" duration:2 position:@"center"];
        return;
        
    }
     if (![CSPUtils checkWeChatNumber:[MemberInfoDTO sharedInstance].wechatNo] && ![[MemberInfoDTO sharedInstance].wechatNo isEqualToString:@""]) {
        [self.view makeMessage:@"微信号使用6~20个字母、数字、下划线和减号" duration:2 position:@"center"];
        return;
    }
    //校验详细地址
    
    if (![CSPUtils checkDetailAddressLength:[MemberInfoDTO sharedInstance].detailAddress] && ![[MemberInfoDTO sharedInstance].detailAddress isEqualToString:@""]) {
        
        [self.view makeMessage:@"详细地址需在5-60字之间可输入中文、英文、数字、符号" duration:2 position:@"center"];
        return;
    
    }

    if (![CSPUtils checkPostalCode:[MemberInfoDTO sharedInstance].postalCode] && ![[MemberInfoDTO sharedInstance].postalCode isEqualToString:@""]) {
        
        [self.view makeMessage:@"邮编格式错误" duration:2 position:@"center"];
        return;
    
    }

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForUpdateMemberDataWithUserInfoDTO:[MemberInfoDTO sharedInstance] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"保存失败" duration:2.0 position:@"center"];

    }];
}



#pragma HZAreaPickerViewDelegate @地址进行选择
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (![picker.locate.state isEqualToString:@""]) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }else
    {
        self.areaValue = @"";
    }
    self.inputTextView.text = self.areaValue;
    [MemberInfoDTO sharedInstance].provinceName = picker.locate.state;
    [MemberInfoDTO sharedInstance].cityName = picker.locate.city;
    [MemberInfoDTO sharedInstance].countyName = picker.locate.district;
    
    [MemberInfoDTO sharedInstance].provinceNo = picker.locate.stateId;
    [MemberInfoDTO sharedInstance].cityNo = picker.locate.cityId;
    [MemberInfoDTO sharedInstance].countyNo = picker.locate.districtId;
}
-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
#pragma mark textview delegate

-(BOOL)textFieldShouldBeginEditing:(PersonIofoTextField *)textField
{
    
    
    if (textField.tag == 5) {
        
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:titlePath];
    
        [textField resignFirstResponder];
    
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
    if (self.inputTextView) {
        [self.inputTextView resignFirstResponder];
    }
    
    self.inputTextView = textField;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT *1.1);

    return YES;

}


-(void)textViewTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textField=[notification object];
    switch (textField.tag) {
        case 0:
            
            [MemberInfoDTO sharedInstance].nickName = textField.text;
            
            break;
        case 1:
            
            [MemberInfoDTO sharedInstance].memberName = textField.text;
            break;
        case 2:
            [MemberInfoDTO sharedInstance].mobilePhone = textField.text;
            break;
        case 3:
            [MemberInfoDTO sharedInstance].telephone = textField.text;
            break;
        case 4:
            [MemberInfoDTO sharedInstance].wechatNo = textField.text;
            break;
        case 5:
            
            break;
//        case 6:
//            [MemberInfoDTO sharedInstance].detailAddress = textField.text;
//            
//            break;
        case 7:
            [MemberInfoDTO sharedInstance].postalCode = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

-(void)textViewTextDidChangeOne:(NSNotification *)notification
{
    UITextField *textField=[notification object];
    
    [MemberInfoDTO sharedInstance].detailAddress = textField.text;

}


@end
