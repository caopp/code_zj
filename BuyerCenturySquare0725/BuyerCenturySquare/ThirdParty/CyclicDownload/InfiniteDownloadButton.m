//
//  InfiniteDownloadButton.m
//  循环下载
//
//  Created by liufengting on 15/11/16.
//  Copyright © 2015年 liufengting. All rights reserved.
//

#import "InfiniteDownloadButton.h"

@interface InfiniteDownloadButton ()

//@property (strong, nonatomic) UIImageView *placeholder;
//@property (weak, nonatomic) UIView *scrollingView;
//@property (strong, nonatomic) CABasicAnimation *currentScrollAnimation;
//@property (nonatomic) InfiniteDownloadDirection direction;
//@property (nonatomic) NSTimeInterval tileDuration;
//@property (strong, nonatomic) UIImage *tileImage;

-(void) setup;
-(void) beginScrollAnimation;


@end

@implementation InfiniteDownloadButton

-(void) dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


-(id)initWithFrame:(CGRect)frame placeholderImage: (UIImage *) placeholdImage tileImage:(UIImage *) tileImage tileDuration:(NSTimeInterval)tileDuration  direction:(InfiniteDownloadDirection) direction{
    if (self=[super initWithFrame:frame]) {
        [self setup];
        
        [self setBackgroundImage:placeholdImage forState:UIControlStateNormal];
        self.tileImage = tileImage;
        self.tileDuration = tileDuration;
        self.direction = direction;
    }
    
    return self;
}


-(id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

-(void) setup {
    // the animations will be canceled once the user leaves the app, so get a notification for when the app becomes active again so that we can restart the animation
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(applicationDidBecomeActive)
               name: UIApplicationDidBecomeActiveNotification
             object: nil];
    
    self.tileDuration = 10.0f;
    self.currentScrollAnimation = nil;
    
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.6f;
    self.clipsToBounds = YES;

     self.backgroundColor = [UIColor whiteColor];
    UIView *scrollingView = [[UIView alloc] init];
    scrollingView.opaque = NO;
    scrollingView.backgroundColor = [UIColor clearColor];
    scrollingView.userInteractionEnabled = NO;
    
    self.scrollingView = scrollingView;
    self.scrollingView.hidden = YES;
    [self addSubview:self.scrollingView];
    
    self.direction = InfiniteDownloadDirectionLeftToRight;
    
    
//    _placeholder = [[UIImageView alloc]initWithFrame:self.bounds];
//    _placeholder.backgroundColor = [UIColor clearColor];
//    _placeholder.contentMode = UIViewContentModeScaleAspectFit;
//    _placeholder.userInteractionEnabled = NO;
//    [self addSubview:_placeholder];
    
}

- (void) setScrollViewFrame {
    CGRect frame = self.bounds;
    if(_direction == InfiniteDownloadDirectionLeftToRight ||
       _direction == InfiniteDownloadDirectionRightToLeft) {
        frame.size.width *= 2;
    }
    else
    {
        frame.origin.x = 0;
        frame.size.width = frame.size.width;
        frame.size.height *= 2;
    }
    self.scrollingView.frame = frame;
}

-(void)applicationDidBecomeActive {
    [self beginScrollAnimation];
}

-(void) setTileImage:(UIImage *)tileImage {
    if (![_tileImage isEqual:tileImage]) {
        _tileImage = tileImage;
        self.scrollingView.backgroundColor = [UIColor colorWithPatternImage:tileImage];
        self.scrollingView.userInteractionEnabled = NO;
        
        
    }
}


-(void) setDirection:(InfiniteDownloadDirection )direction {
    if (_direction != direction) {
        _direction = direction;
        [self setScrollViewFrame];
        [self beginScrollAnimation];
    }
}
- (void)setTileDuration:(NSTimeInterval)tileDuration
{
    _tileDuration = tileDuration;
    [self setScrollViewFrame];
    //[self beginScrollAnimation];
}

-(void) beginScrollAnimation {
    self.currentScrollAnimation = nil;
    [self.scrollingView.layer removeAllAnimations];
    [self _animateScroll];
}

-(void) setHidden:(BOOL)hidden {
    BOOL previousHiddenState = [self isHidden];
    [super setHidden:hidden];
    
    // if we actually transitioned to a new hidden/unhidden state
    if (previousHiddenState != hidden) {
        if (hidden) {
            self.currentScrollAnimation = nil;
            [self.scrollingView.layer removeAllAnimations];
        }
        else {
            [self beginScrollAnimation];
        }
    }
}

-(void) _animateScroll {
    CGRect frame = self.scrollingView.frame;
    
    float fromValue = 0.f;
    float toValue = 0.f;
    if (self.direction == InfiniteDownloadDirectionLeftToRight) {
        fromValue = -frame.size.width/2;
        toValue = 0.f;
        frame.origin.x = fromValue;
    }
    else if (self.direction == InfiniteDownloadDirectionRightToLeft) {
        fromValue = 0.f;
        toValue = -frame.size.width/2;
        frame.origin.x = fromValue;
    }
    else if (self.direction == InfiniteDownloadDirectionTopToBottom) {
        fromValue = -frame.size.height/2;
        toValue = 0;
        frame.origin.y = fromValue;
    }
    else {
        fromValue = 0.f;
        toValue = -frame.size.height/2;
        frame.origin.y = fromValue;
    }
    
    self.scrollingView.frame = frame;
    
    int tileUnits = 0;
    if(_direction == InfiniteDownloadDirectionLeftToRight ||
       _direction == InfiniteDownloadDirectionRightToLeft) {
        tileUnits = self.frame.size.width/self.tileImage.size.width;
    }
    else
    {
        tileUnits = self.frame.size.height/self.tileImage.size.height;
    }
    
    [UIView animateWithDuration: self.tileDuration
                          delay: 0.f
                        options: UIViewAnimationOptionCurveLinear
                     animations:
     ^{
         CGRect frame = self.scrollingView.frame;
         if (self.direction == InfiniteDownloadDirectionLeftToRight) {
             frame.origin.x = toValue;
         }
         else if (self.direction == InfiniteDownloadDirectionRightToLeft) {
             frame.origin.x = toValue;
         }
         else if (self.direction == InfiniteDownloadDirectionTopToBottom) {
             frame.origin.y = toValue;
         }
         else {
             frame.origin.y = toValue;
         }
         
         self.scrollingView.frame = frame;
     }
                     completion:
     ^(BOOL finished) {
         if (finished) {
             [self _animateScroll];
         }
     }];
}

-(void) animationDidStop:(CAAnimation *)animation finished:(BOOL)didFinish {
    if ([animation isEqual:self.currentScrollAnimation]) {
        [self _animateScroll];
    }
}


-(void)start
{

    if (_scrollingView) {
        _scrollingView.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
    _isScrolling = YES;

    [self beginScrollAnimation];
    
}

-(void)stop
{

    if (_scrollingView) {
        _scrollingView.hidden = YES;
       
    }
    
    _isScrolling = NO;

    self.currentScrollAnimation = nil;
    [self.scrollingView.layer removeAllAnimations];
    
}


@end
