//
//  AuditSearchViewController.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AuditSearchViewController.h"
#import "SearchGoodsTableViewCell.h"
#import "SearchMemberTableViewCell.h"
#import "MemberMoreViewController.h"
#import "GoodsMoreViewController.h"
#import "GoodsShareDTO.h"
#import "NoContentTableViewCell.h"
@interface AuditSearchViewController ()
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong,nonatomic)NSMutableArray *arrSeller;
@property (strong,nonatomic)NSMutableArray *arrGoods;
@property (assign,nonatomic)int pageNo;
@end

@implementation AuditSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"审核搜索";
    _searchType = SearchTypeSeller;
    _searchTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self createBar];
    [self createRefresh];
    _pageNo = 1;
    [self customBackBarButton];
    _arrGoods = [[NSMutableArray alloc] initWithCapacity:0];
    _arrSeller = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self requestData:self.refreshHeader];
}

//!创建刷新
-(void)createRefresh{
    
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:_searchTableView];
    
    self.refreshHeader = refreshHeader;
    
    __weak AuditSearchViewController * refreshTable = self;
    
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [refreshTable requestData:self.refreshHeader];
        
    };
    
    //!底部
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    
    [refreshFooter addToScrollView:_searchTableView];
    
    self.refreshFooter = refreshFooter;
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [refreshTable requestData:self.refreshFooter];
    };
    
}



-(void)createBar{
    for (UIView *subview in _searchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                NSLog(@"Keep textfiedld bkg color");
            }else{
                grandSonView.alpha = 0.0f;
            }
        }//for cacheViews
    }//subviews
}
#pragma mark 请求数据
-(void)requestData:(SDRefreshView *)refresh{
    if (refresh == self.refreshHeader) {
        
        _pageNo = 1;
        [_arrGoods removeAllObjects];
        [_arrSeller removeAllObjects];
        
        
    }else{
        
        _pageNo = _pageNo +1;
        
    }
    if (_searchType ==SearchTypeGoods) {
        [HttpManager sendHttpRequestForGoodsListWtihtQueryParam:_searchBar.text  pageNo:[NSNumber numberWithInt:_pageNo] pageSize:[NSNumber numberWithInt:20] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([responseDic[@"code"] isEqualToString:@"000"]) {
                for (NSDictionary *dic in responseDic[@"data"][@"list"]) {
                    GoodsShareDTO *shareDTO = [[GoodsShareDTO alloc] init];
                    [shareDTO setDictFrom:dic];
                    [_arrGoods addObject:shareDTO];
                }
            }
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            
            if (_arrGoods.count < 20) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            [_searchTableView reloadData];

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }];
    }else{
        [HttpManager sendHttpRequestForMemberListWtihtQueryParam:_searchBar.text  pageNo:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:20] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([responseDic[@"code"] isEqualToString:@"000"]) {
                [_arrSeller removeAllObjects];

                for (NSDictionary *dic in responseDic[@"data"][@"list"]) {
                    GoodsShareDTO *shareDTO = [[GoodsShareDTO alloc] init];
                    [shareDTO setDictFrom:dic];
                    shareDTO.totalCount = responseDic[@"data"][@"totalCount"];
                    [_arrSeller addObject:shareDTO];
                    
                }
                
            }
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            
            if (_arrSeller.count < 20) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            [_searchTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }];
    }
    
    
    
}

#pragma mark - EVENT TOUCH
- (IBAction)changeSearchType:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
    sender.selected = YES;
    if (sender.tag == 101) {//按商家
        UIButton *btnSender = [self.view viewWithTag:102];
        btnSender.backgroundColor = [UIColor colorWithHex:0x2b2b2b];
        btnSender.selected = NO;
        _searchBar.placeholder = @"请输入用户昵称/账号";
    }else{
        UIButton *btnSender = [self.view viewWithTag:101];
        btnSender.backgroundColor = [UIColor colorWithHex:0x2b2b2b];
        btnSender.selected = NO;
        _searchBar.placeholder = @"请输入货号/商品名称";
    }
    _searchBar.text = @"";
    [self.view endEditing:YES];
    _pageNo = 1;
    _searchType = sender.tag - 100;
    //[_searchTableView reloadData];
    [self requestData:self.refreshHeader];
}
#pragma mark UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestData:self.refreshHeader];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_searchType == SearchTypeGoods) {
        if (_arrGoods.count) {
            return _arrGoods.count;

        }else{
            return 1;
        }
    }else{
        if (_arrSeller.count) {
            return _arrSeller.count;
            
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSPBaseTableViewCell *cell;
    if (_searchType == SearchTypeGoods) {
        if (!_arrGoods.count) {
            cell = [self createNoContentTableViewCell:indexPath withTable:tableView];
        }else
            cell = [self createSearchGoodsTableViewCell:indexPath withTable:tableView];
    }else{
        if (!_arrSeller.count) {
            cell = [self createNoContentTableViewCell:indexPath withTable:tableView];
        }else
            cell = [self createSearchMemberTableViewCell:indexPath withTable:tableView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchType == SearchTypeGoods) {
        if (!_arrGoods.count) {
            return;
        }
        GoodsShareDTO *dto = [_arrGoods objectAtIndex:indexPath.row];
        
        GoodsMoreViewController *goodsMore = [[GoodsMoreViewController alloc] initWithNibName:@"GoodsMoreViewController" bundle:nil];
        goodsMore.goodsDTO = dto;
        [self.navigationController pushViewController:goodsMore animated:YES];
    }else{
        if (!_arrSeller.count) {
            return;
        }
        GoodsShareDTO *shareDTO = [_arrSeller objectAtIndex:indexPath.row];
        MemberMoreViewController *memberMore = [[MemberMoreViewController alloc] initWithNibName:@"MemberMoreViewController" bundle:nil];
        memberMore.userDTO = shareDTO;
        [self.navigationController pushViewController:memberMore animated:YES];
    }
}
#pragma  mark create TableViewCell

-(CSPBaseTableViewCell *)createSearchGoodsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    SearchGoodsTableViewCell*toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchGoodsTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SearchGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchGoodsTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchGoodsTableViewCell"];
    }
    GoodsShareDTO *goodsDTO = [_arrGoods objectAtIndex:index.row];
    [toolCell loadDTO:goodsDTO];
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return toolCell;
}


-(CSPBaseTableViewCell *)createSearchMemberTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    SearchMemberTableViewCell*toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchMemberTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SearchMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchMemberTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchMemberTableViewCell"];
    }
    GoodsShareDTO *goodsDTO = [_arrSeller objectAtIndex:index.row];

    [toolCell loadDTO:goodsDTO];
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return toolCell;
}
-(NoContentTableViewCell *)createNoContentTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    NoContentTableViewCell *noCell = [tableView dequeueReusableCellWithIdentifier:@"NoContentTableViewCell"];
    if (!noCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoContentTableViewCell"];
        noCell = [tableView dequeueReusableCellWithIdentifier:@"NoContentTableViewCell"];
    }
   
    noCell.notLabel.text = @"暂无匹配的搜索结果";
    return noCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
