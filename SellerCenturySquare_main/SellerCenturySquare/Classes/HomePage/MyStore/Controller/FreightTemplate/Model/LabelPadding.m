//
//  LabelPadding.m
//  button自适应高度
//
//  Created by 张晓旭 on 16/4/16.
//  Copyright © 2016年 张晓旭. All rights reserved.
//

#import "LabelPadding.h"

@implementation LabelPadding
@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end
