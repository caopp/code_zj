//
//  CSPShareView.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPShareView.h"

@implementation CSPShareView



- (IBAction)cancelButtonClicked:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(dismissShareView)]) {
        [self.delegate dismissShareView];
    }
}

- (IBAction)shareToWechatFriend:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(shareToWeChatFriend)]) {
        [self.delegate shareToWeChatFriend];
    }
}

- (IBAction)shareToWeChatMoments:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(shareToWeChatMoments)]) {
        [self.delegate shareToWeChatMoments];
    }
}

@end
