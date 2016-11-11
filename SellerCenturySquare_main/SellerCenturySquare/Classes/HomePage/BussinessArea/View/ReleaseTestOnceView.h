//
//  ReleaseTestOnceView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseTestOnceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *promptTitleLab;
@property (nonatomic ,copy)void (^blockTest)(ReleaseTestOnceView *view);

@end


