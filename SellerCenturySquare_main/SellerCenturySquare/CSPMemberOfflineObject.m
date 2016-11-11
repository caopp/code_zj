//
//  CSPMemberOfflineObject.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMemberOfflineObject.h"
#import "CSPOnlineServiceTableViewCell.h"

@implementation CSPMemberOfflineObject

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPOnlineServiceTableViewCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOnlineServiceTableViewCell"];
    
    
    if (!onlineCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPOnlineServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPOnlineServiceTableViewCell"];
        
        onlineCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOnlineServiceTableViewCell"];
    }
    
    switch (indexPath.row) {
        case 0:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_每月免费上架20.png"];
            onlineCell.titleLabel.text = @"每月免费上架商品";
            onlineCell.detailLabel.text = @"平台免费拍摄、编辑、上传商品。";
            break;
        case 1:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_额外付费上架¥200.png"];
            onlineCell.titleLabel.text = @"额外付费上架商品";
            onlineCell.detailLabel.text = @"付费额外上架商品，等级越高越便宜。";
            break;
            
        default:
            break;
    }
    
    return onlineCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(offLineDidSelectAtRow:)]) {
        [self.delegate offLineDidSelectAtRow:indexPath];
    }
}
@end
