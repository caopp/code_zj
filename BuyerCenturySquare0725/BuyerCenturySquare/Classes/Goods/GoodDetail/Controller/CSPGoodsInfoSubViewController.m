//
//  CSPGoodsInfoSubViewController.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoSubViewController.h"
#import "CSPGoodsInfoTopInfoTableViewCell.h"
#import "CSPGoodsInfoTopTableViewCell.h"
#import "CSPGoodsInfoSizeTableViewCell.h"
#import "CSPGoodsInfoModelTableViewCell.h"
#import "CSPGoodsInfoCountTableViewCell.h"
#import "CSPGoodsInfoMixConditonTableViewCell.h"
#import "CSPGoodsInfoShopTableViewCell.h"
#import "CSPGoodsInfoSubTipsTableViewCell.h"
#import "CSPGoodsInfoSubSizePicTableViewCell.h"
#import "CSPGoodsInfoSubPicsTableViewCell.h"
#import "CSPGoodsInfoSubAccountTableViewCell.h"
#import "CSPGoodsInfoNoticeTableViewCell.h"
#import "ConversationWindowViewController.h"
#import "HttpManager.h"

#import "MWWindow.h"
#import "MJPhoto.h"
#import  "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"

#import "HttpManager.h"
#import "GoodsInfoDetailsDTO.h"
#import "StepListDTO.h"
#import "ImageListDTO.h"
#import "SkuListDTO.h"
#import "GoodsInfoDTO.h"
#import "GetGoodsReplenishmentByMerchantListDTO.h"
#import "CartDTO.h"

#import "CSPShareView.h"

#import "GetDownloadImageListDTO.h"


#define kBasicRowCount 8


@interface CSPGoodsInfoSubViewController ()<UIScrollViewDelegate,CSPShareViewDelegate,UIScrollViewDelegate>
{
   
    NSUInteger rowCount;
    NSUInteger tableViewRowCount;
    NSUInteger bottomTableViewRowCount;
    NSInteger referenceImagesCount;
   // CSPGoodsInfoTopInfoTableViewCell *topInfoCell;
    long stepListCount;
    NSInteger totalCount;
    float totalPrice;
    float presentPrice;
    BOOL tipFlag;
    
    //优化加载速度
    NSDictionary *objectiveImagesDic;
    NSDictionary *referenceImagesDic;

    CSPShareView *shareView;
    
    //StepList 临界价格
    NSMutableDictionary *stepListCriticalPriceDic;
    NSMutableDictionary *stepListCriticalPriceMinDic;
    NSMutableDictionary *stepListCriticalPriceMaxDic;
    
    BOOL scrollUpState;
    int counts;
    
    BOOL noticeShow;
    NSString *noticeMsg;

}
@property (nonatomic,assign)BOOL modeStateSelected;
@property (nonatomic,assign)BOOL showObjectiveImage;
@property (nonatomic,assign)BOOL hasSampleSku;

@property (nonatomic,strong)RefreshControl *topRefreshControl;
@property (nonatomic,strong)RefreshControl *bottomRefreshControl;

@end

@implementation CSPGoodsInfoSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self scrollViewInit];
    rowCount = kBasicRowCount;
    totalCount = 0;
    totalPrice = 0;
    _modeStateSelected = NO;
    _showObjectiveImage = YES;
    self.tableView.scrollEnabled = NO;
    counts = 0;
    scrollUpState = YES;
    tipFlag = YES;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    self.bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self objectiveState:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollEnable) name:kScrollEnableAllNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollUNEnable) name:kScrollUNEnableAllNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollEnable) name:kNextWindowShowAllNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollUNEnable) name:kNextWindowCloseNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(navBarViewChange) name:@"MWWindowcancelTransition" object:nil];
    
    //获取会员信息
    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [self tableViewRefreshInit];
    
    
    UIImage *downloadImage = [UIImage imageNamed:@"顶栏下载"];
    
    [_downloadButton setTileDuration:2.f];
    [_downloadButton setTileImage:downloadImage];
    [_downloadButton setDirection:InfiniteDownloadDirectionTopToBottom];
    
    _backToTopButton.hidden = YES;
    
    [self setExtraCellLineHidden:self.tableView];
    [self setExtraCellLineHidden:self.bottomTableView];
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    GoodsInfoDTO *goodsInfo = [GoodsInfoDTO sharedInstance];
    [self getGoodsDetailInfoWith:goodsInfo.goodsNo];
    
    [self reloadDataForTableViews];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodsCountChanged:) name:kGoodsCountChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modeStateChangedNotification:) name:kModeStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(objectiveOrRefrenceButtonClicked:) name:kObjectiveAndRefrenceButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MJReFreshData) name:kMJRefreshDataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(threeButtonDisappearAnimation) name:kNextWindwoUpToNaviAnimationBegin object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(threeButtonAppearAnimation) name:kNextWindwoDownAnimationBegin object:nil];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)name:@"UIKeyboardWillHideNotification"object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsCountChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsInfoHttpSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kObjectiveAndRefrenceButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kModeStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindwoUpToNaviAnimationBegin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindwoDownAnimationBegin object:nil];
    
}

#pragma mark - HttpRequest 

- (void)getGoodsDetailInfoWith:(NSString *)goodsNo{
    
    [HttpManager sendHttpRequestForGetGoodsInfoDetailsWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic===%@",dic);
         //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _goodsInfoDetailsDTO = [[GoodsInfoDetailsDTO alloc] init];
                [_goodsInfoDetailsDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self getJID:_goodsInfoDetailsDTO.merchantNo];
                [self getDataSuccess];
                GoodsInfoDTO *goodsInfo = [GoodsInfoDTO sharedInstance];
                goodsInfo.goodsInfoDetailsInfo = _goodsInfoDetailsDTO;
                [self reloadDataForTableViews];
                
            }
        }else{
            
            [self alertWithAlertTip:@"未获取到服务器数据"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getJID:(NSString *)merchantNo{
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
//            _goodsInfoDetailsDTO.JID = dic[@"data"];
            
            
            _goodsInfoDetailsDTO.JID = [dic[@"data"] objectForKey:@"account"];
            
        }else{
            
        }
    
        [[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
}

#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop){
        
        //下拉
         _backToTopButton.hidden = YES;
        //结束加载
        [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.tableView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"enable", nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kWMPanEnable object:nil userInfo:dic];
        }];
        
    }else if (direction == RefreshDirectionBottom){
        
        //上拉
        _backToTopButton.hidden = NO;
        //结束加载
        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        [self.bottomTableView reloadData];
        
        [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
            
            
        } completion:^(BOOL finished) {
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"enable", nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kWMPanEnable object:nil userInfo:dic];
        }];
    }
}

//#pragma mark - NoticeView handelPan:
//-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
//    CGPoint translation = [gestureRecognizer translationInView:_noticeView];
//    CGPoint origin;
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            origin = translation;
//            break;
//        case UIGestureRecognizerStateChanged:
//            if (translation.y>origin.y) {
//                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//                    
//                    self.scrollView.contentOffset = CGPointMake(0, 0);
//                    self.tableView.contentOffset = CGPointMake(0, 0);
//                    
//                    
//                } completion:^(BOOL finished) {
//                    [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
//                }];
//            }
//            break;
//        case UIGestureRecognizerStateEnded:
//            [gestureRecognizer setEnabled:NO];
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - Private Functions

- (void)MJReFreshData{
    
    totalCount = 0;
    
    GoodsInfoDTO *goodsInfo = [GoodsInfoDTO sharedInstance];
    
    [self getGoodsDetailInfoWith:goodsInfo.goodsNo];
    
    
}

- (void)reloadDataForTableViews{
    
    [self.tableView reloadData];
    [self.bottomTableView reloadData];
}

- (void)scrollViewInit{

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height*2);
    _scrollView.pagingEnabled = YES;
    
}

- (void)tableViewRefreshInit{
    
    self.bottomRefreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    [self.bottomRefreshControl setBottomEnabled:YES];
    self.bottomTableView.pagingEnabled = NO;
    
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:self.bottomTableView delegate:self];
    [self.topRefreshControl setTopEnabled:YES];
}

-(void)navBarViewChange{
    
    [UIView animateWithDuration:5 animations:^{
        
//        [_navBarView setBackgroundColor:[UIColor blackColor]];

        
    }];
}

- (void)scrollEnable{
    
    self.tableView.scrollEnabled = YES;
}

- (void)scrollUNEnable{
    
    self.tableView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float offset = scrollView.contentOffset.y;
    
    if (offset<-1) {
        
        [self scrollUNEnable];
    }
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:7 inSection:0];
//    
//    CGRect popoverRect = [self.tableView convertRect:[self.tableView rectForRowAtIndexPath:path] toView:[self.tableView superview]];
//    
//    if (popoverRect.origin.y<=[UIScreen mainScreen].bounds.size.height-20-44-50&&popoverRect.origin.y>=[UIScreen mainScreen].bounds.size.height-20-44-50-30) {
//        
//        if (scrollUpState) {
//            //下拉
//            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            scrollUpState = NO;
//        }
//        
//    }else if(popoverRect.origin.y>=64&&popoverRect.origin.y<=100){
//        
//        if (!scrollUpState) {
//            //上拉
//            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            scrollUpState = YES;
//        }
//    
//    }
    
    
    
}

- (void)getDataSuccess{

    if ([_goodsInfoDetailsDTO.isFavorite isEqualToString:@"0"]) {
        
        [self.collectButton setSelected:YES];
    }else{
        [self.collectButton setSelected:NO];
    }
    
    //hasSampleSku
    if ([_goodsInfoDetailsDTO.sampleSkuInfo isKindOfClass:[NSDictionary class]]&&[_goodsInfoDetailsDTO.sampleSkuInfo.allKeys count]>0) {
        _hasSampleSku = YES;
        
    }else{
        
        _hasSampleSku = NO;
    }
    
    //imageList
    referenceImagesDic = [self getReferenceImages];
    objectiveImagesDic = [self getObjectiveImages];
    
    stepListCriticalPriceDic = [[NSMutableDictionary alloc]init];
    stepListCriticalPriceMinDic = [[NSMutableDictionary alloc]init];
    stepListCriticalPriceMaxDic = [[NSMutableDictionary alloc]init];
    
    for (StepListDTO *tmpStepDTO in _goodsInfoDetailsDTO.stepList) {
        
        NSString *criticalPrice_min = [NSString stringWithFormat:@"%@",tmpStepDTO.minNum];
        NSString *criticalPrice_max = [NSString stringWithFormat:@"%@",tmpStepDTO.maxNum];
        
        if (!stepListCriticalPriceDic[criticalPrice_min]) {
            
            [stepListCriticalPriceDic setObject:@1 forKey:criticalPrice_min];
            [stepListCriticalPriceMinDic setObject:@1 forKey:criticalPrice_min];
        }else{
            
            NSNumber *obj = stepListCriticalPriceDic[criticalPrice_min];
            
            obj = [NSNumber numberWithInteger:[obj integerValue]];
            
            [stepListCriticalPriceDic setObject:obj forKey:criticalPrice_min];
            
            obj = stepListCriticalPriceMinDic[criticalPrice_min];
            
            obj = [NSNumber numberWithInteger:[obj integerValue]];
            
            [stepListCriticalPriceMinDic setObject:obj forKey:criticalPrice_min];
        }

        if (![criticalPrice_max isEqualToString:@""]) {
         
            if (!stepListCriticalPriceDic[criticalPrice_max]) {
                
                [stepListCriticalPriceDic setObject:@1 forKey:criticalPrice_max];
                [stepListCriticalPriceMaxDic setObject:@1 forKey:criticalPrice_max];
            }else{
                
                NSNumber *obj = stepListCriticalPriceDic[criticalPrice_max];
                
                obj = [NSNumber numberWithInteger:[obj integerValue]];
                
                [stepListCriticalPriceDic setObject:obj forKey:criticalPrice_max];
                
                obj = stepListCriticalPriceMaxDic[criticalPrice_max];
                
                obj = [NSNumber numberWithInteger:[obj integerValue]];
                
                [stepListCriticalPriceMaxDic setObject:obj forKey:criticalPrice_max];
            }
        }

    }
    
    [self updateConsultData];
    
    [self reloadDataForTableViews];
    
    
}

- (void)modeStateChangedNotification:(NSNotification *)note{
    _modeStateSelected = !_modeStateSelected;
    [self updateConsultData];
    [self.tableView reloadData];
}

- (void)updateRowCountWithList:(NSArray*)list{
    
    NSInteger level = 0;
    if ([MemberInfoDTO sharedInstance]) {
        level = [[MemberInfoDTO sharedInstance].memberLevel integerValue];
    }
    
    NSArray *imageList = list;
    
    if (level<=2) {
        
        noticeShow = YES;
        noticeMsg = @"当前等级无查看权限！";
    }else{
        noticeShow = NO;
    }
    
    if (_hasSampleSku) {
        if (level>2) {
            rowCount = kBasicRowCount+imageList.count+1;
            tableViewRowCount = kBasicRowCount;
            bottomTableViewRowCount = imageList.count;
        }else{
            rowCount = kBasicRowCount;
            tableViewRowCount = kBasicRowCount;
            bottomTableViewRowCount = 0;
        }
    }else{
        if (level>2) {
            rowCount = kBasicRowCount+imageList.count;
            tableViewRowCount = kBasicRowCount-1;
            bottomTableViewRowCount = imageList.count;
        }else{
            rowCount = kBasicRowCount-1;
            tableViewRowCount = kBasicRowCount-1;
            bottomTableViewRowCount = 0;
        }
        
    }
    
}

- (NSDictionary *)getObjectiveImages{
    
    NSArray *imageList = _goodsInfoDetailsDTO.objectiveImageList;
     NSLog(@"list==%@",imageList);
    [self updateRowCountWithList:imageList];
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tmpDic in imageList) {
        
        NSNumber *sort = tmpDic[@"sort"];
        NSString *picUrl = tmpDic[@"picUrl"];
        [imageDic setObject:picUrl forKey:sort];
    }
    
    return imageDic;
}

- (NSDictionary *)getReferenceImages{
    
    NSArray *imageList = _goodsInfoDetailsDTO.referImageList;
    NSLog(@"list==%@",imageList);
    [self updateRowCountWithList:imageList];
    
    referenceImagesCount = imageList.count;
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tmpDic in imageList) {
        
        NSNumber *sort = tmpDic[@"sort"];
        NSString *picUrl = tmpDic[@"picUrl"];
        [imageDic setObject:picUrl forKey:sort];
    }
    
    [self setReferenceButtonNum];
    return imageDic;
}

- (void)objectiveOrRefrenceButtonClicked:(NSNotification *)note{
    
    NSDictionary *dic = [note userInfo];
    NSString *buttonType = dic[@"type"];
    
    if ([buttonType isEqualToString:@"objectiveButton"]) {
        
        _showObjectiveImage = YES;
        [self getObjectiveImages];
    }else{
        _showObjectiveImage = NO;
        [self getReferenceImages];
    }
    
    [self reloadDataForTableViews];
}

//计算当前总价
- (float)calculatePresentTotalPrice:(NSInteger)total withStepList:(NSArray*)stepList{
    
    for (StepListDTO *tmpDTO in stepList) {
        
        NSInteger min = [tmpDTO.minNum integerValue];
        NSInteger max ;
        
        NSString *maxStr = [NSString stringWithFormat:@"%@",tmpDTO.maxNum];
        
        if ([maxStr isEqualToString:@""]) {
            
            max = 2147483640;
        }else{
            
            max = [tmpDTO.maxNum integerValue];
        }
        
        if (total>=min&&total<=max) {
            
            presentPrice = [tmpDTO.price floatValue];
            return presentPrice*total;
        }
    }

    return 0;
}

- (void)goodsCountChanged:(NSNotification*)note{
    
    NSDictionary *dic = [note userInfo];
    NSInteger count = [dic[@"totalCount"] integerValue];
    
    if (totalCount!=count) {
        
        float oldPrice = presentPrice;
        
        [self calculatePresentTotalPrice:count withStepList:_goodsInfoDetailsDTO.stepList];
        
        totalCount = count;
        
        if (presentPrice!=oldPrice) {
            
            NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[topInfoCellIndex] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        NSIndexPath* countCellIndex ;

        if (_hasSampleSku) {
            countCellIndex = [NSIndexPath indexPathForRow:4 inSection:0];
        }else{
            countCellIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        }

        [self updateConsultData];
        [self.tableView reloadRowsAtIndexPaths:@[countCellIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

//按钮隐藏-失效
/*
- (void)setButtonBarHide:(BOOL)hide{

    if (hide) {
    
        [_tableView setFrame:self.view.frame];
        [_tableView reloadData];

    }else{
        
        [_tableView setFrame:CGRectMake(0, _navBarView.frame.size.height,self.view.frame.size.width,self.view.frame.size.height- _navBarView.frame.size.height)];
        _navBarView.userInteractionEnabled = YES;
        [_tableView reloadData];
    }
    
}
*/

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        return tableViewRowCount;
    }else if(tableView==self.bottomTableView){
        if (noticeShow) {
            return 1;
        }
        return bottomTableViewRowCount;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *cell;
    if (tableView == self.tableView) {
        if (_hasSampleSku) {
            
            switch (indexPath.row) {
           
                case 0:
                    cell = [self createCSPGoodsInfoTopInfoTableViewCell:indexPath withTable:tableView];
                    break;
                case 1:
                    cell = [self createCSPBaseTableViewCell:indexPath withTable:tableView];
                    break;
                case 2:
                    cell = [self createCSPGoodsInfoSizeTableViewCell:indexPath withTable:tableView];
                    break;
                case 3:
                    cell = [self createCSPGoodsInfoModelTableViewCell:indexPath withTable:tableView];
                    break;
                case 4:
                    cell = [self createCSPGoodsInfoCountTableViewCell:indexPath withTable:tableView];
                    break;
                case 5:
                    cell = [self createCSPGoodsInfoMixConditonTableViewCell:indexPath withTable:tableView];
                    break;
                case 6:
                    cell = [self createCSPGoodsInfoShopTableViewCell:indexPath withTable:tableView];
                    break;
                case 7:
                    cell = [self createCSPGoodsInfoSubTipsTableViewCell:indexPath withTable:tableView];
                    break;
                default:
                    return nil;
                    break;
            }
            
        }else{
            
            switch (indexPath.row) {
         
                case 0:
                    cell = [self createCSPGoodsInfoTopInfoTableViewCell:indexPath withTable:tableView];
                    break;
                case 1:
                    cell = [self createCSPBaseTableViewCell:indexPath withTable:tableView];
                    break;
                case 2:
                    cell = [self createCSPGoodsInfoSizeTableViewCell:indexPath withTable:tableView];
                    break;
                case 3:
                    cell = [self createCSPGoodsInfoCountTableViewCell:indexPath withTable:tableView];
                    break;
                case 4:
                    cell = [self createCSPGoodsInfoMixConditonTableViewCell:indexPath withTable:tableView];
                    break;
                case 5:
                    cell = [self createCSPGoodsInfoShopTableViewCell:indexPath withTable:tableView];
                    break;
                case 6:
                    cell = [self createCSPGoodsInfoSubTipsTableViewCell:indexPath withTable:tableView];
                    break;
                    
                default:
                    return nil;
                    break;
            }
            
        }
        
        return cell;
    }else{
        if (noticeShow) {
            //noticeCell.noticeL.text = noticeMsg;
            return  [self createCSPGoodsInfoNoticeTableViewCell:indexPath withTable:tableView];
        }
        return [self createCSPGoodsInfoSubPicsTableViewCell:indexPath withTable:tableView];
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
   
    if ([_goodsInfoDetailsDTO.batchMsg length]==0) {
        if (tableView==self.tableView) {
            if (_hasSampleSku) {
                if (indexPath.row == 5) {
                    return 0;
                }
            }else{
                if (indexPath.row == 4) {
                    return 0;
                }
            }
        }
    }
    return height;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

        [cell setSeparatorInset:UIEdgeInsetsZero];

    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        [cell setLayoutMargins:UIEdgeInsetsZero];

    }
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.bottomTableView ==tableView) {
        if (bottomTableViewRowCount) {
             [self tapImage:indexPath];
        }
       
        return;
    }
    if (_modeStateSelected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kModeStateChangedNotification object:nil];
    }
    if (self.tableView==tableView) {
        [self.view endEditing:YES];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CSPGoodsInfoShopTableViewCell class]]) {
        
        [self goodsInfoShopTableViewCellClicked];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.bottomTableView==tableView) {
        return 30.0f;
    }
    return tableView.tableHeaderView.frame.size.height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    headerView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked

- (void)tapImage:(NSIndexPath *)indexPath
{
   [[NSNotificationCenter defaultCenter] postNotificationName:kNextWindowOverAnimation object:nil];
    CSPGoodsInfoSubPicsTableViewCell *cell1 =  [_bottomTableView cellForRowAtIndexPath:indexPath];
    NSArray *imageList =_showObjectiveImage?_goodsInfoDetailsDTO.objectiveImageList: _goodsInfoDetailsDTO.referImageList;
    NSLog(@"imageList===%@",imageList);
   

    
    //NSDictionary *getReferenceImagesDic = _showObjectiveImage?objectiveImagesDic:referenceImagesDic;
    int count =(int) bottomTableViewRowCount;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
         NSDictionary *getReferenceImagesDic = [imageList objectAtIndex:i];
        
        NSString *urlStr = getReferenceImagesDic[@"picUrl"];
        // 替换为中等尺寸图片
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url==%@",url);
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = url; // 图片路径
        photo.srcImageView = cell1.imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.showKeyWindow = YES;
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark - ButtonClicked

- (IBAction)backToTopClicked:(id)sender {
    
    [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        
        
    } completion:^(BOOL finished) {
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"enable", nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kWMPanEnable object:nil userInfo:dic];
        
        self.bottomTableView.contentOffset = CGPointMake(0, 0);
        _backToTopButton.hidden = YES;
    }];
}


//下载
- (IBAction)downloadButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDownloadButtonClickedNotification object:nil];
}

//收藏
- (IBAction)collectButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kCollectButtonClickedNotification object:nil];
}

//分享
- (IBAction)shareButtonClicked:(id)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:kShareButtonClickedNotification object:nil];
//    shareView = [[[NSBundle mainBundle] loadNibNamed:@"CSPShareView" owner:self options:nil] objectAtIndex:0];
//    shareView.delegate = self;
//    shareView.frame = CGRectMake(0, 0, self.view.frame.size.width, 243);
//    [self.downloadView addSubview:shareView];
    [self.downloadView setHidden:NO];
}


-(void)dismissShareView
{
    [shareView removeFromSuperview];
    [self.downloadView setHidden:YES];
}

- (void)goodsInfoShopTableViewCellClicked{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kGoodsInfoShopTableViewCellClicked object:nil];
}

#pragma mark - 询单结算
- (void)updateConsultData{
    
    _startNumL.text = [NSString stringWithFormat:@"起批：%@",_goodsInfoDetailsDTO.batchNumLimit];
    _hasSelectedNumL.text = [NSString stringWithFormat:@"已选购：%zi",totalCount];
    
    if (totalCount>=[_goodsInfoDetailsDTO.batchNumLimit integerValue]) {
        
        [_button setEnabled:YES];
        [_button setBackgroundColor:[UIColor blackColor]];
    }else{
        [_button setEnabled:NO];
        [_button setBackgroundColor:[UIColor grayColor]];
    }
    
    [self updateHasSelectedModel];
}

- (void)updateHasSelectedModel{

    if (_modeStateSelected) {
        
        _startNumL.text = [NSString stringWithFormat:@"发版：1"];
        _hasSelectedNumL.hidden = YES;
        _lineView.hidden = YES;
        [_button setTitle:@"发版结算" forState:UIControlStateNormal];
        [_button setTitle:@"发版结算" forState:UIControlStateHighlighted];
        [_button setEnabled:YES];
        [_button setBackgroundColor:[UIColor blackColor]];
        
    }else{
        
        _startNumL.text = [NSString stringWithFormat:@"起批：%@",_goodsInfoDetailsDTO.batchNumLimit];
        _hasSelectedNumL.hidden = NO;
        _lineView.hidden = NO;
        [_button setTitle:@"询单结算" forState:UIControlStateNormal];
        [_button setTitle:@"询单结算" forState:UIControlStateHighlighted];
    }
}

- (IBAction)settleButtonClicked:(id)sender {
    
    NSDictionary *goodsDic = [[NSDictionary alloc]initWithObjectsAndKeys:_goodsInfoDetailsDTO,@"list",_modeStateSelected?@"0":@"1",@"model",[NSString stringWithFormat:@"%.2f", presentPrice], @"presentPrice", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kConsultAndSettleButtonClickedNotification object:nil userInfo:goodsDic];
    
}

#pragma mark - 客观图、参考图按钮

- (IBAction)objectiveImgBtnClicked:(id)sender {
 
    [self objectiveState:YES];
    _showObjectiveImage = YES;
    [self getObjectiveImages];
    [self.bottomTableView reloadData];
}

- (IBAction)referenceImgBtnClicked:(id)sender {
    
    [self objectiveState:NO];
    _showObjectiveImage = NO;
    [self getReferenceImages];
    [self.bottomTableView reloadData];
}

- (void)objectiveState:(BOOL)objective{
    
    if (objective) {
        _objBackView.backgroundColor = [UIColor whiteColor];
        _objL.textColor = [UIColor blackColor];
        
        _refBackView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        _refL.textColor = [UIColor whiteColor];
    }else{
        _objBackView.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        _objL.textColor = [UIColor whiteColor];
        
        _refBackView.backgroundColor = [UIColor whiteColor];
        _refL.textColor = [UIColor blackColor];
    }
}

- (void)setReferenceButtonNum{
    
    NSString *title = [NSString stringWithFormat:@"参考图(%zi)",referenceImagesCount];
    _refL.text = title;
    
    if (referenceImagesCount==0) {
        
        noticeShow = YES;
        noticeMsg = @"商家暂未上传参考图!";
        
    }else{
        
        if([[MemberInfoDTO sharedInstance].memberLevel integerValue]>=2){
            noticeShow = NO;
        }else{
            
            noticeMsg = @"当前等级无查看权限！";
            noticeShow = YES;
        }
    }
}

#pragma - mark Animation
- (void)threeButtonDisappearAnimation{
    
    [self hideAllButtons:@[_collectButton,_downloadButton,_shareButton]];
    //整体上拉-白消失
    self.navBarView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollViewConstraintAdTop.constant = 0;
        
    }];
    
    self.tableView.scrollEnabled = YES;
    self.bottomTableView.scrollEnabled = YES;
}

- (void)threeButtonAppearAnimation{
    
    [self showAllButtons:@[_collectButton,_downloadButton,_shareButton]];
    //整体下拉-白显示
    self.navBarView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollViewConstraintAdTop.constant = 44;
        
    }];
    
    self.tableView.scrollEnabled = NO;
    self.bottomTableView.scrollEnabled = NO;
}

- (void)hideAllButtons:(NSArray *)btnArray{
    
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *button = btnArray[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.2 animations:^{
                button.alpha = 0;
            }];
            
        });
    }
}

- (void)showAllButtons:(NSArray *)btnArray{
    
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *button = btnArray[i];
        CGRect rect = button.frame;
        rect.origin.y = -50;
        button.alpha = 0.2;
        [button setFrame:rect];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                CGRect rect = button.frame;
                rect.origin.y = 16;
                [button setFrame:rect];
                button.alpha = 1;
                
            } completion:nil];
        });
    }
}

- (void)threeButtonSetAlphaToShow{
    
    NSArray *array = @[_collectButton,_downloadButton,_shareButton];
    
    for (UIButton *tmpBtn in array) {
        tmpBtn.alpha = 1;
    }
    
}

#pragma  mark create TableViewCell

-(CSPGoodsInfoTopInfoTableViewCell *)createCSPGoodsInfoTopInfoTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoTopInfoTableViewCell *topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopInfoTableViewCell"];
    if (!topcell)
    {
        topcell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsInfoTopInfoTableViewCell" owner:self options:nil]objectAtIndex:0];
        //[tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoTopInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoTopInfoTableViewCell"];
        //topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopInfoTableViewCell"];
    }
    topcell.goodName.text = [NSString stringWithFormat:@"%@\n",_goodsInfoDetailsDTO.goodsName]; 
    
    if (totalCount>=[_goodsInfoDetailsDTO.batchNumLimit integerValue]) {
        topcell.price.text = [NSString stringWithFormat:@"%.2lf",presentPrice];
    }else{
        topcell.price.text = [NSString stringWithFormat:@"%.2f",[_goodsInfoDetailsDTO.price floatValue]];
    }
    
    topcell.stepList = _goodsInfoDetailsDTO.stepList;
    [topcell setModeState:_modeStateSelected];
    
    topcell.showLine = YES;
    return topcell;
}

-(CSPBaseTableViewCell *)createCSPBaseTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPBaseTableViewCell *colorCell = [tableView dequeueReusableCellWithIdentifier:@"colorCell"];
    UILabel *colorLabel;
    if (!colorCell) {
        colorCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorCell"];
        colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 200, 14)];
        colorLabel.font = [UIFont systemFontOfSize:14];
        [colorCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [colorCell addSubview:colorLabel];
        
    }
    colorLabel.text = [NSString stringWithFormat:@"颜色: %@",_goodsInfoDetailsDTO.color];
    UIColor *modeStateColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    if (_modeStateSelected) {
        colorLabel.textColor = modeStateColor;
    }else{
        colorLabel.textColor = [UIColor blackColor];
    }
    colorCell.showLine = YES;
    return colorCell;
}
-(CSPGoodsInfoSizeTableViewCell *)createCSPGoodsInfoSizeTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoSizeTableViewCell *sizeCell  = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSizeTableViewCell"];
    if (!sizeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSizeTableViewCell"];
        sizeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSizeTableViewCell"];
    }
    sizeCell.skuList = _goodsInfoDetailsDTO.skuList;
    [sizeCell setModeState:_modeStateSelected];
    sizeCell.showLine = YES;
    return sizeCell;
}
-(CSPGoodsInfoModelTableViewCell *)createCSPGoodsInfoModelTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoModelTableViewCell *modelCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoModelTableViewCell"];
    if (!modelCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoModelTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoModelTableViewCell"];
        modelCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoModelTableViewCell"];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"样板价:  ¥ %@",_goodsInfoDetailsDTO.samplePrice] ];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(6, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(7, [str length]-7)];
    // modelCell.priceL.text = strText;//[NSString stringWithFormat:@"样板价:¥ %@",_goodsInfoDetailsDTO.samplePrice];
    [modelCell.priceL setAttributedText:str];
    
    [modelCell setModeState:_modeStateSelected];
    modelCell.showLine = YES;
    return modelCell;
}
-(CSPGoodsInfoCountTableViewCell *)createCSPGoodsInfoCountTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoCountTableViewCell *countCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoCountTableViewCell"];
    if (!countCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoCountTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoCountTableViewCell"];
        countCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoCountTableViewCell"];
    }
    [countCell setStartNum:_goodsInfoDetailsDTO.batchNumLimit];
    [countCell setModeState:_modeStateSelected];
    countCell.countNumL.text = [NSString stringWithFormat:@"%zi件",totalCount];
    totalPrice = [self calculatePresentTotalPrice:totalCount withStepList:_goodsInfoDetailsDTO.stepList];
    countCell.totalPrice.text = [NSString stringWithFormat:@"%.2lf",totalPrice];
    countCell.showLine = YES;
    return countCell;
}
-(CSPGoodsInfoMixConditonTableViewCell *)createCSPGoodsInfoMixConditonTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoMixConditonTableViewCell *mixConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
    if (!mixConditionCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoMixConditonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
        mixConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
    }
    if ([_goodsInfoDetailsDTO.batchMsg length] > 0) {
        mixConditionCell.alphaView.hidden = NO;
        mixConditionCell.mixL.hidden = NO;
        mixConditionCell.titleL.hidden = NO;
        [mixConditionCell updateBatchMsg:_goodsInfoDetailsDTO.batchMsg];
        [mixConditionCell setModeState:_modeStateSelected];
    }else{
        mixConditionCell.alphaView.hidden = YES;
        mixConditionCell.mixL.hidden = YES;
        mixConditionCell.titleL.hidden = YES;
    }
    mixConditionCell.showLine = YES;
    return mixConditionCell;
}
-(CSPGoodsInfoShopTableViewCell *)createCSPGoodsInfoShopTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoShopTableViewCell"];
    if (!shopCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoShopTableViewCell"];
    }
    shopCell.showLine = YES;
    shopCell.shopName = _goodsInfoDetailsDTO.merchantName;
    return shopCell;
}


-(CSPGoodsInfoSubTipsTableViewCell *)createCSPGoodsInfoSubTipsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoSubTipsTableViewCell *tipsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
    if (!tipsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSubTipsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
        tipsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
    }
    return tipsCell;
}

-(CSPGoodsInfoSubPicsTableViewCell *)createCSPGoodsInfoSubPicsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoSubPicsTableViewCell *picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    if (!picsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSubPicsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
        picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    }
    if (_showObjectiveImage) {
        
        if (bottomTableViewRowCount>0) {
            NSArray *imageList = _goodsInfoDetailsDTO.objectiveImageList;
            
            NSDictionary *getObjectiveImagesDic = [imageList objectAtIndex:index.row];
            
            NSString *urlStr = getObjectiveImagesDic[@"picUrl"];
            
            picsCell.row = index.row;
            picsCell.url = urlStr;
            
        }
        
        
    }else{
        
        if (bottomTableViewRowCount>0) {
            NSArray *imageList = _goodsInfoDetailsDTO.referImageList;
            NSDictionary *getReferenceImagesDic = [imageList objectAtIndex:index.row];
            NSString *urlStr = getReferenceImagesDic[@"picUrl"];
            
            picsCell.row = index.row;
            picsCell.url = urlStr;
        }
        
    }
    
    return picsCell;
}
-(CSPGoodsInfoNoticeTableViewCell *)createCSPGoodsInfoNoticeTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
    if (!noticeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
        noticeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
    }
    noticeCell.noticeL.text = noticeMsg;
    return noticeCell;
}



@end
