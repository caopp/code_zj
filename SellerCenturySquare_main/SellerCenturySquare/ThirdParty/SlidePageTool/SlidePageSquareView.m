//
//  SlidePageSquareView.m
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import "SlidePageSquareView.h"

@interface SlidePageSquareView ()
{
    
    UIColor * _bgColor;
    UIColor * _squareViewColor;
    UIColor * _unSelectTitleColor;
    UIColor * _selectTitleColor;
    UIFont * _titleFont;
    
    UILabel *label;
    UILabel *firstLabel;
    
}

@property (nonatomic,strong) NSArray<NSString*>        * dataArr;
@property (nonatomic,weak) UIView                      * squareView;
@property (nonatomic,weak) UIView                      * bgView;
@property (nonatomic,strong) NSMutableArray <UIButton*> * bottomBtnMArr;
@property (nonatomic,strong) NSMutableArray <UIButton*> * topBtnMArr;

@property (nonatomic ,strong) UILabel *xbDotLab;
@property (nonatomic ,strong) UILabel *xcDotLab;


@end

@implementation SlidePageSquareView

- (instancetype)initWithDataArr:(NSArray<NSString *> *)dataArr bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor withTitleFont:(UIFont *)titleFont{
    if (dataArr.count==0) {
        return nil;
    }
    self = [super init];
    
    
    _bgColor = bgColor;
    _squareViewColor = squareViewColor;
    _unSelectTitleColor = unSelectTitleColor;
    _selectTitleColor = selectTitleColor;
    _titleFont = titleFont;

    
    self.bottomBtnMArr = [NSMutableArray arrayWithCapacity:10];
    self.topBtnMArr    = [NSMutableArray arrayWithCapacity:10];
    self.dataArr       = dataArr;
    
    [self setUpView];
    
    
    //设置通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowhideRedIcon) name:@"windowPicNum" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideRedIcon) name:@"detailPicNum" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideWindowRedIcon) name:@"windowPicNumRed" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideDetailRedIcon) name:@"detailPicNumRed" object:nil];

    if (SCREEN_WIDTH == 320) {
        label  = [[UILabel  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 5, 7, 7)];
        firstLabel  = [[UILabel  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 5, 7, 7)];
    }else{
        
        label  = [[UILabel  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 5, 7, 7)];
        firstLabel  = [[UILabel  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, 5, 7, 7)];
    }

    [self addSubview:label];
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    

    [self addSubview:firstLabel];
    firstLabel.layer.cornerRadius = 4;
    firstLabel.layer.masksToBounds = YES;
  
    return self;
}


-(void)windowhideRedIcon
{
  firstLabel.backgroundColor = [UIColor redColor];
}

-(void)hideRedIcon
{
    /* 目前新增图片显示红点功能 */
    label.backgroundColor = [UIColor redColor];
}

-(void)hideWindowRedIcon
{
    firstLabel.backgroundColor = [UIColor clearColor];
}

-(void)hideDetailRedIcon
{
    label.backgroundColor = [UIColor clearColor];
}


- (void)setUpView{
    
    self.backgroundColor = _bgColor;
    self.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<self.dataArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:_unSelectTitleColor forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (_titleFont) {
            
            [btn.titleLabel setFont:_titleFont];
        }

        [self.bottomBtnMArr addObject:btn];
    }
    
    UIView *squareView = [[UIView alloc]init];
    squareView.backgroundColor = _squareViewColor;
    squareView.layer.masksToBounds = YES;
    [self addSubview:squareView];
    self.squareView = squareView;
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.squareView addSubview:bgView];
    self.bgView = bgView;
    
    for (int i=0; i<self.dataArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:_selectTitleColor forState:UIControlStateNormal];
        btn.tag = 700+i;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_titleFont) {
            
            [btn.titleLabel setFont:_titleFont];
        }
        
        [self.bgView addSubview:btn];
        [self.topBtnMArr addObject:btn];
    }
    
    
    UILabel *xbRedDot = [[UILabel alloc] init];
    xbRedDot.frame = CGRectMake(SCREEN_WIDTH/4 + 25, 3, 8, 8);
    xbRedDot.layer.cornerRadius = 4.0f;
    xbRedDot.layer.masksToBounds = YES;
    
    [self addSubview:xbRedDot];
    self.xbDotLab = xbRedDot;
    
    
    UILabel *xcRedDot = [[UILabel alloc] init];
    xcRedDot.layer.cornerRadius = 4.0f;
    xcRedDot.layer.masksToBounds = YES;
    xcRedDot.frame = CGRectMake(SCREEN_WIDTH/4*3 + 25, 3, 8, 8);
    [self addSubview:xcRedDot];
    self.xcDotLab = xcRedDot;
    
}

- (void)setUpLayout{
    CGFloat squareViewWidth = self.contentSize.width/self.dataArr.count;
    CGFloat squareViewHeight =  self.frame.size.height;
    
    self.squareView.frame = CGRectMake( self.squareViewOriginX, 0, squareViewWidth, squareViewHeight);
    self.bgView.frame     = CGRectMake(-self.squareViewOriginX, 0, squareViewWidth, squareViewHeight);
    for (int i=0; i<self.bottomBtnMArr.count; i++) {
        self.bottomBtnMArr[i].frame = CGRectMake(i*squareViewWidth, 0, squareViewWidth, squareViewHeight);
    }
    for (int i=0; i<self.topBtnMArr.count; i++) {
        self.topBtnMArr[i].frame    = CGRectMake(i*squareViewWidth, 0, squareViewWidth, squareViewHeight);
    }
}

- (void)slidePageSquareViewSlide{
    CGFloat squareViewWidth = self.contentSize.width/self.dataArr.count;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat offsetX = self.squareViewOriginX - screenWidth / 2 + squareViewWidth / 2;
    if (offsetX + screenWidth > self.contentSize.width){
        offsetX = self.contentSize.width - screenWidth;
    }
    
    if (offsetX < 0){
        offsetX = 0;
    }
    
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpLayout];
  
}

- (void)setSquareViewOriginX:(CGFloat)squareViewOriginX{
    _squareViewOriginX = squareViewOriginX;
    [self setUpLayout];
}


- (void)setEndcontentOffsetX:(CGFloat)endcontentOffsetX{
    _endcontentOffsetX = endcontentOffsetX;
    [self slidePageSquareViewSlide];
}


- (void)btnClick:(UIButton*)btn{
    if ([self.delegateForSlidePage respondsToSelector:@selector(slidePageSquareView:andBtnClickIndex:)]) {
        
        [self.delegateForSlidePage slidePageSquareView:self andBtnClickIndex:(btn.tag-100)];
        
        if (btn.tag == 101) {
           
           label.backgroundColor = [UIColor clearColor];
        }
        
        if (btn.tag == 100) {
           firstLabel.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)showLittleRedDotxb:(NSNumber *)xb xc:(NSNumber *)xc
{
    if (xb.integerValue>0) {
        self.xbDotLab.backgroundColor = [UIColor colorWithHex:0xfd4f57];
    }else
    {
        self.xbDotLab.backgroundColor = [UIColor clearColor];
    }
    
    
    if (xc.integerValue > 0) {
        self.xcDotLab.backgroundColor = [UIColor colorWithHex:0xfd4f57];
    }else
    {
        self.xcDotLab.backgroundColor = [UIColor clearColor];
    }
}

//改变button的内容
-(void)changeBtnValue:(NSInteger)btnIndex withTitle:(NSString *)btnTitleStr{

    UIButton * changeBtn = (UIButton *)[self viewWithTag:(100 + btnIndex)];
    [changeBtn setTitle:btnTitleStr forState:UIControlStateNormal];
    
    UIButton *selectedBtn = (UIButton *)[self viewWithTag:(700 + btnIndex)];
    [selectedBtn setTitle:btnTitleStr forState:UIControlStateNormal];
}

//进行同时销毁
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"windowPicNum" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"detailPicNum" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"detailPicNumRed" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"windowPicNumRed" object:nil];
}


@end
