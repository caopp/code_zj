//
//  CSPApplyDataTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplyDataTableViewController.h"
#import "CSPApplyDataPictureTableViewCell.h"
#import "UserApplyInfo.h"
#import "UIImageView+WebCache.h"
#import "CSPApplyEditeViewController.h"
#import "EnlargeImageView.h"
@interface CSPApplyDataTableViewController ()
{
    UserApplyInfo *UserDTO_;
    UIButton *buttonEdite;
}
@property (nonatomic,strong)EnlargeImageView *enlargeImage;
@property (nonatomic,strong) UserApplyInfo *UserDTO;

@end

@implementation CSPApplyDataTableViewController
@synthesize UserDTO = UserDTO_;

-(void)viewWillDisappear:(BOOL)animated{
    buttonEdite.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"applyData", @"申请资料");
    _enlargeImage = [[EnlargeImageView alloc] init];
    
    buttonEdite = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 12, 40, 20)];
    [self.navigationController.navigationBar addSubview:buttonEdite];
    [buttonEdite setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    buttonEdite.titleLabel.font = [UIFont systemFontOfSize:12];
    [buttonEdite setTitle:@"修改" forState:UIControlStateNormal];
    [buttonEdite addTarget:self action:@selector(editeInformition:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonEdite.hidden = YES;
    
    [self addCustombackButtonItem];
    [HttpManager sendHttpRequestForGetApplyInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.UserDTO = [[UserApplyInfo alloc]init];
            [self.UserDTO setDictFrom:[dic objectForKey:@"data"]];
            buttonEdite.hidden = (self.UserDTO.applyStatus.intValue ==0)?YES:NO;
            [self.tableView reloadData];
        }else{
            [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
     buttonEdite.hidden = (self.UserDTO.applyStatus.intValue ==0)?YES:NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPApplyDataPictureTableViewCell *applyPictureCell = [tableView dequeueReusableCellWithIdentifier:@"CSPApplyDataPictureTableViewCell"];

    if (!applyPictureCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPApplyDataPictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPApplyDataPictureTableViewCell"];
        applyPictureCell = [tableView dequeueReusableCellWithIdentifier:@"CSPApplyDataPictureTableViewCell"];
    }
    CSPBaseTableViewCell *otherCell;
    
    UILabel *title;
    UILabel *integrationLabel;
    
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        
    }
    title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-14)/2, 150, 14)];
    title.textColor = HEX_COLOR(0x989898FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    [otherCell addSubview:title];
    
    integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (44-14)/2, self.view.frame.size.width-100-15, 14)];
    integrationLabel.textColor = HEX_COLOR(0x666666FF);
    integrationLabel.textAlignment = NSTextAlignmentLeft;
    integrationLabel.font = [UIFont systemFontOfSize:14];
    integrationLabel.numberOfLines = 0;

     [otherCell addSubview:integrationLabel];
    
    
    switch (indexPath.row) {
        case 0:{
            title.text = @"内推邀请码";
            integrationLabel.text = [self.UserDTO.keyCode length]?self.UserDTO.keyCode:@"";
            return otherCell;
        
        }
            break;
        case 1:
        {
            title.text = NSLocalizedString(@"applyName", @"姓名");
            NSString *sexString;
            if ([self.UserDTO.sex isEqualToString:@"2"]) {
                
                sexString = NSLocalizedString(@"woman",@"女");
                
            }else if([self.UserDTO.sex isEqualToString:@"1"])
            {
                sexString = NSLocalizedString(@"man", @"男") ;
                
            }else{
                sexString = @"";
            }
            integrationLabel.text = [NSString stringWithFormat:@"%@        %@",self.UserDTO.memberName,sexString];
            
            if (self.UserDTO.memberName == nil) {
                integrationLabel.text = @"";
            }

            return otherCell;
        }
            break;
        case 2:
            title.text = NSLocalizedString(@"phoneNumber", @"手机号") ;
            integrationLabel.text = self.UserDTO.mobilePhone;
            return otherCell;
            break;
        case 3:
            title.text = NSLocalizedString(@"location", @"所在地区") ;
            integrationLabel.text =  [NSString stringWithFormat:@"%@ %@ %@",self.UserDTO.provinceName,self.UserDTO.cityName,self.UserDTO.countyName];
            if (self.UserDTO.provinceName == nil && self.UserDTO.cityName == nil && self.UserDTO.countyName == nil)  {
                integrationLabel.text = @"";
            }
            return otherCell;
            break;
//        case 3:
//            title.text = @"街道";
//            integrationLabel.text = self.UserDTO.countyName;
//            return otherCell;
//            break;
        case 4:
        {
            title.text =  NSLocalizedString(@"detailAdress", @"详细地址") ;
            NSString *strInfo = self.UserDTO.detailAddress;
            if (strInfo) {
                integrationLabel.frame = CGRectMake(100, (44-14)/2, self.view.frame.size.width-100-15, [self returnCellHight:strInfo]+14);
                title.frame = CGRectMake(15, (44-14)/2, 150, integrationLabel.frame.size.height);

                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strInfo];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setFirstLineHeadIndent:0];
                [paragraphStyle setLineSpacing:5];//调整行间距
                
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strInfo length])];
                integrationLabel.attributedText = attributedString;
            }
            
            return otherCell;
            
        }
            break;
        case 5:
            title.text = NSLocalizedString(@"homePhone",  @"座机电话");
            
            integrationLabel.text = self.UserDTO.telephone;
            return otherCell;
            break;
        case 6:
        {
            title.text = NSLocalizedString(@"IDCard", @"身份证");
            if ([self.UserDTO.identityNo length]>15) {
                NSString *strNo = [self.UserDTO.identityNo stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"*************"];
                integrationLabel.text = strNo;
            }
          
        }
            return otherCell;
            break;
        case 7:
            title.text = NSLocalizedString(@"businessLicense", @"营业执照") ;
            integrationLabel.text = self.UserDTO.businessLicenseNo;
            return otherCell;
            break;
        case 8:{
            title.text = NSLocalizedString(@"shoptype", @"销售类型");
            NSString *shopType = [self.UserDTO.shopType isEqualToString:@"1"]?@"网络分销":@"实体店";
            if ([self.UserDTO.shopType isEqualToString:@"1"]) {
                shopType = @"网络分销";
            }else if ([self.UserDTO.shopType isEqualToString:@"0"]){
                shopType = @"实体店";
            }
            if ([self.UserDTO.otherPlatform length]) {
                shopType = [shopType stringByAppendingString:[NSString stringWithFormat:@"|%@",self.UserDTO.otherPlatform]];
            }
            if ([self.UserDTO.shopName length]) {
                shopType = [shopType stringByAppendingString:[NSString stringWithFormat:@"|%@",self.UserDTO.shopName]];
            }
            integrationLabel.text =shopType;
        }
            return otherCell;
            break;
        case 9:
        {
            
            title.text = NSLocalizedString(@"bussinessState", @"营业状况");
            NSString *strInfo = self.UserDTO.businessDesc;
            if (strInfo) {
                integrationLabel.frame = CGRectMake(100, (44-14)/2, self.view.frame.size.width-100-15, [self returnCellHight:self.UserDTO.businessDesc]);
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strInfo];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                
                [paragraphStyle setLineSpacing:5];//调整行间距
                
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strInfo length])];
                integrationLabel.attributedText = attributedString;
            }
            
            
        }
            return otherCell;
            break;
        case 11:
            title.text = NSLocalizedString(@"applyState", @"申请状态");
           // integrationLabel.textColor = HEX_COLOR(0x010101FF);
            
            switch (self.UserDTO.applyStatus.intValue) {
                case 0:
                   
                        title.hidden = NO;
                        integrationLabel.hidden = NO;
                    
                   
                    integrationLabel.text = NSLocalizedString(@"waitPass", @"待审核");
                    break;
                case 1:
                    title.hidden = YES;
                    integrationLabel.hidden = YES;
                    integrationLabel.text = NSLocalizedString(@"hasPass", @"审核通过");
                    break;
                case 2:
                    title.hidden = YES;
                    integrationLabel.hidden = YES;
                    integrationLabel.text = NSLocalizedString(@"hasNotPass", @"审核未通过") ;
                    break;
                    
                    
                default:
                    break;
            }
            
            
            return otherCell;
            break;

        case 10:
            if ([self.UserDTO.identityPicUrl length]) {
                  [applyPictureCell.identityImageView sd_setImageWithURL:[NSURL URLWithString:self.UserDTO.identityPicUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
                applyPictureCell.identityImageView.hidden = NO;
                applyPictureCell.identityLabel.hidden = NO;
                applyPictureCell.identityImageView.tag = 1000;
                applyPictureCell.identityImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer  *IdCardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addIdCardImageGesture:)];
                [applyPictureCell.identityImageView addGestureRecognizer:IdCardGesture];
            }else{
                applyPictureCell.identityImageView.hidden = YES;
                applyPictureCell.identityLabel.hidden = YES;
            }
          
            if ([self.UserDTO.businessLicenseUrl length]) {
                [applyPictureCell.businessLicenseImageView sd_setImageWithURL:[NSURL URLWithString:self.UserDTO.businessLicenseUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
                applyPictureCell.businessLicenseImageView.tag = 2000;
                applyPictureCell.businessLicenseImageView.hidden = NO;
                applyPictureCell.bussinessLicenseLabel.hidden = NO;
                applyPictureCell.businessLicenseImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer  *businessGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBusinessLicenseImageGesture:)];
                [applyPictureCell.businessLicenseImageView addGestureRecognizer:businessGesture];
                
            }else{
                applyPictureCell.businessLicenseImageView.hidden = YES;
                applyPictureCell.bussinessLicenseLabel.hidden = YES;
            }
            return applyPictureCell;
            break;
            
            
        default:
            return otherCell;
            break;
            
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 44;
    }else if(indexPath.row == 4){
        
        
        NSString *strInfo =  self.UserDTO.detailAddress;
        
        if (!strInfo) {
            return 44;
        }else{
            return [self returnCellHight:self.UserDTO.detailAddress]+14+14;
        }
        
    }else if(indexPath.row == 9){
       
       
        NSString *strInfo =  self.UserDTO.businessDesc;
        
        if (!strInfo) {
            return 44;
        }else{
            return [self returnCellHight:self.UserDTO.businessDesc]+14+14;
        }
       
    }else if(indexPath.row == 11){
       if (!self.UserDTO.applyStatus.intValue) {
           return 44;
       }else{
           return 0;
       }
    }else if (indexPath.row == 10) {
        if ([self.UserDTO.identityPicUrl length]||[self.UserDTO.businessLicenseUrl length]) {
            return 82;
        }else{
            return 0;
        }
        
    }else{
        return 44;
    }
}
-(void)editeInformition:(UIButton *)btn{
    CSPApplyEditeViewController *applyEdite =[[CSPApplyEditeViewController alloc] init];
    applyEdite.applyDefault = self.UserDTO;
    [self.navigationController  pushViewController:applyEdite animated:YES];
    
}
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    buttonEdite.hidden = YES;
    for (int i =0; i< self.navigationController.viewControllers.count; i++) {
        NSInteger count =self.navigationController.viewControllers.count -2-i;
        UIViewController *controller = self.navigationController.viewControllers[count];
        if (![controller isKindOfClass:[CSPApplyEditeViewController class]]&&![controller isKindOfClass:[self class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if (![controller isKindOfClass:[CSPApplyEditeViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//            break;
//        }
//    }
}
-(float)returnCellHight:(NSString *)strInfo{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strInfo];
    //调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strInfo length])];
    CGRect size = [strInfo boundingRectWithSize:CGSizeMake(self.view.frame.size.width-100-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    
    
    return size.size.height;
}
-(void)addIdCardImageGesture:(UITapGestureRecognizer *)tap{

    if (tap.view.tag == 1000) {
        [_enlargeImage showImage:(UIImageView *)tap.view tag:tap.view.tag];
        _enlargeImage.button.hidden  = YES;
    }
    
}
-(void)addBusinessLicenseImageGesture:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 2000) {
        [_enlargeImage showImage:(UIImageView *)tap.view tag:tap.view.tag];
        _enlargeImage.button.hidden  = YES;
    }
    
}

@end
