//
//  NoInviteCodeInfoView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/6.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理方法
@protocol NoInviteCodeInfoViewDelegate <NSObject>

-(void)didClickCameraAction;
-(void)didClickPhotoAction;
@end

@interface NoInviteCodeInfoView : UIView

@property (strong, nonatomic) IBOutlet UILabel *photoLabel;
@property (strong, nonatomic) IBOutlet UILabel *camera;



@property(weak,nonatomic)id<NoInviteCodeInfoViewDelegate>delegate;

@end
