//
//  UnavailableWebView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "UnavailableWebView.h"

@implementation UnavailableWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _alertWebView = [[UIWebView alloc] initWithFrame:frame];
        [self addSubview:_alertWebView];
    }
    return self;
}
-(void)setHtmlStr:(NSString *)htmlStr{
    [_alertWebView loadHTMLString:htmlStr baseURL:nil];
}
@end
