//
//  MerchantListViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantListViewController.h"
#import "MerchantCell.h"//!商家列表cell
#import "SDRefresh.h"
#import "MerchantListDetailsDTO.h"//!每个商家的dto
#import "RPSlidingMenuLayout.h"//!collectionview布局
#import "MerchantDeatilViewController.h"//!商家详情
#import "SWRevealViewController.h"//!侧滑所需
#import "MerchantLeftSlideController.h"//!左边的筛选界面
#import "SearchView.h"//!搜索界面
#import "SearchMerhcantAndGoodController.h"//!搜索的界面
#import "PersonalCenterDTO.h"//!个人中心的dto
#import "CSPShoppingCartViewController.h"//!采购车
#import "SearchMerchatResultController.h"//!进入商家搜索结果页面

#import "ReturnApplyViewController.h"

@interface MerchantListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,RPSlidingMenuLayoutDelegate,SWRevealViewControllerDelegate>
{

    
    int page;//!页码
    int num;//!请求的数量
    int totalCount;//!总数量
    NSMutableArray *dataArray;//!数据
    
    UIButton *backUpBtn;//!返回到顶部的按钮
    RPSlidingMenuLayout *_layout;//!collectionview的布局
    
    //是否打开侧面
    BOOL isOpen;
    //!右导航
    UIButton * searchBtn;
    UIButton * shopCarBtn;
    //!采购车小红点
    UILabel * shopRedAlertLabel;

}


@property(nonatomic,strong)UICollectionView * merchantCollectionView;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic ,strong) UIView *maskView;//!打开侧面时，在整个界面上放一个透明的view，以防点击到其他地方


@end

@implementation MerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //!创建导航
    [self createNav];
    
    //!创建界面
    [self createUI];
    
    //!创建刷新
    [self createRefresh];

    
    [self requestMerchantList:self.refreshHeader];
    
    
    //!商家列表--》商家详情 点击收藏时候发出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCellStatus:) name:@"CHANGECOLLECTSTATUS" object:nil];
    
    //!侧滑出的框，选中对应类型 要跳转到商家的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intoMerchantSearchResult:) name:@"MerchantSearchResult" object:nil];
    


}
#pragma mark 创建导航
-(void)createNav{

    self.title = NSLocalizedString(@"shop", @"商家");

    [self.view setBackgroundColor:[UIColor whiteColor]];
 
    //!左导航
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.contentMode = UIViewContentModeLeft;
    
    float width = 30;//!导航左右按钮的宽度
    leftNavBtn.frame = CGRectMake(0, 0, width , 30 );//!图片实际宽度 18  14
    [leftNavBtn setImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
    leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -(width - 18) , 0, 0);//!修改图片在按钮中的位置

    [leftNavBtn addTarget:self action:@selector(leftNavClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
    
    
    //!右导航
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    
     searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"serchImage"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, (rightView.frame.size.height - 40)/2, 35, 40);//!原本26、20
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:searchBtn];

    shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(rightView.frame.size.width - 35, (rightView.frame.size.height - 40)/2, 35 , 40 );//!原本：22、19
    shopCarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);

    [shopCarBtn setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
    [shopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shopCarBtn];
    
//    [rightView setBackgroundColor:[UIColor redColor]];
//    [searchBtn setBackgroundColor:[UIColor yellowColor]];
//    [shopCarBtn setBackgroundColor:[UIColor greenColor]];

    
//    shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shopCarBtn.frame = CGRectMake(0, 0, width, 19);//!图片实际宽度 43  37（22  19）
//    [shopCarBtn setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
//    shopCarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width - 22 , 0, 0);//!修改图片在按钮中的位置
//    
//    [shopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //!采购车小红点
    shopRedAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(shopCarBtn.frame.size.width - 2, shopCarBtn.frame.size.height - (shopCarBtn.frame.size.height - 19)/2.0 - 23 , 7 , 7 )];
    [shopRedAlertLabel setBackgroundColor:[UIColor redColor]];
    shopRedAlertLabel.layer.masksToBounds = YES;
    shopRedAlertLabel.layer.cornerRadius = shopRedAlertLabel.frame.size.width/2.0;
    [shopCarBtn addSubview:shopRedAlertLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];

    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shopCarBtn];
    
    //!中间的搜索view
//    SearchView * centerSearchView = [[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
//    
//    centerSearchView.searchViewTapBlock = ^(){//!点击搜索框的时候调用的方法
//        
//        SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
//        searchVC.isSearchMerchant = YES;//!搜索的是商家传入 yes，搜索的是商品 传入no
//        [self.navigationController pushViewController:searchVC animated:NO];
//    
//    };
//    self.navigationItem.titleView = centerSearchView;
    
    
}

-(void)leftNavClick{
    
    
    if (isOpen) {
        
        self.revealViewController.frontViewPosition = FrontViewPositionLeft;
        isOpen = NO;
        
    }else
    {
        self.revealViewController.frontViewPosition = FrontViewPositionRight;
        isOpen = YES;
        
        
    }
    

    
    
}
- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    
    //显示左面标签
    if (position == FrontViewPositionRight) {
        
        [self.maskView  removeFromSuperview];

        //创建不可点击的视图
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+1000)];
        
        //添加Tap点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFormerVC:)];
        
        //添加手势
        [self.maskView addGestureRecognizer:tap];
        
        
        SWRevealViewController *revealController = self.revealViewController;
        revealController.delegate = self;
        [self.maskView addGestureRecognizer:revealController.panGestureRecognizer];
    
        //添加视图
        [revealController.frontViewController.view addSubview:self.maskView];
        
        
        
        isOpen = YES;
        
    }
    
    if (position == FrontViewPositionLeft) {
        
        //添加新的手势
        SWRevealViewController *revealController = self.revealViewController;
        revealController.delegate = self;
        
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        //移除视图
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        
        
        isOpen = NO;
        
    }
    
    
}
//点击maskView的时候，收回界面
- (void)backFormerVC:(UITapGestureRecognizer *)tap
{
    self.revealViewController.frontViewPosition = FrontViewPositionLeftSide;
    
}
//!搜索按钮
-(void)searchBtnClick{

    SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
    searchVC.isSearchMerchant = YES;//!搜索的是商家传入 yes，搜索的是商品 传入no
    [self.navigationController pushViewController:searchVC animated:NO];


}
//!采购车按钮
-(void)shopCarBtnClick{

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    shopVC.isBlockUp = YES;
    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
    [self.navigationController pushViewController:shopVC animated:YES];
    
   
}


#pragma mark 创建界面
-(void)createUI{

    //!创建collectionview
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 0;//item间距(最小值)
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);//item的大小
    
    _layout = [[RPSlidingMenuLayout alloc] initWithDelegate:self];

    CGFloat showHight = self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.navigationController.navigationBar.frame.size.height;
    
    self.merchantCollectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight) collectionViewLayout:_layout];
    
    self.merchantCollectionView.decelerationRate = 0.2;//!重力感
    self.merchantCollectionView.dataSource = self;
    self.merchantCollectionView.delegate = self;
    
    [self.merchantCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    self.merchantCollectionView.alwaysBounceVertical = YES;//!如果不加这句话，数据没有或者数据少的时候没法滑动

    [self.view addSubview:self.merchantCollectionView];

    
    
    //!返回顶部按钮
    backUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backUpBtn setImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
    backUpBtn.frame = CGRectMake(self.view.frame.size.width - 55, showHight - 55, 35, 35);
    [backUpBtn addTarget:self action:@selector(backUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backUpBtn.hidden = YES;
    [self.view addSubview:backUpBtn];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UINib *nib = [UINib nibWithNibName:@"MerchantCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"cellIdentifier"];
    
    MerchantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
   
    if (dataArray.count && indexPath.row <dataArray.count) {
        
        MerchantListDetailsDTO  * merchantInfoDto =  dataArray[indexPath.row];
        [cell configInfo:merchantInfoDto];
        
        __weak MerchantListViewController *vc = self;
        cell.collectBtnClock = ^(){//!收藏按钮
            //!如果是选中状态
            if (cell.collectBtn.selected == YES) {//!是选中的，则需要修改为不收藏
                
                [vc delMerchantFavoriteRequest:merchantInfoDto.merchantNo withIndexPath:indexPath];
                
            }else{//!未选中，修改为收藏
            
                [vc addMerchantFavoriteRequest:merchantInfoDto.merchantNo withIndexPath:indexPath];

            
            }
        
        };

        
    }

    return cell;

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
}
//!非顶部第一个cell的高度
-(CGFloat)heightForCollapsedCell{

    return self.view.frame.size.width *0.3 ;

    
}
//!顶部第一个cell的高度
-(CGFloat)heightForFeatureCell{

    return self.view.frame.size.width;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MerchantDeatilViewController * detailVC = [[MerchantDeatilViewController alloc]init];
    
    MerchantListDetailsDTO  * merchantInfoDto =  dataArray[indexPath.row];
    detailVC.merchantNo = merchantInfoDto.merchantNo;
    
    [self.navigationController pushViewController:detailVC animated:NO];//!为no的时候可以把跳转处的空白去掉


}

//!将要显示某个cell的时候调用
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    //!如果数据没有全部请求回来
    if (dataArray.count < totalCount) {
        
        if (indexPath.row == dataArray.count-6) {//!倒数第5个的时候自动刷新
            
            
            /*
             判断要请求的页 是否已经请求了，请求了就不进入
             
            nowPage（当前第几页）    判断总是是否大于
              14/20 = 0                 20 = 20+20*nowPage;
              34/20 = 1                 40 = 20+20*nowPage;
              54/20 = 2                 60 = 20+20*nowPage;
             
             */
            //1、判断当前在第几页 从0开始
            int nowPage = 0;
            nowPage = indexPath.row/num;
            //!判断是否大于的数
            int count =  num + nowPage * num;
            
            if (dataArray.count > count) {
                
                return;
                
            }else{
            
                [self requestMerchantList:self.refreshFooter];
                
            }
            
        }
        
        
    }


}

#pragma mark 创建刷新
-(void)createRefresh{


    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.merchantCollectionView];
    self.refreshHeader = refreshHeader;
    
    
    __weak MerchantListViewController * vc = self;
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
#pragma mark 请求商家列表
-(void)requestMerchantList:(SDRefreshView *)refresh{

    //!下拉刷新 请求页码为第1页，请求20条，数据数组重新定义
    if (refresh == self.refreshHeader) {
        
        page = 1;
        
        num = 20;

    }else{
    
        page++;
        
    }
    
      
    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:nil pageNo:[NSNumber numberWithInt:page] pageSize:[NSNumber numberWithInt:num] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSDictionary *dataDic = dic[@"data"];
            
            totalCount = [dataDic[@"totalCount"] intValue];
            
            if (refresh == self.refreshHeader) {
                
                dataArray = [NSMutableArray arrayWithCapacity:0];

            }
            for (NSDictionary * merchantDic in dataDic[@"list"]) {
                
                MerchantListDetailsDTO  * merchantInfoDto = [[MerchantListDetailsDTO alloc]initWithDictionary:merchantDic];
                
                [dataArray addObject:merchantInfoDto];
                
            }
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            //!如果有数据，并且请求完全部数据了  这个需要放在reloadData前面，这个会改变sc的位置，刷新动画，导致collectionview闪动
            if (dataArray.count && dataArray.count >= totalCount) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            
            
            [self.merchantCollectionView reloadData];
            
            
        }else{
        

            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];

            //!如果有数据，并且请求完全部数据了
            if (dataArray.count && dataArray.count >= totalCount) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            
            if (dic[@"errorMessage"]) {
                
                [self.view makeMessage:[NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"shopListFail", @"查询商家列表失败"),dic[@"errorMessage"]]  duration:2.0f position:@"center"];

            }

        }
        
        DebugLog(@"123456");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        
        DebugLog(@"error:123456");

    }];
    

}
#pragma mark 请求个人中心信息--》为了得到采购车的数量
-(void)requestPerCenterInfoForShopCar{

    shopRedAlertLabel.hidden = YES;
    
    [HttpManager sendHttpRequestForPersonalCenterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            PersonalCenterDTO * personalDTO = [[PersonalCenterDTO alloc]initWithDictionary:dic[@"data"]];
            
            if ([personalDTO.cartNum intValue]) {
                
                
                shopRedAlertLabel.hidden = NO;//!采购车中有商品，显示提示的红点
                
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        

    }];



}

#pragma 返回顶部按钮涉及到的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 50) {
        
        [backUpBtn setHidden:NO];
        
    } else {
        
        [backUpBtn setHidden:YES];
        
    }
    
    //!下拉的时候改为no，不影响动画
    if (scrollView.contentOffset.y<0) {
        _layout.isRefresh = NO;
    }else{
        _layout.isRefresh = YES;
        
    }
    
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [backUpBtn setHidden:YES];
    
}
//!返回到顶部按钮的事件
-(void)backUpBtnClick{
    
    
//    self.merchantCollectionView.contentOffset = CGPointMake(0, 0);

    [self.merchantCollectionView setContentOffset:CGPointZero animated:YES];
    
}
#pragma mark 商家收藏请求
-(void)addMerchantFavoriteRequest:(NSString *)merchantNo withIndexPath:(NSIndexPath *)indexPath{
    
    __weak MerchantListViewController *vc = self;
    
    [HttpManager sendHttpRequestForAddMerchantFavorite:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!收藏成功
            
           MerchantCell * collectCell = (MerchantCell*)[vc.merchantCollectionView cellForItemAtIndexPath:indexPath];
            collectCell.collectBtn.selected = YES;
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"收藏失败" duration:2.0 position:@"center"];
        
        
    }];
    
    
    
}
-(void)delMerchantFavoriteRequest:(NSString *)merchantNo withIndexPath:(NSIndexPath *)indexPath{
    
    __weak MerchantListViewController *vc = self;

    
    [HttpManager sendHttpRequestForDelMerchantFavorite:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!取消收藏成功
            
            MerchantCell * collectCell = (MerchantCell *)[vc.merchantCollectionView cellForItemAtIndexPath:indexPath];
            collectCell.collectBtn.selected = NO;
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"取消收藏失败" duration:2.0 position:@"center"];
        
        
    }];
    
    
}


-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];
    
    //!此界面不隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    self.navigationController.navigationBar.hidden = NO;
    
    
    
    // !如果是从登录界面过来的，则刷新界面(现在第一次进入的是商品界面，这里不需要做操作了)
//    if ([MyUserDefault defaultLoadLogined]) {
//        
//        [self requestMerchantList:self.refreshHeader];
//        
//        [MyUserDefault removeLogined];// !删除本地记录
//        
//    }
    
    //注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    revealController.delegate = self;
    revealController.rearViewController = [[MerchantLeftSlideController alloc]init];//!左边的筛选界面
    revealController.rearViewRevealWidth = SCREEN_WIDTH *0.4f;

    if (revealController && revealController.panGestureRecognizer) {//!消失的时候会被移除掉，所以要先判断是否存在，如果不存在添加手势会崩溃
       
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
 
        
    }

    //!请求采购车数量、站内信数量
    [self requestPerCenterInfoForShopCar];
    
    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideLeft) name:@"HideLeft" object:nil];

    
    //!以防注册进来有键盘
    [self.view endEditing:YES];
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideLeft" object:nil];


}
-(void)hideLeft{

    //!如果侧拉是打开的，就关起来
    if (isOpen) {
        
        [self leftNavClick];
        
    }

}

#pragma mark 收到商家 收藏的通知
-(void)changeCellStatus:(NSNotification *)notification{

    NSDictionary *dic=notification.userInfo;

    NSString * changeMerchantNo = dic[@"merchantNo"];
    NSString * changeFavoriterStatus = dic[@"collectStatus"];
    
    NSIndexPath *changeIndexPath ;
    

    for (int i=0; i<dataArray.count ;i++) {
        
        MerchantListDetailsDTO * detailDTO = dataArray[i];
        //!找到被改变的那一行
        if ([detailDTO.merchantNo isEqualToString:changeMerchantNo]) {
            
            detailDTO.isFavorite = changeFavoriterStatus;
            
            changeIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.merchantCollectionView reloadItemsAtIndexPaths:@[changeIndexPath]];
            
            break;
            
            
        }
        
    }
    
   
}
#pragma mark 收到 商家列表 侧滑框 点击商家分类 进入对应商家列表的通知
-(void)intoMerchantSearchResult:(NSNotification *)notification{

    NSDictionary *dic=notification.userInfo;
    NSString * categoryNo = dic[@"categoryNo"];
    NSString * categoryName = dic[@"categoryName"];
  
    
    SearchMerchatResultController * resultVC = [[SearchMerchatResultController alloc]init];
    resultVC.isSearchMerchant = YES;//!搜索的是商家
    resultVC.isFilter = YES;//!筛选 侧滑菜单 进行筛选进入的
    resultVC.categoryNo = categoryNo;
    resultVC.categoryName = categoryName;
    
    [self.navigationController pushViewController:resultVC animated:NO];


}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CHANGECOLLECTSTATUS" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"MerchantSearchResult" object:nil];

    

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
