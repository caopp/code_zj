//
//  CSPConfirmOrderViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPConfirmOrderViewController.h"
#import "CSPBaseOrderTableViewCell.h"
#import "SDRefresh.h"
#import "CartListConfirmDTO.h"
#import "CSPOrderSectionHeaderView.h"
#import "GetConsigneeListDTO.h"
#import "CSPConsigneeSectionHeaderView.h"
#import "ConversationWindowViewController.h"
#import "OrderAddDTO.h"
#import "CSPPayAvailabelViewController.h"
#import "CSPAddressMangementViewController.h"//地址管理
#import "AddShippingAddressView.h"//添加收货地址
#import "ConfirmShippingFooterTableViewCell.h"
#import "OrderAccountFooterView.h"

@interface CSPConfirmOrderViewController () <UITableViewDataSource, UITableViewDelegate, CSPConsigneeSectionHeaderViewDelegate, CSPAddressMangementViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  确认采购单
 */
@property (weak, nonatomic) IBOutlet UIButton *submitOrderBtn;
/**
 *  运费价格
 */
@property (weak, nonatomic) IBOutlet UILabel *freightPrepaidLab;
/**
 *  商品件数
 */
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;


@property (nonatomic, strong) CartListConfirmDTO* cartListConfirm;
//收货地址model
@property (nonatomic, strong) ConsigneeDTO* consignee;
//记录收货地址
@property (nonatomic, strong) ConsigneeDTO* recordConsignee;





@property (nonatomic, assign) BOOL isConsigneeLoaded;
@property (nonatomic, assign) BOOL isCartConfirmListLoaded;

@property (nonatomic, weak)  SDRefreshHeaderView *refreshHeader;
@property (nonatomic ,strong) NSString *memberNo;
@property (nonatomic ,strong) NSString *provinceNo;

@property (nonatomic ,strong) NSMutableArray *deliverArr;

@property (nonatomic ,strong) OrderAccountFooterView*footerView;

@property (nonatomic ,strong) NSMutableArray *footerViewArr;


@end

@implementation CSPConfirmOrderViewController

static NSString *SectionHeaderViewIdentifier = @"OrderSectionHeaderViewIdentifier";
static NSString *ConsigneeSectionHeaderViewIdentifier =  @"ConsigneeSectionHeaderView";

static NSString* toPayAvailableSegueId = @"toPayAvailable";
static NSString* toPayUnavailableSegueId = @"toPayUnavailable";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional CSPShoppingCartViewController.hup after loading the view.
    self.title = @"确认采购单";
    
    
    self.deliverArr = [NSMutableArray array];
    self.footerViewArr = [NSMutableArray array];
    


    UINib *sectionHeaderNib = [UINib nibWithNibName:@"OrderSectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];

    UINib* consigneeSectionHeaderNib = [UINib nibWithNibName:@"ConsigneeSectionHeaderView" bundle:nil];
    [self.tableView registerNib:consigneeSectionHeaderNib forHeaderFooterViewReuseIdentifier:ConsigneeSectionHeaderViewIdentifier];
    
    self.tableView.rowHeight = 60.0f;
    self.tableView.userInteractionEnabled = YES;
    

    //初始化下拉刷新
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    
    __weak CSPConfirmOrderViewController *weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadCartConfirmInfoAndConsigneeInfo];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];

    [self updateBottomViewInfo];

    [self addCustombackButtonItem];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    __weak CSPConfirmOrderViewController *weakSelf = self;
    [weakSelf loadCartConfirmInfoAndConsigneeInfo];

[[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    if (self.consignee) {
    
        return self.cartListConfirm.merchantList.count + 1;
//    }
//
//    return self.cartListConfirm.merchantList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    if (self.consignee) {
        if (section == 0) {
            return 0;
        } else {
            
            CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[section - 1];
            return merchantInfo.goodsList.count;
            
//        }
    }
//        else {
//        CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[section];
//        return merchantInfo.goodsList.count;
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (self.consignee) {
        if (indexPath.section == 0) {
            return nil;
        } else {
            CSPBaseOrderTableViewCell *cell = nil;
            
            CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[indexPath.section - 1];
            
            if (merchantInfo.goodsList.count > indexPath.row) {
                
                CartConfirmGoods* goodsInfo = merchantInfo.goodsList[indexPath.row];
                switch (goodsInfo.goodsType) {
                    case CartConfirmGoodsTypeOfNormal:
                        //普通商品
                        cell = [tableView dequeueReusableCellWithIdentifier:@"NormalOrderTableViewCell" forIndexPath:indexPath];
                        break;
                    case CartConfirmGoodsTypeOfSample:
                        //样板
                        cell = [tableView dequeueReusableCellWithIdentifier:@"SampleOrderTableViewCell" forIndexPath:indexPath];
                        break;
                    case CartConfirmGoodsTypeOfMail:
                        //邮费专拍
                        cell = [tableView dequeueReusableCellWithIdentifier:@"MailOrderTableViewCell" forIndexPath:indexPath];
                        break;
                    default:
                        break;
                }

                
                // Configure the cell...
                cell.cartGoodsInfo = goodsInfo;
                return cell;
            } else {
                return nil;
            }
        }
//    }
//    else {
//        CSPBaseOrderTableViewCell *cell = nil;
//        CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[indexPath.section];
//        if (merchantInfo.goodsList.count > indexPath.row) {
//            CartConfirmGoods* goodsInfo = merchantInfo.goodsList[indexPath.row];
//            switch (goodsInfo.goodsType) {
//                case CartConfirmGoodsTypeOfNormal:
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"NormalOrderTableViewCell" forIndexPath:indexPath];
//                    break;
//                case CartConfirmGoodsTypeOfSample:
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"SampleOrderTableViewCell" forIndexPath:indexPath];
//                    break;
//                case CartConfirmGoodsTypeOfMail:
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"MailOrderTableViewCell" forIndexPath:indexPath];
//                    break;
//                default:
//                    break;
//            }
//
//            // Configure the cell...
//            cell.cartGoodsInfo = goodsInfo;
//            return cell;
//        } else {
//            return nil;
//        }
//    }
    

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    if (self.consignee) {
        if (section == 0) {
            CSPConsigneeSectionHeaderView* sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ConsigneeSectionHeaderViewIdentifier];
            if (self.recordConsignee) {
                
                self.consignee = self.recordConsignee;
            }
            sectionHeaderView.consignee = self.consignee;
        
            
            sectionHeaderView.delegate = self;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeConsigneeButtonClicked)];
            [sectionHeaderView addGestureRecognizer:tap];


            if (self.consignee) {
                
                sectionHeaderView.addShippingAddressView.hidden = YES;
                
//                [sectionHeaderView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                
                
                return sectionHeaderView;
                

            }else
            {
                
                sectionHeaderView.addShippingAddressView.hidden = NO;
                
            return sectionHeaderView;
            }
                
        } else {

            CSPOrderSectionHeaderView* sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
            CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[section - 1];
            sectionHeaderView.cartConfirmMerchantInfo = merchantInfo;
            sectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.height, 50);
            sectionHeaderView.delegate = self;

            return sectionHeaderView;
        }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section>0) {
        
    
//        OrderAccountFooterView.h
//        OrderAccountFooterView.m
    //运费模板
        
        OrderAccountFooterView*footerView;
        
        if (self.footerViewArr.count >0) {
            if ((self.footerViewArr.count - 1) >=section) {
                
                footerView = [self.footerViewArr objectAtIndex:section];

            }else
            {
                footerView = [[[NSBundle mainBundle] loadNibNamed:@"OrderAccountFooterView" owner:nil options:nil]lastObject];
                
                [self.footerViewArr addObject:footerView];

            }
        }else
        {
            footerView = [[[NSBundle mainBundle] loadNibNamed:@"OrderAccountFooterView" owner:nil options:nil]lastObject];
            [self.footerViewArr addObject:footerView];
            

        }
        CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[section - 1];

        
        footerView.blockOrderAccountFooterSelectData = ^(DelieveryListDTO *deliverListDto)
        {
            
            if (_deliverArr.count>0) {
                
                NSArray *tempArr = self.deliverArr;
                
                NSString *tempMark = @"no";
                for (int i = 0; i<tempArr.count; i++) {
                    NSDictionary *dict = tempArr[i];
                    NSString *merchantNo = dict[@"merchantNo"];
                    NSString *type = dict[@"type"];
                    if ([merchantNo isEqualToString:deliverListDto.merchantNo] && [type isEqualToString:deliverListDto.type]) {
                        tempMark = @"yes";
                        [self.deliverArr removeObject:dict];
                        
                    }
                    
                }
//                if ([tempMark isEqualToString:@"no"]) {
                
                    [self.deliverArr addObject:@{@"merchantNo":deliverListDto.merchantNo,@"templateId":deliverListDto.templateId,@"type":deliverListDto.type}];
                    
//                }
                
            }else
            {
                [self.deliverArr addObject:@{@"merchantNo":deliverListDto.merchantNo,@"templateId":deliverListDto.templateId,@"type":deliverListDto.type}];
            }
            
            
            NSLog(@"self.deliverArr = %@",self.deliverArr);
            
            [self loadCartInfo];
            
    
        };

        [footerView orderAccountFootCartConfirmMerchant:merchantInfo];

        return footerView;
    }
     return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section >0) {
        return 80;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.consignee) {
        if (indexPath.section == 0) {
            return 0;
        } else {
            CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[indexPath.section - 1];
            if (merchantInfo.goodsList.count > indexPath.row) {
                CartConfirmGoods* goodsInfo = merchantInfo.goodsList[indexPath.row];
                return [CSPBaseOrderTableViewCell cellHeightWithSizesCount:goodsInfo.sizes.count];
            }
            return 91.0f;
        }
    
//    } else {
//        CartConfirmMerchant* merchantInfo = self.cartListConfirm.merchantList[indexPath.section];
//        if (merchantInfo.goodsList.count > indexPath.row) {
//            CartConfirmGoods* goodsInfo = merchantInfo.goodsList[indexPath.row];
//            return [CSPBaseOrderTableViewCell cellHeightWithSizesCount:goodsInfo.sizes.count];
//        }
//        return 91.0f;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.consignee) {
        if (section == 0) {
            if (self.consignee) {
                
                
                CGSize size =    [self accordingContentFont:[NSString stringWithFormat:@"收货地址: %@", self.consignee.addressDescription]];
                if ((size.height+54)>80) {
                    return size.height+54;
                }
                
                return 80;

            }else{
                return 45;
            }
            
        } else {
            return 60.0f;
        }
}


#pragma mark - CustomTableViewCellDelegate


// 生成采购单
- (IBAction)confirmButtonClicked:(id)sender {
    if (!self.consignee || !self.consignee.Id) {
        
        [self.view makeMessage:@"请添收货地址" duration:2.0f position:@"center"];

        return;
    }
    
    self.submitOrderBtn.userInteractionEnabled = NO;

    [HttpManager sendHttpRequestForOrderAddSuccess:self.consignee.Id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",operation.responseString);

        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            OrderAddDTO *orderAddDTO = [[OrderAddDTO alloc] init];
            [orderAddDTO setDictFrom:dic[@"data"]];
            
            CSPPayAvailabelViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.isGoods = self.isGoods;
            
            destViewController.orderAddDTO = orderAddDTO;
            destViewController.isAvailable = YES;
            [self.navigationController pushViewController:destViewController animated:YES];
        } else {
            self.submitOrderBtn.userInteractionEnabled = YES;

            [self.view makeMessage:[NSString stringWithFormat:@"生成采购单操作失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

          
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.submitOrderBtn.userInteractionEnabled = NO;

        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

#pragma mark -
#pragma CSPOrderSectionHeaderViewDelegate

- (void)sectionHeaderView:(CSPOrderSectionHeaderView*)sectionHeaderView enquiryWithMerchantName:(NSString*)merchantName {
    
//    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:@"zhangsan" jid:@"zhangsan" withType:IMType_Service withGood:nil];
//
//    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark -
#pragma mark CSPConsigneeSectionHeaderViewDelegate

- (void)changeConsigneeButtonClicked {
    
    CSPAddressMangementViewController * destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAddressMangementViewController"];
    
    destViewController.isFromSureOrder = YES;//!标志是从确认订单界面进入的
    destViewController.orderSelectID =  self.consignee.Id;//!确认订单的id
    
    destViewController.delegate = self;
    
    [self.navigationController pushViewController:destViewController animated:YES];
    
    
}

#pragma mark -
#pragma mark Private Methods

- (void)loadCartConfirmInfoAndConsigneeInfo {
    
    self.isCartConfirmListLoaded = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //#进行判断收货地址信息
    if (!self.consignee) {
        
        self.isConsigneeLoaded = NO;
        [self loadConsigneeInfo];
        
    }
    
    [self loadCartInfo];
    
}


//	选择结算商品/采购单确认

- (void)loadCartInfo {
    
    //self.selectedGoods（商品采购单cartType和goodsNo数组集合，商品采购单）
    //#确定商品确定
    
    [HttpManager sendHttpRequestForGetCartConfirmWithCartKeyList:self.selectedGoods templateIds:self.deliverArr provinceNo:self.provinceNo memberNo:self.memberNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            self.cartListConfirm = [[CartListConfirmDTO alloc]initWithDictionary:dic[@"data"]];
            
            [self.tableView reloadData];
            //#获取收据进行添加
            [self updateBottomViewInfo];

        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询结算商品失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

        }

        //@结束刷新
        [self.refreshHeader endRefreshing];
        
        self.isCartConfirmListLoaded = YES;
        
        if (self.isConsigneeLoaded && self.isCartConfirmListLoaded) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        [self.refreshHeader endRefreshing];
        
        self.isCartConfirmListLoaded = YES;
        
        if (self.isConsigneeLoaded && self.isCartConfirmListLoaded) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

//小B收货地址列表接口
- (void)loadConsigneeInfo {
    
    [HttpManager sendHttpRequestForConsigneeGetListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            GetConsigneeListDTO* getConsigneeListDTO = [[GetConsigneeListDTO alloc] initWithDictionary:dic];

            self.consignee = getConsigneeListDTO.defaultConsignee;
            [self.tableView reloadData];

            if (!self.consignee || !self.consignee.Id) {
                self.submitOrderBtn.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            }else {
                self.submitOrderBtn.backgroundColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
                
                [self.tableView reloadData];
            }
        } else {
             [self.view makeMessage:[NSString stringWithFormat:@"查询收货地址列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
           
        }
        
        self.isConsigneeLoaded = YES;
        
//        if (self.isConsigneeLoaded && self.isCartConfirmListLoaded) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
        self.isConsigneeLoaded = YES;
        
//        if (self.isConsigneeLoaded && self.isCartConfirmListLoaded) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }
    }];
}

- (void)updateBottomViewInfo {

    if (self.cartListConfirm) {
        
        //@获取价格和总共商品数量
        
        NSString *totalStr =[NSString stringWithFormat:@"共 %lu 件",self.cartListConfirm.totalQuantity];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
        
        
//        [UIFontsystemFontOfSize:15.0],NSFontAttributeName,
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:19.0]
         
                              range:NSMakeRange(1, totalStr.length-2)];

        
        
        
    self.totalAmountLabel.attributedText =AttributedStr ;

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

//    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.cartListConfirm.totalPrice.doubleValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.cartListConfirm.totalPrice.doubleValue] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;
    self.freightPrepaidLab.text = [NSString stringWithFormat:@"¥%.2f",self.cartListConfirm.totalDelieveryFee.doubleValue];
        
        
        
        
    } else {
        
        self.totalAmountLabel.text = @"共0件";
        self.freightPrepaidLab.text = [NSString stringWithFormat:@"¥0.00"];

        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

//        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:@"0.00" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:19]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:@"0.00" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19]}];

        [priceString appendAttributedString:priceValueString];

        self.priceLabel.attributedText = priceString;
    }
}

//计算字体
- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}


#pragma mark -
#pragma mark CSPAddressMangementViewControllerDelegate

- (void)updateConsignee:(ConsigneeDTO *)consignee {
    self.recordConsignee = consignee;
    self.provinceNo = [NSString stringWithFormat:@"%@",consignee.provinceNo];
    [self.tableView reloadData];
//    [self loadConsigneeInfo];
    [self loadCartInfo];
    
    
}

@end
