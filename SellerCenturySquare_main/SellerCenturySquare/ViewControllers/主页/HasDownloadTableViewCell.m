//
//  HasDownloadTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "HasDownloadTableViewCell.h"

@implementation HasDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateOnEditState:(BOOL)editState{
    
    if (editState) {
        
        [_windowDownloadAgainButton setHidden:YES];
        [_objectiveDownloadAgainButton setHidden:YES];
        [_objectiveClearButton setHidden:YES];
        [_windowClearButton setHidden:YES];
        
        [_windowSelectButton setHidden:NO];
        [_objectiveSelectButton setHidden:NO];
        
    }else{
        
        [_windowDownloadAgainButton setHidden:NO];
        [_objectiveDownloadAgainButton setHidden:NO];
        [_objectiveClearButton setHidden:NO];
        [_windowClearButton setHidden:NO];
        
        [_windowSelectButton setHidden:YES];
        [_objectiveSelectButton setHidden:YES];
    }
}

- (IBAction)windowSelectButtonClicked:(id)sender {
    
    _windowSelectButton.selected = !_windowSelectButton.selected;
    
}

- (IBAction)objectiveSelectButtonClicked:(id)sender {
 
    _objectiveSelectButton.selected = !_objectiveSelectButton.selected;
    
}

- (void)hideWindowPics:(BOOL)hide{
    
    if (hide) {
        
        [_windowHideView setHidden:NO];
    }else{
        
        [_objectiveHideView setHidden:YES];
    }
    
}

- (void)hideObjectivePics:(BOOL)hide{
    
    if (hide) {
        
        [_objectiveHideView setHidden:NO];
    }else{
        
        [_objectiveHideView setHidden:YES];
    }
}

- (void)allSelectedState:(BOOL)allSelected{
    
    if (allSelected) {
        
        _objectiveSelectButton.selected = YES;
        _windowSelectButton.selected = YES;
    }else{
        
        _objectiveSelectButton.selected = NO;
        _windowSelectButton.selected = NO;
        
    }
}


@end
