//
//  StoreTagViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "StoreTagViewController.h"
#import "ZJModifyViewController.h"
#import "HttpManager.h"

#import "UICollectionViewLeftAlignedLayout.h"
#import "StoreTagLisrtModel.h"
#import "StoreTagModel.h"
#import "SectionHeaderViewCollectionReusableView.h"

#import "MyCollectionViewCell.h"
#import "NoStoreTagView.h"

#import "GoodsLagViewController.h"


#import "ModifyViewController.h"
#import "ModifyStoreTagViewController.h"
#import "GoodsTagCollectionViewCell.h"

@interface StoreTagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NoStoreTagViewDelegate>
{
    NoStoreTagView *noStoreTagView;
}
@property(nonatomic,strong)UIButton *modifyButton;
@property(nonatomic, strong)UICollectionView *collection;
@property (nonatomic,strong)NSMutableArray *listArray;
//添加一个可变数组
@property (nonatomic,strong)NSMutableArray *allStoreTagArr;
@property (nonatomic,strong)NSMutableArray *otherStoreTagArr;



@end

@implementation StoreTagViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    
}

//进行数据请求
-(void)getData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    // 进行数据请求
    [HttpManager  sendHttpRequestForUpdateStoreTagSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" dic==== %@",dic);
            
            
            //进行初始化
            
            _listArray = [[dic objectForKey:@"data"] objectForKey:@"fixed"];
            
            _otherStoreTagArr = [[dic objectForKey:@"data"] objectForKey:@"other"];
            
            NSString *totalCount = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
            
            for (NSDictionary *dicIofo in _listArray) {
                [_allStoreTagArr addObject:dicIofo];
            }
            
            for (NSDictionary *otherDic in _otherStoreTagArr) {
                
                [_allStoreTagArr addObject:otherDic];
            }
          
            
            if (totalCount.integerValue == 0 ) {
                
                noStoreTagView.hidden = NO;
                self.modifyButton.hidden = YES;
                
            }else
            {
                _collection.hidden = NO;
                self.modifyButton.hidden = NO;
                noStoreTagView.hidden = YES;
                self.modifyButton.hidden = NO;
            }
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [self.collection reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_allStoreTagArr removeAllObjects];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"店铺标签";
    //设置返回按钮
     [self customBackBarButton];
    _listArray = [NSMutableArray arrayWithCapacity:0];
    _allStoreTagArr = [NSMutableArray arrayWithCapacity:0];
    _otherStoreTagArr = [NSMutableArray arrayWithCapacity:0];

    //设置UI
    [self makeUI];
    
}
#pragma mark ==========设置UI=============
-(void)showNoStoreTagsView
{
   
    _collection.hidden = YES;
    self.modifyButton.hidden = YES;

}
//进入到添加标签页面
-(void)joinNextPage
{
    
    ModifyStoreTagViewController *modifyVC = [[ModifyStoreTagViewController alloc]init];
    [self.navigationController pushViewController:modifyVC animated:YES];
    
}


//设置UI
-(void)makeUI
{
    //视图

    //设置浮框
    self.modifyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.modifyButton.frame = CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49);
    self.modifyButton.backgroundColor = [UIColor yellowColor];
    [self.modifyButton setTitle:@"修改标签" forState:(UIControlStateNormal)];
    [self.modifyButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.modifyButton];
    [self.modifyButton addTarget:self action:@selector(setJoinNextPage) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.modifyButton setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
    [self.modifyButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.modifyButton setFont:[UIFont systemFontOfSize:16]];


    //视图展示
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(15,  11, self.view.frame.size.width-30 , self.view.frame.size.height - 49 - 11 - 64) collectionViewLayout:flowLayout];
    [_collection registerClass:[SectionHeaderViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [_collection registerClass:[GoodsTagCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.view  addSubview:_collection];
    
    
    noStoreTagView = [[[NSBundle mainBundle]loadNibNamed:@"NoStoreTagView" owner:nil options:nil]lastObject];
    
    noStoreTagView.center = self.view.center;
    noStoreTagView.delegate = self;
    [self.view addSubview:noStoreTagView];
    noStoreTagView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
    noStoreTagView.center = self.view.center;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_allStoreTagArr[section]];
    
    return getStoreTagListDTO.storeTagList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    static NSString *cellId = @"identifier";
    
    
    GoodsTagCollectionViewCell *cell = (GoodsTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_allStoreTagArr[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    
    cell.tagNameLabel.text = storeTagModel.labelName;

    if ([storeTagModel.flag isEqualToString:@"0"]) {
        cell.tagNameLabel.backgroundColor = [UIColor blackColor];
        [cell.tagNameLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    }
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _allStoreTagArr.count;
}
#pragma mark 头视图size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {self.view.frame.size.width, 30.0};
    return size;
}
#pragma mark 每个Item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_allStoreTagArr[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    
    CGFloat width =    [self gainFontWidthContent:storeTagModel.labelName];

    return CGSizeMake(width + 40, 30);

}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    SectionHeaderViewCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_allStoreTagArr[indexPath.section]];
    
    headView.titleLabel.text = getStoreTagListDTO.labelCategory;
    
    return headView;
    
}

#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setJoinNextPage
{
    ModifyStoreTagViewController *goodTag = [[ModifyStoreTagViewController alloc]init];
    [self.navigationController pushViewController:goodTag animated:YES];
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

@end
