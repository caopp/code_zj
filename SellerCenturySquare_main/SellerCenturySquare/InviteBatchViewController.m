//
//  InviteBatchViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteBatchViewController.h"
#import "InviteSettingLevelTableViewCell.h"
#import "InviteContactInfoDTO.h"
#import "GetMerchantNotAuthTipDTO.h"
#import "HttpManager.h"
#import "GetInvMobileDTO.h"
#import "GetInvMobileListDTO.h"
#import "GUAAlertView.h"
#import "PurchaserLevelViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "CSPUtils.h"

typedef void (^FinishBlock)();
@interface InviteBatchViewController ()<UIAlertViewDelegate>
{

    GUAAlertView *customeAlertView;
    PurchaserLevelViewController *purchaserLevelVC;
    

}
@property(nonatomic,copy)NSString *sendPhoneNum;
@property(nonatomic,copy)InviteContactInfoDTO * tmpContactInfo;


@property (nonatomic,copy) FinishBlock completeBlock;
@property (nonatomic,strong) GetInvMobileListDTO *getInvMobileListDTO;

//!选择发送的联系人当中，不是手机号的 InviteContactInfoDTO 数组
@property(nonatomic,strong)NSMutableArray * unPhoneArray;

@property (weak, nonatomic) IBOutlet UIButton *sendInviteCodeBtn;


@end

@implementation InviteBatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设定等级";
    
    // !导航左按钮
    [self customBackBarButton];
    
    // !导航右按钮
    [self rightBarButton];
   
}
// !导航右按钮 --》采购商
-(void)rightBarButton{

    UIButton * button_back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 20.0f)];
    [button_back setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [button_back setTitleColor:[UIColor colorWithHex:0xe2e2e2] forState:UIControlStateNormal];
    [button_back.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button_back setTitle:@"采购商等级" forState:UIControlStateNormal];
       [button_back.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button_back addTarget:self action:@selector(levelBtnClickOK) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button_back];
    [backButton setStyle:UIBarButtonItemStyleDone];
    [self.navigationItem setRightBarButtonItem:backButton];
   
    
}

//采购商等级
- (void)levelBtnClickOK{

    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.isInvite = YES;
    prepaiduUpgradeVC.file = [HttpManager purchaserLevelNetworkRequestWebView];
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self authSetting];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions
- (void)authSetting{
    
    // !有权限设置等级
    if (_getMerchantNotAuthTipDTO.hasAuth) {
        
        _hasNoAuthView.hidden = YES;
        
    }else{// !无权限设置等级
        
        _hasNoAuthView.hidden = NO;
        
        NSString *string = [NSString stringWithFormat:@"您的等级为V%@，达到V%@后可设置采购商等级",_getMerchantNotAuthTipDTO.currentLevel,_getMerchantNotAuthTipDTO.readLevel];
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:string];
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]};
        
        [attriString setAttributes:attributes range:NSMakeRange(5, 2)];
        [attriString setAttributes:attributes range:NSMakeRange(10, 2)];
        
        _hasNoAuthL.attributedText =attriString;
        
        
        // !所有人的状态设为选中
        for (InviteContactInfoDTO *tmpContactInfo in _contactsInfo) {
            
            tmpContactInfo.isSelected = YES;
            
        }
        
        
    }
    
}
#pragma mark !底部等级设置按钮
- (IBAction)batchLevelButtonClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    for (int i = 10;i<16;i++) {// v1--v6
        
        UIButton *tmpBtn =(UIButton *)[self.view viewWithTag:i+1];
        
        if (tmpBtn.tag==btn.tag) {
            
            tmpBtn.selected = YES;
            
        }else{
            
            tmpBtn.selected = NO;
        }
        
    }
    
    // !改变选中联系人的等级
    for (InviteContactInfoDTO *tmpContactInfo in _contactsInfo) {
        
        if (tmpContactInfo.isSelected) {
            
            tmpContactInfo.shopLevel = btn.tag-10;
        }
    }
    
    [self.tableView reloadData];
    
}
#pragma mark !批量设置按钮
- (IBAction)batchSelectedButtonCliecked:(id)sender {

    
    UIButton *selectedButton = (UIButton *)sender;
    
    selectedButton.selected = !selectedButton.selected;// !批量设置按钮的状态

    if (selectedButton.selected) {// !选中的时候，所有数据改为选中状态
        
        for (InviteContactInfoDTO *tmpContactInfo in _contactsInfo) {
            
            tmpContactInfo.isSelected = YES;
        }
        
    }else{// !未选中的时候，所有数据改为未选中状态
        
        for (InviteContactInfoDTO *tmpContactInfo in _contactsInfo) {
            
            tmpContactInfo.isSelected = NO;
        }
        
    }
    
    [self.tableView reloadData];
    
    
}
#pragma mark 获取所有选中的数据
- (NSArray *)getSelectedContactsInfo{
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc]init];
    
    self.unPhoneArray = [NSMutableArray arrayWithCapacity:0];
    
    
    for (int i = 0; i<_contactsInfo.count ;i++) {
        
        _tmpContactInfo = (InviteContactInfoDTO *)_contactsInfo[i];
        
        DebugLog(@"_tmpContactInfo%@", _tmpContactInfo);

        //!去除电话号码中多余的字符
        
        _sendPhoneNum = _tmpContactInfo.phoneNum;
        
        DebugLog(@"self.sendPhoneNum%@", _sendPhoneNum);

        
        if (self.sendPhoneNum) {
            
            //!去掉所有-
            _sendPhoneNum =  [_sendPhoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            
            //!去掉所有空格
            _sendPhoneNum =  [_sendPhoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            
            //!复制通讯录最顶部自己的手机号会有这样的字符串
            _sendPhoneNum =  [_sendPhoneNum stringByReplacingOccurrencesOfString:@"\U0000202c" withString:@""];
            
            NSArray *componentArray = [_sendPhoneNum componentsSeparatedByString:@"+86"];
            _sendPhoneNum = componentArray[componentArray.count-1];
            
            
        }
        _tmpContactInfo.phoneNum = _sendPhoneNum;
        
        
        // !是选中状态
        if (_tmpContactInfo.isSelected) {
        
            BOOL isPhone = [CSPUtils checkMobileNumber:_tmpContactInfo.phoneNum];
            
            if (isPhone) {
                
                [selectedArr addObject:_tmpContactInfo];

            }else{
            
                [self.unPhoneArray addObject:_tmpContactInfo];
                
            }
            
        }
        
    }
    
    return selectedArr;
    
}
//!组成新的手机号，截取掉多余的内容
-(NSString *)combinNewPhoneNum:(NSString *)phoneNum{
    
     NSString * newPhoneNum =  phoneNum;
    
    if (newPhoneNum.length > 0) {
        
        //!去掉所有-
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        //!去掉所有空格
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //!复制通讯录最顶部自己的手机号会有这样的字符串
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@"\U0000202c" withString:@""];
        
        
        
        
        
        //!判断前面3位数字是否为+86
        //        NSString * headerStr = [newPhoneNum substringToIndex:4];
        //
        //        if ([headerStr isEqualToString:@"+86"]) {
        //
        //            newPhoneNum = [newPhoneNum substringFromIndex:3];
        //        }
        NSArray *componentArray = [newPhoneNum componentsSeparatedByString:@"+86"];
        newPhoneNum = componentArray[componentArray.count-1];
        
        
    }
    
    return newPhoneNum;
    
}

#pragma mark 获取最后要发送的数据
- (NSArray *)getNeedSendContactsInfo{
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc]init];
    
    for (InviteContactInfoDTO *tmpContactInfo in [self getSelectedContactsInfo]) {
        
        // !是选中状态
        if (tmpContactInfo.isSelected) {
            
            if (_getInvMobileListDTO.banInviteDTOList.count) {// !有不需要邀请的人
                
                // !判断是否在不需要邀请的数组里面 在的话移除
                for (int i = 0;i < _getInvMobileListDTO.banInviteDTOList.count ; i++) {
                    
                    GetInvMobileDTO * mobileDTO = _getInvMobileListDTO.banInviteDTOList[i];
                    if ([mobileDTO.memberAccount isEqualToString:tmpContactInfo.phoneNum]) {
                        
                        break;
                        
                    }else if (i==_getInvMobileListDTO.banInviteDTOList.count -1){
                        
                        [selectedArr addObject:tmpContactInfo];
                        
                    }
                    
                }
            }else{
            
                [selectedArr addObject:tmpContactInfo];
                
            }
           
            
        }
        
    }
    
    return selectedArr;
}

#pragma mark 发送邀请码按钮事件
- (IBAction)sendInviteCodeButtonClicked:(id)sender {
    
    /*
     有以下情况：
     全部正确
     1、全部是会员  ---》提示、return
     2、一部分是会员 ---》提示、给剩下的发送
     3、全部不是会员 ---》提示、给全部发送
     
     有不正确的
     1、除去不正确的，全部是会员----》提示 ，return
     2、除去不正确的，一部分是会员---》提示、给剩下的发送
     3、除去不正确的，全部不是会员---》提示 、给全部发送
     
     
     */
    
    NSArray *selectedContactsInfos = [self getSelectedContactsInfo];// !获取所有选中的、并且是手机号的 数据
    NSInteger allSelectCount = selectedContactsInfos.count + self.unPhoneArray.count;
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    NSString *detailInfo = [NSString stringWithFormat:@"叮咚欧品尊敬的客户:\n        您好,%@特邀您加入叮咚欧品-最懂你的高端服装批发平台。\n1、下载app\n2、使用当前手机号注册\n3、输入邀请码进入平台。",getMerchantInfoDTO.merchantName];
    
    
    __block NSString *msg = [NSString stringWithFormat:@"已选择%zi位联系人",allSelectCount];
        
    if (allSelectCount == 0) {
        
        [self.view makeMessage:@"请选择联系人" duration:2 position:@"center"];
        return;
        
    }else if (selectedContactsInfos.count == 0){//!选择的不为手机号 对象 个数 = 0
    
        [self.view makeMessage:@"您已选择的联系人的联系方式非手机号，请重新选择。" duration:2 position:@"center"];
        return;
        
    }

    
    // !获取联系人是否已经是会员的状态
    [self getContactInvitedState:^{
       
        //!全部是正确的手机号
        if (!self.unPhoneArray.count) {
            
            if (_getInvMobileListDTO.banInviteCount>0) {//!有已经是会员的
                
                if (_getInvMobileListDTO.getInvMobileDTOList.count) {//!一部分不是会员
                    
                    msg = [NSString stringWithFormat:@"其中%zi人已是会员\n将向其余%zi人发送邀请码",_getInvMobileListDTO.banInviteCount,_getInvMobileListDTO.getInvMobileDTOList.count];
                    
                    
                }else{// !全部是会员
                    
                    [self.view makeMessage:@"您选择的联系人，已全部是平台会员，请重新选择" duration:3 position:@"center"];
                    
                    return ;
                    
                }
                
                
            }//!else 是：全部是会员

        }else{//!有不正确的手机号
            
            if (_getInvMobileListDTO.banInviteCount > 0) {//!有已经是会员的
                
                if (_getInvMobileListDTO.getInvMobileDTOList.count) {//!一部分不是会员
                    
                    msg = [NSString stringWithFormat:@"其中%zi人已是会员\n其中%zi人的联系电话非手机号\n将向其余%zi人发送邀请码",_getInvMobileListDTO.banInviteCount,self.unPhoneArray.count,_getInvMobileListDTO.getInvMobileDTOList.count];

                    
                }else{//!剩下的全是会员
                
                    NSString * message = [NSString stringWithFormat:@"其中%zi人已是会员，其中%zi人的联系电话非手机号",_getInvMobileListDTO.banInviteCount,self.unPhoneArray.count];
                    
                    [self.view makeMessage:message duration:3 position:@"center"];
                
                    return;
                    
                }
                
            
            }else{//!全部不是会员
            
                msg = [NSString stringWithFormat:@"其中%zi人的联系电话非手机号\n将向其余%zi人发送邀请码",self.unPhoneArray.count,_getInvMobileListDTO.getInvMobileDTOList.count];
            
            }
        
        
        
        }
        
        
        if (customeAlertView) {
            
            [customeAlertView removeFromSuperview];
            
        }
        
        customeAlertView = [GUAAlertView alertViewWithTitle:@"确定发送邀请码?" withTitleClor:nil withTitleFont:16 message:msg withMessageColor:nil withMessageFont:13 withFileterLine:YES withDetailInfo:detailInfo withDeatilColor:nil withDeatilFont:12 oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self sendInviteCodeHttpRequest];

        } dismissAction:nil];

        //!计算变红色的位置
        //!有 非手机号的情况，需要给发送的人数设置为红色
        if (self.unPhoneArray.count) {
            
            [self changeCustomViewColor:msg];
            
        }else{
            
            
            //!没有非手机号的情况,需要给发送的人数设置为红色
            
            if (_getInvMobileListDTO.banInviteCount>0) {
                
                [self changeCustomViewColor:msg];
                
            }

            
        
        }
        
        
        [customeAlertView show];
        

        
    }];
    
    
}
-(void)changeCustomViewColor:(NSString *)msg{


    NSInteger msgLength = msg.length;//发送总内容的长度
    
    NSInteger lastMsgLength = [@"发送邀请码" length];//!接收人个数最后几个值
    NSInteger sendNumLength = [[NSString stringWithFormat:@"%lu",(unsigned long)_getInvMobileListDTO.getInvMobileDTOList.count] length];
    
    
    // !改变人数的颜色
    customeAlertView.changeIndex = msgLength - lastMsgLength - sendNumLength - 1;
    customeAlertView.changeNum = sendNumLength;
    customeAlertView.changeColor = [UIColor redColor];


}


#pragma mark - 发送邀请码的请求
- (void)sendInviteCodeHttpRequest{
    
    NSString *mobileList = [[NSString alloc]init];
  
    NSArray *contactsInfo = [self getNeedSendContactsInfo];
    
    for (InviteContactInfoDTO *inviteDTO in contactsInfo) {
        
        mobileList = [mobileList stringByAppendingFormat:@"%@,%zi|",inviteDTO.phoneNum,inviteDTO.shopLevel];
        
    }
    
    
    if (!mobileList) {
        return;
    }
    
    mobileList = [mobileList substringToIndex:mobileList.length-1];
    
    DebugLog(@"moblieList:%@", mobileList);
    
    self.sendInviteCodeBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForMemberInvite:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            

            [self.view makeMessage:@"发送成功" duration:3 position:@"center"];

            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(popClick) userInfo:nil repeats:NO];
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:3 position:@"center"];

        }
        
        self.sendInviteCodeBtn.enabled = YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.sendInviteCodeBtn.enabled = YES;

        [self.view makeMessage:@"发送失败" duration:3 position:@"center"];
        
    } ];
    
    
}
// !返回
-(void)popClick{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

    
}
#pragma mark 获取联系人是否已经是会员的状态 的请求
- (void)getContactInvitedState:(FinishBlock)completeBlock{
    
    if (self) {
        self.completeBlock = [completeBlock copy];
    }
    
    NSString *mobileList = [[NSString alloc]init] ;
    
//    if (_getMerchantNotAuthTipDTO.hasAuth) {
//        
//        NSArray *contactsInfo = [self getSelectedContactsInfo];// !读取所有选中的、是手机号的数据
//        
//        for (InviteContactInfoDTO *inviteDTO in contactsInfo) {
//            
//            mobileList = [mobileList stringByAppendingFormat:@"%@,",inviteDTO.phoneNum];
//        }
//        
//        
//    }else{
//        
//        // !读取列表所有的数据
//        for (InviteContactInfoDTO *tmpContactInfoDTO in _contactsInfo) {
//            
//            mobileList = [mobileList stringByAppendingFormat:@"%@,",tmpContactInfoDTO.phoneNum];
//        }
//        
//    }
    NSArray *contactsInfo = [self getSelectedContactsInfo];// !读取所有选中的、是手机号的数据
    
    for (InviteContactInfoDTO *inviteDTO in contactsInfo) {
        
        mobileList = [mobileList stringByAppendingFormat:@"%@,",inviteDTO.phoneNum];
    }
    
    
    
    if (mobileList.length>0) {
        
        mobileList  = [mobileList substringToIndex:mobileList.length-1];
    }
    
    
    
    self.sendInviteCodeBtn.enabled = NO;

    [HttpManager sendHttpRequestForGetMemberInviteList:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            _getInvMobileListDTO = [[GetInvMobileListDTO alloc] init];
            
            _getInvMobileListDTO.getInvMobileDTOList = [dic objectForKey:@"data"];
            
            if (self.completeBlock) {
                
                self.completeBlock();
            }
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:3 position:@"center"];

        }
    
        self.sendInviteCodeBtn.enabled = YES;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"请求失败" duration:3 position:@"center"];

        self.sendInviteCodeBtn.enabled = YES;

        
    }];
    
    
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contactsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteSettingLevelTableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteSettingLevelTableViewCell"];
    
    if (!inviteCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"InviteSettingLevelTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteSettingLevelTableViewCell"];
        inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteSettingLevelTableViewCell"];

    }
    
    InviteContactInfoDTO *contactInfo = _contactsInfo[indexPath.row];
    
    inviteCell.inviteContactInfoDTO = contactInfo;
    
    contactInfo.row = indexPath.row;
    
    [inviteCell setAuthState:_getMerchantNotAuthTipDTO.hasAuth];
    
    // Configure the cell...
    
    return inviteCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    return headerView;
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
