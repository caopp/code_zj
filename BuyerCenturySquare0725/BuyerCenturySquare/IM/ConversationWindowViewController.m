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
#import "UUBtnView.h"
#import "HttpManager.h"
#import "IMModityOrder.h"
#import "XMPPFramework.h"
#import "CartAddDTO.h"
#import "IMOrderTableViewCell.h"
#import "IMReferralTableViewCell.h"
#import "IMModelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DoubleSku.h"
#import "DeviceDBHelper.h"
#import "CSPUtils.h"
#import "MJRefresh.h"
#import "CustomBarButtonItem.h"

#import "CSPShoppingCartViewController.h"
#import "CSPOrderRecordTableViewController.h"
#import "MyOrderDetailViewController.h"
#import "CSPGoodsInfoTableViewController.h"
#import "GoodDetailViewController.h"
#import "GoodsInfoDTO.h"

#import "IMMsgDBAccess.h"
#import "NSDate+Utils.h"
#import "BuyCarAlertView.h"
#import "BuyUnLimView.h"
#import "IMCollectOrderTableViewCell.h"
#import "OrderListTableViewCell.h"
#import "OrderGoodsItemDTO.h"

#import "OrderShowView.h"
#import "InquireView.h"
#import "AppDelegate.h"
#import "PersonalCenterDTO.h"
#import "LoginDTO.h"
#import "TextAlertTableViewCell.h"
#define buycarTag 999
@interface ConversationWindowViewController () <UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDelegate, UITableViewDataSource, UUBtnViewDelegate, IMReferralBtnClickDelegate,IMOrderDelegate,BuyCarDelegate,UITableViewDataSource,UITabBarDelegate,UIGestureRecognizerDelegate> {
    
    UUInputFunctionView *IFView;
    UUBtnView *btnView;
    IMModityOrder * modityOrderView;
    NSIndexPath * resendIndexPath;
    NSString * currentElementString;
    NSString * historyBodyType;
    long long timestamp;
    BOOL isFirst;
    BOOL goGoodBack;
    
    InquireView *inquireView;
    OrderShowView *orderShow;
    
    int pageCount;
    NSNumber  *chatCount;//等待人数
    NSString *preMessageId;//前一条消息 id  规避接受 重复消息
    
}

@property (strong, nonatomic) ChatModel * chatModel;
@property (strong, nonatomic) NSMutableArray * historyArray;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) UIView *btnBgView;
@property (strong, nonatomic) NSArray *dtoArrMast;
@property (strong, nonatomic)NSDictionary *dicOrder;
//
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ConversationWindowViewController

//询单
- (instancetype)initWithName:(NSString *)name jid:(NSString *)receiverJid withArray:(NSArray *)dtoArr {
    
    self = [super init];
    if (self) {
        
        _dtoArrMast = dtoArr;
        
        for ( IMGoodsInfoDTO *dto in dtoArr) {
            _imGoodsInfoDTO = dto;
            _merchantno = dto.merchantNo;
            self.title = dto.merchantName;
            self.histrorySearchKey = dto.merchantNo;
            
            _receiver = receiverJid;
            
            [DeviceDBHelper sharedInstance].currentGoodNo = dto.merchantNo;
//            if(dto.sessionType == 0) {
//                _imType = IMType_Service;
//            }else {
                _imType = IMType_Order;
//            }
            _isSendOrder = YES;
            
            //更新询单信息
            [[IMMsgDBAccess sharedInstance] updateIMGoodsInfoDTO:dto];
           
        }
       
      //  [self getMerchantChatNo];
    }
    
    return self;
}


//采购单
- (instancetype)initOrderWithName:(NSString *)name jid:(NSString *)receiverJid withMerchanNo:(NSString *)merchantNo withDic:(NSDictionary *)dtoDic {
    
    self = [super init];
    if (self) {
        //_dtoArrMast = dtoArr;
        
        _imGoodsInfoDTO = [[IMGoodsInfoDTO alloc] init];
        _imGoodsInfoDTO.merchantNo = merchantNo;
        _imGoodsInfoDTO.merchantName = name;
        _merchantno = merchantNo;
        _dicOrder = dtoDic;
        self.title = name;
        _receiver = receiverJid;
//        self.histrorySearchKey = merchantNo;
        self.histrorySearchKey = merchantNo;
        
        
        [DeviceDBHelper sharedInstance].currentGoodNo = merchantNo;
       _imType = IMType_Service;
         _isSendOrderList = YES;
       // for ( OrderGoodsItemDTO *dto in dtoArr) {


       // }
        
        //  [self getMerchantChatNo];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name jid:(NSString *)receiverJid withGood:(IMGoodsInfoDTO *)dto {
    
    self = [super init];
    if (self) {
        
        
        _merchantno = dto.merchantNo;
        self.title = dto.merchantName;
        
        self.histrorySearchKey = dto.merchantNo;
        
        _receiver = receiverJid;
        
        [DeviceDBHelper sharedInstance].currentGoodNo = dto.merchantNo;
        if(dto.sessionType == 0) {
            _imType = IMType_Service;
        }else {
            _imType = IMType_Order;
        }
        _imGoodsInfoDTO = dto;
        _isSendOrder = YES;
        
        //更新询单信息
        [[IMMsgDBAccess sharedInstance] updateIMGoodsInfoDTO:dto];
        
        //[self getMerchantChatNo];
    }
    
    return self;
}
//客服
- (instancetype)initServiceWithName:(NSString *)name jid:(NSString *)receiverJid withMerchantNo:(NSString *)merchantNo{
    
    self = [super init];
    if (self) {
        
        self.title = name;
        self.histrorySearchKey = merchantNo;
        _receiver = receiverJid;
        [DeviceDBHelper sharedInstance].currentGoodNo = merchantNo;
        _imGoodsInfoDTO = [[IMGoodsInfoDTO alloc] init];
        
        
        _imGoodsInfoDTO.goodsNo = receiverJid;
        _imGoodsInfoDTO.merchantName = self.title;
        _imGoodsInfoDTO.sessionType = 0;
        _imGoodsInfoDTO.goodColor = @"客服";
        _imGoodsInfoDTO.goodPic = @"客服";
        _imGoodsInfoDTO.price = [NSNumber numberWithDouble:0.00];
        _imGoodsInfoDTO.merchantNo = merchantNo;
        
        
        _imType = IMType_Service;
        _merchantno = merchantNo;
        
        //判断  _receiver 是否存在
        if (_receiver&&[_receiver length]) {
        }else
            [self getMerchantChatNo];
    }
    
    return self;
}
//聊天列表
- (instancetype)initWithSession:(ECSession *)session {
    
    self = [super init];
    if (self) {
        self.title = session.merchantName;
        //根据 商家编码  搜索
        self.histrorySearchKey = session.merchantNo;
        _merchantno = session.merchantNo;
        _currentSession = session;
        _receiver = session.sessionId;
        [DeviceDBHelper sharedInstance].currentGoodNo = session.merchantNo;
        // 
        if (session.sessionType == 1) {
            
            _imGoodsInfoDTO = [[IMMsgDBAccess sharedInstance] queryIMGoodsInfoDTO:session.merchantNo];
            _imGoodsInfoDTO.merchantNo = session.merchantNo;
             _imGoodsInfoDTO.merchantName = session.merchantName;
        }else {
            
            _imGoodsInfoDTO = [[IMGoodsInfoDTO alloc] init];
            _imGoodsInfoDTO.goodsNo = session.goodNo;
            _imGoodsInfoDTO.merchantName = session.merchantName;
            _imGoodsInfoDTO.sessionType = session.sessionType;
            _imGoodsInfoDTO.merchantNo = session.merchantNo;
        }
        _imType = IMType_Service;
//        if(session.sessionType == 0){
//            _imType = IMType_Service;
//        }else {
//            _imType = IMType_Order;
//        }
    }
    
    

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    pageCount = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置返回键样式
//    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnBtnClick:)];
//    [self.navigationItem setLeftBarButtonItem:btnItem];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(returnBtnClick:) target:self]];

    //添加历史记录按钮
    UIImage *searchimage=[UIImage imageNamed:@"10_商品图片下载_历史浏览"];
    CustomBarButtonItem *barbtn=[[CustomBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    barbtn.image = searchimage;
    self.navigationItem.rightBarButtonItem=barbtn;
    if ([BigBOrSmallB isEqualToString:@"SmallB"] && _imType == IMType_Order) {
        //@询单
        [self initViewOrder];
    }else {
        //@客服会话
        [self initViewNormal];
    }
    
    //数据数组
    self.historyArray = [[NSMutableArray alloc] init];
    //获取到服务器时间 后 开启定时器
    if (_timeStart) {
        [[ChatManager shareInstance] openTime:([_timeStart longLongValue]+2000)];

    }
    timestamp = 0;
    
    MJRefreshGifHeader *_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHistory)];
    
    [_header setTitle:@"下拉加载更多信息..." forState:MJRefreshStateIdle];
    [_header setTitle:@"释放加载更多信息" forState:MJRefreshStatePulling];
    [_header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    _header.lastUpdatedTimeLabel.hidden = YES;
    
    self.chatTableView.mj_header = _header;
    isFirst = YES;
    //清空未读信息
    if (_currentSession != nil) {
        [[DeviceDBHelper sharedInstance] clearOneSessionUnReadCount:_currentSession];
    }
    
    //询单进入
    if (_isSendOrder) {
    
         [self sendGood:_imGoodsInfoDTO withType:@"2"];
        [self showInquireView:_dtoArrMast];
        _isSendOrder = NO;
    }
    
    //订单历史进入
    if (_isSendOrderList) {
        
        [self sendOrderGood:_dicOrder withType:@"5"];
        [self showOrderView:_dicOrder];
        _isSendOrderList = NO;
    }
    
//获取 聊天漫游 数据 no 不需要聊天数据
    [self getChatHistory:YES];
    
//    [self getChatHistory:NO];
//    

//    
    //添加通知
    [self addNSNotification];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self requestPerCenterInfoForShopCar];
    if (!_isWaite) {
        [self getChatCount];

    }

}
-(void)viewWillDisappear:(BOOL)animated{
   [self removeBuyCar];
    if (goGoodBack) {
        if (self.rdv_tabBarController.selectedIndex !=1) {
            [self.rdv_tabBarController setSelectedIndex:1];
            
        }
    }
}

- (void)returnBtnClick:(UIButton *)sender {
    
    //移除相应的通知
    [self removeNSNotification];
    [[ChatManager shareInstance] closeTime];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 
#pragma mark ViewInit function
//普通聊天初始化
- (void)initViewNormal {

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64)];
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 50)];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.bgView addSubview:self.chatTableView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKey)];
    tapRecognizer.delegate = self;
    [self.chatTableView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:self.bgView];
    
    if (isiPhone4) {
        [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height - 88)];
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height - 88)];
    }
    
    IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:YES];
    IFView.delegate = self;
    IFView.TextViewChangeBlock =^(float f){
      
        CGRect frameTable = self.chatTableView.frame;
        frameTable.size.height  -= f;
        self.chatTableView.frame = frameTable;
    };
    [self.bgView addSubview:IFView];
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];

}

//询单聊天初始化
- (void)initViewOrder {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64)];
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 100)];
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
    
    IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:YES];
    IFView.delegate = self;
    IFView.TextViewChangeBlock =^(float f){
        CGRect frameBtn = btnView.frame;
        frameBtn.origin.y -= f;
        btnView.frame = frameBtn;
        CGRect frameTable = self.chatTableView.frame;
        frameTable.size.height  -= f;
        self.chatTableView.frame = frameTable;
    };
    [self.bgView addSubview:IFView];
  
    
    btnView = [[UUBtnView alloc] init];
    btnView.delegate = self;
    [self.bgView addSubview:btnView];
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];
}



#pragma mark -
#pragma mark private function
//文本信息发送
- (void)encaseTextMessage:(NSString *)text withUUmessageFrame:(UUMessageFrame *)frame {
    
    [[ChatManager shareInstance] SendTextMessage:text toUserID:_receiver withGoodsDTO:_imGoodsInfoDTO];
}

//发送图片信息
- (void)encaseImage:(UIImage *)image withUUmessageFrame:(UUMessageFrame *)frame withLocalUrl:(NSString *)localUrl {
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:@"6" orderCode:@"" goodsNo:@"" file:UIImageJPEGRepresentation(image, 0.0000001f) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[ChatManager shareInstance] SendPicMessage:dic[@"data"] toUserID:_receiver withGoodsDTO:_imGoodsInfoDTO withLocalUrl:localUrl];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//发送相应的的商品信息
- (void)encaseGood:(IMGoodsInfoDTO *)goodInfoDetails withType:(NSString *)type {
    
    if ([type isEqualToString: @"2"]) {
        [ChatManager shareInstance].arrDto = _dtoArrMast;
        [[ChatManager shareInstance] SendOrderMessage:_imGoodsInfoDTO toUserID:_receiver];
    }else if ([type isEqualToString:@"5"]){
        
        [[ChatManager shareInstance] SendOrderListMessage:_dicOrder toUserID:_receiver];
    }else if ([type isEqualToString:@"3"]){
        
        [[ChatManager shareInstance] SendModelOrderMessage:_imGoodsInfoDTO toUserID:_receiver];
    }
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom {
    
    if (self.chatModel.dataSource.count == 0)
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
    _isWaite = YES;
    XMPPMessage * message = (XMPPMessage *)notification.object;
    NSString *messageId = [[message attributeForName:@"id"] stringValue];
    if ([messageId isEqualToString:preMessageId]) {
        return;
    }
    preMessageId = messageId;
    NSString *bodyType = [[message elementForName:@"bodyType"] stringValue];
    
    NSString * gn = [[message elementForName:@"merchantNo"] stringValue];
    
    if([gn isEqualToString:self.histrorySearchKey]){
        
        if ([[[message.fromStr componentsSeparatedByString:@"@"] objectAtIndex:0] isEqualToString:_receiver]) {
            NSString *strTime;
            if ([ChatManager shareInstance].timesever) {
                strTime = [CSPUtils getTime:[ChatManager shareInstance].timesever];
            }else{
                strTime = [NSDate stringLoacalDate];
            }
            if([bodyType isEqualToString:@"0"]) {
               
                //文本信息
                NSString *body = [[message elementForName:@"body"] stringValue];
                NSDictionary *dic = @{@"strContent": body,
                                      @"type": @(UUMessageTypeText),
                                      @"strTime": strTime,
                                      @"strIcon": [[message elementForName:@"iconUrl"] stringValue]
                                      };
                [self.chatModel addOtherItem:dic withIsHistory:NO];
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
            }else if ([bodyType isEqualToString:@"1"]){
                NSString *imgUrl =  [[message elementForName:@"Url"] stringValue];
                NSDictionary *dic = @{@"picture": [UIImage imageNamed:@"goods_placeholder"],
                                      @"type": @(UUMessageTypePicture),
                                      @"remotePath": imgUrl,
                                      @"strTime": strTime,
                                      @"strIcon": [[message elementForName:@"iconUrl"] stringValue]
                                      };
                UUMessageFrame * frame = [self.chatModel addOtherItem:dic withIsHistory:NO];
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
                [self loadImage:imgUrl withFrame:frame];
            }else {
                
                XMPPMessage * message = (XMPPMessage *)notification.object;
                [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:message withIsSender:0] withIsHistory:NO];
                [self dealTheFunctionData];
                [self tableViewScrollToBottom];
                if ([bodyType isEqualToString:@"5"]) {
                    [self showOrderVieMessage:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:message withIsSender:0]];
                }else if([bodyType isEqualToString:@"2"]){
                }
                
            }
        }
    }
    //清空未读信息
    if (_currentSession != nil) {
        [[DeviceDBHelper sharedInstance] clearOneSessionUnReadCount:nil];
    }
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
    //接受新消息 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:ReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMerchantChatNo) name:@"getMerchantChatNo" object:nil];;
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
    
    if ([BigBOrSmallB isEqualToString:@"SmallB"] && _imType == IMType_Order) {
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        btnView.hidden = YES;
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, 0 + keyboardBounds.size.height, self.chatTableView.frame.size.width, Main_Screen_Height - 64 -IFView.frame.size.height - 50+ 50 - keyboardBounds.size.height)];
        
        [self tableViewScrollToBottom];
        
        // commit animations
        [UIView commitAnimations];
    }
    
    if (_imType == IMType_Service) {
        
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, 0 + keyboardBounds.size.height, self.chatTableView.frame.size.width, Main_Screen_Height - 64 - IFView.frame.size.height - keyboardBounds.size.height)];
        
        [self tableViewScrollToBottom];
        
        // commit animations
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    AppDelegate *delete = [AppDelegate currentAppDelegate];
    delete.showThridKeyboard = NO;
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if ([BigBOrSmallB isEqualToString:@"SmallB"] && _imType == IMType_Order) {
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        btnView.hidden = NO;
        
        [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, Main_Screen_Height - 64)];
        
        [self.chatTableView setFrame:CGRectMake(0, 0, self.chatTableView.frame.size.width, Main_Screen_Height - 64 - 50 -IFView.frame.size.height)];
        
        [self tableViewScrollToBottom];
        
        // commit animations
        [UIView commitAnimations];
    }
    
    if (_imType == IMType_Service) {
        
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, 0, self.chatTableView.frame.size.width, Main_Screen_Height - 64 - IFView.frame.size.height)];
        
        [self tableViewScrollToBottom];
        
        // commit animations
        [UIView commitAnimations];
    }
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
//    [self tableViewScrollToBottom];
}
#pragma mark 请求个人中心信息--》为了得到采购车的数量
-(void)requestPerCenterInfoForShopCar{
    
    btnView.shopPoint.hidden = YES;
    
    [HttpManager sendHttpRequestForPersonalCenterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            PersonalCenterDTO * personalDTO = [[PersonalCenterDTO alloc]initWithDictionary:dic[@"data"]];
            
            if ([personalDTO.cartNum intValue]) {
                
                
                btnView.shopPoint.hidden = NO;//!采购车中有商品，显示提示的红点
                
            }else{
                
                btnView.shopPoint.hidden = YES;
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
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
                          @"strTime": strTime};
    funcView.TextViewInput.text = @"";
    if (self.chatModel.dataSource.count == 0) {
        isFirst = YES;
    }
    UUMessageFrame * frame = [self.chatModel addSpecifiedItem:dic withIsHistory:NO];
    [self dealTheFunctionData];
    [self tableViewScrollToBottom];
    [self encaseTextMessage:message withUUmessageFrame:frame];
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
- (void)sendGood:(IMGoodsInfoDTO *)dto withType:(NSString *)type {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:[XMPPMessage messageFromElement:[[ChatManager shareInstance] packageGoodsInfoArray:_dtoArrMast withType:type toUserID:_receiver]] withIsSender:0] withIsHistory:NO];
    [self dealTheFunctionData];
    [self encaseGood:dto withType:type];
}


//发送相应订单信息时的相应的处理
- (void)sendOrderGood:(NSDictionary *)dtoDic withType:(NSString *)type {
    if (![[ChatManager shareInstance] retunisXmppConnected]){
        [self.view makeMessage:@"网络连接失败" duration:2.0f position:@"center"];
        return;
    }
    
    [self.chatModel addOrderItem:[[DeviceDBHelper sharedInstance] messageConvertToECMessage:[XMPPMessage messageFromElement:[[ChatManager shareInstance]packageOrderGoodsInfoWithDic:dtoDic withType:@"5" toUserID:_receiver]] withIsSender:0] withIsHistory:NO];
  
    [self dealTheFunctionData];
    [self encaseGood:nil withType:type];
}

#pragma mark -
#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isWaite){
        return self.chatModel.dataSource.count+1;

    }else{
        return self.chatModel.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.chatModel.dataSource.count) {
        static NSString *cellID = @"TextAlertTableViewCell";
        TextAlertTableViewCell *cell = (TextAlertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TextAlertTableViewCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *strMode = [NSString stringWithFormat:@"咨询人数较多，请稍后。\n您前面有%@位会员在排队等候。",chatCount];

            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMode];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0xfd4f57 alpha:1] range:NSMakeRange(16, [strMode length]-25)];
           // cell.textLabel.text =[NSString stringWithFormat:@"咨询人数较多，请稍后。\n您前面有%@位会员在排队等候。",chatCount];
            cell.textLabel.attributedText = str;
        }
        return cell;
    }else if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){

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
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
            
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:message.goodPic] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];
            [cell loadMessage:message];
            return cell;

            
        }else if(message.type == 4) {
            
            static NSString *cellID = @"IMReferralTableViewCell";
            IMReferralTableViewCell * cell = (IMReferralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMReferralTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.strGoodNo = message.goodNo;
            cell.lblGoodNo.text = message.goodsWillNo;
            cell.lblGoodColor.text = message.goodColor;
            cell.lblGoodPrice.text = [NSString stringWithFormat:@"￥%@", message.goodPrice];
            [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:message.goodPic] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];
            cell.timeLabel.text = message.showTime? [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
            return cell;
        }else if (message.type == 3) {//样版
            
            static NSString *cellID = @"IMModelTableViewCell";
            IMModelTableViewCell * cell = (IMModelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"IMModelTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.lblGoodNo.text =message.goodsWillNo;// message.goodNo;
            cell.lblGoodColor.text = message.goodColor;
            cell.lblGoodPrice.text = [NSString stringWithFormat:@"￥%@", message.goodPrice];
            [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:message.goodPic] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];
            cell.labelTime.text = message.showTime? [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
            return cell;
        }else if(message.type == 5){
            //NSArray *dtoArr = [];
            static NSString *cellID = @"OrderListTableViewCell";
            OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == NULL) {
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] ;
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.backgroundColor = [UIColor clearColor];
            [cell loadMessage:message];
            return cell;

        }
        
    }else{
        
        UUMessageCell * cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID" withIndexPath:indexPath];
        cell.delegate = self;
        
        UUMessageFrame * frame = (UUMessageFrame *)self.chatModel.dataSource[indexPath.row];
        
        if (cell.messageFrame.message.from == UUMessageFromMe) {
            cell.messageStatus = frame.message.messageStatus;
        }else{
            
        }
        cell.mearchtNo = self.histrorySearchKey ;
        [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld,%ld",indexPath.row,self.chatModel.dataSource.count);
    if (indexPath.row == self.chatModel.dataSource.count) {
        return 60;
    }
    else if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){
        
        ECMessage * message = (ECMessage *)[self.chatModel.dataSource objectAtIndex:indexPath.row];
        if (message.type == 3 || message.type == 4) {
            return 105.0f +40;
        }
        else if(message.type == 2){

            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
            CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width-130, 0)];
             NSLog(@"rect.height:%g", rect.size.height);
            if (rect.size.height <80) {
                return 120 + 40;
            }
            return rect.size.height + 40 +40;
        }  else if(message.type == 5){
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
            CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
            NSLog(@"rect.height:%g", rect.size.height);
            return rect.size.height + 20 +40;
        }
        else {
        return 300;
            NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSInteger total = 0;
            
            if(dic != nil && err == nil){
                
                NSArray * keysArray = [dic allKeys];
                
                for (int i = 0; i < keysArray.count; i++) {
                    
                    NSString * keyString = [keysArray objectAtIndex:i];
                    
                    NSString * num = [[[dic objectForKey:keyString] componentsSeparatedByString:@","] objectAtIndex:0];
                    
                    if ([num floatValue] > 0) {
                        total ++;
                    }
                    
                }
                
                if (total <= 2) {
                    return 120.0f;
                }else {
                    NSInteger num = (total - 2) / 2;
                    if ((total - 2) % 2 > 0) {
                        num ++;
                    }
                    
                    return 120.0f + num * 17;
                }
            }else {
                
                return 120.0f;
            }
        }
    }else
        return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    if (indexPath.row == self.chatModel.dataSource.count) {
    }else if([[self.chatModel.dataSource objectAtIndex:indexPath.row] isKindOfClass:[ECMessage class]]){
        
        ECMessage * message = (ECMessage *)[self.chatModel.dataSource objectAtIndex:indexPath.row];
        
        if (message.type == 3 || message.type == 2) {
            
            GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
            NSArray *arr = [message.goodNo componentsSeparatedByString:@";"];
            goodsInfoDTO.goodsNo = [arr objectAtIndex:0];
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
            //
            //            goodsInfo.goodsNo = commodityInfo.goodsNo;
            
            GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];

            [self.navigationController pushViewController:goodsInfo animated:YES];
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
            NSString *orderState = [dic objectForKey:@"orderState"];
            
            NSString *orderNo = [dic objectForKey:@"orderNo"];
            MyOrderDetailViewController *myorderDetailVC = [[MyOrderDetailViewController alloc] init];
            myorderDetailVC.orderCode = orderNo;
            myorderDetailVC.orderState = orderState.intValue;
            myorderDetailVC.isChat = YES;
            myorderDetailVC.blockMyOrderDetailChatMessage =^(NSDictionary *dicOrder){
                [dicOrder setValue:self.title forKey:@"merchantName"];
                _dicOrder = dicOrder;
                [self sendOrderGood:dicOrder withType:@"5"];
                [self showOrderView:dicOrder];
                btnView.hidden = YES;
                self.chatTableView.frame =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 50);
            };
            [self.navigationController pushViewController:myorderDetailVC animated:YES];
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)IMReferralBtnClick:(NSString *)goodsNo {
    
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = goodsNo;
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
    //
    //            goodsInfo.goodsNo = commodityInfo.goodsNo;
    
    GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    
    [self.navigationController pushViewController:goodsInfo animated:YES];
}

- (void)UUBtnViewBtnClick:(UUBtnView *)btnView btnIndex:(NSInteger)index {

    if(index == 0) {
        if (modityOrderView == nil) {
            modityOrderView = [[IMModityOrder alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-64 ) withCartArrayDTO:_dtoArrMast];
            modityOrderView.delegate = self;
            [self.view addSubview:modityOrderView];
        }
        [modityOrderView IMmodityOrderShow];
    }else if (index == 1) {
        
        [self verBuyCar:_dtoArrMast];
    }else if (index == 3) {
        
        if ([[IMMsgDBAccess sharedInstance] queryIsHasMessageFromSeller:self.histrorySearchKey]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
            CSPShoppingCartViewController *goodsCarVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
            goodsCarVC.isBlockUp = YES;
            [self.navigationController pushViewController:goodsCarVC animated:YES];
            
            
            
            
        }else {


        }
    }else if (index == 4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
        shopVC.isBlockUp = YES;
        shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
        [self.navigationController pushViewController:shopVC animated:YES];
    }

}


-(void)verBuyCar:(NSArray *)arrCar{
    NSMutableArray *arrOrder =[[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *arrUnOrder =[[NSMutableArray alloc] initWithCapacity:0];
    for (IMGoodsInfoDTO *goodsDTO in arrCar) {
        if ([goodsDTO gettotalQuantity]>0||goodsDTO.isBuyModel)  {
            if (goodsDTO.isBuyModel||[goodsDTO gettotalQuantity] >= [goodsDTO.batchNumLimit integerValue]) {
                [arrOrder addObject:goodsDTO];
            }else{
                [arrUnOrder addObject:goodsDTO];
            }
            
        }
        
    }
    
    if (arrUnOrder.count==0&&arrOrder.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请添加商品数量";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
        
    }
    
    else if(arrUnOrder.count==0&&arrOrder.count >0){
        [self addBuyCar:arrOrder];
        //
    }else {
        
        [self addUnBuyCar:arrUnOrder];
        
       
        
    }

}

//
-(void)addUnBuyCar:(NSMutableArray *)arrGoods{


    BuyUnLimView *buyUnView = [[[NSBundle mainBundle] loadNibNamed:@"BuyUnLimView" owner:self options:nil] objectAtIndex:0];
    
    buyUnView.frame = CGRectMake(0, 0,self.view.frame.size.width,Main_Screen_Height);
    [self.view addSubview:buyUnView];
    for (IMGoodsInfoDTO *gooInfo in arrGoods) {
        UILabel *labelH = [UILabel new];
        labelH.font = [UIFont systemFontOfSize:13];
        labelH.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
        labelH.textAlignment = NSTextAlignmentLeft;
        labelH.heightDime.min(15);
        labelH.leftPos.equalTo(@(40));
        labelH.topPos.equalTo(@(5));
        labelH.widthDime.equalTo(@(buyUnView.frame.size.width - 20));
        labelH.text = [NSString stringWithFormat:@"%@起批量: %@  已订购: %ld",gooInfo.goodColor,gooInfo.batchNumLimit,gooInfo.gettotalQuantity];
        labelH.numberOfLines = 0;
        [labelH sizeToFit];
        
        [buyUnView.flowLayout addSubview:labelH];
       
    }
    
    CGRect rect = [buyUnView.flowLayout estimateLayoutRect:CGSizeMake(buyUnView.frame.size.width - 50, 0)];
    buyUnView.heightLayout.constant = rect.size.height + 100;

    
    
    
}

-(void)addBuyCar:(NSMutableArray *)orderArray{
    NSMutableArray *carAddArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (IMGoodsInfoDTO *imGoodsInfo in orderArray) {
        CartAddDTO *carAddDto;
        if (imGoodsInfo.isBuyModel) {
             carAddDto = [imGoodsInfo transformToModelCartAddDTO];
        }else{
            carAddDto = [imGoodsInfo transformToCartAddDTO];
        }
       
    
        [carAddArray addObject:carAddDto];
    }
 
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForCartAddList:carAddArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:addCartNotification object:nil];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self showCarAlertView:orderArray];
            btnView.shopPoint.hidden = NO;
            //只显示文字
            
            //[self.view makeMessage:@"加入采购车成功" duration:2.0f position:@"center"];
            
        } else {
            [self.view makeMessage:@"加入采购车失败" duration:2.0f position:@"center"];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
    }];

    

}
-(void)showCarAlertView:(NSMutableArray *)goodsInfoArray{
    BuyCarAlertView *buyCarView = [[[NSBundle mainBundle] loadNibNamed:@"BuyCarAlertView" owner:self options:nil] objectAtIndex:0];
    buyCarView.tag = buycarTag;
    buyCarView.delegate = self;
    
    buyCarView.frame = CGRectMake(0, 0,self.view.frame.size.width,Main_Screen_Height);
    [self.view addSubview:buyCarView];
    for (IMGoodsInfoDTO *gooInfo in goodsInfoArray) {
        UILabel *labelH = [UILabel new];
        labelH.font = [UIFont systemFontOfSize:13.0];
        labelH.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
        labelH.textAlignment = NSTextAlignmentLeft;
        labelH.heightDime.min(15);
        labelH.leftPos.equalTo(@(20));
        labelH.topPos.equalTo(@(10));
        labelH.widthDime.equalTo(@(buyCarView.frame.size.width - 50));
        labelH.numberOfLines = 0;
        labelH.text = [NSString stringWithFormat:@"货号: %@  %@",gooInfo.goodsWillNo,gooInfo.goodColor];
        [labelH sizeToFit];
        [buyCarView.labelLayout addSubview:labelH];
        
         NSString * spotStrin = [self showSpotString:gooInfo];
        if ([spotStrin length]) {
            UILabel *labelX = [UILabel new];
            
            labelX.font = [UIFont systemFontOfSize:14.0];
            labelX.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
            labelX.textAlignment = NSTextAlignmentLeft;
            labelX.heightDime.min(15);
            labelX.leftPos.equalTo(@(20));
            labelX.topPos.equalTo(@(3));
            labelX.widthDime.equalTo(@(buyCarView.frame.size.width - 50));
            labelX.numberOfLines = 0;
            labelX.text = spotStrin;
            [labelX sizeToFit];
            [buyCarView.labelLayout addSubview:labelX];
        }
       
        NSString * futureString = [self showFutureString:gooInfo];
        if ([futureString length]) {
            UILabel *labelQ = [UILabel new];
            labelQ.font = [UIFont systemFontOfSize:14.0];
            labelQ.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
            labelQ.textAlignment = NSTextAlignmentLeft;
            labelQ.heightDime.min(15);
            labelQ.leftPos.equalTo(@(20));
            labelQ.topPos.equalTo(@(3));
            labelQ.widthDime.equalTo(@(buyCarView.frame.size.width - 50));
            labelQ.numberOfLines = 0;
            labelQ.text = futureString;
            [labelQ sizeToFit];
            [buyCarView.labelLayout addSubview:labelQ];
        }
     
    }
    
    CGRect rect = [buyCarView.labelLayout estimateLayoutRect:CGSizeMake(buyCarView.labelLayout.weight, 0)];
    buyCarView.alertHight.constant = rect.size.height + 100;
   
   
}
-(NSString *)showSpotString:(IMGoodsInfoDTO*)gooInfo{
    NSString *spotString ;
    if (gooInfo.isBuyModel) {
        spotString = [NSString stringWithFormat:@"样板: 1"];
    }else{
        spotString = @"现货: ";
        //_imGoodsInfoDTO.skuList
        for (DoubleSku * sku in gooInfo.skuList) {
            if (sku.spotValue > 0) {
                spotString = [spotString stringByAppendingString:[NSString stringWithFormat:@"%@: %ld, ", sku.skuName, (long)sku.spotValue]];
                
            }
            
            
        }
        if ([spotString length] <= 4) {
            spotString = @"";
        }
      
       
    }
    return spotString;
}
-(NSString *)showFutureString:(IMGoodsInfoDTO*)gooInfo{
    NSString *futureString;
    if (gooInfo.isBuyModel) {
        futureString = @"";
    }else{
        futureString = @"期货: ";
        //_imGoodsInfoDTO.skuList
        for (DoubleSku * sku in gooInfo.skuList) {
            
            
            if (sku.futureValue > 0) {
                futureString = [futureString stringByAppendingString:[NSString stringWithFormat:@"%@: %ld, ", sku.skuName, (long)sku.futureValue]];
            }
        }
        
        if ([futureString length] <= 4) {
            futureString = @"";
        }
    }
    
    return futureString;
}
-(void)removeBuyCar{
    UIView *buycar = [self.view viewWithTag:buycarTag];
    if (buycar) {
         [buycar removeFromSuperview];
    }
   
}
-(void)goBuy{
    
    goGoodBack = YES;
    
   
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (self.rdv_tabBarController.selectedIndex !=1) {
        [self.rdv_tabBarController setSelectedIndex:1];

    }
    
    

}
-(void)goOrder{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *goodsCarVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    
    goodsCarVC.isBlockUp = YES;
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

-(void)showOrderView:(NSDictionary *)goodsInfoDic{
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
    if (inquireView) {
        [inquireView removeFromSuperview];
    }
    orderShow = [[[NSBundle mainBundle] loadNibNamed:@"OrderShowView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:orderShow];
    [orderShow showOrderWithDic:goodsInfoDic];
    orderShow.frame = CGRectMake(0, 0, self.view.frame.size.width,isFirst?210:150);
    
    
}
-(void)showOrderVieMessage:(ECMessage *)message{
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
    if (inquireView) {
        [inquireView removeFromSuperview];
    }
    orderShow = [[[NSBundle mainBundle] loadNibNamed:@"OrderShowView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:orderShow];
    [orderShow showOrderWithMessage:message];
    orderShow.frame = CGRectMake(0, 0, self.view.frame.size.width,isFirst?210:self.view.frame.size.height/4);
}

-(void)showInquireView:(NSArray *)goodsInfoArray{
    if (inquireView) {
        [inquireView removeFromSuperview];
    }
    
    if (orderShow) {
        [orderShow removeFromSuperview];
    }
     inquireView = [[[NSBundle mainBundle] loadNibNamed:@"InquireView" owner:self options:nil] objectAtIndex:0];
    float h = (goodsInfoArray.count *30+40 < 150)?150:(goodsInfoArray.count *30+40) ;
    inquireView.frame = CGRectMake(0, 0, self.view.frame.size.width,h);
    
    IMGoodsInfoDTO *dto = [goodsInfoArray objectAtIndex:0];
    [self.view addSubview:inquireView];
    [inquireView.inquireImgV sd_setImageWithURL:[NSURL URLWithString:dto.goodPic] placeholderImage:[UIImage imageNamed:@"orderDetail_placeHolder"]];
    BOOL isCount = NO;
    for (IMGoodsInfoDTO *gooInfo in goodsInfoArray) {
        if ([gooInfo.totalQuantity intValue]||gooInfo.isBuyModel) {
            isCount = YES;
        }
    }
    for (IMGoodsInfoDTO *gooInfo in goodsInfoArray) {
        if (![gooInfo.totalQuantity intValue]&&isCount&&!gooInfo.isBuyModel) {
            continue;
        }
        UILabel *labelH = [UILabel new];
        labelH.font = [UIFont  systemFontOfSize:13.0];
        labelH.textColor = [UIColor whiteColor];
        labelH.textAlignment = NSTextAlignmentLeft;
        labelH.heightDime.min(15);
        labelH.leftPos.equalTo(@(0));
        labelH.topPos.equalTo(@(0));
        labelH.widthDime.equalTo(@(inquireView.frame.size.width - 180));
        if (gooInfo.isBuyModel) {
            labelH.text = [NSString stringWithFormat:@" %@  %@样板  ￥%@",gooInfo.goodsWillNo,gooInfo.goodColor,gooInfo.samplePrice];
        }else{
            labelH.text = [NSString stringWithFormat:@" %@  %@  ￥%@",gooInfo.goodsWillNo,gooInfo.goodColor,gooInfo.price];
        }
        
        [labelH sizeToFit];
        [inquireView.flowLayout addSubview:labelH];
    }
    
}

-(void)getHistory{
    [self getChatHistory:YES];
}
/** 查询聊天记录 */
- (void)getChatHistory:(BOOL)isAddMore {
    
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
    
    NSArray * array = [[DeviceDBHelper sharedInstance] getMessageOfSessionId:self.histrorySearchKey beforeTime:timestamp andPageSize:messagePageSize];
    
    if (array != nil && array.count != 0) {
        
        for(int i = (array.count-1); i >=0; i--) {
            
            ECMessage * message = (ECMessage *)[array objectAtIndex:i];
            
            NSDictionary *dic;
            UUMessageFrame * frame;
            ECSession *eCSession = [[IMMsgDBAccess sharedInstance] loadMerchantSessionsNo: self.histrorySearchKey];
            //判断消息的类型展示不同的数据
            if (message.type == 0) {
                
                dic = @{@"strContent": message.text,
                        @"type": @(UUMessageTypeText),
                        @"strTime": [CSPUtils getTime:message.dateTime],
                         @"strIcon": eCSession.iconUrl?eCSession.iconUrl:@"",};
                
                if (message.isSender == 1) {
                    
                    [self.chatModel addSpecifiedItem:dic withIsHistory:YES];
                }else {

                    [self.chatModel addOtherItem:dic withIsHistory:YES];
                }
            }else if(message.type == 1) {
                
                if ([UIImage imageWithContentsOfFile:message.localPath] == nil) {
                    dic = @{@"picture": [UIImage imageNamed:@"goods_placeholder"],
                            @"type": @(UUMessageTypePicture),
                            @"remotePath": message.URL,
                            @"strTime": [CSPUtils getTime:message.dateTime],
                             @"strIcon": eCSession.iconUrl?eCSession.iconUrl:@"",};
                    
                    if (message.isSender == 1) {
                        
                        frame = [self.chatModel addSpecifiedItem:dic withIsHistory:YES];
                    }else {
                        
                        frame = [self.chatModel addOtherItem:dic withIsHistory:YES];
                    }
                    
                    [self loadImage:message.URL withFrame:frame];
                    
                }else {
                    
                    dic = @{@"picture": [UIImage imageWithContentsOfFile:message.localPath],
                            @"type": @(UUMessageTypePicture),
                            @"strTime": [CSPUtils getTime:message.dateTime],
                            @"strIcon": eCSession.iconUrl?eCSession.iconUrl:@""};
                    
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
            }else if (message.type == 5) {
                
                [self.chatModel addOrderItem:message withIsHistory:YES];
            }
            [self.historyArray addObject:message];
        }
        timestamp = ((ECMessage *)[array objectAtIndex:0]).dateTime - 1;
    }
    else if(isAddMore){
        [self getHistoryForSever];
        return;
    }
    
    [self.chatTableView.mj_header endRefreshing];
    
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
    [HttpManager sendHttpRequestForGetChantHistoryWithUser:_merchantno withTime:[CSPUtils getTime:timestamp] pageNo:[NSNumber numberWithInt:pageCount] pageSize:[NSNumber numberWithInt:messagePageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [[DeviceDBHelper sharedInstance] insertMessage:messageXml withIsSender:YES withAddSession:isShowSession];
            isShowSession = NO;
        }
        if (arr) {
            [self getChatHistory:NO];

        }else{
       
            
            [self.chatTableView.mj_header endRefreshing];
            
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
-(void)getChatCount{
    [HttpManager sendHttpRequestForNumbWithJid:_receiver success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {

            //NSLog(@"dic =%@",dic);
            chatCount = dic[@"data"];
            [_chatTableView reloadData];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)rightClick {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPOrderRecordTableViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPOrderRecordTableViewController"];
    if (_currentSession) {
        nextVC.merchantNo = _currentSession.merchantNo;
    }else {
        nextVC.merchantNo = _merchantno;
    }
    nextVC.reOrderSendBlock=^(NSDictionary *dicOrder){
        [dicOrder setValue:self.title forKey:@"merchantName"];
        _dicOrder = dicOrder;
        [self sendOrderGood:dicOrder withType:@"5"];
        [self showOrderView:dicOrder];
        btnView.hidden = YES;
         self.chatTableView.frame =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 50);
    };
    [self.navigationController pushViewController:nextVC animated:YES];
}
-(void)hiddenKey{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"str===%@",NSStringFromClass([touch.view class]) );
    if (self.chatTableView.frame.size.height >Main_Screen_Height -150 ) {
        return NO;
    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"MyFlowLayout"]||]) {//如果当前是tableView
//        //做自己想做的事
//        return NO;
//    }
    return YES;
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取聊天编号
- (void)getMerchantChatNo {
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:_imGoodsInfoDTO.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString * jid = [NSString stringWithFormat:@"%@",dic[@"data"]];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            self.timeStart = time;
            if (!_receiver||[_receiver length]==0) {
                _receiver = jid;

            }
            
            [[ChatManager shareInstance] openTime:([time longLongValue]+2000)];
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


@end
