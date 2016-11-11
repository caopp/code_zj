//
//  SelectedAreaViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SelectedAreaViewController.h"

#import "SelectedAreaListModel.h"
#import "SelectedAreaModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "MyCollectionViewCell.h"

@interface SelectedAreaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


{
    NSString *strID;
    NSString *nameStr;

}
@property (nonatomic,strong)NSMutableArray *allAreaList;
//进行布局
@property(nonatomic, strong)UICollectionView *collection;

@property(nonatomic,strong)NSMutableArray *selectedAreaID;


@property(nonatomic,strong)NSMutableArray *nameStr;

@end

@implementation SelectedAreaViewController

-(NSMutableArray *)nameStr
{

    if ( _nameStr == nil) {
        _nameStr = [NSMutableArray arrayWithCapacity:0];
    }
    return _nameStr;
}


-(NSMutableArray *)selectedAreaID
{
    if (_selectedAreaID == nil) {
        
        _selectedAreaID = [NSMutableArray arrayWithCapacity:0];
           }
    return  _selectedAreaID;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"请选择地区";
    self.selectedAreaID = [NSMutableArray arrayWithCapacity:40];


    //获取省市区
    [self getData];
    //设置UI界面
    [self makeUI];
    //设置返回按钮
    [self setCustomBackBarButton];
    
}

#pragma mark ======获取省市区====
-(void)getData
{
    
    
    //网络请求提示progressHUDShow
    [self progressHUDShowWithString:@"请求中"];
    
    [HttpManager sendHttpRequestForGetAreaListByParentIdWithParentId:[NSNumber numberWithInt:0]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            _allAreaList = [dic objectForKey:@"data"];
            SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
            for (NSDictionary *dictionary in _allAreaList) {
                
                [selectedAreaModel setDictFrom: dictionary];
                self.progressHUD.hidden = YES;
            }
            
        }else
        {
            /**
             *  操作失败 隐藏提示 出错原因
             */
            self.progressHUD.hidden = YES;
            
            [self alertViewWithTitle:@"操作失败" message:[dic objectForKey:ERRORMESSAGE]];
        }
         [_collection reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    
    
    }];
}



#pragma mark ====设置UI=====
-(void)makeUI
{
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(15,  50, self.view.frame.size.width-30 , self.view.frame.size.height) collectionViewLayout:flowLayout];
       _collection.scrollEnabled = NO;
    _collection.delegate = self;
    _collection.dataSource = self;

    _collection.backgroundColor = [UIColor whiteColor];
    [_collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:_collection];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _allAreaList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
    
    [selectedAreaModel setDictFrom:_allAreaList[indexPath.row]];

    cell.label.text = selectedAreaModel.name;
    
    [cell layoutSubviews];
    
    return cell;
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
    
    SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
    [selectedAreaModel setDictFrom:_allAreaList[indexPath.row]];
    
    CGSize contentSize = [selectedAreaModel.name boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    return CGSizeMake(contentSize.width + 30, 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell*)[_collection cellForItemAtIndexPath:indexPath];
    
    cell.isOk = !cell.isOk;
    
    [self updateCollectionViewCellStatus:cell selected:cell.isOk];
    
    SelectedAreaModel *selectedAreaModel = [[SelectedAreaModel alloc]init];
    
    [selectedAreaModel setDictFrom:_allAreaList[indexPath.row]];
    
    if (cell.isOk) {
        [self.selectedAreaID addObject:selectedAreaModel.Id];
        
        [self.nameStr addObject:selectedAreaModel.name];
    }else
    {
        [self.selectedAreaID  removeObject:selectedAreaModel.Id];
        
        [self.nameStr removeObject:selectedAreaModel.name];
    }
    
   
    NSLog(@"strID === %@   nameStr === %@",strID,nameStr);
    
    strID = [self.selectedAreaID  componentsJoinedByString:@","];
    
    nameStr = [self.nameStr componentsJoinedByString:@","];
    
    self.selectedAllAreas(strID,nameStr);

    
}

-(void)updateCollectionViewCellStatus:(MyCollectionViewCell *)myCollectionCell selected:(BOOL)selected
{
    
    if (selected) {
        myCollectionCell.label.backgroundColor = [UIColor blackColor];
        [myCollectionCell.label setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
        
    }else
    {
        myCollectionCell.label.backgroundColor = [UIColor whiteColor];
        [myCollectionCell.label setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    }
}
#pragma mark =============设置按钮==============
//设置返回按钮
- (void)setCustomBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
