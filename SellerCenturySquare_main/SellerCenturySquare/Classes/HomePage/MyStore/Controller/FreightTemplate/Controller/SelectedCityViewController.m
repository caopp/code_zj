//
//  SelectedCityViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#define kControllerHeaderViewHeight                90
#define kControllerHeaderToCollectionViewMargin    0
#define kCollectionViewCellsHorizonMargin          12
#define kCollectionViewCellHeight                  30
#define kCollectionViewItemButtonImageToTextMargin 5

#define kCollectionViewToLeftMargin                16
#define kCollectionViewToTopMargin                 12
#define kCollectionViewToRightMargin               16
#define kCollectionViewToBottomtMargin             10

#define kCellImageToLabelMargin                    10
#define kCellBtnCenterToBorderMargin               19

#import "SelectedCityViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "CollectionViewCell.h"
#import "CollectionHeaderView.h"
#import "SelectedAreaModel.h"


typedef void(^ISLimitWidth)(BOOL yesORNo,id data);


static NSString * const kCellIdentifier           = @"CellIdentifier";
static NSString * const kHeaderViewCellIdentifier = @"HeaderViewCellIdentifier";
@interface SelectedCityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

{
    NSArray *provinces, *cities, *areas;
    
    NSString *strID;
    
    NSString *nameStr;
    
    //下面字符串
    NSString *modelStr;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;




//添加一个装载model的数组
@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,strong)NSMutableArray *thereArr;

@property (nonatomic,strong)NSArray *singleArr;

@property (nonatomic,strong)NSArray *countArray;

//一个数组添加，一个数组减少
//添加
//@property (nonatomic,strong)NSMutableArray *nameArr;
//减少
@property (nonatomic,strong)NSMutableArray *idArr;

@property (nonatomic,strong)NSMutableArray *allAreaList;
@property (nonatomic,strong)NSMutableArray *nameArr;

@end

@implementation SelectedCityViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark =====获取省市区======
-(void)getData
{
    //model类型
    _modelArr = [[NSMutableArray alloc]initWithCapacity:0];
    //选中的
    _thereArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //获取到的cell上的字符串进行切割
    if (self.type.integerValue == 0) {
        
        _singleArr =[self.cellCityID componentsSeparatedByString:@","];
        
    }else
    {
        _countArray = [self.cellCountCityID componentsSeparatedByString:@","];
    }

     [HttpManager sendHttpRequestForGetAreaListByParentIdWithParentId:[NSNumber numberWithInt:0]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
     
         if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
     
             provinces = [dic objectForKey:@"data"];
     
             for (NSDictionary *dictionary in provinces) {
     
                 NSNumber *stateId = [dictionary objectForKey:@"id"];
         
                 SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
         
                 [selectedAreaModel setDictFrom:dictionary];
                 
         
                 if (self.type.integerValue == 0) {
             
             //数组中传值
                     if (![self.cityIDArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
                 
                         [_modelArr addObject:selectedAreaModel];
                 
                     }
             
             //进行cell的字符串
                     if ([_singleArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
                 
                         [_thereArr addObject:selectedAreaModel];
                         
                     }
             
                 }else
                 {
             //数组中传值
                     if (![self.cityCoiuntIDArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
                 
                         [_modelArr addObject:selectedAreaModel];
                     }
             
             //字符串
                     if ([_countArray containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
                 
                         [_thereArr addObject:selectedAreaModel];
                     }
             
                 }
     
                 self.progressHUD.hidden = YES;
             }
             [self.collectionView reloadData];
     }else
     {
         self.progressHUD.hidden = YES;
     
         [self alertViewWithTitle:@"操作失败" message:[dic objectForKey:ERRORMESSAGE]];
     }
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];

}



#pragma mark ======获取省市区====

//-(void)getData
//{
// 
//    //model类型
//    _modelArr = [[NSMutableArray alloc]initWithCapacity:0];
//    //选中的
//    _thereArr = [[NSMutableArray alloc]initWithCapacity:0];
//    
//    
//    //获取到的cell上的字符串进行切割
//    if (self.type.integerValue == 0) {
//        
//        _singleArr =[self.cellCityID componentsSeparatedByString:@","];
//        
//    }else
//    {
//        _countArray = [self.cellCountCityID componentsSeparatedByString:@","];
//    }
//     
//    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaData.plist" ofType:nil]];
//    
//    
//    for (NSDictionary *dic  in provinces) {
//    
//        NSNumber *stateId = [dic objectForKey:@"id"];
//        
//        SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
//        
//        [selectedAreaModel setDictFrom:dic];
//        
//        if (self.type.integerValue == 0) {
//            
//            //数组中传值
//            if (![self.cityIDArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
//                
//                [_modelArr addObject:selectedAreaModel];
//                
//            }
//                
//            //进行cell的字符串
//            if ([_singleArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
//                
//                [_thereArr addObject:selectedAreaModel];
//            }
//            
//        }else
//        {
//            //数组中传值
//            if (![self.cityCoiuntIDArr containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
//                
//                [_modelArr addObject:selectedAreaModel];
//            }
//            
//            //字符串
//            if ([_countArray containsObject:[NSString stringWithFormat:@"%@",stateId]]) {
//                
//                [_thereArr addObject:selectedAreaModel];
//            }
//        
//        }
//        
//     }
//    
//        [self.collectionView reloadData];
//
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"请选择地区";
    
    [self getData];
    
    self.dataSource = [NSMutableArray array];
        
    [self.dataSource addObject:_thereArr];
    
    [self.dataSource addObject:_modelArr];
    
    //添加
    _nameArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //减少
    _idArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //保存按钮
    [self customSaveBarButton];

    [self addCollectionView];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置返回按钮
    [self customBackBarButton];

}

- (void)addCollectionView {
    
    CGRect collectionViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60);
    UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.allowsMultipleSelection = YES;
    
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier];
    
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.collectionView.scrollsToTop = NO;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     return [self.dataSource count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray * array = self.dataSource[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    NSMutableArray * array = self.dataSource[indexPath.section];
    
    SelectedAreaModel *selectedAreaModel = array[indexPath.row];
    
    if (indexPath.section == 0) {
        
        cell.titleLabel.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        [cell.titleLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
        
    }else
    {
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
        [cell.titleLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    }

        cell.titleLabel.text = selectedAreaModel.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",indexPath.row);

    if (indexPath.section==0) {
        
        SelectedAreaModel *model = _thereArr[indexPath.row];
        
        NSString *stateid = [NSString stringWithFormat:@"%@",model.Id];
        
        if (self.type.integerValue == 0) {
            if ([_cityIDArr containsObject:stateid]) {
                [_cityIDArr removeObject:stateid];
            }
        }else
        {
            if ([_cityCoiuntIDArr containsObject:stateid]) {
                [_cityCoiuntIDArr removeObject:stateid];
            }
        }
    
        [_modelArr addObject:_thereArr[indexPath.row]];
        [_thereArr removeObjectAtIndex:indexPath.row];
        
    }else{
        
        [_thereArr addObject:_modelArr[indexPath.row]];
        
        [_modelArr removeObjectAtIndex:indexPath.row];
    }
    
    [self.dataSource replaceObjectAtIndex:0 withObject:_thereArr];
    [self.dataSource replaceObjectAtIndex:1 withObject:_modelArr];
    
    [self.collectionView reloadData];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier forIndexPath:indexPath];
        NSString * str = indexPath.section == 0 ? @"已选择地区":@"点击加载更多地区";
        headerView.titleLabel.text = str;
        return (UICollectionReusableView *)headerView;
    }
    
    return nil;
}





- (float)getCollectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:13]}];
    
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    cellWidth = [self checkCellLimitWidth:cellWidth isLimitWidth:nil];
    return cellWidth;
}


- (float)checkCellLimitWidth:(float)cellWidth isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.collectionView.frame)-kCollectionViewToLeftMargin-kCollectionViewToRightMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth?isLimitWidth(YES,@(cellWidth)):nil;
        return cellWidth;
    }
    isLimitWidth?isLimitWidth(NO,@(cellWidth)):nil;
    return cellWidth;
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // cell 的宽
    NSMutableArray * array = self.dataSource[indexPath.section];
    
    SelectedAreaModel *areaModel = array[indexPath.row];
    
    float cellWidth = [self getCollectionCellWidthText:areaModel.name];
    
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsHorizonMargin;//cell之间的间隔
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 38);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //四周边距
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}


//设置返回按钮
- (void)customSaveBarButton{
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(backBarButton:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
}


//返回按钮执行事件
- (void)backBarButton:(UIBarButtonItem *)sender{

    
     for (SelectedAreaModel *model in _thereArr) {

         if (![self.cityIDArr containsObject:[NSString stringWithFormat:@"%@",model.Id]]) {
             
            [_nameArr addObject:model.name];
             
            [_idArr  addObject:model.Id];
             
         }else if(![self.cityCoiuntIDArr containsObject:[NSString stringWithFormat:@"%@",model.Id]])
         {

             [_nameArr addObject:model.name];
             
             [_idArr  addObject:model.Id];
         }
     }
    
    

     strID = [_idArr  componentsJoinedByString:@","];
    
     nameStr = [_nameArr componentsJoinedByString:@","];
    
    
    //下部分ID数组
    NSMutableArray *unSeletedArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    for ( SelectedAreaModel *model in _modelArr) {
        
        [unSeletedArr addObject:model.Id];
        
    }
     self.selectedAllAreas(strID,nameStr,unSeletedArr);
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(didBackBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)didBackBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
