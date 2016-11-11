//
//  EditorTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EditorTableViewCell.h"
#import "UIColor+UIColor.h"

@implementation EditorTableViewCell

- (void)awakeFromNib {
    
    [self.editorNameLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.setFreightTemplateLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.lineLabel setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)didClickSelectdFreightButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(setEditorButton:)]) {
        [self.delegate setEditorButton:self.setFreightTemplateButton];
    }
}
@end
