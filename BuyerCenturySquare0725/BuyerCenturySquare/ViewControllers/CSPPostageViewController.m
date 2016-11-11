//
//  CSPPostageViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/20/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPostageViewController.h"
#import "CSPAmountControlView.h"
#import "BadgeImageView.h"
#import "GetGoodsFeeInfoDTO.h"
#import "SkuListDTO.h"
#import "UIImageView+WebCache.h"
#import "CartListDTO.h"
#import "SingleSku.h"
#import "SkuDTO.h"
#import "CSPShoppingCartViewController.h"


@interface CSPPostageViewController ()<CSPSkuControlViewDelegate>
{
   
    GetGoodsFeeInfoDTO *getGoodsFeeInfoDTO;
    SkuListDTO *skuListDTO;
    NSInteger totalCount;
}
@property (strong, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet CSPSkuControlView *acountView;
@property (weak, nonatomic) IBOutlet BadgeImageView *shopCartImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopCartLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
- (IBAction)addCartButtonClicked:(id)sender;
@end

@implementation CSPPostageViewController
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    totalCount = 10;
    self.title = @"补差价";
    [self addCustombackButtonItem];
    self.acountView.delegate = self;
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopCartImageViewTaped:)];
    [self.toolView addGestureRecognizer:tap];
    
    self.toolView.userInteractionEnabled = YES;
    
    
    NSString *merchantNo = self.merchantNo;
    
    [HttpManager sendHttpRequestForGetGoodsFeeInfo:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getGoodsFeeInfoDTO = [[GetGoodsFeeInfoDTO alloc] init];
                [getGoodsFeeInfoDTO setDictFrom:[dic objectForKey:@"data"]];

                [self.titleImageVIew sd_setImageWithURL:[NSURL URLWithString:getGoodsFeeInfoDTO.detailUrl]];
                
                self.titleLabel.text = getGoodsFeeInfoDTO.goodsName;
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[CSPUtils stringFromNumber:getGoodsFeeInfoDTO.price]];
                
                //skuList
                skuListDTO = [[SkuListDTO alloc] init];
                long skuListCount = [getGoodsFeeInfoDTO.skuList count];
                NSLog(@"The skuListCount is %ld\n",skuListCount);
                
                for( int index =0; index <skuListCount; index ++){
                    NSDictionary *Dictionary = [getGoodsFeeInfoDTO.skuList objectAtIndex:index];
                    [skuListDTO setDictFrom:Dictionary];
                    
                    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:skuListDTO.skuNo, @"skuNo",skuListDTO.skuName,@"skuName",skuListDTO.sort,@"sort", nil];
                    
                    SingleSku *basicSku = [[SingleSku alloc]initWithDictionary:dic];
                    basicSku.value = basicSku.value==0?10:basicSku.value;
                    self.acountView.skuValue = basicSku;
                    
                }
                
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];
    
    
    [HttpManager sendHttpRequestForCartListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            CartListDTO *cartList = [[CartListDTO alloc]initWithDictionary:dic];

            self.shopCartImageView.badgeNumber = [NSString stringWithFormat:@"%ld",[cartList totalGoodsAmount]];
            
        } else {
            
            [self.view makeMessage:@"查询失败,请联系服务器" duration:2.0f position:@"center"];

        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        

    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated{
//
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//    
//    [super viewWillDisappear:animated];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addCartButtonClicked:(id)sender {
    
    
    
    CartAddDTO * cartAdd = [[CartAddDTO alloc] init];
    cartAdd.merchantNo = self.merchantNo;
//    cartAdd.merchantNo =@"SP00000054";
    cartAdd.goodsNo = getGoodsFeeInfoDTO.goodsNo;
    
    cartAdd.cartType = @"2";

    cartAdd.price = getGoodsFeeInfoDTO.price;

    if(totalCount<1){

        [self.view makeMessage:@"请添加数量" duration:2.0f position:@"center"];
        
        return;
    }
    
    cartAdd.totalQuantity = [NSNumber numberWithInteger:totalCount];

    SkuDTO* skuDTO = [[SkuDTO alloc] init];
    skuDTO.skuNo = skuListDTO.skuNo;
    skuDTO.skuName = skuListDTO.skuName;
    skuDTO.spotQuantity = [[NSNumber alloc] initWithInteger:totalCount];
    skuDTO.futureQuantity = [[NSNumber alloc] initWithInteger:0];
    
    
    NSDictionary *currentDictionary = [skuDTO getDictFrom:skuDTO];
    [cartAdd.skuDTOList addObject:currentDictionary];
//
//    NSMutableArray *skulist = [[NSMutableArray alloc]initWithObjects:skuListDTO, nil];
//    
//    cartAdd.skuDTOList = skulist;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForCartAdd:cartAdd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:addCartNotification object:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //只显示文字
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加入采购车成功";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
        
        [HttpManager sendHttpRequestForCartListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                CartListDTO *cartList = [[CartListDTO alloc]initWithDictionary:dic];
                
                self.shopCartImageView.badgeNumber = [NSString stringWithFormat:@"%ld",[cartList totalGoodsAmount]];
                
            } else {
                
                [self.view makeMessage:@"查询失败,请联系服务器" duration:2.0f position:@"center"];

            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
            
            
        }];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //只显示文字
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加入采购车失败";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }];
    
}

#pragma mark--
#pragma CSPSkuControlViewDelegate
- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue
{
    SingleSku *single = (SingleSku *)skuValue;
    totalCount = single.value;
}


-(void)shopCartImageViewTaped:(UITapGestureRecognizer *)gesture{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    thirdViewController.isBlockUp = YES;
    [self.navigationController pushViewController:thirdViewController animated:YES];
//    if (self.rdv_tabBarController.selectedIndex == 3) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } else {
//        [self.rdv_tabBarController setSelectedIndex:3];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
}

//键盘的弹出方法
- (void) keyboardWillShow:(NSNotification *) notification
{
    
    
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    
    
    
    //    NSDictionary *info = [notification userInfo];
    //    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    //    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - keyboardBounds.size.height/2;
    self.view.frame = frame;
    
   
    
    
    [UIView commitAnimations];
    
    
    //    NSLog(@"keyBoard:%f", keyboardSize.height);//216
    ///keyboardWasShown = YES;
}
- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    self.view.frame = frame;
    
    
}

@end
