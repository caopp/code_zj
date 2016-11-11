//
//  CPSDownloadHistoryViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSDownloadHistoryViewController.h"

#import "CSPDownLoadImageCell.h"

#import "RefreshControl.h"

#import "ImageHistoryDTO.h"

#import "CSPSelectedButton.h"

#import "CSPPicInfoDTO.h"

#import "CSPDownLoadImageDTO.h"

#import "GetHistoryDownloadListDTO.h"
#import "UIImageView+WebCache.h"
#import "GoodsInfoDTO.h"
#import "CSPGoodsInfoTableViewController.h"
#import "GoodDetailViewController.h"
#import "SDRefresh.h"

const CGFloat convert = 1024.0;

@interface CPSDownloadHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>

@property (strong,nonatomic)NSMutableArray *downloadImageArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *selectedAllButton;

- (IBAction)selectedAllButtonClick:(id)sender;

- (IBAction)downloadAgainButtonClick:(id)sender;


@property (strong,nonatomic)NSMutableArray *dataArray;

/**
 *  剩余下载次数
 */
@property (assign,nonatomic)NSInteger residueDownload;

@property (assign,nonatomic)NSInteger allDownloadCount;


@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@end

@implementation CPSDownloadHistoryViewController{
    
    NSInteger _pageNO;
    
    BOOL _isRefresh;
    
    NSMutableArray *_selectedArray;
    
    BOOL _isClickAllSelected;
    
    NSMutableArray *upArray;
    
    NSInteger canDownCount;
    

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addCustombackButtonItem];
    self.title = @"下载历史";
    
    _pageNO = 1;
    
    //!创建刷新
    [self createRefresh];
    
    //!去除分割线
    [self setExtraCellLineHidden:self.tableView];
    
    [self initArray];
    
    
    [self requestHistoryDownloadImage:self.refreshHeader];
    
    

}
//!创建刷新
-(void)createRefresh{

    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    
    __weak CPSDownloadHistoryViewController * vc = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [vc requestHistoryDownloadImage:self.refreshHeader];
        
    };
    
    //!底部
    self.refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [self.refreshFooter addToScrollView:self.tableView];
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        
        
        [vc requestHistoryDownloadImage:self.refreshFooter];
        
    };



}

- (void)initArray{
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    _selectedArray = [[NSMutableArray alloc]init];
    
    self.downloadImageArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark 读取下载历史
- (void)requestHistoryDownloadImage:(SDRefreshView *)refresh{
    

    if (refresh == self.refreshFooter) {
        
        _pageNO++;

    }else{
        
        _pageNO = 1;
    }
    
    [HttpManager sendHttpRequestForGetHistoryDownloadListWithPageNo:[NSNumber numberWithInteger:_pageNO] pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        if (refresh == self.refreshHeader) {
            
            [self.dataArray removeAllObjects];
            
        }
        
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:@"code"]]) {
            
            
            id data = [responseDic objectForKey:@"data"];
            
            DownloadHistoryDTO *downloadHistoryDTO = [[DownloadHistoryDTO alloc]init];
            
            [downloadHistoryDTO setDictFrom:data];
            
            id list = [data objectForKey:@"list"];
            
            for (NSDictionary *dic in list) {
                
                ImageHistoryDTO *imageHistoryDTO = [[ImageHistoryDTO alloc]init];
                
                [imageHistoryDTO setDictFrom:dic];
                
                id dataList = [dic objectForKey:@"list"];
                
                for (NSDictionary *listDic in dataList) {
                    
                    HistoryPictureDTO2 *historyPictureDTO = [[HistoryPictureDTO2 alloc]init];
                    historyPictureDTO.goodsNO = imageHistoryDTO.goodsNo;
                    [historyPictureDTO setDictFrom:listDic];
                    
                    [imageHistoryDTO.historyPictureDTOList addObject:historyPictureDTO];
                }
                
                [downloadHistoryDTO.list addObject:imageHistoryDTO];
                
                [self.dataArray addObject:imageHistoryDTO];
            }
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            NSMutableArray * listArray = list;
            
            if (listArray.count < pageSize) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            
            [self getAllDownloadCount];
            
            [self.tableView reloadData];
            

            
            
            if (refresh == self.refreshHeader) {//!下拉刷新的时候，如果全选是选择的，就改变选中的状态
                
                self.selectedAllButton.selected = NO;
                [_selectedArray removeAllObjects];
                
            }else{
                //!上拉加载的时候，判断 选中的数据是否和请求 回来的个数相同
                if (self.allDownloadCount == _selectedArray.count) {
                    
                    self.selectedAllButton.selected = YES;
                    
                }else{
                    
                    self.selectedAllButton.selected = NO;
                    
                }
                
            }
            
            
        }else{
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        
    }];

    
    
    /*
    [HttpManager sendHttpRequestForGetHistoryDownloadListWithPageNo:[NSNumber numberWithInteger:_pageNO] pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        if (refresh == self.refreshHeader) {
            
            [self.dataArray removeAllObjects];
            
        }
        
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:@"code"]]) {
            
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                DownloadHistoryDTO *downloadHistoryDTO = [[DownloadHistoryDTO alloc]init];
                
                [downloadHistoryDTO setDictFrom:data];
                
                id list = [data objectForKey:@"list"];
                
                if ([self checkData:list class:[NSMutableArray class]]) {
                    
                    for (NSDictionary *dic in list) {
                        
                        ImageHistoryDTO *imageHistoryDTO = [[ImageHistoryDTO alloc]init];
                        
                        [imageHistoryDTO setDictFrom:dic];
                        
                        id dataList = [dic objectForKey:@"list"];
                        
                        if ([self checkData:dataList class:[NSMutableArray class]]) {
                            
                            for (NSDictionary *listDic in dataList) {
                                
                                HistoryPictureDTO2 *historyPictureDTO = [[HistoryPictureDTO2 alloc]init];
                                historyPictureDTO.goodsNO = imageHistoryDTO.goodsNo;
                                [historyPictureDTO setDictFrom:listDic];
                                
                                [imageHistoryDTO.historyPictureDTOList addObject:historyPictureDTO];
                            }

                        }
                        
                        [downloadHistoryDTO.list addObject:imageHistoryDTO];
                        
                        [self.dataArray addObject:imageHistoryDTO];
                    }
                    
                    [self.refreshHeader endRefreshing];
                    [self.refreshFooter endRefreshing];
                    
                    NSMutableArray * listArray = list;
                    
                    if (listArray.count < pageSize) {
                    
                        [self.refreshFooter noDataRefresh];
                    
                    }
                    
                }else{
                
                    [self.refreshHeader endRefreshing];
                    [self.refreshFooter endRefreshing];
                    
                }
                
                [self getAllDownloadCount];
                
                [self.tableView reloadData];
                
               
                
            }
            
            
            if (refresh == self.refreshHeader) {//!下拉刷新的时候，如果全选是选择的，就改变选中的状态
                
                self.selectedAllButton.selected = NO;
                [_selectedArray removeAllObjects];
            
            }else{
                //!上拉加载的时候，判断 选中的数据是否和请求 回来的个数相同
                if (self.allDownloadCount == _selectedArray.count) {
                    
                    self.selectedAllButton.selected = YES;
                    
                }else{
                
                    self.selectedAllButton.selected = NO;

                }
            
            }
            
            
        }else{
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];

        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];

    }];
    */
    
}

#pragma mark-
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPDownLoadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownLoadImageCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPDownLoadImageCell" owner:self options:nil]firstObject];
        
    }
    
    cell.viewControllerType = DownloadHistoryViewController;
    
    ImageHistoryDTO *imageHistoryDto = [self.dataArray objectAtIndex:indexPath.row];
    
    HistoryPictureDTO2 *windowHistoryPictureDto;
    
    HistoryPictureDTO2 *objectHistoryPictureDto;
    
    for (HistoryPictureDTO2 *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
        
        if (historyPictureDto.picType.integerValue == 0) {
            
            windowHistoryPictureDto = historyPictureDto;
            
        }else if (historyPictureDto.picType.integerValue == 1){
            
            objectHistoryPictureDto = historyPictureDto;
        }
    }
    
    [cell showCellWithImageHistoryDto:imageHistoryDto downloadedSelectedWindowImageBlock:^{
        //选择/取消窗口图
        cell.windowImageSelectedButton.selected = !cell.windowImageSelectedButton.selected;
        
        if ([_selectedArray containsObject:windowHistoryPictureDto]) {
            [_selectedArray removeObject:windowHistoryPictureDto];
        }else{
            [_selectedArray addObject:windowHistoryPictureDto];
        }
        
        [self isSelectedAll];
        
    } downloadedSelectedObjectImageBlock:^{
        //选择/取消客观图
        cell.objectImageSelectedButton.selected = !cell.objectImageSelectedButton.selected;
        
        if ([_selectedArray containsObject:objectHistoryPictureDto]) {
            [_selectedArray removeObject:objectHistoryPictureDto];
        }else{
            [_selectedArray addObject:objectHistoryPictureDto];
        }
        
        [self isSelectedAll];
    }];
    
    cell.goodsNo = imageHistoryDto.goodsNo;
    
    cell.windowImageSelectedButton.selected = [_selectedArray containsObject:windowHistoryPictureDto];
    
    cell.objectImageSelectedButton.selected = [_selectedArray containsObject:objectHistoryPictureDto];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageHistoryDTO *imageHistoryDto = [self.dataArray objectAtIndex:indexPath.row];
    
    //跳转
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = imageHistoryDto.goodsNo;
    
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
    //
    //            goodsInfo.goodsNo = commodityInfo.goodsNo;
    
    GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    
    [self.navigationController pushViewController:goodsInfo animated:YES];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (!self.dataArray.count) {
        
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableView.frame.size.height)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        noDataLabel.center = footerView.center;
        noDataLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        noDataLabel.text = @"暂无历史下载记录";
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:noDataLabel];
        
        self.tableView.scrollEnabled = NO;
        
        return footerView;
        
    }
    self.tableView.scrollEnabled = YES;

    return nil;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (!self.dataArray.count) {
        
        return self.tableView.frame.size.height;
        
    }else{
        
        return 0.00001;
        
    }
}


#pragma mark-处理数据
- (NSMutableArray *)handImageInfoData{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (HistoryPictureDTO2 *historyPictureDto in _selectedArray) {
        //CSPPicInfoDTO为上传类型数据
        CSPPicInfoDTO *picInfoDto = [[CSPPicInfoDTO alloc]init];
        picInfoDto.downLoadType = historyPictureDto.picType;
        picInfoDto.goodsNo = historyPictureDto.goodsNO;
        [array addObject:picInfoDto];
    }
    return array;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-全选
- (IBAction)selectedAllButtonClick:(id)sender {
    
    
    [self changeSelectAllStatus];
    
}
-(void)changeSelectAllStatus{

    [self.selectedAllButton setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_选中"] forState:UIControlStateSelected];
    [self.selectedAllButton setImage:[UIImage imageNamed:@"10_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];
    
    
    self.selectedAllButton.selected = !self.selectedAllButton.selected;
    
    [_selectedArray removeAllObjects];
    
    if (self.selectedAllButton.selected) {
        
        for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
            
            for (HistoryPictureDTO2 *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
                [_selectedArray addObject:historyPictureDto];
            }
        }
    }
    
    [self.tableView reloadData];
    

}

#pragma mark-再次下载
- (IBAction)downloadAgainButtonClick:(id)sender {
    
    
    upArray = [[NSMutableArray alloc]init];
    
    for (CSPPicInfoDTO *picInfoDTO in [self handImageInfoData]) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:picInfoDTO.goodsNo forKey:@"goodsNo"];
        
        [dic setObject:picInfoDTO.downLoadType forKey:@"downLoadType"];
        
        [upArray addObject:dic];
    }
    
    if (upArray.count == 0) {

        [self.view makeMessage:@"请选择至少一项下载" duration:2.0 position:@"center"];

        return;
    }
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //!读取可以下载的次数
    [HttpManager sendHttpRequestForPayDownloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {

            canDownCount = [responseDic[@"data"][@"downloadNum"] integerValue];
            
            NSInteger canDownCount = [self selectAllDownload:upArray.count];
            if (canDownCount == 0) {//!次数不够
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                return ;
                
            }
            
            if (canDownCount != -1) {//!下载个数受限制
                
                NSArray * tempArray = [upArray subarrayWithRange:NSMakeRange(0, canDownCount)];
                
                upArray = [NSMutableArray arrayWithArray:tempArray];
                
            }
            //!请求下载的数据
            [self requestDownData];
            
                            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeMessage:@"网络连接失败" duration:2.0 position:@"center"];

        
    }];

    
}

#pragma mark-请求需要下载的图片的信息

-(void)requestDownData{

    
    [HttpManager sendHttpRequestForGetDownloadImageList:upArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *responseDic = [self conversionWithData:responseObject];
                
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                self.residueDownload = ((NSNumber *)[data objectForKey:@"remainCount"]).intValue;
                
                id list = [data objectForKey:@"list"];
                
                if ([self checkData:list class:[NSArray class]]) {
                    
                    [self.downloadImageArray removeAllObjects];
                    for (NSDictionary * upDic in upArray) {
                        
                        for (NSDictionary *dataDic in list) {
                            
                            if ([upDic[@"goodsNo"] isEqualToString:dataDic[@"goodsNo"]]) {
                        
                                CSPDownLoadImageDTO *downLoadImageDTO = [[CSPDownLoadImageDTO alloc]init];
                                
                                [downLoadImageDTO setDictFrom:dataDic];
                                
                                DebugLog(@"downLoadImageDTO.goodsNo = %@", downLoadImageDTO.goodsNo);
                                
                                id zips = [dataDic objectForKey:@"zips"];
                                
                                if ([self checkData:zips class:[NSArray class]]) {
                                    
                                    for (NSDictionary *dic in zips) {
                                        
                                        CSPZipsDTO *zipsDTO = [[CSPZipsDTO alloc]init];
                                        
                                        [zipsDTO setDictFrom:dic];
                                        
                                        [downLoadImageDTO.zipsList addObject:zipsDTO];
                                    }
                                }
                                
                                [self.downloadImageArray addObject:downLoadImageDTO];

                                
                            }
                            
                    
                        }
                        
                        
                        
                    }
                    
                }
                
                
            }
            
            //处理下载逻辑
            [self.view makeMessage:@"已加入下载队列" duration:2 position:@"center"];
            
            //遍历self.downloadImageArray添加到队列中
            for (CSPDownLoadImageDTO *downLoadImageDTO in self.downloadImageArray) {
                //需要优化
                NSMutableDictionary *downLoadUrlDic = [downLoadImageDTO getLoadUrlWith:downLoadImageDTO.zipsList];
                //!客观图路劲
                NSString *objectiveImgaeURL = [downLoadUrlDic objectForKey:@"1"];
                //!窗口图路劲
                NSString *windowImageURL = [downLoadUrlDic objectForKey:@"0"];
                
                NSString *pictureURL;
                
                for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
                    
                    if ([imageHistoryDto.goodsNo isEqualToString: downLoadImageDTO.goodsNo]) {
                        
                        pictureURL = imageHistoryDto.picUrl;
                    }
                }
                //数量
                NSMutableDictionary *imageItemsDic = [downLoadImageDTO getImageItemsWith:downLoadImageDTO.zipsList];
                
                NSString *objectImageItems = [imageItemsDic objectForKey:@"1"];
                
                NSString *windowImageItems = [imageItemsDic objectForKey:@"0"];
                
                DebugLog(@"~~~~~~~~~~~~~~~~~%@", downLoadImageDTO.goodsNo);
                [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downLoadImageDTO.goodsNo objectiveFigureUrl:objectiveImgaeURL objectiveFigureItems:objectImageItems windowFigureUrl:windowImageURL windowFigureItems:windowImageItems pictureUrl:pictureURL];
                
            }

            
        }else{
        
            [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        
    }];


}

#pragma mark-获取可用的下载次数
- (BOOL)isCanDownload{
    if ((self.residueDownload - [DownloadLogControl sharedInstance].downloadingItems)>=0) {
        return YES;
    }
    return NO;
}
//!点击全选按钮时候的权限判断：可以全部下载返回-1，不可以就返回可以下载的个数
-(NSInteger)selectAllDownload:(NSInteger)selectCount{
    
    NSInteger downCount = canDownCount - [DownloadLogControl sharedInstance].downloadingItems ;//!把正在下载的下载完成之后剩下的下载个数
    //!无限制下载 -->可以直接下载
    if (canDownCount == -1) {
        
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


#pragma mark-获取一共有多少条下载数据
- (void)getAllDownloadCount{
    int i = 0;
    for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
        
        for (HistoryPictureDTO2 *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
            i++;
        }
    }
    self.allDownloadCount = i;
}

- (void)isSelectedAll{
    
    if (_selectedArray.count==self.allDownloadCount) {
        self.selectedAllButton.selected = YES;
    }else{
        self.selectedAllButton.selected = NO;
    }
}

@end
