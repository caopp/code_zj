//
//  Toast+UIView.m
//  Toast
//  Version 2.0
//
//  Copyright 2013 Charles Scalesse.
//

#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>



/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height


static const CGFloat CSToastHorizontalPadding   = 10;
static const CGFloat CSToastVerticalPadding     = 10.0;


/**
 *  设置视图的弧型
 */
static const CGFloat CSToastCornerRadius        = 0.0;
static const CGFloat CSToastOpacity             = 0.3;
static const CGFloat CSToastFontSize            = 14.0;
static const CGFloat CSToastTitleFontSize       = 18.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 3.0;
static const NSString * CSToastDefaultPosition  = @"bottom";

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";


@interface UIView (ToastPrivate)

- (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;

@end


@implementation UIView (Toast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}



-(void)makeMessage
{
    [self showToast:nil];
}


/**
 *  显示消息采用的方法
 */
-(void)makeMessage:(NSString *)message duration:(CGFloat)interval position:(id)position
{
    
    
    UIView *grayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [grayBgView setBackgroundColor:[UIColor blackColor]];
    grayBgView.alpha = 0.5;
    grayBgView.tag = grayViewTag;
    
    [self addSubview:grayBgView];
    

    UIView *toast = [self viewForMessage:message title:nil image:nil];
    
//    [self showToast:toast duration:interval position:position];
    
    [self showToast:toast grayView:grayBgView duration:interval position:@"center"];
    

}

-(void)makeMessage:(NSString *)message duration:(CGFloat)interval position:(id)position tag:(NSInteger)tag
{
    [self makeMessage:message duration:interval position:position];
}



- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init] ;
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
//    if (CSToastDisplayShadow) {
//        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
//        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
//        wrapperView.layer.shadowRadius = CSToastShadowRadius;
//        wrapperView.layer.shadowOffset = CSToastShadowOffset;
//    }
    
//    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    
    wrapperView.backgroundColor = [UIColor blackColor];
    wrapperView.layer.cornerRadius = 4;
    wrapperView.layer.masksToBounds = YES;
    
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    
    
    if (message != nil) {
        
        //重新创建新的label
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        
        messageLabel.text = message;
        

        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 10.0, expectedSizeMessage.width, expectedSizeMessage.height);
        
    }
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastTitleFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle = [title sizeWithFont:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        
        
        //        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
        titleLabel.frame = CGRectMake(0.0, 0.0, messageLabel.frame.size.width, expectedSizeTitle.height);
        
    }
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
   
    
    
    return wrapperView;
}


/**
 *  登录注册采用的方法
 */
//- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
//    
//    
//    UIView *toast = [self viewForMessager:message title:nil image:nil];
//    [self showToast:toast duration:interval position:position];
//
//}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
    
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:interval position:position];
    
    
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

/**
 *  采用的方法
 */
- (void)showToast:(UIView *)toast grayView:(UIView *)grayView duration:(CGFloat)interval position:(id)point {
    
    toast.tag = toastViewTag;
    /**
     *  中心位置
     */
    toast.center = [self centerPointForPosition:point withToast:toast];
    
    toast.alpha = 0.0;
    
    [self addSubview:toast];
    
    /**
     *  动画
     */
    //!灰色背景
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                        
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              toast.alpha = 0.0;
                                              
                                              grayView.alpha = 0.0;//!移除灰色背景
                                              
                                
                                          } completion:^(BOOL finished) {
                                              
                                              [toast removeFromSuperview];
                                              
                                              [grayView removeFromSuperview];//!移除灰色背景
                                              
                                              
                        }];
        }];
}




/**
 *  采用的方法
 */
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point {
   
    toast.tag = toastViewTag;
    /**
     *  中心位置
     */
    toast.center = [self centerPointForPosition:point withToast:toast];
    
    toast.alpha = 0.0;
    
    [self addSubview:toast];
    
    /**
     *  动画
     */
    //!灰色背景
    UIView *grayView = [self viewWithTag:grayViewTag];

    
//    toast.alpha = 1.0;

    
//    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(removeViews) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         toast.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              toast.alpha = 0.0;
                                              
                                              grayView.alpha = 0.0;//!移除灰色背景
                                              
                                              grayView.hidden = YES;
                                              
                                              [grayView removeFromSuperview];//!移除灰色背景
                                              
                                              
                                          } completion:^(BOOL finished) {
                                              
                                              [toast removeFromSuperview];

                                              
                                          }];
                     }];
    
    
    
}

-(void)removeViews{


//    toast.alpha = 0.0;
//    
//    grayView.alpha = 0.0;//!移除灰色背景
//    
//    grayView.hidden = YES;
//    
//    [grayView removeFromSuperview];//!移除灰色背景
//    
//    [toast removeFromSuperview];



}


#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)];

    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor redColor].CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Private Methods


/**
 *  设置中心位置UI view
 *
 */
- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        /**
         *  中心位置设置
         */
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            return CGPointMake(self.bounds.size.width / 2, (self.bounds.size.height - (toast.frame.size.height / 2)) + 40);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
//    NSLog(@"Warning: Invalid position for toast.");
    /**
     *  返回这个方法
     */
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}


/**
 * 设置显示的内容和方法
 */
- (UIView *)viewForMessager:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init] ;
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    
    UIImageView *imageViewBack = [[UIImageView alloc]initWithFrame:self.bounds];
    imageViewBack.image = [UIImage imageNamed:@"LoginBackground"];
    imageViewBack.alpha = 0.7;
    [wrapperView addSubview:imageViewBack];

    /**
     *  显示视图的背景的颜色
     */
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
     if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = LGClickColor;
//        messageLabel.backgroundColor = [UIColor redColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
//         size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) , self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        
        messageLabel.frame = CGRectMake(0.0, 100.0, expectedSizeMessage.width, expectedSizeMessage.height);
        
    }
      CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    //
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLabel.center = self.center;
        messageLeft =  self.frame.size.width/2 - messageWidth/2;
        messageTop = self.frame.size.height/2 - messageHeight/2;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat wrapperWidth = self.frame.size.width;
    CGFloat wrapperHeight =self.frame.size.height;
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    if(messageLabel != nil) {
        
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        
        [wrapperView addSubview:messageLabel];
    }

    return wrapperView;
}

@end
