//
//  CSPShoppingCartViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPShoppingCartViewController.h"
#import "CSPNormalCartTableViewCell.h"
#import "CSPSampleCartTableViewCell.h"
#import "CSPMailCartTableViewCell.h"
#import "CSPBaseCartTableViewCell.h"
#import "CSPCartSectionHeaderView.h"
#import "CartListDTO.h"
#import "CartAddDTO.h"
#import "ConversationWindowViewController.h"
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"

#import "WholeSaleConditionDTO.h"
#import "CSPConfirmOrderViewController.h"
#import "CSPPostageViewController.h"
#import "GoodsInfoDTO.h"
#import "CSPGoodsInfoTableViewController.h"
#import "CSPPersonCenterMainViewController.h"
#import "GoodDetailViewController.h"

#import "MerchantDeatilViewController.h"//!商家详情
#import "AllGoodsViewController.h"//!全部商品列表
#import "MerchantListViewController.h"//!商家列表

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface CSPShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource, CSPBaseCartTableViewCellDelegate, CSPCartSectionHeaderViewDelegate, UIAlertViewDelegate> {
}

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIView* bottomView;
//全选
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *noGoodsTipView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) CartListDTO* cartList;

@property (nonatomic, strong) CartGoods* cartGoodsOfSelectedToDelete;
@property (nonatomic, strong) NSIndexPath* indexPathOfSelectedToDelete;
@property (nonatomic, assign)BOOL keyboardShown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;

@property (nonatomic, weak)     SDRefreshHeaderView *refreshHeader;

@end

@implementation CSPShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.selectAllButton.enabled = NO;
    
    // Do any additional setup after loading the view.
    self.editButtonItem.possibleTitles = [NSSet setWithObjects:@"编辑", @"完成", nil];
    self.editButtonItem.title = @"编辑";
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]};
    [self.editButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.editButtonItem.tintColor = HEX_COLOR(0x999999FF);

//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"采购车";

    //头部view
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"CartSectionHeaderView" bundle:nil];
    //注册头部ID
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    //下拉刷新数据
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    //添加
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPShoppingCartViewController * weakSelf = self;
    //进来第一次加请求数据
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadCartInfo];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];

    //统计所有的钱数
    [self updateTotalPrice];

    //更改按钮的状态
    [self updatePayButtonState];
    
    //设置后退按钮
    [self addCustombackButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    
    //进来就刷新
    [self.refreshHeader beginRefreshing];
    
    
    //监听键盘显示和隐藏事件
    //显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.selectAllButton.selected = NO;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
//    self.constraintToAdjust.constant = 0;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Move this asignment to the method/action that
    // handles table editing for bulk operation.
    [super setEditing:editing animated:animated];

    if (self.editing) {
        
        self.editButtonItem.title = @"完成";
        
    } else {
        
        self.editButtonItem.title = @"编辑";
    
    }

    [self.tableView setEditing:editing animated:animated];

//    for (CartMerchant* merchantInfo in self.cartList.merchantList) {
//        merchantInfo.headerView.selectButton.selected = NO;
//    }
//
//    self.selectAllButton.selected = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.cartList.merchantList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    CartMerchant* cartMerchantInfo = self.cartList.merchantList[section];
    return cartMerchantInfo.goodsList.count;
}


/**
 *****************************************************************************
 */
- (CSPBaseCartTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    CSPBaseCartTableViewCell *cell = nil;

    CartGoods* cartGoodsInfo = [self.cartList cartGoodsForIndexPath:indexPath];
    if (cartGoodsInfo.cartGoodsType == CartGoodsTypeOfNormal) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCartTableViewCell" forIndexPath:indexPath];
    } else if (cartGoodsInfo.cartGoodsType == CartGoodsTypeOfSample) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SampleCartTableViewCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MailCartTableViewCell" forIndexPath:indexPath];
    }

    // Configure the cell...
    [cell setEditing:self.isEditing];
    [cell setupWithCartGoodsInfo:cartGoodsInfo];
    
     CartMerchant* cartMerchantInfo = self.cartList.merchantList[indexPath.section];
    if ((cartMerchantInfo.goodsList.count -1 )== indexPath.row) {
        [cell showLastLine:YES];
    }else {
        [cell showLastLine:NO];
    }

    cell.delegate = self;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CartGoods* cartGoodsInfo = [self.cartList cartGoodsForIndexPath:indexPath];
    if (cartGoodsInfo.cartGoodsType == CartGoodsTypeOfNormal) {
        if (!cartGoodsInfo.isInvalidCartGoods) {
            if (cartGoodsInfo.skuList.count == 0) {
                return 105;
            } else {
                return 125 + 35 * cartGoodsInfo.skuList.count;
            }
        } else {
            return 105;
        }

    } else if (cartGoodsInfo.cartGoodsType == CartGoodsTypeOfSample) {
        return 88.0f;
    } else {
        return 98.0f;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CartGoods* cartGoodsInfo = [self.cartList cartGoodsForIndexPath:indexPath];
    
    if (cartGoodsInfo.isInvalidCartGoods) {
        
        
    }
    
    if (![cartGoodsInfo.goodsStatus isEqualToString:@"2"]) {
        return;
    }
    
    if (cartGoodsInfo.cartGoodsType == CartGoodsTypeOfNormal ||
        cartGoodsInfo.cartGoodsType == CartGoodsTypeOfSample) {
        
        GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
        
        goodsInfoDTO.goodsNo = cartGoodsInfo.goodsNo;
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //   CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
        //
        //            goodsInfo.goodsNo = commodityInfo.goodsNo;
        
        GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        
        [self.navigationController pushViewController:goodsInfo animated:YES];
        
    } else {
        CSPPostageViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        destViewController.merchantNo = cartGoodsInfo.merchantNo;
        [self.navigationController pushViewController:destViewController animated:YES];
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CSPCartSectionHeaderView* sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    CartMerchant* merchantInfo = self.cartList.merchantList[section];
    merchantInfo.headerView = sectionHeaderView;

    [sectionHeaderView setupWithMerchantInfo:merchantInfo section:section];

    if (merchantInfo.isSatisfy) {
        sectionHeaderView.style = CartSectionHeaderViewStyleNormal;
    } else {
        sectionHeaderView.style = CartSectionHeaderViewStyleWarning;
    }
    sectionHeaderView.delegate = self;

    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CartMerchant* merchantInfo = self.cartList.merchantList[section];
    if (merchantInfo.isSatisfy) {
        return 30;
    } else {
        
        return 150;
    }
    return 30;
}

#pragma mark - CustomTableViewCellDelegate


- (void)cartTableViewCell:(CSPBaseCartTableViewCell*)cartTableViewCell cartTableViewCellSkuValueChangedToValid:(BOOL)valid {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cartTableViewCell];
    
    if (valid) {
        [self updateSectionSelectionButtonStateForSection:indexPath.section];
    }
}

- (void)cartTableViewCell:(CSPBaseCartTableViewCell *)cartTableViewCell selectionStateChanged:(BOOL)selected {
    NSIndexPath *indexPath =  [self.tableView indexPathForCell:cartTableViewCell];
    [self updateAllSelectionStateForSectionOfActionItem:indexPath.section];
    [self updateTotalPrice];

    [self updatePayButtonState];
}

- (void)cartTableViewCell:(CSPBaseCartTableViewCell *)cartTableViewCell deleteCartGoodsInfo:(CartGoods *)goodsInfo {

    NSIndexPath* indexPath = [self.tableView indexPathForCell:cartTableViewCell];
    if (indexPath.section < self.cartList.merchantList.count) {
        CartMerchant* merchantInfo = self.cartList.merchantList[indexPath.section];
        if (indexPath.row < merchantInfo.goodsList.count) {
            self.cartGoodsOfSelectedToDelete = merchantInfo.goodsList[indexPath.row];
            self.indexPathOfSelectedToDelete = indexPath;

            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否从采购车中删除该商品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];

            [alertView show];
        }
    }

    [self updateTotalPrice];

    [self updatePayButtonState];
}

- (void)cartTableViewCellSelectionStateChanged {
    [self updateTotalPrice];

    [self updatePayButtonState];
}

- (void)cartTableViewCellSkuValueChanged {
    [self updateTotalPrice];
}

- (void)cartTableViewCellSkuValueCannotSubtract {
    [self.view makeMessage:@"商品数量不能小于起批数量" duration:2.0f position:@"center"];
    

}

- (void)cartTableViewCellSkuValueChangeFailed {
    [self.view makeMessage:@"采购车数量修改失败" duration:2.0f position:@"center"];
    [self.tableView reloadData];
    
}

#pragma mark - Private Method

- (void)updateTotalPrice {
    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.cartList.totalPriceForSelectedGoods] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19]}];

    [priceString appendAttributedString:priceValueString];

    self.totalPriceLabel.attributedText = priceString;

}

- (void)updateAllSelectionStateForSectionOfActionItem:(NSInteger)section {

    [self updateTotalSelectionButtonState];

    [self updateSectionSelectionButtonStateForSection:section];
}

- (void)updatePayButtonState {
    if ([self.cartList selectedGoodsAmount] > 0) {
        [self.payButton setEnabled:YES];
        [self.payButton setBackgroundColor:[UIColor colorWithHexValue:0xfd4f57 alpha:1]];
    } else {
        [self.payButton setEnabled:NO];
        [self.payButton setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    }
}

- (void)updateTotalSelectionButtonState {
    if (self.cartList.isAllGoodsSelected) {
        [self.selectAllButton setSelected:YES];
    } else {
        [self.selectAllButton setSelected:NO];
    }
}

- (void)updateSectionSelectionButtonStateForSection:(NSInteger)section {

    CartMerchant* merchantInfo = self.cartList.merchantList[section];
    BOOL selectionState = merchantInfo.isAllGoodsSelected;
    merchantInfo.selected = selectionState;

    CSPCartSectionHeaderView* headerView = merchantInfo.headerView;

    if (headerView) {
        headerView.selectButton.selected = selectionState;
        [headerView.selectButton setHidden:![merchantInfo isThereGoodsOptional]];
    }
}

/**
 *  请求所有信息
 */
- (void)loadCartInfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.bottomView.hidden = NO;
//    self.constraintToAdjust.constant = 0;
    [HttpManager sendHttpRequestForCartListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:clickCartNotification object:nil];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.cartList = [[CartListDTO alloc]initWithDictionary:dic];
            if (self.cartList.merchantList.count>0) {
                
               
                [self updateTotalPrice];

//                [self updateTotalSelectionButtonState];

                self.navigationItem.rightBarButtonItem = self.editButtonItem;
                
                [self.view sendSubviewToBack:self.noGoodsTipView];
                self.selectAllButton.enabled = YES;
                self.title = [NSString stringWithFormat:@"采购车(%ld)", (long)self.cartList.totalGoodsAmount];
//                self.constraintToAdjust.constant = 0;
                self.bottomView.hidden = NO;
                self.bottomView.hidden = NO;
                
            } else {

                self.navigationItem.rightBarButtonItem = nil;

                [self.view bringSubviewToFront:self.noGoodsTipView];
                self.selectAllButton.enabled = NO;
                self.bottomView.hidden = YES;
                


//                 self.constraintToAdjust.constant = -50;
                
                self.title = @"采购车(0)";
            }
            [self.tableView reloadData];

        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询采购车信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

          
        }
        
        [self.refreshHeader endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        


        [self.refreshHeader endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)addEditButton {
    
    UIBarButtonItem *editItem = self.editButtonItem;
    editItem.tintColor = [UIColor colorWithRed:134.0/255 green:184.0/255 blue:9.0/255 alpha:1];
    self.navigationItem.rightBarButtonItem = editItem;
    
    
}

- (IBAction)selectAllButtonClicked:(id)sender {
  
//    UIButton *payBtn = (UIButton *)sender;
//    payBtn.userInteractionEnabled = NO;
    
    if ([self.selectAllButton isSelected]) {

        for (CartMerchant* merchantInfo in self.cartList.merchantList) {

            merchantInfo.selected = NO;

            for (CartGoods* goodsInfo in merchantInfo.goodsList) {
                goodsInfo.selected = NO;
            }

        }

        [self.selectAllButton setSelected:NO];
    } else {

        for (CartMerchant* merchantInfo in self.cartList.merchantList) {

            merchantInfo.selected = YES;

            for (CartGoods* goodsInfo in merchantInfo.goodsList) {
                goodsInfo.selected = YES;
            }

        }

        [self.selectAllButton setSelected:YES];
    }

    [self updateTotalPrice];

    [self updatePayButtonState];

    [self.tableView reloadData];
}

- (IBAction)settleButtonClicked:(id)sender {
    
    
    NSArray* selectedCartStatisticalList = [self.cartList selectedCartStatisticalListToCheckWholesaleCondition];
    if (selectedCartStatisticalList.count > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForSetCartWholeSaleCondition:selectedCartStatisticalList success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                WholeSaleConditionDTO* wholeSaleCondition = [[WholeSaleConditionDTO alloc]initWithDictionary:dic];
                if ([wholeSaleCondition isAllMerchantsSatisfy]) {
                    [self performSegueWithIdentifier:@"toOrderConfirm" sender:self];
                } else {
                    [self.cartList updateMerchantsInfoByWholeSaleCondition:wholeSaleCondition];

                    [self.tableView beginUpdates];
                    [self.tableView reloadSections:self.cartList.changedSectionsIndexSet withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            } else {
                [self.view makeMessage:[NSString stringWithFormat:@"查询全店批发校验条件失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

                           }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        }];
    } else {
        [self.view makeMessage:@"请选择需要购买的商品" duration:2.0f position:@"center"];

    }
}
//!去采购车挑选

- (IBAction)toChooseGoodsButtonClicked:(id)sender {
    

    // !保证在任何情况下 ，点击tabbar的商家 时显示的是商家列表
    NSArray* controllers = self.navigationController.viewControllers;
    
    // !tabbar 选中的是 商家（从商家列表进入的）
    if ([[controllers objectAtIndex:0] isKindOfClass:[MerchantListViewController class]]) {
        
        [self changeIndexAndPop:@"A"];
        
        
    }else if ([[controllers objectAtIndex:0] isKindOfClass:[AllGoodsViewController class]]){//!从商品列表进入的
    
        [self changeIndexAndPop:@"B"];

    }else if ([[controllers objectAtIndex:0] isKindOfClass:[CSPPersonCenterMainViewController class]] && self.fromPersonCenterShopCart){//!从个人中心 采购车进入
    
        [self changeIndexAndPop:@"B"];
    
    }else{//!从个人中心 补货商品列表进入
    
        [self changeIndexAndPop:@"A"];
    
    }
    

}
-(void)changeIndexAndPop:(NSString *)choice{

    if ([choice isEqualToString:@"A"]) {
        
        //!商家列表进入的 个人中心的补货商品列表进入的
        self.rdv_tabBarController.selectedIndex = 1;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        if (self.rdv_tabBarController.selectedIndex == 1) {
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }else{
            
            //!从商品列表、个人中心的采购车  进入的时候这么跳
            self.rdv_tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
    }

}

#pragma mark -
#pragma mark CSPCartSectionHeaderViewDelegate

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView selectionStatusChanged:(BOOL)isSelected {

    CartMerchant* merchantInfo = self.cartList.merchantList[sectionHeaderView.section];
    for (CartGoods* goodsInfo in merchantInfo.goodsList) {
        goodsInfo.selected = isSelected;
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionHeaderView.section] withRowAnimation:UITableViewRowAnimationNone];

    [self updateTotalSelectionButtonState];

    [self updateTotalPrice];

    [self updatePayButtonState];
}

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView startEnquiryWithMerchantInfo:(CartMerchant *)merchantInfo {

    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantInfo.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantInfo.merchantName jid:jid withMerchantNo:merchantInfo.merchantNo];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;


            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView showMerchantGoods:(NSString *)merchantNo {
    
    MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
    detailVC.merchantNo = merchantNo;
    [self.navigationController pushViewController:detailVC animated:YES];

    
//    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:merchantNo pageNo:@1 pageSize:@20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSDictionary* dataDict = [dic objectForKey:@"data"];
//
//            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
////            if (merchantListDTO.merchantList.count > 0) {
//                MerchantListDetailsDTO* merchantDetails = [merchantListDTO.merchantList firstObject];
//                
//                MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
//                detailVC.merchantNo = merchantNo;
//                [self.navigationController pushViewController:detailVC animated:YES];
//                
//                
////            } else {
////                [self.view makeMessage:[NSString stringWithFormat:@"查询商家信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
////
////                          }
//            
//        } else {
//            [self.view makeMessage:@"查询失败, 请联系服务器" duration:2.0f position:@"center"];
//
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
//        
//
//    }];
}

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView reloadSection:(NSInteger)section {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]) {
        self.cartGoodsOfSelectedToDelete = nil;
        self.indexPathOfSelectedToDelete = nil;
    } else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForCartDelete:self.cartGoodsOfSelectedToDelete.goodsNo cartType:self.cartGoodsOfSelectedToDelete.cartType success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                CartMerchant* merchantInfo = self.cartList.merchantList[self.indexPathOfSelectedToDelete.section];

                [merchantInfo.goodsList removeObject:self.cartGoodsOfSelectedToDelete];

                if (merchantInfo.goodsList.count == 0) {
                    [self.cartList.merchantList removeObject:merchantInfo];
                    
                }

                self.cartGoodsOfSelectedToDelete = nil;
                self.indexPathOfSelectedToDelete = nil;
                
                
                
                self.title = [NSString stringWithFormat:@"采购车(%ld)", (long)self.cartList.totalGoodsAmount];
                [self updateTotalPrice];
                if (self.cartList.totalGoodsAmount == 0) {
                    // 进入页面自动加载一次数据
                    [_refreshHeader beginRefreshing];
                    
                }else {
                    [self.tableView reloadData];
  
                }
            } else {
                
                [self.view makeMessage:[NSString stringWithFormat:@"删除采购车失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

                         }
            
            [self.tableView reloadData];

            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.cartGoodsOfSelectedToDelete = nil;
            self.indexPathOfSelectedToDelete = nil;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        }];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toOrderConfirm"]) {
        CSPConfirmOrderViewController* destViewController = (CSPConfirmOrderViewController*)segue.destinationViewController;
        //从采购车进入 设置为YES ,放弃支付时会POP到采购车中
        destViewController.isGoods = YES;
        
        //进行商品采购单号数据的传递
        destViewController.selectedGoods = self.cartList.selectedGoodsDictionaryList;
    }
}


- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    if (self.isBlockUp) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [self.rdv_tabBarController setSelectedIndex:self.rdv_tabBarController.lastSelectedIndex];
        
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (self.keyboardShown)
        return;
    
    NSDictionary* info = [aNotification userInfo];
    
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    self.constraintToAdjust.constant = keyboardSize.height - CGRectGetHeight(self.bottomView.frame);
    
    
    self.keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    
    self.constraintToAdjust.constant = 0;
    
    self.keyboardShown = NO;
}


@end
