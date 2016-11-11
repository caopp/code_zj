//
//  CSPDownloadHistoryViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPDownloadHistoryViewController.h"
#import "CSPDownloadHistoryTableViewCell.h"
#import "GetHistoryDownloadListDTO.h"
#import "GetDownloadImageListDTO.h"
#import "HistoryDownloadDTO.h"
#import "UIImageView+WebCache.h"
#import "DownloadImageDTO.h"
#import "PictureDTO.h"
#import "FilesDownManage.h"

@interface CSPDownloadHistoryViewController ()<CSPDownloadHistoryCellDelegate>

@property (nonatomic,strong)GetHistoryDownloadListDTO *getHistoryDownloadListDTO;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
- (IBAction)allButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadAgainButton;
- (IBAction)downloadAgainButtonClicked:(id)sender;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation CSPDownloadHistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载历史";
    [self addCustombackButtonItem];
//    [FilesDownManage sharedFilesDownManageWithBasepath:@"DownLoad" TargetPathArr:[NSArray arrayWithObject:@"DownLoad/zip"]];
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPDownloadHistoryViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadNewHistoryList];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
            
        [weakSelf loadMoreHistoryList];
    };

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.getHistoryDownloadListDTO.historyDownloadDTOList.count == 0) {
        [self.refreshHeader beginRefreshing];
    }
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.getHistoryDownloadListDTO.historyDownloadDTOList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPDownloadHistoryTableViewCell *downloadHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownloadHistoryTableViewCell"];

    
    if (!downloadHistoryCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPDownloadHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPDownloadHistoryTableViewCell"];
        downloadHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"CSPDownloadHistoryTableViewCell"];
    }
    downloadHistoryCell.delegate = self;
    
    HistoryDownloadDTO* historyDownloadDTO = [[HistoryDownloadDTO alloc] init];
    NSDictionary *Dictionary = [self.getHistoryDownloadListDTO.historyDownloadDTOList objectAtIndex:indexPath.row];
    [historyDownloadDTO setDictFrom:Dictionary];
    
    [downloadHistoryCell.titleImageView sd_setImageWithURL:[NSURL URLWithString:historyDownloadDTO.picUrl]];
    
    BOOL isWindow = NO;
    BOOL isImpersonality = NO;
    HistoryPictureDTO *historyPictureDTO = [[HistoryPictureDTO alloc] init];
    if (historyDownloadDTO.historyPictureDTOList.count > 0) {
        
        for (NSDictionary *dic in historyDownloadDTO.historyPictureDTOList) {
            [historyPictureDTO setDictFrom:dic];
            if ([historyPictureDTO.picType isEqualToString:@"0"]) {
                downloadHistoryCell.windowTitleLabel.text = [NSString stringWithFormat:@"窗口图(%@张)",historyPictureDTO.picNum.stringValue];
                downloadHistoryCell.windowValueLabel.text = [NSString stringWithFormat:@"%.1fMB",historyPictureDTO.picSize.doubleValue/1024];
                isWindow = YES;
            }else{
                downloadHistoryCell.impersonalityTitleLabel.text = [NSString stringWithFormat:@"客观图(%@张)",historyPictureDTO.picNum.stringValue];
                downloadHistoryCell.impersonalityValueLabel.text = [NSString stringWithFormat:@"%.1fMB",historyPictureDTO.picSize.doubleValue/1024];
                isImpersonality = YES;
            }
        }
    }
    if (isWindow == NO) {
        downloadHistoryCell.windowTitleLabel.hidden = YES;
        downloadHistoryCell.windowValueLabel.hidden = YES;
        downloadHistoryCell.windowSelectedButton.hidden = YES;

    }
    if (isImpersonality == NO) {
        downloadHistoryCell.impersonalityTitleLabel.hidden = YES;
        downloadHistoryCell.impersonalityValueLabel.hidden = YES;
        downloadHistoryCell.impersonalitySelectedButton.hidden = YES;


    }

    
    return downloadHistoryCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)windowSelectClicked:(UIButton *)sender;
{
    sender.selected = !sender.selected;
}
- (void)impersonalitySelectClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)allButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
    for (int i = 0; i<self.getHistoryDownloadListDTO.historyDownloadDTOList.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        CSPDownloadHistoryTableViewCell *historyCell = (CSPDownloadHistoryTableViewCell *)cell;
        historyCell.windowSelectedButton.selected = YES;
        historyCell.impersonalitySelectedButton.selected = YES;
    }
    }else{
        button.selected = NO;
        for (int i = 0; i<self.getHistoryDownloadListDTO.historyDownloadDTOList.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            CSPDownloadHistoryTableViewCell *historyCell = (CSPDownloadHistoryTableViewCell *)cell;
            historyCell.windowSelectedButton.selected = NO;
            historyCell.impersonalitySelectedButton.selected = NO;
        }

    }
    
}
- (IBAction)downloadAgainButtonClicked:(id)sender {
    
    
    NSMutableArray *downloadArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<self.getHistoryDownloadListDTO.historyDownloadDTOList.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        CSPDownloadHistoryTableViewCell *historyCell = (CSPDownloadHistoryTableViewCell *)cell;
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        BOOL iswindowSelected = NO;
        BOOL isimpersonalitySelectd = NO;
        NSString *type;
        
        HistoryDownloadDTO* historyDownloadDTO = [[HistoryDownloadDTO alloc] init];
        NSDictionary *Dictionary = [self.getHistoryDownloadListDTO.historyDownloadDTOList objectAtIndex:i];
        [historyDownloadDTO setDictFrom:Dictionary];

        if (historyCell.windowSelectedButton.selected == YES && historyCell.windowSelectedButton.hidden == NO)
        {
            iswindowSelected = YES;
        }
        if (historyCell.impersonalitySelectedButton.selected == YES && historyCell.impersonalitySelectedButton.hidden == NO)
        {
            isimpersonalitySelectd = YES;
        }
        if (iswindowSelected == YES && isimpersonalitySelectd == YES) {
            type = @"3";
            [dic setValue:historyDownloadDTO.goodsNo forKey:@"goodsNo"];
            [dic setValue:type forKey:@"downLoadType"];
            [downloadArray addObject:dic];
        }else if(iswindowSelected == YES && isimpersonalitySelectd == NO)
        {
            type = @"0";
            [dic setValue:historyDownloadDTO.goodsNo forKey:@"goodsNo"];
            [dic setValue:type forKey:@"downLoadType"];
            [downloadArray addObject:dic];
        }else if(iswindowSelected == NO && isimpersonalitySelectd == YES)
        {
            type = @"1";
            [dic setValue:historyDownloadDTO.goodsNo forKey:@"goodsNo"];
            [dic setValue:type forKey:@"downLoadType"];
            [downloadArray addObject:dic];
        }else
        {
            
        }
    
    }
    
    
    
    
//    NSDictionary *firstImage = @{@"goodsNo":@"00000020",@"downLoadType":@"0"};
    
//    NSMutableArray *imageDownloadArray = [[NSMutableArray alloc] init];
//    [imageDownloadArray addObject:firstImage];
    
    [HttpManager sendHttpRequestForGetDownloadImageList:downloadArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            GetDownloadImageListDTO* getDownloadImageListDTO = [[GetDownloadImageListDTO alloc] init];
            DownloadImageDTO* downloadImageDTO = [[DownloadImageDTO alloc] init];
            PictureDTO *pictureDTO = [[PictureDTO alloc] init];
            
            getDownloadImageListDTO.downloadImageDTOList = [dic objectForKey:@"data"];

            
            
            long count = [getDownloadImageListDTO.downloadImageDTOList count];
            
            NSLog(@"the count is %ld",count);
            
            for( int index =0; index <count; index ++){
                NSDictionary *Dictionary = [getDownloadImageListDTO.downloadImageDTOList objectAtIndex:index];
                [downloadImageDTO setDictFrom:Dictionary];
                NSLog(@"The goodsNo is %@\n",downloadImageDTO.goodsNo);
                
                
                long picCount = [downloadImageDTO.pictureDTOList count];
                for(int index = 0;index < picCount;index ++)
                {
                    NSDictionary *Dictionary = [downloadImageDTO.pictureDTOList objectAtIndex:index];
                    [pictureDTO setDictFrom:Dictionary];
//                    [[FilesDownManage sharedFilesDownManage]downFileUrl:pictureDTO.zipUrl filename:[NSString stringWithFormat:@"%@%@",pictureDTO.picType,downloadImageDTO.goodsNo] filetarget:@"zip" fileimage:nil];
                    NSLog(@"The picSize is %@\n",pictureDTO.picSize);
                }
            }
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];

    
}


#pragma mark -
#pragma mark Getter and Setter

- (GetHistoryDownloadListDTO*)getHistoryDownloadListDTO {
    if (!_getHistoryDownloadListDTO) {
        _getHistoryDownloadListDTO = [[GetHistoryDownloadListDTO alloc]init];
    }
    return _getHistoryDownloadListDTO;
}

#pragma mark -
#pragma mark Private Methods
- (void)getHistoryListWithPageNo:(NSNumber*)pageNo  complete:(void (^)(NSNumber* totalCount, NSArray* historyList))complete {
    
    [HttpManager sendHttpRequestForGetHistoryDownloadListWithPageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            GetHistoryDownloadListDTO* historyListDTO = [[GetHistoryDownloadListDTO alloc]init];
            [historyListDTO setDictFrom:dataDict];
            
            complete(historyListDTO.totalCount, historyListDTO.historyDownloadDTOList);
        }
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
    
}

- (void)loadNewHistoryList {
    [self getHistoryListWithPageNo:@1 complete:^(NSNumber *totalCount, NSArray *historyList) {
        self.getHistoryDownloadListDTO.totalCount = totalCount;
        [self.getHistoryDownloadListDTO.historyDownloadDTOList removeAllObjects];
        [self.getHistoryDownloadListDTO.historyDownloadDTOList addObjectsFromArray:historyList];
        
        [self.tableView reloadData];
        
        [self.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreHistoryList {
//    if ([self.tableView.footer isRefreshing]) {
//        NSLog(@"isRefreshing");
//    }
    if (self.getHistoryDownloadListDTO.totalCount.integerValue <= self.getHistoryDownloadListDTO.historyDownloadDTOList.count) {
        [self.refreshFooter endRefreshing];
        return;
    }
    
    NSNumber * pageNo = [NSNumber numberWithInteger:(self.getHistoryDownloadListDTO.historyDownloadDTOList.count /pageSize) + 1];
    [self getHistoryListWithPageNo:pageNo complete:^(NSNumber *totalCount, NSArray *merchantList) {
        self.getHistoryDownloadListDTO.totalCount = totalCount;
        [self.getHistoryDownloadListDTO.historyDownloadDTOList addObjectsFromArray:merchantList];
        
        [self.tableView reloadData];
        
        [self.refreshFooter endRefreshing];
    }];
    
    
}




@end
