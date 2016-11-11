//
//  CSPApplicationInfoViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplicationInfoViewController.h"
#import "CSPApplyTableViewCell.h"
#import "CSPApplyLicenceTableViewCell.h"
#import "UserApplyInfo.h"
#import "CSPUtils.h"
#import "CustomBarButtonItem.h"

#import "CSPWaitCertifyViewController.h"

#import "LoginDTO.h"
@interface CSPApplicationInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UserApplyInfo* userApplyInfo;

@end

typedef NS_ENUM(NSInteger, ApplicationInfoIndex) {
    ApplicationInfoIndexCode,
    ApplicationInfoIndexName,
    ApplicationInfoIndexPhone,
    ApplicationInfoIndexAddress,
    ApplicationInfoIndexDetailAddress,
    ApplicationInfoIndexFixedLine,
    ApplicationInfoIndexIdCard,
    ApplicationInfoIndexStoreType,
    ApplicationInfoIndexBusinessLicense,
    ApplicationInfoIndexLicenseImage,
    ApplicationInfoIndexBusinessState,
    ApplicationInfoIndexApplicationState,
};

@implementation CSPApplicationInfoViewController

static NSString* applyTextCellIdentifier = @"applyTextCell";
static NSString* applyImageCellIdentifier = @"applyImageCell";

-(void)viewDidAppear:(BOOL)animated
{

    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"登录注册背景@2x_顶栏背景(1)"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view.
    self.title =  NSLocalizedString(@"applicationMaterials",@"申请资料");
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    
    self.tableView.scrollEnabled = YES;
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonItemClicked:) target:self]];

    
    [HttpManager sendHttpRequestForGetApplyInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.userApplyInfo = [[UserApplyInfo alloc]initWithDictionary:dic[@"data"]];
            
            [self.tableView reloadData];
            
        } else {
            
            [self.view makeMessage:@"查询申请资料出错,检查服务器" duration:2.0f position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:NSLocalizedString(@"connectError",  @"网络连接异常" ) duration:2.0f position:@"center"];

    }];

    [self addCustombackButtonItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LoginDTO *loginDTO = [LoginDTO sharedInstance];
    if ([loginDTO.joinType isEqualToString:@"2"]) {
        return 11;
    }else{
        return 12;
    }
   
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    CSPApplyTableViewCell* applyTextCell = nil;
    CSPApplyLicenceTableViewCell* applyImageCell = nil;
    LoginDTO *loginDTO = [LoginDTO sharedInstance];
    NSInteger tag = [loginDTO.joinType isEqualToString:@"2"]?indexPath.row+1:indexPath.row ;
    switch (tag) {
        case ApplicationInfoIndexCode:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                [applyTextCell setTitle:@"内推邀请码" content:self.userApplyInfo.keyCode];
            } else {
                [applyTextCell setTitle:@"内推邀请码" content:@""];
            }
            break;
        case ApplicationInfoIndexName:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                NSString* name = [NSString stringWithFormat:@"%@    %@", self.userApplyInfo.memberName, [CSPUtils translateSex:self.userApplyInfo.sex]];
                [applyTextCell setTitle:@"姓名" content:name];
            } else {
                [applyTextCell setTitle:@"姓名" content:@""];
            }
            break;
        case ApplicationInfoIndexPhone:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                [applyTextCell setTitle:@"手机号" content:self.userApplyInfo.mobilePhone];
            } else {
                [applyTextCell setTitle:@"手机号" content:@""];
            }
            break;
        case ApplicationInfoIndexAddress:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                
                NSString* address = [NSString stringWithFormat:@"%@%@%@", self.userApplyInfo.provinceName, self.userApplyInfo.cityName, self.userApplyInfo.countyName];
                [applyTextCell setTitle:@"省市区" content:address];
            } else {
                [applyTextCell setTitle:@"省市区" content:@""];
            }
            break;
        case ApplicationInfoIndexDetailAddress:
            
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            
            if (self.userApplyInfo) {
                [applyTextCell setTitle:@"详细地址" content:self.userApplyInfo.detailAddress];
                
                CGSize  detailAddressHeight = [self.userApplyInfo.detailAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
                
                applyTextCell.contentHight.constant = detailAddressHeight.height+10;
                
            } else {
                [applyTextCell setTitle:@"详细地址" content:@""];
            }
            break;
        case ApplicationInfoIndexFixedLine:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                [applyTextCell setTitle:@"座机电话" content:self.userApplyInfo.telephone];
            } else {
                [applyTextCell setTitle:@"座机电话" content:@""];
            }
            break;
        case ApplicationInfoIndexIdCard:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            
            if (self.userApplyInfo) {
                [applyTextCell setTitle:@"身份证" content:self.userApplyInfo.identityNo];
            } else {
                [applyTextCell setTitle:@"身份证" content:@""];
            }
            break;
        case ApplicationInfoIndexBusinessLicense:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            
            
            if (self.userApplyInfo) {
                
                [applyTextCell setTitle:@"营业执照" content:self.userApplyInfo.businessLicenseNo];
            } else {
                [applyTextCell setTitle:@"营业执照" content:@""];
            }
            break;
            
           case ApplicationInfoIndexStoreType:
              applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                
                if([self.userApplyInfo.shopType isEqualToString:@"0"])
                {
                    NSString *netWorkType = [NSString  stringWithFormat:@"%@",@"实体店"];
                    [applyTextCell setTitle:@"销售类型" content:netWorkType];
                }else
                {
                    if ([self.userApplyInfo.shopName isEqualToString:@""]||[self.userApplyInfo.shopName isEqual:nil]) {
                        
                        NSString *netWorkType = [NSString  stringWithFormat:@"%@|%@",@"网络分销",self.userApplyInfo.otherPlatform];
                        
                        [applyTextCell setTitle:@"销售类型" content:netWorkType];
                    }else
                    {
                        NSString *netWorkType = [NSString  stringWithFormat:@"%@|%@|%@",@"网络分销",self.userApplyInfo.otherPlatform,self.userApplyInfo.shopName];
                        
                        CGSize  shopNameStateHeight = [netWorkType boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
                        
                        applyTextCell.contentHight.constant = shopNameStateHeight.height+10;
                        
                        
                        [applyTextCell setTitle:@"销售类型" content:netWorkType];
                        
                        
                        
                        
                    }
                    
                }
                
            } else {
                [applyTextCell setTitle:@"销售类型" content:@""];
            }

            
            
            break;
            
        case ApplicationInfoIndexLicenseImage:
            
            applyImageCell = [tableView dequeueReusableCellWithIdentifier:applyImageCellIdentifier];
            if (self.userApplyInfo) {
                [applyImageCell setupIdCardImageURL:[NSURL URLWithString:self.userApplyInfo.identityPicUrl] andBusinessLicenceImageURL:[NSURL URLWithString:self.userApplyInfo.businessLicenseUrl]];
                
            }
            break;
            
        case ApplicationInfoIndexBusinessState:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                
                CGSize  businessStateHeight = [self.userApplyInfo.businessDesc boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
                
                applyTextCell.contentHight.constant = businessStateHeight.height+10;

                [applyTextCell setTitle:@"营业状况" content:self.userApplyInfo.businessDesc];
            }
            else {
                [applyTextCell setTitle:@"营业状况" content:@""];
            }
            break;
        case ApplicationInfoIndexApplicationState:
            applyTextCell = [tableView dequeueReusableCellWithIdentifier:applyTextCellIdentifier];
            if (self.userApplyInfo) {
                
                
                
                NSString* applyStatus = [CSPUtils translateApplyStatus:self.userApplyInfo.applyStatus];
                [applyTextCell setTitle:@"申请状态" content:applyStatus];
            } else {
                [applyTextCell setTitle:@"申请状态" content:@""];
            }
            break;
        default:
            break;

    }

    if (applyTextCell != nil) {
        cell = applyTextCell;
    } else {
        cell = applyImageCell;
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     LoginDTO *loginDTO = [LoginDTO sharedInstance];
    NSInteger indexTag = [loginDTO.joinType isEqualToString:@"2"]?indexPath.row+1:indexPath.row ;
    if (indexTag == ApplicationInfoIndexLicenseImage) {
        return 90;
        
    }else if (indexTag == ApplicationInfoIndexStoreType)
    {
        
        NSString *netWorkType = [NSString  stringWithFormat:@"%@|%@|%@",@"网络分销",self.userApplyInfo.otherPlatform,self.userApplyInfo.shopName];
        
        CGSize  shopNameStateHeight = [netWorkType boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
        
        if (shopNameStateHeight.height + 5 +10 < 44) {
            return 44;
        }
        return  shopNameStateHeight.height+10;
    }
    
    
    else if (indexTag == ApplicationInfoIndexDetailAddress)
    {
        CGSize  detailAddressHeight = [self.userApplyInfo.detailAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
        
        if (detailAddressHeight.height + 5 +10 < 44) {
            return 44;
        }
        
        
        return detailAddressHeight.height + 5 +10;
        
        
    }else if (indexTag == ApplicationInfoIndexBusinessState)
    {
    
        CGSize  businessStateHeight = [self.userApplyInfo.businessDesc boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 159, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;

        if (businessStateHeight.height + 5 +10 < 44) {
            return 44;
        }
        
        return businessStateHeight.height + 5 +10;
    
    }else{
        return 44;
    }
    
}

- (void)backBarButtonItemClicked:(id)sender {
    [self performSegueWithIdentifier:@"toWaitCertify" sender:self];
}
- (IBAction)logoutBarButtonItemClicked:(id)sender {
    
//    CSPWaitCertifyViewController *waitCertifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPWaitCertifyViewController"];
//    
//    [self.navigationController pushViewController:waitCertifyVC animated:YES];
//    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{

    [self performSegueWithIdentifier:@"toWaitCertify" sender:self];
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
