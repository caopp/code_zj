//
//  AboutView.m
//  BuyerCenter
//
//  Created by 左键视觉 on 15/10/23.
//  Copyright © 2015年 左键视觉. All rights reserved.
//

#import "AboutsView.h"

@implementation AboutsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // !设置控件属性
    [self setView];


    // !语言国际化
    [self international];
    
    
    // !4s上面
    if ([UIScreen mainScreen].bounds.size.height  <=480) {
        
        self.iconTop.constant = 5;
        
    }
    
    
    
}

// !语言国际化
- (void)international{

    
    self.appNamLabel.text = NSLocalizedString(@"appName", @"叮咚欧品");
    
    self.descLabel.text = NSLocalizedString(@"appDesc", @"app的描述");

    
    
    
}


// !设置控件属性
- (void)setView{
    
    
    //图标
    self.aboutImageView.layer.masksToBounds = YES;
    self.aboutImageView.layer.cornerRadius =10;
    
    
    // !版本号
    // 内容
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVerionCode = [NSBundle mainBundle].infoDictionary[key];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",currentVerionCode];
    // 颜色
    [self.versionLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    
    //描述
    [self.descLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];



    
    
}

// !服务规则
- (IBAction)serviceRuleBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(serviceBtnClick)]) {
        
        [self.delegate performSelector:@selector(serviceBtnClick)];
        
    }
    
    
    
}
// !观看引导页
- (IBAction)guideBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(guideBtnClick)]) {
        
        [self.delegate performSelector:@selector(guideBtnClick)];
        
    }
    
    
}

@end
