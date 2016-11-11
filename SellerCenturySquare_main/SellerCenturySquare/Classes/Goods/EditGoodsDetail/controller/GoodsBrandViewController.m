//
//  GoodsBrandViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsBrandViewController.h"
#import "Masonry.h"
#import "BrandCustomTextField.h"
#import "BrandSearchTableViewCell.h"
#import "RefreshControl.h"
#import "MJRefresh.h"
#import "BrandSearchGoodsDTO.h"

@interface GoodsBrandViewController ()<RefreshControlDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UIView *topView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) RefreshControl *refresh;

@property (nonatomic ,strong) UITextField *brandNameTF;
@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,assign) NSInteger pageNo;

@property (nonatomic ,strong)  MJRefreshAutoGifFooter *footerRefresh;


@end

@implementation GoodsBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置返回按钮
    [self customBackBarButton];

    self.pageNo = 1;
    //1.  创建数据源
    self.dataArr = [NSMutableArray array];
    
    //2.  设置标题
    self.title = @"选择商品品牌";
    
    //3.  设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    //4.  创建顶部视图
    self.topView = [[UIView alloc] init];
    //4.1 添加到主视图
    [self.view addSubview:self.topView];
    
    //4.2 给topView布局
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@78);
    }];
  
    //5.  创建搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //5.1 设置按钮的图片
    [searchBtn setImage:[UIImage imageNamed:@"brandsearch"] forState:UIControlStateNormal];
    //5.2 添加事件
    [searchBtn addTarget:self action:@selector(searchInputContentBtn:) forControlEvents:UIControlEventTouchUpInside];
    //5.3 添加到顶部视图
    [self.topView addSubview:searchBtn];
    
    
    //6.  自定义搜索框
    BrandCustomTextField *brandNameTF = [[BrandCustomTextField alloc] init];
    //6.1 设置提示文字
    brandNameTF.placeholder = @"请输入品牌名";
    //6.2 设置代理放啊放
    brandNameTF.delegate = self;
    //6.3 设置字体样式
    brandNameTF.font = [UIFont systemFontOfSize:14];
    //6.4 设置键盘显示样式，显示“搜索”按钮
    brandNameTF.returnKeyType = UIReturnKeySearch;
    //6.5 全局化
    self.brandNameTF = brandNameTF;
    //6.6 设置边的线的颜色
    brandNameTF.layer.borderColor = [UIColor colorWithHex:0xe2e2e2].CGColor;
    //6.7 设置边线的宽度
    brandNameTF.layer.borderWidth = 1;
    //6.8 设置提示文字的颜色
    brandNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入品牌名" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999]}];
    
    //6.9 添加到顶部视图
    [self.topView addSubview:brandNameTF];
    //6.9.1 给自定义搜索框brandNameTF布局
    [brandNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.right.equalTo(searchBtn.mas_left).offset(-10);
        make.height.equalTo(@30);
        
    }];
    
    //5.4 给搜索按钮searchBtn布局
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
    //7.0 添加分割线
    UIView *lineView = [[UIView alloc] init];
    //7.1 设置分割线的背景颜色
    lineView.backgroundColor = [UIColor colorWithHex:0xe2e2e2];
    //7.2 添加到顶部视图
    [self.topView addSubview:lineView];
    //7.3 给分割线lineView布局
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.topView.mas_bottom);
        make.height.equalTo(@0.5f);
        
        
    }];
    
    //8.0 创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 300) style:UITableViewStylePlain];
    //8.1 使tableView全局化
    self.tableView = tableView;
    
    //8.2 创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packPuTheKeyBoard:)];
    tap.cancelsTouchesInView = NO;//!不影响tableView的点击事件
    //8.2.1 给tableView添加手势
    [tableView addGestureRecognizer:tap];
    
    
    //8.3 隐藏系统自带的cell的线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //8.4 添加到主视图
    [self.view addSubview:tableView];
    //8.5 设置代理
    tableView.delegate =self;
    tableView.dataSource = self;
    //8.6 给tableView布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    //9 设置上拉加载和下拉刷新
    //9.1 设置临时变量
    __unsafe_unretained UITableView *tableViewMj = self.tableView;
    
    //9.2 自定义上拉刷新方式
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoadNewData)];
    //9.2.1 隐藏时间
    header.lastUpdatedTimeLabel.hidden =YES;
    //9.2.2 设置刷新内容
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //9.3 赋值上下拉刷新
    tableViewMj.header = header;
    
    
    //9.4 自定义上拉加载
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadNewData)];
    
    [footer setTitle:@"已经到底啦！" forState:MJRefreshStateNoMoreData];
    
    //9.5 全局上拉刷新
    self.footerRefresh = footer;
    //9.6 上拉加载
    tableViewMj.footer = footer;
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //每次过来请求数据
    [self sendHttpRequestForGoodsgetBrandList:self.goodsNo queryName:nil pageNo:[NSNumber numberWithInteger:self.pageNo] pageSize:[NSNumber numberWithInteger:20]];
    
}


/**
 *  下拉刷新
 */
- (void)headLoadNewData
{
    //1、重置pageNo
    self.pageNo = 1;
    //2、清空数据源
    [self.dataArr removeAllObjects];
    //3、请求数据
    [self sendHttpRequestForGoodsgetBrandList:self.goodsNo queryName:self.brandNameTF.text pageNo:[NSNumber numberWithInteger:self.pageNo] pageSize:nil];

}

/**
 *  上拉加载
 */
- (void)footerLoadNewData
{
    //1. 请求数据
    [self sendHttpRequestForGoodsgetBrandList:self.goodsNo queryName:nil pageNo:[NSNumber numberWithInteger:self.pageNo] pageSize:nil];
}


#pragma mark - tableViewDelegate&&DataScource

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

//section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//自定义cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. 设置id
    static NSString *cellId = @"BrandSearchTableViewCellId";
    //2. 根据cell的id获取cell
    BrandSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //3. 如果不存在创建新的cell
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandSearchTableViewCell" owner:nil options:nil]lastObject];
    }
    //4. 设置选择后的cell效果消失
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count>0) {
        
   
    //5. 获取所需的数据
    GoodsListDTO*listDto = self.dataArr[indexPath.row];
    
    DebugLog(@"tableView.frame.size.height = %f", tableView.frame.size.height);
    DebugLog(@"tableView.contentSize.height = %f", tableView.contentSize.height);
    DebugLog(@"tableView.contentOffset.y = %f", tableView.contentOffset.y);
    
    //6. 判断数据是否加载完
    if ((self.dataArr.count-1)==indexPath.row) {
        //6.1 判断是否超过一屏幕
        if (tableView.contentSize.height<(self.view.frame.size.height-78)) {
            //如果未超过一屏幕 隐藏底部
            self.tableView.footer.hidden = YES;
            
        }else{
            //如没有显示已经加载完毕
            [self.tableView.footer noticeNoMoreData];
        }
    }
    //7. 显示中英文
    NSString *showName;
        
        
    
    //7.1 判断中文是否存在，判断不存在显示英文
    if (listDto.cnName.length>0&&[listDto.enName isEqualToString:@""]) {
        
        showName = listDto.cnName;
        //判断英文是否存在，不存在显示中文
    }else if (listDto.enName.length>0&&[listDto.cnName isEqualToString:@""])
    {
        showName = listDto.enName;
        //如果都存在 显示中英文
    }else if (listDto.cnName.length>0 && listDto.enName.length>0)
    {
        showName = [NSString stringWithFormat:@"%@/%@",listDto.cnName,listDto.enName];
    }
    
    //8。 显示cell内容
    cell.customTextLabel.text = showName;
    }else
    {
        NSLog(@"****************************为空**********************");
        
    }
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //1. 创建head
    UIView *headView = [[UIView alloc] init];
    //2. 创建显示的label
    UILabel *promptLabel = [[UILabel alloc] init];
    //3. 将label添加到view中
    [headView addSubview:promptLabel];
    //4. 给label设置内容
    promptLabel.text = @"暂无相关品牌！";
    //5. 给label设置字体样式
    promptLabel.font = [UIFont systemFontOfSize:15];
    //6. 设置label的布局
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(headView.mas_top).offset(23);
    }];
    return headView;
}

//设置head的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    //如果dataArr 有数据返回0 如没有返回60
    if (self.dataArr.count==0) {
        return 60;
    }
    return 0;
}

// 点击cell触发的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.dataArr.count>0) {
    //1. 获取数据对象
    GoodsListDTO*listDto = self.dataArr[indexPath.row];
    //2. 传给上一个控制器
    self.goodsNameBlock(listDto);
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Http
- (void)sendHttpRequestForGoodsgetBrandList:(NSString *)goodsNo queryName:(NSString* )name pageNo:(NSNumber *)no   pageSize:(NSNumber *)size
{
    
    [HttpManager sendHttpRequestForGoodsgetBrandList:goodsNo queryName:self.brandNameTF.text pageNo:no pageSize:size success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
        
        if ([dict[CODE] isEqualToString:@"000"]) {
            DebugLog(@"%@", dict);

            BrandSearchGoodsDTO *brandSearchDto = [[BrandSearchGoodsDTO alloc] init];
            [brandSearchDto setDictFrom:dict[@"data"]];
//            brandSearchDto.totalCount = [NSNumber numberWithInteger:21];
            
            if (brandSearchDto.totalCount.integerValue>self.dataArr.count) {
                self.pageNo++;

                [self.dataArr addObjectsFromArray:brandSearchDto.listGoodsArr];
                

            }
            [self.tableView reloadData];

            [self.tableView.header endRefreshing];
            
            [self.tableView.footer endRefreshing];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];

        
    }];
}

#pragma mark - actionClick

/**
 *  搜索按钮点击触发的事件
 *
 *  @param btn
 */
- (void)searchInputContentBtn:(UIButton *)btn
{
    [self.tableView.header beginRefreshing];
    [self.brandNameTF endEditing:YES];
    
}

//Packp the keyboard
/**
 *  添加其他地方返回按钮
 *
 *  @param tap
 */
- (void)packPuTheKeyBoard:(UIGestureRecognizer *)tap
{
//    [self.tableView.header beginRefreshing];
    [self.brandNameTF endEditing:YES];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tableView.header beginRefreshing];
    [self.brandNameTF endEditing:YES];
    
    return YES;
    
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
