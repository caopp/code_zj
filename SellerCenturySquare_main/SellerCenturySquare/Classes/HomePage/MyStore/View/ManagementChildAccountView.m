//
//  AddChildAccountView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ManagementChildAccountView.h"
#import "Masonry.h"
#import "CSPUtils.h"
#import "GUAAlertView.h"

#import "UIColor+HexColor.h"
@interface ManagementChildAccountView ()<UIAlertViewDelegate>
{
    GUAAlertView *alert;
}

// 账号
@property (weak, nonatomic) IBOutlet UILabel *AccountLabel;

//昵称- 可修改
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

//开启按钮
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

//关闭
@property (weak, nonatomic) IBOutlet UIButton *shutDownBtn;

@property (nonatomic ,strong) NSMutableDictionary *dataDict;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *firstOpenFlag;
@property (nonatomic ,strong) NSString *merchantAccount;


@end

@implementation ManagementChildAccountView
- (void)awakeFromNib
{
    
  
    
    
    self.status = @"1";
    self.dataDict = [NSMutableDictionary dictionary];
    
    
    //分割视图
    UIView *placeholderViewAccount = [[UIView alloc] init];
    //添加本View
    [self addSubview:placeholderViewAccount];
    placeholderViewAccount.frame = CGRectMake(0, 0, 8, 40);
    
    //布局
    [placeholderViewAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameTextField.mas_top);
        make.left.equalTo(self.nameTextField.mas_left);
        make.bottom.equalTo(self.nameTextField.mas_bottom);
        make.width.equalTo(@8);
        
    }];
    //设置输入框的左视图显示
    self.nameTextField.leftView = placeholderViewAccount;
    //设置显示模式
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //边框颜色
    self.nameTextField.layer.borderColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1].CGColor;
    //显示模式
    self.nameTextField.textAlignment =NSTextAlignmentJustified;
    //允许修改
    self.nameTextField.layer.masksToBounds=YES;
    //边框宽度
    self.nameTextField.layer.borderWidth= 1.0f;
    
    
    
    //关闭按钮背景
    self.shutDownBtn.backgroundColor =  [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1];
    //消圆
    self.shutDownBtn.layer.cornerRadius = 2;
    //默认选中
    self.shutDownBtn.selected = YES;
    //选中后不允许编辑
    self.shutDownBtn.enabled = NO;
    //允许修改
    self.shutDownBtn.layer.masksToBounds = YES;
    
    //开启按钮背景颜色
    self.openBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    //消圆
    self.openBtn.layer.cornerRadius = 2;
    //允许修改
    self.openBtn.layer.masksToBounds = YES;
 
}


/**
 *  开启按钮的点击事件
 *
 *  @param sender 传入对象
 */
- (IBAction)openUserBtn:(id)sender {
    
   
    self.status = @"0";
    
    UIButton *btn = (UIButton *)sender;
    //设置开启按钮的状态
    btn.selected = YES;
    
    //设置关闭按钮的状态
    self.shutDownBtn.selected = !btn.selected;
    
    //判断如果开启按钮选中状态，则默认不允许交互  更改关闭按钮 与它相反
    if (btn.selected) {
        
        //关闭按钮允许交互
        self.shutDownBtn.enabled = YES;
        //开启按钮不允许交互
        btn.enabled = NO;
        //设置关闭按钮背景颜色
        self.shutDownBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
        //设置开启按钮的背景色
//        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        btn.backgroundColor = [UIColor colorWithHex:0x000000];
        
    }else
    {
//        self.shutDownBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.shutDownBtn.backgroundColor = [UIColor colorWithHex:0x000000];
        
        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
    }
    
    NSLog(@"打开");

    
    
}
/**
 *  关闭按钮 与开始按钮所加注释一样
 *
 *  @param sender
 */
- (IBAction)shutUpUserBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    self.openBtn.selected = !btn.selected;
    self.status = @"1";
    if (btn.selected) {
        self.openBtn.enabled = YES;
        btn.enabled = NO;
//        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        btn.backgroundColor = [UIColor colorWithHex:0x000000];
        self.openBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
    }else
    {
        btn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
//        self.openBtn.backgroundColor =[UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.openBtn.backgroundColor = [UIColor colorWithHex:0x000000];
        
    }
}

- (void)saveChangeMessage
{
    
    
        //dispatch_async 异步开启任务
        //dispatch_get_global_queue 读取GCD中的一条线程，后面的参数为0则是开启默认线程，GCD提供3条线程，高优先级别线程，默认线程，以及低级别线程
        //判断账号的长度为0时 提示
        
        NSString *alertTitle =@"";
       if ((self.nameTextField.text.length!=0 && ![CSPUtils checkAccountUserName:self.nameTextField.text]))
        {
            
            
            alertTitle = @"昵称应为2-10个汉字,字母、数字、下划线或减号";
            
        }else    if (self.nameTextField.text.length ==0) {
        alertTitle= @"昵称应为2-10个汉字,字母、数字、下划线或减号";
    }
            
            if (alertTitle.length != 0) {
                
                if (alert) {
                    [alert removeFromSuperview];
                }
                alert = [GUAAlertView alertViewWithTitle:alertTitle withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
                    
                } dismissAction:^{
                    
                }];
                [alert show];
                return;

                
            }else
            {
                if (alert) {
                    [alert removeFromSuperview];
                }
                alert = [GUAAlertView alertViewWithTitle:@"确定保存修改？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{

                    [self.delegate  accpetToSendnickName:self.nameTextField.text status:self.status firstOpenFlag:self.firstOpenFlag merchantAccount:self.AccountLabel.text];

                    
                } dismissAction:^{
                    
                }];
                [alert show];

                
            }

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        [self.dataDict setObject:self.nameTextField.text forKey:@"nickName"];
        [self.dataDict setObject:self.status  forKey:@"status"];
        [self.delegate  accpetToSendnickName:self.nameTextField.text status:self.status firstOpenFlag:self.firstOpenFlag merchantAccount:self.AccountLabel.text];
    }
   
}

/**
 *  接受从子账户显示页面传过来单个cell的详细信息
 *
 *  @param dict 数据
 */

- (void)accpetToSendData:(NSDictionary *)dict
{

    
    self.nameTextField.text = dict[@"nickName"];
    self.AccountLabel.text = dict[@"merchantAccount"];
    NSString *status = dict[@"enableFlag"];
    self.firstOpenFlag = dict[@"firstOpenFlag"];
    
    
    
    if ([status isEqualToString:@"0"]) {
        self.openBtn.selected = YES;
        self.openBtn.enabled = NO;
        self.shutDownBtn.selected = NO;
        self.shutDownBtn.enabled = YES;
        
        
//        self.openBtn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.openBtn.backgroundColor = [UIColor colorWithHex:0x000000];
        self.shutDownBtn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];

    }
    else
    {
            //  1.关闭
        
        self.shutDownBtn.selected = NO;
        self.shutDownBtn.enabled = YES;
        
        self.openBtn.selected = YES;
        self.shutDownBtn.enabled = NO;
        
        
        self.openBtn.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
        self.shutDownBtn.backgroundColor = [UIColor colorWithHex:0x000000];
    }
}


@end
