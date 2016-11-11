//
//  GUAAlertView.m
//  GUAAlertView
//
//  Created by gua on 11/11/14.
//  Copyright (c) 2014 GUA. All rights reserved.
//

#import "GUAAlertView.h"


static const float finalAngle = 45;
static const float backgroundViewAlpha = 0.5;
static const float alertViewCornerRadius = 8;


@interface GUAAlertView ()
{
    
    BOOL withTwoBtn;//标志是否显示两个按钮

}

// backgroundView, alertView ,shotView(要截取的view)
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UIView *shotView;


// titleLabel, messageLable, button
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *buttonOK;//确定按钮
@property (nonatomic) UIButton *buttonCancel;//取消按钮


// autolayout constraint for alertview centerY
@property (nonatomic) NSLayoutConstraint *alertConstraintCenterY;

// title, message, button text
@property (nonatomic) NSString *titleText;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) CGFloat  titleFont;

@property (nonatomic) NSString *messageText;
@property (nonatomic) UIColor *messageColor;


@property (nonatomic) NSString *buttonOkTitleText;
@property (nonatomic) UIColor *okBtnColor;

@property (nonatomic) NSString *buttonCancelTitleText;
@property (nonatomic) UIColor *cancelBtnColor;


// blocks
@property (nonatomic, copy) GUAAlertViewBlock buttonBlock;
@property (nonatomic, copy) GUAAlertViewBlock dismissBlock;

@property (nonatomic) float rorateDirection;


@end


@implementation GUAAlertView

#pragma mark - 带title字体大小的init

/**
 *
 *  @param title             标题 可为nil
 *  @param titleColor        标题颜色
 *  @param titleFont         标题字体大小（和下面方法不一样的地方）如果为默认的，则传0即可
 *  @param message           信息
 *  @param messageColor      信息颜色
 *  @param buttonTitle       右边按钮文字（被称为 “第一个按钮”）
 *  @param okButtonColor     右边按钮文字的颜色
 *  @param cancelButtonTitle 左边按钮文字（被称为“第二个按钮”）
 *  @param cancelBtnColor    左边按钮文字的颜色
 *  @param shotView          要添加alert的view  不可以为nil
 *  @param buttonBlock       右边按钮的事件
 *  @param dismissBlock      左边按钮的事件
 
 */
+ (instancetype)alertViewWithTitle:(NSString *)title  withTitleClor:(UIColor *)titleColor  withTitleFont:(CGFloat )titleFont  message:(NSString *)message                                                        withMessageColor:(UIColor *)messageColor
                     oKButtonTitle:(NSString *)buttonTitle
                 withOkButtonColor:(UIColor *)okButtonColor
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 withOkCancelColor:(UIColor *)cancelBtnColor  withView:(UIView *)shotView
               buttonTouchedAction:(GUAAlertViewBlock)buttonBlock
                     dismissAction:(GUAAlertViewBlock)dismissBlock{
    
    return [[GUAAlertView alloc]initWithTitle:title withTitleClor:titleColor withTitleFont:titleFont message:message withMessageColor:messageColor oKButtonTitle:buttonTitle withOkButtonColor:okButtonColor cancelButtonTitle:cancelButtonTitle withOkCancelColor:cancelBtnColor withView:shotView buttonTouchedAction:buttonBlock dismissAction:dismissBlock];
    
    
}

- (instancetype)initWithTitle:(NSString *)title
                withTitleClor:(UIColor *)titleColor
                withTitleFont:(CGFloat )titleFont
                      message:(NSString *)message
             withMessageColor:(UIColor *)messageColor
                oKButtonTitle:(NSString *)oKButtonTitle
            withOkButtonColor:(UIColor *)okButtonColor
            cancelButtonTitle:(NSString *)cancelButtonTitle
            withOkCancelColor:(UIColor *)cancelBtnColor
                     withView:(UIView *)shotView
          buttonTouchedAction:(GUAAlertViewBlock)buttonAction
                dismissAction:(GUAAlertViewBlock)dismissAction {
    
    self = [super init];
    
    if (self) {
        
        
        
        //传入了第二个按钮的文字  则显示两个按钮  withTwoBtn=yes  右边是第一个 左边是第二个
        if (cancelButtonTitle!=nil) {
            
            withTwoBtn=YES;
            //1.
            _buttonCancelTitleText=cancelButtonTitle;//第二个按钮的文字
            
            _dismissBlock = dismissAction;//第二个按钮的事件
            
            _cancelBtnColor=cancelBtnColor;//第二个按钮的字体颜色
            
        }
        
        //2.
        //第一个按钮的文字
        _buttonOkTitleText = oKButtonTitle;
        //第一个按钮的事件
        _buttonBlock = buttonAction;
        
        //第一个按钮的字体颜色
        _okBtnColor=okButtonColor;
        
        //3.
        //title的文字
        _titleText = title;
        //title文字的颜色
        _titleColor=titleColor;
        // title 文字的字体大小  区别就是这里设了字体大小
        _titleFont = titleFont;
        
        //4.
        //提示信息的文字
        _messageText = message;
        //提示信息的文字颜色
        _messageColor=messageColor;
        
        _shotView=shotView;
        
        
        [self setup];
        
    }
    return self;
}

#pragma mark - 不带title字体大小的init

/**
 *
 *  @param title             标题 可为nil
 *  @param titleColor        标题颜色
 *  @param message           信息
 *  @param messageColor      信息颜色
 *  @param buttonTitle       右边按钮文字（被称为 “第一个按钮”）
 *  @param okButtonColor     右边按钮文字的颜色
 *  @param cancelButtonTitle 左边按钮文字（被称为“第二个按钮”）
 *  @param cancelBtnColor    左边按钮文字的颜色
 *  @param shotView          要添加alert的view  不可以为nil
 *  @param buttonBlock       右边按钮的事件
 *  @param dismissBlock      左边按钮的事件
 */
+ (instancetype)alertViewWithTitle:(NSString *)title  withTitleClor:(UIColor *)titleColor    message:(NSString *)message                                                        withMessageColor:(UIColor *)messageColor
                     oKButtonTitle:(NSString *)buttonTitle
                 withOkButtonColor:(UIColor *)okButtonColor
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 withOkCancelColor:(UIColor *)cancelBtnColor  withView:(UIView *)shotView
               buttonTouchedAction:(GUAAlertViewBlock)buttonBlock
                     dismissAction:(GUAAlertViewBlock)dismissBlock{

    return [[GUAAlertView alloc]initWithTitle:title withTitleClor:titleColor message:message withMessageColor:messageColor oKButtonTitle:buttonTitle withOkButtonColor:okButtonColor cancelButtonTitle:cancelButtonTitle withOkCancelColor:cancelBtnColor withView:shotView buttonTouchedAction:buttonBlock dismissAction:dismissBlock];


}

- (instancetype)initWithTitle:(NSString *)title
                      withTitleClor:(UIColor *)titleColor
                      message:(NSString *)message
                     withMessageColor:(UIColor *)messageColor
                  oKButtonTitle:(NSString *)oKButtonTitle
                  withOkButtonColor:(UIColor *)okButtonColor
            cancelButtonTitle:(NSString *)cancelButtonTitle
            withOkCancelColor:(UIColor *)cancelBtnColor
            withView:(UIView *)shotView
          buttonTouchedAction:(GUAAlertViewBlock)buttonAction
                dismissAction:(GUAAlertViewBlock)dismissAction {
    
    self = [super init];
    
    if (self) {
        

        
        //传入了第二个按钮的文字  则显示两个按钮  withTwoBtn=yes  右边是第一个 左边是第二个
        if (cancelButtonTitle!=nil) {
            
            withTwoBtn=YES;
            //1.
            _buttonCancelTitleText=cancelButtonTitle;//第二个按钮的文字

            _dismissBlock = dismissAction;//第二个按钮的事件
            
            _cancelBtnColor=cancelBtnColor;//第二个按钮的字体颜色

        }
        
        //2.
        //第一个按钮的文字
        _buttonOkTitleText = oKButtonTitle;
        //第一个按钮的事件
        _buttonBlock = buttonAction;
        
        //第一个按钮的字体颜色
        _okBtnColor=okButtonColor;
        
        //3.
        //title的文字
        _titleText = title;
        //title文字的颜色
        _titleColor=titleColor;
        
        //4.
        //提示信息的文字
        _messageText = message;
        //提示信息的文字颜色
        _messageColor=messageColor;
        
        _shotView=shotView;
        
        
        [self setup];
    }
    return self;
}



#pragma mark - setups

- (void)setup {
    
    //设置背景
    [self setupBackground];

    //alertview
    [self setupAlertView];

    [self setupTitleLabel];

    [self setupContent];

    [self setupButton];
    

    // setup layout constraints
    [self setupLayoutConstraints];
    
    
    
}

- (void)setupLayoutConstraints {
    
    
    
    if (!withTwoBtn) {//只显示一个按钮的时候
        
        // metrics and views
        NSDictionary *metrics = @{@"padding": @20,
                                  @"buttonHeight": @44,
                                  };
        NSDictionary *views = @{@"title": _titleLabel,
                                @"content": _messageLabel,
                                @"button": _buttonOK,
                                };

        
        // vertical layout
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:
                                    @"V:|-padding-[title]-[content]-padding-[button(==buttonHeight)]|"
                                    options:0
                                    metrics:metrics
                                    views:views]];
        
        
        // horizontal layout
        
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-[content]-|"
                                    options:0
                                    metrics:metrics
                                    views:views]];
        
        
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|[button]|"
                                    options:0
                                    metrics:metrics
                                    views:views]];
        
        
        // !没有title的时候
        if (!_titleText.length) {
            
            
            //title的高度设为0
            
            [_alertView addConstraint:[NSLayoutConstraint
                                       constraintWithItem:_titleLabel
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                       constant:0]];
            
            
            
        }else{// !有title的时候
            
            // horizontal layout
            [_alertView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-[title]-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
            
            
        }

        

    }else{//显示两个按钮的时候
    
        // metrics and views
        NSDictionary *metrics = @{@"padding": @20,
                                  @"buttonHeight": @44,
                                  };
        NSDictionary *views = @{@"title": _titleLabel,
                                @"content": _messageLabel,
                                @"buttonOK": _buttonOK,
                                @"buttonCancel":_buttonCancel
                                };
        
        // vertical layout
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:
                                    @"V:|-padding-[title]-[content]-padding-[buttonOK(==buttonHeight)]|"
                                    options:0
                                    metrics:metrics
                                    views:views]];
        
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:
                                    @"V:|-padding-[title]-[content]-padding-[buttonCancel(==buttonHeight)]|"
                                    options:0
                                    metrics:metrics
                                    views:views]];
        
        
//        // horizontal layout
//        [_alertView addConstraints:[NSLayoutConstraint
//                                    constraintsWithVisualFormat:@"H:|-[title]-|"
//                                    options:0
//                                    metrics:metrics
//                                    views:views]];
        
        [_alertView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-[content]-|"
                                    options:0
                                    metrics:metrics
                                    views:views]];

        //按钮 宽度   ；  horizontal layout  两个button距离alertview的距离为0 两个button之间的距离也为0
        [_alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[buttonCancel(buttonOK)][buttonOK]|" options:0 metrics:metrics views:views]];
        
        
        // !没有title的时候
        if (!_titleText.length) {
            
            
            //title的高度设为0
            
            [_alertView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_titleLabel
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                constant:0]];

            
            
        }else{// !有title的时候
            
            // horizontal layout
            [_alertView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-[title]-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
            
           
        }

    
    }
    
   
    
    

}

/**
 *  设置背景
 */
- (void)setupBackground {

    
    //创建背景imageview
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;//把这个关了之后  防止和autolayout冲突
    

    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    //截取屏幕
    UIImage *shotImage=[self getSnapshotImage:w];
 
    //进行毛玻璃处理  此处可以修改毛玻璃的颜色  模糊效果等
    [imageView setImage:[shotImage applyBlurWithRadius:15 tintColor:[UIColor colorWithWhite:0.3 alpha:0.7] saturationDeltaFactor:1.8 maskImage:nil]];

    [self addSubview:imageView];

    _backgroundView = imageView;

    
    
}
/**
 *  截取屏幕
 *
 *  @param shotView 要截取的view
 *
 *  @return 截取成的image
 */
- (UIImage *)getSnapshotImage:(UIView *)shotView
{
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(shotView.frame),
                                                      CGRectGetHeight(shotView.frame)), NO,
                                           1);
    
    
    [shotView
     drawViewHierarchyInRect:CGRectMake(0,
                                        
                                        0,
                                        CGRectGetWidth(shotView.frame), CGRectGetHeight(shotView.frame))
     afterScreenUpdates:NO];
    
    
    UIImage
    *snapshot =
    UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    
    return  snapshot;
    
    
}



- (void)setupAlertView {
    // init
    _alertView = [UIView new];
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    _alertView.layer.cornerRadius = alertViewCornerRadius;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    
    // add pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [_alertView addGestureRecognizer:panGesture];
    
    // autolayout constraint
    NSLayoutConstraint *constraintCenterX =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *constraintCenterY =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    self.alertConstraintCenterY = constraintCenterY;
    
    
    NSLayoutConstraint *constraintLeft =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:- 40];
    
    NSLayoutConstraint *constraintRight =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:40];
    
    
    
    
//    NSLayoutConstraint *constraintHeightMin =
//    [NSLayoutConstraint constraintWithItem:_alertView
//                                 attribute:NSLayoutAttributeHeight
//                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                    toItem:nil
//                                 attribute:NSLayoutAttributeNotAnAttribute
//                                multiplier:1
//                                  constant:130];
//    
//    NSLayoutConstraint *constraintHeightMax =
//    [NSLayoutConstraint constraintWithItem:_alertView
//                                 attribute:NSLayoutAttributeHeight
//                                 relatedBy:NSLayoutRelationLessThanOrEqual
//                                    toItem:self
//                                 attribute:NSLayoutAttributeHeight
//                                multiplier:1
//                                  constant:-50];
    
    [self addConstraints:@[constraintCenterX,constraintCenterY, constraintLeft,constraintRight]];
    
    
}

- (void)setupTitleLabel {
    
    UILabel *label = [self labelWithText:_titleText];
    
    if (_titleFont) {

        label.font = [UIFont systemFontOfSize:_titleFont];

        
    }else{
    
        label.font = [UIFont systemFontOfSize:14.0f];

        
    }
    
    
    
    
    [_alertView addSubview:label];
    _titleLabel = label;
    
    // 标题颜色
    if (_titleColor) {
        
        [_titleLabel setTextColor:_titleColor];
        
    }
    
    
}

- (void)setupContent {
    
    UILabel *label = [self labelWithText:_messageText];
    label.font = [UIFont systemFontOfSize:14.0f];

    [_alertView addSubview:label];
    _messageLabel = label;
    
    // 信息颜色
    if (_messageColor) {
        
        [_messageLabel setTextColor:_messageColor];
        
    }
    
}

- (void)setupButton {
    
    int max=1;//显示几个按钮
    
    if (withTwoBtn) {//显示两个按钮
        
        max=2;
        
    }
    
    for (int i=0; i<max; i++) {
        
        // init
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        
        // gray seperator
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.shadowColor = [[UIColor grayColor] CGColor];
        btn.layer.shadowRadius = 0.5;
        btn.layer.shadowOpacity = 1;
        btn.layer.shadowOffset = CGSizeZero;
        btn.layer.masksToBounds = NO;
        
        NSString *btnStr;//按钮的文字
        
        if (i==0) {//确定按钮（第一个按钮）
            
            _buttonOK=btn;
            
            //title
            btnStr=_buttonOkTitleText;
            
            // action
            [btn addTarget:self
                    action:@selector(buttonAction:)   forControlEvents:UIControlEventTouchUpInside];

            
            [_alertView addSubview:_buttonOK];
            
            // 按钮颜色
            if (_okBtnColor) {
                
                [_buttonOK setTitleColor:_okBtnColor forState:UIControlStateNormal];
                
            }else{
                
                [_buttonOK setTitleColor:[UIColor colorWithHexValue:0x007aff alpha:1] forState:UIControlStateNormal];

            
            }
        
        }else{//取消按钮（第二个按钮）  如果没有第二个按钮没有传入文字 则第二个按钮是没有的
            
            _buttonCancel=btn;
            //title
            btnStr=_buttonCancelTitleText;

            // action
            [btn addTarget:self
                    action:@selector(cancelButtonAction:)   forControlEvents:UIControlEventTouchUpInside];

            
            [_alertView addSubview:_buttonCancel];

            // 按钮颜色
            if (_cancelBtnColor) {
                
                [_buttonCancel setTitleColor:_cancelBtnColor forState:UIControlStateNormal];
                
            }else{
            
                [_buttonCancel setTitleColor:[UIColor colorWithHexValue:0x007aff alpha:1] forState:UIControlStateNormal];

            }
        
        }
        

        
        // title

        [btn setTitle:btnStr forState:UIControlStateNormal];
        [btn setTitle:btnStr forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        
        
    }
    
    
}

#pragma mark - gesture recognizer

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    UIView *v = recognizer.view;
    CGPoint translation = [recognizer translationInView:v];
    [recognizer setTranslation:CGPointZero inView:v];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint position =  [recognizer locationInView:v];
        self.rorateDirection = position.x > CGRectGetMidX(v.bounds) ? 1 : -1;
        
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        // update alertview constraint
        self.alertConstraintCenterY.constant += translation.y;

        // rotate
        float halfScreenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        float ratio = self.alertConstraintCenterY.constant / halfScreenHeight;
        // change background alpha when slide down
        if (ratio > 0) {
            _backgroundView.alpha = backgroundViewAlpha - ratio * backgroundViewAlpha;
        }

        CGFloat finalDegree = 45;
        CGFloat radian = finalDegree * (M_PI / 180) * ratio * self.rorateDirection;
        v.transform = CGAffineTransformMakeRotation(radian);
        
    } else {
        [self panEnd];
    }
}

- (void)panEnd {
    if (fabs(self.alertView.center.y - self.bounds.size.height) < (self.bounds.size.height / 4)) {
        [self dismiss];
    } else {
        [self resetAlertViewPosition];
    }
}

#pragma mark - show and dismiss
/**
 *  显示
 */
- (void)show {
    
    
    if (self.lastTextColor) {
        
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
    NSInteger length = [self.messageLabel.text length];
    
    
    [str addAttribute:NSForegroundColorAttributeName value:self.lastTextColor range:NSMakeRange(length-1,1)];
    self.messageLabel.attributedText = str;
    
    }


    UIWindow *w = [[UIApplication sharedApplication] keyWindow];

    
    if (self.withJudge) {//!有弹出框存在，就返回，不弹出
        
        for (UIView * childViews in w.subviews) {
            
            if ([childViews isKindOfClass:[GUAAlertView class]]) {
                
                return ;
            }
            
        }
        
    }

    [w addSubview:self];

    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSizeFitConstraint:self toView:w widthConstant:0 heightConstant:0];
//    [self addSizeFitConstraint:self toView:topView widthConstant:0 heightConstant:0];

    
    
    [self showAlertView];

    // NOTE, hack for iOS7.
    // only keyWindow.subviews[0] get rotation event in iOS7

    
    
}

- (void)showAlertView {
    // init state
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat y = -(CGRectGetHeight(screenBounds) + CGRectGetHeight(_alertView.frame)/2);
    _alertView.center = CGPointMake(_alertView.center.x, y);
    _alertView.transform = CGAffineTransformMakeRotation(finalAngle);

    //duration ：执行动画的时间  delay：延迟多长时间执行  usingSpringWithDamping：摆动的幅度 initialSpringVelocity :速度    options：从哪里进入
    [UIView animateWithDuration:1
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         _alertView.transform = CGAffineTransformMakeRotation(0);
                         _alertView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                                         CGRectGetMidY(self.bounds));
                     } completion:^(BOOL finished) {
                     }];

    
}

- (void)dismiss {
    
    
    [UIView animateWithDuration:1
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         
                         _backgroundView.alpha = 0.0;

                         _alertView.transform = CGAffineTransformMakeRotation(finalAngle);
                         
                        //决定了alertview收回的方向
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
//                        float finalY = -(screenBounds.size.height / 2 + self.alertView.bounds.size.height);
                         
                        float finalY = -(screenBounds.size.height /2  + self.alertView.bounds.size.height + self.alertView.bounds.size.height/2);

                        self.alertConstraintCenterY.constant += finalY;


                         
                         [self layoutIfNeeded];
                         

                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
    
}

- (void)resetAlertViewPosition {
    
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.alpha = backgroundViewAlpha;
                         _alertView.transform = CGAffineTransformMakeRotation(0);
                         self.alertConstraintCenterY.constant = 0;
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

#pragma mark - button action
//左边按钮
- (void)buttonAction:(UIButton *)sender {
    if (_buttonBlock != NULL) {
        _buttonBlock();
    }
    [self dismiss];
}
//右边按钮
- (void)cancelButtonAction:(UIButton *)sender {
    
    if (_dismissBlock != NULL) {
        
        _dismissBlock();
    
    }
    
    [self dismiss];
}


#pragma mark - helper methods

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;

    return label;
}

- (void)addSizeFitConstraint:(id)view1
                      toView:(id)view2
               widthConstant:(CGFloat)widthConstant
              heightConstant:(CGFloat)heightConstant {
    
    NSLayoutConstraint *centerX =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];

    NSLayoutConstraint *centerY =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];

    NSLayoutConstraint *width =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.1     // NOTE, hack to work with ios7
                                  constant:widthConstant];

    NSLayoutConstraint *height =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1     // NOTE, hack to work with ios7
                                  constant:heightConstant];
    
    // !设置最低高度
    
    
//    NSLayoutConstraint *height =[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_HEIGHT];
//
    
    [view2 addConstraints:@[centerX, centerY, width, height]];
    
    
    
}

UIImage *
imageFromColor(UIColor *color){
    
      CGRect rect = CGRectMake(0, 0, 1, 1);
      UIGraphicsBeginImageContext(rect.size);
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextSetFillColorWithColor(context, [color CGColor]);
      CGContextFillRect(context, rect);
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();

      return image;
}

@end
