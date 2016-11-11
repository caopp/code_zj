//
//  PrepaidGoodsView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PrepaidGoodsView.h"
#import "Masonry.h"
#import "CustomBtn.h"
#import "GUAAlertView.h"

@interface PrepaidGoodsView () <UIScrollViewDelegate ,UITextFieldDelegate>

@property (nonatomic ,strong) UIScrollView *scroll;
//充值等级
@property (nonatomic ,assign) NSInteger topupLevel;
//充值金额
@property (nonatomic ,assign) float topupMoney;


//存放等级V1-V6
@property (nonatomic ,strong) NSMutableArray *levelArr;
//顶部的View
@property (nonatomic ,strong) UIView *topView;
//中间的View可以滑动的
@property (nonatomic ,strong) UIView *middleView;
//底部View
@property (nonatomic ,strong) UIView *bottomView;

//自定义Button按钮
@property (nonatomic ,strong) CustomBtn *recordSel;
//用户当前的等级
@property (nonatomic ,assign) NSInteger userLevel;
/**
 * 其他金额显示
 */
//前面对号图片
@property (nonatomic ,strong) UIButton *iconBtn;
//其他金额
@property (nonatomic ,strong) UILabel *otherMoneyLab;
//￥标记
@property (nonatomic ,strong) UILabel *moneySymbol;
//输入框
@property (nonatomic ,strong) UITextField *textFiled;

@property (nonatomic ,strong) UILabel *titleOtherLab;


@property (nonatomic ,strong) BalanceChangeBto *balanceBto;







@end

@implementation PrepaidGoodsView
- (instancetype)initWithFrame:(CGRect)frame BalanceDto:(BalanceChangeBto *)Dto;

{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scroll = [[UIScrollView alloc] init];
        [self addSubview:scroll];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView)];
        [scroll addGestureRecognizer:tapGesture];
        

        self.scroll = scroll;
        [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-111);
        }];
        
        self.balanceBto = Dto;
        self.userLevel = [self.balanceBto.level integerValue];
        [self generateContent];
        
    }
    return self;
}

- (void)generateContent
{
    UIView *contentView = [[UIView alloc] init];
    [self.scroll addSubview:contentView];
    self.scroll.userInteractionEnabled = YES;
    
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scroll);
        make.top.equalTo(self.scroll.mas_top);
        make.left.equalTo(self.scroll.mas_left);
        make.right.equalTo(self.scroll.mas_right);
        make.bottom.equalTo(self.scroll.mas_bottom).offset(-111);
        make.width.equalTo(self.scroll);
    }];
    
    #pragma mark - 顶部
    //**********************顶部**********************
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    [contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@46);
    }];
    
    //提示等级
    UILabel *promptLevelLab = [[UILabel alloc] init];
    promptLevelLab.text = @"您当前的级别:";
    promptLevelLab.font = [UIFont systemFontOfSize:13];
    
    [topView addSubview:promptLevelLab];
    [promptLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.width.equalTo(@85);
    }];
    
    UILabel *levelLab = [[UILabel alloc] init];
    [topView addSubview:levelLab];
    
    levelLab.text = [NSString stringWithFormat:@"V%@",[self.balanceBto.level stringValue]];
    levelLab.adjustsFontSizeToFitWidth = YES;
    levelLab.textAlignment = NSTextAlignmentRight;
    
    levelLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
    levelLab.font = [UIFont systemFontOfSize:13];
    [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLevelLab.mas_top);
        make.left.equalTo(promptLevelLab.mas_right).offset(4);
        make.width.equalTo(@15);
    }];
    //"|"分割线线
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    [topView addSubview:lineView];
    
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
    [topView addSubview:promptBalanceLab];
    [promptBalanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLevelLab.mas_top);
        make.left.equalTo(lineView.mas_right).offset(15);
        make.width.equalTo(@85);
    }];
    
    //余额
    UILabel *balanceLab = [[UILabel alloc] init];
    BalanceBTO *balance = self.balanceBto.balancDic[@"balance"];
    balanceLab.adjustsFontSizeToFitWidth = YES;
    balanceLab.textAlignment = NSTextAlignmentLeft;
//    balanceLab.backgroundColor = [UIColor redColor];
    
    balanceLab.text = [NSString stringWithFormat:@"￥%.2f",[balance.availableAmount floatValue]];
                       
    [topView addSubview:balanceLab];
    balanceLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
    
    balanceLab.font = [UIFont systemFontOfSize:13];
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBalanceLab.mas_top);
        
        make.left.equalTo(promptBalanceLab.mas_right).offset(2);
        make.right.equalTo(contentView.mas_right).offset(-15);
        
    }];
    
    
    
    
    #pragma mark - 中间
    //**********************中间**********************
    UIView *middleView = [[UIView alloc] init];
    self.middleView = middleView;
    [contentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@432);
        
    }];
    
    int level = 6;// = 6-level;
    NSArray *levelArr = self.balanceBto.prepayListArr;
    
    self.levelArr = [NSMutableArray arrayWithArray:levelArr];
    
    CustomBtn *recordBtn;
    
    for (int i = 0; i<levelArr.count-1;i++ ) {
        if (i == level) {
            return;
        }
        
        PrepayList *list = levelArr[i];
        
        CustomBtn *selBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
        [middleView addSubview:selBtn];
        
        
        selBtn.tag = 10000+i;
        [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recordBtn?recordBtn.mas_bottom:middleView.mas_top).offset(recordBtn?7:0);
            [selBtn.levelBtn setTitle:[NSString stringWithFormat:@"升级V%@",[list.level stringValue]] forState:UIControlStateNormal];
            [selBtn.topUpBtn setTitle:[NSString stringWithFormat:@"充值￥%@",[list.advancePayment stringValue]] forState:UIControlStateNormal];
            make.left.equalTo(middleView.mas_left).offset(15);
//            make.width.equalTo(@306);
            make.width.equalTo(@295);
            make.height.equalTo(@48);
        }];
        recordBtn = selBtn ;
        [selBtn addTarget:self action:@selector(clickSelBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self clickSelBtn:selBtn];
        }
        
    }
    
    //充值其他金额
    UIView *otherTopup = [[UIView alloc] init];
    [middleView addSubview:otherTopup];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topupOtherMoneyTap)];
    [otherTopup addGestureRecognizer:tapGest];
    
    [otherTopup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordBtn.mas_bottom).offset(15);
        make.right.equalTo(middleView.mas_right);
        make.left.equalTo(middleView.mas_left);
        make.height.equalTo(@100);
    }];
    
    
    //其他金额分割线
    UIView *secondLineView = [[UIView alloc] init];
    secondLineView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [otherTopup addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherTopup.mas_top);
        make.right.equalTo(otherTopup.mas_right);
        make.left.equalTo(otherTopup.mas_left);
        make.height.equalTo(@1);
    }];
    
    //提示建议其他方式充值
    UILabel *titleOtherLab = [[UILabel alloc] init];
    self.titleOtherLab = titleOtherLab;
    titleOtherLab.text = @"建议直接在上方选择金额充值，升级至对应等级";
    titleOtherLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    titleOtherLab.font = [UIFont systemFontOfSize:12];
    [otherTopup addSubview:titleOtherLab];
    [titleOtherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineView.mas_bottom).offset(15);
        make.left.equalTo(@15);
    }];

    //其他金额的View
    UIView *otherView = [[UIView alloc] init];
    [otherTopup addSubview:otherView];
    
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleOtherLab.mas_bottom).offset(20);
        make.left.equalTo(otherTopup.mas_left);
        make.width.equalTo(@295);
        make.height.equalTo(@48);
    }];
    
    
    
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconBtn = iconBtn;
    [otherView addSubview:iconBtn];
    [iconBtn setImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"topup_sel"] forState:UIControlStateSelected];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
        make.centerY.equalTo(otherView.mas_centerY);
    }];
    
    //提示“其他金额”
    UILabel *otherMoneyLab = [[UILabel alloc] init];
    self.otherMoneyLab = otherMoneyLab;
    [otherView addSubview:otherMoneyLab];
    
    [otherMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherView.mas_top);
        make.left.equalTo(iconBtn.mas_right).offset(11);
        make.bottom.equalTo(otherView.mas_bottom);
        make.width.equalTo(@105);
    }];
    otherMoneyLab.text = @"其他金额";
    otherMoneyLab.textAlignment = NSTextAlignmentCenter;
    otherMoneyLab.textColor = [UIColor colorWithHexValue:0xffffff alpha:1];
    otherMoneyLab.font = [UIFont systemFontOfSize:16];
    otherMoneyLab.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
    //人民币标志“￥”
    UILabel *moneySymbol = [[UILabel alloc] init];
    self.moneySymbol = moneySymbol;
    [otherView addSubview:moneySymbol];
    
    [moneySymbol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(otherView.mas_centerY);
        make.left.equalTo(otherMoneyLab.mas_right).offset(10);
    }];
    moneySymbol.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    moneySymbol.font = [UIFont fontWithName:@"Hiragino Sans" size:21];
    moneySymbol.text = @"￥";
    
    UITextField* textFiled = [[UITextField alloc] init];
    textFiled.keyboardType = UIKeyboardTypeDecimalPad;
    self.textFiled = textFiled;
    [otherView addSubview:textFiled];
    textFiled.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    textFiled.layer.borderWidth = 1.5f;
    textFiled.delegate = self;
    
    
    
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherView.mas_top);
        make.bottom.equalTo(otherView.mas_bottom);
        make.left.equalTo(moneySymbol.mas_right).offset(10);
        make.right.equalTo(otherView.mas_right);
    }];
    
    
    //底部分割线
    UIView *middleViewBottomLine = [[UIView alloc] init];
    middleViewBottomLine.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [middleView addSubview:middleViewBottomLine];
    [middleViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(middleView.mas_left);
        make.right.equalTo(middleView.mas_right);
        make.bottom.equalTo(otherTopup.mas_bottom).offset(15);
        
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 10;
    NSString *contentStr =  @"1、选填其他金额，将按填写的金额计算可升级的等级。\n2、每次充值的金额不做累加，如需升级至对应等级需一次性\n充值。\n3、充值后立刻升级，并且下月可继续享受本月升级后的等\n级。月初就充值相当于享受2个月的特权！";
    
//    UILabel设置行间距等属性：
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,contentStr.length)];
    
    titleLabel.attributedText = attributedString;

    
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    
    [middleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleViewBottomLine.mas_bottom).offset(15);
        make.left.equalTo(middleView.mas_left).offset(15);
        make.right.equalTo(middleView.mas_right).offset(-15);
        
        
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(middleView.mas_bottom);
        
        
    }];
    #pragma mark - 底部
    //**********************底部**********************
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@111);
        
    }];
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
        make.top.equalTo(confirmTopupBtn.mas_bottom).offset(10);
        make.width.equalTo(confirmTopupBtn.mas_width);
        
    }];
}

/**
 *  确认充值
 */
- (void)confirmTopButton:(UIButton *)btn
{
    /**
     *  判断输入的是否是数字和小数点
     */
    

    /**
     *  充值的金额
     */
    NSString * moneyStr;
    //充值的等级
    int level = 0;
    //skuNo对应的等级 如果是其他金额，skuNoLevel 应该等于-1。
    NSInteger skuNoLevel = -1;
    

    if (self.recordSel) {
        //取出来选中的金额以及等级
        PrepayList *list = self.levelArr[(self.recordSel.tag-10000)];
        moneyStr = [list.advancePayment stringValue];
        //判断等级
        level = [list.level intValue];

        skuNoLevel = [list.level integerValue];
        
        
        
    }else
    {
        
        
        BOOL isGood =  [CSPUtils checkMoneyNumber:self.textFiled.text];
        if (!isGood) {
            GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"只能输入数字和小数点，小数点只能输入后两位。" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
                
            } dismissAction:^{
                
            }];
            [alert show];
            return;
        }

        moneyStr = self.textFiled.text;

        for (int i=0; i<self.levelArr.count-1 ; i++) {
            PrepayList *list = self.levelArr[i];
            if (list.advancePayment.doubleValue) {
                if ([self.textFiled.text doubleValue]>=[list.advancePayment doubleValue]) {
                    level = [list.level intValue];
                    skuNoLevel = -1;
                    break;
//                    moneyStr = [list.advancePayment stringValue];
                }
            }
        }
    }

    float money = moneyStr.floatValue;
    /**
     *  充值金额和等级
     */
    //等级
    self.topupLevel = level;
    //钱数
    self.topupMoney = money;
    
    NSString *titleStr = @"无";
    NSString *messageStr = @"(金额达不到升级标准)";

    /**
     *  大于0小于6的 如果大于6需要单独处理
     */
    if ((level) > 0) {
        if (level >self.userLevel) {
            messageStr = @"";
            titleStr = [NSString stringWithFormat:@"V%d",level];
        }
        if (level>6) {
            titleStr = [NSString stringWithFormat:@"V6"];
             messageStr = @"";;
        }
    }

    if (money<=0) {
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"充值不能为0元" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        [alert show];
        
        return;
        
    }
    

    GUAAlertView *alert = [GUAAlertView alertViewWithTitle:[NSString stringWithFormat:@"确认充值？"] withTitleClor:nil message:[NSString stringWithFormat: @"本次充值￥%.2f\n可升级至:%@\n%@",money,titleStr,messageStr] withMessageColor:[UIColor colorWithHexValue:0x673ab7 alpha:1] oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self buttonTouchedAction:^{
        //代理传值过去

        if ([self.delegate respondsToSelector:@selector(prepaidGoodsLevel:topupMoney:skuNo:)])
        {
            [self.delegate prepaidGoodsLevel:[NSNumber numberWithInteger:self.topupLevel] topupMoney:[NSNumber numberWithDouble:self.topupMoney] skuNo:skuNoLevel];
        }
        
        
//        [self.delegate prepaidGoodsLevel:[NSNumber numberWithInteger:self.topupLevel] topupMoney:[NSNumber numberWithFloat:self.topupMoney];
        

        
        
    } dismissAction:^{
        
    }];
    [alert show];
    
}

//

- (void)commitPrepaidButton:(UIButton *)btn
{
    NSNumber *money;
    
    if (_recordSel) {
        
            //取出来选中的金额以及等级
            PrepayList *list = self.levelArr[(self.recordSel.tag-10000)];
             ;
        money = list.advancePayment;
        
            //判断等级
    }else
    {
        NSString *moneyStr = self.textFiled.text;

        money = [NSNumber numberWithFloat:moneyStr.floatValue];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(PrepaidGoodsJumpVCMoney:skuNo:)]) {
        //直接提交预付货款充值
        [self.delegate PrepaidGoodsJumpVCMoney:money skuNo:-1];
    }
    
//    [self.delegate PrepaidGoodsJumpVCMoney:money];
}
//直接固定金额
- (void)clickSelBtn:(CustomBtn *)btn
{
    PrepayList *preList = self.levelArr[(btn.tag-10000)];
    if (preList.level.intValue<=self.balanceBto.level.intValue) {
        
        NSString *titleContent = [NSString stringWithFormat:@"您已是V%d，请选择更高级别升级。",self.balanceBto.level.intValue];
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:titleContent withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self buttonTouchedAction:^{
            
            
        } dismissAction:^{
    
        }];
        [alert show];
        return;
        
    }
    
    
    [self.textFiled resignFirstResponder];
    
    
    
    
    self.titleOtherLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.iconBtn.selected = NO;
    self.moneySymbol.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.otherMoneyLab.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.textFiled.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    
    if (self.recordSel) {
        self.recordSel.iconBtn.selected = NO;
        self.recordSel.levelBtn.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        self.recordSel.topUpBtn.selected = NO;
        
    }
    btn.iconBtn.selected = YES;
    btn.levelBtn.backgroundColor = [UIColor blackColor];
    btn.topUpBtn.selected = YES;
    
    
    
    self.recordSel = btn;
    
}

/**
 *  其他金额
 */
- (void)topupOtherMoneyTap
{
    if (self.recordSel) {
        self.recordSel.iconBtn.selected = NO;
        self.recordSel.levelBtn.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        self.recordSel.topUpBtn.selected = NO;
 
    }
    self.recordSel = nil;
    
    self.titleOtherLab.textColor = [UIColor blackColor];
    self.iconBtn.selected = YES;
    self.moneySymbol.textColor = [UIColor blackColor];
    self.otherMoneyLab.backgroundColor = [UIColor blackColor];
    self.textFiled.layer.borderColor = [UIColor colorWithHexValue:0x000000 alpha:1].CGColor;
    

}


- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    
    [self animateTextField: textField up: YES];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField

{

    [self animateTextField: textField up: NO];
    
}



- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const int movementDistance = 150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? movementDistance : 0);
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    //    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    self.scroll.contentOffset = CGPointMake(0, movement);
    
    
    [UIView commitAnimations];
    
}





//只允许输入输入小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textFiled resignFirstResponder];
}
/**
 *  结算
 */
- (void)tapUiscrollView
{
    [self.textFiled resignFirstResponder];

}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self topupOtherMoneyTap];
    return YES;
}

@end
