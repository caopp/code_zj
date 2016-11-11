//
//  SearchMerchatResultController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchMerchatResultController.h"
#import "MerchantAndGoodSelectView.h"
#import "SearchView.h"//!假搜索框
#import "SearchMerhcantAndGoodController.h"//!搜索界面
#import "SearchMerchantCell.h"//!搜索出来的cell
#import "SearchMerhantDTO.h"//!搜索出来的结果
#import "MerchantDeatilViewController.h"
#import "GoodsNotLevelTipDTO.h"
#import "CSPAuthorityPopView.h"
#import "MembershipUpgradeViewController.h"
#import "GoodsInfoDTO.h"
#import "GoodDetailViewController.h"//!商品详情
#import "AllListNoGoodsView.h"//!暂无相关商品、商家的view
#import "PrepaiduUpgradeViewController.h"//!等级规则
#import "CCWebViewController.h"//!立即升级
#import "CustomBarButtonItem.h"

@interface SearchMerchatResultController ()<UICollectionViewDataSource,UICollectionViewDelegate,CSPAuthorityPopViewDelegate>
{
    UIButton *selectTempBtn;
    //!搜索view
    SearchView * searchView;
    
    int pageNo;
    int pageSize;

    int totalCount;
    
    NSMutableArray * dataArray;//!数据源

}
@property(nonatomic,assign)MerchantAndGoodSelectView * headerSelectView;

@property(nonatomic,strong)UICollectionView * merchantCollectionView;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@end

@implementation SearchMerchatResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    //!创建界面
    [self createUI];
    
    //!创建刷新
    [self createRefresh];
    
    //!请求数据
    [self requestMerchantList:self.refreshHeader];
    
    //!商家列表--》商家详情 点击收藏时候发出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCellStatus:) name:@"CHANGECOLLECTSTATUS" object:nil];
    

}
-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];

    self.isSearchMerchant = YES;
    
    //!创建导航
    [self createNav];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
  
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];

    if (self.headerSelectView) {
        
        [self.headerSelectView removeFromSuperview];

    }
    
    if (searchView) {
        
        [searchView removeFromSuperview];

    }

    
}
#pragma mark 创建导航
-(void)createNav{

//    [self addCustombackButtonItem];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backButtonClick) target:self]];

    
    __weak SearchMerchatResultController * vc = self;

    //!商家、商品分类切换view
    _headerSelectView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantAndGoodSelectView" owner:self options:nil]lastObject];
    _headerSelectView.frame = CGRectMake(15+10 + 27, (self.navigationController.navigationBar.frame.size.height - _headerSelectView.frame.size.height/2)/2, _headerSelectView.frame.size.width, _headerSelectView.frame.size.height/2);//!先只显示一半
    
    [_headerSelectView setDataisFromMerchant:self.isSearchMerchant];//!设置按钮上面的数据，如果是从搜索商家传入yes
    [_headerSelectView setBackgroundColor:[UIColor clearColor]];
    
    _headerSelectView.changHightBlock = ^(BOOL isSelectBtn){//!参数：是否点击了按钮（如果点击按钮就调到搜索界面）

        
        CGFloat hight;
        if (_headerSelectView.frame.size.height >= 60) {//!展开的时候，现在要收起
            
            hight = _headerSelectView.frame.size.height/2;
            
            selectTempBtn.hidden = YES;
            
            
        }else{
            
            hight = _headerSelectView.frame.size.height*2;
            //!对这样的写法深深的致歉，现在实在没有找到办法如何解决 这个选中框第二个按钮不在nav 部分无法点中的问题 ，只好在展开的时候，显示一个透明的按钮在 下面
            
            if (!selectTempBtn) {
                
                selectTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectTempBtn.frame = CGRectMake(_headerSelectView.frame.origin.x, 0, _headerSelectView.firstBtn.frame.size.width, 30);
                [selectTempBtn setBackgroundColor:[UIColor clearColor]];
                [selectTempBtn addTarget:self action:@selector(tempBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:selectTempBtn];
                
            }
            
            selectTempBtn.hidden = NO;
            
            
        }
        
        _headerSelectView.frame =CGRectMake(15+10 + 27, _headerSelectView.frame.origin.y, _headerSelectView.frame.size.width,hight);
        
        //!获取到第一个按钮的数据，判断是商家还是商品
        if ([_headerSelectView.firstBtn.titleLabel.text isEqualToString:@"商家"]) {
            
            self.isSearchMerchant = YES;
            
        }else{
            
            self.isSearchMerchant = NO;
        }
        
        if (isSelectBtn) {//!参数：是否点击了按钮（如果点击按钮就调到搜索界面）
            
            [vc intoSearchVC];

            
        }
        

    };
    [self.navigationController.navigationBar addSubview:_headerSelectView];
    
    

    //!搜索view
    searchView = [[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
    if (self.searchContent) {
        
        searchView.leftLabel.text = self.searchContent;//!输入框显示的是 搜索内容

    }else{
    
        searchView.leftLabel.text = self.categoryName;//!输入框显示的是 筛选内容

    }
    
    
    searchView.searchViewTapBlock = ^(){//!点击搜索框的时候调用的方法
        
        [vc intoSearchVC];
        
    };
    searchView.frame = CGRectMake(CGRectGetMaxX(_headerSelectView.frame)+6, _headerSelectView.frame.origin.y, self.navigationController.navigationBar.frame.size.width - CGRectGetMaxX(_headerSelectView.frame)- 6 - 7, 30);
    
    [self.navigationController.navigationBar addSubview:searchView];
    
    
    
}
//!进入搜索界面
-(void)intoSearchVC{

    
    if (self.isSearchMerchantBlock) {//!告诉上一个搜索界面 搜索的是商家还是商品
        
        self.isSearchMerchantBlock(self.isSearchMerchant);
        
    }
    
    //!判断当前界面的上一个界面是否是 输入搜索内容的界面，如果是就返回上一个界面，不是就进入搜索界面
    if (self.isFilter) {//!从 筛选 侧滑菜单 进行筛选进入的，上一个界面不是搜索
        
        SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
        searchVC.isSearchMerchant = self.isSearchMerchant;//!搜索的是商家传入 yes，搜索的是商品 传入no
        
        [self.navigationController pushViewController:searchVC animated:NO];

        
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    

}
-(void)tempBtnClick{
    
    
    [_headerSelectView secondBtnClick];
    
}

/**
 *  返回按钮
 */
- (void)backButtonClick{
    
    DebugLog(@"商家搜索结果页面点击返回按钮");

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 创建界面
-(void)createUI{

    //!创建collectionview
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 0;//item间距(最小值)
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);//item的大小
    
    
    CGFloat showHight = self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    self.merchantCollectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight) collectionViewLayout:flowLayout];
    
    self.merchantCollectionView.dataSource = self;
    self.merchantCollectionView.delegate = self;
    
    [self.merchantCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.merchantCollectionView.alwaysBounceVertical = YES;//!如果不加这句话，数据没有或者数据少的时候没法滑动
    
    
    [self.view addSubview:self.merchantCollectionView];



}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return dataArray.count;

}

-(SearchMerchantCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    UINib *nib = [UINib nibWithNibName:@"SearchMerchantCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"cellIdentifier"];
    
    SearchMerchantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (dataArray.count) {
        
        SearchMerhantDTO * searchMerchantDTO = dataArray[indexPath.row];
        
        [cell configData:searchMerchantDTO];
        
        __weak SearchMerchatResultController * resultVC = self;
        
        cell.selectGoodsBlock = ^(TenNumGoodsDTO * goodsDTO ,BOOL isSelectLast,NSString * merchantNo){
        
            //!点击的是最后一个按钮，就进入商家
            if (isSelectLast) {
                
                [resultVC intoMerchantDeatil:merchantNo];
                
            }else{//!查看商品
            
               
                [resultVC intoGoodsDeatil:goodsDTO];
                

            }
            
            
        };
        
        cell.collectBtnClock = ^(){
        
            //!如果是选中状态
            if (cell.collectBtn.selected == YES) {//!是选中的，则需要修改为不收藏
                
                [resultVC delMerchantFavoriteRequest:searchMerchantDTO.merchantNo withIndexPath:indexPath];
                
            }else{//!未选中，修改为收藏
                
                [resultVC addMerchantFavoriteRequest:searchMerchantDTO.merchantNo withIndexPath:indexPath];
                
                
            }
            
        
        };
        

    }
    
    

    return cell;

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SearchMerhantDTO * searchMerchantDTO = dataArray[indexPath.row];
    
    [self intoMerchantDeatil:searchMerchantDTO.merchantNo];
    

}

-(void)intoMerchantDeatil:(NSString *)merchantNo{


    MerchantDeatilViewController * detailVC = [[MerchantDeatilViewController alloc]init];
    
    detailVC.merchantNo = merchantNo;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    

}
- (void) intoGoodsDeatil:(TenNumGoodsDTO *)goodsDTO{

    
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = goodsDTO.goodsNo;

    //!判断是否有权限查看 0:无 1:有
    if ([goodsDTO.authFlag isEqualToString:@"0"]) {//!无
        
//        [self showNotLevelReadTipForGoodsNo:goodsDTO.goodsNo];
        
        [self showNotLevelReadTipForGoodsNo:goodsDTO.goodsNo withIsReadable:NO];
        
        
    }else{//!有权限
        
        [self showNotLevelReadTipForGoodsNo:goodsDTO.goodsNo withIsReadable:YES];

//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        GoodDetailViewController *goodsInfo = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
//        [self.navigationController pushViewController:goodsInfo animated:YES];
        
    }
    
   

}
//!goodsNo：商品编码  isReadable：商品列表请求回来的时候是否可以查看
- (void)showNotLevelReadTipForGoodsNo:(NSString*)goodsNo withIsReadable:(BOOL)isReadable{
    
    /*
     该方法是在点击进入商品详情之前再次进行判断是否有权限进入
     
     有蒙层                             无蒙层
     无权限进入：弹出等级不足提示          提示刷新
     有权限进入：提示刷新列表              直接进入
     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            GoodsNotLevelTipDTO *goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {//!最新请求结果为不能查看
                
                if (isReadable) {//!列表数据请求回来的时候是可以查看的，无蒙层，现不可以查看
                    
                    [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                    
                }else{//!列表数据请求回来的时候是可以不能查看的，有蒙层
                    
                    [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                    
                    CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                    popView.frame = self.view.bounds;
                    popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                    
                    popView.delegate = self;
                    [self.view addSubview:popView];
                    
                }
                
                
                
            } else {//!最新请求结果为能查看
                
                if (isReadable) {//!列表数据请求回来的时候是可以查看的，无蒙层，现也可查看
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
                    
                    goodsInfoDTO.goodsNo = goodsNo;
                    
                    GoodDetailViewController *goodsInfo = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
                    [self.navigationController pushViewController:goodsInfo animated:YES];
                    
                    
                }else{//!列表数据请求回来的时候是可以不能查看的，有蒙层，现克查看了
                    
                    [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                    
                    
                }
                
                
            }
            
        }else {
            
            [self.view makeMessage:@"查询权限失败" duration:2.0f position:@"center"];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];
    
    
}
- (void)showNotLevelReadTipForGoodsNo:(NSString*)goodsNo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            GoodsNotLevelTipDTO *goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                
                CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                popView.frame = self.view.bounds;
                popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                
                popView.delegate = self;
                [self.view addSubview:popView];
                
                
            } else {
                
                [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                
            }
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询权限失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];
}
//查看商品详情权限不足的提示view
- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//!查看商品详情权限不足的提示view 的代理方法
- (void)showLevelRules{
    

    
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    //bool值进行名字判断
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    
}
- (void)prepareToUpgradeUserLevel{
    
    
    CCWebViewController * cc = [[CCWebViewController alloc]init];
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    //bool 值进行判断
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];
    

    
}



#pragma mark 创建刷新
-(void)createRefresh{


    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.merchantCollectionView];
    self.refreshHeader = refreshHeader;
    
    
    __weak SearchMerchatResultController * vc = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [vc requestMerchantList:self.refreshHeader];
    
    };
    
    //!底部
    self.refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [self.refreshFooter addToScrollView:self.merchantCollectionView];
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        
        
        [vc requestMerchantList:self.refreshFooter];
        
    };

    
}
-(void)requestMerchantList:(SDRefreshView *)refresh{


    if (refresh == self.refreshHeader) {
        
        pageNo = 1;
    }else{
    
        pageNo ++;
    }
    
    pageSize = 20;
    
    __weak SearchMerchatResultController * resultVC = self;
    
    [HttpManager sendHttpRequestFoSeachMerchantListWithQueryParam:self.searchContent withCategoryNo:self.categoryNo  withPageNo:[NSNumber numberWithInt:pageNo] withPageSize:[NSNumber numberWithInt:pageSize] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
        
            
            if (refresh == self.refreshHeader) {
                
                dataArray = [NSMutableArray arrayWithCapacity:0];
            }
            
            NSArray * listArray = dic[@"data"][@"list"];
            
            for (int i = 0 ; i< listArray.count; i++) {
                
                NSDictionary * merchantDic = listArray[i];
                
                SearchMerhantDTO * merchantDTO = [[SearchMerhantDTO alloc]initWithDictionary:merchantDic];
                
                //!请求商家 计算当前添加的数据在总数据中的位置
                NSString * dataCountStr =  [NSString stringWithFormat:@"%ld",dataArray.count] ;
                
                int num = [dataCountStr intValue];
                
                [resultVC requestForGoodsTenNum:merchantDTO.merchantNo withNum:num];

                [dataArray addObject:merchantDTO];
                
                
            }
            
            totalCount = [dic[@"data"][@"totalCount"] intValue];
        
            [CATransaction begin];

            [self.merchantCollectionView reloadData];
            
            [CATransaction commit];

            
        }else{
        
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
        
        }
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        if (dataArray.count == totalCount) {
            
            [self.refreshFooter noDataRefresh];
            
        }
        
        if (totalCount == 0) {
            
            AllListNoGoodsView * goodsNoView = [[[NSBundle mainBundle]loadNibNamed:@"AllListNoGoodsView" owner:nil options:nil]lastObject];
            goodsNoView.noAlertLabel.text = @"暂无相关商家";
            [self.view addSubview:goodsNoView];
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
        
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        
        
    }];

}

-(void)requestForGoodsTenNum:(NSString *)merchantNo withNum:(int)num{

    if (merchantNo == nil || [merchantNo isEqualToString:@""]) {
        
        return ;
    }

    [HttpManager sendHttpRequestFoQueryGoodsTenNum:merchantNo Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            //!找到对应的那个dto
            SearchMerhantDTO * merchantDTO = (SearchMerhantDTO *)dataArray[num];
            
            if (merchantDTO.merchantNo == merchantNo) {
                
                NSMutableArray * tenGoodsArray  = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary * tenNumDic in dic[@"data"]) {
                    
                    TenNumGoodsDTO * goodDTO = [[TenNumGoodsDTO alloc]initWithDictionary:tenNumDic];
                    [tenGoodsArray addObject:goodDTO];
                    
                }
                
                merchantDTO.tenNumGoodsArray = tenGoodsArray;
             
                [self.merchantCollectionView reloadData];
                
            }
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    

}

#pragma mark 商家收藏请求
-(void)addMerchantFavoriteRequest:(NSString *)merchantNo withIndexPath:(NSIndexPath *)indexPath{
    
    __weak SearchMerchatResultController *vc = self;
    
    [HttpManager sendHttpRequestForAddMerchantFavorite:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!收藏成功
            
            
            SearchMerchantCell * merchantCell = (SearchMerchantCell*)[vc.merchantCollectionView cellForItemAtIndexPath:indexPath];
            merchantCell.collectBtn.selected = YES;
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
        
        
    }];
    
    
    
}
-(void)delMerchantFavoriteRequest:(NSString *)merchantNo withIndexPath:(NSIndexPath *)indexPath{
    
    __weak SearchMerchatResultController *vc = self;
    
    
    [HttpManager sendHttpRequestForDelMerchantFavorite:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!取消收藏成功
            
            SearchMerchantCell * merchantCell = (SearchMerchantCell*)[vc.merchantCollectionView cellForItemAtIndexPath:indexPath];
            merchantCell.collectBtn.selected = NO;
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
        
        
    }];
    
    
}
#pragma mark 收到商家 收藏的通知
-(void)changeCellStatus:(NSNotification *)notification{
    
    NSDictionary *dic=notification.userInfo;
    
    NSString * changeMerchantNo = dic[@"merchantNo"];
    NSString * changeFavoriterStatus = dic[@"collectStatus"];
    
    NSIndexPath *changeIndexPath ;
    for (int i=0; i<dataArray.count ;i++) {
        
        SearchMerhantDTO * searchMerchantDTO = dataArray[i];

        //!找到被改变的那一行
        if ([searchMerchantDTO.merchantNo isEqualToString:changeMerchantNo]) {
            
            searchMerchantDTO.isFavorite = changeFavoriterStatus;
            
            changeIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.merchantCollectionView reloadItemsAtIndexPaths:@[changeIndexPath]];
            
            break;
            
            
        }
        
    }
    
    
}
-(void)dealloc{

    //!商家收藏的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CHANGECOLLECTSTATUS" object:nil];

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
