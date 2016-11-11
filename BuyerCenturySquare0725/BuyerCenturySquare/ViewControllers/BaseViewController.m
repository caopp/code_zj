//
//  BaseViewController.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomBarButtonItem.h"

//
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"



/**
 *  父类，其他的控制器继承父类（可以借鉴，相当不错）
 */

@interface BaseViewController ()<NJKWebViewProgressDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    
    [self.view addSubview:self.progressHUD];
    

    
}

//!点击空白收起键盘的事件
-(void)addTapHideKeyBoard{

    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideTap];

}
-(void)hideKeyBoard{

    [self.view endEditing:YES];

}


/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
//    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//数组中图片的样式
- (NSArray *)siftImagesFromImageList:(NSArray *)imageList withType:(CSPImageListType)type{
    
    if (imageList==nil) {
        return nil;
    }
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tmpDic in imageList) {
        
        NSString *picType = tmpDic[@"picType"];
        if ([picType integerValue]==type) {
            
            [resultArr addObject:tmpDic];
        }
    }
    
    NSLog(@"siftImagesFromImageList:%@",resultArr);
    return resultArr;
}




- (CGFloat )getWidthWithString:(NSString *)string font:(UIFont*)font{
    
    CGSize sizeName = [string sizeWithFont:font
                         constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    return sizeName.width;
}


//
- (UIBarButtonItem *)barButtonWithtTitle:(NSString *)title font:(UIFont*)font{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [self getWidthWithString:title font:font];
    
    rightButton.frame = CGRectMake(0, 0, width, 44);
    
    rightButton.titleLabel.font = font;
    
    [rightButton setTitleColor:HEX_COLOR(0x999999FF) forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}




- (void)rightButtonClick:(UIButton *)sender{
    
}

//菊花显示（样式、信息提示赋值）
- (void)progressHUDShowWithString:(NSString *)string{
    
    [self.progressHUD show:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.progressHUD.labelText = string;
}
//菊花隐藏（样式、两秒之内消失、信息提示赋值）
- (void)progressHUDHiddenWidthString:(NSString *)string{
    
    self.progressHUD.mode = MBProgressHUDModeText;
    
    self.progressHUD.labelText = string;
    
    [self.progressHUD hide:YES afterDelay:2];
}

- (NSDictionary *)conversionWithData:(NSData *)data{
    
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (void)progressHUDHiddenTipSuccessWithString:(NSString *)string{
    
    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    self.progressHUD.labelText = string;
    
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    [self.progressHUD hide:YES afterDelay:2];
}


- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

//简单一个判断对与请求数据（主要请求返回code值判断）
- (BOOL)isRequestSuccessWithCode:(NSString*)code{
    
    if ([code isEqualToString:@"000"]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (BOOL)checkData:(id)data class:(Class)class{
    
    if (data && [data isKindOfClass:class]){
        return YES;
    }else{
        return NO;
    }
}


#pragma mark ----简单的一个提示框显示（公共用）------

- (void)alertWithAlertTip:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
}
- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}




-(void)setExtraCellLineHidden: (UITableView *)tableView{

    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}



- (NSString *)transformationData:(id)data{
    
    if ([data isKindOfClass:[NSString class]]) {
        
        return data;
        
    }else if ([data isKindOfClass:[NSNumber class]]){
        
        NSNumber *number = (NSNumber *)data;
        
        return number.stringValue;
    }else{
        return @"";
    }
    
}

/**
 *  简单的动画效果的实现（公共类，方便大家调用）
 *
 *  @param rect 设置了动画进行时间
 */
- (void)animationForContentView:(CGRect)rect{
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"contentViewResizeAnimation" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



@end
