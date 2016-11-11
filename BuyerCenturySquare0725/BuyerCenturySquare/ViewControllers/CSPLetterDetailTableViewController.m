//
//  CSPLetterDetailTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPLetterDetailTableViewController.h"
#import "CSPLetterSentTableViewCell.h"
#import "CSPLetterDetailViewController.h"
#import "GetMemberNoticeInfoListDTO.h"
#import "MemberNoticeDTO.h"
#import "GetMemberNoticeListDTO.h"
#import "CSPUtils.h"
#import "UIImageView+WebCache.h"
#import "TitleZoneGoodsTableViewCell.h"
@interface CSPLetterDetailTableViewController ()

@property (nonatomic,strong) GetMemberNoticeListDTO *getMemberNoticeListDTO;
@property (nonatomic, weak)  SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak)  SDRefreshFooterView *refreshFooter;

@end

@implementation CSPLetterDetailTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"站内信";
    [self addCustombackButtonItem];
    
    SDRefreshHeaderView* refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPLetterDetailTableViewController * weakSelf = self;
    self.refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadNewLetterList];
    };
    
//    // 进入页面自动加载一次数据
//    [self.refreshHeader beginRefreshing];
    
    SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
            
        [weakSelf loadMoreLetterList];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.getMemberNoticeListDTO.memberNoticeDTOlist.count == 0) {
        [self.refreshHeader beginRefreshing];
    }
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // 进入页面自动加载一次数据
    [self.refreshHeader beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    NSLog(@"洪水来了");
}
#pragma mark -
#pragma mark Getter and Setter

- (GetMemberNoticeListDTO*)getMemberNoticeListDTO {
    if (!_getMemberNoticeListDTO) {
        _getMemberNoticeListDTO = [[GetMemberNoticeListDTO alloc]init];
    }
    return _getMemberNoticeListDTO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    if (self.getMemberNoticeListDTO.memberNoticeDTOlist.count) {
        return self.getMemberNoticeListDTO.memberNoticeDTOlist.count;
    }else{
   
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.getMemberNoticeListDTO.memberNoticeDTOlist.count) {
        CSPLetterSentTableViewCell *lettersendCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLetterSentTableViewCell"];
        
        
        if (!lettersendCell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"CSPLetterSentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPLetterSentTableViewCell"];
            lettersendCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLetterSentTableViewCell"];
            
        }
        
        CGRect cellFrame = lettersendCell.frame;
        cellFrame.origin = CGPointMake(0, 0);
        
        MemberNoticeDTO* memberNoticeDTO = [[MemberNoticeDTO alloc] init];
        NSDictionary *dic = self.getMemberNoticeListDTO.memberNoticeDTOlist[indexPath.section];
        [memberNoticeDTO setDictFrom:dic];
        
        if ([memberNoticeDTO.listPic isEqualToString:@""])
        {
            lettersendCell.titleImageView.hidden = YES;
            lettersendCell.labelConstraint.constant = 10;
            lettersendCell.imageViewConstraint.constant = 10;
            
            cellFrame.size.height = 122;
        }else{
            lettersendCell.titleImageView.hidden = NO;
            cellFrame.size.height = 274;
            lettersendCell.labelConstraint.constant = 167;
            lettersendCell.imageViewConstraint.constant = 167;
            [lettersendCell.titleImageView sd_setImageWithURL:[NSURL URLWithString:memberNoticeDTO.listPic]placeholderImage:[UIImage imageNamed:@"merchant_placeholder"]];
        }
        
        [lettersendCell setFrame:cellFrame];
        
        lettersendCell.titleLabel.text = memberNoticeDTO.infoTitle;
        lettersendCell.contentLabel.text = memberNoticeDTO.infoContent;
        lettersendCell.timeLabel.text = [CSPUtils converDateFormatString:memberNoticeDTO.sendTime];
        
        //小红点
        if ([memberNoticeDTO.readStatus isEqualToString:@"1"]) {
            lettersendCell.sendImageView.image = [UIImage imageNamed:@"bell_red"];
        }else{
            lettersendCell.sendImageView.image = [UIImage imageNamed:@"bell.png"];
            
        }
        
        return lettersendCell;
    }else{
    
        TitleZoneGoodsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        
        
        cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.titleLabel.text = @"暂无相关站内信";
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        
        
        return cell;
    }
   
       
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.getMemberNoticeListDTO.memberNoticeDTOlist.count == 0) return;
    MemberNoticeDTO* memberNoticeDTO = [[MemberNoticeDTO alloc] init];
    NSDictionary *dic = self.getMemberNoticeListDTO.memberNoticeDTOlist[indexPath.section];
    [memberNoticeDTO setDictFrom:dic];
    if ([memberNoticeDTO.readStatus isEqualToString:@"1"]) {
        if (self.returnTextBlock != nil) {
            self.returnTextBlock();
        }
    }
    CSPLetterDetailViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailViewController"];
    nextVC.memberNoticeDTO = memberNoticeDTO;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.getMemberNoticeListDTO.memberNoticeDTOlist.count) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return self.view.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}




#pragma mark -
#pragma mark Private Methods
- (void)getLetterListWithPageNo:(NSNumber*)pageNo  complete:(void (^)(NSNumber* totalCount, NSArray* listArray))complete {
    
//    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:nil pageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSDictionary* dataDict = [dic objectForKey:@"data"];
//            
//            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
//            
//            complete(merchantListDTO.totalCount, merchantListDTO.merchantList);
//        }
//        
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
//        
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//    }];
    
    [HttpManager sendHttpRequestForGetMemberNoticeListWithPageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberNoticeListDTO* getMemberNoticeListDTO = [[GetMemberNoticeListDTO alloc] init];
                
                [getMemberNoticeListDTO setDictFrom:[dic objectForKey:@"data"]];
                complete(getMemberNoticeListDTO.totalCount,getMemberNoticeListDTO.memberNoticeDTOlist);

            }
            //
                    [self.refreshHeader endRefreshing];
                    [self.refreshFooter endRefreshing];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        
        [self.view makeMessage:@"网络连接异常"  duration:2.0f position:@"center"];

        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
    
}

- (void)loadNewLetterList {
    [self getLetterListWithPageNo:@1 complete:^(NSNumber *totalCount, NSArray *listArray) {
        self.getMemberNoticeListDTO.totalCount = totalCount;
        [self.getMemberNoticeListDTO.memberNoticeDTOlist removeAllObjects];
        [self.getMemberNoticeListDTO.memberNoticeDTOlist addObjectsFromArray:listArray];
        
        [self.tableView reloadData];
        
        [self.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreLetterList {
//    if ([self.tableView.footer isRefreshing]) {
//        NSLog(@"isRefreshing");
//    }
    if (self.getMemberNoticeListDTO.totalCount.integerValue <= self.getMemberNoticeListDTO.memberNoticeDTOlist.count) {
        [self.refreshFooter noDataRefresh];
        return;
    }
    
    NSNumber * pageNo = [NSNumber numberWithInteger:(self.getMemberNoticeListDTO.memberNoticeDTOlist.count /pageSize) + 1];
    [self getLetterListWithPageNo:pageNo complete:^(NSNumber *totalCount, NSArray *listArray) {
        self.getMemberNoticeListDTO.totalCount = totalCount;
        [self.getMemberNoticeListDTO.memberNoticeDTOlist addObjectsFromArray:listArray];
        
        [self.tableView reloadData];
        
        [self.refreshFooter endRefreshing];
    }];
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

@end
