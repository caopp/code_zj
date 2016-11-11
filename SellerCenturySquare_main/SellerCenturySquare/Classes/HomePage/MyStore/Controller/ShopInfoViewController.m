//
//  ShopInfoViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
/*
 注意！！！！！！！！！！
 如果用户资料有头像，那么我就要把 头像的值给headerImage
 在tableView头部赋值的时候，没有这个值就给默认头像
 
 点击修改头像，成功后，把headerImage == 修改后的头像，刷新tableView，并且把本地保存的GetMerchantInfoDTO信息进行修改
 （现在缺 请求数据 ，把本地GetMerchantInfoDTO修改）
 */

#import "ShopInfoViewController.h"
#import "ShopInfoIntroduceTableViewCell.h"
#import "ShopInfoNormalTableViewCell.h"

#import "GetMerchantInfoDTO.h"
#import "RDVTabBarController.h"
#import "RSKImageCropViewController.h"
#import "UIButton+WebCache.h"
#import "GUAAlertView.h"

@interface ShopInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
{
    NSMutableArray *arrNames;
}
// !商家信息
@property (nonatomic,strong) GetMerchantInfoDTO *getMerchantInfoDTO;

// !修改商家信息的时候上传的数据
@property (nonatomic,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;


@end

@implementation ShopInfoViewController
{

    UIButton *headerBtn;// !头像btn
    UIImage *headerImage;//!用户头像
    GUAAlertView *alertView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customBackBarButton];

    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    //数组
    
    arrNames = [NSMutableArray arrayWithObjects:@"店铺负责人",@"手机号",@"座机电话",@"身份证",@"所在地区",@"详细地址",@"合同编号",@"",nil];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    
    // !现在修改为直接 不能修改资料
//    if (!_getMerchantInfoDTO.isMaster) {// !子账号
    
        [_modItem setTitle:@""];
        _modItem.enabled = NO;
        
//    }
    

    
    [self.tableView reloadData];
    
    // !组合要上传的数据 必须在这里组合，不然到时候点击修改头像需要判断其余信息是否全，不全不能上传
    [self combinData];

    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getIdentifyNo:(NSString*)identifyNo{
    
    NSString *idNo =[[NSString alloc]init];
    
    if (identifyNo.length>=15) {
        
        if (identifyNo.length==15) {
            
            idNo =[NSString stringWithFormat:@"%@xxxxxxxxxxx%@",[identifyNo substringToIndex:3],[identifyNo substringFromIndex:identifyNo.length-4]];
        }else{
            
            idNo =[NSString stringWithFormat:@"%@xxxxxxxxxxxxxx%@",[identifyNo substringToIndex:3],[identifyNo substringFromIndex:identifyNo.length-4]];
        }
    }
    
     return idNo;
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ShopInfoIntroduceTableViewCell *shopInfoIntroduceCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoIntroduceTableViewCell"];
    
    ShopInfoNormalTableViewCell *shopInfoNormalCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoNormalTableViewCell"];
    
    if (!shopInfoIntroduceCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ShopInfoIntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopInfoIntroduceTableViewCell"];
        shopInfoIntroduceCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoIntroduceTableViewCell"];
    }
    
    
    if (!shopInfoNormalCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ShopInfoNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopInfoNormalTableViewCell"];
        shopInfoNormalCell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoNormalTableViewCell"];
    }
    shopInfoNormalCell.titleL.text = arrNames[indexPath.row];
    
    switch (indexPath.row) {
        case 0:{
            
            NSString *name  = _getMerchantInfoDTO.shopkeeper;
            NSString *sex = [_getMerchantInfoDTO.sex integerValue]==1?@"男":@"女";
            NSString *detailStr = [NSString stringWithFormat:@"%@      %@",name,sex];
            [shopInfoNormalCell getDetailInfoStr:detailStr num:nil];
        }
            break;
        case 1:
        {
            
            [shopInfoNormalCell getDetailInfoStr:[self replaceNilWithString:_getMerchantInfoDTO.mobilePhone] num:nil];

        }
            break;
        case 2:
        {
             [shopInfoNormalCell getDetailInfoStr:[self replaceNilWithString:_getMerchantInfoDTO.telephone] num:nil];
        }
            break;
        case 3:
        {
             [shopInfoNormalCell getDetailInfoStr:[self getIdentifyNo:_getMerchantInfoDTO.identityNo] num:nil];
        }
            break;
        case 4:
        {
              NSString *add = [NSString stringWithFormat:@"%@%@%@",_getMerchantInfoDTO.provinceName,_getMerchantInfoDTO.cityName,_getMerchantInfoDTO.countyName];
            
             [shopInfoNormalCell getDetailInfoStr:[self replaceNilWithString:add] num:nil];
        }
            break;
        case 5:
            
        {
            [shopInfoNormalCell getDetailInfoStr:[self replaceNilWithString:_getMerchantInfoDTO.detailAddress] num:nil];

        }
        break;
        case 6:
        {
            [shopInfoNormalCell getDetailInfoStr:[self replaceNilWithString:_getMerchantInfoDTO.contractNo] num:nil];
        }
            break;
        
        case 7:
            shopInfoIntroduceCell.introduceTV.text = [self replaceNilWithString:_getMerchantInfoDTO.Description];
            return shopInfoIntroduceCell;
            break;
         
        
            
        default:
            return nil;
            break;
    }
    
    return shopInfoNormalCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 105;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 105)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // !如果请求回来了头像，就放头像，不然就放默认的
    if ([_getMerchantInfoDTO.iconUrl isEqualToString:@""] || _getMerchantInfoDTO.iconUrl == nil) {
        
        [headerBtn setBackgroundImage:[UIImage imageNamed:@"shopInfoHeader"] forState:UIControlStateNormal];

    }else{
    /*
//        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_getMerchantInfoDTO.iconUrl]];
//        UIImage *bgImage = [UIImage imageWithData:imageData];
//     
//        [headerBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        */
        
        [headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_getMerchantInfoDTO.iconUrl] forState:UIControlStateNormal];


    }
    
    
    headerBtn.frame = CGRectMake(0, 0, 85, 85);
    headerBtn.center = headerView.center;
    headerBtn.layer.cornerRadius = headerBtn.frame.size.width/2.0;
    headerBtn.layer.masksToBounds = YES;
    [headerBtn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerBtn];
    
    return headerView;
    

}
// !头像点击事件
-(void)headerBtnClick{
    
    
    UIAlertController *newSheetCorntroller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoOrgetAlbum:NO];
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoOrgetAlbum:YES];

    }];

    
    [newSheetCorntroller addAction:cancelAction];
    [newSheetCorntroller addAction:cameraAction];
    [newSheetCorntroller addAction:photoAction];
    
    [self presentViewController:newSheetCorntroller animated:YES completion:nil];
    
    

}
// !拍照或从手机相册选择  isAlbum:是否是从相册选择
-(void)takePhotoOrgetAlbum:(BOOL)isAlbum{

    NSUInteger sourceType = 0;
    
    // !如果是从相机选择 判断相机是否可用
    if (!isAlbum) {
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {// !支持
            
            sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
        
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        }
        
    }else{// !相册
    
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    imagePickerController.delegate = self;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];

}
#pragma mark - image picker delegte
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    [picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //保存图片到本地
//    UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
    
    UIImage *uploadImage = [self scaleFromImage:croppedImage toSize:CGSizeMake(400, 400)];
    
    NSData* fileData = UIImageJPEGRepresentation(uploadImage, 0.1);
    
    // !上传图片---》获得图片地址后上传商家信息
    
    [self progressHUDShowWithString:@"上传信息中"];
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"8" orderCode:nil goodsNo:nil file:fileData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
//            _getMerchantInfoDTO.iconUrl = dic[@"data"];
//            _updateMerchantInfoModel.iconUrl = _getMerchantInfoDTO.iconUrl; // !添加头像

            [self upLoadMerchantInfo:dic[@"data"]];
    
        }else{
            
            [self progressHUDHiddenWidthString:[NSString stringWithFormat:@"%@",dic[@"errorMessage"]]];

        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self progressHUDHiddenWidthString:@"上传头像失败"];
    }];
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 上传图片信息
// !上传商家信息
-(void)upLoadMerchantInfo:(NSString *)iconUrl{
    
    
    [HttpManager sendHttpRequestForUpdateIconUrl:iconUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [self progressHUDHiddenWidthString:@"上传成功"];
            
            _getMerchantInfoDTO.iconUrl = iconUrl;

            [self.tableView reloadData];
            
        }else{
            
            [self progressHUDHiddenWidthString:[NSString stringWithFormat:@"%@",dic[@"errorMessage"]]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self progressHUDHiddenWidthString:@"上传信息失败"];
    }];
}
// !组合要上传的数据
-(void)combinData{
    
    _updateMerchantInfoModel = [[UpdateMerchantInfoModel alloc]init];
    _updateMerchantInfoModel.shopkeeper = _getMerchantInfoDTO.shopkeeper;
    _updateMerchantInfoModel.sex = _getMerchantInfoDTO.sex;
    _updateMerchantInfoModel.mobilePhone = _getMerchantInfoDTO.mobilePhone;
    _updateMerchantInfoModel.telephone = _getMerchantInfoDTO.telephone;
    _updateMerchantInfoModel.identityNo = _getMerchantInfoDTO.identityNo;
    _updateMerchantInfoModel.detailAddress = _getMerchantInfoDTO.detailAddress;
    _updateMerchantInfoModel.contractNo = _getMerchantInfoDTO.contractNo;
    _updateMerchantInfoModel.provinceNo = _getMerchantInfoDTO.provinceNo;
    _updateMerchantInfoModel.cityNo = _getMerchantInfoDTO.cityNo;
    _updateMerchantInfoModel.countyNo = _getMerchantInfoDTO.countyNo;
    _updateMerchantInfoModel.Description = _getMerchantInfoDTO.Description;
    
    _updateMerchantInfoModel.iconUrl = _getMerchantInfoDTO.iconUrl; // !添加头像
    
}

//设置导航栏颜色
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    viewController.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [viewController.view addSubview:statusBarView];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self navigationBarSettingShow:YES];
}


@end
