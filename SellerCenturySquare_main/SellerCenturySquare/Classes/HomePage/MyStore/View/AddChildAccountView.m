//
//  AddChildAccountView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "AddChildAccountView.h"
#import "Masonry.h"
#import "HttpManager.h"
#import "CSPUtils.h"

@interface AddChildAccountView ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *shutDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic ,strong) NSString *status;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)openUserBtn:(id)sender;

@end

@implementation AddChildAccountView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    

    
    self.status = @"1";
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    self.scrollView.scrollEnabled = NO;
    

    
    //分割视图
    UIView *placeholderViewAccount = [[UIView alloc] init];
    //添加本View
    [self addSubview:placeholderViewAccount];
    //布局
    [placeholderViewAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameTextField.mas_top);
        make.left.equalTo(self.nameTextField.mas_left);
        make.bottom.equalTo(self.nameTextField.mas_bottom);
        make.width.equalTo(@8);
        
    }];
    

    //设置视图的位置
    self.accountPhoneTextField.leftView = placeholderViewAccount;
    //设置显示模式
    self.accountPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //边框颜色
    self.accountPhoneTextField.layer.borderColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1].CGColor;
    //内容显示方式
    self.accountPhoneTextField.textAlignment =NSTextAlignmentJustified;
    self.accountPhoneTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    //允许修改
    self.accountPhoneTextField.layer.masksToBounds=YES;
    //边框宽度
    self.accountPhoneTextField.layer.borderWidth= 1.0f;
    
    
    
    UIView *placeholderViewName = [[UIView alloc] init];
    [self addSubview:placeholderViewName];
    
    [placeholderViewName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameTextField.mas_top);
        make.left.equalTo(self.nameTextField.mas_left);
        make.bottom.equalTo(self.nameTextField.mas_bottom);
        make.width.equalTo(@8);
        
    }];
    self.nameTextField.leftView = placeholderViewName;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.nameTextField.layer.borderColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1].CGColor;
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.layer.masksToBounds = YES;
    

    
    //关闭按钮背景
    self.shutDownBtn.backgroundColor =  [UIColor colorWithHex:0x000000];
    //消圆
    self.shutDownBtn.layer.cornerRadius = 2;
    //默认选中
    self.shutDownBtn.selected = YES;
    //选中后不允许编辑
    self.shutDownBtn.enabled = NO;
    //允许修改
    self.shutDownBtn.layer.masksToBounds = YES;
    
    //开启按钮背景颜色
    self.openBtn.backgroundColor = [UIColor colorWithHex:0xe2e2e2];
    //消圆
    self.openBtn.layer.cornerRadius = 2;
    //允许修改
    
    
    
}

/**
 *  关闭按钮的点击事件
 *
 *  @param sender
 */
- (IBAction)shutDownUserBtn:(id)sender {
    
    
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    self.openBtn.selected = !btn.selected;
   
    self.status = @"1";
    
    
    if (btn.selected) {
        self.openBtn.enabled = YES;
        btn.enabled = NO;
//        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        btn.backgroundColor = [UIColor colorWithHex:0x000000 alpha:1];
        self.openBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
    }else
    {
        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
//        self.openBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.openBtn.backgroundColor = [UIColor colorWithHex:0x000000];
        

    }
    

}


/**
 *  打开按钮的点击事件
 *
 *  @param sender
 */
- (IBAction)openUserBtn:(id)sender {
    self.status = @"0";
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    self.shutDownBtn.selected = !btn.selected;
    if (btn.selected) {
        
        self.shutDownBtn.enabled = YES;
        btn.enabled = NO;
        self.shutDownBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];

//        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        btn.backgroundColor = [UIColor colorWithHex:0x000000];
    }else
    {
//        self.shutDownBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.shutDownBtn.backgroundColor = [UIColor colorWithHex:0x000000];

        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
    }
}


/**
 *  保存按钮的点击事件
 *
 *  @param sender
 */
- (void)saveAddMessage
{
//    [self.delegate showWait];
    

    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        //dispatch_async 异步开启任务
        //dispatch_get_global_queue 读取GCD中的一条线程，后面的参数为0则是开启默认线程，GCD提供3条线程，高优先级别线程，默认线程，以及低级别线程
        //判断账号的长度为0时 提示
        
        NSString *alertTitle =@"";
 
        if (self.accountPhoneTextField.text.length == 0) {
            alertTitle = @"请填写账号";
            
        }else if (![CSPUtils checkMobileNumber:self.accountPhoneTextField.text])//判断输入的是否符合标准
        {
            alertTitle= @"请填写手机号作为账号";
            
        }else if ((self.nameTextField.text.length!=0 && ![CSPUtils checkAccountUserName:self.nameTextField.text]))
        {
            
            
            alertTitle = @"昵称应为2-10个汉字,字母、数字、下划线或减号";
            
        }
        
        
        
        else
        {
            
//            [self.delegate hidenView];
            
            
            
            if (self.openBtn.selected) {
                
                NSString *alertMessage = [NSString stringWithFormat:@"平台将向手机号 %@,发送开通提醒，并发送初始登录密码",self.accountPhoneTextField.text];
                
                UIAlertView *alertOpen = [[UIAlertView alloc] initWithTitle:@"确定新增子账号？" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertOpen.tag = 10001;
                [alertOpen show];
                
                
                
            }else
            {
                
                NSString *alertMessage = [NSString stringWithFormat:@"目前为关闭状态，在您选择开启后，将向新增账号发送开通提醒。"];
                
                UIAlertView *alertShutUp = [[UIAlertView alloc] initWithTitle:@"确定新增子账号？" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertShutUp.tag = 10002;
                
                [alertShutUp show];
            }
        }
        
            if (alertTitle.length != 0) {
 
//                
//                UIView *titleView = [[UIView alloc] init];
//                
//                
//                titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//                
//                [self addSubview:titleView];
//                [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.equalTo(self);
//                }];
//                
//                UILabel *titleLabel  =[[UILabel alloc] init];
//                [titleView addSubview:titleLabel];
//                
//                titleLabel.font = [UIFont systemFontOfSize:13];
//                titleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
//                
//                
//                titleLabel.text = alertTitle;
//                
//                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(titleView.mas_centerX);
//                    make.centerY.equalTo(titleView.mas_centerY);
//                }];
                
                
                [self makeMessage:alertTitle duration:2 position:@"center"];
                
                
            }
}


 - (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
 
    return YES;

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.delegate AddChildAccountNickName:self.nameTextField.text merchantAccount:self.accountPhoneTextField.text status:self.status];

    }
   
}

@end
