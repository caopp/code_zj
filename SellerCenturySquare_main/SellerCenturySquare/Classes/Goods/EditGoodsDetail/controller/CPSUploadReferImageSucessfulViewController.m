//
//  CPSUploadReferImageSucessfulViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSUploadReferImageSucessfulViewController.h"
#import "CPSChooseUploadReferImageCollectionViewCell.h"
#import "CSPCustomCollectionViewHeadView.h"
#import "CSPCustomCollectionViewFootView.h"
#import "GetImageReferImageHistoryListDTO.h"
#import "CPSUploadReferImageViewController.h"
#import "CPSGoodsDetailsEditViewController.h"
#import "EditGoodsViewController.h"

@interface CPSUploadReferImageSucessfulViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)uploadReferImgaeButtonClick:(id)sender;

@property (strong,nonatomic)NSMutableArray *dataResourceArray;

@end

@implementation CPSUploadReferImageSucessfulViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"上传参考图";
    
    [self customBackBarButton];
    
    self.dataResourceArray = [[NSMutableArray alloc]init];
    
    DebugLog(@"goodsNo = %@", self.goodsNo);
    
    //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"CPSChooseUploadReferImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CPSChooseUploadReferImageCollectionViewCell"];
    
    //注册headerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"CSPCustomCollectionViewHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSPCustomCollectionViewHeadView"];
    
    //注册footerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"CSPCustomCollectionViewFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CSPCustomCollectionViewFootView"];
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    //返回到CPSGoodsDetailsEditViewController
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[EditGoodsViewController class]]) {
            
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //请求参考图历史记录
    [self requestReferImage];
    
}

#pragma mark-请求参考图历史记录
- (void)requestReferImage{
    
    [self progressHUDShowWithString:@"加载中"];
    
    [HttpManager sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //检查数据
            if ([self checkData:data class:[NSArray class]]) {
                
                [self.dataResourceArray removeAllObjects];
                
                for (NSDictionary *dic in data) {
                    
                    GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [[GetImageReferImageHistoryListDTO alloc]init];
                    
                    [getImageReferImageHistoryListDTO setDictFrom:dic];
                    
                    [self.dataResourceArray addObject:getImageReferImageHistoryListDTO];
                    
                }
            }
            
            [self.collectionView reloadData];
        
        }else{
            
            [self alertViewWithTitle:@"加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
}

#pragma mark-UICollectionViewDataSource,UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    
    GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [self.dataResourceArray objectAtIndex:section];
    
    NSArray *array = getImageReferImageHistoryListDTO.imageUrlsList;
    
    return array.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView  {
    
    return self.dataResourceArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    return CGSizeMake((self.view.frame.size.width-30-14)*1.0/3,(self.view.frame.size.width-30-14)*1.0/3);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section  {
    
    return UIEdgeInsetsMake(15,15, 0, 15);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    CPSChooseUploadReferImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPSChooseUploadReferImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.selectedImageView.hidden = YES;
    
    GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [self.dataResourceArray objectAtIndex:indexPath.section];

    NSString *url = [getImageReferImageHistoryListDTO.imageUrlsList objectAtIndex:indexPath.row];
    
    [cell.referImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@" "]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        
        CSPCustomCollectionViewFootView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"CSPCustomCollectionViewFootView"   forIndexPath:indexPath];
        
        return view;
        
    }else{
        
        CSPCustomCollectionViewHeadView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"CSPCustomCollectionViewHeadView"   forIndexPath:indexPath];
        
        GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [self.dataResourceArray objectAtIndex:indexPath.section];

        view.imageNumLabel.text = [NSString stringWithFormat:@"已上传图片 %@",[self transformationData:getImageReferImageHistoryListDTO.qty]];
        
        view.uploadSateLabel.text = getImageReferImageHistoryListDTO.auditStatus;
        
        view.uploadDateLabel.text = [NSString stringWithFormat:@"上传时间：%@",getImageReferImageHistoryListDTO.uploadDate];
        
        return view;
    }
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={self.view.frame.size.width,88};
    
    return size;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize size={self.view.frame.size.width,15};
    
    return size;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 7;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)uploadReferImgaeButtonClick:(id)sender {
    
    CPSUploadReferImageViewController *uploadReferImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageViewController"];
    
    uploadReferImageViewController.goodsNo = self.goodsNo;
    
    [self.navigationController pushViewController:uploadReferImageViewController animated:YES];
}
@end
