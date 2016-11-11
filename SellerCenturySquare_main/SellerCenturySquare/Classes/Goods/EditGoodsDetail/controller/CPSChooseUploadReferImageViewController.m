//
//  CPSChooseUploadReferImageViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSChooseUploadReferImageViewController.h"
#import "CPSUploadReferImageSucessfulViewController.h"
#import "CPSChooseUploadReferImageCollectionViewCell.h"
#import "CPSChooseUploadReferImageBottomView.h"
#import "UIImage+Compression.h"
#import "CPSUploadReferImageSucessfulViewController.h"
#import "GUAAlertView.h"

@interface CPSChooseUploadReferImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    
    GUAAlertView *customerAlertView;
    BOOL isUp;//!是否正在上传。正在上传的时候不允许返回
    BOOL upSuccess;//!是否上传成功，上传成功就进入下一个页面，不成功则不跳转

}
@property (weak, nonatomic) IBOutlet UILabel *chooseImageNumLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic)CPSChooseUploadReferImageBottomView *chooseUploadReferImageBottomView;

@end

@implementation CPSChooseUploadReferImageViewController{
    NSMutableArray *_seletedArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"上传参考图";
    
    [self customBackBarButton];
    
    _seletedArray = [[NSMutableArray alloc]init];
    
    [_seletedArray addObjectsFromArray:self.referImageArray];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CPSChooseUploadReferImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CPSChooseUploadReferImageCollectionViewCell"];
    
    [self initChooseUploadReferImageBottomView];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
    //!改变 “已选图片”数量提示、全选按钮的状态
    [self changeSelectNumAndAllBtnStatues];
    
    
}
//!返回按钮
- (void)backBarButtonClick:(UIBarButtonItem *)sender{

    //!如果正在上传，就不能点击返回按钮
    if (isUp) {
        
        return;
    }
    
    
    
    if (customerAlertView) {
        
        [customerAlertView removeFromSuperview];
        
    }
    
    customerAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否放弃上传，重新选择图片" withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } dismissAction:^{
       
        
    }];
    
    [customerAlertView show];
    
    
}
- (void)initChooseUploadReferImageBottomView{
    
    self.chooseUploadReferImageBottomView = [[[NSBundle mainBundle]loadNibNamed:@"CPSChooseUploadReferImageBottomView" owner:self options:nil]lastObject];
    
    __weak CPSChooseUploadReferImageViewController *weakSelf = self;
    
    self.chooseUploadReferImageBottomView.uploadBlock = ^(){
        
        [weakSelf uploadImage];
    
    };
    
    
    self.chooseUploadReferImageBottomView.deleteBlock = ^(){
        
        [weakSelf deleteReferImage];
    
    };
    //!选中全部
    self.chooseUploadReferImageBottomView.selectAllBlock = ^(BOOL selectStatus){
    
        [weakSelf selectAllNum:selectStatus];
        
    
    };
    
    
    
    self.chooseUploadReferImageBottomView.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    
    [self.view addSubview:self.chooseUploadReferImageBottomView];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"CPSChooseUploadReferImageViewControllerSegueID"]) {
        
        CPSChooseUploadReferImageViewController *chooseUploadReferImageViewController = [segue destinationViewController];
        
        chooseUploadReferImageViewController.goodsNo = self.goodsNo;
    }
    
    
}

- (void)uploadImage{
    
    [self progressHUDShowWithString:@"上传中"];
    
    [self uploadReferImage];
}

#pragma mark-确定上传
- (void)uploadReferImage{
  
    //!标志正在上传，等上传完毕，或者失败再标志为没有上传
    isUp = YES;

    //!轮流取每张
    UIImage *image = [_seletedArray objectAtIndex:0];
    
    image = [UIImage reduceImage:image percent:0.01];
    
    NSData *imageData = [self getDataWithImage:image];
    
    //上传参考图时不需要orderCode
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"3" orderCode:nil goodsNo:self.goodsNo file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            //删除第一条
            [_seletedArray removeObjectAtIndex:0];
            
            if (_seletedArray.count) {
                
                [self uploadReferImage];
                
            }else{
                
                //!标志为没有在上传
                isUp = NO;
                
                [self.collectionView reloadData];
                
                //!标志上传成功
                upSuccess = YES;
                
                //上传成功
                [self progressHUDHiddenTipSuccessWithString:@"上传成功"];
            }
            
            
        }else{
            
            //!标志为没有在上传
            isUp = NO;
            
            //!标志上传失败
            upSuccess = NO;
            
            [self alertViewWithTitle:@"上传失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
            [self.progressHUD hide:YES];
            
            [self.collectionView reloadData];
            
            [self changeSelectNumAndAllBtnStatues];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //!标志上传失败
        upSuccess = NO;
        
        [self tipRequestFailureWithErrorCode:error.code];
        
        [self.collectionView reloadData];
        
        [self changeSelectNumAndAllBtnStatues];

        //!标志为没有在上传
        isUp = NO;
        
    }];

}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    //!如果上传成功，则跳转到下一个页面，否则不做任何操作
    if (upSuccess) {
        
        //上传成功
        CPSUploadReferImageSucessfulViewController *uploadReferImageSucessfulViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageSucessfulViewController"];
        
        uploadReferImageSucessfulViewController.goodsNo = self.goodsNo;
        
        [self.navigationController pushViewController:uploadReferImageSucessfulViewController animated:YES];
        

    }
   

}


#pragma mark-删除
- (void)deleteReferImage{
    
    if (_seletedArray.count == 0) {
    
        [self.view makeMessage:@"请选择要删除的照片" duration:2.0 position:@"center"];
        
        return;
    }
    
    for (UIImage *image in _seletedArray) {
        
        [self.referImageArray removeObject:image];
    }
    
    [_seletedArray removeAllObjects];
    
    
    if (self.referImageArray.count == 0) {
        
        self.chooseUploadReferImageBottomView.uploadButton.backgroundColor = [UIColor lightGrayColor];

        self.chooseUploadReferImageBottomView.uploadButton.enabled = NO;
        
        
    }else{
        
        self.chooseUploadReferImageBottomView.uploadButton.backgroundColor = [UIColor blackColor];
        
        self.chooseUploadReferImageBottomView.uploadButton.enabled = YES;
    }
    
    [self.collectionView reloadData];
    
    //!改变 “已选图片”数量提示、全选按钮的状态
    [self changeSelectNumAndAllBtnStatues];
    
}

#pragma mark 全选
-(void)selectAllNum:(BOOL )selectStatues{

    [_seletedArray removeAllObjects];

    
    //!全选
    if (selectStatues) {
        
        [_seletedArray addObjectsFromArray:self.referImageArray];
        
        
    }
  
    [self.collectionView reloadData];
    
    //!修改状态
    [self changeSelectNumAndAllBtnStatues];
    

}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.chooseUploadReferImageBottomView.frame =  CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    
    DebugLog(@"------>%f", self.view.frame.size.height-49);
}

#pragma mark-UICollectionViewDataSource,UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return self.referImageArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView  {
    return 1;
    
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
    
    UIImage *image = [self.referImageArray objectAtIndex:indexPath.row];
    
    cell.referImageView.image = image;
    
    if ([_seletedArray containsObject:image]) {
        
        cell.selectedImageView.hidden = NO;
        
    }else{
        cell.selectedImageView.hidden = YES;
    }
    
    return cell;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    UIImage *image = [self.referImageArray objectAtIndex:indexPath.row];
    
    if ([_seletedArray containsObject:image]) {
        [_seletedArray removeObject:image];
    }else{
        [_seletedArray addObject:image];
    }
    

    
    [collectionView reloadData];
    
    //!改变 “已选图片”数量提示、全选按钮的状态
    [self changeSelectNumAndAllBtnStatues];

    
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    return YES;
}

#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
}

//!改变 “已选图片”数量提示、全选按钮的状态
-(void)changeSelectNumAndAllBtnStatues{
    
    //!修改 文字"已选图片"
    self.chooseImageNumLabel.text = [NSString stringWithFormat:@"已选图片 %lu",(unsigned long)_seletedArray.count];
    
    //!如果全部选中了  全选按钮为选中
    if (_seletedArray.count == self.referImageArray.count) {
        
        
        self.chooseUploadReferImageBottomView.selectAllBtn.selected = YES;
        
        
    }else{
        
        self.chooseUploadReferImageBottomView.selectAllBtn.selected = NO;
        
        
    }
    
    //!改变上传按钮的状态
    if (_seletedArray.count == 0) {
        
        
        self.chooseUploadReferImageBottomView.uploadButton.backgroundColor = [UIColor lightGrayColor];
        
        self.chooseUploadReferImageBottomView.uploadButton.enabled = NO;
        
        
    }else{
    
        self.chooseUploadReferImageBottomView.uploadButton.backgroundColor = [UIColor blackColor];
        
        self.chooseUploadReferImageBottomView.uploadButton.enabled = YES;
        
        
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
