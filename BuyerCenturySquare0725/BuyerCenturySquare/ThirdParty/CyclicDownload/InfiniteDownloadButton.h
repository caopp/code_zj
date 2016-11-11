//
//  InfiniteDownloadButton.h
//  循环下载
//
//  Created by liufengting on 15/11/16.
//  Copyright © 2015年 liufengting. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum InfiniteDownloadDirection {
    InfiniteDownloadDirectionUnset,
    InfiniteDownloadDirectionLeftToRight,
    InfiniteDownloadDirectionRightToLeft,
    InfiniteDownloadDirectionTopToBottom,
    InfiniteDownloadDirectionBottomToTop
} InfiniteDownloadDirection;

@interface InfiniteDownloadButton : UIButton


@property (weak, nonatomic) UIView *scrollingView;
@property (strong, nonatomic) CABasicAnimation *currentScrollAnimation;
@property (nonatomic) InfiniteDownloadDirection direction;
@property (nonatomic) NSTimeInterval tileDuration;
@property (strong, nonatomic) UIImage *tileImage;

@property (nonatomic,assign ) BOOL isScrolling;

//集成方法

-(id)initWithFrame:(CGRect)frame placeholderImage: (UIImage *) placeholdImage tileImage:(UIImage *) tileImage tileDuration:(NSTimeInterval)tileDuration  direction:(InfiniteDownloadDirection) direction;

-(void) start;

-(void) stop;





@end
