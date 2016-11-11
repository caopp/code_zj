//
//  GoodsClassViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CommodityClassification.h"
#import "GoodsClassViewController.h"
#import "CommodityClassificationDTO.h"
#import "SWRevealViewController.h"
#import "LeftSlideViewController.h"
#import "ClassNameCollectionCell.h"
#import "CustomBarButtonItem.h"
#import "AllGoodsViewController.h"//!全部商品列表
#import "EqualSpaceFlowLayout.h"
#import "MerchantAndGoodSelectView.h"//!商家、商品的切换view
#import "SearchView.h"//!假搜索框
#import "SearchMerhcantAndGoodController.h"//!搜索界面
#import "GoodsFilterViewController.h"//!商品筛选页面

@interface GoodsClassViewController ()<UITableViewDataSource ,UITableViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegate ,SWRevealViewControllerDelegate, EqualSpaceFlowLayoutDelegate>
{
    UIButton *selectTempBtn;
    //!搜索view
    SearchView * searchView;

}
@property(nonatomic,assign)MerchantAndGoodSelectView * headerSelectView;
@property(nonatomic,assign)BOOL isSearchMerchant;//!搜索的是否是商家


@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIView *superTableView;
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UIView *superCollectionView;
@property (nonatomic ,strong)CommodityClassification *commoditClassData;
@property (nonatomic ,strong) NSArray *classArr;

@property (nonatomic ,strong) ClassNameCollectionCell *recordCell;

@end

@implementation GoodsClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , 110, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //设置默认的背景颜色
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去掉cell多余的横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.itemSize = CGSizeMake(75,30);
//    flowLayout.minimumInteritemSpacing = 10.0f;
//    flowLayout.minimumLineSpacing = 10.0f;
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.delegate = self;


    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(110, 0 , self.view.frame.size.width-110, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.contentSize = CGSizeMake(self.view.frame.size.width-110, self.view.frame.size.height+50);
    collectionView.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
    self.collectionView.alwaysBounceVertical = YES;

    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [collectionView registerClass:[ClassNameCollectionCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    
    
    //请求所有分类数据
    [HttpManager sendHttpRequestForGetCategoryListWithMerchantNo:@"" withQueryType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:CODE] isEqualToString:@"000"]) {
            //创建数据模型
            self.commoditClassData = [[CommodityClassification alloc] initWithDictionaries:[dic objectForKey:@"data"]];
            //默认设置第一个标题
            
            [self.tableView reloadData];
            
            
            CommodityClassificationDTO *commodityClassDto = [self.commoditClassData.primaryCategory objectAtIndex:0];
            
            NSNumber *classKey = commodityClassDto.id;
            
            self.classArr = [self.commoditClassData.secondaryCategory objectForKey:classKey];
            
            [self.collectionView reloadData];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@", error);
    }];
}

- (void)popNav
{
    
    
//    SWRevealViewController *revealVC = self.revealViewController;
//    [revealVC setFrontViewController:[[LeftSlideViewController alloc] init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - TableViewdelegate&&dataScource
//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commoditClassData.primaryCategory.count;
}

//返回cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    //获取模型对象
    CommodityClassificationDTO *commodityDto = [self.commoditClassData.primaryCategory objectAtIndex:indexPath.section];
    //设置每个cell的背景颜色
    cell.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];

    
    //设置字体的颜色
    cell.textLabel.textColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    
    
    if (indexPath.section == 0) {
        
        cell.textLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        cell.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
        
    }
    
    //赋值
    cell.textLabel.text = commodityDto.categoryName;
    
    //设置fontx
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
}


//设置head的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

//设置footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //刷新所有数据，默认为重置状态
    [tableView reloadData];
    
    //如果选择
    if (self.recordCell) {
        
        self.recordCell.textLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        self.recordCell.textLabel.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
//        self.recordCell.textLabel.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    }
    
    
    //取出第一个行到cell
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cellNormal = [tableView cellForRowAtIndexPath:selectedIndexPath];
    //设置背景和字体颜色为默认的
    cellNormal.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    cellNormal.textLabel.textColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    
    //获取点中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //更高字体颜色和背景
    cell.textLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];

    cell.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];

    
    CommodityClassificationDTO *commodityClassDto = [self.commoditClassData.primaryCategory objectAtIndex:indexPath.section];
    NSNumber *classKey = commodityClassDto.id;
    
    self.classArr = [self.commoditClassData.secondaryCategory objectForKey:classKey];

    [self.collectionView reloadData];
    
  
    
}

#pragma mark - UICollectionViewDelegate&&DatacollectionView:layout:sizeForItemAtIndexPathSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classArr.count;
}

- (ClassNameCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"collectionViewCell";
    
    ClassNameCollectionCell *cell = (ClassNameCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];

//    cell.backgroundColor = [UIColor redColor];
    CommodityClassificationDTO *commodityClassDto = [self.classArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = commodityClassDto.categoryName;
    return cell;
    
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//};
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CommodityClassificationDTO *commodityClassDto = [self.classArr objectAtIndex:indexPath.row];
    
   CGFloat width =  [self gainFontWidthContent:commodityClassDto.categoryName]+16;
    
    return CGSizeMake(width, 30);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self.collectionView reloadData];
    
    if (self.recordCell) {
        self.recordCell.textLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        self.recordCell.textLabel.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
        self.recordCell.textLabel.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    }

    ClassNameCollectionCell *classNameCell =(ClassNameCollectionCell*) [collectionView cellForItemAtIndexPath:indexPath];
    self.recordCell = classNameCell;
    
    classNameCell.textLabel.layer.borderColor = [UIColor colorWithHexValue:0x673ab7 alpha:1].CGColor;
    classNameCell.textLabel.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
    classNameCell.textLabel.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:0.5f];
    
    CommodityClassificationDTO *commodityClassDto = [self.classArr objectAtIndex:indexPath.row];
    
    GoodsFilterViewController * goodsFilterVC = [[GoodsFilterViewController alloc]init];
    goodsFilterVC.structNo = commodityClassDto.structureNo;
    if ([commodityClassDto.categoryName isEqualToString:@"全部"]) {
        NSString *structName = [[commodityClassDto.structureName componentsSeparatedByString:@"-"] firstObject];
        goodsFilterVC.structName = structName;
        
    }else
    {
        goodsFilterVC.structName = commodityClassDto.categoryName;

    }
    
    [self.navigationController pushViewController:goodsFilterVC animated:YES];

    
//    AllGoodsViewController *goodsVC = [[AllGoodsViewController alloc]init];
//    goodsVC.isFromFilter = YES;//!标志从筛选界面进入的
//    goodsVC.structNo = commodityClassDto.structureNo;
//    goodsVC.structName = commodityClassDto.categoryName;
//    
//    [self.navigationController pushViewController:goodsVC animated:YES];
    

}

/**
 *  计算字体宽度
 *
 *  @param content 输入的内容
 *
 *  @return 返回字体的宽度
 */
- (CGFloat)gainFontWidthContent:(NSString *)content
{
    CGSize size;
    
    size=[content boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    return size.width;
    

}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //!隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    //!搜索的是否是商家
    self.isSearchMerchant = NO;

    //!创建导航
    [self createNav];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

    //!删除导航上面的控件
    if (_headerSelectView) {
        
        [_headerSelectView removeFromSuperview];
        [searchView removeFromSuperview];
    }
    


}
#pragma mark 创建导航
-(void)createNav{

    [self addCustombackButtonItem];
    
    __weak GoodsClassViewController * vc = self;

    //!商家、商品分类切换view
    _headerSelectView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantAndGoodSelectView" owner:self options:nil]lastObject];
    _headerSelectView.frame = CGRectMake(15+10 + 27, (self.navigationController.navigationBar.frame.size.height - _headerSelectView.frame.size.height/2)/2, _headerSelectView.frame.size.width, _headerSelectView.frame.size.height/2);//!先只显示一半
    
    [_headerSelectView setDataisFromMerchant:self.isSearchMerchant];//!设置按钮上面的数据，如果是从搜索商家传入yes
    [_headerSelectView setBackgroundColor:[UIColor clearColor]];
    
    _headerSelectView.changHightBlock = ^(BOOL isSelectBtn){
        
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
            searchView.leftLabel.text = @"搜索商家";
            
        }else{
            
            self.isSearchMerchant = NO;
            searchView.leftLabel.text = @"搜索商品";

        }
        
        if (isSelectBtn) {//!参数：是否点击了按钮（如果点击按钮就调到搜索界面）
            
            [vc intoSearchVC];
            
            
        }
        
        
        
    };
    [self.navigationController.navigationBar addSubview:_headerSelectView];
    
    
    
    //!搜索view
    searchView = [[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
    searchView.searchViewTapBlock = ^(){//!点击搜索框的时候调用的方法
        
        [vc intoSearchVC];
        
    };
    if ([_headerSelectView.firstBtn.titleLabel.text isEqualToString:@"商家"]) {
        
        searchView.leftLabel.text = @"搜索商家";

    }else{
        searchView.leftLabel.text = @"搜索商品";
    
    }
    searchView.frame = CGRectMake(CGRectGetMaxX(_headerSelectView.frame)+6, _headerSelectView.frame.origin.y, self.navigationController.navigationBar.frame.size.width - CGRectGetMaxX(_headerSelectView.frame)-6 -7, 30);
    
    [self.navigationController.navigationBar addSubview:searchView];



}
//!进入搜索界面
-(void)intoSearchVC{
    
    SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
    searchVC.isSearchMerchant = self.isSearchMerchant;//!搜索的是商家传入 yes，搜索的是商品 传入no
    [self.navigationController pushViewController:searchVC animated:NO];
    
    
}
-(void)tempBtnClick{
    
    [_headerSelectView secondBtnClick];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
