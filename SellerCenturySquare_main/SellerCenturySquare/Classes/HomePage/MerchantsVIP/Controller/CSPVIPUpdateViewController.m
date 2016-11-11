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
#import "CSPMemberVIPViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "CSPGoodsNewCheckTableViewController.h"
#import "CustomBarButtonItem.h"
#import "UIImageView+WebCache.h"
#import "CSPScrolSelectView.h"
#import "OrderAddDTO.h"
#import "CSPConsumptionPointsRecordTableViewController.h"
#import "GetMerchantInfoDTO.h"

@interface CSPVIPUpdateViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CSPScorllViewDelegate>
{
    NSInteger VIPLevel;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *VIPUpdateCollectionView;

@property (weak, nonatomic) IBOutlet CustomBarButtonItem *rightBarbuttonItem;
- (IBAction)rightBarButtonItemClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet CustomBadge *levelBadgeView;
@property (weak, nonatomic) IBOutlet UILabel *intergrationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;

@property (weak, nonatomic)  CSPScrolSelectView *selectView;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic) OrderAddDTO *orderAddDTO;

@end

@implementation CSPVIPUpdateViewController
@synthesize memDTO = memDTO_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家特权";
   

    self.memDTO = [GetMerchantInfoDTO sharedInstance];

    [self customBackBarButton];
    
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width/4*2, 0);
    
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
    
    self.integrationLabel.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.integrationLabel.layer.cornerRadius = 5;
    self.balanceLabel.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.balanceLabel.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *intergrationTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intergrationLabelTaped:)];
    [self.intergrationTitleLabel addGestureRecognizer:intergrationTaped];
    self.intergrationTitleLabel.userInteractionEnabled = YES;

    self.balanceTitleLabel.userInteractionEnabled = YES;
    
    VIPLevel = 6;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self UIInit];
   
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
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
            
        }else{
            view.frame = CGRectMake(i*self.view.frame.size.width/4, 0, self.view.frame.size.width/4, 70);
//            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width/4*2, 0);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*1.5, 70) ;
        }

    }

}

- (void)UIInit{
    
    self.shopNameL.text = self.memDTO.merchantName;
    
    [self.levelBadgeView changeViewToBadgeWithString:[NSString stringWithFormat:@"V%@",self.memDTO.level] withScale:0.5 withTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:201/255.0 green:32/255.0 blue:37/255.0 alpha:1]];
    
    self.integrationLabel.text = [NSString stringWithFormat:@" %@  ", self.memDTO.monthIntegralNum];
    
    if ([self.memDTO.downloadNum intValue]<0) {
        self.balanceLabel.text = @"无限制    ";
        self.balanceLabel.font = [UIFont systemFontOfSize:7];
    
    }else{
        self.balanceLabel.text = [NSString stringWithFormat:@"%@",self.memDTO.downloadNum];
    }
    
    [self bottomTipsViewUpdateWithLevel:VIPLevel];
    
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:self.memDTO.pictureUrl] placeholderImage:[UIImage imageNamed:@"merchant_placeholder"]];
    
}

- (void)bottomTipsViewUpdateWithLevel:(NSInteger)level{
    
    switch (level) {
        case 1:
            [self redTipShow:YES withRedText:@"连续2个月为V1,将清退。" withBlackText:@"0-49999"];
            break;
        case 2:
            [self redTipShow:YES withRedText:@"次月评级仍达不到V3，将降至V1" withBlackText:@"50000-99999"];
            break;
        case 3:
            [self redTipShow:NO withRedText:nil withBlackText:@"100000-199999"];
            break;
        case 4:
            [self redTipShow:NO withRedText:nil withBlackText:@"200000-299999"];
            break;
        case 5:
            [self redTipShow:NO withRedText:nil withBlackText:@"300000-499999"];
            break;
        case 6:
            [self redTipShow:NO withRedText:nil withBlackText:@"≥500000"];
            break;
        default:
            break;
    }
}

- (void)redTipShow:(BOOL)show withRedText:(NSString*)txt withBlackText:(NSString*)blackTxt{
    
    if (show) {
        
        _bottomHeight.constant = 74;
        
        _redHeight.constant = 27;
        
        if (txt) {
            _redTipL.text = txt;
            
        }
       
        _blackHeight.constant = 47;

    }else{
        
        _bottomHeight.constant = 50;
        
        _redHeight.constant = 0;
        
        _blackHeight.constant = 50;
    }
    
    if (blackTxt) {
        
        _bussinessScoreL.text = [NSString stringWithFormat:@"单月营业额积分：%@",blackTxt];
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
        return 6;
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
                cell.titleLabel.text = @"店铺置顶";
                if (VIPLevel>2) {
                    cell.roundimageView.image = [UIImage imageNamed:@"店铺置顶"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"店铺置顶-UnSelected"];
                }
                break;
            case 1:
                cell.titleLabel.text = @"采购商分级";
                if (VIPLevel>3) {
                    cell.roundimageView.image = [UIImage imageNamed:@"采购商分级"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"采购商分级-UnSelected"];
                }
                break;
            case 2:
                cell.titleLabel.text = @"采购商黑名单";
                if (VIPLevel>4) {
                    cell.roundimageView.image = [UIImage imageNamed:@"采购商黑名单"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"采购商黑名单-UnSelected"];
                }
                break;
            case 3:
                cell.titleLabel.text = @"免费下载图片次数";
                
                if (VIPLevel>2) {
                    switch (VIPLevel) {
                        case 3:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_免费下载图片次数10"];
                            break;
                        case 4:
                            cell.roundimageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数20次可下载状态"];
                            break;
                        case 5:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_免费下载图片次数30"];
                            break;
                        case 6:
                            cell.roundimageView.image = [UIImage imageNamed:@"无限下载"];//不限
                            break;
                            
                        default:
                            break;
                    }
                    
                    
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"免费下载图片次数-UnSelected"];
                }
                break;
            case 4:
                cell.titleLabel.text = @"付费下载图片次数";
                if (VIPLevel>2) {
                    switch (VIPLevel) {
                        case 3:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_付费下载图片次数¥500"];
                            break;
                        case 4:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_付费下载图片次数¥300"];
                            break;
                        case 5:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_付费下载图片次数¥200"];
                            break;
                        case 6:
                            cell.roundimageView.image = [UIImage imageNamed:@"04_商家中心_采购商_付费下载图片次数¥0"];
                            break;
                        default:
                            break;
                    }
                    
                    
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"付费下载图片次数-UnSelected"];
                }
                break;
            case 5:
                cell.titleLabel.text = @"限制采购商下载";
                if (VIPLevel>4) {
                    cell.roundimageView.image = [UIImage imageNamed:@"限制采购商下载"];
                }else{
                    cell.roundimageView.image = [UIImage imageNamed:@"限制采购商下载-UnSelected"];
                }
                break;
            default:
                break;
        }
    }else{
        if (indexPath.row ==0) {
            cell.titleLabel.text = @"每月免费上架";
            if (VIPLevel>2) {
                switch (VIPLevel) {
                    case 3:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架10"];
                        break;
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架20"];
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架30"];
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架50"];
                        break;
                    default:
                        break;
                }
            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架-UnSelected"];
            }
        }else if(indexPath.row ==1){
            cell.titleLabel.text = @"每月免费拍摄";
            if (VIPLevel>2) {
                switch (VIPLevel) {
                    case 3:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架10"];
                        break;
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架20"];
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架30"];
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"每月免费上架50"];
                        break;
                    default:
                        break;
                }
            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"每月免费拍摄-UnSelected"];
            }
        }else{
            cell.titleLabel.text = @"额外付费上架";
            if (VIPLevel>2) {
                switch (VIPLevel) {
                    case 3:
                        cell.roundimageView.image = [UIImage imageNamed:@"额外付费上架300"];
                        break;
                    case 4:
                        cell.roundimageView.image = [UIImage imageNamed:@"额外付费上架200"];
                        break;
                    case 5:
                        cell.roundimageView.image = [UIImage imageNamed:@"额外付费上架150"];
                        break;
                    case 6:
                        cell.roundimageView.image = [UIImage imageNamed:@"额外付费上架100"];
                        break;
                    default:
                        break;
                }

            }else{
                cell.roundimageView.image = [UIImage imageNamed:@"额外付费上架-UnSelected"];
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
                nextVC.Service = CSPOnlineGoodsPictureLook;
                break;
            case 4:
                nextVC.Service = CSPOnlineGoodsPictureFree;
                break;
            case 5:
                nextVC.Service = CSPOnlineGoodsPicturePay;
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
                nextVC.Service = CSPOfflineAdviseSupplier;
                break;
            case 2:
                nextVC.Service = CSPOfflineGuidance;
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

- (void)intergrationLabelTaped:(UITapGestureRecognizer *)gesture{
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    if (getMerchantInfoDTO.isMaster) {
        
        CSPConsumptionPointsRecordTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsRecordTableViewController"];
        //    nextVC.listArray = getIntegralListDTO.integralDTOList;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

-(void)selectButtonClicked:(UIButton *)sender{
    

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
    [self bottomTipsViewUpdateWithLevel:VIPLevel];
    [self.VIPUpdateCollectionView reloadData];
}


@end
