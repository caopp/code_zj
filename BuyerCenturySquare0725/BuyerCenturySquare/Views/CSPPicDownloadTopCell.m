//
//  CSPPicDownloadTopCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 9/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPicDownloadTopCell.h"

@implementation CSPPicDownloadTopCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.title = [[UILabel alloc]init];
        self.title.textColor = HEX_COLOR(0x999999FF);
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.title];
        
        self.allStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allStartButton setTitleColor:HEX_COLOR(0x999999FF) forState:UIControlStateNormal];
        self.allStartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.allStartButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.allStartButton.hidden = YES;
        [self addSubview:self.allStartButton];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setTitleColor:HEX_COLOR(0x000000FF) forState:UIControlStateNormal];
        self.editButton.titleLabel.textAlignment = NSTextAlignmentRight;
        self.editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.editButton];
        
        
    }
    return  self;
    
}

@end
