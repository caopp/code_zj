//
//  AddChildAccountController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "AddChildAccountController.h"
#import "ManagementChildAccountView.h"
#import "AddChildAccountView.h"
#import "ChangeAccountController.h"
#import "Masonry.h"
#import "GUAAlertView.h"
@interface AddChildAccountController ()<AddChildAccountViewDelegate ,MBProgressHUDDelegate>
{
    AddChildAccountView *childV;
    
}
@property (nonatomic ,strong) UIButton *saveBtn;

@end

@implementation AddChildAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self tabbarHidden:NO];
    //设置错误和成功提示
    self.progressHUD.delegate = self;
    [self.view bringSubviewToFront:self.progressHUD];
    

    
    
    //左按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tintColor = [UIColor blackColor];
    
    leftBtn.frame = CGRectMake(0, 0, 10,18);
    
    [leftBtn setImage:[UIImage imageNamed:@"nav_retrun_btn"] forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(popNavVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    

    
    self.title =NSLocalizedString(@"addChildVCtitle", @"新增子账号");
    
    
    //添加视图
    childV =  [[[NSBundle mainBundle] loadNibNamed:@"AddChildAccountView" owner:nil options:nil] lastObject];
    
    childV.delegate = self;
    childV.childAccountArr = self.dataArr;
    
    childV.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //添加
    [self.view addSubview:childV];
 
    
    //设置提示代理
    [super.view bringSubviewToFront:self.progressHUD];
    self.progressHUD.delegate = self;
    
    
    UIView *bottomViwe = [[UIView alloc] init];
    [self.view addSubview:bottomViwe];
    
    
    
    
    [bottomViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@159);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];

    lineLabel.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
    [bottomViwe addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomViwe);
        make.left.equalTo(bottomViwe);
        make.right.equalTo(bottomViwe);
        make.height.equalTo(@1);
        
    }];
    
    UILabel *titleOne = [[UILabel  alloc] init];
    titleOne.text = @"";
    
    [bottomViwe addSubview:titleOne];
    titleOne.text = @"1、  子账号的登陆账号为手机号，设置后不可修改。";
        titleOne.numberOfLines = 0;
    titleOne.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    titleOne.font = [UIFont systemFontOfSize:13];
    [titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_top).offset(20);
        make.left.equalTo(lineLabel.mas_left).offset(15);


    }];
    
    UILabel *titleTwo = [[UILabel  alloc] init];
    [bottomViwe addSubview:titleTwo];

    titleTwo.text = @"2、  确认新增后，平台将向子账号的手机号发送开通提醒，并发送初始登陆密码。";
    titleTwo.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleTwo.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleTwo.text length])];
    titleTwo.attributedText = attributedString;
    [self.view addSubview:titleTwo];
    [titleTwo sizeToFit];
    
titleTwo.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    
    
    
    titleTwo.font = [UIFont systemFontOfSize:13];
    [titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleOne);
        make.top.equalTo(titleOne.mas_bottom).offset(8);
        make.width.equalTo(@306);
        
        
    }];
    

    
    UILabel *titleThree = [[UILabel  alloc] init];
    [bottomViwe addSubview:titleThree];
    titleThree.text = @"3、  子账号权限: 客服询单、采购单管理、商品推荐。";
    titleThree.numberOfLines = 0;

    titleThree.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    titleThree.font = [UIFont systemFontOfSize:13];
[titleThree mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(titleTwo);
    make.top.equalTo(titleTwo.mas_bottom).offset(8);
    
}];
  
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomViwe addSubview:saveBtn];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor blackColor];
    [saveBtn addTarget:self action:@selector(saveMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomViwe);
        make.right.equalTo(bottomViwe);
        make.left.equalTo(bottomViwe);
        make.height.equalTo(@49);
        
        
    }];

    //!添加轻击收拾 隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    
    
}
//!隐藏键盘
-(void)hideKeyBoard{
    
    [self.view endEditing:YES];


}

- (void)saveMessageBtn:(UIButton *)btn
{
    [childV saveAddMessage];
    
}

- (void)popNavVC:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - AddChildAccountView的代理方法

- (void)showWait
{
    self.progressHUD.hidden = NO;
    [self  progressHUDShowWithString:@"1"];
    
    
}
- (void)hidenView
{
    self.progressHUD.hidden = YES;
}

/**
 *  @param nickName 昵称
 *  @param merchant 账户
 *  @param status   状态
 */
- (void)AddChildAccountNickName:(NSString *)nickName merchantAccount:(NSString *)merchant status:(NSString *)status
{
//    self.progressHUD.hidden = YES;
    

    
    //网络请求提示progressHUDShow
    [self progressHUDShowWithString:NSLocalizedString(@"progressHUDShow", @"操作中")];

    //请求
    [HttpManager sendHttpRequestForAddChildAccountMerchantAccount:merchant   nickName:nickName  status:status success:^(AFHTTPRequestOperation *operation, id reqeustObject) {
        //解析数据
        NSDictionary *dict =    [NSJSONSerialization JSONObjectWithData:reqeustObject options:NSJSONReadingAllowFragments error:nil];
        
        //判断是否
        if ([dict[@"code"]isEqualToString:@"000"]) {
            /**
             *  如果是0 则表示已经默认开启状态了。 否则 需要跳到子账户详情页开启
             */
            
            if (self.block) {
            self.block();    
            }
            
            
            if ([status isEqualToString:@"0"]) {
                
                [self progressHUDHiddenTipSuccessWithString:@"操作成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                //接收到需要传递参数
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:nickName forKey:@"nickName"];
                [dict setObject:merchant forKey:@"merchantAccount"];
                [dict setObject:status forKey:@"enableFlag"];
                [dict setObject:status forKey:@"firstOpenFlag"];
                self.progressHUD.hidden = YES;

                //跳转
                ChangeAccountController *childAccount = [[ChangeAccountController alloc] init];
                childAccount.dataDict = dict;
                [self.navigationController pushViewController:childAccount animated:YES];

                
            }
        }else
        {
            /**
             *  操作失败 隐藏提示 出错原因
             */
            self.progressHUD.hidden = YES;
            
//            GUAAlertView  *alert = [GUAAlertView alertViewWithTitle:@"操作失败" withTitleClor:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:ERRORMESSAGE]] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
//                return ;
//                
//            } dismissAction:^{
//                
//            }];
        
//            [alert show];
            [self.view makeMessage:[NSString stringWithFormat:@"操作失败%@",[dict objectForKey:ERRORMESSAGE]] duration:2 position:@"center"];
            
            
            
////            [self progressHUDHiddenTipSuccessWithString:[NSString stringWithFormat:@"操作失败%@",[dict objectForKey:ERRORMESSAGE]]];
//            [self progressHUDHiddenWidthString:[NSString stringWithFormat:@"操作失败:%@",[dict objectForKey:ERRORMESSAGE]]];
            
//            [self alertViewWithTitle:@"操作失败" message:[dict objectForKey:ERRORMESSAGE]];
        
        }
 
        
    } failure:^(AFHTTPRequestOperation *opeation, NSError *error) {
        
        //请求失败的原因
        [self tipRequestFailureWithErrorCode:error.code];

        
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
