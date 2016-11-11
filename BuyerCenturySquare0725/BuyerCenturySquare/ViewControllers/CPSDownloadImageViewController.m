//
//  CPSDownloadImageViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSDownloadImageViewController.h"

#import "CSPDownLoadImageCell.h"

#import "CSPTipNoDownloadData.h"

#import "GetPayMerchantDownloadDTO.h"

#import "CPSDownloadHistoryViewController.h"

#import "DownloadLogControl.h"

#import "MHImageDownloadProcessor.h"

#import "MHImageDownloadManager.h"

#import "CSPPayAndDownloadViewController.h"

#import "CSPGoodsInfoTableViewController.h"

#import "GoodsInfoDTO.h"

#import "CSPVIPUpdateViewController.h"

#import "CSPMemberVIPViewController.h"

#import "UIImageView+WebCache.h"

#import "GoodDetailViewController.h"

#import "LoginDTO.h"

#import "GUAAlertView.h"


@interface CPSDownloadImageViewController ()<UITableViewDataSource,UITableViewDelegate,DownloadLogControlDelegate>

@property (nonatomic, assign)id<NSObject> notification;

@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;

@property (strong,nonatomic)UITableView *alreadyDownloadTableView;

@property (strong,nonatomic)UITableView *downLoadingTableView;

@property (strong,nonatomic)GetPayMerchantDownloadDTO *getPayMerchantDownload;

@property (weak, nonatomic) IBOutlet UIButton *alreadyDownLoadButton;

- (IBAction)alreadyDownLoadButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *downLoadingButton;

- (IBAction)downLoadingButtonClick:(id)sender;

@property (strong,nonatomic)NSMutableArray *downingList;

@property (strong,nonatomic)NSMutableArray *finishedList;

@property (weak, nonatomic) IBOutlet UILabel *residueDownloadNoLabel;

- (IBAction)buyDownLoadNoClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *displayDataTypeButton;

- (IBAction)displayDataTypeButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)editButtonClick:(id)sender;
//!底部的view：“删除”、"全选"
@property (weak, nonatomic) IBOutlet UIView *downloadingDeleteBottomView;
//删除
- (IBAction)deleteDownloadingButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectedAllDownloadButton;

- (IBAction)selectedAllDownloadButtonClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *alreadDownloadAllSelectedButton;
- (IBAction)alreadDownloadAllSelectedButtonClick:(id)sender;
- (IBAction)alreadDownloadAgainButtonClick:(id)sender;
- (IBAction)alreadDownloadClearButtonClick:(id)sender;

//!底部的view：清除、再次下载、全选
@property (weak, nonatomic) IBOutlet UIView *alreadDownloadButtomView;

//没有下载过的时候
//购买次数
@property (weak, nonatomic) IBOutlet UIView *buyNoBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *buyNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyDownloadbtn;

@property (weak, nonatomic) IBOutlet UIButton *residueDownBtn;


- (IBAction)buyDownloadNoButtonClick:(id)sender;

//!底部的view---“剩余下载次数：0”，“购买下载次数”
@property (weak, nonatomic) IBOutlet UIView *residueDownloadNoBackgroundView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alreadDownViewHight;


@property(assign,nonatomic)NSInteger lastPage;

//控制已下载页面存放选择需要再次下载的数据
@property (strong,nonatomic)NSMutableArray *selectedArray;
//控制正下载页面存放需要删除的数据
@property (strong,nonatomic)NSMutableArray *deleteArray;

@end

@implementation CPSDownloadImageViewController{
    /**
     *  用来控制当前显示已下载或者正在下载的数据
     */
    BOOL _isDisplayAlreadyDownload;
    
    BOOL _isDisplaydownloading;
    
    
    /**
     *  用来控制已经下载或者正在下载页面是否在编辑
     */
    BOOL _isAlreadyDownloadEdit;
    
    BOOL _isDisplaydownloadingEdit;
    
    /**
     *  判断是否全部暂停
     */
    BOOL _isAllPause;
    
    /**
     *  控制是否全部删除
     */
    BOOL _isAllDelete;
    
    BOOL _isDownloadingAllSelected;
    
    BOOL _isAlreadSelectedAll;
    
    BOOL _isDownloadingImage;
    
    GUAAlertView * guAlertView;//!提示的view

    
}

- (UIColor *)getButtonSelectedBackgroundColor{
    return HEX_COLOR(0x323232FF);
}
#pragma mark 根据页面改变底部view的显示
- (void)displayData{
    
    //!已下载按钮
    self.alreadyDownLoadButton.selected = _isDisplayAlreadyDownload;
    
    //!正在下载按
    self.downLoadingButton.selected = _isDisplaydownloading;
    
    
    //已下载列表
    if (_isDisplayAlreadyDownload) {
        
        if (self.finishedList.count>0) {
            
            self.topBackgroundView.hidden = NO;
            
        }else{
            
            self.topBackgroundView.hidden = YES;
            _isAlreadyDownloadEdit = NO;
            
        }
        
        self.alreadyDownLoadButton.backgroundColor = [UIColor whiteColor];
        
        self.downLoadingButton.backgroundColor = [self getButtonSelectedBackgroundColor];
        
        [self.displayDataTypeButton setTitle:@"已下载完成" forState:UIControlStateNormal];
        //控制编辑还是完成
        if (!_isAlreadyDownloadEdit) {
            
            [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
            
        }else{
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        
        [self.editButton setImage:nil forState:UIControlStateNormal];
        
        //判断bottomView如何显示
        if (self.finishedList.count) {//!有需要显示的下载图片
            
            if (_isAlreadyDownloadEdit) {
                [self showBottomView:self.alreadDownloadButtomView];
            }else{
                [self showBottomView:self.residueDownloadNoBackgroundView];
            }
            
        }else{//!没有需要显示的下载图片
            
            if (_isDownloadingImage) {//!下载过图片
                
                [self showBottomView:self.residueDownloadNoBackgroundView];
                
            }else{//!没有下载过图片
                
                
                [self showBottomView:self.buyNoBackgroundView];
                
                //购买次数：10次/￥300
                self.buyNoLabel.text = [NSString stringWithFormat:@"购买次数：%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
                
            }
            
            
        }
        
    }else{//正在下载列表
        
        
        if (self.downingList.count>0) {
            
            self.topBackgroundView.hidden = NO;
            
        }else{
            
            self.topBackgroundView.hidden = YES;
            _isDisplaydownloadingEdit = NO;
        }
        
        self.alreadyDownLoadButton.backgroundColor = [self getButtonSelectedBackgroundColor];
        
        self.downLoadingButton.backgroundColor = [UIColor whiteColor];
        
        //需要判断是暂停还是开始
        [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部暂停（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];
        
       
        if (!_isDisplaydownloadingEdit) {
            
            [self.editButton setImage:[UIImage imageNamed:@"04_商品图片下载_删除"] forState:UIControlStateNormal];
            
            [self.editButton setTitle:nil forState:UIControlStateNormal];
            
        }else{
            
            [self.editButton setImage:nil forState:UIControlStateNormal];
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        
        }
        
        //判断bottomView如何显示
        if (self.downingList.count) {
            
            if (_isDisplaydownloadingEdit) {
                [self showBottomView:self.downloadingDeleteBottomView];
            }else{
                [self showBottomView:self.residueDownloadNoBackgroundView];

            }
            
        }else{
            
            if (_isDownloadingImage) {
                
                [self showBottomView:nil];
                
                
            }else{
                
                [self showBottomView:self.buyNoBackgroundView];
                
                //购买次数：10次/￥300
                self.buyNoLabel.text = [NSString stringWithFormat:@"购买次数：%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
            }
        }
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品图片下载";
    
    [self addCustombackButtonItem];
    
    //!右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"10_商品图片下载_历史浏览"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [self initArray];
    
    
    _isDisplayAlreadyDownload = YES;
    
    _isDisplaydownloading = NO;
    
    
    [self initTableView];
    
    
    //!去掉底部多余的横线
    [self setExtraCellLineHidden:self.alreadyDownloadTableView];
    
    [self setExtraCellLineHidden:self.downLoadingTableView];


    //!如果有正在下载的 跳转到正在下载界面
    if (self.isDownLoading) {
        
        
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
        _isDisplayAlreadyDownload = NO;
        
        _isDisplaydownloading = YES;
        
        self.lastPage = 1;
        
        //!显示正在下载
        [self setSCAndTableViewCanScrollerToTop:NO];

        
    }else{
    
        //!显示已下载
        [self setSCAndTableViewCanScrollerToTop:YES];

        
    }
    
    //!如果是苹果审核账号，则去除底部的购买次数按钮
    if ([MyUserDefault loadIsAppleAccount]) {
        
        
        [self.residueDownloadNoBackgroundView removeFromSuperview];
        
        [self.buyNoBackgroundView removeFromSuperview];
        
        
    }
    
    //!没有访问相册权限的提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAuthorAlert) name:@"NoAuthorNotification" object:nil];
    
}
-(void)dealloc{
    
    //!没有访问相册权限的提示
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NoAuthorNotification" object:nil];
    
}


-(void)noAuthorAlert{
    
    if (guAlertView) {
        
        return ;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
       
        guAlertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"请在iPhone“设置-隐私-照片”中允许访问照片，否则图片无法保存成功" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            guAlertView = nil;
            [guAlertView removeFromSuperview];            
            
        } dismissAction:nil];
        
        guAlertView.withJudge = YES;
        
        [guAlertView show];
        
        
    });
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //!获取剩余下载次数、之前是否下载过图片 处理下载数据 UI
    [self requestPayDownLoad];
    
    [self registerNotification];
    
    
    //!点击一次购买次数按钮不可以用，将要出现的时候再可用
    self.buyDownloadbtn.enabled = YES;
    
    self.residueDownBtn.enabled = YES;
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:(NSString *)K_NOTICE_RELOADDOWNLOADCOUNT object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[DownloadLogControl sharedInstance] resetAllDelegates];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self.notification];
    
}

#pragma mark-注册通知
- (void)registerNotification{
    
    self.notification = [[NSNotificationCenter defaultCenter]addObserverForName:NotificationOfDownloadStatusInfo object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        if ([note.object isKindOfClass:[DownloadStatusInfoNotificationDTO class]]) {
            
            DownloadStatusInfoNotificationDTO* notification = note.object;
            
            if ([notification changeToCompelete] || [notification changeToDownloading] || [notification clear] ) {
                
                if ([notification changeToCompelete]) {

                }
                //!处理下载数据
                [self handleData];
                
            }
            
        }
        
    }];
    
    //!请求数据(获取剩余下载次数、之前是否下载过图片) 处理下载数据 UI  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPayDownLoad) name:(NSString *)K_NOTICE_RELOADDOWNLOADCOUNT object:nil];
    
    
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender{
    
    [self downloadHistory];
    
}

#pragma mark-历史下载图片
- (void)downloadHistory{
    
    CPSDownloadHistoryViewController *downloadHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSDownloadHistoryViewController"];
    
    [self.navigationController pushViewController:downloadHistoryViewController animated:YES];

}

- (void)initArray{
    
    self.downingList = [[NSMutableArray alloc]init];
    
    self.finishedList = [[NSMutableArray alloc]init];
    
    self.selectedArray = [[NSMutableArray alloc]init];
    
    self.deleteArray = [[NSMutableArray alloc]init];
    
}

#pragma mark-处理下载数据 UI
- (void)handleData{
    
    //重置数据
    [self.downingList removeAllObjects];
    [self.finishedList removeAllObjects];

    //!获取正在下载的数据
    self.downingList = (NSMutableArray *)[[DownloadLogControl sharedInstance]downloadingLogItems];
    
    //!获取已经下载完的数据
    self.finishedList = (NSMutableArray *)[[DownloadLogControl sharedInstance]downloadedLogItems];
    
    //处理UI(判断如果有数据，就删除无数据UI提示)
    [self displayNodataTip];
    
    //!根据页面改变底部view的显示
    [self displayData];
    
    
}

-(void)resetFinishList{

    NSArray * downList;
   
    downList = [self.finishedList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       
        DownloadLogItem *downloadLogItemOne = obj1;
        DownloadLogItem *downloadLogItemSecond = obj2;
        
        NSDate *oneDate = [self getCompareDate:downloadLogItemOne];
        NSDate *secondDate = [self getCompareDate:downloadLogItemSecond];
        
       
        if (oneDate && secondDate) {
            
            NSComparisonResult result = [oneDate compare:secondDate];
            //!如果第二个时间比第一个大  交换位置
            if (result == 1) {
                
                return YES;
                
            }else{
            
                return NO;
            }
            
        }else if (oneDate && !secondDate){//!如果第一个时间有，第二个时间没有 第一个还在前面 不交换位置
            
            return NO;
            
        }else if (!oneDate && secondDate){//!如果第二个时间有，第一个时间没有 算第二个大，交换位置
        
            return YES;
        
        }

        return NO;
        
    }];
    
    
    self.finishedList = [NSMutableArray arrayWithArray:downList];
    
    
}
//!把一个商品的客观图 和参考图下载完成时间作对比，哪个是最新下载的就传哪个出来
-(NSDate *)getCompareDate:(DownloadLogItem *)item{

    NSDate * windowDate = item.windowFigure.finshDate;
    NSDate * objectiveDate =item.objectiveFigure.finshDate;
    
    if (windowDate && objectiveDate) {
        
        NSComparisonResult result = [windowDate compare:objectiveDate];
        //!如果 客观图时间大  返回客观图时间
        if (result == 1) {
            
            return objectiveDate;
            
        }else{
            
            return windowDate;
        }
        
    }else if (windowDate && !objectiveDate){//!如果只有窗口图时间 返回窗口图时间
        
        return windowDate;
        
    }else if (!windowDate && objectiveDate){//!如果只有客观图时间 返回客观图时间
        
        return objectiveDate;
        
    }else{//!都没有时间，返回空
        
        return nil;
    
    }

    
    

}

- (void)displayNodataTip{
    
    //先removeCSPTipNoDownloadData
    NSArray *array = self.scrollView.subviews;
    
    for (UIView *view in array) {
        
        if ([view isKindOfClass:[CSPTipNoDownloadData class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    //!sc的高度取决于这个值的高度
    self.alreadDownViewHight.constant = 49;
    [self.scrollView layoutIfNeeded];

    
    //!已下载的数量为0
    if (!self.finishedList.count) {
        
        self.topBackgroundView.hidden = YES;
        
        if (_isDownloadingImage) {
            
            //下载过的
            //已下载列表已清空
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            tipNoDownloadData.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipEmptyDataView];
            
            [self.scrollView addSubview:tipNoDownloadData];
            
        }else{
            
            //未下载过
            
            //!判断当前用户如果无下载权限/无限制下载，则修改提示的界面frame 为了修改 v1的时候无权限下载，则底部按钮隐藏

            if ([self.getPayMerchantDownload.authFlag isEqualToString:@"0"] || [self.getPayMerchantDownload.downloadNum intValue] == -1) {
                
                //!sc的高度取决于这个值的高度
                self.alreadDownViewHight.constant = 0;
                [self.scrollView layoutIfNeeded];
            }
            
            //隐藏编辑view
            
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            tipNoDownloadData.frame = CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadDataView];
            
            tipNoDownloadData.currentGradeLabel.text = [NSString stringWithFormat:@"当前等级：V%@",[self transformationData:self.getPayMerchantDownload.level]];
            
            if(self.getPayMerchantDownload.downloadNum.integerValue == -1){
            
                tipNoDownloadData.downloadNumLabel.text = [NSString stringWithFormat:@"可下载商品数量：无限次"];
            }else {
                tipNoDownloadData.downloadNumLabel.text = [NSString stringWithFormat:@"可下载商品数量：%@次",[self transformationData:self.getPayMerchantDownload.downloadNum]];
            }
            
            [self.scrollView addSubview:tipNoDownloadData];
            
        }
        
        
    }else{//!已下载数量不为0
        
        [self.alreadyDownloadTableView reloadData];
        
    }
    
    //!正在下载的数量不为0
    if (!self.downingList.count) {
        
        self.topBackgroundView.hidden = YES;
        
        if (_isDownloadingImage) {
            //下载过的
            //暂无正在下载
            
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadingDataView];
            
            tipNoDownloadData.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadingDataView];
            
            tipNoDownloadData.buyMoreImageBlock = ^(){
                //查看下载历史
                [self  downloadHistory];
            };
            
            [self.scrollView addSubview:tipNoDownloadData];
            
            
            
            
        }else{
            
            //没下载过的
            
            //!判断当前用户如果无下载权限/无限制下载，则修改提示的界面frame 为了修改 v1的时候无权限下载，则底部按钮隐藏
            if ([self.getPayMerchantDownload.authFlag isEqualToString:@"0"] || [self.getPayMerchantDownload.downloadNum intValue] == -1) {
                
                //!sc的高度取决于这个值的高度
                self.alreadDownViewHight.constant = 0;
                [self.scrollView layoutIfNeeded];
            
            }
            
            
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            tipNoDownloadData.frame = CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadDataView];
            
            tipNoDownloadData.currentGradeLabel.text = [NSString stringWithFormat:@"当前等级：V%@",[self transformationData:self.getPayMerchantDownload.level]];
            
            if(self.getPayMerchantDownload.downloadNum.integerValue == -1){
                
                tipNoDownloadData.downloadNumLabel.text = [NSString stringWithFormat:@"可下载商品数量：无限次"];
            }else {
                tipNoDownloadData.downloadNumLabel.text = [NSString stringWithFormat:@"可下载商品数量：%@次",[self transformationData:self.getPayMerchantDownload.downloadNum]];
            }
            
            [self.scrollView addSubview:tipNoDownloadData];
            

           

        }
    }else{
        [self.downLoadingTableView reloadData];
    }
}

#pragma mark-请求数据(获取剩余下载次数、之前是否下载过图片) 处理下载数据 UI
- (void)requestPayDownLoad{
    
    [HttpManager sendHttpRequestForPayDownloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if(!responseDic) return ;
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                if (!self.getPayMerchantDownload) {
                    
                    self.getPayMerchantDownload = [[GetPayMerchantDownloadDTO alloc]init];
                }
                
                [self.getPayMerchantDownload setDictFrom:data];
                
            }
            //!下载过图片
            if (self.getPayMerchantDownload.downloadFlag.integerValue == 1) {
                
                _isDownloadingImage = YES;
                
            }else if(self.getPayMerchantDownload.downloadFlag.integerValue == 0){//!没有下载过图片
                
                _isDownloadingImage = NO;
            }
            
            
            //修改剩余下载次数 的显示
            [self residueDownloadNo];
            
            //! 处理下载数据 UI
            [self handleData];
            
            
            
        }else{
            
            [self alertViewWithTitle:@"提示" message:[responseDic objectForKey:@"errorMessage"]];

            
            DebugLog(@"请求下载次数失败");
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        
        DebugLog(@"failure：请求下载次数失败");
        
    }];
    
    
    
}

#pragma mark-剩余下载次数
- (void)residueDownloadNo{
    
    if ([self.getPayMerchantDownload.downloadNum intValue]==-1) {
        
        self.residueDownloadNoLabel.text = @"剩余下载次数: 本月无限下载";
        
    }else{
    
        
        self.residueDownloadNoLabel.text = [NSString stringWithFormat:@"剩余下载次数:%@",[self transformationData:self.getPayMerchantDownload.downloadNum]];
    }
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if ([self.alreadyDownloadTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.alreadyDownloadTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.alreadyDownloadTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.alreadyDownloadTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    if ([self.downLoadingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.downLoadingTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.downLoadingTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.downLoadingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.scrollView.frame.size.height);
    
    self.alreadyDownloadTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
    self.downLoadingTableView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
    
    
//    self.buyNoBackViewHight.constant = 49;
//    [self.scrollView layoutIfNeeded];
//
////    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    DebugLog(@"~~~~~~~~~%f", self.scrollView.frame.size.height);
//    [self.scrollView setBackgroundColor:[UIColor greenColor]];

    
    
}

- (void)initTableView{
    
    self.alreadyDownloadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
    
    self.alreadyDownloadTableView.delegate = self;
    
    self.alreadyDownloadTableView.dataSource = self;
    
    self.downLoadingTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
    
    self.downLoadingTableView.delegate = self;
    
    self.downLoadingTableView.dataSource = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.scrollView.frame.size.height);
    
    [self.scrollView addSubview:self.alreadyDownloadTableView];
    
    [self.scrollView addSubview:self.downLoadingTableView];
    
   
    
    
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.downLoadingTableView) {
        
        return self.downingList.count;
        
    }else{
        
        return self.finishedList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPDownLoadImageCell *cell;
    
    if (tableView == self.alreadyDownloadTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownLoadImageCellAlready"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownLoadImageCell" owner:self options:nil]firstObject];
        }
        
        cell.viewControllerType = DownloadViewController;
        
        //!已下载
        if (self.finishedList.count && self.finishedList.count > indexPath.row) {
            
            DownloadLogItem *downloadLogItem = [self.finishedList objectAtIndex:indexPath.row];
            
            DownloadLogFigure *windowFigure = downloadLogItem.windowFigure;
            DownloadLogFigure *objectiveFigure = downloadLogItem.objectiveFigure;
            cell.objectiveDownloadLogFigure = objectiveFigure;
            cell.windowDownloadLogFigure = windowFigure;

            cell.goodsNo = downloadLogItem.goodsNo;
            
            [cell.windowDefaultImgaeView sd_setImageWithURL:[NSURL URLWithString:downloadLogItem.pictureUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
            
            cell.windowImageDownLoadAgain.figure = windowFigure;
            cell.objectImgaeDownLoadAgain.figure = objectiveFigure;
            //!再次下载窗口图
            [cell.windowImageDownLoadAgain addTarget:self action:@selector(windowImageDownLoadAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            //!再次下载客观图
            [cell.objectImgaeDownLoadAgain addTarget:self action:@selector(objectImgaeDownLoadAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //!选中窗口图 客观图 按钮
            //控制点击even
            [cell.windowImageSelectedButton addTarget:self action:@selector(windowImageSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.windowImageSelectedButton.figure = windowFigure;
            
            [cell.objectImageSelectedButton addTarget:self action:@selector(objectImageSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.objectImageSelectedButton.figure = objectiveFigure;
            
            if (windowFigure.isDownloaded) {
                //窗口图文件大小
                cell.windowImageSizeLabel.text = [self getPicSize:windowFigure.fileContentSize];

//                CGFloat windowSize = [downloadLogItem.windowPicSize floatValue];
//
//                cell.windowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",windowSize/CONVERT];
                
                //图片张数
                cell.alreadyDownloadWindowImageItemsLabel.text = [NSString stringWithFormat:@"窗口图(%@)张",downloadLogItem.windowFigure.imageItems];
                
                cell.downLoadWindowImageBackView.hidden = NO;
                
            }else{

                cell.downLoadWindowImageBackView.hidden = YES;
            }
            
            if (objectiveFigure.isDownloaded) {
                
                //客观图文件大小
                cell.objectImageSizeLabel.text = [self getPicSize:objectiveFigure.fileContentSize];
                
//                CGFloat objectiveSize = [downloadLogItem.objectivePicSize floatValue];
////
//                cell.objectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",objectiveSize/CONVERT];

                //图片张数
                cell.alreadyDownloadObjectImageItemsLabel.text = [NSString stringWithFormat:@"客观图(%@)张",downloadLogItem.objectiveFigure.imageItems];

                
                cell.downLoadObjectImageBackView.hidden = NO;
            }else{
                cell.downLoadObjectImageBackView.hidden = YES;
            }
            
            //移动位置
            if (cell.downLoadWindowImageBackView.hidden) {
                
                cell.downLoadObjectImageBackViewTopConstraint.constant = 15.0f;
            }else{
                
                cell.downLoadObjectImageBackViewTopConstraint.constant = 40.0f;

            }
            
            //控制编辑按钮
            [cell isAlreadyDownloadEdit:_isAlreadyDownloadEdit];
            
            //!从已经选中的数组中判断 并 改变是否选中窗口图 、客观图
            if ([self.selectedArray containsObject:windowFigure]) {
                cell.windowImageSelectedButton.selected = YES;
            }else{
                cell.windowImageSelectedButton.selected = NO;
            }
            
            if ([self.selectedArray containsObject:objectiveFigure]) {
                cell.objectImageSelectedButton.selected = YES;
            }else{
                cell.objectImageSelectedButton.selected = NO;
            }
            
        }
 
    }else{//正在下载
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownLoadImageCellDownLoading"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownLoadImageCell" owner:self options:nil]lastObject];
        }
        
        cell.viewControllerType = DownloadViewController;
        
        
        if (self.downingList.count && self.downingList.count > indexPath.row) {
            
            DownloadLogItem *downloadLogItem = [self.downingList objectAtIndex:indexPath.row];
            
            cell.goodsNo = downloadLogItem.goodsNo;
            
            [cell.downLoadingDefaultImgaeView sd_setImageWithURL:[NSURL URLWithString:downloadLogItem.pictureUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
            
            //控制编辑删除和暂停启动按钮的状态
            [cell controlEditButtonStatusIsDisplaydownloadingEdit:_isDisplaydownloadingEdit];
            
            //判断客观图、窗口图是否存在
            if (![downloadLogItem isDownloadingFigureType:DownloadFigureTypeOfWindow]) {
                cell.downLoadingWindownImageBackView.hidden = YES;
            }else{
                cell.downLoadingWindownImageBackView.hidden = NO;
            }
            
            if (![downloadLogItem isDownloadingFigureType:DownloadFigureTypeOfObjective]) {
                cell.downLoadingObjectImageBackView.hidden = YES;
            }else{
                cell.downLoadingObjectImageBackView.hidden = NO;
            }
            
            DownloadLogFigure *windowFigure = downloadLogItem.windowFigure;
            DownloadLogFigure *objectiveFigure = downloadLogItem.objectiveFigure;
            
            cell.objectiveDownloadLogFigure = objectiveFigure;
            cell.windowDownloadLogFigure = windowFigure;
            
            cell.downloadingWindowImageEditButton.figure = windowFigure;
            [cell.downloadingWindowImageEditButton addTarget:self action:@selector(downloadingWindowImageEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.downloadingObjectImageEditButton.figure = objectiveFigure;
            [cell.downloadingObjectImageEditButton addTarget:self action:@selector(downloadingObjectImageEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //初始化状态
            if (windowFigure.status == DownloadItemStatusForDownloading) {
                cell.downLoadingWindowSelectedButton.selected = NO;
            }else{
                cell.downLoadingWindowSelectedButton.selected = YES;
            }
            
            if (objectiveFigure.status == DownloadItemStatusForDownloading) {
                cell.downLoadingObjectSelectedButton.selected = NO;
            }else{
                cell.downLoadingObjectSelectedButton.selected = YES;
            }
            
            //控制勾选
            if ([self.deleteArray containsObject:windowFigure]) {
                cell.downloadingWindowImageEditButton.selected = YES;
            }else{
                cell.downloadingWindowImageEditButton.selected = NO;
            }
            
            if ([self.deleteArray containsObject:objectiveFigure]) {
                cell.downloadingObjectImageEditButton.selected = YES;
            }else{
                cell.downloadingObjectImageEditButton.selected = NO;
            }
            
            
            
            //窗口图文件大小
            cell.downLoadingWindowImageSizeLabel.text = [self getPicSize:windowFigure.fileContentSize];

            
//            CGFloat windowPicSize = [downloadLogItem.windowPicSize floatValue];
////
//            cell.downLoadingWindowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",windowPicSize/CONVERT];

            
            //图片张数
            cell.windowImageItemsLabel.text = [NSString stringWithFormat:@"窗口图(%@)",downloadLogItem.windowFigure.imageItems];
            
            //窗口图进度条
            cell.downLoadingWindowProgressView.progress = windowFigure.progress;
            
            //窗口图已经下载了多少
            cell.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%@/%@",[self getPicSize:windowFigure.receivedBytes],[self getPicSize:windowFigure.fileContentSize]];

            //!如果是暂停的，速度为0kb/s   如果没有下载：总大小、已下载的比例不显示
            if (!windowFigure.receivedBytes) {
                
                cell.downLoadingWindowImageSizeLabel.text = @"";
                cell.downLoadingWindowProportionLabel.text = @"";
                
            }
            
//            cell.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",windowFigure.receivedBytes/(CONVERT *CONVERT),windowPicSize/CONVERT];

            
            
            //客观图文件大小
            cell.downLoadingObjectImageSizeLabel.text = [self getPicSize:objectiveFigure.fileContentSize];

//            CGFloat objectivePicSize = [downloadLogItem.objectivePicSize floatValue];
////
//            cell.downLoadingObjectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",objectivePicSize/CONVERT];

            
            //图片张数
            cell.objectImageItemsLabel.text = [NSString stringWithFormat:@"客观图(%@)",downloadLogItem.objectiveFigure.imageItems];
            //客观图进度条
            cell.downLoadingObjectProgressView.progress = objectiveFigure.progress;
            
            //客观图已经下载了多少
            cell.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%@/%@",[self getPicSize:objectiveFigure.receivedBytes],[self getPicSize:objectiveFigure.fileContentSize]];

//            cell.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",objectiveFigure.receivedBytes/(CONVERT *CONVERT),objectivePicSize/CONVERT];

            //!如果是暂停的，速度为0kb/s   如果没有下载：总大小、已下载的比例不显示
            if (!objectiveFigure.receivedBytes) {
                
                cell.downLoadingObjectImageSizeLabel.text = @"";
                cell.downLoadingObjectProportionLabel.text = @"";
                
            }
            
            
        }
        
    }
    return cell;

}
/*
 不满足1MB，显示为kb
 不满足1GB，显示mb
 不满足1TB,显示G
 
 fileContentSize 单位:byte
 1T = 1024G
 1G = 1024MB
 1MB = 1024kb
 1kb = 1024b
 
*/
-(NSString *)getPicSize:(long long)fileContentSize{

    NSString * sizeStr = @"";
    
    // 1T = 1024G = 1024 * 1024 MB = 1024*1024*1024 kb = 1024*1024*1024*1024 b
    double tbSize = pow(CONVERT, 4);
    double gbSize = pow(CONVERT, 3);
    double mbSize = pow(CONVERT, 2);
    double kbSize = CONVERT;
    
    if (fileContentSize>=tbSize) {//!大于T
        
        sizeStr = [NSString stringWithFormat:@"%.2fTB",fileContentSize/tbSize];
        
    }else if (fileContentSize>=gbSize){//!大于GB
    
        sizeStr = [NSString stringWithFormat:@"%.2fGB",fileContentSize/gbSize];

    }else if (fileContentSize>=mbSize){
    
        sizeStr = [NSString stringWithFormat:@"%.2fMB",fileContentSize/mbSize];

    }else{
    
        sizeStr = [NSString stringWithFormat:@"%.2fkb",fileContentSize/kbSize];

    }

    
    return sizeStr;

}


#pragma mark-已下载-点击cell中的窗口图再次下载
- (void)windowImageDownLoadAgainClick:(CSPSelectedButton *)sender{
    
//    [self tipDownloadAgainWithTitle:@"提示" message:@"确定要重新下载此窗口图" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" selectedButton:sender];
    

    [self isDownloadAgain:sender];

    
}

#pragma mark-已下载-点击cell中的客观图再次下载
- (void)objectImgaeDownLoadAgainClick:(CSPSelectedButton *)sender{
    
//    [self tipDownloadAgainWithTitle:@"提示" message:@"确定要重新下载此客观图" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" selectedButton:sender];
    

    [self isDownloadAgain:sender];

    
}

- (void)tipDownloadAgainWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle selectedButton:(CSPSelectedButton *)selectedButton{
    
//    [JCAlertView showTwoButtonsWithTitle:title Message:message ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:cancelButtonTitle Click:^{
//        
//        
//        
//    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:otherButtonTitle Click:^{
//        [self isDownloadAgain:selectedButton];
//    }];
    
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:otherButtonTitle withOkButtonColor:nil cancelButtonTitle:cancelButtonTitle withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self isDownloadAgain:selectedButton];

        
    } dismissAction:^{
        

    }];
    
    [alertView show];
    
}

#pragma mark-已下载-控制点击cell再次下载
- (void)isDownloadAgain:(CSPSelectedButton *)sender{
    
    //!单个去下载

    NSInteger canDownloadNum = [self selectAllDownload:1];//!传入选择的个数,为-1的时候是选择的商品全部都可以下载
    
    if (canDownloadNum == 0) {
        
        return;
    }
    
    [sender.figure restartDownload];

    [self.view makeMessage:@"已加入下载队列" duration:2 position:@"center"];


}

#pragma mark-已下载-勾选窗口图
- (void)windowImageSelectedButtonClick:(CSPSelectedButton *)sender{
    [self selectedControl:sender];
}
#pragma mark-已下载-勾选客观图
- (void)objectImageSelectedButtonClick:(CSPSelectedButton *)sender{
    [self selectedControl:sender];
}
#pragma mark-控制勾选
- (void)selectedControl:(CSPSelectedButton *)sender{
    if ([self.selectedArray containsObject:sender.figure]) {
        [self.selectedArray removeObject:sender.figure];
    }else{
        [self.selectedArray addObject:sender.figure];
    }
    
    [self.alreadyDownloadTableView reloadData];
    
    if ([self isSelectedAll]) {
        
        [self alreadDownloadAllSelectedButtonClick:nil];

    }else{
        
        _isAlreadSelectedAll = NO;
        self.alreadDownloadAllSelectedButton.selected = NO;
        
    }
    
}
#pragma mark-控制勾选时是否触发全选
- (BOOL)isSelectedAll{
    NSInteger i = 0;
    for (DownloadLogItem *downloadLogItem in self.finishedList) {
        if (downloadLogItem.windowFigure.isDownloaded) {
            i++;
        }
        if (downloadLogItem.objectiveFigure.isDownloaded) {
            i++;
        }
    }
    
    if (self.selectedArray.count == i) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}
#pragma mark-正下载-勾选窗口图
- (void)downloadingWindowImageEditButtonClick:(CSPSelectedButton *)sender{
    [self downloadingSelectedControl:sender];
}
#pragma mark-正下载-勾选客观图
- (void)downloadingObjectImageEditButtonClick:(CSPSelectedButton *)sender{
    [self downloadingSelectedControl:sender];
}

#pragma mark-正下载-控制勾选
- (void)downloadingSelectedControl:(CSPSelectedButton *)sender{
    if ([self.deleteArray containsObject:sender.figure]) {
        [self.deleteArray removeObject:sender.figure];
    }else{
        [self.deleteArray addObject:sender.figure];
    }
    
    [self.downLoadingTableView reloadData];
    
    if ([self isDeleteAll]) {
        [self selectedAllDownloadButtonClick:nil];
        
    }else{
        _isDownloadingAllSelected = NO;
        self.selectedAllDownloadButton.selected = NO;
    }
}
#pragma mark-已下载-控制勾选时是否触发全选
- (BOOL)isDeleteAll{
    
    NSInteger i = 0;
    for (DownloadLogItem *downloadLogItem in self.downingList) {
        if (downloadLogItem.windowFigure.isDownloading) {
            i++;
        }
        if (downloadLogItem.objectiveFigure.isDownloading) {
            i++;
        }
    }
    
    if (self.deleteArray.count == i) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.alreadyDownloadTableView) {
        
        return 81;
        
    }else{
        return 108;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadLogItem *downloadLogItem;
    if (tableView == self.alreadyDownloadTableView) {
        
        downloadLogItem = [self.finishedList objectAtIndex:indexPath.row];
        
    }else if (tableView == self.downLoadingTableView){
        
        downloadLogItem = [self.downingList objectAtIndex:indexPath.row];
    }
    
//    跳转到商品详情
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = downloadLogItem.goodsNo;
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
    //
    //            goodsInfo.goodsNo = commodityInfo.goodsNo;
    
    GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    
    [self.navigationController pushViewController:goodsInfo animated:YES];
    
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self swichData];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self swichData];
}

- (void)swichData{
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.lastPage == page) {
        //页面没有滚动过去，不需要操作
    }else{
        
        self.lastPage = page;
        
        if (page == 0) {
            
            _isDisplayAlreadyDownload = YES;
            _isDisplaydownloading = NO;
            
            //!显示已下载
            [self setSCAndTableViewCanScrollerToTop:YES];
            
            
        }else{
            
            _isDisplaydownloading = YES;
            _isDisplayAlreadyDownload = NO;
            
            //!显示 正在下载
            [self setSCAndTableViewCanScrollerToTop:NO];

        }
        
        [self displayData];
    }
    
    
}
//!设置 “已下载”/"正在下载"列表点击顶部可返回置顶的功能 isShowDownLoaded:显示的是否是“已下载”
-(void)setSCAndTableViewCanScrollerToTop:(BOOL)isShowDownLoaded{


    self.scrollView.scrollsToTop = NO;
    self.alreadyDownloadTableView.scrollsToTop = isShowDownLoaded;
    self.downLoadingTableView.scrollsToTop = !isShowDownLoaded;
    
    
}

#pragma mark-已下载
- (IBAction)downLoadingButtonClick:(id)sender {
    
    CGPoint point = CGPointMake(self.view.frame.size.width, 0);
    
    [self.scrollView setContentOffset:point animated:YES];
    
}

#pragma mark-正下载
- (IBAction)alreadyDownLoadButtonClick:(id)sender {
    
    CGPoint point = CGPointMake(0, 0);
    
    [self.scrollView setContentOffset:point animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark-购买下载次数
- (IBAction)buyDownLoadNoClick:(id)sender {
    
    
    if(self.getPayMerchantDownload.downloadNum.integerValue == -1){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当月无限下载，无需购买下载次数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }else {
        
        //!让按钮不可以用，将要出现的时候再可用
        self.buyDownloadbtn.enabled = NO;
        
        self.residueDownBtn.enabled = NO;
        
        //跳转付费下载
        CSPPayAndDownloadViewController *payDownLoadView = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAndDownloadViewController"];
        
        [self.navigationController pushViewController:payDownLoadView animated:YES];
    }
    
    
    
}

#pragma mark-编辑
- (IBAction)editButtonClick:(id)sender {
    
    if (_isDisplayAlreadyDownload) {
        
        _isAlreadyDownloadEdit = !_isAlreadyDownloadEdit;
        
        if (_isAlreadyDownloadEdit) {
            
            //点击编辑的时候，让所有选择的数据清空，重新选择
            _isAlreadSelectedAll = NO;
            self.alreadDownloadAllSelectedButton.selected = _isAlreadSelectedAll;
            [self.selectedArray removeAllObjects];
            
            
            [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
            
            [self showBottomView:self.alreadDownloadButtomView];
            
        }else{
            
            [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
            
            [self showBottomView:self.residueDownloadNoBackgroundView];
        }
        
        [self.editButton setImage:nil forState:UIControlStateNormal];
        
        [self.alreadyDownloadTableView reloadData];
        
    }else if (_isDisplaydownloading){
        
        _isDisplaydownloadingEdit = !_isDisplaydownloadingEdit;
        
        if (_isDisplaydownloadingEdit) {
            
            
            [self showBottomView:self.downloadingDeleteBottomView];
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
            
            [self.editButton setImage:nil forState:UIControlStateNormal];
            
        }else{
            
            [self showBottomView:self.residueDownloadNoBackgroundView];
            
            [self.editButton setTitle:nil forState:UIControlStateNormal];
            
            [self.editButton setImage:[UIImage imageNamed:@"04_商品图片下载_删除"] forState:UIControlStateNormal];
        }
        
        [self.downLoadingTableView reloadData];
    }
}

/**
 *  显示哪个底部的bottomView
 *
 *  @param view 有4个bottomView
 */
- (void)showBottomView:(UIView *)view{
    
    
    if (view == self.downloadingDeleteBottomView) {//!正在下载界面底部（清除）
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = NO;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        
        //!正在下载界面显示清除的时候，购买下载次数按钮为不可用
        self.buyDownloadbtn.enabled = NO;
        
        self.residueDownBtn.enabled = NO;

        
    }else if (view == self.alreadDownloadButtomView){//!已下载界面底部（再次下载、清除）
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = NO;
        self.buyNoBackgroundView.hidden = YES;
        
        //!已下载界面显示清除的时候，购买下载次数按钮为不可用
        self.buyDownloadbtn.enabled = NO;

        self.residueDownBtn.enabled = NO;

    
    }else if (view == self.buyNoBackgroundView){
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = NO;
        
        self.buyDownloadbtn.enabled = YES;//!显示购买底部的时候，购买按钮可用

        self.residueDownBtn.enabled = YES;

    
    }else if (view == self.residueDownloadNoBackgroundView){//!购买次数
        
        self.residueDownloadNoBackgroundView.hidden = NO;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        
        self.buyDownloadbtn.enabled = YES;//!显示购买底部的时候，购买按钮可用

        self.residueDownBtn.enabled = YES;

        
    }else{
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
   
        self.buyDownloadbtn.enabled = YES;//!显示购买底部的时候，购买按钮可用

        self.residueDownBtn.enabled = YES;

    }
    
}

#pragma mark-全部暂停
- (IBAction)displayDataTypeButtonClick:(id)sender {
    
    if (_isDisplaydownloading) {
        //全部暂停
        _isAllPause = !_isAllPause;
        
        if (_isAllPause) {
            
            //!这是新写的，原来的方法再次开启下载的时候 顺序会混乱
            [[DownloadLogControl sharedInstance] suspendAllDownLoad];

//            [[MHImageDownloadManager sharedInstance]suspendAllProcessor];
            
            [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部开始（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];
            
        }else{
            

            [[DownloadLogControl sharedInstance] resumeAllDownLoad];

            
//            [[MHImageDownloadManager sharedInstance]resumeAllProcessor];
            
            
            [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部暂停（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];

        }
        
        [self.downLoadingTableView reloadData];
    }
}

#pragma mark-删除正在下载
- (IBAction)deleteDownloadingButtonClick:(id)sender {
    
    for (DownloadLogFigure *figure in self.deleteArray) {
        figure.selected = YES;
    }
    
    [[DownloadLogControl sharedInstance]removeAllSelectedDownloadingLogItems];
    
    _isDownloadingAllSelected = NO;

    [self handleData];
}

#pragma mark-正下载-全选
- (IBAction)selectedAllDownloadButtonClick:(id)sender {
    
    
    UIButton *btn = sender;
    [btn setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_选中"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];
    

    
    _isDownloadingAllSelected  = !_isDownloadingAllSelected;
    
    self.selectedAllDownloadButton.selected = _isDownloadingAllSelected;
    
    [self.deleteArray removeAllObjects];
    
    if (_isDownloadingAllSelected) {
        for (DownloadLogItem *downloadingLogItem in self.downingList) {
            if (downloadingLogItem.windowFigure.isDownloading) {
                [self.deleteArray addObject:downloadingLogItem.windowFigure];
            }
            if (downloadingLogItem.objectiveFigure.isDownloading) {
                [self.deleteArray addObject:downloadingLogItem.objectiveFigure];
            }
        }
    }
    
    [self.downLoadingTableView reloadData];
}

#pragma mark-已下载-全选
- (IBAction)alreadDownloadAllSelectedButtonClick:(id)sender {
    
    
    UIButton *btn = sender;
    [btn setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_选中"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];
    
    
    
    _isAlreadSelectedAll = !_isAlreadSelectedAll;
    
    self.alreadDownloadAllSelectedButton.selected = _isAlreadSelectedAll;
    
    [self.selectedArray removeAllObjects];

    if (_isAlreadSelectedAll) {
        
        for (DownloadLogItem *downloadLogItem in self.finishedList) {
            if (downloadLogItem.windowFigure.isDownloaded) {
                [self.selectedArray addObject:downloadLogItem.windowFigure];
                
            }
            if (downloadLogItem.objectiveFigure.isDownloaded) {
                [self.selectedArray addObject:downloadLogItem.objectiveFigure];
            }
        }
    }
    
    [self.alreadyDownloadTableView reloadData];
}

#pragma mark-已下载-底部再次下载
- (IBAction)alreadDownloadAgainButtonClick:(id)sender {
    
    if (!self.selectedArray.count) {
        [self alertViewWithTitle:@"提示" message:@"请选择要下载的图片"];
        return;
    }else{
        
        NSInteger canDownCount = [self selectAllDownload:self.selectedArray.count];
         if (canDownCount == 0) {//!下载次数不够
            
            return;
        }
        
        if (canDownCount != -1) {//!不能全部下载，则截取出可以下载的部分
            
            NSArray * tempArray = [self.selectedArray subarrayWithRange:NSMakeRange(0 , canDownCount)];

            self.selectedArray = [NSMutableArray arrayWithArray:tempArray];
            
        }
       
        
        for (DownloadLogFigure *figure in self.selectedArray) {
            figure.selected = YES;
        }
        
        [self.view makeMessage:@"已加入下载队列" duration:2.0 position:@"center"];
        [[DownloadLogControl sharedInstance]restartAllSelectedDownloadedLogItems];
        //重置
        _isAlreadSelectedAll = NO;
        self.alreadDownloadAllSelectedButton.selected = _isAlreadSelectedAll;
        [self.selectedArray removeAllObjects];
        
        //调用编辑按钮
        [self editButtonClick:nil];
        
        [self handleData];
        
    }
    
    
}

#pragma mark-已下载-清除
- (IBAction)alreadDownloadClearButtonClick:(id)sender {
    
    if (!self.selectedArray.count) {
        [self alertViewWithTitle:@"提示" message:@"请选择"];
        return;
    }
    
    for (DownloadLogFigure *figure in self.selectedArray) {
        figure.selected = YES;
    }
    
    [[DownloadLogControl sharedInstance]removeAllSelectedDownloadedLogItems];
    
    [self handleData];
}

#pragma mark-购买次数
- (IBAction)buyDownloadNoButtonClick:(id)sender {

    
    
    if(self.getPayMerchantDownload.downloadNum.integerValue == -1){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当月无限下载，无需购买下载次数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    
    }else {
        
        //!让按钮不可以用，将要出现的时候再可用
        self.buyDownloadbtn.enabled = NO;
        
        self.residueDownBtn.enabled = NO;

        //跳转付费下载
        CSPPayAndDownloadViewController *payDownLoadView = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAndDownloadViewController"];
        
        [self.navigationController pushViewController:payDownLoadView animated:YES];
        
    }
    
}

#pragma mark-下载次数控制
- (BOOL)isDownload{
    
    //判断等于下载次数（下载次数需要考虑选择多个下载的情况）
    if (self.getPayMerchantDownload.downloadNum.integerValue!=-1 && self.getPayMerchantDownload.downloadNum.integerValue<self.selectedArray.count) {
        //提示需要修改
        [self alertViewWithTitle:@"提示" message:@"下载次数不足"];
        return NO;
    }
    return YES;
    
}
//!点击全选按钮时候的权限判断：可以全部下载返回-1，不可以就返回可以下载的个数
-(NSInteger)selectAllDownload:(NSInteger)selectCount{
    
    NSInteger downCount = self.getPayMerchantDownload.downloadNum.integerValue - [DownloadLogControl sharedInstance].downloadingItems ;//!把正在下载的下载完成之后剩下的下载个数
    
    //!无限制下载 -->可以直接下载
    if (self.getPayMerchantDownload.downloadNum.integerValue == -1) {
        
        return -1;
        
    }else if(downCount >= selectCount){
        
        //选择下载的个数 <= 下载次数 ---->可以直接下载
        
        return -1;
        
    }else if (downCount == 0 || downCount <0){//!次数不够
        
        [self.view makeMessage:@"您下载次数不够" duration:2.0 position:@"center"];
        return 0;
        
        
    }else if(downCount < selectCount){//!不可以全部下载，返回可以下载的个数
        
        
        NSString * message = [NSString stringWithFormat:@"已选择%ld个下载项，超出了您的剩余下载次数。已将其中%ld个加入下载队列。",selectCount,downCount];
        
        GUAAlertView * alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:nil];
        
        [alertView show];
        
        
        return downCount;
        
        
    }
    
    return 0;
    
}


- (void)actionWhenPopViewDimiss{
    
    
}


@end
