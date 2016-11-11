//
//  CSPPicDownloadView.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPicDownloadView.h"

@interface CSPPicDownloadView()

@property (nonatomic, strong) SGMenuActionHandler actionHandle;

@end

@implementation CSPPicDownloadView

-(void)layoutSubviews
{
    CGRect bounds =[[UIScreen mainScreen] bounds];
    self.bounds =CGRectMake(self.bounds.origin.x, self.bounds.origin.y, bounds.size.width, self.bounds.size.height);
    _impersonalityButton.selected = YES;
    _windowPicButton.selected = YES;
}



- (IBAction)windowPicButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

}
- (IBAction)impersonalityButtonClicked:(UIButton *)sender {
    
     sender.selected = !sender.selected;
    
}
- (IBAction)downloadButtonClicked:(id)sender {
    
    
    if ([sender isKindOfClass:[UIButton class]] && self.actionHandle) {
        if (!self.windowPicButton.selected&&self.impersonalityButton.selected) {
            
        }
        
        //进行延迟
        double delayInSeconds = 0.05;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            self.actionHandle(self.windowPicButton.selected,self.impersonalityButton.selected);
            
        });
    }

}

- (void)triggerSelectedAction:(SGMenuActionHandler)actionHandle;
{
    self.actionHandle = actionHandle;
}

@end
