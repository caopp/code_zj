//
//  InviteSettingLevelTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteSettingLevelTableViewCell.h"
#import "InviteContactInfoDTO.h"

@implementation InviteSettingLevelTableViewCell

- (void)awakeFromNib {
    // Initialization code

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)levelButtonClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    for (int i = 0;i<6;i++) {
        
        UIButton *tmpBtn =(UIButton *)[self viewWithTag:i+1];
        
        if (tmpBtn.tag==btn.tag) {
            
            tmpBtn.selected = YES;
            
            _inviteContactInfoDTO.shopLevel = i+1;
            
        }else{
            
            tmpBtn.selected = NO;
        }
    }
    
    
}


- (IBAction)selectedButtonClicked:(id)sender {
    
    _selectedButton.selected = !_selectedButton.selected;
    
    _inviteContactInfoDTO.isSelected = _selectedButton.selected;
}

- (void)setInviteContactInfoDTO:(InviteContactInfoDTO *)inviteContactInfoDTO{
    
    _inviteContactInfoDTO = inviteContactInfoDTO;
    
    _nameL.text = inviteContactInfoDTO.name;
    
    _onlyNameL.text = inviteContactInfoDTO.name;
    
    
    if ([inviteContactInfoDTO.name isEqualToString:@""] || !inviteContactInfoDTO.name || [inviteContactInfoDTO.name isEqualToString:@"(null)"] || [inviteContactInfoDTO.name isKindOfClass:[NSNull class]]) {
        

        _nameL.text = inviteContactInfoDTO.phoneNum;

        _onlyNameL.text = inviteContactInfoDTO.phoneNum;


    }
    
    for (int i = 0;i<6;i++) {
        
        UIButton *tmpBtn =(UIButton *)[self viewWithTag:i+1];
        
        if (tmpBtn.tag==inviteContactInfoDTO.shopLevel) {
            
            tmpBtn.selected = YES;
            
        }else{
            
            tmpBtn.selected = NO;
        }
    }
    
    _selectedButton.selected = inviteContactInfoDTO.isSelected;
}

- (void)setAuthState:(BOOL)hasAuth{
    
    _onlyNameL.hidden = hasAuth;
    _selectedButton.hidden = !hasAuth;
    _nameL.hidden = !hasAuth;
    
    _level1Button.enabled = hasAuth;
    _level2Button.enabled = hasAuth;
    _level4Button.enabled = hasAuth;
    _level5Button.enabled = hasAuth;
    _level6Button.enabled = hasAuth;
}

@end
