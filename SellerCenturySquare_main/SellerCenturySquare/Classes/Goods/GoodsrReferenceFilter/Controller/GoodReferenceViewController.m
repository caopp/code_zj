//
//  GoodReferenceViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodReferenceViewController.h"
#import "GoodReferencerTableViewCell.h"
#import "FeedbackTypePickerView.h"
#import "HttpManager.h"
//进行具体详情页面
#import "DetailReferenceViewController.h"
#import "SDRefresh.h"

#import "GoodReferenceDTO.h"
#import "TitleZoneGoodsTableViewCell.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HIGHT ([UIScreen mainScreen].bounds.size.height)
@interface GoodReferenceViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    FeedbackTypePickerView *goodReferenView;
    //类型
    NSString *type;
    //搜索框内容
    NSString *searStr;
    
    NSInteger pageNO;
    NSInteger pageSize;
    
    
    UILabel *label;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arrDic;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelected;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (weak, nonatomic) IBOutlet UIView *buttonBackgroundView;

@end

@implementation GoodReferenceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.refreshHeader beginRefreshing];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.refreshHeader endRefreshing];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    if (!goodReferenView) {
        //进行选中类型页面加载
        goodReferenView = [[[NSBundle mainBundle]loadNibNamed:@"FeedbackTypePickerView" owner:self options:nil]lastObject];
        goodReferenView.frame = CGRectMake(0, SCREEN_HIGHT - 64, SCREEN_WIDTH, 300);
        [self.view addSubview:goodReferenView];
    }
}


//创建可变数组
-(NSMutableArray *)arrDic
{
    if (!_arrDic) {
        _arrDic = [NSMutableArray array];
    }
    return _arrDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];
    
    self.title = @"零售_商品默认参考图筛选";
    self.view.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    self.buttonBackgroundView.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    self.buttonSelected.backgroundColor = [UIColor colorWithHex:0xffffff alpha:1];
    [self.buttonSelected setTitleColor:[UIColor colorWithHex:0x000000 alpha:1] forState:UIControlStateNormal];
    self.buttonSelected.layer.masksToBounds = YES;
    self.buttonSelected.layer.cornerRadius = 2;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //进行通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDataList:) name:@"FeedType" object:nil];
    
    //页面添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChangeDataType)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    
    self.buttonSelected.selected = NO;
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBar.layer.borderWidth = 0;
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    
    
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorWithHex:0x000000 alpha:1];
    searchField.backgroundColor = [UIColor colorWithHex:0xffffff alpha:1];
    [searchField setValue:[UIColor colorWithHex:0xe2e2e2 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    //!创建刷新
    [self createRefresh];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, SCREEN_HIGHT/2- 100, 200, 15)];
    label.hidden = YES;
    label.text = @"暂无匹配的搜索结果";
    label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:label];
    
}


//!创建刷新
-(void)createRefresh{
    
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak GoodReferenceViewController * vc = self;
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

- (void)requestHistoryDownloadImage:(SDRefreshView *)refresh{
    
    if (refresh == self.refreshHeader) {
        
        pageNO = 1;
        
        pageSize = 20;
        
    }else{
        
        pageNO = pageNO +1;
    }

      [self getDataList:[NSNumber numberWithInt:[type intValue]] queryParam:searStr  pageNo:pageNO pageSize:pageSize  refresh:refresh] ;
}



#pragma mark ----search 代理方法---
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searStr = searchBar.text;

    if (type == nil) {
        type = @"0";
    }
    
    if (searchBar.text.length  >= 50 ) {
        [self.view makeMessage:@"最多可输入50位字" duration:1.0f position:@"center"];
        return;
    }
    
    [self.refreshHeader beginRefreshing];
    
}
//通知选中模块进行隐藏以及编辑结束
-(void)hideChangeDataType
{
    //编辑结束
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.6 animations:^{
        goodReferenView.frame = CGRectMake(0, SCREEN_HIGHT - 64, SCREEN_WIDTH, 300);
    }];
}


//进行通知方法
-(void)changeDataList:(NSNotification *)changeDataList
{
    type = changeDataList.userInfo[@"queryType"];
    
    [self.buttonSelected setTitle:changeDataList.userInfo[@"queryTypeName"] forState:(UIControlStateNormal)];
    //开始进行刷新
    [self.refreshHeader beginRefreshing];
    
    [self  hideChangeDataType];
    
    self.buttonSelected.selected = NO;
}


#pragma mark ====uitableView   delegate=====
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.arrDic.count > 0) {
        label.hidden = YES;
        self.tableView.scrollEnabled = YES;

    }else
    {
        label.hidden = NO;
        self.tableView.scrollEnabled = NO;
    }
        return self.arrDic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        GoodReferencerTableViewCell *toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodReferencerTableViewCell"];
        if (!toolCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"GoodReferencerTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodReferencerTableViewCell"];
            toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodReferencerTableViewCell"];
        }
        
        toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GoodReferenceDTO *goodReference = [[GoodReferenceDTO alloc]init];
        
        [goodReference setDictFrom:self.arrDic[indexPath.row]];
        
        //对数据进行处理
        if ([goodReference.retailPrice floatValue] == 0) {
            //零售价
            toolCell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",@"0"];
            
        }else
        {
            //零售价
            toolCell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",goodReference.retailPrice];
        }
        
        //商品名称
        toolCell.goodsNameLabel.text = goodReference.goodsName;
        
        //设置壮态
        if ([goodReference.goodsStatus isEqualToString:@"2"]) {
            
            toolCell.goodsStatusLabel.text = @"已上架";
            
        }else if ([goodReference.goodsStatus isEqualToString:@"3"])
        {
            toolCell.goodsStatusLabel.text = @"已下架";
        }
        //货号
        toolCell.goodsWillNoLabel.text = [NSString stringWithFormat:@"货号: %@", goodReference.goodsWillNo];
        
        //商品颜色
        toolCell.colorLabel.text = [NSString stringWithFormat:@"颜色: %@", goodReference.color];
        
        //图片链接url
        [toolCell.imgUrlImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodReference.imgUrl]] placeholderImage:[UIImage imageNamed:@""]];
        
        // 窗口图设置
        if ([goodReference.isSetWPic isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            toolCell.windowSetLabel.text = @"未设置";
            [toolCell.windowSetLabel setTextColor:[UIColor colorWithHex:0xfd4f57 alpha:1]];
        }else
        {
            toolCell.windowSetLabel.text = @"已设置";
            [toolCell.windowSetLabel setTextColor:[UIColor blackColor]];
        }
        
        // 详情图设置
        if ([goodReference.isSetRPic isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            toolCell.detailSetLabel.text = @"未设置";
            [toolCell.detailSetLabel setTextColor:[UIColor colorWithHex:0xfd4f57 alpha:1]];
            
        }else
        {
            toolCell.detailSetLabel.text = @"已设置";
            [toolCell.detailSetLabel setTextColor:[UIColor blackColor]];
            
        }
        
        //窗口图和详情图相加
        int num = goodReference.wQty.intValue+ goodReference.rQty.intValue;
        
        if (num == 0) {
            toolCell.picNumLabel.hidden= YES;
        }else
        {
            toolCell.picNumLabel.hidden = NO;
        }
        
        //图片展示个数
        toolCell.picNumLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:num]];
    
        return toolCell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailReferenceViewController *detailReferenceVC = [[DetailReferenceViewController alloc]init];

    GoodReferenceDTO *referenceDTO = [[GoodReferenceDTO alloc]init];
    
    if (self.arrDic.count == 0) {
        return;
    }
    
    [referenceDTO setDictFrom:self.arrDic[indexPath.row]];
    
    detailReferenceVC.goodReference = referenceDTO;
    
    [self.navigationController pushViewController:detailReferenceVC animated:YES];
}


- (IBAction)didClickShowGoodListType:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    if (sender.selected) {
        [UIView animateWithDuration:0.6 animations:^{
            
            goodReferenView.frame = CGRectMake(0, SCREEN_HIGHT  - 300, SCREEN_WIDTH, 300);
        }];
        
    }else
    {
        [UIView animateWithDuration:0.6 animations:^{
            
            goodReferenView.frame = CGRectMake(0, SCREEN_HIGHT - 64, SCREEN_WIDTH, 300);
        }];
    }
}

#pragma mark ===========获取商品数据==========
-(void)getDataList:(NSNumber *)queryType  queryParam:(NSString *)queryParam pageNo:(NSInteger)pageNun pageSize:(NSInteger)pageSizeNu refresh:(SDRefreshView *)refresh
{
    
    [HttpManager sendHttpRequestForScreeningDefaultImagesQueryType:queryType queryParam:queryParam pageNo:[NSNumber numberWithInteger:pageNun] pageSize:[NSNumber numberWithInteger:pageSizeNu] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *arr;
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
    
             arr =responseDic[@"data"][@"list"];
        
            if (refresh == _refreshHeader) {
                    
                self.arrDic = [NSMutableArray arrayWithArray:arr];
                    
            }else{
                    
                [self.arrDic addObjectsFromArray:arr];
            }

            if (_arrDic.count == 0) {
    
                label.hidden = YES;
            }else
            {
                label.hidden = NO;
            }
         
        }
        
        [self.tableView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        if (arr.count < 20) {
        
             [self.refreshFooter noDataRefresh];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
 
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length == 0) {
        searStr =  @"";
        [self.refreshHeader beginRefreshing];
        [searchBar resignFirstResponder];
    }
}


//删除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}





@end
