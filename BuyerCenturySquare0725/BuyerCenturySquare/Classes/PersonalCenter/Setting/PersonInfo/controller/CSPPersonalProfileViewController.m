//
//  CSPPersonalProfileViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPersonalProfileViewController.h"
#import "CSPPersonalProfileHeaderTableViewCell.h"
#import "CSPModifyPersonProfileViewController.h"
#import "MemberInfoDTO.h"
#import "UIImageView+WebCache.h"
#import "OverPlayView.h"
#import "RSKImageCropViewController.h" // !编辑相片

@interface CSPPersonalProfileViewController ()<CSPPersonalProfileHeaderDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
{
    BOOL isneedRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;
- (IBAction)modifyButtonClicked:(id)sender;

@end

@implementation CSPPersonalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    [self addCustombackButtonItem];
    [self setExtraCellLineHidden:self.tableView];
    //线顶头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    isneedRefresh = YES;
    
    [self.modifyButton setBackgroundColor:[UIColor colorWithHexValue:0x1a1a1a alpha:1]];
}

- (void)viewWillAppear:(BOOL)animated {

    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];

    if (isneedRefresh == YES) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
                
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:personalCenterRefresh object:nil];

}
- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPPersonalProfileHeaderTableViewCell *personalHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonalProfileHeaderTableViewCell"];
    CSPBaseTableViewCell *otherCell;

    
    UILabel *title;
    UILabel *integrationLabel;
    if (!personalHeaderCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonalProfileHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonalProfileHeaderTableViewCell"];
        personalHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonalProfileHeaderTableViewCell"];
        personalHeaderCell.delegate = self;
    }
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-18)/2, 135, 18)];//!高原本是14，为了让g之类的字母显示全，改成了18
        
//        title.text = @"座机电话";
        title.textColor = HEX_COLOR(0x999999FF);
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:14];
        [otherCell addSubview:title];
        
        integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, (44-18)/2, self.view.frame.size.width-80, 18)];//!如果这里宽度改了，在cell高度赋值的地方，也要更改计算cell高度的值
        integrationLabel.textColor = HEX_COLOR(0x000000FF);
        integrationLabel.textAlignment = NSTextAlignmentLeft;
        integrationLabel.font = [UIFont systemFontOfSize:14];
        [otherCell addSubview:integrationLabel];
        
    }
    
    if (indexPath.row == 0) {
        if ([[MemberInfoDTO sharedInstance].iconUrl isEqualToString:@""]||[MemberInfoDTO sharedInstance].iconUrl == nil) {
            personalHeaderCell.hederImageView.image = [UIImage imageNamed:@"setting_defaultHeader"];
        }else{
            
            //!这个是同步的
//            personalHeaderCell.hederImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[MemberInfoDTO sharedInstance].iconUrl]]];
            
            //!改成异步的
            NSString *iconUrl =  [MemberInfoDTO sharedInstance].iconUrl;
            
            [personalHeaderCell.hederImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"10_个人中心_默认头像区块"]];
            
        }
        
        personalHeaderCell.nick.text = [MemberInfoDTO sharedInstance].nickName;
        
        return personalHeaderCell;
    }else{
        
        switch (indexPath.row) {
            case 1:
            {
                title.text = @"姓名";
                NSString *sexString;
                
                if ([[MemberInfoDTO sharedInstance].sex isEqualToString:@"1"]) {
                    sexString = @"男";
                }else if([[MemberInfoDTO sharedInstance].sex isEqualToString:@"2"]){
                    sexString = @"女";
                }else{
                    sexString = @"";
                }
                integrationLabel.text = [NSString stringWithFormat:@"%@           %@",[MemberInfoDTO sharedInstance].memberName,sexString];
                if ([MemberInfoDTO sharedInstance].memberName == nil && [MemberInfoDTO sharedInstance].sex == nil ) {
                     integrationLabel.text = @"";
                }
            }
                break;
            case 2:
                title.text = @"手机号";
                integrationLabel.text = [MemberInfoDTO sharedInstance].mobilePhone;
                break;
            case 3:
                title.text = @"座机电话";
                integrationLabel.text = [MemberInfoDTO sharedInstance].telephone;
                break;
            case 4:
                title.text = @"微信";
                integrationLabel.text = [MemberInfoDTO sharedInstance].wechatNo;
                break;
            case 5:
                title.text = @"所在地区";
                
                integrationLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[MemberInfoDTO sharedInstance].provinceName, [MemberInfoDTO sharedInstance].cityName,[MemberInfoDTO sharedInstance].countyName];
                if ([MemberInfoDTO sharedInstance].cityName == nil && [MemberInfoDTO sharedInstance].countyName == nil && [MemberInfoDTO sharedInstance].provinceName == nil) {
                    
                    integrationLabel.text = @"";
                
                }
                break;

            case 6:
                {
                    title.text = @"详细地址";
                    integrationLabel.text = [MemberInfoDTO sharedInstance].detailAddress;
                    
                    CGSize detailSize = [self getDetailSize];
                   
                    if (detailSize.height > 18) {
                        
                        integrationLabel.frame = CGRectMake(80, (44-14)/2, self.view.frame.size.width-100-15, detailSize.height+4);//!增加的4是为了适应字母多出来的部分

                        integrationLabel.numberOfLines = 0;
                    }
                }
                break;
            case 7:
                title.text = @"邮编";
                integrationLabel.text = [MemberInfoDTO sharedInstance].postalCode;
                break;

                
            default:
                break;
        }
        
        
        return otherCell;
    }
    
    

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 142;
    }else if(indexPath.row == 6){//!详细地址
        
        //!计算详细地址的高度，改变cell的高度
        
        CGSize detailSize = [self getDetailSize];
        
        if (detailSize.height > 18 ) {
            
            return 44 - 18 +detailSize.height;
            
        }else{
        
            return 44;
        }
        
    }else{
        
        return 44;
    }

}


-(CGSize )getDetailSize{

    NSString *detailStr = [MemberInfoDTO sharedInstance].detailAddress;
    
    CGSize detailSize = [detailStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width-100-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return detailSize;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }
}

- (IBAction)modifyButtonClicked:(id)sender {
    
    CSPModifyPersonProfileViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPModifyPersonProfileViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];

}

#pragma mark--
#pragma CSPPersonalProfileHeaderDelegate

- (void)changeHeader
{

    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我的相册", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark--
#pragma UIActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:

                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:

                    return;
                    break;
            }
            
        }
        
        else {
        
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
           
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        
        isneedRefresh = NO;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.navigationBar.translucent = NO;
               
        imagePickerController.sourceType = sourceType;

        [self presentViewController:imagePickerController animated:YES completion:^{}];
        

    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    
    imageCropVC.delegate = self;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - RSKImageCropViewControllerDelegate


- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    
//    [self.addPhotoButton setImage:croppedImage forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //保存图片到本地
//    UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
      
    UIImage *uploadImage = [self scaleFromImage:croppedImage toSize:CGSizeMake(400, 400)];
    
    NSString *appType = @"2";
    
    NSString *type = @"4";
    
    NSData* file = UIImageJPEGRepresentation(uploadImage, 0.1);
    
    // !上传图片
    [self progressHUDShowWithString:@"上传中"];
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:appType type:type orderCode:@"" goodsNo:@"" file:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [MemberInfoDTO sharedInstance].iconUrl = dic[@"data"];
            
            // !上传商家资料
            [HttpManager sendHttpRequestForUpdateMemberDataWithUserInfoDTO:[MemberInfoDTO sharedInstance] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    
                    [self.tableView reloadData];
                    
                    [self progressHUDHiddenWidthString:@"上传成功"];

                    
                }else{
                    
                    [self progressHUDHiddenWidthString:dic[@"errorMessage"]];

                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self progressHUDHiddenWidthString:@"上传失败"];
            
            }];
            
            
        }else{
            
            [self progressHUDHiddenWidthString:dic[@"errorMessage"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        [self progressHUDHiddenWidthString:@"上传失败"];

        
    }];
    

    
}




/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    
 
    //保存图片到本地
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(400, 400)];
    
    NSString *appType = @"2";
    NSString *type = @"4";
    
    NSData* file = UIImageJPEGRepresentation(uploadImage, 0.1);
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:appType type:type orderCode:@"" goodsNo:@"" file:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [MemberInfoDTO sharedInstance].iconUrl = dic[@"data"];
            
            
            [HttpManager sendHttpRequestForUpdateMemberDataWithUserInfoDTO:[MemberInfoDTO sharedInstance] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"dic = %@",dic);
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    
                    [self.tableView reloadData];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            }];
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]);
            NSLog(@"Response = %@", operation);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        NSLog(@"Response = %@", operation);
    }];
    
}
*/




//设置导航栏颜色
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    viewController.navigationController.navigationBar.translucent = YES;

    viewController.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [viewController.view addSubview:statusBarView];
    
}




- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
