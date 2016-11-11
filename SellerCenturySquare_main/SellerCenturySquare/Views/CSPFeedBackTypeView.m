//
//  CSPFeedBackTypeView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPFeedBackTypeView.h"
#import "CSPFeedBackTypeCell.h"

@implementation CSPFeedBackTypeView

- (void)awakeFromNib{
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //倒角
    self.contentView.layer.cornerRadius = 7;
    
    self.feedBackTableView.delegate = self;
    
    self.feedBackTableView.dataSource = self;
    
}

- (IBAction)removeView:(id)sender {
    
    [self removeFromSuperview];
}

- (void)reloadUI{
    
    
    self.contentViewHight.constant = 30+60+self.feedBackTypeArray.count *40;
    [self.feedBackTableView reloadData];
    
    
}

- (IBAction)confirmButtonClick:(id)sender {
    
    self.confirmBlock(self.feedBackType);
    
    [self removeFromSuperview];
}

#pragma mark-
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.feedBackTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPFeedBackTypeCell *feedBackTypeCell;
    
    feedBackTypeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPFeedBackTypeCellID0"];
    
    if (!feedBackTypeCell) {
        
        feedBackTypeCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPFeedBackTypeCell" owner:self options:nil]firstObject];
    }
    
    CSPFeedBackTypeDTO *feedBackTypeDto = [self.feedBackTypeArray objectAtIndex:indexPath.row];
    
    feedBackTypeCell.feedBackTypeLabel.text = feedBackTypeDto.typeName;

    
    if ([self.feedBackType.typeName isEqualToString:feedBackTypeDto.typeName]) {
        
        feedBackTypeCell.selectedImageView.image = [UIImage imageNamed:@"10_设置_设收货地址_选中状态.png"];

    }else{
        feedBackTypeCell.selectedImageView.image = [UIImage imageNamed:@"10_设置_设收货地址_未选中状态.png"];

    }
    
    return feedBackTypeCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    CSPFeedBackTypeDTO *feedBackTypeDto = [self.feedBackTypeArray objectAtIndex:indexPath.row];
    
    self.feedBackType = feedBackTypeDto;
    
    [tableView reloadData];
}


@end
