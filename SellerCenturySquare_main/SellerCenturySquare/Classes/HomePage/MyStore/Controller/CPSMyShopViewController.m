//
//  CPSMyShopViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSMyShopViewController.h"
#import "BusinessStateCell.h"
#import "ScoreTableViewCell.h"
#import "SettingTableViewCell.h"
#import "MoneyConditionTableViewCell.h"
#import "CountConditionTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "CheckShopTableViewCell.h"
#import "DownloadJurisdictionTableViewCell.h"
#import "ShopInformationTableViewCell.h"
#import "MoneyConditionEditedTableViewCell.h"
#import "CountConditionEditedTableViewCell.h"
#import "ChildAccountCell.h"
#import "DownloadTimesBuyCell.h"

//店铺标签
#import "StoreTagViewController.h"
#import "StoreTagTableViewCell.h"
//运费模版
#import "FreightTemplateTableViewCell.h"
#import "FreightTemplateViewController.h"

#import "MyShopStateDTO.h"
#import "ModCloseBusinessTimeViewController.h"
#import "SetDownloadJurisdictionViewController.h"
#import "ShopInfoViewController.h"
#import "CSPGoodsListViewController.h"
#import "ChildAccountController.h"
#import "MyUserDefault.h"

#import "CSPConsumptionPointsRecordTableViewController.h"
#import "CSPVIPUpdateViewController.h"

#import "HttpManager.h"
#import "UIColor+UIColor.h"
#import "GUAAlertView.h"

#import "TransactionRecordsViewController.h"

#import "MerchantsPrivilegesViewController.h"

#import "ScoreQueryViewController.h"

#import "LoginDTO.h"
#import "SecondaryViewController.h"
#import "ThreePageViewController.h"


//新修改模板
#import "ZJ_FreightTemplateViewController.h"

@interface CPSMyShopViewController ()<ScoreQueryViewControllerDelegate,MerchantsPrivilegesViewControllerDelegate,SecondaryViewControllerDelegate>
{
    
    
    MyShopStateDTO *myShopStateDTO;

    // !自定义提示view
    GUAAlertView * customeAlertView ;
    //营业额积分记录缓存清除
    ScoreQueryViewController *scoreQueryVC;
    //清除商家特权缓存
    MerchantsPrivilegesViewController *merchantsPrivilegesVC;
    
    NSIndexPath * moneyEditIndex;//!起批价钱 编辑行
    NSIndexPath * countEditIndex;//!起批数量 编辑行
    
    
}
//主账号-子帐号权限区分：有修改和查看下载的权限
@property (nonatomic,assign)BOOL isMaster;
//编辑状态
@property (nonatomic,assign)BOOL editedState;
//营业状态
@property (nonatomic,assign)BOOL operateStatus;

@end

@implementation CPSMyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     
    myShopStateDTO = [MyShopStateDTO sharedInstance];
    
    myShopStateDTO.editedState = NO;
    
    _getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    _isMaster = _getMerchantInfoDTO.isMaster;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self customBackBarButton];
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self.tableView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    
    // !歇业按钮的背景view
    [self.closeBtnBgView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];

}
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    //!需要将以前的控件移除，不然再次进来的时候会复用还没有dealloc的cell，数据会不正确
    for (UIView * views in [self.view subviews]) {
        
        [views removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)hideKeyboard{

    [self.view endEditing:YES];

}


- (void)viewWillAppear:(BOOL)animated{
    
    // !更改编辑状态
    [self updateEditedState:NO];

    [self getData];
    
    [self tabbarHidden:YES];
    
    [self updateShopState];
    
    // !修改混批条件  因为在界面消失的时候就移除观察，则再返回这个界面的时候观察就没有了，所以要在将要出现界面重新添加观察
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateEditedStateNotification:) name:kMyShopEditStateChangedNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self getDownloadSettingAuthTipRequest];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    // !修改混批条件 必须在这里去除，如果在dealloc里面移除：界面返回了，但是观察没有移除，则再创建一个页面，这个观察还在，会执行这个观察的事件多次
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMyShopEditStateChangedNotification object:nil];
    
}
- (void)dealloc{
    
    // !修改混批条件
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMyShopEditStateChangedNotification object:nil];
    
}

#pragma mark - Private Functions
- (void)updateShopState{

    if (_getMerchantInfoDTO.operateStatus) {
        
        if (![_closeShopButton.titleLabel.text isEqualToString:@"歇业"]) {
            
            [_closeShopButton setTitle:@"歇业" forState:UIControlStateNormal];
            
            [_closeShopButton setTitle:@"歇业" forState:UIControlStateHighlighted];
        }
    }else{
        
        [_closeShopButton setTitle:@"恢复营业" forState:UIControlStateNormal];
        
        [_closeShopButton setTitle:@"恢复营业" forState:UIControlStateHighlighted];
    }
    
    // !主账号  歇业按钮
    if (_getMerchantInfoDTO.isMaster) {
        
//        _closeShopButton.enabled = YES;
//        [_closeShopButton setBackgroundColor:[UIColor blackColor]];
        _closeShopButton.hidden = NO;
        _closeBtnBgView.hidden = NO;// !歇业按钮的背景view
        
    }else{
        
//        _closeShopButton.enabled = NO;
//        [_closeShopButton setBackgroundColor:[UIColor grayColor]];
        _closeShopButton.hidden = YES;
        _closeBtnBgView.hidden = YES;// !歇业按钮的背景view
        
       
        
        
    }

}


#pragma mark 修改混批条件
//编辑状态通知
- (void)updateEditedStateNotification:(NSNotification*)notification{
    
    [self.view endEditing:YES];

    NSDictionary *infoDic = [notification userInfo];
    
    NSString *editedState = infoDic[@"editedState"];
    
    // !修改为 编辑状态
    if ([editedState integerValue]==1) {
        
        [self updateEditedState:YES];
    
    }else{
        
        //!得到 价格 起批编辑行
         MoneyConditionEditedTableViewCell *moneyEditedCell = (MoneyConditionEditedTableViewCell*)[self.tableView cellForRowAtIndexPath:moneyEditIndex];
        
        NSString * batchMoneyFlag = moneyEditedCell.stateOn.on ? @"0":@"1";
        
        CGFloat moneyNum = [moneyEditedCell.textField.text floatValue];
        
        
        //!得到 数量 起批编辑行
        CountConditionEditedTableViewCell *countConditionEditedCell = (CountConditionEditedTableViewCell*)[self.tableView cellForRowAtIndexPath:countEditIndex];
        
        
        NSString *batchCountFlag = countConditionEditedCell.stateOn.on ?  @"0":@"1";
        int countNum = [countConditionEditedCell.textField.text intValue];


        //!开启金额限制，并且数量填写为0/0.00/0.0
        if ([batchMoneyFlag isEqualToString:@"0"] && moneyNum == 0) {
            
            [self.view makeMessage:@"起批金额不能为0元" duration:2.0 position:@"center"];
            
            // !修改为编辑状态
            [self updateEditedState:YES];
            
            return;
            
        }
        
        if ([batchCountFlag isEqualToString:@"0"] && countNum == 0 ) {
            
            [self.view makeMessage:@"“起批件数不能小于1件" duration:2.0 position:@"center"];
            
            // !修改为编辑状态
            [self updateEditedState:YES];
            
            return;
        }
        
        
        if (customeAlertView) {
            [customeAlertView removeFromSuperview];
        }
        
        customeAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否保存全店混批条件？" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            // !进行请求
            [self updateMerchantBatchlimit];
            
        } dismissAction:^{
           
            // !修改为编辑状态
            [self updateEditedState:YES];
            
        }];

        [customeAlertView show];
    }
}

//编辑状态更新
- (void)updateEditedState:(BOOL)edited{
    
    _editedState = edited;
    myShopStateDTO.editedState = edited;
    [self.tableView reloadData];
    
}
//更新混批条件
- (void)updateMerchantBatchlimit{
    
    
    NSString * batchAmountFlag = _getMerchantInfoDTO.batchAmountFlag;
    NSString *batchNumFlag = _getMerchantInfoDTO.batchNumFlag;
    
    NSNumber* batchAmountLimit = _getMerchantInfoDTO.batchAmountLimit;
    NSNumber* batchNumLimit = _getMerchantInfoDTO.batchNumLimit;
    
    
    [HttpManager sendHttpRequestForGetUpdateMerchantBatchlimit: batchAmountFlag batchNumFlag:batchNumFlag batchAmountLimit:batchAmountLimit batchNumLimit:batchNumLimit success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            DebugLog(@"修改全店混批条件  返回正常编码");
            
            [self.view makeMessage:@"修改成功" duration:2 position:@"center"];
            // !修改为不编辑状态
            [self updateEditedState:NO];
            
        }else{
            
            DebugLog(@"修改全店混批条件  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
            // !修改为编辑状态
            [self updateEditedState:YES];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"修改失败" duration:2 position:@"center"];
        [self updateEditedState:YES];
        
        DebugLog(@"testGetUpdateMerchantBatchlimit 失败");
        DebugLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}


#pragma mark 歇业 恢复营业按钮
- (IBAction)closeShopButtonClicked:(id)sender {

    if (_getMerchantInfoDTO.operateStatus) {
        
        // !判断用户是否有权限歇业  每个店每年有两次歇业的机会
        [self getMerchantCloseLog];
        
    }else{
        
        if (customeAlertView) {
            
            [customeAlertView removeFromSuperview];
       
        }
        
        customeAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否立刻恢复营业?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self restartShopRequest];

            
        } dismissAction:nil];
        
        [customeAlertView show];
        
        
    }
    
}
// !判断用户是否有权限歇业  每个店每年有两次歇业的机会
- (void)getMerchantCloseLog{

//    [self progressHUDShowWithString:@"请求中"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.closeShopButton.enabled = NO;
    
    [HttpManager sendHttpRequestForGetMerchantCloseLog:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.closeShopButton.enabled = YES;

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
//            [self progressHUDHiddenWidthString:@"请求成功"];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];

            
            NSDictionary * dataDic = dic[@"data"];
            // !有权限
            if ([dataDic[@"isSetClose"] isEqualToString:@"0"]) {
                
                [self performSegueWithIdentifier:@"closeShop" sender:nil];
                
            }else{// !不能再设置歇业
                
                NSArray *closeLogArray = dataDic[@"closeLogList"];
                NSDictionary *closeOneDic = closeLogArray[0];
                
                NSString * timeOne = [NSString stringWithFormat:@"第1次：%@ 至 %@",[self componentStr:closeOneDic[@"closeStartTime"]],[self componentStr:closeOneDic[@"closeEndTime"]]];
                
                
                NSDictionary *closeTwoDic = closeLogArray[1];
                NSString * timeTwo = [NSString stringWithFormat:@"第2次：%@ 至 %@",[self componentStr:closeTwoDic[@"closeStartTime"]],[self componentStr:closeTwoDic[@"closeEndTime"]]];
                
                NSString * closeTime = [NSString stringWithFormat:@"%@\n%@",timeOne,timeTwo];
                
                
                if (customeAlertView) {
                    
                    [customeAlertView removeFromSuperview];
                }

                customeAlertView = [GUAAlertView alertViewWithTitle:@"您今年的2次歇业已用完!" withTitleClor:[UIColor redColor] message:closeTime withMessageColor:nil oKButtonTitle:@"关闭" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:nil dismissAction:nil];
                
                [customeAlertView show];
                
            
            }
            
        }else{
        
            
//            [self progressHUDHiddenWidthString:@"请求失败"];
        
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
            [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        self.closeShopButton.enabled = YES;

        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];

        
    }];


}
-(NSString *)componentStr:(NSString *)str{


    NSArray * comArray = [str componentsSeparatedByString:@":"];
    
    return [NSString stringWithFormat:@"%@点",comArray[0]];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10) {
        // !恢复营业的请求
        if ([alertView cancelButtonIndex]!=buttonIndex) {
            

            [self restartShopRequest];
            
        }
        
    }else{
        
        if ([alertView cancelButtonIndex]!=buttonIndex) {
            
            [self updateEditedState:NO];
            
            [self updateMerchantBatchlimit];
            
        }
    }
    
}

#pragma mark 恢复营业的请求
- (void)restartShopRequest{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *timeStr = [formatter stringFromDate:date];
    
    self.closeShopButton.enabled = NO;

    [HttpManager sendHttpRequestForGetUpdateMerchantBusiness:@"0" closeStartTime:@"" closeEndTime:timeStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.closeShopButton.enabled = YES;

        NSDictionary *resultDic = [self conversionWithData:responseObject];
        
        if ([resultDic[@"code"] integerValue]==0) {
            
            [self.view makeMessage:@"恢复成功" duration:2 position:@"center"];
            
            [self getData];
            
            [self.tableView reloadData];
            
            
        }else{
            
            [self.view makeMessage:@"恢复失败" duration:2 position:@"center"];

        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.closeShopButton.enabled = YES;

        [self.view makeMessage:@"恢复失败" duration:2 position:@"center"];

        
    }];
    
    
    
}

#pragma mark - HttpRequest
//主账号等级权限控制-采购商下载权限控制
- (void)getDownloadSettingAuthTipRequest{
    
    NSString * authType = @"5";//设置采购商下载权限
  //**********************
    [HttpManager sendHttpRequestForGetMerchantNotAuthTip:authType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            DebugLog(@" 无权限提示接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getMerchantNotAuthTipDTO = [[GetMerchantNotAuthTipDTO alloc ]init];
                
                [_getMerchantNotAuthTipDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
        }else{
            
            DebugLog(@" 无权限提示接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DebugLog(@"testGetMerchantNotAuthTip 失败");
        DebugLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
}

//大B商家信息接口
- (void)getData{
    
    
    //***********************
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                _getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                
                _isMaster = _getMerchantInfoDTO.isMaster;
                
                [self updateShopState];
                
                [self.tableView reloadData];
            }
            
        }else{
            
            DebugLog(@"大B商家信息接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DebugLog(@"testGetMerchantInfo 失败");
        DebugLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //!如果是苹果审核账号，则不显示 “下载次数购买记录”
    if ([[LoginDTO sharedInstance].merchantAccount isEqualToString:AppleAccount]) {
        return 5;
    }
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isMaster) {
        
        switch (section) {
            case 0:
                return 2;
                break;
            case 1:
                return 4;
                break;
            case 2:
                return 4;
                break;
                
             case 3:
                
                return 1;
                break;
            case 4:
            {
                if ([[MyUserDefault JudgeUserAccount] isEqualToString:@"1"]) {
                    return 0;
                    break;
                }else
                {
                    return 1;
                    break;
                }
               
            }
            case 5:
            {
                if ([[MyUserDefault JudgeUserAccount] isEqualToString:@"1"]) {
                    return 0;
                    break;
                }else
                {
                    return 1;
                    break;
                }
                
            }

                
            default:
                break;
        }
        
    }else{
        
        //无修改权限
        switch (section) {
            case 0:
                return 2;
                break;
            case 1:
                return 4;
                break;
            case 2:
                return 2;
                break;
            case 3:
                return 0;
                break;
                
                
            case 4:
            {
                if ([[MyUserDefault JudgeUserAccount] isEqualToString:@"1"]) {
                    return 0;
                    break;
                }else
                {
                    return 0;
                    break;
                }
            }
            case 5:
            {
                if ([[MyUserDefault JudgeUserAccount] isEqualToString:@"1"]) {
                    return 0;
                    break;
                }else
                {
                    return 0;
                    break;
                }
                
            }

            default:
                break;
        }

        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section  = indexPath.section;
    
    // Configure the cell...
    CPSMyShopViewController * shopVC = self;
    if (_isMaster) {
        
        
        switch (section) {
            case 0:
                
                switch (indexPath.row) {
                    case 0:
                    {
                    
                        BusinessStateCell *businessStateCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessStateCell"];

                        if (!businessStateCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"BusinessStateCell" bundle:nil] forCellReuseIdentifier:@"BusinessStateCell"];
                            businessStateCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessStateCell"];
                            
                        }
                        
                        [businessStateCell updateBusinessState:_getMerchantInfoDTO.operateStatus];
                        
                        if (_getMerchantInfoDTO.level) {
                            [businessStateCell setLevelString:[_getMerchantInfoDTO.level stringValue]];
                        }
                        
                        // !点击等级图片的事件
                        
                        businessStateCell.levelBlock = ^(){
                            
                            [shopVC intoVIPUpdateView];
                            
                        };
                        return businessStateCell;
                        
                        break;
                        
                    
                    }
                       
                    case 1:
                        
                    {
                        ScoreTableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell"];
                        
                        if (!scoreCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreTableViewCell"];
                            scoreCell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell"];
                            
                        }
                        
                        if (_getMerchantInfoDTO.monthIntegralNum) {
                            
                            [scoreCell setScore:[_getMerchantInfoDTO.monthIntegralNum stringValue]];
                        }
                        return scoreCell;
                        break;

                    
                    
                    
                    }
                    default:
                        break;
                }
                
                break;
            case 1:
                
                if (_editedState) {
                    
                    //修改状态
                    switch (indexPath.row) {
                        case 0:

                        {
                            SettingTableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                            if (!settingCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
                                settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                                
                            }
                            //有权限
                            settingCell.editButton.hidden = NO;
                            
                            [settingCell updateButtonOnEditedState:YES];
                            return settingCell;
                            break;
                        
                        
                        }
                        
                        case 1:
                          
                        {
                            
                            MoneyConditionEditedTableViewCell *moneyEditedCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionEditedTableViewCell"];

                            if (!moneyEditedCell) {
                                
                                
                                [tableView registerNib:[UINib nibWithNibName:@"MoneyConditionEditedTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyConditionEditedTableViewCell"];
                                
                                
                                moneyEditedCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionEditedTableViewCell"];
                                
                            }
                            moneyEditIndex = indexPath;//!记录价钱编辑行
                            
                            return moneyEditedCell;
                            
                            break;
                        
                        }
                        
                        case 2:
                        {
                            countEditIndex = indexPath;//!记录数量编辑行
                            
                            CountConditionEditedTableViewCell *countConditionEditedCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionEditedTableViewCell"];
                            
                            if (!countConditionEditedCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"CountConditionEditedTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountConditionEditedTableViewCell"];
                                countConditionEditedCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionEditedTableViewCell"];
                                
                            }
                            
                            return countConditionEditedCell;
                            
                            break;
                        
                        
                        }
                        
                        case 3:
                            
                        {
                            NoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                            
                            if (!noticeCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
                                noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                                
                            }
                            return noticeCell;
                            break;
                        
                        
                        }
                        default:
                            break;
                    }
                    
                }else{
                    
                    //完成状态
                    switch (indexPath.row) {
                            
                        case 0:
                            
                        {
                            SettingTableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                            
                            if (!settingCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
                                settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                                
                            }
                            
                            [settingCell updateButtonOnEditedState:NO];
                            return settingCell;
                            break;
                            
                        
                        }
                        
                        case 1:
                        
                        {
                            MoneyConditionTableViewCell *moneyCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionTableViewCell"];
                            
                            
                            if (!moneyCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"MoneyConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyConditionTableViewCell"];
                                moneyCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionTableViewCell"];
                                
                            }
                            
                            return moneyCell;
                            break;
                        
                        }
                        case 2:
                            
                        {
                        
                            CountConditionTableViewCell *countConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionTableViewCell"];
                            
                            if (!countConditionCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"CountConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountConditionTableViewCell"];
                                countConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionTableViewCell"];
                                
                            }
                            
                            return countConditionCell;
                            break;
                        
                        }
                            
                        case 3:
                        {
                            NoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                            
                            if (!noticeCell) {
                                
                                [tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
                                noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                                
                            }
                            return noticeCell;
                            break;
                        
                        }
                            
                        default:
                            break;
                            
                    }
                    
                }
                
                break;
            case 2:
                
                switch (indexPath.row) {
                    case 0:
                    {
                        CheckShopTableViewCell *checkShopCell = [tableView dequeueReusableCellWithIdentifier:@"CheckShopTableViewCell"];
                        
                        if (!checkShopCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"CheckShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckShopTableViewCell"];
                            checkShopCell = [tableView dequeueReusableCellWithIdentifier:@"CheckShopTableViewCell"];
                            
                        }
                        return checkShopCell;
                        break;
                    
                    }
                    case 1:
                        
                    {
                        StoreTagTableViewCell *storeTagCell = [tableView dequeueReusableCellWithIdentifier:@"StoreTagTableViewCell"];
                        
                        if (!storeTagCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"StoreTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreTagTableViewCell"];
                            storeTagCell = [tableView dequeueReusableCellWithIdentifier:@"StoreTagTableViewCell"];
                            
                        }
                        return storeTagCell;
                        break;
                    
                    
                    }
                    case 2:
                    {
                        FreightTemplateTableViewCell *freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"FreightTemplateTableViewCell"];
                        
                        if (!freightTemplateCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"FreightTemplateTableViewCell" bundle:nil] forCellReuseIdentifier:@"FreightTemplateTableViewCell"];
                            freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"FreightTemplateTableViewCell"];
                            
                        }
                        return freightTemplateCell;
                        break;
                    
                    
                    }
                    case 3:
                    {
                        ShopInformationTableViewCell *shopInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInformationTableViewCell"];
                        
                        if (!shopInfoCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"ShopInformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopInformationTableViewCell"];
                            shopInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInformationTableViewCell"];
                            
                        }
                        return shopInfoCell;
                        break;
                    
                    
                    }
                    default:
                        break;
                }
                
                break;
            case 3:
            {
                DownloadJurisdictionTableViewCell *downloadCell = [tableView dequeueReusableCellWithIdentifier:@"DownloadJurisdictionTableViewCell"];
                
                if (!downloadCell) {
                    
                    [tableView registerNib:[UINib nibWithNibName:@"DownloadJurisdictionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DownloadJurisdictionTableViewCell"];
                    downloadCell = [tableView dequeueReusableCellWithIdentifier:@"DownloadJurisdictionTableViewCell"];
                    
                }
                
                
                return downloadCell;
                break;
            
            }
        
            case 4:
            {
                ChildAccountCell *childCell = [tableView dequeueReusableCellWithIdentifier:@"ChildAccountCell"];
                
                if (!childCell) {
                    
                    [tableView registerNib:[UINib nibWithNibName:@"ChildAccountCell" bundle:nil] forCellReuseIdentifier:@"ChildAccountCell"];
                    childCell = [tableView dequeueReusableCellWithIdentifier:@"ChildAccountCell"];
                    
                    
                }
                
                return childCell;
                break;
            
            }
            
            case 5:
            {
                DownloadTimesBuyCell *downloadTime = [tableView dequeueReusableCellWithIdentifier:@"DownloadTimesBuyCell"];
                
                if (!downloadTime) {
                    [tableView registerNib:[UINib nibWithNibName:@"DownloadTimesBuyCell" bundle:nil] forCellReuseIdentifier:@"DownloadTimesBuyCell"];
                    downloadTime = [tableView dequeueReusableCellWithIdentifier:@"DownloadTimesBuyCell"];
                    
                }
                
                return downloadTime;
                break;

            
            }
                
            default:
                return nil;
                break;
        }
        
    }else{
        
        //无权限
        switch (section) {
            case 0:
                
                switch (indexPath.row) {
                    case 0:
                    {
                        BusinessStateCell *businessStateCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessStateCell"];

                        if (!businessStateCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"BusinessStateCell" bundle:nil] forCellReuseIdentifier:@"BusinessStateCell"];
                            businessStateCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessStateCell"];
                            
                        }
                        
                        [businessStateCell updateBusinessState:_getMerchantInfoDTO.operateStatus];
                        
                        if (_getMerchantInfoDTO.level) {
                            
                            [businessStateCell setLevelString:[_getMerchantInfoDTO.level stringValue]];
                            
                        }
                        // !点击等级图片的事件
                        businessStateCell.levelBlock = ^(){
                            
                            [shopVC intoVIPUpdateView];
                            
                        };
                        
                        
                        return businessStateCell;
                        break;

                    
                    
                    }
                    case 1:
                        
                    {
                        ScoreTableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell"];
                        
                        if (!scoreCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreTableViewCell"];
                            scoreCell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell"];
                            
                        }
                        
                        if (_getMerchantInfoDTO.monthIntegralNum) {
                            
                            [scoreCell setScore:[_getMerchantInfoDTO.monthIntegralNum stringValue]];
                        }
                        return scoreCell;
                        break;

                    
                    
                    
                    }
                    default:
                        break;
                }
                
                break;
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                        
                    {
                        SettingTableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                        
                        if (!settingCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
                            settingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
                            
                        }
                        
                        settingCell.editButton.hidden = YES;
                        return settingCell;
                        break;
                    
                    
                    }
                    
                    case 1:
                        
                    {
                        MoneyConditionTableViewCell *moneyCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionTableViewCell"];
                        
                        if (!moneyCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"MoneyConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyConditionTableViewCell"];
                            moneyCell = [tableView dequeueReusableCellWithIdentifier:@"MoneyConditionTableViewCell"];
                            
                        }
                        
                        return moneyCell;
                        break;
                
                    
                    }
                    case 2:
                        
                    {
                        CountConditionTableViewCell *countConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionTableViewCell"];
                        
                        if (!countConditionCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"CountConditionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountConditionTableViewCell"];
                            countConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CountConditionTableViewCell"];
                            
                        }
                        
                        return countConditionCell;
                        break;
                    
                    
                    }
                    
                    case 3:
                    {
                        NoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                        
                        if (!noticeCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
                            noticeCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
                            
                        }
                        return noticeCell;
                        break;
                    
                    }
                        
                    default:
                        break;
                }
                
                break;
            case 2:
                
                switch (indexPath.row) {
                    case 0:
                    {
                        CheckShopTableViewCell *checkShopCell = [tableView dequeueReusableCellWithIdentifier:@"CheckShopTableViewCell"];
                        
                        if (!checkShopCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"CheckShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckShopTableViewCell"];
                            checkShopCell = [tableView dequeueReusableCellWithIdentifier:@"CheckShopTableViewCell"];
                            
                        }
                        return checkShopCell;
                        break;
                    
                    
                    }
                    case 1:
                    {
                        ShopInformationTableViewCell *shopInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInformationTableViewCell"];
                        
                        if (!shopInfoCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"ShopInformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopInformationTableViewCell"];
                            shopInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInformationTableViewCell"];
                            
                        }
                        return shopInfoCell;
                        break;
                    
                    
                    }
                    case 2:
                    {
                        StoreTagTableViewCell *storeTagCell = [tableView dequeueReusableCellWithIdentifier:@"StoreTagTableViewCell"];
                        
                        if (!storeTagCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"StoreTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreTagTableViewCell"];
                            storeTagCell = [tableView dequeueReusableCellWithIdentifier:@"StoreTagTableViewCell"];
                            
                        }
                        return storeTagCell;
                        break;
                    
                    
                    }
                    case 3:
                        
                    {
                        FreightTemplateTableViewCell *freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"FreightTemplateTableViewCell"];
                        
                        if (!freightTemplateCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"FreightTemplateTableViewCell" bundle:nil] forCellReuseIdentifier:@"FreightTemplateTableViewCell"];
                            freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"FreightTemplateTableViewCell"];
                            
                        }
                        return freightTemplateCell;
                        break;
    
                    
                    }
                        
                    default:
                        break;
                }

                
                break;
                
                case 3:
                {
                    
                    ChildAccountCell *childCell = [tableView dequeueReusableCellWithIdentifier:@"ChildAccountCell"];
                    
                    if (!childCell) {
                        
                        [tableView registerNib:[UINib nibWithNibName:@"ChildAccountCell" bundle:nil] forCellReuseIdentifier:@"ChildAccountCell"];
                        childCell = [tableView dequeueReusableCellWithIdentifier:@"ChildAccountCell"];
                        
                        
                    }
                    return childCell;
                    break;
            
                }
                
                case 4:
                {
            
                    DownloadTimesBuyCell *downloadTime = [tableView dequeueReusableCellWithIdentifier:@"DownloadTimesBuyCell"];
                    
                    if (!downloadTime) {
                        [tableView registerNib:[UINib nibWithNibName:@"DownloadTimesBuyCell" bundle:nil] forCellReuseIdentifier:@"DownloadTimesBuyCell"];
                        downloadTime = [tableView dequeueReusableCellWithIdentifier:@"DownloadTimesBuyCell"];
                        
                    }
                    
                    return downloadTime;
                    break;

            
                }
                
                
            default:
                return nil;
                break;
        }
        
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.section==0&&indexPath.row==0&&!_getMerchantInfoDTO.operateStatus) {
        
        ModCloseBusinessTimeViewController *modCloseBusinessTimeVC = [storyboard instantiateViewControllerWithIdentifier:@"ModCloseBusinessTimeViewController"];
        modCloseBusinessTimeVC.startFormatterString = _getMerchantInfoDTO.closeStartTime;
        modCloseBusinessTimeVC.endFormatterString = _getMerchantInfoDTO.closeEndTime;
        
        [self navigationBarSettingShow:YES];
        
        [self.navigationController pushViewController:modCloseBusinessTimeVC animated:YES];
        
        
    }
    
 if(indexPath.section==3){// !设置采购商下载权限
    
        SetDownloadJurisdictionViewController *setDownloadJurVC = [storyboard instantiateViewControllerWithIdentifier:@"SetDownloadJurisdictionViewController"];
        
        if (_getMerchantNotAuthTipDTO) {
            
            setDownloadJurVC.hasAuth = _getMerchantNotAuthTipDTO.hasAuth;
            
            [self navigationBarSettingShow:YES];
            
            [self.navigationController pushViewController:setDownloadJurVC animated:YES];
        }else{
            
            [self getDownloadSettingAuthTipRequest];
        }
 }
    
    
    
    
    // !子账号管理
    if (indexPath.section==4) {
        
        ChildAccountController *childVC = [[ChildAccountController alloc] init];
        [self navigationBarSettingShow:YES];
        
        [self.navigationController pushViewController:childVC animated:YES];
    }
    
    if (indexPath.section == 5) {
        
        DebugLog(@"**** 下载次数购买记录 **************");
        
        /**** 下载次数购买记录 ************** */
        
        TransactionRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
        [self.navigationController pushViewController:nextVC animated:YES];

        
    }
    
    
    if (_isMaster) {
        // !营业额积分 ：需要和h5交互
        if (indexPath.section==0&&indexPath.row==1) {
            
            
            ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
            
            threePageVC.file = [HttpManager scoreQueryNetworkRequestWebView];
            
            [self.navigationController pushViewController:threePageVC animated:YES];
            
//            CSPConsumptionPointsRecordTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsRecordTableViewController"];
//            [self.navigationController pushViewController:nextVC animated:YES];
            
            
        }
        // !查看店铺
        if (indexPath.section == 2 && indexPath.row == 0) {
           
            CSPGoodsListViewController* goodsListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsListViewController"];
            [self.navigationController pushViewController:goodsListViewController animated:NO];
            
        }
        else if (indexPath.section==2&&indexPath.row==1)
        {
            //店铺标签
            StoreTagViewController *storeTagVC = [[StoreTagViewController alloc]init];
            [self.navigationController pushViewController:storeTagVC animated:YES];
            
        }else if (indexPath.section==2&&indexPath.row==2)
        {
            //运费模版
//            FreightTemplateViewController *freightTemplate = [[FreightTemplateViewController alloc]init];
//            [self.navigationController pushViewController:freightTemplate animated:YES];
            
            ZJ_FreightTemplateViewController *freightTemplate = [[ZJ_FreightTemplateViewController alloc]init];
            [self.navigationController pushViewController:freightTemplate animated:YES];
            
            
        }
        else if(indexPath.section==2&&indexPath.row==3){// !商家资料
            
            //运费模版
//            FreightTemplateViewController *freightTemplate = [[FreightTemplateViewController alloc]init];
//            [self.navigationController pushViewController:freightTemplate animated:YES];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ShopInfoViewController *shopInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"ShopInfoViewController"];
            
            [self navigationBarSettingShow:YES];
            
            [self.navigationController pushViewController:shopInfoVC animated:YES];
            
        }
       
    }else{
        
        if (indexPath.section == 2 && indexPath.row == 0) {// !查看店铺
            
            CSPGoodsListViewController* goodsListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsListViewController"];
            [self.navigationController pushViewController:goodsListViewController animated:YES];
            
        }else if(indexPath.section==2&&indexPath.row==1){// !商家资料
            
            ShopInfoViewController *shopInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"ShopInfoViewController"];
            
//            [self navigationBarSettingShow:YES];
            
            [self.navigationController pushViewController:shopInfoVC animated:YES];
            
        }
        else if (indexPath.section==2&&indexPath.row==3)
        {
            //店铺标签
            StoreTagViewController *storeTagVC = [[StoreTagViewController alloc]init];
            [self.navigationController pushViewController:storeTagVC animated:YES];
            
        }else if (indexPath.section==2&&indexPath.row==4)
        {
            //运费模版
            FreightTemplateViewController *freightTemplate = [[FreightTemplateViewController alloc]init];
            [self.navigationController pushViewController:freightTemplate animated:YES];
            
            
        }
        

        
    }
    
    
    
}

-(void)removalOfTurnoverIntegralCache
{
    [scoreQueryVC.webView removeFromSuperview];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0:
            return 1;
            break;
            
        default:
            break;
    }
    
    return 10;
    
}

#pragma mark 进入商家特权
- (void)intoVIPUpdateView{

    
    ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
    
    threePageVC.file = [HttpManager privilegesNetworkRequestWebView];
    
    [self.navigationController pushViewController:threePageVC animated:YES];
    
    
//    CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
//    
//    [self.navigationController pushViewController:vipVC animated:YES];


}
-(void)pushTransactionRecordsVC
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TransactionRecordsViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

//清除商家特权缓存记录
-(void)clearBusinessFranchiseRecord
{
    [merchantsPrivilegesVC.webView removeFromSuperview];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self navigationBarSettingShow:YES];
}


@end
