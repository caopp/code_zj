//
//  ConversationWindowViewController.m
//  IMTest
//
//  Created by 王剑粟 on 15/6/25.
//
//

#import "ConversationWindowViewController.h"
#import "UIView+KeyboardObserver.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "ACMacros.h"
#import "XMPPFramework.h"
#import "ChatManager.h"
#import "HttpManager.h"
#import "XMPPFramework.h"
#import "IMOrderTableViewCell.h"
#import "IMReferralTableViewCell.h"
#import "IMModelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DeviceDBHelper.h"
#import "CSPUtils.h"
#import "MJRefresh.h"
#import "ShopGoodsDTO.h"
#import "CPSGoodsDetailsPreviewViewController.h"

#import "CSPOrderRecordTableViewController.h"
#import "IMCollectOrderTableViewCell.h"
#import "NSDate+Utils.h"

#import "UIImage+Compression.h"
#import "OrderListTableViewCell.h"
#import "OrderDetaillViewController.h"
#import "OrderShowView.h"
#import "InquireView.h"
#import "AppDelegate.h"

#import "LoginDTO.h"
@interface ConversationWindowViewController () <UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDelegate, UITableViewDataSource, IMReferralBtnClickDelegate> {
    
    UUInputFunctionView *IFView;
    NSIndexPath * resendIndexPath;
    NSString * currentElementString;
    NSString * historyBodyType;
    long long timestamp;
    float yfloat;
    NSString * imtype;
    BOOL isFirst;
    BOOL isSendOrderList;
    NSString *mearchName;
    NSString *memberNo;
    NSString *iconUrl;//小B头像
    OrderShowView *orderShow;
    InquireView *inquireView;

}

@property (strong, nonatomic) ChatModel * chatModel;
@property (strong, nonatomic) NSMutableArray * historyArray;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) UIView *btnBgView;
@property (strong, nonatomic) NSDictionary *dicOrder;
@end

@implementation ConversationWindowViewController

- (instancetype)initWithSession:(ECSession *)session {
    
    self = [super init];
    if (self) {
        mearchName = session.merchantName;
        self.title = session.merchantName;
//        self.histrorySearchKey = session.sessionId;
        self.histrorySearchKey = session.jid;
        _receiver = session.jid;
        _currentECSession = session;
        memberNo = session.memberNo;
        [DeviceDBHelper sharedInstance].currentGoodNo = session.sessionId;
        imtype = @"0";//[NSString stringWithFormat:@"%d", session.sessionType];
    }
    
    return self;
}

- (instancetype)initWithNameWithYOffsent:(NSString *)name withJID:(NSString *)jid  withMemberNO:(NSString *)_memberNo{
    
    self = [super init];
    if (self) {
        self.title = name;
        mearchName = name;
        self.histrorySearchKey = jid;
        _receiver = jid;
        memberNo = _memberNo;
//        _currentECSession = [[IMMsgDBAccess sharedInstance] querySession:jid];
//        memberNo = _currentECSession.memberNo;
//        [DeviceDBHelper sharedInstance].currentGoodNo = jid;
        imtype = @"0";
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name withJID:(NSString *)jid  withMemberNo:(NSString *)_memberNo{
    
    self = [super init];
    if (self) {
        self.title = name;
        mearchName = name;

        self.histrorySearchKey = jid;
        _receiver = jid;
        _currentECSession = [[IMMsgDBAccess sharedInstance] querySession:_memberNo];
        memberNo = _memberNo;
        [DeviceDBHelper sharedInstance].currentGoodNo = jid;
        imtype = @"0";
    }
    
    return self;
}

//采购单
- (instancetype)initOrderWithName:(NSString *)name jid:(NSString *)receiverJid withMerchanNo:(NSString *)merchantNo withDic:(NSDictionary *)dtoDic {
    
    self = [super init];
    if (self) {
        //_dtoArrMast = dtoArr;
        _dicOrder = dtoDic;
        self.title = name;
        mearchName = name;
        memberNo = [dtoDic objectForKey:@"memberNo"];
        if([name length]==11&& [name hasPrefix:@"1"]){
            NSString *nickAccount = [name  stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            mearchName = nickAccount;
        }
        _receiver = receiverJid;
        self.histrorySearchKey = receiverJid;
        
        [DeviceDBHelper sharedInstance].currentGoodNo = merchantNo;
        isSendOrderList = YES;
        // for ( OrderGoodsItemDTO *dto in dtoArr) {
        
        
        // }
        
        //  [self getMerchantChatNo];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ChatManager shareInstance].memberNo = memberNo;
    // Do any additional setup after loading the view.
    
    //设置返回键
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"10_设置_后退"] style:UIBarButtonItemStyleDone target:self action:@selector(returnBtnClick:)];
    [self.navigationItem setLeftBarButtonItem:btnItem];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //添加历史记录按钮
    UIImage *searchimage=[UIImage imageNamed:@"10_商品图片下载_历史浏览"];
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    barbtn.image = searchimage;
    self.navigationItem.rightBarButtonItem=barbtn;

    [self initViewNormal];
    
    self.historyArray = [[NSMutableArray alloc] init];
    //获取到服务器时间 后 开启定时器
    if (_timeStart) {
        [[ChatManager shareInstance] openTime:([_timeStart longLongValue]+2000)];
        
    }
    timestamp = 0;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHistory)];
    
    [header setTitle:@"下拉加载更多信息..." forState:MJRefreshStateIdle];
    [header setTitle:@"释放加载更多信息" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.chatTableView.header = header;
    isFirst = YES;
    if (isSendOrderList) {
        [self sendOrderGood:_dicOrder withType:@"5"];
        isSendOrderList = NO;
        [self showOrderView:_dicOrder];
    }
    
    //清楚未读信息条数
    [[DeviceDBHelper sharedInstance] clearOneSessionUnReadCount:_currentECSession];
    
    
    [self getChatHistory:YES];
    
    //添加通知
    [self addNSNotification];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self tabbarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)returnBtnClick:(UIButton *)sender {
    
    [self removeNSNotification];
    [[ChatManager shareInstance] closeTime];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark ViewInit function
//普通聊天初始化
- (void)initViewNormal {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64)];
    
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 50 - 64)];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.bgView addSubview:self.chatTableView];
    [self.view addSubview:self.bgView];
    
    if (isiPhone4) {
        [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height - 88)];
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height - 88)];
    }
    [ChatManager shareInstance].memberNo = memberNo;
    if ([imtype isEqualToString:@"0"]) {
        IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:YES];
    }else {
        IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:NO];
    }
    IFView.TextViewChangeBlock =^(float f){
     
        CGRect frameTable = self.chatTableView.frame;
        frameTable.size.height  -= f;
        self.chatTableView.frame = frameTable;
    };
    IFView.delegate = self;
    [self.bgView addSubview:IFView];
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];

}

#pragma mark -
#pragma mark private function
//文本信息发送
- (void)encaseTextMessage:(NSString *)text {
    
    [[ChatManager shareInstance] SendTextMessage:text toUserID:_receiver withECSession:_currentECSession withMerchantname:mearchName];
}

//发送图片信息
- (void)encaseImage:(UIImage *)image withUUmessageFrame:(UUMessageFrame *)frame withLocalUrl:(NSString *)localUrl {
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"6" orderCode:@"" goodsNo:@"" file:UIImageJPEGRepresentation(image, 0.0000001f) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[ChatManager shareInstance] SendPicMessage:dic[@"data"] toUserID:_receiver withECSession:_currentECSession withMerchantname:self.title withLocalUrl:localUrl];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//发送相应的的商品信息
- (void)encaseGood:(ShopGoodsDTO *)goodInfoDetails {

    if (goodInfoDetails) {
         [[ChatManager shareInstance] SendGoodMessage:goodInfoDetails toUserID:_receiver withIMtype:imtype withMerchantname:mearchName withECSession:_currentECSession];
    }else{
        [[ChatManager shareInstance] SendOrderListMessage:_dicOrder toUserID:_receiver withMerchantname:mearchName];
    }
   
}


//tableView Scroll to bottom
- (void)tableViewScrollToBottom {
    
    if (self.chatModel.dataSource.count==0)
        return;
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatModel.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//tableview scroll to index
- (void)tableviewScrollToIndex:(NSInteger)index {
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_chatTableView scrollToRowAtIndexPath:scrollIndexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//接受到消息之后的处理
- (void)receiveMessage:(NSNotification *)notification {
    
    
    XMPPMessage * message = (XMPPMessage *)notification.object;
    
    NSArray *arr = [[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"];
    if (![arr isKindOfClass:[NSArray class]]&&arr.count ==0) {
        return;
    }
    NSString * gn = [arr objectAtIndex:0];
    NSLog(@"gn===%@===%@",gn,self.histrorySearchKey);
//    if ([[[message elementForName:@"sessionType"] stringValue] intValue] == 1) {
//        gn = [gn stringByAppendingString:[NSString stringWithFormat:@"_%@",[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0]]];
//    }
    
    if([gn isEqualToString:self.histrorySearchKey]){
    
        if ([[[message.fromStr componentsSeparatedByString:@"@"] objectAtIndex:0] isEqualToString:_receiver]) {
            NSString *bodyType = [[message elementForName:@"bodyType"] stringValue];
            
            if([bodyType isEqualToString:@"0"]) {
                
                //文本信息
                NSString *body = [[message elementForName:@"body"] stringValue];
                NSDictionary *dic = @{@"strContent": body,
                                      @"type": @(UUMessageTypeText),
                                      @"strTime": [NSDate stringLoacalDate],
                                      @"strIcon": [[message elementForName:@"iconUrl"] stringValue]
                                      };
                [self.chatModel addOtherItem:dic withIsHistory:NO];
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
            }else if ([bodyType isEqualToString:@"1"]){
                
                NSString *imgUrl = [[message elementForName:@"Url"] stringValue];
                NSDictionary *dic = @{@"picture": [UIImage imageNamed:@"goods_placeholder"],
                                      @"type": @(UUMessageTypePicture),
                                      @"remotePath": imgUrl,
                                      @"strTime": [NSDate stringLoacalDate],
                                      @"strIcon": [[message elementForName:@"iconUrl"] stringValue]
                                      };
                UUMessageFrame * frame = [self.chatModel addOtherItem:dic withIsHistory:NO];
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
                [self loadImage:imgUrl withFrame:frame];
            }else {
                
                XMPPMessage * message = (XMPPMessage *)notification.object;
                [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:message withIsSender:0] withIsHistory:NO];
                if ([bodyType isEqualToString:@"5"]) {
                    [self showOrderVieMessage:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:message withIsSender:0] ];
                }else if([bodyType isEqualToString:@"2"]){
                    [self showInquireViewMessage:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:message withIsSender:0]];
                }
                
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
            }
        }
    }
    if (_currentECSession) {
        //清楚未读信息条数
        [[DeviceDBHelper sharedInstance] clearOneSessionUnReadCount:_currentECSession];
    }
   
}

//发送推送
-(void)sendPush:(NSNumber *)type withTitle:(NSString *)title{
//    [HttpManager sendHttpRequestForGetChatPusher:type title:title acountType:@"1" acounts:<#(NSString *)#> targets:<#(NSString *)#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>];
}
//异步加载图片
- (void)loadImage:(NSString *)url withFrame:(UUMessageFrame *)frame {
    
    //异步加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                frame.message.picture = image;
                frame.message.messageStatus = UUMessageStatusSuccess;
                [_chatTableView reloadData];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                frame.message.messageStatus = UUMessageStatusPicError;
                [_chatTableView reloadData];
            });
        }
    });
}

//添加各种通知
- (void)addNSNotification {
    
    [self.bgView addKeyboardObserver];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getServerTime) name:@"getMerchantChatNo" object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:ReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
        
    // set views with new info
    [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, 0 + keyboardBounds.size.height, self.chatTableView.frame.size.width, Main_Screen_Height - 64 - 50 - keyboardBounds.size.height)];
        
    [self tableViewScrollToBottom];
        
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.showThridKeyboard = NO;
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
        
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
        
    // set views with new info
    [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, 0, self.chatTableView.frame.size.width, Main_Screen_Height - 64 - 50)];
    
    [self tableViewScrollToBottom];
        
    // commit animations
    [UIView commitAnimations];
}

//移除各种通知
- (void)removeNSNotification {
    
    [self.bgView removeKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMerchantChatNo" object:nil];
    [DeviceDBHelper sharedInstance].currentGoodNo = nil;
}

- (void)dealTheFunctionData {
    
    [_chatTableView reloadData];
}

#pragma mark -
#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    NSString *strTime;
    if ([ChatManager shareInstance].timesever) {
        strTime = [CSPUtils getTime:[ChatManager shareInstance].timesever];
    }else{
        strTime = [NSDate stringLoacalDate];
    }
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText),
                          @"strTime": strTime
                          };
    funcView.TextViewInput.text = @"";
    if (self.chatModel.dataSource.count == 0) {
        isFirst = YES;
    }
    [self.chatModel addSpecifiedItem:dic withIsHistory:NO];
    [self dealTheFunctionData];
    [self tableViewScrollToBottom];
    [self encaseTextMessage:message];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image withUrl:(NSString *)url {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    NSString *strTime;
    if ([ChatManager shareInstance].timesever) {
        strTime = [CSPUtils getTime:[ChatManager shareInstance].timesever];
    }else{
        strTime = [NSDate stringLoacalDate];
    }
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture),
                          @"strTime": strTime
                          };
    if (self.chatModel.dataSource.count == 0) {
        isFirst = YES;
    }
    UUMessageFrame * frame = [self.chatModel addSpecifiedItem:dic withIsHistory:NO];
    [self dealTheFunctionData];
    [self tableViewScrollToBottom];
    [self encaseImage:image withUUmessageFrame:frame withLocalUrl:url];
}
//发送相应商品信息时的相应的处理
- (void)sendOrderGood:(NSDictionary *)dtoDic withType:(NSString *)type {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    
    [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:[XMPPMessage messageFromElement:[[ChatManager shareInstance]packageOrderGoodsInfoWithDic:dtoDic withName:mearchName withType:@"5" toUserID:_receiver]] withIsSender:0] withIsHistory:NO];
    
    [self dealTheFunctionData];
    [self encaseGood:nil];
}



- (void)SendGoods:(UUInputFunctionView *)funcView withGoods:(NSMutableArray *)goods {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    
    if (goods.count > 0) {
        for (ShopGoodsDTO * shopGoodsDTO in goods) {
            if (self.chatModel.dataSource.count == 0) {
                isFirst = YES;
            }
            
            shopGoodsDTO.searchGoodNo = self.histrorySearchKey;
            //shopGoodsDTO.goodsNo = shopGoodsDTO.goodsNo;//self.histrorySearchKey;
            
            [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:[XMPPMessage messageFromElement:[[ChatManager shareInstance] packageGoodsInfo:shopGoodsDTO toUserID:_receiver withIMtype:imtype withMerchantname:[GetMerchantInfoDTO sharedInstance].merchantName withECSession:_currentECSession]] withIsSender:0] withIsHistory:NO];
            [self dealTheFunctionData];
            [self tableViewScrollToBottom];
            [self encaseGood:shopGoodsDTO];
        }
    }
}

#pragma mark -
#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){

        ECMessage * message = (ECMessage *)[self.chatModel.dataSource objectAtIndex:indexPath.row];
        
        
        
        if (message.type == 2) {
         
            ///
            static NSString *cellID = @"IMCollectOrderTableViewCell";
            IMCollectOrderTableViewCell *cell = (IMCollectOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMCollectOrderTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:message.goodPic]];
            [cell loadMessage:message];
            return cell;
        }else if (message.type == 5){
            static NSString *cellID = @"OrderListTableViewCell";
            OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            
            [cell loadMessage:message];
            return cell;

        }
//        if (message.type == 2) {
//            
//            static NSString *cellID = @"IMOrderTableViewCell";
//            IMOrderTableViewCell * cell = (IMOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
//            
//            if (cell == NULL) {
//                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMOrderTableViewCell" owner:self options:nil] ;
//                cell = [nib objectAtIndex:0];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            
//            cell.lblGoodNo.text = message.goodsWillNo;//[[message.goodNo componentsSeparatedByString:@"_"] objectAtIndex:0];
//            cell.lblGoodColor.text = message.goodColor;
//            cell.lblGoodPrice.text = [NSString stringWithFormat:@"￥%@", message.goodPrice];
//            //cell.jsonSku = message.goodSku;
//            
//            if(![message.goodPic isEqualToString:@"04_商品列表_邮费专拍"]) {
//                [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:message.goodPic]];
//            }else {
//                [cell.picImageView setImage:[UIImage imageNamed:message.goodPic]];
//            }
//            
//            return cell;
//            
//        }
        else if(message.type == 4) {
            
            static NSString *cellID = @"IMReferralTableViewCell";
            IMReferralTableViewCell * cell = (IMReferralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMReferralTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.timeLabel.text =message.showTime?  [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
            cell.strGoodNo = message.goodNo;
            cell.lblGoodNo.text =message.goodsWillNo;
            cell.lblGoodColor.text = message.goodColor;
            cell.lblGoodPrice.text = [NSString stringWithFormat:@"￥%@", message.goodPrice];
            [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:message.goodPic]];
            
            return cell;
        }else if (message.type == 3) {
            
            static NSString *cellID = @"IMModelTableViewCell";
            IMModelTableViewCell * cell = (IMModelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMModelTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.timeLabel.text =message.showTime?  [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
            cell.lblGoodNo.text = message.goodsWillNo;//[[message.goodNo componentsSeparatedByString:@"_"] objectAtIndex:0];
            cell.lblGoodColor.text = message.goodColor;
            cell.lblGoodPrice.text = [NSString stringWithFormat:@"￥%@", message.goodPrice];
            [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:message.goodPic]];
            
            return cell;
        }
        
    }else{
        
        UUMessageCell * cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID" withIndexPath:indexPath];
        cell.delegate = self;
        
        UUMessageFrame * frame = (UUMessageFrame *)self.chatModel.dataSource[indexPath.row];
        
        if (cell.messageFrame.message.from == UUMessageFromMe) {
            cell.messageStatus = frame.message.messageStatus;
        }
        [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){
        
        ECMessage * message = (ECMessage *)[self.chatModel.dataSource objectAtIndex:indexPath.row];
        if (message.type == 3 || message.type == 4) {
            return 105.0f+40;
        }else if(message.type == 2){
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
            CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width-130, 0)];
            if (rect.size.height <80) {
                return 120+40;
            }
            return rect.size.height + 40+40;
        }else if(message.type == 5){
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
            CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
            NSLog(@"rect.height:%g", rect.size.height);
            return rect.size.height + 20+40;
            

        }else {
            return 200;
//            NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&err];
//            if(dic != nil && err == nil){
//                
//                NSArray * keysArray = [dic allKeys];
//                if (keysArray.count <= 6) {
//                    return 145.0f;
//                }else {
//                    int num = ((int)keysArray.count - 6) / 2;
//                    if (((int)keysArray.count - 6) % 2 > 0) {
//                        num ++;
//                    }
//                    
//                    return 145.0f + num * 20;
//                }
//            }else {
//                
//                return 145.0f;
//            }
        }
        
    }else
        return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){
        
        ECMessage * message = (ECMessage *)[self.chatModel.dataSource objectAtIndex:indexPath.row];
        
        if (message.type == 3 || message.type == 2) {
         
            CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
            
            goodsDetailsPreviewViewController.isPreview = NO;
            goodsDetailsPreviewViewController.noGoodsListView = YES;
            
            goodsDetailsPreviewViewController.isFromConversation = YES;
           NSString *goodNo =  [[message.goodNo componentsSeparatedByString:@"_"] objectAtIndex:0];

            goodsDetailsPreviewViewController.goodsNo = [[goodNo componentsSeparatedByString:@";"] objectAtIndex:0];
            [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
        }else if(message.type == 5){
            NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            if (!jsonData) {
                return;
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            //
            
            NSString *orderNo = [dic objectForKey:@"orderNo"];
            OrderDetaillViewController * orderVC = [[OrderDetaillViewController alloc]init];
            
            orderVC.orderCode = orderNo;
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }else if(message.type == 4){
            CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
            
            goodsDetailsPreviewViewController.isPreview = NO;
            goodsDetailsPreviewViewController.noGoodsListView = YES;
            goodsDetailsPreviewViewController.isFromConversation = YES;
            
            goodsDetailsPreviewViewController.goodsNo = message.goodNo;
            
            [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)IMReferralBtnClick:(NSString *)goodsNo {
    
    CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
    
    goodsDetailsPreviewViewController.isPreview = NO;
    
    goodsDetailsPreviewViewController.isFromConversation = YES;
    
    goodsDetailsPreviewViewController.goodsNo = goodsNo;
    
    [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
}


-(void)showOrderView:(NSDictionary *)goodsInfoDic{
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
    if (inquireView) {
        [inquireView  removeFromSuperview];
    }
    orderShow = [[[NSBundle mainBundle] loadNibNamed:@"OrderShowView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:orderShow];
    [orderShow showOrderWithDic:goodsInfoDic];
     orderShow.frame = CGRectMake(0, 0, self.view.frame.size.width,isFirst?210:self.view.frame.size.height/4);
}
-(void)showOrderVieMessage:(ECMessage *)message{
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
    if (inquireView) {
        [inquireView  removeFromSuperview];
    }
    orderShow = [[[NSBundle mainBundle] loadNibNamed:@"OrderShowView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:orderShow];
    [orderShow showOrderWithMessage:message];
    orderShow.frame = CGRectMake(0, 0, self.view.frame.size.width,isFirst?210:self.view.frame.size.height/4);
}
-(void)showInquireViewMessage:(ECMessage *)message{
    NSArray *arrGoodNo = [message.goodNo componentsSeparatedByString:@";"];
    NSArray *arrColor =  [message.goodColor componentsSeparatedByString:@";"];
    NSArray *arrGoodsWillNo =  [message.goodsWillNo componentsSeparatedByString:@";"];
    NSArray *arrPrice =  [message.goodPrice componentsSeparatedByString:@";"];
    
    NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSMutableArray *skuList = [dic objectForKey:@"skuList"];
    
    NSString *messageType = [dic objectForKey:@"msgType"];
    NSArray *arrType = [messageType componentsSeparatedByString:@";"];
    BOOL isCount = NO;//总采购单量
    for (int i =0 ;i< arrColor.count;i++) {
        
        NSString *modeType = [arrType objectAtIndex:i];
        NSDictionary *dic = [skuList objectAtIndex:i];
        
        for (NSString * skuName in dic.allKeys) {
            NSString *value = [[[dic objectForKey:skuName] componentsSeparatedByString:@","] objectAtIndex:0];
            if ([value intValue]>0||[modeType isEqualToString:@"3"]) {
                isCount = YES;
            }
        }
    }
    if (inquireView) {
        [inquireView  removeFromSuperview];
    }
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
    inquireView = [[[NSBundle mainBundle] loadNibNamed:@"InquireView" owner:self options:nil] objectAtIndex:0];
    float h = (arrColor.count *30< 100)?100:(arrColor.count *30) ;
    inquireView.frame = CGRectMake(0, 0, self.view.frame.size.width,h);
    
    [self.view addSubview:inquireView];
    [inquireView.inquireImgV sd_setImageWithURL:[NSURL URLWithString:message.goodPic]];
  
    for (int i =0 ;i< arrColor.count;i++) {
        NSString *goodNo = [arrGoodNo objectAtIndex:i];
        NSString *color = [arrColor objectAtIndex:i];
        NSString *goodsWillNo =[arrGoodsWillNo objectAtIndex:i];
        NSString *price = [arrPrice objectAtIndex:i];
        NSString *modeType = [arrType objectAtIndex:i];
        NSDictionary *dic = [skuList objectAtIndex:i];
        BOOL isExcited = NO;
        for (NSString * skuName in dic.allKeys) {
            NSString *value = [[[dic objectForKey:skuName] componentsSeparatedByString:@","] objectAtIndex:0];
            if ([value intValue]>0||[modeType isEqualToString:@"3"]) {
                isExcited = YES;
            }
        }
        if (!isExcited&&isCount) {
            continue;
        }
        UILabel *labelH = [UILabel new];
        labelH.font = [UIFont systemFontOfSize:13.0];
        labelH.textColor = [UIColor whiteColor];
        labelH.textAlignment = NSTextAlignmentLeft;
        labelH.heightDime.min(15);
        labelH.leftPos.equalTo(@(0));
        labelH.topPos.equalTo(@(0));
        labelH.widthDime.equalTo(@(inquireView.frame.size.width - 180));
        if (![modeType isEqualToString:@"2"]) {
            labelH.text = [NSString stringWithFormat:@" %@  %@样板  ￥%@",goodsWillNo,color,price];
        }else{
            labelH.text = [NSString stringWithFormat:@" %@  %@  ￥%@",goodsWillNo,color,price];
        }
        
        [labelH sizeToFit];
        [inquireView.flowLayout addSubview:labelH];
    }
    
}

- (void)rightClick {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPOrderRecordTableViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPOrderRecordTableViewController"];
    nextVC.memberNo = memberNo;
//    if (_currentSession) {
//        nextVC.merchantNo = _currentSession.merchantNo;
//    }else {
//        nextVC.merchantNo = _merchantno;
//    }
    nextVC.reOrderSendBlock=^(NSDictionary *dicOrder){
        [dicOrder setValue:self.title forKey:@"merchantName"];
        _dicOrder = dicOrder;
        [self sendOrderGood:dicOrder withType:@"5"];
        [self showOrderView:dicOrder];
    };
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)getHistory
{
    [self getChatHistory:YES];
}


/** 查询聊天记录 */
- (void)getChatHistory:(BOOL) isAddMore {
    
    if (isFirst) {
        [self.chatModel.dataSource removeAllObjects];
    }
    
    if (self.historyArray.count == 0) {
        if([ChatManager shareInstance].timesever){
            timestamp = [ChatManager shareInstance].timesever;
        }else{
            timestamp = [CSPUtils getTimeStampFromNSDate:[NSDate date]];
            
        }
    }
    
//    NSArray * array = [[DeviceDBHelper sharedInstance] getMessageOfSessionId:self.histrorySearchKey beforeTime:timestamp andPageSize:messagePageSize];
    NSArray * array = [[DeviceDBHelper sharedInstance] getMessageOfSessionId:memberNo beforeTime:timestamp andPageSize:messagePageSize];

    
    if (array != nil && array.count != 0) {
        
        for(int i = array.count -1; i >= 0; i--) {
            
            ECMessage * message = (ECMessage *)[array objectAtIndex:i];
            
            NSDictionary *dic;
            UUMessageFrame * frame;
            
            //判断消息的类型展示不同的数据
            if (message.type == 0) {
                
                if(_currentECSession != nil) {
                    NSLog(@"%@----%@---%@---%@",message.text,@(UUMessageTypeText),[CSPUtils getTime:message.dateTime],_currentECSession.iconUrl);
                    dic = @{@"strContent": message.text,
                            @"type": @(UUMessageTypeText),
                            @"strTime": [CSPUtils getTime:message.dateTime],
                            @"strIcon": _currentECSession.iconUrl?_currentECSession.iconUrl:@"",
                            };
                }else {
                    
                    dic = @{@"strContent": message.text,
                            @"type": @(UUMessageTypeText),
                            @"strTime": [CSPUtils getTime:message.dateTime],
                            @"strIcon": @""
                            };
                }
                
                if (message.isSender == 1) {
                    
                    [self.chatModel addSpecifiedItem:dic withIsHistory:YES];
                }else {

                    [self.chatModel addOtherItem:dic withIsHistory:YES];
                }
            }else if(message.type == 1) {
                
                if ([UIImage imageWithContentsOfFile:message.localPath] == nil) {
                    
                    if (_currentECSession != nil) {
                        dic = @{@"picture": [UIImage imageNamed:@"goods_placeholder"],
                                @"type": @(UUMessageTypePicture),
                                @"remotePath": message.URL,
                                @"strTime": [CSPUtils getTime:message.dateTime],
                                @"strIcon": _currentECSession.iconUrl?_currentECSession.iconUrl:@"",
                                };
                    }else {
                        
                        dic = @{@"picture": [UIImage imageNamed:@"goods_placeholder"],
                                @"type": @(UUMessageTypePicture),
                                @"remotePath": message.URL,
                                @"strTime": [CSPUtils getTime:message.dateTime],
                                @"strIcon": @""
                                };
                    }
                    
                    
                    if (message.isSender == 1) {
                        
                        frame = [self.chatModel addSpecifiedItem:dic withIsHistory:YES];
                    }else {
                        
                        frame = [self.chatModel addOtherItem:dic withIsHistory:YES];
                    }
                    
                    [self loadImage:message.URL withFrame:frame];
                    
                }else {
                    
                    if (_currentECSession != nil) {
                        dic = @{@"picture": [UIImage imageWithContentsOfFile:message.localPath],
                                @"type": @(UUMessageTypePicture),
                                @"strTime": [CSPUtils getTime:message.dateTime],
                                @"strIcon": _currentECSession.iconUrl?_currentECSession.iconUrl:@""
                                };
                    }else {
                        
                        dic = @{@"picture": [UIImage imageWithContentsOfFile:message.localPath],
                                @"type": @(UUMessageTypePicture),
                                @"strTime": [CSPUtils getTime:message.dateTime],
                                @"strIcon": @""
                                };
                    }
                    
                    
                    if (message.isSender == 1) {
                        
                        frame = [self.chatModel addSpecifiedItem:dic withIsHistory:YES];
                    }else {
                        
                        frame = [self.chatModel addOtherItem:dic withIsHistory:YES];
                    }
                }
            }else if (message.type == 2) {
                
                [self.chatModel addOrderItem:message withIsHistory:YES];
                
            }else if (message.type == 3) {
            
                [self.chatModel addOrderItem:message withIsHistory:YES];
            }else if (message.type == 4) {
            
                [self.chatModel addOrderItem:message withIsHistory:YES];
            }
            else if (message.type == 5) {
                
                [self.chatModel addOrderItem:message withIsHistory:YES];
            }
            [self.historyArray addObject:message];
        }
        timestamp = ((ECMessage *)[array objectAtIndex:0]).dateTime - 1;
    }else if (isAddMore)
    {
        [self getHistoryForSever];
        return;
    }
    
    [self.chatTableView.header endRefreshing];
    
    [_chatTableView reloadData];
    
    if (isFirst) {
        [self tableViewScrollToBottom];
        isFirst = NO;
    }
}

-(void)getHistoryForSever{
    if (self.historyArray.count == 0) {
        if([ChatManager shareInstance].timesever){
            timestamp = [ChatManager shareInstance].timesever;
        }else{
            timestamp = [CSPUtils getTimeStampFromNSDate:[NSDate date]];
            
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForGetChantHistoryWithUser:memberNo withTime:[CSPUtils getTime:timestamp] pageNo:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:messagePageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        BOOL isShowSession;//刷新 聊天列表
        if (self.chatModel.dataSource.count) {
            isShowSession = NO;
        }else{
            isShowSession = YES;
        }
        for (NSDictionary *dicMessage  in arr) {
            NSString *strXml = [dicMessage objectForKey:@"message"];
            DDXMLElement *ddxml = [[DDXMLElement alloc] initWithXMLString:strXml error:nil];
            XMPPMessage *messageXml = [XMPPMessage messageFromElement:ddxml];
            
           NSString *jid = [[DeviceDBHelper sharedInstance] insertMessage:messageXml withIsSender:YES withAddSession:isShowSession];
            if (isShowSession) {
                _receiver = jid;
            }
            isShowSession = NO;
           
        }
        if (arr) {
            [self getChatHistory:NO];
            
        }else{
            
            
            [self.chatTableView.header endRefreshing];
            
            [_chatTableView reloadData];
            
            if (isFirst) {
                [self tableViewScrollToBottom];
                isFirst = NO;
            }
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
}

// 获取服务器时间
-(void)getServerTime{
    [HttpManager sendHttpRequestForGetChantTimeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//
            NSLog(@"dic = %@",dic);
            NSNumber *time = [dic objectForKey:@"data"];
         
            self.timeStart = time;
          [[ChatManager shareInstance] openTime:([time longLongValue]+2000)];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
