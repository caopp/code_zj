
//
//  ShowGoodsTagViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ShowGoodsTagViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "GoodsTagCollectionViewCell.h"
#import "Masonry.h"
#import "GoodsAlllTagDTO.h"
#import "GoodsLagCollectionReusableView.h"
#import "GoodsLagViewController.h"
#import "PromptGoodsTagsViewController.h"
#import "EditGoodsViewController.h"

@interface ShowGoodsTagViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate >

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,assign) BOOL isRequest;


@end

@implementation ShowGoodsTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //s设置左导航
    [self customBackBarButton];
    
    self.title = @"设置商品标签";
    //6.  设置flowLayout
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    //6.1 设置head的宽和高
    flowLayout.headerReferenceSize = CGSizeMake(375, 50);
    
    
    //7.  设置collectionView
    UICollectionView*collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, 300) collectionViewLayout:flowLayout];
    
    
    //7.1 设置背景颜色
    collectionView.backgroundColor = [UIColor whiteColor];
    //7.2 控制控件不能滚动
//    collectionView.scrollEnabled = NO;
    collectionView.alwaysBounceVertical = YES;
    
    
    //7.3 赋给全局变量
    self.collectionView = collectionView;
    //7.4 添加到topView中
    [self.view addSubview:collectionView];
    //7.5 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //7.5 注册collectionViewCell
    [collectionView registerClass:[GoodsTagCollectionViewCell class] forCellWithReuseIdentifier:@"goodsTagCollectionViewCell1"];
    //7.6 注册collectionViewHead
    [collectionView registerNib:[UINib nibWithNibName:@"GoodsLagCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"goodsTagCollectionHeadView"];
    //7.7 布局collectionView
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-46);
    }];
    
    
    
    UIButton *changeTagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:changeTagsBtn];
    
    [changeTagsBtn setTitle:@"修改" forState:UIControlStateNormal];
    changeTagsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    changeTagsBtn.backgroundColor = [UIColor blackColor];
    [changeTagsBtn addTarget:self action:@selector(schangeTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [changeTagsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@46);
        
    }];

}


- (void)viewWillAppear:(BOOL)animated
{
    
    if (self.goodsNo) {
        
        [HttpManager sendHttpRequestForgoodsGetLabelListByGoodsNo:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            GoodsAlllTagDTO *goodsAll = [[GoodsAlllTagDTO alloc] init];
            [goodsAll setDictFrom:dict[@"data"]];
            
            DebugLog(@"dict = %@", dict);
            if ([dict checkLegitimacyForData:@"000"]) {
                NSLog(@"请求成功");
                //设置需要传的数据
                NSMutableArray *allOrder = [NSMutableArray array];
                
                //判断固定标签是否存在
                if (goodsAll.fixedArr.count>0) {
                    for (FixedTagDTO *fixDto in goodsAll.fixedArr) {
                        [allOrder addObject:fixDto];
                        
                        
                        
                    }
                }
                
                //判断临时标签是否存储
                if (goodsAll.otherArr.count>0) {
                    for (FixedTagDTO *otherDto  in goodsAll.otherArr) {
                        [allOrder addObject:otherDto];
                    }
                }
                
                //判断是否有数据，没有数据跳转到商品标签
                if (allOrder.count>0) {
                    
                    self.tagsArr = allOrder;
                    [self.collectionView reloadData];
                    
//                    ShowGoodsTagViewController *showGoodsVC = [[ShowGoodsTagViewController alloc] init];
//                    showGoodsVC.tagsArr = allOrder;
//                    showGoodsVC.goodsNo = self.goodsNo;
//                    [self.navigationController pushViewController:showGoodsVC animated:YES];
                    
                }else
                {
                    PromptGoodsTagsViewController *promptGoodsVC = [[PromptGoodsTagsViewController alloc] init];
                    promptGoodsVC.goodsNo = self.goodsNo;
                    [self.navigationController pushViewController:promptGoodsVC animated:YES];
                    
                }
                
                
                
                
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"error = %@", error);
            
            
        }];
    }
    
}
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[EditGoodsViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}


#pragma mark - collectionViewDelegate&&dataSource

//cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSArray *keys = self.dictData.allKeys;
    //    NSArray *values = [self.dictData objectForKey:[keys objectAtIndex:section]];
    //    return values.count;
    
//    FixedTagDTO *fixed = self.goodsAllDto.fixedArr[section];
    

//    return fixed.listArr.count;
    
    FixedTagDTO *fixedDto =self.tagsArr[section];
    
    
    return fixedDto.listArr.count;
    
}

//section 个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //    NSArray *keys = self.dictData.allKeys;
    //    return keys.count;
    
//    return self.goodsAllDto.fixedArr.count;
    return self.tagsArr.count;
}

//显示cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goodsTagCollectionViewCell1";
    
    
    GoodsTagCollectionViewCell *cell = (GoodsTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
 
    
    if (self.tagsArr.count>0) {
    
    FixedTagDTO *fixedDto =self.tagsArr[indexPath.section];
    ListTagDTO *listDto = fixedDto.listArr[indexPath.row];
    cell.tagNameLabel.text = listDto.labelName;
    }
    

    return cell;
}


//显示headView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //设置reusableview
    UICollectionReusableView *reusableview = nil;
    
    //获取headView
    GoodsLagCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"goodsTagCollectionHeadView" forIndexPath:indexPath];
    FixedTagDTO *fixedDto = self.tagsArr[indexPath.section];
    
    headView.goodsLagCollectionLabel.text = fixedDto.labelCategory;

    
    reusableview = headView;
    
    return reusableview;
    
}

//返回headView的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 0) {
       return CGSizeMake(375, 40);
    }
    return CGSizeMake(375, 20);
    
}

//返回cell的每个宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FixedTagDTO *fixedDto =self.tagsArr[indexPath.section];
    ListTagDTO *listDto = fixedDto.listArr[indexPath.row];
    
    NSString *value =  listDto.labelName;

    
    //根据内容获取宽高
    CGFloat width =    [self gainFontWidthContent:value];
    return CGSizeMake(width+40, 30);
}


//设置每个cell的top,left,bottom,right
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0 , 15, 10, 20);
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

#pragma mark - GoodsLagDelegate
/**
 *  返回需要请求数据
 *
 *  @param isRequest yes 刷新请求，no不请求
 */
- (void)GoodsLagSaveSuccess:(BOOL)isRequest
{
    self.isRequest = isRequest;
}

//修改按钮
- (void)schangeTagBtn:(UIButton *)btn
{
    GoodsLagViewController *goodsLagVC = [[GoodsLagViewController alloc] init];
    goodsLagVC.goodsNo = self.goodsNo;
    
    [self.navigationController pushViewController:goodsLagVC animated:YES];
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
