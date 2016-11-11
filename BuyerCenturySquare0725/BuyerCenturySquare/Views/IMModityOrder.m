//
//  IMModityOrder.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "IMModityOrder.h"
#import "DoubleSku.h"
#import "UIImageView+WebCache.h"
#import "IMMsgDBAccess.h"
#import "UIView+KeyboardObserver.h"
#import "KeyboardBar.h"
#define BTNTAG 800
#define TextFieldTag  900
@implementation IMModityOrder{
    float modelViewHeight;
}

//- (instancetype)initWithFrame:(CGRect)frame withCartDTO:(IMGoodsInfoDTO *)good {
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        [self addKeyboardObserver];
//        
//        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
//        _imGoodsInfoDTO = good;
//        [self createUI];
//        
//        UITapGestureRecognizer *licenseFinger = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchModeImageEvent)];
//        [self addGestureRecognizer:licenseFinger];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame withCartArrayDTO:(NSArray *)goodArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addKeyboardObserver];
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        _colorItemArray = goodArray;
        [self createUI];
        
        UITapGestureRecognizer *licenseFinger = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchModeImageEvent)];
        licenseFinger.delegate = self;
        [self addGestureRecognizer:licenseFinger];
    }
    return self;
}
-(void)createUI{
    //添加采购车按钮
    UIButton * addOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44)];
    [addOrderBtn setBackgroundColor:[UIColor blackColor]];
    [addOrderBtn.titleLabel setFont:[UIFont fontWithName:@"" size:13.0f]];
    [addOrderBtn setTitle:@"加入采购车" forState:UIControlStateNormal];
    [addOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addOrderBtn addTarget:self action:@selector(addOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addOrderBtn];
    
    modelViewHeight = 0;
    
    
    //是否购买样板
    bgBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - 50, self.frame.size.width, 50)];
    [bgBtnView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgBtnView.frame.size.width, 1)];
    [lineLabel setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
    [bgBtnView addSubview:lineLabel];
    
    checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 22, 22)];
    
    [bgBtnView addSubview:checkImage];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 14, 80, 22)];
    [nameLabel setText:@"购买样板"];
    [nameLabel setFont:[UIFont fontWithName:@"" size:16]];
    [bgBtnView addSubview:nameLabel];
    
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 14, self.frame.size.width - 142, 22)];
    [priceLabel setFont:[UIFont fontWithName:@"" size:16]];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    [bgBtnView addSubview:priceLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isBuyModelFuntion)];
    [bgBtnView addGestureRecognizer:tap];
    
    [self addSubview:bgBtnView];
    
    wholesale = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - modelViewHeight - 25, self.frame.size.width, 25)];
    wholesale.font = [UIFont systemFontOfSize:14];
    [wholesale setTextColor:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1]];
    wholesale.backgroundColor = [UIColor whiteColor];
    [self addSubview:wholesale];
    
    colorScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - modelViewHeight - 300, self.frame.size.width, 30)];
    colorScroll.backgroundColor = [UIColor whiteColor];
    [self addSubview:colorScroll];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    [colorScroll addSubview:line];
    colorScroll.pagingEnabled = YES;
    int i =0;
    for (IMGoodsInfoDTO *imGoodsInfo in _colorItemArray) {
        
        UIButton *btnColorItem = [[UIButton alloc] initWithFrame:CGRectMake(i*self.frame.size.width/4, 0, self.frame.size.width/4, 30)];
        [btnColorItem addTarget:self action:@selector(changeColorItem:)
               forControlEvents:UIControlEventTouchUpInside];
        btnColorItem.tag = BTNTAG +i;
        if (i == 0) {
            UIImage *img= [UIImage imageNamed:@"color_normal"];
            img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            btnColorItem.backgroundColor = [UIColor whiteColor];
            [btnColorItem setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
            [btnColorItem setBackgroundImage:img forState:UIControlStateNormal];
        }else{
            btnColorItem.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [btnColorItem setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            [btnColorItem setBackgroundImage:nil forState:UIControlStateNormal];
        }
        [btnColorItem setTitle:imGoodsInfo.goodColor forState:UIControlStateNormal];
        [colorScroll addSubview:btnColorItem];
        i++;
    }
    colorScroll.showsHorizontalScrollIndicator = NO;
    colorScroll.showsVerticalScrollIndicator = NO;
    colorScroll.contentSize = CGSizeMake((i+3)/4*SCREEN_WIDTH, 0);
    //修改采购单
    bgModityView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - modelViewHeight - 300 + 30-25, self.frame.size.width, 270-25)];
    [bgModityView setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel * num1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 14)];
    [num1 setText:@"现货数量"];
    [num1 setFont:[UIFont fontWithName:@"" size:12]];
    //[num1 setTextColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    num1.textColor = [UIColor blackColor];
    [bgModityView addSubview:num1];
    
    UILabel * num2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 80, 14)];
    [num2 setText:@"期货数量"];
    [num2 setFont:[UIFont fontWithName:@"" size:12]];
    //[num2 setTextColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    num2.textColor = [UIColor blackColor];
    [bgModityView addSubview:num2];
    _imGoodsInfoDTO = [_colorItemArray objectAtIndex:0];
    
    
 
    bgUnClickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgModityView.contentSize.width, bgModityView.contentSize.height)];
    [bgUnClickView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]];
    [bgModityView addSubview:bgUnClickView];
    

    
    [self addSubview:bgModityView];
    
    //采购单信息
    detailsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - modelViewHeight - 300 - 118, self.frame.size.width, 118)];
    [detailsView setBackgroundColor:[UIColor whiteColor]];
    
    //    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, detailsView.frame.size.height - 1, detailsView.frame.size.width,  1)];
    //    [lineLabel1 setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
    //    [detailsView addSubview:lineLabel1];
    
    picImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 88, 88)];
    picImage.backgroundColor = [UIColor lightGrayColor];

    [detailsView addSubview:picImage];
    
    priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 200, 35)];
    priceLabel1.font = [UIFont systemFontOfSize:20];
    //[priceLabel1 setFont:[UIFont fontWithName:@"" size:20]];
    [detailsView addSubview:priceLabel1];
    
   
    
    num = [[UILabel alloc] initWithFrame:CGRectMake(115, 83, 60, 18)];
    num.layer.cornerRadius = 4;
    num.layer.masksToBounds = YES;
    num.textAlignment = NSTextAlignmentCenter;
    num.font = [UIFont systemFontOfSize:12];
    //[num setFont:[UIFont fontWithName:@"" size:8]];
    //[num setTextColor:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1]];
    num.textColor = [UIColor whiteColor];
    num.backgroundColor = [UIColor blackColor];
    [detailsView addSubview:num];
    
    [self addSubview:detailsView];
    
    //hidden btn
    UIButton * hiddenBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 15, 20, 20)];
    [hiddenBtn setImage:[UIImage imageNamed:@"10_设置_修改登录密码_清除"] forState:UIControlStateNormal];
    [hiddenBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [detailsView addSubview:hiddenBtn];
    
    [self loadData:_imGoodsInfoDTO];

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == bgModityView||touch.view==detailsView) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

//加载数据
- (void)loadData:(IMGoodsInfoDTO *)goodsInfoDTO {
    CGRect rectBg = bgBtnView.frame;
    CGRect rectColor = colorScroll.frame;
    CGRect rectModity = bgModityView.frame;
    CGRect rectDetails = detailsView.frame;
    if (goodsInfoDTO.sampleSkuNo !=nil) {
        bgBtnView.hidden = NO;modelViewHeight = 50;
        

        
        if(goodsInfoDTO.isBuyModel) {
            [bgUnClickView setHidden:NO];
            [checkImage setImage:[UIImage imageNamed:@"setting_changePwd_select"]];
        }else {
            [bgUnClickView setHidden:YES];
            [checkImage setImage:[UIImage imageNamed:@"setting_changePwd_unselect"]];
        }
        
        [priceLabel setText:[NSString stringWithFormat:@"样板价：￥%.2f", [goodsInfoDTO.samplePrice floatValue]]];
    }else{
        [bgUnClickView setHidden:YES];
        bgBtnView.hidden = YES;
        modelViewHeight = 0;
    }
    [picImage sd_setImageWithURL:[NSURL URLWithString:goodsInfoDTO.goodPic]];
    [priceLabel1 setText:[NSString stringWithFormat:@"￥%.2f", [goodsInfoDTO.price doubleValue]]];
    wholesale.text = [NSString stringWithFormat:@"   %@起批量：%@件",goodsInfoDTO.goodColor,goodsInfoDTO.batchNumLimit];
     //[wholesale setText:[NSString stringWithFormat:@"%d件起批", [goodsInfoDTO.batchNumLimit intValue]]];
    // [num setText:[NSString stringWithFormat:@"货号：%@", goodsInfoDTO.goodsWillNo]];
    wholesale.frame =   CGRectMake(0, self.frame.size.height - 44 - modelViewHeight - 25, self.frame.size.width, 25);
    [num setText:[NSString stringWithFormat:@"V%@会员价",goodsInfoDTO.shopLevel]];
    rectColor.origin.y  = self.frame.size.height - 44 - modelViewHeight - 300;
    colorScroll.frame = rectColor;
    
    rectModity.origin.y = self.frame.size.height - 44 - modelViewHeight - 300 + 30;
    
    bgModityView.frame = rectModity;
    
    
    rectDetails.origin.y = self.frame.size.height - 44 - modelViewHeight - 300 - 118;
    detailsView.frame = rectDetails;

   [self createSku:_imGoodsInfoDTO];
    
}

-(void)createSku:(IMGoodsInfoDTO *)goodsInfoDTO{
    for (UIView *view in bgModityView.subviews) {
        if ([view isKindOfClass:[CSPSkuControlView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < goodsInfoDTO.skuList.count; i++) {
        
        DoubleSku * sku = [goodsInfoDTO.skuList objectAtIndex:i];
        CSPSkuControlView * skuView = [[CSPSkuControlView alloc] initWithFrame:CGRectMake(15, 34 + 53 * i, 200, 35)];
        skuView.tag =  TextFieldTag + i;
        skuView.style = CSPSkuControlViewStyleDoubleCounter;
        skuView.title = sku.skuName;
        skuView.skuValue = sku;
        skuView.delegate = self;
        [bgModityView addSubview:skuView];
    }
      [bgModityView setContentSize:CGSizeMake(self.frame.size.width, 100 + 53 * (goodsInfoDTO.skuList.count - 1))];
       bgUnClickView.frame = CGRectMake(0, 0, bgModityView.contentSize.width, bgModityView.contentSize.height);
    [bgModityView bringSubviewToFront:bgUnClickView];
}
#pragma mark -
#pragma mark CSPSkuControlViewDelegate

- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue {
    
    NSInteger totalCount = 0;
    
    for (DoubleSku* sku in self.imGoodsInfoDTO.skuList) {
        totalCount += sku.futureValue;
        totalCount += sku.spotValue;
    }
    
    [priceLabel1 setText:[NSString stringWithFormat:@"￥%.2f", [[self.imGoodsInfoDTO stepPriceForCurrentQuantity] doubleValue]]];
}

//- (BOOL)skuControlView:(CSPSkuControlView *)skuControlView couldSkuValueChanged:(NSInteger)tagetValue {
//    
//    NSInteger limitedValue = self.imGoodsInfoDTO.batchNumLimit - [self.imGoodsInfoDTO totalQuantityExceptSku:(ReplenishmentSku*)skuControlView.skuValue];
//    if (limitedValue <= tagetValue){
//        return YES;
//    } else {
//        return NO;
//    }
//}


//加入采购车点击事件
- (void)addOrderBtnClick:(UIButton *)sender {
    NSMutableArray *arrOrder =[[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *arrUnOrder =[[NSMutableArray alloc] initWithCapacity:0];
    for (IMGoodsInfoDTO *goodsDTO in _colorItemArray) {
        if ([goodsDTO gettotalQuantity]>0||goodsDTO.isBuyModel)  {
            if (goodsDTO.isBuyModel||[goodsDTO gettotalQuantity] >= [goodsDTO.batchNumLimit integerValue]) {
                 [arrOrder addObject:goodsDTO];
            }else{
                [arrUnOrder addObject:goodsDTO];
            }
           
        }
     
    }
    
    if (arrUnOrder.count==0&&arrOrder.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请添加商品数量";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;

    }
    
   else if(arrUnOrder.count==0&&arrOrder.count >0){
        [self IMmodityOrderHidden];
        [self.delegate addBuyCar:arrOrder];
//       
    }else {
        
        [self.delegate addUnBuyCar:arrUnOrder];
       
        
//        [MBProgressHUD hideHUDForView:self animated:YES];
//        //只显示文字
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"未达到起批数量";
//        hud.margin = 10.f;
//        hud.yOffset = 150.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:2];
    
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex == 1) {
//        
//        if(_imGoodsInfoDTO.isBuyModel) {
//            
//            [MBProgressHUD showHUDAddedTo:self animated:YES];
//            
//            [HttpManager sendHttpRequestForCartAdd:[_imGoodsInfoDTO transformToModelCartAddDTO] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:addCartNotification object:nil];
//                
//                [MBProgressHUD hideHUDForView:self animated:YES];
//                
//                [self IMmodityOrderHidden];
//                [self.delegate showCarAlertView:_imGoodsInfoDTO];
//                //只显示文字
////                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
////                hud.mode = MBProgressHUDModeText;
////                hud.labelText = @"加入采购车成功";
////                hud.margin = 10.f;
////                hud.yOffset = 150.f;
////                hud.removeFromSuperViewOnHide = YES;
////                [hud hide:YES afterDelay:2];
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [MBProgressHUD hideHUDForView:self animated:YES];
//                //只显示文字
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"加入采购车失败";
//                hud.margin = 10.f;
//                hud.yOffset = 150.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }];
//            
//        }else {
//            
//            if ([_imGoodsInfoDTO gettotalQuantity] < [_imGoodsInfoDTO.batchNumLimit integerValue]) {
//                
//                [MBProgressHUD hideHUDForView:self animated:YES];
//                //只显示文字
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"未达到起批数量";
//                hud.margin = 10.f;
//                hud.yOffset = 150.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//                return;
//            }
//            
//            [MBProgressHUD showHUDAddedTo:self animated:YES];
//            
//            [HttpManager sendHttpRequestForCartAdd:[_imGoodsInfoDTO transformToCartAddDTO] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:addCartNotification object:nil];
//                [self IMmodityOrderHidden];
//                [self.delegate showCarAlertView:_imGoodsInfoDTO];
////                [MBProgressHUD hideHUDForView:self animated:YES];
////                //只显示文字
////                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
////                hud.mode = MBProgressHUDModeText;
////                hud.labelText = @"加入采购车成功";
////                hud.margin = 10.f;
////                hud.yOffset = 150.f;
////                hud.removeFromSuperViewOnHide = YES;
////                [hud hide:YES afterDelay:2];
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [MBProgressHUD hideHUDForView:self animated:YES];
//                //只显示文字
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"加入采购车失败";
//                hud.margin = 10.f;
//                hud.yOffset = 150.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }];
//        }
//        
//        [[IMMsgDBAccess sharedInstance] updateIMGoodsInfoDTO:_imGoodsInfoDTO];
//    }
//}

//是否购买样板
- (void)isBuyModelFuntion {
    
    if (_imGoodsInfoDTO.isBuyModel) {
        [checkImage setImage:[UIImage imageNamed:@"setting_changePwd_unselect"]];
        _imGoodsInfoDTO.isBuyModel = NO;
        [bgUnClickView setHidden:YES];
    }else {
        [checkImage setImage:[UIImage imageNamed:@"setting_changePwd_select"]];
        _imGoodsInfoDTO.isBuyModel = YES;
        [bgUnClickView setHidden:NO];
    }
}
- (void)changeColorItem:(UIButton *)sender{
    _imGoodsInfoDTO = [_colorItemArray objectAtIndex:sender.tag - BTNTAG];
    [self loadData:_imGoodsInfoDTO];
    for (int i = 0; i <_colorItemArray.count; i++) {
        UIButton *btnColorItem = (UIButton *)[self viewWithTag:BTNTAG + i];
        if ((i+BTNTAG) == sender.tag) {
            UIImage *img= [UIImage imageNamed:@"color_normal"];
            img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            btnColorItem.backgroundColor = [UIColor whiteColor];
            [btnColorItem setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
            [btnColorItem setBackgroundImage:img forState:UIControlStateNormal];
        }else{
            btnColorItem.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [btnColorItem setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            [btnColorItem setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}
//取消按钮
- (void)cancelBtn:(UIButton *)sender {
    
    [[IMMsgDBAccess sharedInstance] updateIMGoodsInfoDTO:_imGoodsInfoDTO];
    [self IMmodityOrderHidden];
}

- (void)IMmodityOrderShow {

    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:1];
    
    // set views with new info
    self.hidden = NO;
    
    // commit animations
    [UIView commitAnimations];
}
-(void)touchModeImageEvent{
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:1];
    
    // set views with new info
    self.hidden = YES;
    
    // commit animations
    [UIView commitAnimations];
}
- (void)IMmodityOrderHidden {
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:1];
    
    // set views with new info
    self.hidden = YES;
    
    // commit animations
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect containerFrame = self.originRectOfSelf;
    if([self isKindOfClass:[UIScrollView class]]){
        containerFrame.size.height -= self.keyboardViewRect.size.height;
    }else{
        
        float h =
        SCREEN_HEIGHT - 44 - modelViewHeight - 270 +(34 + 53 * _imGoodsInfoDTO.skuList.count)-40;
        
        NSLog(@"%f---%f---%f",h,keyboardBounds.origin.y ,containerFrame.origin.y );
        if (containerFrame.origin.y<(h-keyboardBounds.origin.y)-colorScroll.frame.origin.y) {
            containerFrame.origin.y = -colorScroll.frame.origin.y;
        }else{
            containerFrame.origin.y -= (h-keyboardBounds.origin.y)-40;

        }
    }
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
 
    
    // set views with new info

    self.frame =containerFrame;
    // commit animations
    [UIView commitAnimations];
}

//- (void)keyboardWillHide:(NSNotification *)notification {
//    
//    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    // set views with new info
//    self.frame = self.originRectOfSelf;
//    
//    // commit animations
//    [UIView commitAnimations];
//    
//    self.isKeyboardShow = NO;
//    self.translatesAutoresizingMaskIntoConstraints = NO;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
