//
//  PrepaidGoodsMaxView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PrepaidGoodsMaxView.h"
#import "Masonry.h"
#import "GUAAlertView.h"
@interface PrepaidGoodsMaxView ()<UITextFieldDelegate>

//对号按钮
@property (nonatomic ,strong) UIButton *iconBtn;
//显示其他金额
@property (nonatomic ,strong) UILabel *otherMoneyLab;
//输入框
@property (nonatomic ,strong) UITextField *textFiled;

//显示用户当前的等级
@property (nonatomic ,strong) UILabel* levelLab;

//显示用户当前的余额
@property (nonatomic ,strong) UILabel *balanceLab;

@end
@implementation PrepaidGoodsMaxView
- (instancetype)init
{
    if (self = [super init]) {
        [self makeUI];
        
          }
    return self;
}

- (void) makeUI{
    
    //提示等级
    UILabel *promptLevelLab = [[UILabel alloc] init];
    promptLevelLab.text = @"您当前的级别:";
    promptLevelLab.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:promptLevelLab];
    [promptLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.width.equalTo(@85);
        
    }];

    UILabel *levelLab = [[UILabel alloc] init];
    self.levelLab = levelLab;
    [self addSubview:levelLab];
    levelLab.text = @"V0";
    levelLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
    levelLab.font = [UIFont systemFontOfSize:13];
    [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLevelLab.mas_top);
        make.left.equalTo(promptLevelLab.mas_right).offset(4);
        make.width.equalTo(@20);
    }];
    //"|"分割线线
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelLab.mas_right).offset(16);
        make.centerY.equalTo(levelLab.mas_centerY);
        make.width.equalTo(@0.5);
        make.height.equalTo(@9);
    }];
    
    
    //预付货余额提示
    UILabel *promptBalanceLab = [[UILabel alloc] init];
    promptBalanceLab.text = @"预付货款余额:";
    promptBalanceLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:promptBalanceLab];
    [promptBalanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLevelLab.mas_top);
        make.left.equalTo(lineView.mas_right).offset(15);
        make.width.equalTo(@85);
    }];
    
    //余额
    UILabel *balanceLab = [[UILabel alloc] init];
    self.balanceLab = balanceLab;
    balanceLab.text = @"0";
    balanceLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
    balanceLab.adjustsFontSizeToFitWidth = YES;
    balanceLab.minimumFontSize = 6;
    balanceLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:balanceLab];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBalanceLab.mas_top);
        
        make.left.equalTo(promptBalanceLab.mas_right).offset(4);
        make.right.equalTo(self.mas_right).offset(15);
        
    }];
    
    //其他金额的View
    UIView *otherView = [[UIView alloc] init];
    [self addSubview:otherView];
    
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(promptBalanceLab.mas_bottom).offset(22);
        make.bottom.equalTo(self.mas_centerY).offset(-10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@96);
    }];
    UILabel *titlePromptMoney = [[UILabel alloc] init];
    titlePromptMoney.font = [UIFont systemFontOfSize:22];
    titlePromptMoney.text = @"充值金额";
    titlePromptMoney.textAlignment = NSTextAlignmentCenter;
    [otherView addSubview:titlePromptMoney];
    [titlePromptMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherView.mas_top);
        make.left.equalTo(otherView.mas_left);
        make.right.equalTo(otherView.mas_right);
    }];
    
    UIView *moneyView = [[UIView alloc] init];
    [otherView addSubview:moneyView];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlePromptMoney.mas_bottom).offset(20);
        make.left.equalTo(otherView.mas_left).offset(20);
        make.right.equalTo(otherView.mas_right).offset(-20);
        make.height.equalTo(@48);
    }];
    UILabel *moneyMarkLab = [[UILabel alloc] init];
    moneyMarkLab.text = @"￥";
    moneyMarkLab.font = [UIFont systemFontOfSize:20];
    
    [moneyView addSubview:moneyMarkLab];
    
    [moneyMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyView.mas_left);
        make.top.equalTo(moneyView.mas_top);
        make.height.equalTo(@48);
        make.width.equalTo(@20);
        
    }];
    UITextField *moneyTF = [[UITextField alloc] init];
    self.textFiled = moneyTF;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.delegate = self;
    
    moneyTF.layer.borderWidth = 0.5;
    moneyTF.layer.borderColor = [UIColor blackColor].CGColor;
    
    [moneyView addSubview:moneyTF];
    [moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_top);
        make.left.equalTo(moneyMarkLab.mas_right).offset(10);
        make.bottom.equalTo(moneyView.mas_bottom);
        make.right.equalTo(moneyView.mas_right).offset(-15);
    }];
    
    
                


    
//    
//    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.iconBtn = iconBtn;
//    iconBtn.selected = YES;
//    [otherView addSubview:iconBtn];
//    [iconBtn setImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
//    [iconBtn setImage:[UIImage imageNamed:@"topup_sel"] forState:UIControlStateSelected];
//    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.height.equalTo(@21);
//        make.width.equalTo(@21);
//        make.centerY.equalTo(otherView.mas_centerY);
//    }];
//    
//    //提示“其他金额”
//    UILabel *otherMoneyLab = [[UILabel alloc] init];
//    self.otherMoneyLab = otherMoneyLab;
//    [otherView addSubview:otherMoneyLab];
//    
//    [otherMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(otherView.mas_top);
//        make.left.equalTo(iconBtn.mas_right).offset(11);
//        make.bottom.equalTo(otherView.mas_bottom);
//        make.width.equalTo(@105);
//    }];
//    otherMoneyLab.text = @"其他金额";
//    otherMoneyLab.textAlignment = NSTextAlignmentCenter;
//    otherMoneyLab.textColor = [UIColor colorWithHexValue:0xffffff alpha:1];
//    otherMoneyLab.font = [UIFont systemFontOfSize:16];
//    otherMoneyLab.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
//    
//    
//    //人民币标志“￥”
//    UILabel *moneySymbol = [[UILabel alloc] init];
//    [otherView addSubview:moneySymbol];
//    
//    [moneySymbol mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(otherView.mas_centerY);
//        make.left.equalTo(otherMoneyLab.mas_right).offset(10);
//    }];
//    moneySymbol.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
//    moneySymbol.font = [UIFont fontWithName:@"Hiragino Sans" size:21];
//    moneySymbol.text = @"￥";
//    
//    UITextField* textFiled = [[UITextField alloc] init];
//    self.textFiled = textFiled;
//    [otherView addSubview:textFiled];
//    textFiled.layer.borderColor = [UIColor colorWithHexValue:0x000000 alpha:1].CGColor;
//    textFiled.layer.borderWidth = 1.5f;
//    textFiled.delegate = self;
//    
//    
//    
//    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(otherView.mas_top);
//        make.bottom.equalTo(otherView.mas_bottom);
//        make.left.equalTo(moneySymbol.mas_right).offset(10);
//        make.width.equalTo(@131);
//    }];
//    
//    
    
#pragma mark - 底部
    //**********************底部**********************
    UIView *bottomView = [[UIView alloc] init];
//    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@111);
        
    }];
    
    //确认充值按钮
    UIButton *confirmTopupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:confirmTopupBtn];
    confirmTopupBtn.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [confirmTopupBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [confirmTopupBtn addTarget:self action:@selector(confirmTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [confirmTopupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(15);
        make.top.equalTo(bottomView.mas_top);
        make.right.equalTo(bottomView.mas_right).offset(-15);
        make.height.equalTo(@45);
        
    }];
    
    //直接提交预付货款转账信息
    UIButton *commitPrepaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:commitPrepaidBtn];
    commitPrepaidBtn.layer.borderWidth = 1;
    commitPrepaidBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [commitPrepaidBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitPrepaidBtn setTitle:@"直接提交预付货款转账信息" forState:UIControlStateNormal];
    [commitPrepaidBtn addTarget:self action:@selector(commitPrepaidButton:) forControlEvents:UIControlEventTouchUpInside];
    [commitPrepaidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmTopupBtn.mas_left);
        make.height.equalTo(confirmTopupBtn.mas_height);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.width.equalTo(confirmTopupBtn.mas_width);
        
    }];
}

/**
 *  赋值给当前页面
 *
 *  @param balanceBto banlance对象
 */
- (void)setBalanceBto:(BalanceChangeBto *)balanceBto
{
 
    //等级
    self.levelLab.text = [NSString stringWithFormat:@"V%@",balanceBto.level.stringValue];
    BalanceBTO *bto = balanceBto.balancDic[@"balance"];
    //金额
    self.balanceLab.text = [NSString stringWithFormat:@"¥%.2lf",[bto.availableAmount doubleValue]];
}

//只允许输入输入小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ([textField.text doubleValue] >=9999999) {
//        
//        return NO;
//    }

    //判断输入个数小99999999
    
    if (range.location > 6) {
        return NO;
    }

       NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}


//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textFiled resignFirstResponder];
}


/**
 *  确认充值按钮
 */
- (void)confirmTopButton:(UIButton *)btn
{
    CGFloat money = self.textFiled.text.floatValue;
    if (money<=0) {
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"充值不能为0元" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        [alert show];
        
        return;
    }
    
    BOOL isGood =  [CSPUtils checkMoneyNumber:self.textFiled.text];
    if (!isGood) {
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"只能输入数字和小数点，小数点只能输入后两位。" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        
        [alert show];
        
        return;
    }
    
    [self.delegate prepaidGoodsMaxMoney:[NSNumber numberWithDouble:self.textFiled.text.doubleValue] skuNO:-1];
}

/**
 *  直接提交预付货款转账信息
 */
- (void)commitPrepaidButton:(UIButton *)btn
{
    [self.delegate PrepaidGoodsMaxJumpVC:[NSNumber numberWithDouble:self.textFiled.text.doubleValue] skuNo:-1];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


