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

#import "CPSGoodsDetailsPreviewViewController.h"

#import "GUAAlertView.h"

#import "SDRefresh.h"

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
    
    NSInteger _pageSize;
    
    BOOL _isRefresh;
    
    NSMutableArray *_selectedArray;
    
    NSInteger canDownCount;//!可以下载的次数
    NSMutableArray * selectArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"下载历史";
    
    _pageNO = 1;
    
    [self customBackBarButton];
    
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
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];

    self.refreshFooter = refreshFooter;
    
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

#pragma mark-请求下载历史数据
- (void)requestHistoryDownloadImage:(SDRefreshView *)refresh{
    
    if (refresh == self.refreshHeader) {
        
        _pageNO = 1;
        
        _pageSize = 20;
        
    }else{
    
        _pageNO = _pageNO +1;
    
    }

    
    [HttpManager sendHttpRequestForGetImageHistoryList:[NSNumber numberWithInteger:_pageNO] pageSize:[NSNumber numberWithInteger:_pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        if (refresh == self.refreshHeader) {
            
            [self.dataArray removeAllObjects];

        }
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            DownloadHistoryDTO *downloadHistoryDTO = [[DownloadHistoryDTO alloc]init];
            
            [downloadHistoryDTO setDictFrom:data];
            
            id list = [data objectForKey:@"list"];
            
            for (NSDictionary *dic in list) {
                
                ImageHistoryDTO *imageHistoryDTO = [[ImageHistoryDTO alloc]init];
                
                [imageHistoryDTO setDictFrom:dic];
                
                id dataList = [dic objectForKey:@"list"];
                
                for (NSDictionary *listDic in dataList) {
                    
                    HistoryPictureDTO *historyPictureDTO = [[HistoryPictureDTO alloc]init];
                    
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
            
            if (listArray.count < _pageSize) {
                
                [self.refreshFooter noDataRefresh];
                
            }

            
            [self.tableView reloadData];
            
            [self getAllDownloadCount];
            
            
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
        
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];

        
    }];
    
    
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
    
    //控制是下载历史页面还是商品图片下载页面
    cell.viewControllerType = DownloadHistoryViewController;
    
    ImageHistoryDTO *imageHistoryDto = [self.dataArray objectAtIndex:indexPath.row];
    
    HistoryPictureDTO *windowHistoryPictureDto;
    
    HistoryPictureDTO *objectHistoryPictureDto;
    
    for (HistoryPictureDTO *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageHistoryDTO *imageHistoryDto = [self.dataArray objectAtIndex:indexPath.row];
    
    //跳转
    CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
    
    goodsDetailsPreviewViewController.isPreview = NO;
    
    goodsDetailsPreviewViewController.noGoodsListView = YES;
    
    goodsDetailsPreviewViewController.goodsNo = imageHistoryDto.goodsNo;
    
    [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-全选
- (IBAction)selectedAllButtonClick:(id)sender {
    
    self.selectedAllButton.selected = !self.selectedAllButton.selected;
    
    [_selectedArray removeAllObjects];
    
    if (self.selectedAllButton.selected) {
        
        for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
            
            for (HistoryPictureDTO *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
                [_selectedArray addObject:historyPictureDto];
            }
        }
    }
    
    [self.tableView reloadData];

}

#pragma mark-处理数据
- (NSMutableArray *)handImageInfoData{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (HistoryPictureDTO *historyPictureDto in _selectedArray) {
        //CSPPicInfoDTO为上传类型数据
        CSPPicInfoDTO *picInfoDto = [[CSPPicInfoDTO alloc]init];
        picInfoDto.downLoadType = historyPictureDto.picType;
        picInfoDto.goodsNo = historyPictureDto.goodsNO;
        [array addObject:picInfoDto];
    }
    return array;
}

#pragma mark-再次下载
- (IBAction)downloadAgainButtonClick:(id)sender {
    
    
    selectArray = [NSMutableArray arrayWithCapacity:0];
    
    for (CSPPicInfoDTO *picInfoDTO in [self handImageInfoData]) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:picInfoDTO.goodsNo forKey:@"goodsNo"];
        
        [dic setObject:picInfoDTO.downLoadType forKey:@"downLoadType"];
        
        [selectArray addObject:dic];
        
        DebugLog(@"~~~~%@", picInfoDTO.goodsNo);
    }
    
    if (selectArray.count == 0) {
        
        [self.view makeMessage:@"请选择至少一项下载" duration:2.0 position:@"center"];

        return;
    }
    
    //!请求剩下的下载次数
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetPayMerchantDownload:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *dic = [self conversionWithData:responseObject];
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            canDownCount = [dic[@"data"][@"downloadNum"] intValue];
            
            //判断下载次数
            canDownCount = [self isCanDownloads:selectArray.count];
            if (canDownCount == 0) {//!无下载次数
                
                return ;
                
            }else if (canDownCount != -1){//!-1是选择的个数没有超过可以下载的个数
                
                NSArray * tempArray = [selectArray subarrayWithRange:NSMakeRange(0, canDownCount)]
                ;
              
                selectArray = [NSMutableArray arrayWithArray:tempArray];
                
            }
            
            [self requesDownloadData];

            
        }else{
        

            [self.view makeMessage:dic[ERRORMESSAGE] duration:2.0 position:@"center"];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self.view makeMessage:@"获取失败" duration:2.0 position:@"center"];

    }];
    
    
}
#pragma mark-请求需要下载的图片的信息

-(void)requesDownloadData{

    
    [HttpManager sendHttpRequestForGetDownloadImageList:selectArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSDictionary class]]) {
                
                //!把选中的下载完成之后，剩余的下载次数
                self.residueDownload = ((NSNumber *)[data objectForKey:@"remainCount"]).intValue;
                
                id list = [data objectForKey:@"list"];

                [self.downloadImageArray removeAllObjects];

                 for (NSDictionary * goodsNoDic in selectArray) {//!服务器给的顺序和传入的顺序不一致，所以要重新排序

                     if ([self checkData:list class:[NSArray class]]) {
                    
                        for (NSDictionary *dataDic in list) {
                            
                            if ([dataDic[@"goodsNo"] isEqualToString:goodsNoDic[@"goodsNo"]]) {
                                
                                CSPDownLoadImageDTO *downLoadImageDTO = [[CSPDownLoadImageDTO alloc]init];
                                
                                [downLoadImageDTO setDictFrom:dataDic];
                                
                                id zips = [dataDic objectForKey:@"zips"];
                                
                                if ([self checkData:zips class:[NSArray class]]) {
                                    
                                    for (NSDictionary *dic in zips) {
                                        
                                        if ([dic[@"picType"] intValue] == [goodsNoDic[@"downLoadType"] intValue]) {
                                            
                                            CSPZipsDTO *zipsDTO = [[CSPZipsDTO alloc]init];
                                            
                                            [zipsDTO setDictFrom:dic];
                                            
                                            [downLoadImageDTO.zipsList addObject:zipsDTO];
                                            
                                            DebugLog(@"downLoadImageDTO：~~~~%@", downLoadImageDTO.goodsNo);

                                            [self.downloadImageArray addObject:downLoadImageDTO];

                                            break;
                                        }
                                       
                                    }
                                }


                                break;
                            
                            }
                           
                        
                        }
                        
                        
                    }
                
                    
                }
            }
            
            //处理下载逻辑
            //遍历self.downloadImageArray添加到队列中
            for (CSPDownLoadImageDTO *downLoadImageDTO in self.downloadImageArray) {
                //需要优化
                NSMutableDictionary *downLoadUrlDic = [downLoadImageDTO getLoadUrlWith:downLoadImageDTO.zipsList];
                
                NSString *objectiveImgaeURL = [downLoadUrlDic objectForKey:@"1"];
                
                NSString *windowImageURL = [downLoadUrlDic objectForKey:@"0"];
                
                NSString *pictureURL;
                
                for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
                    
                    if ([imageHistoryDto.goodsNo isEqualToString: downLoadImageDTO.goodsNo]) {
                        
                        pictureURL = imageHistoryDto.picUrl;
                       
                        break;
                    }
                }
                //数量
                NSMutableDictionary *imageItemsDic = [downLoadImageDTO getImageItemsWith:downLoadImageDTO.zipsList];
                
                NSString *objectImageItems = [imageItemsDic objectForKey:@"1"];
                
                NSString *windowImageItems = [imageItemsDic objectForKey:@"0"];
                
                DebugLog(@"!!!!!!!!!!downLoadImageDTO:%@", downLoadImageDTO.goodsNo);


                [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downLoadImageDTO.goodsNo objectiveFigureUrl:objectiveImgaeURL objectiveFigureItems:objectImageItems windowFigureUrl:windowImageURL windowFigureItems:windowImageItems pictureUrl:pictureURL];
                
            }
            
            [self.view makeMessage:@"已加入下载队列" duration:2.0 position:@"center"];

            
        }else if([[responseDic objectForKey:@"code"]isEqualToString:@"120"]){
            
            [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
            
            
        }else{
            
            [self.view makeMessage:@"获取失败" duration:2.0 position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self.view makeMessage:@"获取失败" duration:2.0 position:@"center"];

        
    }];


}



#pragma mark-获取可用的下载次数
- (BOOL)isCanDownload{
    
    if ((self.residueDownload - [DownloadLogControl sharedInstance].downloadingItems)>=0) {
        return YES;
    }
    return NO;


}
//!选中的全部可以下载 返回-1；可以下载次数为0，返回0；否则返回下载次数
-(NSInteger)isCanDownloads:(NSInteger)selectCount{

    //!先减去在 正在下载列表中的个数 - 选中的下载个数
    NSInteger downCount = canDownCount - [DownloadLogControl sharedInstance].downloadingItems;
    
    //!无限制下载 -->可以直接下载
    if (canDownCount == -1) {
        
        return -1;
        
        
    }else if (downCount >= selectCount) {
        //选择下载的个数 <= 下载次数 ---->可以直接下载
        
        return -1;
        
    }else if(downCount <= 0){
        
        [self.view makeMessage:@"您下载次数不够" duration:2.0 position:@"center"];
        
        return 0;
        
    }else if(downCount < selectCount){//!不可以全部下载，返回可以下载的个数
    
        NSString * message = [NSString stringWithFormat:@"已选择%ld个下载项，超出了您的剩余下载次数。已将其中%ld个加入下载队列。",selectCount,downCount];
        
        GUAAlertView * alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:nil];
        
        [alertView show];
        
        
        return downCount;//!返回可以下载的个数
    
    
    }
    
    return 0;

}

#pragma mark-获取一共有多少条下载数据
- (void)getAllDownloadCount{
    int i = 0;
    for (ImageHistoryDTO *imageHistoryDto in self.dataArray) {
        
        for (HistoryPictureDTO *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
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
