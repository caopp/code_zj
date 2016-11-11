//
//  BankCardViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankCardViewController.h"
#import "Masonry.h"
#import "BankPaymentListDTO.h"
#import "UIImageView+WebCache.h"
#import "OrderAddDTO.h"
#import "CustomBarButtonItem.h"
#import "LoginDTO.h"
#import "PaymentDetailController.h"
#import "PromptChooseBankView.h"
#import "MJExtension.h"
#import "CSPUtils.h"
@interface BankCardViewController ()<UITextFieldDelegate ,PromptChooseBankDelegate>
{
    UILabel *chooseBankLabel;
    
}
@property (nonatomic ,strong) BankPaymentListDTO *bankPayDto;
//选择的银行
@property (nonatomic ,copy) NSString *selectedObject;
//银行代码
@property (nonatomic ,copy) NSString *bankCode;

@property (nonatomic ,strong) UILabel *outBankNameContent;
@property (nonatomic ,strong) UITextField *rollBankNameTF;
@property (nonatomic ,strong) UITextField *rollAmountTF;//钱数
@property (nonatomic ,strong) UIScrollView *scroll;
@property (nonatomic ,strong) UIButton *commintBtn;
@property (nonatomic ,strong) NSMutableArray *bankList;



@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];

    self.title = @"确认银行卡转账信息";

    self.view.backgroundColor = [UIColor whiteColor];
    [HttpManager sendHttpRequestForbankCardMessageSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        BankPaymentListDTO *bankDto = [[BankPaymentListDTO alloc] init];
        [bankDto setDictFrom:dic[@"data"]];
        self.bankPayDto = bankDto;
        DebugLog(@"dic = %@", dic);

        [self makeUI];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@", error);
        
    }];
}
- (void)makeUI
{
    BankAccListDTO *accListDto = [self.bankPayDto.bankAccList lastObject];
    
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    [self.view addSubview:scroll];
    self.scroll = scroll;
    scroll.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoradTakebBack)];
    [scroll addGestureRecognizer:keyTop];
    
    
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scroll addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        
    }];
    
    
    
    //推荐显示的View
    UIView *recommendedView = [[UIView alloc] init];
    
    [contentView addSubview:recommendedView];
    [recommendedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.top.equalTo(contentView.mas_top);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@55);
    }];
    
    UIImageView *commendImageView = [[UIImageView alloc] init];
    
    [recommendedView addSubview:commendImageView];
    commendImageView.image = [UIImage imageNamed:@"commend_pay"];
    
    [commendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendedView.mas_left);
        make.top.equalTo(recommendedView.mas_top).offset(15);
        make.height.equalTo(@28);
        make.width.equalTo(@33);
    }];
    
    UILabel *commendLab = [[UILabel alloc] init];
    commendLab.numberOfLines = 10;
    
    commendLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    commendLab.font = [UIFont systemFontOfSize:11];
    commendLab.text = @"";
    [recommendedView addSubview:commendLab];
    [commendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commendImageView.mas_right).offset(13);
        make.top.equalTo(commendImageView.mas_top);
    }];
    
    //    UILabel设置行间距等属性：
    NSString *contentStr = @"人工审核对帐，非实时。\n工作时间9:30-18:30,核帐约1小时。\n安全无限额，免手续费，大额支付首选。";
    
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,contentStr.length)];
    
    commendLab.attributedText = attributedString;
    UIView *recommendBottomView = [[UIView alloc] init];
    [recommendedView addSubview:recommendBottomView];
    recommendBottomView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [recommendBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(recommendedView.mas_bottom).offset(2);
        make.height.equalTo(@0.5f);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(recommendedView.mas_right);
        
    }];
    
    //第一步
    UIView *firstStepView= [[UIView alloc] init];
    
    [contentView addSubview:firstStepView];
    [firstStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendedView.mas_bottom);
        make.height.equalTo(@44);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        
        
    }];
    UILabel *titleLab = [[UILabel alloc] init];
    [firstStepView addSubview:titleLab];
    titleLab.text = @"第1步:请先转账到叮咚欧品的银行账号";
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstStepView.mas_centerY);
        
        make.left.equalTo(@15);
    }];

    UIView *firstStepBottomView = [[UIView alloc] init];
    [firstStepView addSubview:firstStepBottomView];
    firstStepBottomView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [firstStepBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(firstStepView.mas_bottom);
        make.left.equalTo(firstStepView.mas_left);
        make.right.equalTo(firstStepView.mas_right);
        make.height.equalTo(@0.5f);
        
    }];

    

  //银行账户 View
    UIView *bankView = [[UIView alloc] init];
    [contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.height.equalTo(@100);
        make.top.equalTo(firstStepView.mas_bottom);
        make.right.equalTo(contentView.mas_right);
    }];
    
    
    //银行卡的持有人  第二行
    UILabel *bankAccoutLab = [[UILabel alloc] init];
    [bankView addSubview:bankAccoutLab];
    
    
    UIImageView *bankMark = [[UIImageView alloc] init];
    [bankMark sd_setImageWithURL:[NSURL URLWithString:accListDto.bankPic]];
    [bankView addSubview:bankMark];
    [bankMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankAccoutLab.mas_centerY);
        make.left.equalTo(bankView.mas_left).offset(-3);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    

    
    //银行卡账号  第一行
    
    //G公司名称
    UILabel *bankNameLab = [[UILabel alloc] init];
    bankNameLab.textAlignment = NSTextAlignmentRight;
    
    [bankView addSubview:bankNameLab];
    bankNameLab.text = @"公司名称:";
    
    
    bankNameLab.font = [UIFont systemFontOfSize:13];
    
    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_top).offset(12);
        make.left.equalTo(bankMark.mas_right).offset(10);
        make.width.equalTo(@60);
        
    }];
    
    //公司名称所填写的内容
    UILabel *bankNameContentLab = [[UILabel alloc] init];
    bankNameContentLab.text =accListDto.accountName;
    bankNameContentLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    
    bankNameContentLab.font = [UIFont systemFontOfSize:13];
    [bankView addSubview:bankNameContentLab];
    bankNameContentLab.textAlignment = NSTextAlignmentLeft;
    [bankNameContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLab.mas_right).offset(5);
        make.top.equalTo(bankNameLab.mas_top);
    }];
    
    //公司账号:第二行
    
//    UILabel *bankAccoutLab = [[UILabel alloc] init];
    [bankView addSubview:bankAccoutLab];
    bankAccoutLab.textAlignment = NSTextAlignmentRight;
    bankAccoutLab.font = [UIFont systemFontOfSize:13];
    bankAccoutLab.text =  @"账号:";
    
//    bankAccoutLab.font = [UIFont fontWithName:@"TwCenMT-Regular" size:16];
//    bankAccoutLab.text =  [self cutoutCharacterStr:@"1234567887654321123123"];
    
    [bankAccoutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNameLab.mas_bottom).offset(7);
        make.right.equalTo(bankNameLab.mas_right);
    }];
    
    //公司账号内容
    UILabel *bankAccountContentLab = [[UILabel alloc] init];
    bankAccountContentLab.textAlignment = NSTextAlignmentLeft;
   bankAccountContentLab.font = [UIFont fontWithName:@"TwCenMT-Regular" size:16];

    if (accListDto.account) {
    bankAccountContentLab.text =[self cutoutCharacterStr: accListDto.account];
    }

    bankAccountContentLab.adjustsFontSizeToFitWidth = YES;
    

    [bankView addSubview:bankAccountContentLab];
    [bankAccountContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameContentLab.mas_left);
        make.top.equalTo(bankAccoutLab.mas_top);
        make.right.equalTo(bankView.mas_right).offset(-15);
        
    }];
    
    
    //第三行：开户行
    UILabel *bankAccountNameLab = [[UILabel alloc] init];
    [bankView addSubview:bankAccountNameLab];
    bankAccountNameLab.text = @"开户行:";
    bankAccountNameLab.font = [UIFont systemFontOfSize:13];
    bankAccountNameLab.textAlignment = NSTextAlignmentRight;
    [bankAccountNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAccoutLab.mas_bottom).offset(7);
        make.right.equalTo(bankNameLab.mas_right);
        
    }];

    
    //开户行内容
    UILabel *bankAccountNameContentLab = [[UILabel alloc] init];
    bankAccountNameContentLab.textAlignment = NSTextAlignmentLeft;
    bankAccountNameContentLab.text = accListDto.bankName;
    bankAccountNameContentLab.font = [UIFont systemFontOfSize:13];
    bankAccountNameContentLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];

    [bankView addSubview:bankAccountNameContentLab];
    [bankAccountNameContentLab  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAccountNameLab.mas_top);
        make.left.equalTo(bankNameContentLab.mas_left);
    }];
    
    
    
    
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    promptLabel.font = [UIFont systemFontOfSize:9];
//    promptLabel.text = @"安全无限额，免手续费，大额支付首选。";
    [bankView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.mas_left);
        make.bottom.equalTo(bankView.mas_bottom).offset(-10);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    
    [bankView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.mas_left);
        make.right.equalTo(bankView.mas_right).offset(-15);
        make.height.equalTo(@0.5f);
        make.bottom.equalTo(bankView.mas_bottom);
        
    }];
    
    
    UIView *intervalOneView = [[UIView alloc] init];
    intervalOneView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [contentView addSubview:intervalOneView];
    [intervalOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@10);
    }];
    
    
    //第二步
    
    UIView *secondStepView= [[UIView alloc] init];
    
    [contentView addSubview:secondStepView];
    [secondStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(intervalOneView.mas_bottom);
        make.height.equalTo(@44);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        
        
    }];
    UILabel *titleSecondLab = [[UILabel alloc] init];
    [firstStepView addSubview:titleSecondLab];
    titleSecondLab.text = @"第2步：请提交确认转账的金额";
    titleSecondLab.font = [UIFont systemFontOfSize:13];
    titleSecondLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    [titleSecondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondStepView.mas_centerY);
        
        make.left.equalTo(@15);
    }];
    

    UIView *secondStepBottomView = [[UIView alloc] init];
    [secondStepView addSubview:secondStepBottomView];
    secondStepBottomView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [secondStepBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(secondStepView.mas_bottom);
        make.left.equalTo(secondStepView.mas_left);
        make.right.equalTo(secondStepView.mas_right);
        make.height.equalTo(@0.5f);
        
    }];

    
    //转出银行
    UITapGestureRecognizer *rollTapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickRollTapView)];
    
    UIView *rollOutbank = [[UIView alloc] init];
    
    [contentView addSubview:rollOutbank];
    [rollOutbank addGestureRecognizer:rollTapView];
//    rollOutbank.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [rollOutbank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondStepView.mas_bottom);
        make.height.equalTo(@43);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
    }];
    UILabel *outBankNameLabel = [[UILabel alloc] init];
    [rollOutbank addSubview:outBankNameLabel];
    outBankNameLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    outBankNameLabel.text = @"转出银行:";
    outBankNameLabel.textAlignment = NSTextAlignmentLeft;
    outBankNameLabel.font = [UIFont systemFontOfSize:14];
    [outBankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rollOutbank.mas_centerY);
        make.left.equalTo(@15);
        make.width.equalTo(@71);

    }];
    
    //选择选中的银行
    
    UILabel *outBankNameContent = [[UILabel alloc] init];
    self.outBankNameContent = outBankNameContent;
    
    chooseBankLabel = [[UILabel alloc] init];
    [rollOutbank addSubview:chooseBankLabel];
    
    
    [rollOutbank addSubview:outBankNameContent];
    outBankNameContent.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    outBankNameContent.font = [UIFont systemFontOfSize:14];
    if (self.creditDto) {
        outBankNameContent.text = self.creditDto.bankName;
        self.selectedObject = self.creditDto.bankName;
    }
    
    [outBankNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rollOutbank.mas_centerY);
        make.left.equalTo(outBankNameLabel.mas_right).offset(15);
//        make.width.equalTo(@100);
        make.right.equalTo(chooseBankLabel.mas_left).offset(-10);
        
        
    }];
    
    UIImageView *bankImage = [[UIImageView alloc] init];
    [rollOutbank addSubview:bankImage];
    
    
 
    chooseBankLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    chooseBankLabel.text = @"请选择银行";
    chooseBankLabel.font = [UIFont systemFontOfSize:13];
    [chooseBankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rollOutbank.mas_centerY);
        make.right.equalTo(bankImage.mas_left).offset(-10);
    }];
    
    bankImage.image = [UIImage imageNamed:@"balancePay"];
    [bankImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rollOutbank.mas_right).offset(-14);
        make.centerY.equalTo(rollOutbank.mas_centerY);
        make.height.equalTo(@13);
        make.width.equalTo(@8);
    }];
    //底部分割线
    UIView *rollBankBottomLine = [[UIView alloc] init];
    [rollOutbank addSubview:rollBankBottomLine];
    rollBankBottomLine.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [rollBankBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollOutbank.mas_left);
        make.right.equalTo(rollOutbank.mas_right);
        make.bottom.equalTo(rollOutbank.mas_bottom);
        make.height.equalTo(@0.5f);
    }];
    
    
    //转账账户名
    UIView *rollBankNameView = [[UIView alloc] init];
    [contentView addSubview:rollBankNameView];
    [rollBankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.top.equalTo(rollOutbank.mas_bottom);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@44);
    }];
    
    UILabel *rollBankNameLab = [[UILabel alloc] init];
    [rollBankNameView addSubview:rollBankNameLab];
    [rollBankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollBankNameView.mas_left).offset(15);
        make.centerY.equalTo(rollBankNameView.mas_centerY);

    }];
    rollBankNameLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    rollBankNameLab.text = @"转出银行卡开户人姓名:";
    rollBankNameLab.textAlignment = NSTextAlignmentLeft;

    rollBankNameLab.font = [UIFont systemFontOfSize:14];
    

    /**
     * 输入的账户
    **/
    UITextField *rollBankNameTF = [[UITextField alloc] init];
    rollBankNameTF.text = self.creditDto.userName;
    self.rollBankNameTF = rollBankNameTF;
    
    
    
    rollBankNameTF.layer.borderColor = [UIColor whiteColor].CGColor;
    rollBankNameTF.layer.borderWidth = 1;
    rollBankNameTF.layer.cornerRadius = YES;
    rollBankNameTF.font = [UIFont systemFontOfSize:14];
    rollBankNameTF.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    rollBankNameTF.delegate = self;
    [rollBankNameView addSubview:rollBankNameTF];
    [rollBankNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollBankNameLab.mas_right).offset(15);
        make.top.equalTo(rollBankNameView.mas_top).offset(5);
        make.bottom.equalTo(rollBankNameView.mas_bottom).offset(-5);
        make.right.equalTo(rollBankNameView.mas_right).offset(-15);
        
    }];
    
    
    UIView *rollBankNameBottomLine = [[UIView alloc] init];
    rollBankNameBottomLine.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [rollBankNameView addSubview:rollBankNameBottomLine];
    [rollBankNameBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rollBankNameView.mas_bottom);
        make.left.equalTo(rollBankNameView.mas_left);
        make.right.equalTo(rollBankNameView.mas_right);
        make.height.equalTo(@0.5f);
    }];
    
    
    //转账金额
    UIView *rollAmountView= [[UIView alloc] init];
    [contentView addSubview:rollAmountView];
    [rollAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@44);
        make.top.equalTo(rollBankNameView.mas_bottom);
        
    }];
    
    
    
    UILabel *rollAmountLab = [[UILabel alloc] init];
    [rollAmountView addSubview:rollAmountLab];
    [rollAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rollAmountView.mas_centerY);
        make.left.equalTo(@15);
        make.width.equalTo(@71);
    }];
//    rollAmountLab.textAlignment = NSTextAlignmentRight;
    
    rollAmountLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    rollAmountLab.text = @"转帐金额:";
    rollAmountLab.font = [UIFont systemFontOfSize:14];
    rollAmountLab.textAlignment = NSTextAlignmentLeft;
    
    
    UITextField *rollAmountTF = [[UITextField alloc] init];
    rollAmountTF.keyboardType =  UIKeyboardTypeDecimalPad;
    rollAmountTF.text = [NSString stringWithFormat:@"%.2f",self.creditDto.amount];
    self.rollAmountTF = rollAmountTF;
    if (self.changeMoneyTF) {
        rollAmountTF.userInteractionEnabled = YES;

    }else
    {
    rollAmountTF.userInteractionEnabled = NO;
    }

    
    if (self.creditDto) {
        
    }else
    {
        rollAmountTF.text =  [NSString stringWithFormat:@"%.2f",self.payMoney.floatValue];
        if (self.payMoney.floatValue == 0) {
            rollAmountTF.text =  nil;
            
        }

    }
    rollAmountTF.delegate = self;
    rollAmountTF.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    rollAmountTF.font = [UIFont systemFontOfSize:14];

    [rollAmountView addSubview:rollAmountTF];
    [rollAmountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollAmountLab.mas_right).offset(15);
        make.top.equalTo(rollAmountView.mas_top).offset(5);
//        make.width.equalTo(@100);
        make.right.equalTo(rollAmountView.mas_right).offset(-15);
        make.bottom.equalTo(rollAmountView.mas_bottom).offset(-5);
    }];
    
    
    UIView *rollAmounBottomLine = [[UIView alloc] init];
    rollAmounBottomLine.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [rollAmountView addSubview:rollAmounBottomLine];
    [rollAmounBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rollAmountView.mas_bottom);
        make.left.equalTo(rollAmountView.mas_left);
        make.right.equalTo(rollAmountView.mas_right);
        make.height.equalTo(@0.5f);
    }];
    
    
    
    //第二个间隔
    UIView *intervalTwoView = [[UIView alloc] init];
    intervalTwoView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [contentView addSubview:intervalTwoView];
    
    [intervalTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rollAmountView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(rollAmountView.mas_right);
        make.height.equalTo(@10);
    }];

    UIView *bottomView = [[UIView alloc] init];
    [contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(intervalTwoView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@240);
    }];
    
    UILabel *firstContentLab = [[UILabel alloc] init];
    [bottomView addSubview:firstContentLab];
    [firstContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(22);
        make.left.equalTo(bottomView.mas_left).offset(15);
        make.width.equalTo(contentView.mas_width).offset(-30);
        make.right.equalTo(contentView.mas_right).offset(-15);
        
    }];
    firstContentLab.numberOfLines = 3;
    firstContentLab.text = @"1. 核帐通过后，立刻升级，并且下月可继续享受本月升级后的等级。月初就充值相当于享受2个月的特权!";
 
    
    firstContentLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    firstContentLab.font = [UIFont systemFontOfSize:14];
    
    
    
    UILabel *secondContentLab = [[UILabel alloc] init];
    [bottomView addSubview:secondContentLab];
    [secondContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstContentLab.mas_bottom).offset(19);
        make.left.equalTo(bottomView.mas_left).offset(15);
        make.right.equalTo(bottomView.mas_right).offset(-15);
        
        
    }];
    secondContentLab.text = @"2. 1次转账只能提交1次审核，恶意重复提交将封号。";
    secondContentLab.numberOfLines = 3;
    secondContentLab.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    secondContentLab.font = [UIFont systemFontOfSize:14];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).offset(140);
        
        
    }];
    
    UIButton *commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commintBtn = commintBtn;
    [self.view addSubview:commintBtn];
    [commintBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [commintBtn addTarget:self action:@selector(submitOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    if (self.creditDto) {
        
        commintBtn.backgroundColor = [UIColor colorWithHexValue:0x000000  alpha:1];
        commintBtn.userInteractionEnabled = YES;
        
    }else
    {
        commintBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        commintBtn.userInteractionEnabled = NO;
    }
   
    
    [commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@46);
    }];
    
    
    
}

/**
 *  银行卡账号专用
 *
 *  @param contentStr 传入后台发给的银行卡号
 *
 *  @return 返回XXXX XXXX XX格式
 */
- (NSString *)cutoutCharacterStr:(NSString *)contentStr
{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *lenthstr = @"";
    NSRange range;
    
    if (contentStr.length == 0) {

        
    }
    for (int i = 0; i<contentStr.length/4+1; i++) {
        
        if ((i*4+4) > contentStr.length) {
            
            if (contentStr.length  != i *4 ) {
                range = NSMakeRange(i*4, contentStr.length-i*4);
            }
            
        }else
        {
            range = NSMakeRange(i*4, 4);
        }
        
        lenthstr = [contentStr substringWithRange:range];
        [arr addObject:lenthstr];
    }
    
    NSString *blankStr;
    blankStr = arr [0];
    
    for (int i =1; i<arr.count; i++) {
        blankStr = [NSString stringWithFormat:@"%@  %@",blankStr,arr[i]];
        
    }
    
    return blankStr;
    
}

/**
 *  选中转出的银行
 */
- (void)ClickRollTapView
{
    //收回键盘
    
    [self keyBoradTakebBack];
    NSMutableArray *stringsArr = [[NSMutableArray alloc] init];
    self.bankList = stringsArr;
    if (self.bankPayDto.prepayBankList) {
        for (PrepayBankListDTO *listDto in self.bankPayDto.prepayBankList) {
            [stringsArr addObject:listDto.bankName];
            
        }
    }
    
    
   NSString * selectedObject = [stringsArr objectAtIndex:0];
    self.selectedObject = selectedObject;
    
    PromptChooseBankView *promptView = [[PromptChooseBankView alloc] initWithFrame:self.view.frame bankNames:stringsArr];
       promptView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    promptView.delegate = self;
    promptView.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.6];
    
    
    [self.view addSubview:promptView];

   
//    [MMPickerView showPickerViewInView: self.navigationController.view
//                           withStrings:stringsArr
//                           withOptions:@{MMbackgroundColor: [UIColor whiteColor],
//                                         MMtextColor: [UIColor blackColor],
//                                         MMtoolbarColor: [UIColor whiteColor],
//                                         MMbuttonColor: [UIColor blueColor],
//                                         MMfont: [UIFont systemFontOfSize:18],
//                                         MMvalueY: @3,
//                                         MMselectedObject:selectedObject,
//                                         MMtextAlignment:@1}
//                            completion:^(NSString *selectedString) {
//                                
//                                
//                                _outBankNameContent.text = selectedString;
//                                _selectedObject = selectedString;
//                                
//                                
//                                if (self.outBankNameContent.text.length != 0&&self.rollAmountTF.text.length != 0 &&self.rollBankNameTF.text != 0 ) {
//                                    self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0x000000  alpha:1];
//                                    self.commintBtn.userInteractionEnabled = YES;
//                                    
//                                }else
//                                {
//                                    self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
//                                    self.commintBtn.userInteractionEnabled = NO;
//                                }
//
//                            }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoradTakebBack
{
    [self.rollBankNameTF resignFirstResponder];
    [self.rollAmountTF resignFirstResponder];
    
}

/**
 *  确认充值按钮
 */
- (void)submitOrderButton:(UIButton *)btn
{
    
    

    BOOL isName = [CSPUtils checkUserNameFormat:self.rollBankNameTF.text];
    if (!isName) {
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"只能输入中文和英文。" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view  buttonTouchedAction:^{
            
        } dismissAction:^{
            
            
        }];
        [alert show];
        return;
    }

    
    BOOL isGood =  [CSPUtils checkMoneyNumber:self.rollAmountTF.text];
    if (!isGood) {
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"只能输入数字和小数点，小数点只能输入后两位。" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view  buttonTouchedAction:^{
            
        } dismissAction:^{
            
            
        }];
        [alert show];
        return;
    }
    

    
//    bankPayDto
//    BankAccListDTO
//    PrepayBankListDTO
    NSString * moneyStr = self.rollAmountTF.text;
    
    //用户升至的等级
   __block int level = 0;
    
    
    NSArray *listArr =   self.balanceDto.prepayListArr;
    if (listArr.count >= 1) {
        
    for (int i=0; i<listArr.count-1 ; i++) {
        PrepayList *list = listArr[i];
        if (list.advancePayment.doubleValue) {
            if ([self.rollAmountTF.text doubleValue]>=[list.advancePayment doubleValue]) {
                level = [list.level intValue];
                
                //当前的等级
                int  currentLevel =  [MemberInfoDTO sharedInstance].memberLevel.intValue;
                if (currentLevel == 6) {
                    level = 0;
                }
                break;
                
                //                    moneyStr = [list.advancePayment stringValue];
            }
        }
    }
}
    
    //输入的钱数
    float money = moneyStr.floatValue;
    
    
    if (money<=0) {
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"充值不能为0元" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        [alert show];
        
        return;
        
    }
    
    
    /**
     *  充值金额和等级
     */
 
    NSString *titleStr = @"";
    NSString *messageStr = @"(金额达不到升级标准)";
    
    /**
     *  大于0小于6的 如果大于6需要单独处理
     */
    int userLevel = 0 ;
    if (self.balanceDto) {
        //用户当前的等级
        userLevel = self.balanceDto.level.intValue;
    }
    
    
    if (self.creditDto) {
        userLevel =  [MemberInfoDTO sharedInstance].memberLevel.intValue;
        
    }
   
    
    if ((level) > 0) {
        if (level >userLevel) {
            messageStr = @"";
            titleStr = [NSString stringWithFormat:@"核帐通过后您的等级将升至:V%d",level];
        }
        if (level>6) {
            titleStr = [NSString stringWithFormat:@"核帐通过后您的等级将升至:V6"];
            messageStr = @"";;
            
        }
    }

    CGFloat submitMoney = self.rollAmountTF.text.floatValue;
  
    //  验证充值是否符合金额
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    //如果没有大于当前
    if (level <userLevel) {
        level = 0;
    }

    

    [HttpManager sendHttpRequestForpaymentCheckMoneylevel:[NSNumber numberWithInt:level] amount:[NSNumber numberWithFloat:submitMoney] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSString *message = [NSString stringWithFormat:@"转帐银行:%@\n转出银行卡开户人姓名:%@\n转账金额:%@元\n%@\n\n\n确定提交？",self.selectedObject,self.rollBankNameTF.text,self.rollAmountTF.text,titleStr];
            
            GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"请认真核对"
                                                     withTitleClor:[UIColor colorWithHexValue:0x673ab7 alpha:1]
                                   
                                                           message:message
                                                  withMessageColor:[UIColor colorWithHexValue:0x666666 alpha:1]
                                                     oKButtonTitle:@"确定"
                                                 withOkButtonColor:nil
                                                 cancelButtonTitle:@"取消"
                                                 withOkCancelColor:nil
                                                          withView:self.view
                                               buttonTouchedAction:^{
                                                   //根据钱数判断获取self.balanceBto.prepayListArr数组中的商品信息
                                                   
                                                   //用户的当前等级!充值等级

//                                                   int userLevel = 0 ;
                                                   
//                                                   
//                                                   //获取充值的等级
//                                                   if (self.balanceDto) {
//                                                       userLevel = self.balanceDto.level.intValue;
//                                                   }
//                                                   
//
//                                                   if (self.creditDto) {
//                                                       level = self.creditDto.level.intValue;
//
//                                                   }
                                                   
                                                   
                                                   
                                                   //获取等级的位置，用数组取
                                                   
//                                                   NSInteger numb = 0;
//                                                   if (level > 0) {
//                                                       if (userLevel>level) {
//                                                           numb = 6- level;
//                                                       }
//                                                       if (userLevel==6) {
//                                                           numb = 0;
//                                                           
//                                                       }
//                                                       
//                                                       
//                                                   }else
//                                                   {
//                                                       numb = self.balanceDto.prepayListArr.count-1;
//                                                       
//                                                   }
                                                   PrepayList *list ;
                                                   for (PrepayList*preLsit in self.balanceDto.prepayListArr) {
                                                       if (preLsit.level.intValue == self.skuLevel) {
                                                           list = preLsit;
                                                       }
                                                   }
                                                   
                                                   if (!list) {
                                                   list = [self.balanceDto.prepayListArr lastObject];    
                                                   }
                                                   
                                                   NSString *goodsNo = [NSString stringWithFormat:@"%@",list.goodsNo];
                                                   NSString *skuNo  =[NSString stringWithFormat:@"%@",list.skuNo];
                                                   NSString *bankCode;
                                                   
                                                   
                                                   
                                                   NSArray  *bankListArr  =   self.bankPayDto.prepayBankList;
                                                   if (bankListArr.count>0) {
                                                       for (PrepayBankListDTO *list in bankListArr) {
                                                           if ([list.bankName isEqualToString:self.selectedObject]) {
                                                               bankCode = list.bankCode;
                                                           }
                                                       }
                                                   }
                                            
                                                   
                                                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   NSInteger serviceType = 5;
                                                   if (self.skuLevel != 0) {
                                                       if (self.skuLevel == -1) {
                                                           serviceType = 5;
                                                       }else
                                                       {
                                                           serviceType = 4;
                                                       }
                                                   }else
                                                   {
                                                       serviceType = 5;
                                                   }
                                                   
                                                   
                                                   
                                                   [HttpManager sendHttpRequestForaddVirtualOrder:[NSNumber numberWithInt:1] goodsNo:goodsNo skuNo:skuNo serviceType:[NSNumber numberWithInteger:serviceType] depositAmount:[NSNumber numberWithFloat:money] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       
                                                       
                                                    NSData *data=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                                       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                       NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                                                       NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                                                       responseString
                                                       DebugLog(@"dic = %@", dic);
                                                       
                                                       if (dic == nil) {
                                                           [self.view makeMessage:@"提交失败" duration:2 position:@"center"];

                                                       }
                                                       if ([dic[@"code"] isEqualToString:@"000"]) {
                                                           //2。调起起支付接口
                                                           OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
                                                           
                                                           [orderDto setDictFrom:[dic objectForKey:@"data"]];
                                                           
                                                           //如果没有大于当前
                                                           if (level <userLevel) {
                                                               level = 0;
                                                           }

                                                                                                                   //                                                               addPrepay
                                                           [HttpManager sendHttpRequestForPaymentChargeBankCode:bankCode bankName:self.selectedObject level:[NSNumber numberWithInteger:level] amount:[NSNumber numberWithFloat:money] userName:self.rollBankNameTF.text tradeNo:orderDto.tradeNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                               
                                                               
                                                               NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                                                               DebugLog(@"dic = %@", dic);
                                                               
                                                               if ([dic[@"code"] isEqualToString:@"000"]) {

                                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
                                                                   PaymentDetailController *paymentVC = [[PaymentDetailController alloc] init];
                                                                   paymentVC.auditNo = dic[@"data"][@"auditNo"];
                                                                   
                                                                   [self.navigationController pushViewController:paymentVC animated:YES];
                                                                   
                                                               }else
                                                               {
                                                                   [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
                                                               }
                                                   
                                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               NSLog(@"%@",error);
                                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                                               
                                                               
                                                           }];
                                                           
                                                           
                                                       }else
                                                       {
                                                           [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
                                                           
                                                       }
                                                       
                                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                                       
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       
                                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                       
                                                   }];
                                                   
                                                   
                                                   
                                                   
                                               }
                                                     dismissAction:^{
                                                         
                                                         return;
                                                         
                                                     }];
            
            
            
            
            [alert show];
        }else
            
        {
            [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
            
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
    

  
    
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    
    [self animateTextField: textField up: YES];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
    if (self.outBankNameContent.text.length != 0&&self.rollBankNameTF.text.length != 0 &&self.rollAmountTF.text != 0 ) {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0x000000  alpha:1];
        self.commintBtn.userInteractionEnabled = YES;
        
    }else
    {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        self.commintBtn.userInteractionEnabled = NO;
    }
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

- (void)PromptChooseDeleBankView:(UIView *)bankView
{
    
    if (self.outBankNameContent.text.length != 0&&self.rollAmountTF.text.length != 0 &&self.rollBankNameTF.text != 0 ) {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0x000000  alpha:1];
        self.commintBtn.userInteractionEnabled = YES;
        
    }else
    {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        self.commintBtn.userInteractionEnabled = NO;
    }

    [bankView removeFromSuperview];
    
}
- (void)promptChoosebankChooseBankView:(UIView *)bankView bankName:(NSString *)name
{
    

    _outBankNameContent.text = name;
    _selectedObject = name;
    
    chooseBankLabel.text = @"";

    
    
    if (self.outBankNameContent.text.length != 0&&self.rollAmountTF.text.length != 0 &&self.rollBankNameTF.text != 0 ) {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0x000000  alpha:1];
        self.commintBtn.userInteractionEnabled = YES;
        
    }else
    {
        self.commintBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        self.commintBtn.userInteractionEnabled = NO;
    }
    

    [bankView removeFromSuperview];
    
}


//只允许输入输入小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
  
    if (textField  == self.rollAmountTF) {
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
}
    
    return YES;
}


/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
