//
//  CSPVIPUpdateViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPVIPUpdateViewController.h"
#import "CSPVIPCollectionViewCell.h"
#import "CSPViPCollectionReusableView.h"
#import "CSPConsumptionPointsRecordTableViewController.h"
#import "CSPAdvancePaymentRecordTableViewController.h"
#import "CSPMemberVIPViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "UAProgressView.h"

#import "CSPGoodsNewCheckTableViewController.h"
#import "CustomBarButtonItem.h"
#import "UIImageView+WebCache.h"
#import "GetIntegralListDTO.h"
#import "IntegralByMonthDTO.h"
#import "GetPaymentsRecordsDTO.h"
#import "CSPScrolSelectView.h"
#import "MemberPermissionDTO.h"
#import "OrderAddDTO.h"
#import "CSPPersonalProfileViewController.h"


@interface CSPVIPUpdateViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CSPScorllViewDelegate>
{
    NSInteger VIPLevel;
    
    GetIntegralListDTO* getIntegralListDTO;
    
    CGFloat scrollViewBtnWidth;
    
}
//@property (weak, nonatomic) IBOutlet YAScrollSegmentControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *scrolbackView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *VIPUpdateCollectionView;

@property (weak, nonatomic) IBOutlet CustomBarButtonItem *rightBarbuttonItem;
- (IBAction)rightBarButtonItemClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intergrationLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLabelWidthCOnstraint;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
- (IBAction)confirmButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backgroungView;

@property (weak, nonatomic) IBOutlet UILabel *intergrationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;

@property (weak, nonatomic)  CSPScrolSelectView *selectView;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic) OrderAddDTO *orderAddDTO;

@property (weak, nonatomic) IBOutlet UAProgressView *headerView;
@property (nonatomic, assign) CGFloat localProgress;
@property (strong,nonatomic) UIImageView *imgView;
@property (strong,nonatomic) UILabel *vipLabel;
@end

@implementation CSPVIPUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员升级";
    [self addCustombackButtonItem];


    
    scrollViewBtnWidth = self.view.frame.size.width / 4;
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width/4*2, 0);
    
    self.scrollView.bounces = NO;
    
    for (int i = 0; i<6; i++) {
        CSPScrolSelectView *view;
        view = [[[NSBundle mainBundle] loadNibNamed:@"CSPScrolSelectView" owner:self options:nil] objectAtIndex:0];
        view.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"08_v%d会员未选中状态.png",i+1]];
        view.levelLabel.text = [NSString stringWithFormat:@"%d级会员",i+1];
        view.button.tag = i;
        view.bottomImageView.hidden = YES;
        view.delegate = self;
        view.tag = i+10;
        
        if (i == 5) {
            view.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"08_v%d会员选中状态.png",i+1]];
            view.topView.backgroundColor =[UIColor whiteColor];
            view.levelLabel.font = [UIFont systemFontOfSize:11];
            view.bottomImageView.hidden = NO;
        }
        
        [self.scrollView addSubview:view];
    }


    

    
    self.VIPUpdateCollectionView.dataSource = self;
    self.VIPUpdateCollectionView.delegate = self;
    
    self.integrationLabel.layer.backgroundColor = HEX_COLOR(0x454646FF).CGColor;
    self.integrationLabel.layer.cornerRadius = 5;
    self.balanceLabel.layer.backgroundColor = HEX_COLOR(0x454646FF).CGColor;
    self.balanceLabel.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *intergrationTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intergrationLabelTaped:)];
    UITapGestureRecognizer *intergrationTaped2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intergrationLabelTaped:)];
    [self.integrationLabel addGestureRecognizer:intergrationTaped2];
    self.integrationLabel.userInteractionEnabled = YES;
    [self.intergrationTitleLabel addGestureRecognizer:intergrationTaped];
    self.intergrationTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *balanceTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balanceLabelTaped:)];
    UITapGestureRecognizer *balanceTaped2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balanceLabelTaped:)];
    [self.balanceLabel  addGestureRecognizer:balanceTaped2];
         self.balanceLabel.userInteractionEnabled = YES;
    [self.balanceTitleLabel  addGestureRecognizer:balanceTaped];
    self.balanceTitleLabel.userInteractionEnabled = YES;
    
    VIPLevel = 6;
    self.levelLabel.text = @"V6预付货款";
    self.moneyLabel.text = @"50,000";
    


//    self.headerImageView.layer.masksToBounds=YES;
//    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
//    [self.headerImageView addGestureRecognizer:tap];
//    self.headerImageView.userInteractionEnabled = YES;
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
        [self.headerView addGestureRecognizer:tap];
        self.headerView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
    [self.nameLabel addGestureRecognizer:tap2];
    self.nameLabel.userInteractionEnabled = YES;
    
    //采购商等级权限
    
    [HttpManager sendHttpRequestForMemberPermissionListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.listArray = [[NSMutableArray alloc] init];
            
            self.listArray = [dic objectForKey:@"data"];

            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
    //头像动画
    [self setupheaderView ];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;

//    self.navigationController.navigationBar.
    
    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
             
            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
            if (![[MemberInfoDTO sharedInstance].iconUrl isEqualToString:@""]) {
                
//                self.headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.memDTO.iconUrl]]];
//                self.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[MemberInfoDTO sharedInstance].iconUrl]]];
                
                //!改成异步的
                NSString *iconUrl =  [MemberInfoDTO sharedInstance].iconUrl;
                
                [self.imgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"08_会员级_默认头像"]];
                
                
            }else{
//                self.headerImageView.image = [UIImage imageNamed:@"header.png"];
                self.imgView.image = [UIImage imageNamed:@"08_会员级_默认头像"];
            }
            
            self.vipLabel.text =[NSString stringWithFormat:@"V%@",[MemberInfoDTO sharedInstance].memberLevel.stringValue];
            
                if (![[MemberInfoDTO sharedInstance].nickName isEqualToString:@""]) {
                    self.nameLabel.text = [MemberInfoDTO sharedInstance].nickName;
                }else{
                    if (![[MemberInfoDTO sharedInstance].memberName isEqualToString:@""]) {
                        self.nameLabel.text = [MemberInfoDTO sharedInstance].memberName;
                    }else{
                        self.nameLabel.text = [MemberInfoDTO sharedInstance].mobilePhone;
                    }
                }

            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

    
    

    
    //消费记录积分查询
//    [HttpManager sendHttpRequestForGetIntegralListWithTime:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            getIntegralListDTO = [[GetIntegralListDTO alloc] init];
//            IntegralByMonthDTO* integralDTO = [[IntegralByMonthDTO alloc] init];
//            getIntegralListDTO.integralDTOList = [dic objectForKey:@"data"];
//            
//            if (getIntegralListDTO.integralDTOList.count>0) {
//                NSMutableDictionary *otherDic = getIntegralListDTO.integralDTOList[0];
//                [integralDTO setDictFrom:otherDic];
//                
//                //自适应label
//                self.integrationLabel.text = [CSPUtils stringFromNumber:integralDTO.integralNum];
//                UIFont *fnt = [UIFont fontWithName:@"TwCenMT-Regular" size:10];
//                self.integrationLabel.font = fnt;
//                self.integrationLabel.numberOfLines = 1;
//                self.integrationLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                CGRect tmpRect = [self.integrationLabel.text boundingRectWithSize:CGSizeMake(400, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
//                self.intergrationLabelWidthConstraint.constant = tmpRect.size.width+8;
//            }
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//    }];
    

    
    NSString *type =@"";
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:20];
    [HttpManager sendHttpRequestForGetPaymentsRecords:type pageNo:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPaymentsRecordsDTO *getPaymentsRecordsDTO = [[GetPaymentsRecordsDTO alloc ]init];
                //                PaymentsRecordsDTO *paymentsRecordsDTO = [[PaymentsRecordsDTO alloc ]init];
                
                [getPaymentsRecordsDTO setDictFrom:[dic objectForKey:@"data"]];
                self.balanceLabel.text = [NSString stringWithFormat:@"￥%@",[CSPUtils stringFromNumber:getPaymentsRecordsDTO.balance]];
                
//                self.balanceLabel.text = [CSPUtils stringFromNumber:getPaymentsRecordsDTO.balance];
                
                
                UIFont *fnt = [UIFont fontWithName:@"TwCenMT-Regular" size:10];
                self.balanceLabel.font = fnt;
                self.balanceLabel.numberOfLines = 1;
                self.balanceLabel.lineBreakMode = NSLineBreakByWordWrapping;
                CGRect tmpRect = [self.balanceLabel.text boundingRectWithSize:CGSizeMake(400, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
                self.balanceLabelWidthCOnstraint.constant = tmpRect.size.width+8;

            }
            
        }else{
        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];

    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    for (int i = 0; i<6; i++) {
        CSPScrolSelectView *view = (CSPScrolSelectView *)[self.scrollView viewWithTag:i+10];
        if (self.view.frame.size.width == 375) {
            view.frame = CGRectMake(i*94, 0, 94, 70);
//            self.scrollView.contentOffset = CGPointMake(94*2, 0);
            self.scrollView.contentSize = CGSizeMake(376*1.5, 70) ;
            
        }else if(self.view.frame.size.width == 414)
        {
            view.frame = CGRectMake(i*104, 0, 104, 70);
            self.scrollView.contentSize = CGSizeMake(416*1.5, 70) ;
        }
        else{
            view.frame = CGRectMake(i*self.view.frame.size.width/4, 0, self.view.frame.size.width/4, 70);
//            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width/4*2, 0);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*1.5, 70) ;
        }

    }
    
    

}



#pragma mark--
#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    else{
        return 3;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CSPVIPCollectionViewCell";
    CSPVIPCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                switch (VIPLevel) {
                    case 1:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看10日前上新可查看状态.png"];
                        cell.titleLabel.text = @"查看10日前更新";
                        break;
                    case 2:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看7日前上新可查看状态.png"];
                        cell.titleLabel.text = @"查看7日前更新";
                        break;
                    case 3:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看7日前上新可查看状态.png"];
                        cell.titleLabel.text = @"查看7日前更新";
                        break;
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看5日前上新可查看状态.png"];
                        cell.titleLabel.text = @"查看5日前更新";
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看3日前上新可查看状态.png"];
                        cell.titleLabel.text = @"查看3日前更新";
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看实时上新可查看状态.png"];
                        cell.titleLabel.text = @"查看实时更新";
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                cell.titleLabel.text = @"收藏商品";
                if (VIPLevel>2) {
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_可收藏状态.png"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_不可收藏状态.png"];
                }
                break;
            case 2:
                cell.titleLabel.text = @"分享图片链接";
                if (VIPLevel>4) {
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数10次可分享状态.png"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数10次不可分享状态.png"];
                }
                break;
            case 3:
                cell.titleLabel.text = @"查看窗口图";
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看窗口图可查看状态.png"];
                break;
            case 4:
                cell.titleLabel.text = @"查看客观图";
                if (VIPLevel>2) {
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看详情图可查看状态.png"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看详情图不可查看状态.png"];
                }
                break;
            case 5:
                cell.titleLabel.text = @"查看参考图";
                if (VIPLevel>2) {
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看参考图可查看状态.png"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_查看参考图不可查看状态.png"];
                }
                break;
            case 6:
                cell.titleLabel.text = @"免费下载次数";
                switch (VIPLevel) {
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数20次可下载状态.png"];
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数40次可下载状态.png"];
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数60次可下载状态.png"];
                        break;
                        
                    default:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数0不可下载状态.png"];
                        break;
                }
                break;
            case 7:
                cell.titleLabel.text = @"付费下载图片次数";
                switch (VIPLevel) {
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载20次¥50可下载状态.png"];
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载20次¥40可下载状态.png"];
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载20次¥30可下载状态.png"];
                        break;
                        
                    default:
                        cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载10次0不可下载状态.png"];
                        break;
                }
                break;

                
            default:
                break;
        }
    }else{
        if (indexPath.row ==0) {
            cell.titleLabel.text = @"优秀供应商推荐";
            if (VIPLevel>3) {
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_优秀供应商可点击状态.png"];
            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_优秀供应商不可点击状态.png"];
            }
        }else if(indexPath.row ==1){
            cell.titleLabel.text = @"开店指导";
            if (VIPLevel>5) {
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_开店指导可点击状态.png"];
            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_开店指导不可点击状态.png"];
            }
        }else{
            cell.titleLabel.text = @"买手推荐";
            if (VIPLevel>5) {
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_买手推荐可点击状态.png"];
            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_买手推荐不可点击状态.png"];
            }
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CSPViPCollectionReusableView *headView;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headView.titleLabel.text = @"线上服务";
        }else{
            headView.titleLabel.text = @"线下服务";
        }

    }

    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 20);
}


#pragma mark--
#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    CSPGoodsNewCheckTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsNewCheckTableViewController"];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                nextVC.Service = CSPOnlineNewsCheck;
                break;
            case 1:
                nextVC.Service = CSPOnlineGoodsCollection;
                break;
            case 2:
                nextVC.Service = CSPOnlineGoodsShare;
                break;
            case 3:
            case 4:
            case 5:
                nextVC.Service = CSPOnlineGoodsPictureLook;
                break;
            case 6:
                nextVC.Service = CSPOnlineGoodsPictureFree;
                break;
            case 7:
                nextVC.Service =CSPOnlineGoodsPicturePay;
                break;
        
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                nextVC.Service = CSPOfflineAdviseSupplier;
                break;
            case 1:
                nextVC.Service = CSPOfflineGuidance;
                break;
            case 2:
                nextVC.Service = CSPOfflineBuyerAdvise;
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (IBAction)rightBarButtonItemClicked:(id)sender {
    CSPMemberVIPViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPMemberVIPViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

//确认升级
- (IBAction)confirmButtonClicked:(id)sender {
    
    
    if ([MemberInfoDTO sharedInstance].memberLevel.integerValue >= VIPLevel ) {
        
        [self.view makeMessage:@"当前等级大于或等于所选等级,无需升级" duration:2.0f position:@"center"];

             return;
    }
    
    
    NSNumber *piece = [NSNumber numberWithInt:1];
    NSString *goodsNo;
    NSString *skuNo;
    NSNumber *servieType = [NSNumber numberWithInteger:4];
    
    MemberPermissionDTO* memberPermissionDTO = [[MemberPermissionDTO alloc] init];
    for (NSDictionary *dic in self.listArray) {
        [memberPermissionDTO setDictFrom:dic];
        if (VIPLevel == memberPermissionDTO.level.integerValue) {
            goodsNo = memberPermissionDTO.goodsNo;
            skuNo = memberPermissionDTO.skuNo;
        }
    }
    
    [HttpManager sendHttpRequestForaddVirtualOrder:piece goodsNo:goodsNo skuNo:skuNo serviceType:servieType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            self.orderAddDTO = [[OrderAddDTO alloc] init];
            
            [self.orderAddDTO setDictFrom:[dic objectForKey:@"data"]];
            
            
            CSPPayAvailabelViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.orderAddDTO = self.orderAddDTO;
            destViewController.isAvailable = NO;
            destViewController.isHomePage = YES;
            
            [self.navigationController pushViewController:destViewController animated:YES];
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];

    
}

- (void)intergrationLabelTaped:(UITapGestureRecognizer *)gesture{
    
    CSPConsumptionPointsRecordTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsRecordTableViewController"];
    
//    nextVC.listArray = getIntegralListDTO.integralDTOList;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)balanceLabelTaped:(UITapGestureRecognizer *)gesture{
    CSPAdvancePaymentRecordTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAdvancePaymentRecordTableViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)selectButtonClicked:(UIButton *)sender{
    
    
    if (sender.tag == 5 || sender.tag == 4) {
        
        [self.scrollView setContentOffset:CGPointMake(scrollViewBtnWidth * 2, self.scrollView.frame.origin.y) animated:YES];
    }else if (sender.tag == 3) {
        if (self.scrollView.contentOffset.x < scrollViewBtnWidth) {
            
            [self.scrollView setContentOffset:CGPointMake(scrollViewBtnWidth, self.scrollView.frame.origin.y) animated:YES];
        }
    }else if (sender.tag == 2) {
        if (self.scrollView.contentOffset.x > scrollViewBtnWidth) {
            
            [self.scrollView setContentOffset:CGPointMake(scrollViewBtnWidth * 1, self.scrollView.frame.origin.y) animated:YES];
        }
    }else if (sender.tag == 1) {
        if (self.scrollView.contentOffset.x > 0) {
            
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.origin.y) animated:YES];
        }
    }else {
        
    }
    
    for (int i = 0; i<6; i++) {
        CSPScrolSelectView *view = (CSPScrolSelectView *)[self.scrollView viewWithTag:i+10];
        view.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"08_v%d会员未选中状态.png",i+1]];
        view.topView.backgroundColor =[UIColor clearColor];
        view.levelLabel.font = [UIFont systemFontOfSize:9];
        view.bottomImageView.hidden = YES;
    }
        CSPScrolSelectView *view = (CSPScrolSelectView *)[self.scrollView viewWithTag:sender.tag+10];
        view.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"08_v%ld会员选中状态.png",sender.tag+1]];
        view.topView.backgroundColor =[UIColor whiteColor];
        view.levelLabel.font = [UIFont systemFontOfSize:11];
        view.bottomImageView.hidden = NO;
    
    
    NSLog(@"%ld",sender.tag);
    VIPLevel = sender.tag+1;
    switch (VIPLevel) {
        case 1:
            self.backgroungView.hidden = YES;
            break;
        case 2:
            self.backgroungView.hidden = YES;
            break;
        case 3:
            self.backgroungView.hidden = NO;
            self.levelLabel.text = @"V3预付货款";
            self.moneyLabel.text = @"10,000";
            break;
        case 4:
            self.backgroungView.hidden = NO;
            self.levelLabel.text = @"V4预付货款";
            self.moneyLabel.text = @"20,000";
            break;
        case 5:
            self.backgroungView.hidden = NO;
            self.levelLabel.text = @"V5预付货款";
            self.moneyLabel.text = @"30,000";
            break;
        case 6:
            self.backgroungView.hidden = NO;
            self.levelLabel.text = @"V6预付货款";
            self.moneyLabel.text = @"50,000";
            break;
            
        default:
            break;
    }
    [self.VIPUpdateCollectionView reloadData];
}

-(void)headerImageViewTaped:(UITapGestureRecognizer *)gesture{
    CSPPersonalProfileViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPersonalProfileViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (void)setupheaderView {
    
    /*
     设置头像的圆形效果：1.创建一个viewPhoto 2.把图片放到viewPhoto上 3.让viewPhoto居中
     */
    
    self.headerView.backgroundColor = [UIColor clearColor];
    //1.创建头像的view
    UIView *viewPhoto= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width-3, self.headerView.frame.size.height-3)];
    
    //添加图片
    self.imgView = [[UIImageView alloc] initWithFrame:viewPhoto.bounds];
//    img.image = [UIImage imageNamed:@"header.png"];
    [viewPhoto addSubview:self.imgView ];
    
    viewPhoto.layer.cornerRadius = viewPhoto.frame.size.width/2;
    viewPhoto.layer.masksToBounds = YES;
    viewPhoto.userInteractionEnabled = YES;
    
    
    //centralView 这个view的位置刚好是居中的
    self.headerView.centralView = viewPhoto;
    
    
    self.headerView.fillChangedBlock = ^(UAProgressView *progressView, BOOL filled, BOOL animated){
        UIColor *color = (filled ? [UIColor whiteColor] : [UIColor redColor]);
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                progressView.centralView.backgroundColor = color;
            }];
        } else {
            progressView.centralView.backgroundColor = color;
        }
    };
    
    
    //这个位置需要调整的
    
    UIView *roundView1 = [[UIView alloc]initWithFrame:CGRectMake(50,3, 20, 20)];
    roundView1.backgroundColor = [UIColor blackColor];
    roundView1.layer.cornerRadius = 10;
    
    
    UIView *roundView = [[UIView alloc]initWithFrame:CGRectMake(52,5, 16, 16)];
    roundView.backgroundColor = HEX_COLOR(0xcb1d1dFF);
    roundView.layer.cornerRadius = 8;
    
    
    self.vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(52,5, 16, 16)];
    self.vipLabel.textAlignment =NSTextAlignmentCenter;
//    self.vipLabel.text = @"V3";
    self.vipLabel.backgroundColor = [UIColor clearColor];
    self.vipLabel.font = [UIFont systemFontOfSize:9];
    self.vipLabel.textColor = [UIColor whiteColor];

    [self.headerView addSubview:roundView1];
    [self.headerView addSubview:roundView];
    [self.headerView addSubview:self.vipLabel];
}

- (void)updateProgress:(NSTimer *)timer {
    _localProgress = ((int)((_localProgress * 100.0f) + 1.01) % 100) / 100.0f;
    NSLog(@"%f",_localProgress);
    
    //
    if (_localProgress  == 0.8f) {
        [timer   invalidate];
    }
    [self.headerView setProgress:_localProgress];
}


@end
