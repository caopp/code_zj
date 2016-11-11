//
//  CPSGoodsDetailsPreviewViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
/*
 更改了的地方：
 1.根据商品名称的长度修改label cell的高度
 2.点击下载给了提示：在下载中查看
 3.子账号没有查看权限
 4.下载动效（在button上面添加动效，刚开始是停止的动效；点击下载按钮的时候开始动画，结束下载的时候收到结束下载的通知，结束动画；注意：如果本地已经存着相同的照片，那么下载的动画就会短暂）
 
 */

#import "CPSGoodsDetailsPreviewViewController.h"

#import "RefreshControl.h"

#import "CPSGoodsDetailsPreviewTableViewCell.h"

#import "RefreshControl.h"

#import "CPSGoodsDetailsEditStepPriceView.h"

#import "CPSGoodsDetailsEditSkuView.h"

#import "CSPDownloadImageView.h"

#import "CSPDownLoadImageDTO.h"

#import "ZipArchive.h"

#import "GetMerchantNotAuthTipDTO.h"

#import "CSPAuthorityPopView.h"

#import "DownloadLogControl.h"

#import "CSPGoodsListViewController.h"

#import "CSPVIPUpdateViewController.h"
#import "CSPAuthorityTitlePopView.h"
#import "CSPPayDownloadViewController.h"
#import "GUAAlertView.h"//!下载提示框
#import "UIColor+UIColor.h"
#import "MyUserDefault.h"
#import "DEInfiniteTileMarqueeView.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "SegmentView.h"

#import "CSPAttrTableViewCell.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "AttrListDTO.h"
#import "ManageGoodsViewController.h"
#import "CSPMerchantClosedView.h"
#import "SecondaryViewController.h"

#import "TransactionRecordsViewController.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
typedef enum _ObjectStyle {
    ObjectStyleObject,
    ObjectStyleForment,
    ObjectStyleAttr
} ObjectStyle;
//3所有，0窗口图，1客观图
typedef NS_ENUM(NSInteger, DownLoadType) {
    DownLoadAllImage          = 3,
    DownLoadWindow            = 0,
    DownLoadObject            = 1,
};

@interface CPSGoodsDetailsPreviewViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,CSPAuthorityPopViewDelegate,CSPAuthorityTitlePopViewDelegate,SegmentViewDelegate,SecondaryViewControllerDelegate,CSPMerchantClosedViewDelegate>{
    CSPDownloadImageView *downloadImageView ;
}
@property(nonatomic,strong)SegmentView *imgSelectView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UITableView *goodsInfoTableView;

@property(nonatomic,strong)UITableView *imageTableView;

@property(nonatomic,strong)RefreshControl *bottomRefreshControl;

@property(nonatomic,strong)RefreshControl *topRefreshControl;

@property(nonatomic,assign)DownLoadType downLoadType;

@property(nonatomic,strong)GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;

/**
 *  置顶
 */
@property(nonatomic,strong)UIButton *topButton;

@property(nonatomic,strong)NSMutableArray *downloadImageArray;

// !下载动效果
@property (nonatomic ,strong) DEInfiniteTileMarqueeView *infinitTitle;
@property (nonatomic ,strong) UIImageView *downImgView;
@property (nonatomic,assign) NSInteger select_itm;
@property BOOL isStop;

/**
 *  剩余下载次数
 */
@property(nonatomic,assign)NSInteger residueDownload;

/**
 *  如果选择窗口图=1，如果选择客观图=1，如果选择窗口图和客观图=0
 */
@property(nonatomic,assign)NSInteger cancelDownloadCount;


@end

@implementation CPSGoodsDetailsPreviewViewController{
    
    BOOL _sampleFlag;
    
    NSMutableArray *_windowImageArray;
    
    NSMutableArray *_objectiveImageArray;
    
    NSMutableArray *_referImageArray;
    
    NSMutableArray *_attrImageArray;
    
    NSMutableArray *_goodsImageArray;
    
    NSMutableArray *_skuArray;
    
    NSMutableArray *_downLoadUrlArray;
    
    NSMutableArray *_zipsArray;
    
    NSMutableArray *_zipsPathArray;

    // !自定义提示view
    GUAAlertView *alertView;
    
    // !记录下载的按钮
    UIButton *getDownBtn;

    ObjectStyle objectStyle;
    UIButton *downloadBtn;
}
-(void)viewWillDisappear:(BOOL)animated{
    downloadBtn.hidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [self customBackBarButton];
    
    
    [self initArray];
    
    [self initScrollView];
    
    [self initTableView];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
    self.downLoadType = DownLoadAllImage;
    
    //判断是预览还是商品详情
    if (self.isPreview) {
        
        //[self handleData];
        _getGoodsInfoList = [_arrColorItems objectAtIndex:0];
        [self getDataSuccess];
        
    }else{
        
        [self progressHUDShowWithString:@"加载中"];
        
        [self requestGoodsDetailsData];
    }
    
    downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35,30 , 25, 25)];
    downloadBtn.backgroundColor = [UIColor whiteColor];
    downloadBtn.layer.cornerRadius = 12.5f;
    downloadBtn.layer.masksToBounds = YES;
    downloadBtn.hidden = _isPreview;
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateNormal];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateHighlighted];
    [downloadBtn addTarget:self action:@selector(showDownloadViewNotification) forControlEvents:UIControlEventTouchUpInside];
    downloadBtn.hidden = YES;
    [self.navigationController.view addSubview:downloadBtn];

    // !下载完毕发出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endDownloadAni) name:NotificationOfDownloadComplete object:nil];
    
    
}
#pragma mark 下载的动画
-(void)beginDownLoadAni{


    NSLog(@"开始下载");
    self.isStop = NO;// !不停止 开始下载

    [self downAin];
    
    
}
-(void)endDownloadAni{

    NSLog(@"下载完毕");
    
    self.isStop = YES;// !停止下载
    
    [self downAin];


}

-(void)addAni:(UIButton *)downBtn{

    
    //设置图片
    UIImage *topImage = [UIImage imageNamed:@"03_商家商品详情页_下载箭头"];
    
    // 抽出一个类 做循环向下的操作  20是topImage对应图片的大小
    self.infinitTitle = [[DEInfiniteTileMarqueeView alloc] initWithFrame:CGRectMake((downBtn.frame.size.width - 20)/2.0, 0 , 20 , downBtn.frame.size.height )];
    
    
    //添加要滚动的图片
    self.infinitTitle.tileImage = topImage;
    
    //设置时长
    self.infinitTitle.tileDuration = 1.5;
    
    //设置方向 向下
    self.infinitTitle. direction = DEInfiniteTileMarqueeViewDirectionTopToBottom;
    
    [downBtn addSubview:self.infinitTitle];
    
    // 在下面添加一个白色的view遮挡  不然下载的动画就会多出一部分呢
    UIView * shelterView = [[UIView alloc]initWithFrame:CGRectMake(self.infinitTitle.frame.origin.x, downBtn.frame.size.height-(downBtn.frame.size.height -26)/2.0, self.infinitTitle.frame.size.width, (downBtn.frame.size.height -26)/2.0)];
    [shelterView setBackgroundColor:[UIColor whiteColor]];
    [downBtn addSubview:shelterView];
    
//    [downBtn setBackgroundColor:[UIColor grayColor]];
    
    
    // !先不开始动画
    self.isStop = YES;
    self.infinitTitle.hidden = YES;
    
    if (!self.isStop) {
        
        [downBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_下载_下载过程"] forState:UIControlStateNormal];
        
    }

    getDownBtn = downBtn;
    
    
}

- (void)downAin
{
    
    if (self.isStop) {//! yes :停止下载
        
        self.infinitTitle.hidden = YES;
        
        [getDownBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_下载"] forState:UIControlStateNormal];
        //        self.isStop = YES;
        [getDownBtn setEnabled:YES];
        
        
    }else  //no：开始下载
    {
    
        self.infinitTitle.hidden = NO;
        
        [getDownBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_下载_下载过程"] forState:UIControlStateNormal];
        
        //        self.isStop = NO;
        [getDownBtn setEnabled:NO];

        
    }
    
//    self.isStop = !self.isStop;

    
    
}

-(void)dealloc{

    
      // !下载完毕的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationOfDownloadComplete object:nil];

    
    
}

#pragma mark-请求需要下载的图片信息
- (void)requestImageInfo{
    //下载客观图
    //下载类型3所有，0窗口图，1客观图 2:参考图
    //需要判断是否有权限和下载次数
    [self progressHUDShowWithString:@"加载中"];
    
    NSMutableArray *imageListArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *imageInfoDic = [[NSMutableDictionary alloc]init];
    
    [imageInfoDic setValue:self.goodsNo forKey:@"goodsNo"];
    
    [imageInfoDic setValue:@"3" forKey:@"downLoadType"];//3是所有
    
    [imageListArray addObject:imageInfoDic];
    
    [HttpManager sendHttpRequestForGetDownloadImageList:imageListArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                self.residueDownload = ((NSNumber *)[data objectForKey:@"remainCount"]).integerValue;
                
                id list = [data objectForKey:@"list"];
                
                if ([self checkData:list class:[NSArray class]]) {
                    
                    [self.downloadImageArray removeAllObjects];
                    for (NSDictionary *dic in list) {
                        
                        CSPDownLoadImageDTO *downLoadImageDTO = [[CSPDownLoadImageDTO alloc]init];
                        [downLoadImageDTO setDictFrom:dic];
                        id zips = [dic objectForKey:@"zips"];
                    
                        if ([self checkData:zips class:[NSArray class]]) {
                            for (NSDictionary *zipDic in zips) {
                                CSPZipsDTO *zipsDTO = [[CSPZipsDTO alloc]init];
                                [zipsDTO setDictFrom:zipDic];
                                [downLoadImageDTO.zipsList addObject:zipsDTO];
                            }
                        }
                        [self.downloadImageArray addObject:downLoadImageDTO];
                    }
                }
            }
            
            if ([self isConnectWifi]) {
                //下载图片
                [self addDownLoadView];
                
            }else{
                
                if (alertView) {
                    
                    
                    
                    [alertView removeFromSuperview];
                    
                }
                
                
                
                alertView = [GUAAlertView alertViewWithTitle:@"为节省流量，建议开启WiFi后进行下载！" withTitleClor:[UIColor colorWithHexValue:0x007aff alpha:1] message:@"尚未开启wifi，是否继续下载"  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                    
                    
                    
                    //下载图片
                    
                    [self addDownLoadView];
                    
                    
                    
                    
                    
                } dismissAction:^{
                    
                    
                    
                    //开启按钮
                    
                    [self downLoadButtonEnable:YES];
                                        
                }];
                
                
                
                [alertView show];
            }
            
        }else if([[responseDic objectForKey:@"code"]isEqualToString:@"120"]){
            
            [self tipDownloadNoIsnil];
            
        }else{
            [self alertViewWithTitle:@"下载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
}

#pragma mark-CSPAuthorityTitlePopViewDelegate
- (void)actionWhenPopViewDimiss{
    DebugLog(@"关闭");
}

- (void)gotoBuyDownloadTimes{
    DebugLog(@"购买");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPPayDownloadViewController *payDownloadViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayDownloadViewController"];
    
    [self.navigationController pushViewController:payDownloadViewController animated:YES];
}


#pragma mark-请求商品详情
- (void)requestGoodsDetailsData{
    
    [HttpManager sendHttpRequestForGetNewGoodsInfoList:self.goodsNo withIsNotes:_isNotes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"---------->responseDic = %@", responseDic);
        
        [self.progressHUD hide:YES];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            NSMutableArray *arrData = [[NSMutableArray alloc] initWithCapacity:0];
            //判断数据的合法
            if ([self checkData:data class:[NSArray class]]) {
                _arrColorItems = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in data) {
                    GetGoodsInfoListDTO *goodsDto = [[GetGoodsInfoListDTO alloc]init];
                    [goodsDto  setDictFrom:dic];
                    if(goodsDto.goodsStatus.intValue !=3){
                        [_arrColorItems addObject:goodsDto];
                    }
                    [arrData addObject:goodsDto];
                }
                GetGoodsInfoListDTO *goodsDto = [arrData objectAtIndex:0];
                if (goodsDto.goodsStatus.intValue == 3||_arrColorItems.count==0) {
                    
                    self.scrollView.hidden = YES;
                    self.title = @"提示";
                    
                    CSPMerchantClosedView *merchantCloseView = [self instanceMerchantClosedView];
                    //        merchantCloseView.type = MerchantClosedViewTypeGoodsInvalid;
                    CGRect rect = self.view.frame;
                    rect.origin.y -= 60;
                    merchantCloseView.frame = self.view.frame;
                    
                    [merchantCloseView setType:MerchantClosedViewTypeGoodsInvalid];
                    
                    merchantCloseView.delegate = self;
                    
                    [self.view addSubview:merchantCloseView];
                    
//                    UIAlertView *alertViewlog = [[UIAlertView alloc] initWithTitle:@"商品已下架" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    alertViewlog.tag = 101;
//                    [alertViewlog show];
                    return ;
                }
                self.getGoodsInfoList = nil;
                
                self.getGoodsInfoList = [[GetGoodsInfoListDTO alloc]init];
                self.getGoodsInfoList = [_arrColorItems objectAtIndex:0];
                //[self.getGoodsInfoList setDictFrom:data];
                
            }else if([self checkData:data class:[NSDictionary class]]){
                _arrColorItems = [[NSMutableArray alloc] initWithCapacity:0];
                    GetGoodsInfoListDTO *goodsDto = [[GetGoodsInfoListDTO alloc]init];
                    [goodsDto  setDictFrom:data];
                    if(goodsDto.goodsStatus.intValue !=3){
                        [_arrColorItems addObject:goodsDto];
                    }
                if (_arrColorItems.count == 0) {
                    
                    self.scrollView.hidden = YES;
                    self.title = @"提示";
                    
                    CSPMerchantClosedView *merchantCloseView = [self instanceMerchantClosedView];
                    //        merchantCloseView.type = MerchantClosedViewTypeGoodsInvalid;
                    CGRect rect = self.view.frame;
                    rect.origin.y -= 60;
                    merchantCloseView.frame = self.view.frame;
                    
                    [merchantCloseView setType:MerchantClosedViewTypeGoodsInvalid];
                    
                    merchantCloseView.delegate = self;
                    
                    [self.view addSubview:merchantCloseView];
//                    UIAlertView *alertViewlog = [[UIAlertView alloc] initWithTitle:@"商品已下架" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    alertViewlog.tag = 101;
//                    [alertViewlog show];
                    return ;
                }
                self.getGoodsInfoList = nil;
                
                self.getGoodsInfoList = [[GetGoodsInfoListDTO alloc]init];
                self.getGoodsInfoList = [_arrColorItems objectAtIndex:0];
            }
            [self getDataSuccess];
           
            
        }else{
            
            [self alertViewWithTitle:@"商品详情加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tipRequestFailureWithErrorCode:error.code];
        
        
        
    }];
}
-(void)getDataSuccess{
    [self handleData];
    objectStyle = ObjectStyleObject;
    [self objectiveState:ObjectStyleObject];
    [self.goodsInfoTableView reloadData];
    [self.imageTableView reloadData];
}
#pragma mark-提示下载次数为空
- (void)tipDownloadNoIsnil{
    
    CSPAuthorityTitlePopView *authorityTitlePopView = [[[NSBundle mainBundle]loadNibNamed:@"CSPAuthorityTitlePopView" owner:self options:nil]firstObject];
    
    authorityTitlePopView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    authorityTitlePopView.delegate = self;
    authorityTitlePopView.buyTimesButton.hidden = NO;
    [authorityTitlePopView showAuthorityTitlePopViewWithBuyTimesButtonBlock:^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CSPPayDownloadViewController *payDownloadViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayDownloadViewController"];
        
        [self.navigationController pushViewController:payDownloadViewController animated:YES];
        
    }];
    
    [self.view addSubview:authorityTitlePopView];
}

#pragma mark-提示无权限下载
- (void)tipDownloadNoAuthority{
    
    CSPAuthorityPopView *authPopView = [[[NSBundle mainBundle]loadNibNamed:@"CSPAuthorityPopView" owner:self options:nil]firstObject];
    
    authPopView.displayAutoGradeLabel.text = @"下载权限等级:";
    
    authPopView.tipLackIntegralLabel.text = @"营业积分还差:";
    
    authPopView.delegate = self;
    
    authPopView.frame = self.view.bounds;
    
    [authPopView setGoodsNotLevelTipDTO:self.getMerchantNotAuthTipDTO];
    
    [self.view addSubview:authPopView];
}
- (void)handleData{
    
    [self handleSku];
    
    if ([self.getGoodsInfoList.sampleFlag isEqualToString:@"1"]) {
        
        _sampleFlag = YES;
        
    }else{
        _sampleFlag = NO;
    }
    
    [self getGoodsImages];
}

#pragma mark-处理尺码数据
- (void)handleSku{
    _skuArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (SkuDTO *skuDto in self.getGoodsInfoList.skuDTOList) {
            
        if ([skuDto.showStockFlag isEqualToString:@"1"]) {
            
            [_skuArray addObject:skuDto];
        }
    }
}

- (void)initArray{
    
    _objectiveImageArray = [[NSMutableArray alloc]init];
    
    _windowImageArray = [[NSMutableArray alloc]init];
    
    _referImageArray = [[NSMutableArray alloc]init];
    
    _skuArray = [[NSMutableArray alloc]init];
    
    self.downloadImageArray = [[NSMutableArray alloc]init];
    
    _downLoadUrlArray = [[NSMutableArray alloc]init];
    
    _zipsArray = [[NSMutableArray alloc]init];
    
    _zipsPathArray = [[NSMutableArray alloc]init];
}

/**
 *  获取商品窗口图、客观图、参考图
 */
- (void)getGoodsImages{
    
    NSMutableArray *referArray = [self.getGoodsInfoList getReferImage:self.getGoodsInfoList.referImageList];
    
    for (NSString *imageURL in referArray) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.view addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                [_referImageArray addObject:image];
                
            }
            
            if (_referImageArray.count == referArray.count) {
                
               // [self.imageTableView reloadData];
            }
        }];
    }
    
      [_imgSelectView.reftBtn setTitle:[NSString stringWithFormat:@"参考图(%ld)",referArray.count] forState:UIControlStateNormal];
    //默认是客观图
    _goodsImageArray = _objectiveImageArray;
    
    NSMutableArray *objectiveArray = [self.getGoodsInfoList getObjectiveImage:self.getGoodsInfoList.objectiveImageList];
    
    for (NSString *imageURL in objectiveArray) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.view addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                [_objectiveImageArray addObject:image];
            }
            
            if (_objectiveImageArray.count == objectiveArray.count) {
                
                [self.imageTableView reloadData];
            }
        }];
    }
    
    NSMutableArray *windowArray = [self.getGoodsInfoList getWindowImage:self.getGoodsInfoList.windowImageList];
    
    for (NSString *imageURL in windowArray) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.view addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                [_windowImageArray addObject:image];

            }
            
            
            if (_windowImageArray.count == windowArray.count) {
                
                [self.goodsInfoTableView reloadData];
                
            }
        }];
    }
    
  
    if (!_goodsImageArray.count) {
        [self.imageTableView reloadData];
    }
    _attrImageArray= [[NSMutableArray alloc] initWithCapacity:0];
    for (AttrListDTO *attDto in  _getGoodsInfoList.attrList) {
        if (attDto.attrValText.length >0) {
             [_attrImageArray addObject:attDto];
        }
        
    }
   
  
}

- (void)initScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)initTableView{
    
    self.goodsInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    self.goodsInfoTableView.delegate = self;
    
    self.goodsInfoTableView.dataSource = self;
    
    [self.scrollView addSubview:self.goodsInfoTableView];
    
    //添加上拉
    self.bottomRefreshControl = [[RefreshControl alloc] initWithScrollView:self.goodsInfoTableView delegate:self];
    
    [self.bottomRefreshControl setBottomEnabled:YES];
    
    [self.bottomRefreshControl setTopEnabled:NO];
    
    _imgSelectView= [[SegmentView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height , self.scrollView.frame.size.width, 30)];
    _imgSelectView.delegate = self;
    
    self.imageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height+30, self.scrollView.frame.size.width, self.scrollView.frame.size.height-30) style:UITableViewStyleGrouped];
    
    self.imageTableView.delegate = self;
    
    self.imageTableView.dataSource = self;
    
    self.imageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.imageTableView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.imageTableView];
    [self.scrollView addSubview:self.imgSelectView];
    //添加下拉
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:self.imageTableView delegate:self];
    
    [self.topRefreshControl setTopEnabled:YES];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.topButton setBackgroundImage:[UIImage imageNamed:@"04_商家中心_设置店铺置顶可点击状态"] forState:UIControlStateNormal];
    
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.topButton.frame = CGRectMake(self.view.frame.size.width-25-35,self.scrollView.frame.size.height*2-25-35, 35, 35);
    
    [self.scrollView addSubview:self.topButton];
}

- (CSPMerchantClosedView *)instanceMerchantClosedView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantClosedView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)topButtonClick:(UIButton *)sender{
    
    //结束加载
    [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
    //下拉
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.goodsInfoTableView.contentOffset = CGPointMake(0, 0);
        
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)colorChange:(UIButton *)sender {
    [self initArray];

    for (int i = 0; i <_arrColorItems.count; i++) {
        UIButton *obj = [_goodsInfoTableView viewWithTag:i+1+1000];
        if ((i+1+1000) ==sender.tag) {
            _select_itm  = i;
            UIImage *img= [UIImage imageNamed:@"color_normal"];
            img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            obj.backgroundColor = [UIColor whiteColor];
            [obj setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
            [obj setBackgroundImage:img forState:UIControlStateNormal];
        }else{
            obj.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [obj setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            [obj setBackgroundImage:nil forState:UIControlStateNormal];
        }

    }
    _getGoodsInfoList = [_arrColorItems objectAtIndex:sender.tag - 1-1000];
    [self objectiveImgBtnClicked:nil ];
    [self getDataSuccess];
       NSString *totalStr = [NSString stringWithFormat:@"%zi",sender.tag];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:totalStr,@"colorTag", nil];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self tabbarHidden:YES];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);

    self.goodsInfoTableView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.imageTableView.frame = CGRectMake(0, self.scrollView.frame.size.height+30, self.scrollView.frame.size.width, self.scrollView.frame.size.height-30);
    
    self.topButton.frame = CGRectMake(self.view.frame.size.width-25-35,self.scrollView.frame.size.height*2-25-35, 35, 35);
    self.imgSelectView.frame = CGRectMake(0, self.scrollView.frame.size.height , self.scrollView.frame.size.width, 30);
}
#pragma mark - CSPMerchantClosedViewDelegate 
-(void)backSubViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//!批发_在售:1； 零售_在售：2； 新发布:3； 全部_在售：4；
-(void)reviewGoodsList{
    
    ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
    
    //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
   //!全部_在售、新发布 的时候， 看 全部_在售
        
    managerGoodsVC.type = @"-1";
        
    managerGoodsVC.isIntoUndercarriage = YES;
    
    [self.navigationController pushViewController:managerGoodsVC animated:YES];
}
-(void)reviewOtherList{
    ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
    
    //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
    //!全部_在售、新发布 的时候， 看 全部_在售
    
    managerGoodsVC.type = @"-1";
    
    
    
    [self.navigationController pushViewController:managerGoodsVC animated:YES];
    
}
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.goodsInfoTableView) {
        return 1;
        
    }else{
        
        if (_goodsImageArray == _referImageArray||_goodsImageArray == _attrImageArray) {
            
            if (_goodsImageArray.count) {
                
                return _goodsImageArray.count;
            }else{
                
                return 1;
            }
            
        }else if (_goodsImageArray == _objectiveImageArray){
            
            return _goodsImageArray.count+1;// !添加一个“客观图按钮”，一个商品描述


        }
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.goodsInfoTableView) {
        
        if (_sampleFlag) {
            //有发版价
            return 7;
            
        }else{
            //无发版价
            return 6;
        }
    }else{
        
        return 1;
    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPSGoodsDetailsPreviewTableViewCell *cell;
    
    if (self.goodsInfoTableView == tableView) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            
            NSInteger windowImageNum = 0;
            
            windowImageNum = self.getGoodsInfoList.windowImageList.count;
            
            cell.goodsPageControl.numberOfPages = windowImageNum;
            
            if (windowImageNum <= 1) {
                cell.goodsPageControl.hidden = YES;
            }
            
            cell.goodsScrollView.contentSize = CGSizeMake(self.view.frame.size.width*windowImageNum, self.view.frame.size.width);
            
            for (int i = 0; i<windowImageNum; i++) {
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width)];
                
                if (_windowImageArray.count>i) {
                    
                    imageView.image = [_windowImageArray objectAtIndex:i];
                }
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                [cell.goodsScrollView addSubview:imageView];
            }
            
            // !0主账号 1子账号
            NSString * isMaster = [MyUserDefault JudgeUserAccount];
            
            
            //判断需不需要下载按钮(如果是预览 或者是子账号查看，就不显示下载按钮)
            if (self.isPreview ||  [isMaster isEqualToString:@"1"]) {
                
                cell.downLoadButton.hidden = YES;
                
            }else{
                cell.downLoadButton.hidden = NO;
                
                
            }
            
            if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount])
            {
                cell.priceLabel.hidden = YES;
            }else{
                cell.priceLabel.hidden = NO;
            }
            //!给button添加动画
            [self addAni:cell.downLoadButton];
            
            
            cell.downLoadButtonBlock = ^(){
                
                DebugLog(@"下载图片");
                
                if (self.getGoodsInfoList.downloadAuth.integerValue) {
                    //有权限
                    
                    //还需要判断是否有下载次数
                    [self requestImageInfo];
                    
                    
                }else{
                    
                    //无权限
                    [self downloadAuth];
                }
                
            };
          
            cell.goodsNameLabel.text = _getGoodsInfoList.goodsName?[NSString stringWithFormat:@"%@\n",_getGoodsInfoList.goodsName]:@"";
            
            
//            //价格
            NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//
//            
//            float hightFloat = 0.0f;
//            //获取最高价格
//            for (StepDTO *stepDto in self.getGoodsInfoList.stepDTOList) {
//                if ([stepDto.price floatValue] > hightFloat) {
//                    hightFloat = [stepDto.price floatValue];
//                }
//            }
//            NSNumber *strPrice;
//            for (VIPPriceDTO *vipDto in _getGoodsInfoList.vipPriceList) {
//                if ([vipDto.level intValue] == 6) {
//                    strPrice = vipDto.amount ;
//                }
//            }
            NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[self transformationData:_getGoodsInfoList.price6] attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont fontWithName:@"Tw Cen MT" size:35]}];
            
            [prefix appendAttributedString:price];
            
            cell.priceLabel.attributedText = prefix;
            
            
        }else if (indexPath.row == 1){
             NSInteger colorListCount = _arrColorItems.count;
            for (int i =0; i<9; i++) {
                 UIButton *obj = [cell viewWithTag:i+1+1000];
                if (i<colorListCount) {
                    [obj setHidden:NO];
                    GetGoodsInfoListDTO *goodsInfoDetails = [_arrColorItems objectAtIndex:i];
                    [obj setTitle:goodsInfoDetails.color forState:UIControlStateNormal];
                    if (i == _select_itm) {
                        UIImage *img= [UIImage imageNamed:@"color_normal"];
                        img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
                        obj.backgroundColor = [UIColor whiteColor];
                        [obj setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
                        [obj setBackgroundImage:img forState:UIControlStateNormal];
                    }
                    [obj addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [obj setHidden:YES];
                }

            }
        }else if (indexPath.row == 2){
            

            //尺码
            //计算有多少列
            NSInteger law = 0;
            
            for (int i = 0; i<_skuArray.count; i++) {
                
                if (self.view.frame.size.width - (15+(60+12)*i+60)<15) {
                    
                    law = i;
                    break;
                }
            }
            
            //如果law = 0说明只有一行
            if (law == 0) {
                
                for (int i = 0; i<_skuArray.count; i++) {
                    
                    SkuDTO *skuDto = [_skuArray objectAtIndex:i];
                    
                    CPSGoodsDetailsEditSkuView *goodsDetailsEditSkuView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsEditSkuView" owner:self options:nil]firstObject];
                    
                    goodsDetailsEditSkuView.skuNameLabel.text = skuDto.skuName;
                    
                    goodsDetailsEditSkuView.frame = CGRectMake(15+(goodsDetailsEditSkuView.frame.size.width+12)*i, 10, goodsDetailsEditSkuView.frame.size.width, goodsDetailsEditSkuView.frame.size.height);
                    
                    [cell addSubview:goodsDetailsEditSkuView];
                }
                
            }else{
                
                //如果law不等于0,说明有多行
                for (int i = 0; i<_skuArray.count; i++) {
                    
                    SkuDTO *skuDto = [_skuArray objectAtIndex:i];
                    
                    CPSGoodsDetailsEditSkuView *goodsDetailsEditSkuView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsEditSkuView" owner:self options:nil]firstObject];
                    
                    goodsDetailsEditSkuView.skuNameLabel.text = skuDto.skuName;
                    
                    goodsDetailsEditSkuView.frame = CGRectMake(15+(NSInteger)(goodsDetailsEditSkuView.frame.size.width+12)*(i%law), 10+(NSInteger)(goodsDetailsEditSkuView.frame.size.height+15)*(i/law), goodsDetailsEditSkuView.frame.size.width, goodsDetailsEditSkuView.frame.size.height);
                    
                    [cell addSubview:goodsDetailsEditSkuView];
                    
                }
            }
            
        }else if (indexPath.row == 3){
            //起批量
            cell.batchNumLimitLabel.text = [NSString stringWithFormat:@"%@起批量：%@ 件",self.getGoodsInfoList.color,[self transformationData:self.getGoodsInfoList.batchNumLimit]];
            
        }else if (indexPath.row == 4){
            
            if (_sampleFlag) {
                
                //发版价
               // cell.sampleTitleColor.text = @"lalalalla";//[NSString stringWithFormat:@"%@样板价",_getGoodsInfoList.color];
                //cell.samplePriceLabel.text
                NSString *strPrice = [NSString stringWithFormat:@"%@样板价:￥%@",_getGoodsInfoList.color,[self transformationData:self.getGoodsInfoList.samplePrice]];
                
                cell.samplePriceLabel.attributedText= [cell createStringWithString:strPrice withRange:NSMakeRange(_getGoodsInfoList.color.length+4, (strPrice.length - _getGoodsInfoList.color.length-4))]
                ;
                NSLog(@"%ld---%ld",_getGoodsInfoList.color.length+4,(strPrice.length - _getGoodsInfoList.color.length-4));
            }else{
           
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:6];
                
                cell.merchantNameLabel.text = self.getGoodsInfoList.merchantName;
                cell.limtMsgLabel.text =self.getGoodsInfoList.batchMsg;
            }

            
        }else if (indexPath.row == 5){
           
            
            if (_sampleFlag) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:6];
                
                cell.merchantNameLabel.text = self.getGoodsInfoList.merchantName;
                cell.limtMsgLabel.text = self.getGoodsInfoList.batchMsg;

                
            }else{
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:7];
                
                
            }
            
            
        }else if (indexPath.row == 6){
            
           
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:7];
        
            
        }else if (indexPath.row == 7){
            
      
        }
        
    }else{
        
        
            
        if (_goodsImageArray == _objectiveImageArray) {// !客观图
            
            
            
            // !商品详情  第1段
            if (indexPath.section == 0) {
                
                
                //!自己写的cell
                CPSGoodsDeatilsCell *   cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDeatilsCell" owner:self options:nil]objectAtIndex:0];
                
                //                    cell.merchantNameLabel.text = self.getGoodsInfoList.details;
                cell.goodsDetailLabel.text = self.getGoodsInfoList.details;
                //                    cell.detailLabel.text = self.getGoodsInfoList.details;
                
                return cell;
                
                
            }
            
            // !商品图片
            // !每段是一行 改~~~~~
            if (_goodsImageArray.count>indexPath.section-1) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"goodsImgaeViewCellID"];
                
                if (!cell) {
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:9];
                }
                
                cell.goodsImageView.image = [_goodsImageArray objectAtIndex:indexPath.section-1];
                
                
            }
            
            
        }else if (_goodsImageArray == _referImageArray){// !参考图
            
            if (_goodsImageArray.count) {// !如果有参考图
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"goodsImgaeViewCellID"];
                
                if (!cell) {
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:9];
                }
                
                if (_goodsImageArray.count>indexPath.section) {
                    
                    cell.goodsImageView.image = [_goodsImageArray objectAtIndex:indexPath.section];
                    
                    
                }
                
            }else{// !如果没有参考图
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"tipNogoodsImgaeViewCellID"];
                
                if (!cell) {
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:10];
                }
                
            }
            
        }else if(_goodsImageArray == _attrImageArray){
            if (_attrImageArray.count) {
                CSPAttrTableViewCell *attrCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAttrTableViewCell"];
                if (!attrCell)
                {
                    [tableView registerNib:[UINib nibWithNibName:@"CSPAttrTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPAttrTableViewCell"];
                    attrCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAttrTableViewCell"];
                }
                AttrListDTO *attrListDTO = [_goodsImageArray objectAtIndex:indexPath.section];
                attrCell.titleLabel.text = attrListDTO.attrName;
                attrCell.valueLabel.text = attrListDTO.attrValText;
                // attrCell.imagesArr = [self getWindowsImageURLs];
                
                return attrCell;
            }else{
                static NSString *cellId = @"TitleZoneGoodsTableViewCell";
                TitleZoneGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[TitleZoneGoodsTableViewCell alloc] init];
                    
                }
                cell.titleLabel.text = @"商家暂未填写商品规格参数";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                self.view.backgroundColor = [UIColor whiteColor];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                return cell;

            }
       
            
        }

       
    }
   

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [downloadImageView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.goodsInfoTableView == tableView) {
        
        if (_sampleFlag) {
            
            if (indexPath.row == 7) {
                
                //结束加载
                [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
                
                //下拉
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
                
            }else if (indexPath.row == 6){
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CSPGoodsListViewController* goodsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsListViewController"];
                
                [self.navigationController pushViewController:goodsListViewController animated:YES];
            }else if (indexPath.row == 5){// !商家详情 返回上一个界面即可
                if (_isPreview||_noGoodsListView||_isNotes) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CSPGoodsListViewController* goodsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsListViewController"];
                    
                    [self.navigationController pushViewController:goodsListViewController animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }

            
        }else{
            
            if (indexPath.row == 6) {
                
                //结束加载
                [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
                
                
                //下拉
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                }];
            }else if(indexPath.row == 4){
                if (_isPreview||_noGoodsListView||_isNotes) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CSPGoodsListViewController* goodsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsListViewController"];
                    
                    [self.navigationController pushViewController:goodsListViewController animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }
    }else{
        NSLog(@"==%ld",indexPath.section);
//        if (indexPath.section ==0) {
//            return;
//        }
        if (_goodsImageArray == _objectiveImageArray&&indexPath.section ==0) {
            return;
        }
        if (objectStyle !=ObjectStyleAttr) {
            [self tapImageWithIndex:indexPath];
        }
        
        
    }
    
}
-(CGFloat)goodNameSize{

   
    CGSize size = [self.getGoodsInfoList.goodsName boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;

    return size.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.goodsInfoTableView == tableView) {
        
        if (indexPath.row == 0) {
            
//            NSInteger stepPriceRow = 0;
//            
//            if (self.getGoodsInfoList.stepDTOList.count%3 == 0) {
//                stepPriceRow = self.getGoodsInfoList.stepDTOList.count/3;
//            }else{
//                stepPriceRow = self.getGoodsInfoList.stepDTOList.count/3+1;
//            }
//            
            
            // 34是xib上面商品名称的label高度

           return   156 - 34+ [self goodNameSize]+self.view.frame.size.width;
            

//            return stepPriceRow*30+156+self.view.frame.size.width;
            
            
            
        }else if (indexPath.row == 1){
            
            return 30;
            
        }else if (indexPath.row == 2){
            
            //尺寸
            //计算有多少列
            NSInteger law = 0;
            
            NSInteger skuRowNum = 0;
            
            for (int i = 0; i<_skuArray.count; i++) {
                
                if (self.view.frame.size.width - (15+(60+12)*i+60)<15) {
                    
                    law = i;
                    break;
                }
            }
            
            if (law == 0) {
                
                return 51;
                
            }else{
                
                if (_skuArray.count%law == 0) {
                    
                    skuRowNum = _skuArray.count/law;
                    
                }else{
                    
                    skuRowNum = _skuArray.count/law+1;
                }
            }
            
            return 10+skuRowNum*(28+15);

            
        }else if (indexPath.row == 3){
            
            return 50;
            
        }else if (indexPath.row == 4){
            
            if (_sampleFlag) {
                return 50;
            }else{
                return 64;
            }
            
        }else if (indexPath.row == 5){
            
            return 64;
            
        }else if (indexPath.row == 6){
            
            if (_sampleFlag) {
                return 64;
            }else{
                return 42;
            }
            
        }else if (indexPath.row == 7){
            return 42;
        }
        
    }else{// !客观图  参考图 的tableview
        if (_goodsImageArray == _objectiveImageArray && indexPath.section == 0){// !客观图中的描述
        
            // !计算商品描述的高度
                
            if ([self.getGoodsInfoList.details isEqualToString:@""] || self.getGoodsInfoList.details==nil || self.getGoodsInfoList == NULL) {
                
                return 0;
                
            }else{
                
                CGSize detailSize = [self.getGoodsInfoList.details boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                
                
                return detailSize.height + 25 +80;
                
            }
            
            
        
        
        }else if(_goodsImageArray == _attrImageArray){
            if (_goodsImageArray.count) {
                return 40;
            }else{
                return self.view.frame.size.height;
            }
            
       
        }else{
            
            if (_goodsImageArray.count) {// !有客观图 参考图的时候 根据比例计算高度
                
                //image的高度
                CGFloat wight = self.view.frame.size.width;
                
                CGFloat height = 172;
                
                UIImage *image;
                
                if (_goodsImageArray == _objectiveImageArray && _goodsImageArray.count>indexPath.section-1) {
                    // !客观图
                    
                    
                    image = (UIImage *)[_goodsImageArray objectAtIndex:indexPath.section-1];

                    CGFloat scale;
                    
                    scale = image.size.width*1.0/wight;
                    
                    height = image.size.height*1.0/scale;// !根据比例 得到图片的实际高度
                    

                }else if (_goodsImageArray == _referImageArray && _goodsImageArray.count>indexPath.section){// !参考图
                
                    image = (UIImage *)[_goodsImageArray objectAtIndex:indexPath.section];
                    
                    CGFloat scale;
                    
                    scale = image.size.width*1.0/wight;
                    
                    height = image.size.height*1.0/scale;// !根据比例 得到图片的实际高度
                    

                }else{
                    return 40;
                }
                
            
                
                return height;
                
                
                
            }else{//!没有图的时候
                
                if (_goodsImageArray == _referImageArray) {//!没有的图是参考图
                    
                    return 196;
                }
                
            }
            
            
            
            
            
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.goodsInfoTableView == tableView) {
        return 0;
    }else{
       if(_goodsImageArray == _attrImageArray){
            return 2.5;
            
        }
        if (section == 0){
            return 20;
        }else if (section == 1){
            return 15;
        }else{
            return 2.5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.goodsInfoTableView == tableView) {
        return 0;
    }else{
        return 0.01;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath



{
    
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        if (indexPath.row == 1||indexPath.row == 0) {
            [cell setSeparatorInset: UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
        }else {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        
        
        
        
    }
    
    
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        
        
    }
    
}
#pragma mark - SegmentViewDelegate
- (void)objectiveImgBtnClicked:(id)sender {
    objectStyle = ObjectStyleObject;
    _goodsImageArray = _objectiveImageArray;
    [self objectiveState:ObjectStyleObject];
    [self.imageTableView reloadData];
    

}

- (void)referenceImgBtnClicked:(id)sender {
    objectStyle = ObjectStyleForment;
    _goodsImageArray = _referImageArray;
    [self objectiveState:ObjectStyleForment];

    [self.imageTableView reloadData];
}
-(void)attrBtnClicked:(id)sender{
    objectStyle = ObjectStyleAttr;
    _goodsImageArray = _attrImageArray;
    [self objectiveState:ObjectStyleAttr];
    
    [self.imageTableView reloadData];
}

- (void)objectiveState:(ObjectStyle)objective{
    switch (objective) {
        case ObjectStyleObject:
        {
            _imgSelectView.objectBtn.backgroundColor = [UIColor whiteColor];
            [_imgSelectView.objectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _imgSelectView.reftBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.reftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            ;
            [_imgSelectView.attrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case ObjectStyleForment:
        {
            _imgSelectView.objectBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.objectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _imgSelectView.reftBtn.backgroundColor = [UIColor whiteColor];
            [_imgSelectView.reftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            ;
            [_imgSelectView.attrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case ObjectStyleAttr:
        {
            _imgSelectView.objectBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.objectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _imgSelectView.reftBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
;
            [_imgSelectView.reftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor whiteColor];
            ;
            [_imgSelectView.attrBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    

}
#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop){
        
        DebugLog(@"下拉");
        
        //结束加载
        [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];

        
        //上拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    CGRect rect = downloadBtn.frame;
                    rect.origin.y = 80;
                    [downloadBtn setFrame:rect];
                    downloadBtn.hidden = YES;
                    
                } completion:nil];
            });
        } completion:^(BOOL finished) {
            
                    }];
        
    }else if (direction == RefreshDirectionBottom){
        
        DebugLog(@"上拉");
        
        //结束加载
        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];

        
        //下拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    CGRect rect = downloadBtn.frame;
                    rect.origin.y = 30;
                    [downloadBtn setFrame:rect];
                    downloadBtn.hidden = _isPreview?YES:NO;
                    
                } completion:nil];
            });

            
            self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)_alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_alertView.tag == 101) {
        [self.navigationController  popViewControllerAnimated:YES];
    }else{
        if (buttonIndex) {
            
            //下载图片
            [self addDownLoadView];
            
        }else{
            
            //开启按钮
            [self downLoadButtonEnable:YES];
        }
    }
   
    
}
#pragma mark - 添加 大图
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [self tapImgBk:(UIImageView *)tap.view withindex:tap.view.tag withArray:_windowImageArray];
}
-(void)tapImageWithIndex:(NSIndexPath *)index{
    CPSGoodsDetailsPreviewTableViewCell *cell = [_imageTableView cellForRowAtIndexPath:index];
    if (_goodsImageArray == _objectiveImageArray) {
        [self tapImgBk:cell.goodsImageView withindex:index.section-1 withArray:_goodsImageArray];
    }else{
        [self tapImgBk:cell.goodsImageView withindex:index.section withArray:_goodsImageArray];
    }
    
}
-(void)tapImgBk:(UIImageView *)srcview withindex:(NSInteger)index withArray:(NSMutableArray *)objectiveArray{
    [downloadImageView removeFromSuperview];

    int count = (int )objectiveArray.count;
    
    
    if (objectiveArray.count==0) {
        return;
    }
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        //NSString *urlstr = [objectiveArray objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        //photo.url = [NSURL URLWithString:urlstr];
        photo.image = [objectiveArray objectAtIndex:i]; // 图片路径
        photo.srcImageView = srcview; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark down
-(void)showDownloadViewNotification{
    
    if (self.getGoodsInfoList.downloadAuth.integerValue) {
        //有权限
        
        //还需要判断是否有下载次数
        [self requestImageInfo];
        
        
    }else{
        
        //无权限
        [self downloadAuth];
    }
}
#pragma mark-判断下载权限
- (void)downloadAuth{
    //开启按钮
    [self downLoadButtonEnable:YES];
    
    [self progressHUDShowWithString:@"获取下载权限"];
    
    [HttpManager sendHttpRequestForGetMerchantNotAuthTip:@"3" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                if (!self.getMerchantNotAuthTipDTO) {
                    
                    self.getMerchantNotAuthTipDTO = [[GetMerchantNotAuthTipDTO alloc]init];
                    
                }
                    
                [self.getMerchantNotAuthTipDTO setDictFrom:data];
                
            }
            
            
            //等级提示
            CSPAuthorityPopView *authPopView = [[[NSBundle mainBundle]loadNibNamed:@"CSPAuthorityPopView" owner:self options:nil]firstObject];
            
            authPopView.displayAutoGradeLabel.text = @"下载权限等级:";
            
            authPopView.tipLackIntegralLabel.text = @"营业积分还差:";

            authPopView.delegate = self;
            
            authPopView.frame = self.view.bounds;
            
            [authPopView setGoodsNotLevelTipDTO:self.getMerchantNotAuthTipDTO];
            
            [self.view addSubview:authPopView];
        
        }else{
            
            [self alertViewWithTitle:@"下载失败" message:[responseDic objectForKey:ERRORMESSAGE]];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
    
}

#pragma mark-添加下载图片
- (void)addDownLoadView{
    if (self.downloadImageArray.count) {
        //self.downloadImageArray.count肯定是1
        CSPDownLoadImageDTO *downLoadImageDTO = [self.downloadImageArray objectAtIndex:0];
        
        DownloadImgaeViewDTO *windowDownloadImageViewDTO;
        DownloadImgaeViewDTO *objectDownloadImageViewDTO;
        
        NSMutableArray *zipsArray = downLoadImageDTO.zipsList;//!有两个对象，一个是窗口图，一个是客观图，下载的是一个压缩包
        
        for (CSPZipsDTO *zipsDTO in zipsArray) {
            
            if (zipsDTO.picType.integerValue == DownLoadWindow) {
                
                windowDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:DownLoadWindow picSize:zipsDTO.picSize];
                
                
            }else if (zipsDTO.picType.integerValue == DownLoadObject){
                
                objectDownloadImageViewDTO = [[DownloadImgaeViewDTO alloc]initWithGoodsNo:downLoadImageDTO.goodsNo downloadURL:zipsDTO.zipUrl imageItems:zipsDTO.qty imageType:DownLoadObject picSize:zipsDTO.picSize];
                
            }
            
        }
        
        downloadImageView = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownloadImageView" owner:self options:nil]firstObject];
        
        [downloadImageView showDownloadImageViewWithWindownDownloadImageViewDTO:windowDownloadImageViewDTO ObjectDownloadImageViewDTO:objectDownloadImageViewDTO downloadBlock:^{
            
            if (downloadImageView.selectedWindownImageButton.selected && downloadImageView.selectedObjectImgaeButton.selected) {
                
                self.cancelDownloadCount = 0;
                
                if ([self isCanDownload]) {
                    
                    //下载全部
                    [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:windowDownloadImageViewDTO.goodsNo objectiveFigureUrl:objectDownloadImageViewDTO.downloadURL objectiveFigureItems:objectDownloadImageViewDTO.imageItems windowFigureUrl:windowDownloadImageViewDTO.downloadURL windowFigureItems:windowDownloadImageViewDTO.imageItems pictureUrl:self.getGoodsInfoList.defaultPicUrl];
                    
                    [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];
//                    [self progressHUDHiddenTipSuccessWithString:@"已成功添加到下载队列"];
                    
                }else{
                    
                    [self tipDownloadNoIsnil];
                }
                
            }else if (downloadImageView.selectedWindownImageButton.selected){
                
                self.cancelDownloadCount = 1;
                
                if ([self isCanDownload]) {
                    
                    //下载窗口图
                    [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:windowDownloadImageViewDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowDownloadImageViewDTO.downloadURL windowFigureItems:windowDownloadImageViewDTO.imageItems pictureUrl:self.getGoodsInfoList.defaultPicUrl];
                    
                    [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];

//                    [self progressHUDHiddenTipSuccessWithString:@"已成功添加到下载队列"];
                    
                }else{
                    [self tipDownloadNoIsnil];
                    
                }
                
            }else if (downloadImageView.selectedObjectImgaeButton.selected){
                
                self.cancelDownloadCount = 1;
                
                if ([self isCanDownload]) {
                    
                    //下载客观图
                    [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:objectDownloadImageViewDTO.goodsNo objectiveFigureUrl:objectDownloadImageViewDTO.downloadURL objectiveFigureItems:objectDownloadImageViewDTO.imageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:self.getGoodsInfoList.defaultPicUrl];
                    
                    [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];

//                    [self progressHUDHiddenTipSuccessWithString:@"已成功添加到下载队列"];
                    
                }else{
                    [self tipDownloadNoIsnil];
                    
                }
                
            }else{
                [self downLoadButtonEnable:YES];
                [self progressHUDTipWithString:@"未选择要下载的图片"];
            }
            
            [downloadImageView removeFromSuperview];
            
        }];
        
        downloadImageView.frame = CGRectMake(0, self.view.frame.size.height-downloadImageView.frame.size.height, self.view.frame.size.width, downloadImageView.frame.size.height);
        
        [self.view addSubview:downloadImageView];
        
    }else{
        [self downLoadButtonEnable:YES];//开启下载按钮
        [self alertViewWithTitle:@"提示" message:@"数据异常"];
    }
}


- (void)downLoadButtonEnable:(BOOL)enable{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    CPSGoodsDetailsPreviewTableViewCell *cell = (CPSGoodsDetailsPreviewTableViewCell *)[self.goodsInfoTableView cellForRowAtIndexPath:indexPath];
    
    cell.downLoadButton.enabled = enable;
}

- (void)downLoadObjectiveImage:(BOOL)downLoadObjectiveImage downLoadWindowImage:(BOOL)downLoadWindowImage downLoadView:(UIView *)downLoadView{
    
    if (downLoadObjectiveImage && downLoadWindowImage) {
        
        self.downLoadType = DownLoadAllImage;
        
    }else if (downLoadObjectiveImage){
        
        self.downLoadType = DownLoadObject;
        
    }else if (downLoadWindowImage){
        
        self.downLoadType = DownLoadWindow;
    }else{
        
        [downLoadView removeFromSuperview];
        
        [self downLoadButtonEnable:YES];
    }
}

#pragma mark-判断是否连接到wifi
- (BOOL)isConnectWifi{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWWAN:
            
            isExistenceNetwork = NO;
            
            break;
            
        default:
            
            isExistenceNetwork = NO;
            
            break;
    }
    
    return isExistenceNetwork;
}

#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
}

#pragma mark-CSPAuthorityPopViewDelegate
- (void)showLevelRules{
    //等级规则
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
- (void)prepareToUpgradeUserLevel{

}
-(void)pushTransactionRecordsVC
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TransactionRecordsViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)isCanDownload{
    if ((self.residueDownload - [DownloadLogControl sharedInstance].downloadingItems+self.cancelDownloadCount)>=0) {
        return YES;
    }
    return NO;
}


//#pragma mark - CSPBaseTableViewCell return cell
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow0AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell0"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    NSInteger windowImageNum = 0;
//    
//    windowImageNum = self.getGoodsInfoList.windowImageList.count;
//    
//    cell.goodsPageControl.numberOfPages = windowImageNum;
//    
//    if (windowImageNum <= 1) {
//        cell.goodsPageControl.hidden = YES;
//    }
//    
//    cell.goodsScrollView.contentSize = CGSizeMake(self.view.frame.size.width*windowImageNum, self.view.frame.size.width);
//    
//    for (int i = 0; i<windowImageNum; i++) {
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width)];
//        
//        if (_windowImageArray.count>i) {
//            
//            imageView.image = [_windowImageArray objectAtIndex:i];
//        }
//        imageView.tag = i;
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
//        [cell.goodsScrollView addSubview:imageView];
//    }
//    
//    // !0主账号 1子账号
//    NSString * isMaster = [MyUserDefault JudgeUserAccount];
//    
//    
//    //判断需不需要下载按钮(如果是预览 或者是子账号查看，就不显示下载按钮)
//    if (self.isPreview ||  [isMaster isEqualToString:@"1"]) {
//        
//        cell.downLoadButton.hidden = YES;
//        
//    }else{
//        cell.downLoadButton.hidden = NO;
//        
//        
//    }
//    //!给button添加动画
//    [self addAni:cell.downLoadButton];
//    
//    
//    cell.downLoadButtonBlock = ^(){
//        
//        DebugLog(@"下载图片");
//        
//        if (self.getGoodsInfoList.downloadAuth.integerValue) {
//            //有权限
//            
//            //还需要判断是否有下载次数
//            [self requestImageInfo];
//            
//            
//        }else{
//            
//            //无权限
//            [self downloadAuth];
//        }
//        
//    };
//    
//    cell.goodsNameLabel.text = _getGoodsInfoList.goodsName?[NSString stringWithFormat:@"%@\n",_getGoodsInfoList.goodsName]:@"";
//    
//    
//    //价格
//    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    
//    
//    float hightFloat = 0.0f;
//    //获取最高价格
//    for (StepDTO *stepDto in self.getGoodsInfoList.stepDTOList) {
//        if ([stepDto.price floatValue] > hightFloat) {
//            hightFloat = [stepDto.price floatValue];
//        }
//    }
//    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[self transformationData:[NSNumber numberWithFloat:hightFloat]] attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x000000FF),NSFontAttributeName:[UIFont fontWithName:@"Tw Cen MT" size:35]}];
//    
//    [prefix appendAttributedString:price];
//    
//    cell.priceLabel.attributedText = prefix;
//    
//    
//    //创建阶梯价格
//    NSInteger stepPriceRow = 0;
//    
//    if (self.getGoodsInfoList.stepDTOList.count%3 == 0) {
//        stepPriceRow = self.getGoodsInfoList.stepDTOList.count/3;
//    }else{
//        stepPriceRow = self.getGoodsInfoList.stepDTOList.count/3+1;
//    }
//    
//    for (int i = 0; i<stepPriceRow; i++) {
//        
//        CPSGoodsDetailsEditStepPriceView *goodsDetailsEditStepPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsEditStepPriceView" owner:self options:nil]firstObject];
//        // !需要加上商品名称多余的数据
//        //                goodsDetailsEditStepPriceView.frame = CGRectMake(0, 156 +self.view.frame.size.width+30*i, self.view.frame.size.width, goodsDetailsEditStepPriceView.frame.size.height);
//        
//        // 34是xib上面商品名称的label高度
//        goodsDetailsEditStepPriceView.frame = CGRectMake(0, 156 - 34 + [self goodNameSize] +self.view.frame.size.width+30*i, self.view.frame.size.width, goodsDetailsEditStepPriceView.frame.size.height);
//        
//        
//        //赋值
//        for (int j = i*3; j<i*3+3; j++) {
//            
//            if (self.getGoodsInfoList.stepDTOList.count>j) {
//                
//                StepDTO *stepDto  = [self.getGoodsInfoList.stepDTOList objectAtIndex:j];
//                
//                UILabel *label = (UILabel *)[goodsDetailsEditStepPriceView viewWithTag:101+j%3];
//                
//                label.text = [NSString stringWithFormat:@"%@件：￥%0.2f",[self transformationData:stepDto.minNum],[[self transformationData:stepDto.price] floatValue]];
//                
//                if (j == self.getGoodsInfoList.stepDTOList.count-1) {
//                    
//                    label.text = [NSString stringWithFormat:@"%@件：￥%0.2f",[self transformationData:stepDto.minNum],[[self transformationData:stepDto.price] floatValue]];
//                }
//                
//            }else{
//                
//                UILabel *label = (UILabel *)[goodsDetailsEditStepPriceView viewWithTag:101+j%3];
//                
//                label.hidden = YES;
//                
//                //第二个分割线是需要隐藏的
//                UIView *view = (UIView *)[goodsDetailsEditStepPriceView viewWithTag:104];
//                
//                view.hidden = YES;
//            }
//        }
//        
//        
//        [cell addSubview:goodsDetailsEditStepPriceView];
//    }
//    return cell;
//
//}
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow1AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//    
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell1"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    //颜色
//    cell.goodsColorLabel.text = self.getGoodsInfoList.color? [NSString stringWithFormat:@"颜色：%@",self.getGoodsInfoList.color]:@"";
//    return cell;
//}
//
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow2AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//    
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell2"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    //尺码
//    //计算有多少列
//    NSInteger law = 0;
//    
//    for (int i = 0; i<_skuArray.count; i++) {
//        
//        if (self.view.frame.size.width - (15+(60+12)*i+60)<15) {
//            
//            law = i;
//            break;
//        }
//    }
//    
//    //如果law = 0说明只有一行
//    if (law == 0) {
//        
//        for (int i = 0; i<_skuArray.count; i++) {
//            
//            SkuDTO *skuDto = [_skuArray objectAtIndex:i];
//            
//            CPSGoodsDetailsEditSkuView *goodsDetailsEditSkuView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsEditSkuView" owner:self options:nil]firstObject];
//            
//            goodsDetailsEditSkuView.skuNameLabel.text = skuDto.skuName;
//            
//            goodsDetailsEditSkuView.frame = CGRectMake(15+(goodsDetailsEditSkuView.frame.size.width+12)*i, 44, goodsDetailsEditSkuView.frame.size.width, goodsDetailsEditSkuView.frame.size.height);
//            
//            [cell addSubview:goodsDetailsEditSkuView];
//        }
//        
//    }else{
//        
//        //如果law不等于0,说明有多行
//        for (int i = 0; i<_skuArray.count; i++) {
//            
//            SkuDTO *skuDto = [_skuArray objectAtIndex:i];
//            
//            CPSGoodsDetailsEditSkuView *goodsDetailsEditSkuView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsEditSkuView" owner:self options:nil]firstObject];
//            
//            goodsDetailsEditSkuView.skuNameLabel.text = skuDto.skuName;
//            
//            goodsDetailsEditSkuView.frame = CGRectMake(15+(NSInteger)(goodsDetailsEditSkuView.frame.size.width+12)*(i%law), 44+(NSInteger)(goodsDetailsEditSkuView.frame.size.height+15)*(i/law), goodsDetailsEditSkuView.frame.size.width, goodsDetailsEditSkuView.frame.size.height);
//            
//            [cell addSubview:goodsDetailsEditSkuView];
//            
//        }
//    }
//    return cell;
//}
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow3AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//    
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell3"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    return cell;
//}
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow4AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//    
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell4"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    return cell;
//}
//-(CPSGoodsDetailsPreviewTableViewCell *)tableView:(UITableView *)tableView cellForRow5AtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dic{
//    
//    
//    CPSGoodsDetailsPreviewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsPreviewTableViewCell5"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
//    }
//    return cell;
//}
@end
 /*
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  CPSGoodsDetailsPreviewTableViewCell *cell;
  
  if (self.goodsInfoTableView == tableView) {
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
  
  if (indexPath.row == 0) {
  
  
  }else if (indexPath.row == 1){
  
 
  
  }else if (indexPath.row == 2){
  
  
  
  }else if (indexPath.row == 3){
  //起批量
  cell.batchNumLimitLabel.text = [NSString stringWithFormat:@"起批量：%@ 件起批",[self transformationData:self.getGoodsInfoList.batchNumLimit]];
  
  }else if (indexPath.row == 4){
  
  if (_sampleFlag) {
  
  //发版价
  cell.samplePriceLabel.text = [NSString stringWithFormat:@"￥%@",[self transformationData:self.getGoodsInfoList.samplePrice]];
  
  }else{
  //混批条件
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:5];
  
  cell.batchMsgLabel.text = self.getGoodsInfoList.batchMsg;
  }
  
  
  }else if (indexPath.row == 5){
  
  if (_sampleFlag) {
  
  //混批条件
  cell.batchMsgLabel.text = self.getGoodsInfoList.batchMsg;
  
  }else{
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row+1];
  
  cell.merchantNameLabel.text = self.getGoodsInfoList.merchantName;
  
  
  }
  
  
  }else if (indexPath.row == 6){
  
  if (!_sampleFlag) {
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row+1];
  }else{
  
  
  cell.merchantNameLabel.text = self.getGoodsInfoList.merchantName;
  
  
  
  }
  
  }else if (indexPath.row == 7){
  
  }
  
  }else{
  
  //        if (indexPath.section == 0) {// !客观图 参考图标题
  //
  //            cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:8];
  //
  //            if (_goodsImageArray == _referImageArray) {
  //
  //                [cell showReferButton];
  //
  //            }else{
  //
  //                [cell showObjectiveButton];
  //            }
  //
  //            [cell.referImageButton setTitle:[NSString stringWithFormat:@"参考图（%ld）", _referImageArray.count] forState:UIControlStateNormal];
  //
  //            cell.referImageButtonBlock = ^(){
  //
  //
  //                _goodsImageArray = _referImageArray;
  //
  //                [self.imageTableView reloadData];
  //
  //            };
  //
  //            cell.objectiveImageButtonBlock = ^(){
  //
  //                _goodsImageArray = _objectiveImageArray;
  //
  //                [self.imageTableView reloadData];
  //            };
  //
  //        }else{
  
  
  if (_goodsImageArray == _objectiveImageArray) {// !客观图
  
  
  
  // !商品详情  第1段
  if (indexPath.section == 0) {
  
  
  //!自己写的cell
  CPSGoodsDeatilsCell *   cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDeatilsCell" owner:self options:nil]objectAtIndex:0];
  
  //                    cell.merchantNameLabel.text = self.getGoodsInfoList.details;
  cell.goodsDetailLabel.text = self.getGoodsInfoList.details;
  //                    cell.detailLabel.text = self.getGoodsInfoList.details;
  
  return cell;
  
  
  }
  
  // !商品图片
  // !每段是一行 改~~~~~
  if (_goodsImageArray.count>indexPath.section-1) {
  
  cell = [tableView dequeueReusableCellWithIdentifier:@"goodsImgaeViewCellID"];
  
  if (!cell) {
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:9];
  }
  
  cell.goodsImageView.image = [_goodsImageArray objectAtIndex:indexPath.section-1];
  
  
  }
  
  
  }else if (_goodsImageArray == _referImageArray){// !参考图
  
  if (_goodsImageArray.count) {// !如果有参考图
  
  cell = [tableView dequeueReusableCellWithIdentifier:@"goodsImgaeViewCellID"];
  
  if (!cell) {
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:9];
  }
  
  if (_goodsImageArray.count>indexPath.section) {
  
  cell.goodsImageView.image = [_goodsImageArray objectAtIndex:indexPath.section];
  
  
  }
  
  }else{// !如果没有参考图
  
  cell = [tableView dequeueReusableCellWithIdentifier:@"tipNogoodsImgaeViewCellID"];
  
  if (!cell) {
  
  cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:10];
  }
  
  }
  
  }
  }

  */
