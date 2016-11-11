//
//  CSPMemberLevelObject.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMemberLevelObject.h"
#import "CSPLevelJudgmentTableViewCell.h"
#import "CSPLevelDetailTableViewCell.h"

@implementation CSPMemberLevelObject






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPLevelJudgmentTableViewCell *levelJudgmentCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLevelJudgmentTableViewCell"];
    
    CSPLevelDetailTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLevelDetailTableViewCell"];
    
    if (!levelJudgmentCell)
    {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPLevelJudgmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPLevelJudgmentTableViewCell"];
        
        levelJudgmentCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLevelJudgmentTableViewCell"];
    }
    
    if (!otherCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPLevelDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPLevelDetailTableViewCell"];
        
        otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLevelDetailTableViewCell"];
    }
    
    
    if (indexPath.row == 0) {
        return levelJudgmentCell;
    }
    else if (indexPath.row == 1){
        otherCell.titleLabel.text = @"如何评定级别？";
        otherCell.detailLbale.text = @"次月1日核算上一个月的\"营业额积分\"达标即可维持对应的等级。";
        return otherCell;
    }else{
        otherCell.titleLabel.text = @"什么是营业额积分？";
        otherCell.detailLbale.text = @"采购单的\"实付金额\"将自动转为营业额积分，0.01元=0.01积分。";
        return otherCell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 313;
    }else
    {
        return 92;
    }

}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////    if (section == 0) {
////        return 0;
////    }else
////    {
////        return 10;
////    }
////}
//    return 1;
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


@end
