//
//  ContactsTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ContactsTableViewCell.h"


@implementation ContactsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectChanged:(id)sender {
    
    if (_recommendSelectedInfo) {
        //推荐联系人
        _selectButton.selected = !_selectButton.selected;
        
        if (_selectButton.selected) {
            
            [_recommendSelectedInfo setObject:_recommendReceiverDTO forKey:_recommendReceiverDTO.memberNo];
            
        }else{
            
            [_recommendSelectedInfo removeObjectForKey:_recommendReceiverDTO.memberNo];
        }
        
    }else{
        
        //邀请联系人
        _selectButton.selected = !_selectButton.selected;
        
        NSDictionary *dic ;
        
        if (_selectButton.selected) {// !选中
            
            dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"Num",[NSString stringWithFormat:@"%zi",_row],@"Row",[NSString stringWithFormat:@"%zi",_section],@"Section",nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kContactsSelectChangedNotification object:nil userInfo:dic];
            
            
        }else{// !未选中
            
            dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"-1",@"Num",[NSString stringWithFormat:@"%zi",_row],@"Row",[NSString stringWithFormat:@"%zi",_section],@"Section",nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kContactsSelectChangedNotification object:nil userInfo:dic];
            
        }

    }

}

- (void)setButtonSelected:(BOOL)selected{
    
    _selectButton.selected = selected;
}

- (void)setRecommendReceiverDTO:(RecommendReceiverDTO *)recommendReceiverDTO{
    
    _recommendReceiverDTO = recommendReceiverDTO;
    _nameL.text = [NSString stringWithFormat:@"%@  V%@",recommendReceiverDTO.memberName,recommendReceiverDTO.memberLevel];
    
}


@end
