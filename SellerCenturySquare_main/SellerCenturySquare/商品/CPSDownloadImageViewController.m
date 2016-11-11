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

#import "CSPPayDownloadViewController.h"

#import "CPSGoodsDetailsPreviewViewController.h"

#import "GetMerchantNotAuthTipDTO.h"

#import "CSPAuthorityPopView.h"

#import "CSPVIPUpdateViewController.h"
#import "GUAAlertView.h"// !提示的view
#import "LoginDTO.h"

#import "CSPDownLoadImageDTO.h"
#import "CSPDownloadImageView.h"
#import "SDRefresh.h"
#import "BatchTableViewCell.h"
#import "SecondaryViewController.h"

#import "TransactionRecordsViewController.h"
#import "GUAAlertView.h"

@interface CPSDownloadImageViewController ()<UITableViewDataSource,UITableViewDelegate,DownloadLogControlDelegate,CSPAuthorityPopViewDelegate,SecondaryViewControllerDelegate>

@property (nonatomic, assign)id<NSObject> notification;


@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;

@property (strong,nonatomic)UITableView *batchDownloadTableView;

@property (strong,nonatomic)UITableView *alreadyDownloadTableView;

@property (strong,nonatomic)UITableView *downLoadingTableView;

@property (strong,nonatomic)GetPayMerchantDownloadDTO *getPayMerchantDownload;

@property (weak, nonatomic) IBOutlet UIButton *batchDownLoadButton;
//!底部批量下载view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *batchDownViewHight;

@property (weak, nonatomic) IBOutlet UIButton *alreadyDownLoadButton;

- (IBAction)alreadyDownLoadButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *downLoadingButton;

- (IBAction)downLoadingButtonClick:(id)sender;


@property(nonatomic,strong)NSMutableArray * batchDownloadList;//!批量下载数组

@property (strong,nonatomic)NSMutableArray *downingList;

@property (strong,nonatomic)NSMutableArray *finishedList;

@property (weak, nonatomic) IBOutlet UILabel *residueDownloadNoLabel;

- (IBAction)buyDownLoadNoClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *displayDataTypeButton;

- (IBAction)displayDataTypeButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)editButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *downloadingDeleteBottomView;
//删除
- (IBAction)deleteDownloadingButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectedAllDownloadButton;

- (IBAction)selectedAllDownloadButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *alreadDownloadAllSelectedButton;

- (IBAction)alreadDownloadAllSelectedButtonClick:(id)sender;

- (IBAction)alreadDownloadAgainButtonClick:(id)sender;

- (IBAction)alreadDownloadClearButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *alreadDownloadButtomView;

//没有下载过的时候
//购买次数
@property (weak, nonatomic) IBOutlet UIView *buyNoBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *buyNoLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyDownloadbtn;

- (IBAction)buyDownloadNoButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *residueBuyDownBtn;

@property (weak, nonatomic) IBOutlet UIView *residueDownloadNoBackgroundView;

//!批量下载页面 编辑时底部的view
@property (weak, nonatomic) IBOutlet UIView *batchEditBottomView;
//!批量下载，选中全部的按钮
@property (weak, nonatomic) IBOutlet UIButton *batchSelectAllBtn;

@property(nonatomic,assign)int batchSelectCount;//!批量下载页面已经选中的个数

@property(assign,nonatomic)NSInteger lastPage;

//控制已下载页面存放选择需要再次下载的数据
@property (strong,nonatomic)NSMutableArray *selectedArray;
//控制正下载页面存放需要删除的数据
@property (strong,nonatomic)NSMutableArray *deleteArray;
//控制下载权限
@property (strong,nonatomic)GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;

@property (nonatomic, weak) SDRefreshHeaderView * refreshHeader;

@property (nonatomic, weak) SDRefreshFooterView * refreshFooter;

@end

@implementation CPSDownloadImageViewController{
    /**
     *  用来控制当前显示已下载或者正在下载的数据
     */
    BOOL _isDisplayBatchDownoad;
    
    BOOL _isDisplayAlreadyDownload;
    
    BOOL _isDisplaydownloading;
    
    
    /**
     *  用来控制已经下载或者正在下载页面是否在编辑
     */
    BOOL _isBatchDownloadEdit;//!批量下载
    
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
    
    //!批量下载
    int pageNo;
    int pageSize;
    
    int batchTotal;//!可批量下载的商品总数目
    
    UILabel *batchNoDataLabel;//!批量下载列表 无数据的时候显示的提示
    
    GUAAlertView * guAlertView;//!提示的view
    
}

- (UIColor *)getButtonSelectedBackgroundColor{
    
    return HEX_COLOR(0x323232FF);
}

- (void)displayData{
    
    self.batchDownLoadButton.selected = _isDisplayBatchDownoad;
    
    self.alreadyDownLoadButton.selected = _isDisplayAlreadyDownload;
    
    self.downLoadingButton.selected = _isDisplaydownloading;
    
    //!批量下载页面
    if (_isDisplayBatchDownoad) {
        
        //!有数据的时候不隐藏顶部view，无数据则隐藏顶部的view并且把对应的 编辑状态修改为 不编辑的no状态
        if (self.batchDownloadList.count >0) {
            
            self.topBackgroundView.hidden = NO;
            
            batchNoDataLabel.hidden = YES;//!批量下载隐藏无数据的提示
            
        }else{
            
            self.topBackgroundView.hidden = YES;
            _isBatchDownloadEdit = NO;
            
            //!无数据的提示
            if (!batchNoDataLabel) {
                
                batchNoDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 30)];
                batchNoDataLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                
                batchNoDataLabel.text = @"暂无相关商品";
                batchNoDataLabel.textAlignment = NSTextAlignmentCenter;
                [batchNoDataLabel setFont:[UIFont systemFontOfSize:18]];
                [self.view addSubview:batchNoDataLabel];
                
            }
            
            batchNoDataLabel.hidden = NO;
            
        }
        
        //!改变顶部按钮的颜色
        self.batchDownLoadButton.backgroundColor =  [UIColor whiteColor];
        
        self.alreadyDownLoadButton.backgroundColor = [self getButtonSelectedBackgroundColor];
        
        self.downLoadingButton.backgroundColor = [self getButtonSelectedBackgroundColor];

        [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"商品:%d",batchTotal] forState:UIControlStateNormal];//!此时显示商品总数量
        
        //控制编辑还是完成
        if (!_isBatchDownloadEdit) {
            
            [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
            
        }else{
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        
        [self.editButton setImage:nil forState:UIControlStateNormal];
        
        
        //!底部发提示
        //判断bottomView如何显示
        if (_isBatchDownloadEdit) {//!编辑状态下
            
            [self showBottomView:self.batchEditBottomView];
            
        }else{
            
            if (_isDownloadingImage) {//!下载过图片
                
                [self showBottomView:self.residueDownloadNoBackgroundView];
                
            }else{//!未下载过图片
                
                
                if([self.getPayMerchantDownload.downloadNum intValue]==-1){//!v6 无限次下载
                    
                    [self showBottomView:self.residueDownloadNoBackgroundView];
                    
                    
                }else{//!非无限次下载
                    
                    [self showBottomView:self.buyNoBackgroundView];
                    
                    //购买次数：10次/￥300
                    self.buyNoLabel.text = [NSString stringWithFormat:@"购买次数：%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
                    
                }
                
                
                
            }
            
        }
        
        
    }
    
    
    //已下载列表
    if (_isDisplayAlreadyDownload) {
        
        
        batchNoDataLabel.hidden = YES;//!批量下载隐藏无数据的提示
        
        if (self.finishedList.count>0) {
            
            self.topBackgroundView.hidden = NO;
            
        }else{
            
            self.topBackgroundView.hidden = YES;
            _isAlreadyDownloadEdit = NO;
            
        }
        //!改变顶部按钮的颜色
        self.batchDownLoadButton.backgroundColor =  [self getButtonSelectedBackgroundColor];
        
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
        if (self.finishedList.count) {
            
            if (_isAlreadyDownloadEdit) {
                [self showBottomView:self.alreadDownloadButtomView];
            }else{
                [self showBottomView:self.residueDownloadNoBackgroundView];
            }
            
        }else{//!已下载列表为空
            
            if (_isDownloadingImage) {//!下载过图片
                
                [self showBottomView:self.residueDownloadNoBackgroundView];
                
            }else{//!未下载过图片
                

                if([self.getPayMerchantDownload.downloadNum intValue]==-1){//!v6 无限次下载
                
                    [self showBottomView:self.residueDownloadNoBackgroundView];

                
                }else{//!非无限次下载
                
                    [self showBottomView:self.buyNoBackgroundView];
                    
                    //购买次数：10次/￥300
                    self.buyNoLabel.text = [NSString stringWithFormat:@"购买次数：%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
                
                }
                
                
                
            }
        }
        
    }
    
    //正在下载列表
    if (_isDisplaydownloading) {
        
        batchNoDataLabel.hidden = YES;//!批量下载隐藏无数据的提示
        
        if (self.downingList.count>0) {
            
            self.topBackgroundView.hidden = NO;
            
        }else{
            
            self.topBackgroundView.hidden = YES;
            _isDisplaydownloadingEdit = NO;
        }
        
        //!改变顶部按钮的颜色
        self.batchDownLoadButton.backgroundColor =  [self getButtonSelectedBackgroundColor];
        
        self.alreadyDownLoadButton.backgroundColor = [self getButtonSelectedBackgroundColor];
        
        self.downLoadingButton.backgroundColor = [UIColor whiteColor];
        
        //需要判断是暂停还是开始

        [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部暂停（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];

//        //!判断下载列表里面的数据 按钮是要显示“全部暂停”或者“全部开始”
//        if ([[DownloadLogControl sharedInstance] downloadingIsAllPause]) {//!正在下载列表全部处于暂停状态
//            
//            _isAllPause = YES;
//            
//            [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部开始（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];
//            
//        }else{
//        
//            _isAllPause = NO;
//
//            [self.displayDataTypeButton setTitle:[NSString stringWithFormat:@"全部暂停（%lu）",(unsigned long)self.downingList.count] forState:UIControlStateNormal];
//
//        }
        
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
            
            }else{//!未下载过图片
                
                
                if([self.getPayMerchantDownload.downloadNum intValue]==-1){//!v6 无限次下载
                    
                    [self showBottomView:self.residueDownloadNoBackgroundView];
                    
                    
                }else{//!非无限次下载
                    
                    [self showBottomView:self.buyNoBackgroundView];
                    
                    //购买次数：10次/￥300
                    self.buyNoLabel.text = [NSString stringWithFormat:@"购买次数：%@次/￥%@",[self transformationData:self.getPayMerchantDownload.buyDownloadQty],[self transformationData:self.getPayMerchantDownload.buyDownloadPrice]];
                    
                }
                
                
                
            }

        }
    }
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品图片下载";
    
    [self customBackBarButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商品图片下载_历史浏览"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self initArray];
    
    //用来控制当前显示已下载或者正在下载的数据
    _isDisplayAlreadyDownload = YES;
    
    _isDisplaydownloading = NO;
    
    [self initTableView];
    
    [self setExtraCellLineHidden:self.batchDownloadTableView];
    
    [self setExtraCellLineHidden:self.alreadyDownloadTableView];
    
    [self setExtraCellLineHidden:self.downLoadingTableView];
    
    
    //!如果是苹果审核账号，则不显示底部的充值按钮
    if ([[LoginDTO sharedInstance].merchantAccount isEqualToString:AppleAccount]) {
        
        [self.residueDownloadNoBackgroundView removeFromSuperview];
        [self.buyNoBackgroundView removeFromSuperview];
        
    }
    
    
    //!第一次进入的时候，滑动到已下载页面 让sc滚动到已下载页面
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    self.lastPage = 1;//!记录当前滑动到的是第1页，不是第0页
    

    //!批量下载
    [self createBatchRefresh];
    
    
    [self requestBatchDownLoadListWithRefresh:self.refreshHeader];
    
    //!设置点击statusBar tableView 是否可置顶
    [self setScToTop:NO withDownloaded:YES withDoloading:NO];

    
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
    
    guAlertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"请在iPhone“设置-隐私-照片”中允许访问照片，否则图片无法保存成功" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        guAlertView = nil;
        [guAlertView removeFromSuperview];
        
        
    } dismissAction:nil];
    
    guAlertView.withJudge = YES;
    
    [guAlertView show];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [self tabbarHidden:YES];
    
    
    //请求数据(获取剩余下载次数、之前是否下载过图片)
    [self requestPayDownLoad];
    
    [self registerNotification];
    
    
    //!点击之后让购买按钮不可用，界面将要出现的时候再让按钮可用
    self.buyDownloadbtn.enabled = YES;
    self.residueBuyDownBtn.enabled = YES;
    
}

-(void)createBatchRefresh{

    // !请求
    SDRefreshHeaderView* refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.batchDownloadTableView];
    
    self.refreshHeader = refreshHeader;
    
    __weak CPSDownloadImageViewController * weakSelf = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf requestBatchDownLoadListWithRefresh:self.refreshHeader];
    };
    
    SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.batchDownloadTableView];
    
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf requestBatchDownLoadListWithRefresh:self.refreshFooter];

    };

    

}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:K_NOTICE_RELOADDOWNLOADCOUNT object:nil];

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
                
                [self handleData];
                
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPayDownLoad) name:K_NOTICE_RELOADDOWNLOADCOUNT object:nil];
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

#pragma mark-处理下载数据
- (void)handleData{
    //重置数据
    [self.downingList removeAllObjects];
    [self.finishedList removeAllObjects];
    
    self.downingList = (NSMutableArray *)[[DownloadLogControl sharedInstance]downloadingLogItems];
    
    self.finishedList = (NSMutableArray *)[[DownloadLogControl sharedInstance]downloadedLogItems];
    
    //处理UI(判断如果有数据，就删除无数据UI提示)
    [self displayNodataTip];
    
    [self displayData];
    
   
    
}

- (void)displayNodataTip{
    
    //先removeCSPTipNoDownloadData
    NSArray *array = self.scrollView.subviews;
    
    for (UIView *view in array) {
        
        if ([view isKindOfClass:[CSPTipNoDownloadData class]]) {
            
            
            [view removeFromSuperview];
        }
    }
    
    //!有权限的，正常情况下
    self.batchDownViewHight.constant = 49;
    [self.scrollView layoutIfNeeded];
    
    
    if (!self.finishedList.count) {//!已下载部分
        
        self.topBackgroundView.hidden = YES;
        
        if (_isDownloadingImage) {
            
            //下载过的
            //已下载列表已清空
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            tipNoDownloadData.frame = CGRectMake(self.view.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipEmptyDataView];
            
            [self.scrollView addSubview:tipNoDownloadData];
            
        }else{//未下载过
            
            
            //隐藏编辑view
            
            //!无权限下载/无限制下载，隐藏底部
            if ([_getPayMerchantDownload.authFlag isEqualToString:@"0"] || [_getPayMerchantDownload.downloadNum intValue] == -1) {
                
                self.batchDownViewHight.constant = 0;
                [self.scrollView layoutIfNeeded];
                
            }

            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            
            tipNoDownloadData.frame = CGRectMake(self.view.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
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
        
        [self.alreadyDownloadTableView reloadData];
    }
    
    //!正在下载部分
    if (!self.downingList.count) {
        
        self.topBackgroundView.hidden = YES;
        
        if (_isDownloadingImage) {
            //下载过的
            //暂无正在下载
            
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadingDataView];
            
            tipNoDownloadData.frame = CGRectMake(self.scrollView.frame.size.width * 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            [tipNoDownloadData showView:tipNoDownloadData.tipNoDownloadingDataView];
            
            tipNoDownloadData.buyMoreImageBlock = ^(){
                //查看下载历史
                [self  downloadHistory];
            };
            
            [self.scrollView addSubview:tipNoDownloadData];
            
        }else{//没下载过的
            
            
            //!无权限下载，隐藏底部
            if ([_getPayMerchantDownload.authFlag isEqualToString:@"0"] || [_getPayMerchantDownload.downloadNum intValue] == -1) {
                
                self.batchDownViewHight.constant = 0;
                [self.scrollView layoutIfNeeded];
                
                
            }
            
            CSPTipNoDownloadData *tipNoDownloadData = [[[NSBundle mainBundle]loadNibNamed:@"CSPTipNoDownloadData" owner:self options:nil]firstObject];
            
            tipNoDownloadData.frame = CGRectMake(self.view.frame.size.width * 2, 0 , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
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

#pragma mark-请求数据(获取剩余下载次数、之前是否下载过图片)
- (void)requestPayDownLoad{
    
//    [self progressHUDShowWithString:@"加载中"];
    
    [HttpManager sendHttpRequestForGetPayMerchantDownload:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                if (!self.getPayMerchantDownload) {
                    
                    self.getPayMerchantDownload = [[GetPayMerchantDownloadDTO alloc]init];
                }
                
                [self.getPayMerchantDownload setDictFrom:data];
                
            }
            
            //!是否下载过
            if (self.getPayMerchantDownload.downloadFlag.integerValue == 1) {
                
                _isDownloadingImage = YES;
                
            }else if(self.getPayMerchantDownload.downloadFlag.integerValue == 0){
                
                _isDownloadingImage = NO;
            }
            
            
            //剩余下载次数
            [self residueDownloadNo];
            
            [self handleData];
            
            
        }else{
            
            if (responseDic[@"errorMessage"] && ![responseDic[@"errorMessage"] isEqualToString:@""]) {
                
                [self.view makeMessage:[responseDic objectForKey:@"errorMessage"] duration:2.0 position:@"center"];

            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];
//        [self tipRequestFailureWithErrorCode:error.code];
        
        
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
    
    //!重新给frame
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, self.scrollView.frame.size.height);
    
    self.batchDownloadTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
    self.alreadyDownloadTableView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
    self.downLoadingTableView.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
}

- (void)initTableView{
    
    //!批量下载
    self.batchDownloadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
    self.batchDownloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.batchDownloadTableView.delegate = self;
    self.batchDownloadTableView.dataSource = self;
    [self.scrollView addSubview:self.batchDownloadTableView];
    
    
    //!已下载
    self.alreadyDownloadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
    
    self.alreadyDownloadTableView.delegate = self;
    
    self.alreadyDownloadTableView.dataSource = self;
    
    //!正在下载
    self.downLoadingTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];

    self.downLoadingTableView.delegate = self;
    
    self.downLoadingTableView.dataSource = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, self.scrollView.frame.size.height);
    
    [self.scrollView addSubview:self.alreadyDownloadTableView];
    
    [self.scrollView addSubview:self.downLoadingTableView];
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.batchDownloadTableView) {//!批量下载
        
        return  self.batchDownloadList.count;
        
    }else if (tableView == self.downLoadingTableView) {//!正在下载
        
        return self.downingList.count;
        
    }else{//!已下载
        
        return self.finishedList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPDownLoadImageCell *cell;
    
    if (tableView == self.batchDownloadTableView) {//!批量下载列表
     
        BatchTableViewCell  * batchCell = [tableView dequeueReusableCellWithIdentifier:@"batchCell"];
        if (!batchCell) {
            
            batchCell = [[[NSBundle mainBundle]loadNibNamed:@"BatchTableViewCell" owner:self options:nil]lastObject];
            
        }
        batchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
        if (self.batchDownloadList && self.batchDownloadList.count > indexPath.row) {
            
            CSPDownLoadImageDTO * downLoadDTO = self.batchDownloadList[indexPath.row];
            
            [batchCell configData:downLoadDTO withEditStatus:_isBatchDownloadEdit];
            
            __weak CPSDownloadImageViewController * vc = self;
            batchCell.downloadBlock = ^(NSString *downLoadType){
                
                //!单个去下载
                NSInteger canDownloadNum = [self selectAllDownload:1];//!传入选择的个数,为-1的时候是选择的商品全部都可以下载
                //!可以下载的个数为0 ,return
                if (canDownloadNum == 0) {
                    
                    return;
                }
                
                [vc downLoadOneImageDTO:downLoadDTO withDownLoadType:downLoadType];
                
                
            };
            
            //!编辑状态下，选中 或者 取消选中 的时候返回给controller 计算算中的数量 返回的值是：是否选中
            batchCell.changeSelectStatusInEditing = ^(BOOL isSelect){
                
                if (isSelect) {//!选中了，则计算选中的数量+1
                    
                    vc.batchSelectCount = vc.batchSelectCount +1;
                }else{
                    
                    vc.batchSelectCount = vc.batchSelectCount - 1;
                }
                
                //!改变 “全选”按钮的状态
                
                [self changeAllSelectStatus];
                
                
            };
            
            
            return batchCell;

            
        }
        
        
        
    }if (tableView == self.alreadyDownloadTableView) {//!已下载
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownLoadImageCellAlready"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownLoadImageCell" owner:self options:nil]firstObject];
        }
        
        cell.viewControllerType = DownloadViewController;
        
        if (self.finishedList.count && self.finishedList.count > indexPath.row) {
            
            DownloadLogItem *downloadLogItem = [self.finishedList objectAtIndex:indexPath.row];
            
            //窗口图
            DownloadLogFigure *windowFigure = downloadLogItem.windowFigure;
            //客观图
            DownloadLogFigure *objectiveFigure = downloadLogItem.objectiveFigure;
            
            cell.objectiveDownloadLogFigure = objectiveFigure;
            cell.windowDownloadLogFigure = windowFigure;
            
            cell.goodsNo = downloadLogItem.goodsNo;
            
            [cell.windowDefaultImgaeView sd_setImageWithURL:[NSURL URLWithString:downloadLogItem.pictureUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
            
            cell.windowImageDownLoadAgain.figure = windowFigure;
            cell.objectImgaeDownLoadAgain.figure = objectiveFigure;
            
            [cell.windowImageDownLoadAgain addTarget:self action:@selector(windowImageDownLoadAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.objectImgaeDownLoadAgain addTarget:self action:@selector(objectImgaeDownLoadAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //控制点击even
            [cell.windowImageSelectedButton addTarget:self action:@selector(windowImageSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.windowImageSelectedButton.figure = windowFigure;
            
            [cell.objectImageSelectedButton addTarget:self action:@selector(objectImageSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.objectImageSelectedButton.figure = objectiveFigure;
            
            if (windowFigure.isDownloaded) {
                //窗口图文件大小
//                cell.windowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",windowFigure.fileContentSize/(CONVERT*CONVERT)];
                
                cell.windowImageSizeLabel.text = [self getPicSize:windowFigure.fileContentSize];

                
                //图片张数
                if (downloadLogItem.windowFigure.imageItems) {
                    
                    cell.alreadyDownloadWindowImageItemsLabel.text = [NSString stringWithFormat:@"窗口图(%@)张",downloadLogItem.windowFigure.imageItems];

                }else{
                
                    cell.alreadyDownloadWindowImageItemsLabel.text = @"窗口图";

                }
                
                cell.downLoadWindowImageBackView.hidden = NO;
                
            }else{
                
                cell.downLoadWindowImageBackView.hidden = YES;
            }
            
            if (objectiveFigure.isDownloaded) {
                //客观图文件大小
//                cell.objectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",objectiveFigure.fileContentSize/(CONVERT*CONVERT)];
                cell.objectImageSizeLabel.text = [self getPicSize:objectiveFigure.fileContentSize];

                
                //图片张数
                if (downloadLogItem.objectiveFigure.imageItems) {
                    
                    cell.alreadyDownloadObjectImageItemsLabel.text = [NSString stringWithFormat:@"客观图(%@)张",downloadLogItem.objectiveFigure.imageItems];

                }else{
                
                    cell.alreadyDownloadObjectImageItemsLabel.text = @"客观图";

                }
                
                
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
            
            //控制选择
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
        
    }else if(tableView == self.downLoadingTableView){//!正在下载
        
        //正在下载
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownLoadImageCellDownLoading"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownLoadImageCell" owner:self options:nil]lastObject];
        }
        
        cell.viewControllerType = DownloadViewController;
        
        
        if (self.downingList.count && self.downingList.count >indexPath.row) {
            
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
//            cell.downLoadingWindowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",windowFigure.fileContentSize/(CONVERT *CONVERT)];
            cell.downLoadingWindowImageSizeLabel.text = [self getPicSize:windowFigure.fileContentSize];
            

            //图片张数
            cell.windowImageItemsLabel.text = [NSString stringWithFormat:@"窗口图(%@)",downloadLogItem.windowFigure.imageItems];
            
            //窗口图进度条
            cell.downLoadingWindowProgressView.progress = windowFigure.progress;
            //窗口图已经下载了多少
//            cell.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",windowFigure.receivedBytes/(CONVERT *CONVERT),windowFigure.fileContentSize/(CONVERT *CONVERT)];
            
            cell.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%@/%@",[self getPicSize:windowFigure.receivedBytes],[self getPicSize:windowFigure.fileContentSize]];
            
            DebugLog(@"~~~~~~~~~%@", [self getPicSize:windowFigure.receivedBytes]);
            
            //!如果下载数据为0，则不显示下载百分比、 总大小不显示
            if (!windowFigure.receivedBytes) {
                
                cell.downLoadingWindowProportionLabel.text = @"";
                cell.downLoadingWindowImageSizeLabel.text = @"";
                
            }
            
            //客观图文件大小
//            cell.downLoadingObjectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",objectiveFigure.fileContentSize/(CONVERT *CONVERT)];
            cell.downLoadingObjectImageSizeLabel.text = [self getPicSize:objectiveFigure.fileContentSize];

            
            //图片张数
            cell.objectImageItemsLabel.text = [NSString stringWithFormat:@"客观图(%@)",downloadLogItem.objectiveFigure.imageItems];
            //客观图进度条
            cell.downLoadingObjectProgressView.progress = objectiveFigure.progress;
            //客观图已经下载了多少
//            cell.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",objectiveFigure.receivedBytes/(CONVERT *CONVERT),objectiveFigure.fileContentSize/(CONVERT *CONVERT)];
            cell.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%@/%@",[self getPicSize:objectiveFigure.receivedBytes],[self getPicSize:objectiveFigure.fileContentSize]];
            
            //!如果下载数据为0，则不显示下载百分比、 总大小不显示
            if (!objectiveFigure.receivedBytes) {
                
                cell.downLoadingObjectProportionLabel.text = @"";
                cell.downLoadingObjectImageSizeLabel.text = @"";
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
    
    
    [self isDownloadAgain:sender];

    
    
}

#pragma mark-已下载-点击cell中的客观图再次下载
- (void)objectImgaeDownLoadAgainClick:(CSPSelectedButton *)sender{
    
    [self isDownloadAgain:sender];


}

- (void)tipDownloadAgainWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle selectedButton:(CSPSelectedButton *)selectedButton{
    
    if (message == nil || [message isEqualToString:@""] || [message isEqualToString:@" "]) {
        
        return ;
        
    }
    
    GUAAlertView *customAlertView = [GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [self isDownloadAgain:selectedButton];
       
        
    } dismissAction:nil];
    
    [customAlertView show];


}

#pragma mark-已下载-控制点击cell再次下载
- (void)isDownloadAgain:(CSPSelectedButton *)sender{
    
    
    //!单个去下载
    NSInteger canDownloadNum = [self selectAllDownload:1];//!传入选择的个数,为-1的时候是选择的商品全部都可以下载
    //!可以下载的个数为0 ,return
    if (canDownloadNum == 0) {
        
        return;
    }
    
    [sender.figure restartDownload];
    [self.view makeMessage:@"已加入下载队列" duration:2.0 position:@"center"];


    
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
    
    if (tableView == self.alreadyDownloadTableView || tableView == self.batchDownloadTableView) {//!已下载
        
        return 80;
        
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
    
    NSString *willLookGoodsNo = @"";
    
    if (tableView == self.batchDownloadTableView) {//!批量下载
        
        CSPDownLoadImageDTO * downLoadDTO = self.batchDownloadList[indexPath.row];
        willLookGoodsNo = downLoadDTO.goodsNo;
        
        
    }else if (tableView == self.alreadyDownloadTableView) {//!已下载
        
        DownloadLogItem * downloadLogItem = [self.finishedList objectAtIndex:indexPath.row];
        
        willLookGoodsNo = downloadLogItem.goodsNo;
        
    }else if (tableView == self.downLoadingTableView){//!正在下载
        
         DownloadLogItem * downloadLogItem = [self.downingList objectAtIndex:indexPath.row];
        
        willLookGoodsNo = downloadLogItem.goodsNo;
        
    }
    
    //跳转到商品详情
    CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
    
    goodsDetailsPreviewViewController.isPreview = NO;
    
    goodsDetailsPreviewViewController.noGoodsListView = YES;
    
    goodsDetailsPreviewViewController.goodsNo = willLookGoodsNo;
    
    [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
    
    
    
}
#pragma mark !请求批量下载的列表
-(void)requestBatchDownLoadListWithRefresh:(SDRefreshView *)refresh{

    
    if (refresh == self.refreshHeader) {
        
        pageNo = 1;
        pageSize = 20;

    
    }else{
        
        pageNo ++;
    }
    
    [HttpManager sendHttpRequestForDownloadAllListWithPageNo:pageNo withPageSize:pageSize Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            
            if (refresh == self.refreshHeader) {
                
                self.batchDownloadList = [NSMutableArray arrayWithCapacity:0];

                //!下拉刷新后，选中的数量变为0
                self.batchSelectCount = 0;
                
            }
           
            
            for (NSDictionary * downloadDic in responseDic[@"data"][@"list"]) {
                
                CSPDownLoadImageDTO * downLoadDTO = [[CSPDownLoadImageDTO alloc]initWithDictionary:downloadDic];
                downLoadDTO.zipsList = [NSMutableArray arrayWithCapacity:0];
                id zips = [downloadDic objectForKey:@"zips"];
                
                if ([self checkData:zips class:[NSArray class]]) {
                    
                    for (NSDictionary *zipDic in zips) {
                        
                        CSPZipsDTO *zipsDTO = [[CSPZipsDTO alloc]init];
                        [zipsDTO setDictFrom:zipDic];
                        [downLoadDTO.zipsList addObject:zipsDTO];
                    }
                    
                }
                batchTotal = [responseDic[@"data"][@"totalCount"] intValue];
                [self.batchDownloadList  addObject:downLoadDTO];
                
            }
            
            [self.batchDownloadTableView reloadData];
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            //!加载到底了
            if (self.batchDownloadList.count == batchTotal) {
                
                [self.refreshFooter noDataRefresh];
            }
            
            //!改变底部“全选”按钮的状态
            [self changeAllSelectStatus];
            
            
        }else{
        
            [self.view makeMessage:@"请求商品列表失败" duration:2.0 position:@"center"];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"请求商品列表失败" duration:2.0 position:@"center"];

        
    }];
    

}
//!每次点击cell上面的单选按钮时 需要调用，上拉、下拉时需要调用 改变底部“全选”按钮的状态
-(void)changeAllSelectStatus{

    if (self.batchSelectCount == self.batchDownloadList.count *2) {//!全部商品选中了，就改变 “全选”按钮的状态
        
        self.batchSelectAllBtn.selected = YES;
        
    }else{
        
        self.batchSelectAllBtn.selected = NO;
        
    }
    

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
    
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    
    
    
    if (self.lastPage == page) {
        //页面没有滚动过去，不需要操作
    }else{
        
        self.lastPage = page;
        
        if (page == 0) {//!批量下载
            
            _isDisplayBatchDownoad = YES;
            _isDisplayAlreadyDownload = NO;
            _isDisplaydownloading = NO;
           
            
        }else if(page == 1){//!已下载
            
            _isDisplayBatchDownoad = NO;
            _isDisplayAlreadyDownload = YES;
            _isDisplaydownloading = NO;
            
        }else{//!正在下载
        
            _isDisplayBatchDownoad = NO;
            _isDisplayAlreadyDownload = NO;
            _isDisplaydownloading = YES;
            
        
        }
        
        //!设置点击statusBar tableView 是否可置顶
        [self setScToTop:_isDisplayBatchDownoad withDownloaded:_isDisplayAlreadyDownload withDoloading:_isDisplaydownloading];
        
        
        [self displayData];
        
    }
    
}
//!设置点击statusBar tableView 是否可置顶
-(void)setScToTop:(BOOL)isBatch withDownloaded:(BOOL)isDownloaded withDoloading:(BOOL)isDowning{

    self.scrollView.scrollsToTop = NO;
    
    self.batchDownloadTableView.scrollsToTop = isBatch;
    
    self.alreadyDownloadTableView.scrollsToTop = isDownloaded;
    
    self.downLoadingTableView.scrollsToTop = isDowning;

}

#pragma mark 批量下载 按钮点击事件

- (IBAction)batchDownLoadButtonClick:(id)sender {
    
    CGPoint point = CGPointMake(0, 0);
    
    [self.scrollView setContentOffset:point animated:YES];

    
}

#pragma mark-正在下载 按钮点击事件
- (IBAction)downLoadingButtonClick:(id)sender {
    
    CGPoint point = CGPointMake(self.view.frame.size.width * 2, 0);
    
    [self.scrollView setContentOffset:point animated:YES];
    
}

#pragma mark-已下载 按钮点击事件
- (IBAction)alreadyDownLoadButtonClick:(id)sender {
    
    CGPoint point = CGPointMake(self.view.frame.size.width , 0);
    
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
        
        //!点击之后让购买按钮不可用，界面将要出现的时候再让按钮可用
        self.buyDownloadbtn.enabled = NO;
        self.residueBuyDownBtn.enabled = NO;
        
        
        //跳转付费下载
        CSPPayDownloadViewController *payDownLoadView = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayDownloadViewController"];
        [self.navigationController pushViewController:payDownLoadView animated:YES];
    }
}

#pragma mark-编辑
- (IBAction)editButtonClick:(id)sender {
    
    if (_isDisplayBatchDownoad) {//!如果显示的是批量下载,底部的显示同“已下载”的请求
     
        _isBatchDownloadEdit = !_isBatchDownloadEdit;
        
        if (_isBatchDownloadEdit) {
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
            
            [self showBottomView:self.batchEditBottomView];
            
        }else{
            
            [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
            
            [self showBottomView:self.residueDownloadNoBackgroundView];
        }
        
        [self.editButton setImage:nil forState:UIControlStateNormal];
        
        [self.batchDownloadTableView reloadData];
        
        
    }else if (_isDisplayAlreadyDownload) {
        
        _isAlreadyDownloadEdit = !_isAlreadyDownloadEdit;
        
        if (_isAlreadyDownloadEdit) {
            
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
            
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
            
            [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
            
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
 *  显示哪个bottomView
 *
 *  @param view 有4个bottomView
 */
- (void)showBottomView:(UIView *)view{
    
    if (view == self.downloadingDeleteBottomView) {//!正在下载底部的编辑view

        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = NO;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        self.batchEditBottomView.hidden = YES;//!批量下载 --》 编辑 --》底部的view
        
        
        
    }else if (view == self.alreadDownloadButtomView){//!已下载底部的编辑view
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = NO;
        self.buyNoBackgroundView.hidden = YES;
        self.batchEditBottomView.hidden = YES;//!批量下载 --》 编辑 --》底部的view

        
    }else if (view == self.buyNoBackgroundView){//!!!!
        
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = NO;
        self.batchEditBottomView.hidden = YES;//!批量下载 --》 编辑 --》底部的view

        
    }else if (view == self.residueDownloadNoBackgroundView){//!!!!
        
        self.residueDownloadNoBackgroundView.hidden = NO;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        self.batchEditBottomView.hidden = YES;//!批量下载 --》 编辑 --》底部的view
        
        
    }else if (view == self.batchEditBottomView){//!批量下载 底部编辑的view
    
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        self.batchEditBottomView.hidden = NO;//!批量下载 --》 编辑 --》底部的view
        
      

    }else{
        self.residueDownloadNoBackgroundView.hidden = YES;
        self.downloadingDeleteBottomView.hidden = YES;
        self.alreadDownloadButtomView.hidden = YES;
        self.buyNoBackgroundView.hidden = YES;
        self.batchEditBottomView.hidden = YES;//!批量下载 --》 编辑 --》底部的view
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
#pragma mark 批量下载 单个下载按钮
-(void)downLoadOneImageDTO:(CSPDownLoadImageDTO * )downLoadImageDTO withDownLoadType:(NSString *)downloadType{

    
    DownloadImgaeViewDTO *windowDownloadImageViewDTO;
    DownloadImgaeViewDTO *objectDownloadImageViewDTO;
    
    NSMutableArray *zipsArray = downLoadImageDTO.zipsList;//!有两个对象，一个是窗口图，一个是客观图，下载的是一个压缩包
    
    for (CSPZipsDTO *zipsDTO in zipsArray) {
        
        //0:窗口图1:客观图
        if (zipsDTO.picType.integerValue == 0) {
            
            windowDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:0 picSize:zipsDTO.picSize];
            
            
        }else if (zipsDTO.picType.integerValue == 1){
            
            objectDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:1 picSize:zipsDTO.picSize];
            
        }
        
    }
    
    
    //!downType ： 0窗口图、1客观图
    if ([downloadType isEqualToString:@"0"]) {//!窗口图
        
        //下载窗口图
        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:windowDownloadImageViewDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowDownloadImageViewDTO.downloadURL windowFigureItems:windowDownloadImageViewDTO.imageItems pictureUrl:downLoadImageDTO.picListSmall];
        

        
    }else{//!客观图
    

        //下载客观图
        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:objectDownloadImageViewDTO.goodsNo objectiveFigureUrl:objectDownloadImageViewDTO.downloadURL objectiveFigureItems:objectDownloadImageViewDTO.imageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:downLoadImageDTO.picListSmall];
        
    
    }


    [self.view makeMessage:@"已加入下载队列" duration:2.0 position:@"center"];
    

}

#pragma mark 批量下载--》底部全选按钮
- (IBAction)batchSelectAllBtnClick:(id)sender {
    
    //!把所有批量下载的数据变为选中状态后刷新数据
    UIButton * allSelectBtn = (UIButton *)sender;
    allSelectBtn.selected = !allSelectBtn.selected;
    
    
    for (CSPDownLoadImageDTO * downLoadImageDTO in self.batchDownloadList) {
    
        downLoadImageDTO.selectWindow = allSelectBtn.selected;
        downLoadImageDTO.selectObject = allSelectBtn.selected;
    
    }
    
    //!如果全选，则选中的数量 == 数据的数量*2
    if (allSelectBtn.selected) {
        
        self.batchSelectCount = self.batchDownloadList.count * 2;
    
    }else{
        
        self.batchSelectCount = 0;
    }
    
    [_batchDownloadTableView reloadData];
    
    
}

#pragma mark 批量下载--》底部下载按钮
- (IBAction)batchDownAllBtnClick:(id)sender {
    
    //!没有选中下载的商品，就返回
    if (!self.batchSelectCount) {
        
        [self.view makeMessage:@"请选择要下载商品" duration:2.0 position:@"center"];
        
        return ;
    }
    
    NSInteger canDownloadNum = [self selectAllDownload:self.batchSelectCount];//!传入选择的个数,为-1的时候是选择的商品全部都可以下载
    //!可以下载的个数为0 ,return
    if (canDownloadNum == 0) {
        
        return;
    }
    
    int hasDownLoadNum = 0;//!计算加入队列的个数
    for (int i = 0 ;i < self.batchDownloadList.count ; i++) {
        
        CSPDownLoadImageDTO * downLoadImageDTO = self.batchDownloadList[i];
        DownloadImgaeViewDTO *windowDownloadImageViewDTO;
        DownloadImgaeViewDTO *objectDownloadImageViewDTO;
        
        NSMutableArray *zipsArray = downLoadImageDTO.zipsList;//!有两个对象，一个是窗口图，一个是客观图，下载的是一个压缩包
        
        for (CSPZipsDTO *zipsDTO in zipsArray) {
            
            //0:窗口图1:客观图
            if (zipsDTO.picType.integerValue == 0 && downLoadImageDTO.selectWindow) {//!是窗口图 并且选中了
                
                windowDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:0 picSize:zipsDTO.picSize];
                
                [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downLoadImageDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowDownloadImageViewDTO.downloadURL windowFigureItems:windowDownloadImageViewDTO.imageItems pictureUrl:downLoadImageDTO.picListSmall];
                
                hasDownLoadNum = hasDownLoadNum +1;//!加入队列后，计数+1
                
                if (hasDownLoadNum >= canDownloadNum && canDownloadNum!= -1) {
                    
                    break;
                }
                
                
                
            }else if (zipsDTO.picType.integerValue == 1 && downLoadImageDTO.selectObject){//!是客观图 并且选中了
                
                objectDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:1 picSize:zipsDTO.picSize];
                
                [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downLoadImageDTO.goodsNo objectiveFigureUrl:objectDownloadImageViewDTO.downloadURL objectiveFigureItems:objectDownloadImageViewDTO.imageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:downLoadImageDTO.picListSmall];

                hasDownLoadNum = hasDownLoadNum +1;//!加入队列后，计数+1

                if (hasDownLoadNum >= canDownloadNum && canDownloadNum!= -1) {
                    
                    break;
                }
                
            }
            
        }
        
        //!不可以再下载了
        if (hasDownLoadNum >= canDownloadNum && canDownloadNum!= -1) {
            
            break;
        }

        
        
    }
    
    
    [self.view makeMessage:@"已成功添加到下载队列" duration:2.0 position:@"center"];

    
    
    
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
        
        NSInteger canDownloadNum = [self selectAllDownload:self.selectedArray.count];//!传入选择的个数,为-1的时候是选择的商品全部都可以下载
        //!可以下载的个数为0 ,return
        if (canDownloadNum == 0) {
            
            return;
        }else if (canDownloadNum != -1 && canDownloadNum != self.selectedArray.count){//!不是“无限次下载” ，并且可以下载的个数不 = 选择的商品个数
        
            NSArray * tempArray = [self.selectedArray subarrayWithRange:NSMakeRange(0, canDownloadNum)];
            self.selectedArray = [NSMutableArray arrayWithArray:tempArray];
        
        }
        
        
        for (DownloadLogFigure *figure in self.selectedArray) {
            figure.selected = YES;
        }
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
        
        [self.view makeMessage:@"请选择要删除的商品" duration:2.0 position:@"center"];
        
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
        
        //!点击之后让购买按钮不可用，界面将要出现的时候再让按钮可用
        self.buyDownloadbtn.enabled = NO;
        self.residueBuyDownBtn.enabled = NO;
        
        //跳转付费下载
        CSPPayDownloadViewController *payDownLoadView = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayDownloadViewController"];
        [self.navigationController pushViewController:payDownLoadView animated:YES];
    }
}

#pragma mark-权限控制
//!点击单个 现在按钮时候的权限判断
- (BOOL)isDownload{
    
    //判断等于下载次数（下载次数需要考虑选择多个下载的情况） 这里只判断是否有下载次数，不需要判断是否有下载权限
    if (self.getPayMerchantDownload.downloadNum.integerValue!=-1 && self.getPayMerchantDownload.downloadNum.integerValue<self.selectedArray.count) {
        
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

#pragma mark-CSPAuthorityPopViewDelegate
- (void)showLevelRules{
    
    /*
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CSPVIPUpdateViewController *vipVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
    
    [self.navigationController pushViewController:vipVC animated:YES];
    */
    
    SecondaryViewController *secondaryVC = [[SecondaryViewController alloc]init];
    
    secondaryVC.delegate = self;
    
    secondaryVC.file = [HttpManager privilegesNetworkRequestWebView];
    
    [self.navigationController pushViewController:secondaryVC animated:YES];

}
-(void)pushTransactionRecordsVC
{
    TransactionRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];

}




- (void)prepareToUpgradeUserLevel{
    
}

@end
