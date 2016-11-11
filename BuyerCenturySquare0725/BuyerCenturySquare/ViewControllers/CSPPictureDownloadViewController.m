//
//  CSPPictureDownloadViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPictureDownloadViewController.h"
#import "CSPPictureDownloadTableViewCell.h"
#import "CSPPicDownloadingTableViewCell.h"
#import "CSPDownloadHistoryViewController.h"
#import "CSPPayAndDownloadViewController.h"
#import "SMSegmentView.h"
#import "PayDownloadDTO.h"
#import "CSPPicDownloadTopCell.h"
#import "DownloadImageDTO.h"
#import "FilesDownManage.h"

@interface CSPPictureDownloadViewController ()<SMSegmentViewDelegate,CSPPicDownloadedCellDelegate,CSPPicDownloadingCellDelegate>

{
    BOOL isNoDownloadedPic;
    
}


@property (nonatomic, strong)PayDownloadDTO* payDownloadDTO;

@property (weak, nonatomic) IBOutlet UITableView *downloadedTableView;
@property (weak, nonatomic) IBOutlet UITableView *downloadingTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *historyBarButton;
- (IBAction)historyBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet SMSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *noDownloadedView;
@property (weak, nonatomic) IBOutlet UIView *noDownloadedBottomView;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDownloadedValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *noDownloadedBuyButton;
- (IBAction)noDownloadedBuyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *noDownloadHistoryButton;
- (IBAction)noDownloadHistoryButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *downloadBottomView;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
- (IBAction)cleanButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *downloadLeftCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLeftValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
- (IBAction)allSelectedButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadAgainButton;
- (IBAction)downloadAgainButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *downloadBuyButton;
- (IBAction)downloadBuyButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBottomButton;
- (IBAction)deleteBottomButtonClicked:(id)sender;




@end

@implementation CSPPictureDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品图片下载";
    self.segmentView.delegate = self;
    [self addCustombackButtonItem];
    [self.segmentView addSegmentWithTitle:@"已下载"];
    [self.segmentView addSegmentWithTitle:@"正下载"];
    [self.segmentView selectSegmentAtIndex:0];
    
    isNoDownloadedPic = NO;
    
    if (isNoDownloadedPic == YES) {
        
        self.downloadBottomView.hidden = YES;
        [HttpManager sendHttpRequestForPayDownloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    self.payDownloadDTO = [[PayDownloadDTO alloc] init];
                    
                    [self.payDownloadDTO setDictFrom:[dic objectForKey:@"data"]];
                    
                    self.noDownloadedLevelLabel.text = [NSString stringWithFormat:@"当前等级:V%@", self.payDownloadDTO.level.stringValue];
                    
                    self.noDownloadedCountLabel.text = [NSString stringWithFormat:@"免费赠送下载次数:%@次",self.payDownloadDTO.downloadNum.stringValue];
                    
                    if (self.payDownloadDTO.authFlag.intValue == 0) {
                        
                        self.noDownloadedBottomView.hidden = YES;
                        
                    }else{
                        
                        self.noDownloadedValueLabel.text = [NSString stringWithFormat:@"%@次/￥%@",self.payDownloadDTO.buyDownloadQty.stringValue,self.payDownloadDTO.buyDownloadPrice.stringValue];
                        
                    }
                    
                }
                //参数需要保存
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            
        }];
        
    }else
    {
        self.noDownloadedBottomView.hidden = YES;
        self.noDownloadedView.hidden = YES;
        self.downloadingTableView.hidden = YES;
        self.downloadedTableView.hidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    
    [filedownmanage startLoad];
    self.downingList=filedownmanage.downinglist;
    [self.downloadingTableView reloadData];
    
    self.finishedList=filedownmanage.finishedlist;
    [self.downloadedTableView reloadData];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    [filedownmanage saveFinishedFile];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.downloadedTableView]){
        return self.finishedList.count + 1;
    }else{
        return self.downingList.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.downloadedTableView]) {
        CSPPictureDownloadTableViewCell *pictureDownloadedCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPictureDownloadTableViewCell"];
        
        CSPPicDownloadTopCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPicDownloadTopCell"];
        if (!otherCell) {
            
            otherCell = [[CSPPicDownloadTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSPPicDownloadTopCell"];
        }
        
        otherCell.title.text = @"已下载完成";
        otherCell.title.frame = CGRectMake(15, (36-13)/2, 150, 13);
        
        otherCell.editButton.frame =  CGRectMake(self.view.frame.size.width-30-15, (36-13)/2, 30, 13);
        [otherCell.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [otherCell.editButton setTitle:@"完成" forState:UIControlStateSelected];
        [otherCell.editButton addTarget:self action:@selector(editButtonClikced:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if (!pictureDownloadedCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"CSPPictureDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPictureDownloadTableViewCell"];
            pictureDownloadedCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPictureDownloadTableViewCell"];
        }
        
        pictureDownloadedCell.delegate = self;
        pictureDownloadedCell.windowCleanButton.tag= indexPath.row;
        pictureDownloadedCell.windowSelectedButton.tag = indexPath.row;
        pictureDownloadedCell.impersonalityCleanButton.tag = indexPath.row;
        pictureDownloadedCell.impersonalitySelectedButton.tag = indexPath.row;
        
        if (indexPath.row == 0) {
            return otherCell;
        }else{
            return pictureDownloadedCell;
        }
        
        
    }else
    {
        
        CSPPicDownloadingTableViewCell *pictureDownloadingCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPicDownloadingTableViewCell"];
        CSPPicDownloadTopCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPicDownloadTopCell"];
        if (!otherCell) {
            
            otherCell = [[CSPPicDownloadTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSPPicDownloadTopCell"];
        }
        
        otherCell.title.hidden = YES;
        [otherCell.allStartButton setTitle:@"全部开始" forState:UIControlStateNormal];
        [otherCell.allStartButton setTitle:@"全部暂停" forState:UIControlStateSelected];
        otherCell.allStartButton.hidden = NO;
        [otherCell.allStartButton addTarget:self action:@selector(allStartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        otherCell.allStartButton.frame = CGRectMake(15, (36-13)/2, 150, 13);
        
        otherCell.editButton.frame =  CGRectMake(self.view.frame.size.width-30-15, (36-20)/2, 30, 20);
        [otherCell.editButton setTitle:@"完成" forState:UIControlStateSelected];
        [otherCell.editButton setImage:[UIImage imageNamed:@"10_商品图片下载_删除.png"] forState:UIControlStateNormal];
        [otherCell.editButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
        [otherCell.editButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if (!pictureDownloadingCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"CSPPicDownloadingTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPicDownloadingTableViewCell"];
            pictureDownloadingCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPicDownloadingTableViewCell"];
        }
        pictureDownloadingCell.delegate = self;
        
    
        if (indexPath.row == 0) {
            return otherCell;
        }else{
            DownloadImageDTO* downloadImageDTO = [[DownloadImageDTO alloc] init];

//            NSDictionary *Dictionary = [self.downloadingArray objectAtIndex:indexPath.row-1];
//            [downloadImageDTO setDictFrom:Dictionary];
//            
            
            
            PictureDTO *pictureDTO = [[PictureDTO alloc] init];
            
            long picCount = [downloadImageDTO.pictureDTOList count];
            
            if (picCount == 1) {
                NSDictionary *Dictionary = [downloadImageDTO.pictureDTOList objectAtIndex:0];
                [pictureDTO setDictFrom:Dictionary];
                if ([pictureDTO.picType isEqualToString:@"0"]) {
                    pictureDownloadingCell.windowTitlelabel.text = [NSString stringWithFormat:@"窗口图(%@)",pictureDTO.qty];
//                    pictureDownloadingCell.windowValueLabel.text = [NSString stringWithFormat:@"%.1fMB",pictureDTO.picSize.doubleValue/1024];
                    
//                    [pictureDownloadingCell downloadZipWith:pictureDTO];
                    pictureDownloadingCell.impersonalityTitleLabel.hidden = YES;
                    pictureDownloadingCell.impersonalityRateLabel.hidden = YES;
                    pictureDownloadingCell.impersonalityProgressView.hidden = YES;
                    pictureDownloadingCell.impersonalityProgressLabel.hidden = YES;
                    pictureDownloadingCell.impersonalityPauseButton.hidden = YES;
                    pictureDownloadingCell.impersonalitySelectedButton.hidden = YES;
                }
                else{
                    pictureDownloadingCell.impersonalityTitleLabel.text = [NSString stringWithFormat:@"客观图(%@)",pictureDTO.qty];
//                    pictureDownloadingCell.impersonalityValueLabel.text = [NSString stringWithFormat:@"%.1fMB",pictureDTO.picSize.doubleValue/1024];
//                    [pictureDownloadingCell downloadZipWith:pictureDTO];
                    
                    pictureDownloadingCell.windowTitlelabel.hidden = YES;
                    pictureDownloadingCell.windowRateLabel.hidden = YES;
                    pictureDownloadingCell.windowProgressView.hidden = YES;
                    pictureDownloadingCell.windowProgressLabel.hidden = YES;
                    pictureDownloadingCell.windowPauseButton.hidden = YES;
                    pictureDownloadingCell.windowSelcetedButton.hidden = YES;
                }
            }else{
                
//                [pictureDownloadingCell downloadZipsWith:downloadImageDTO];
                
                for(int index = 0;index < picCount;index ++)
                {
                    NSDictionary *Dictionary = [downloadImageDTO.pictureDTOList objectAtIndex:index];
                    [pictureDTO setDictFrom:Dictionary];
                    if ([pictureDTO.picType isEqualToString:@"0"]) {
                        pictureDownloadingCell.windowTitlelabel.text = [NSString stringWithFormat:@"窗口图(%@)",pictureDTO.qty];
//                        pictureDownloadingCell.windowValueLabel.text = [NSString stringWithFormat:@"%.1fMB",pictureDTO.picSize.doubleValue/1024];
                    }
                    else{
                        pictureDownloadingCell.impersonalityTitleLabel.text = [NSString stringWithFormat:@"客观图(%@)",pictureDTO.qty];
//                        pictureDownloadingCell.impersonalityValueLabel.text = [NSString stringWithFormat:@"%.1fMB",pictureDTO.picSize.doubleValue/1024];
                    }
                    
                }
                
                
            }
            
            return pictureDownloadingCell;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.downloadedTableView]) {
        
        if (indexPath.row == 0) {
            return 36;
        }else{
            return 80;
        }
        
    }else{
        if (indexPath.row == 0) {
            return 36;
        }else{
            return 102;
        }
        
    }
    
}

#pragma mark -
#pragma mark SMSegemntViewDelegate

- (void)segmentView:(SMSegmentView*)segmentView didSelectSegmentAtIndex:(NSInteger)index {
    if (index == 0) {
        self.downloadedTableView.hidden = NO;
        self.downloadingTableView.hidden = YES;
        
    } else {
        self.downloadedTableView.hidden = YES;
        self.downloadingTableView.hidden = NO;
    }
    
}




- (IBAction)historyBarButtonClicked:(id)sender {
    
    CSPDownloadHistoryViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPDownloadHistoryViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}
- (IBAction)noDownloadedBuyButton:(id)sender {
    
    CSPPayAndDownloadViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAndDownloadViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)noDownloadHistoryButtonClicked:(id)sender {
    
    CSPDownloadHistoryViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPDownloadHistoryViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)cleanButtonClicked:(id)sender {
    self.noDownloadedBottomView.hidden = NO;
    self.downloadBottomView.hidden = YES;
    self.noDownloadedView.hidden = NO;
    self.noDownloadedTitleLabel.text = @"列表已清空";
    self.noDownloadedLevelLabel.text = @"可到商品详情页继续下载新的图片";
    self.noDownloadedCountLabel.hidden = YES;
}
- (IBAction)allSelectedButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        if (self.downloadedTableView.hidden == NO) {
            for (int i = 1; i<3; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell = [self.downloadedTableView cellForRowAtIndexPath:index];
                CSPPictureDownloadTableViewCell *downloadedCell = (CSPPictureDownloadTableViewCell *)cell;
                downloadedCell.windowSelectedButton.selected = YES;
                downloadedCell.impersonalitySelectedButton.selected = YES;
            }
        }else
        {
            for (int i = 1; i<3; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell = [self.downloadingTableView cellForRowAtIndexPath:index];
                CSPPicDownloadingTableViewCell *downloadedCell = (CSPPicDownloadingTableViewCell *)cell;
                downloadedCell.windowSelcetedButton.selected = YES;
                downloadedCell.impersonalitySelectedButton.selected = YES;
            }
            
        }
        
    }else
    {
        button.selected = NO;
        if (self.downloadedTableView.hidden == NO) {
            for (int i = 1; i<3; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell = [self.downloadedTableView cellForRowAtIndexPath:index];
                CSPPictureDownloadTableViewCell *downloadedCell = (CSPPictureDownloadTableViewCell *)cell;
                downloadedCell.windowSelectedButton.selected = NO;
                downloadedCell.impersonalitySelectedButton.selected = NO;
            }
        }else
        {
            for (int i = 1; i<3; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell = [self.downloadingTableView cellForRowAtIndexPath:index];
                CSPPicDownloadingTableViewCell *downloadedCell = (CSPPicDownloadingTableViewCell *)cell;
                downloadedCell.windowSelcetedButton.selected = NO;
                downloadedCell.impersonalitySelectedButton.selected = NO;
            }
            
        }
        
    }
    
}
- (IBAction)downloadAgainButtonClicked:(id)sender {
}
- (IBAction)downloadBuyButtonClicked:(id)sender {
    CSPPayAndDownloadViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAndDownloadViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)deleteBottomButtonClicked:(id)sender {
    self.noDownloadedBottomView.hidden = NO;
    self.downloadBottomView.hidden = YES;
    self.noDownloadedView.hidden = NO;
    self.noDownloadedTitleLabel.text = @"暂无正在下载的商品图片";
    self.noDownloadedLevelLabel.text = @"可继续下载新的商品";
    self.noDownloadedCountLabel.text = @"或到下载历史中再次下载原来的商品";
    self.noDownloadHistoryButton.hidden = NO;
    
}

- (void)editButtonClikced:(UIButton *)sender
{
    if (sender.selected == NO) {
        
        sender.selected = YES;
        for (int i = 1; i<3; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.downloadedTableView cellForRowAtIndexPath:index];
            CSPPictureDownloadTableViewCell *downloadedCell = (CSPPictureDownloadTableViewCell *)cell;
            downloadedCell.windowCleanButton.hidden = YES;
            downloadedCell.windowSelectedButton.hidden = NO;
            downloadedCell.impersonalityCleanButton.hidden = YES;
            downloadedCell.impersonalitySelectedButton.hidden = NO;
            downloadedCell.windowAgainButton.hidden = YES;
            downloadedCell.impersonalityAgainButton.hidden = YES;
        }
        
        self.cleanButton.hidden = NO;
        self.downloadLeftCountLabel.hidden = YES;
        self.downloadLeftValueLabel.hidden = YES;
        self.allSelectedButton.hidden = NO;
        self.allLabel.hidden = NO;
        self.downloadAgainButton.hidden = NO;
        self.downloadBuyButton.hidden = YES;
    }else
    {
        sender.selected = NO;
        for (int i = 1; i<3; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.downloadedTableView cellForRowAtIndexPath:index];
            CSPPictureDownloadTableViewCell *downloadedCell = (CSPPictureDownloadTableViewCell *)cell;
            downloadedCell.windowCleanButton.hidden = NO;
            downloadedCell.windowSelectedButton.hidden = YES;
            downloadedCell.impersonalityCleanButton.hidden = NO;
            downloadedCell.impersonalitySelectedButton.hidden = YES;
            downloadedCell.windowAgainButton.hidden = NO;
            downloadedCell.impersonalityAgainButton.hidden = NO;
        }
        self.cleanButton.hidden = YES;
        self.downloadLeftCountLabel.hidden = NO;
        self.downloadLeftValueLabel.hidden = NO;
        self.allSelectedButton.hidden = YES;
        self.allLabel.hidden = YES;
        self.downloadAgainButton.hidden = YES;
        self.downloadBuyButton.hidden = NO;
    }
    
}

- (void)deleteButtonClicked:(UIButton *)sender
{
    if (sender.selected == NO) {
        
        sender.selected = YES;
        for (int i = 1; i<3; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.downloadingTableView cellForRowAtIndexPath:index];
            CSPPicDownloadingTableViewCell *downloadedCell = (CSPPicDownloadingTableViewCell *)cell;
            downloadedCell.windowPauseButton.hidden = YES;
            downloadedCell.windowSelcetedButton.hidden = NO;
            downloadedCell.impersonalityPauseButton.hidden = YES;
            downloadedCell.impersonalitySelectedButton.hidden = NO;
            
        }
    
        self.downloadLeftCountLabel.hidden = YES;
        self.downloadLeftValueLabel.hidden = YES;
        self.allSelectedButton.hidden = NO;
        self.allLabel.hidden = NO;
        self.downloadBuyButton.hidden = YES;
        self.deleteBottomButton.hidden = NO;
    }else
    {
        sender.selected = NO;
        for (int i = 1; i<3; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.downloadingTableView cellForRowAtIndexPath:index];
            CSPPicDownloadingTableViewCell *downloadedCell = (CSPPicDownloadingTableViewCell *)cell;
            downloadedCell.windowPauseButton.hidden = NO;
            downloadedCell.windowSelcetedButton.hidden = YES;
            downloadedCell.impersonalityPauseButton.hidden = NO;
            downloadedCell.impersonalitySelectedButton.hidden = YES;
            
        }
        self.downloadLeftCountLabel.hidden = NO;
        self.downloadLeftValueLabel.hidden = NO;
        self.allSelectedButton.hidden = YES;
        self.allLabel.hidden = YES;
        self.downloadBuyButton.hidden = NO;
        self.deleteBottomButton.hidden = YES;
    }
    
}

-(void)allStartButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark--
#pragma CSPPicDownloadedCellDelegate

- (void)windowAgainClicked:(UIButton *)sender
{
    
}
- (void)windowCleanClicked:(UIButton *)sender
{
    
}
- (void)windowSelectedClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)impersonalityClicked:(UIButton *)sender
{
    
}
- (void)impersonalityCleanClicked:(UIButton *)sender
{
    
}
- (void)impersonalitySelectedClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark--
#pragma CSPPicdDownloadingCellDelegate
- (void)windowSelected2Clicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)windowPauseClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)impersonalitySelectedCliced:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)impersonalityPauseClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)didReceiveMemoryWarning{

     [super didReceiveMemoryWarning];

    
}


@end
