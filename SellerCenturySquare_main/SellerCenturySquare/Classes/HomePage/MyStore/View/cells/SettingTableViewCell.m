//
//  SettingTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "Marco.h"
#import "MyShopStateDTO.h"
@implementation SettingTableViewCell
{
    BOOL isEdited;
}


- (void)awakeFromNib {
    // Initialization code
    MyShopStateDTO *myShopStateDTO = [MyShopStateDTO sharedInstance];
    
    isEdited = myShopStateDTO.editedState;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateButtonOnEditedState:(BOOL)edited{
    
    if (edited) {
        
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        
        [self.editButton setTitle:@"完成" forState:UIControlStateHighlighted];
        
        
    }else{
        
        [self.editButton setTitle:@"修改" forState:UIControlStateNormal];
        
        [self.editButton setTitle:@"修改" forState:UIControlStateHighlighted];
        
    }
 
    
}


- (IBAction)buttonClicked:(id)sender {
    
    NSLog(@"isEdited === %d",isEdited);
    
    //进行判断（判断选中状态）
    isEdited = !isEdited;
    
    NSString *state = isEdited?@"1":@"0";
    
    //更改状态但tableView未reloadData
    [self updateButtonOnEditedState:isEdited];
    
    NSDictionary *infoDic = [[NSDictionary alloc]initWithObjectsAndKeys:state,@"editedState", nil];
    
    // !修改混批条件
    [[NSNotificationCenter defaultCenter]postNotificationName:kMyShopEditStateChangedNotification object:nil userInfo:infoDic];

}

@end
