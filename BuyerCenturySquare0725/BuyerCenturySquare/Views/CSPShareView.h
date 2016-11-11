//
//  CSPShareView.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CSPShareViewDelegate <NSObject>

-(void)dismissShareView;

/**
 * 分享
 * shareToWeChatFriend 分享给微信好友
 * shareToWeChatMoments 分享至朋友圈
 */
-(void)shareToWeChatFriend;
-(void)shareToWeChatMoments;

@end

@interface CSPShareView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClicked:(id)sender;
@property (nonatomic ,assign)id<CSPShareViewDelegate>delegate;

@end
