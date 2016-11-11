//
//  PicChooseView.m
//  IMTest
//
//  Created by 王剑粟 on 15/6/29.
//
//

#import "PicChooseView.h"
#import "ACMacros.h"

@implementation PicChooseView

- (instancetype)initWithFrame:(CGRect)frame withtype:(PlusType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        _plusType = type;
        xoffsent = (Main_Screen_Width - 59 * 3) / 4;
        [self addPic];
    }
    
    return self;
}

- (void)addPic {

    //photo
    UIView * photoView = [[UIView alloc] initWithFrame:CGRectMake(xoffsent, 15, 59, 76)];
    photoView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [photoView addGestureRecognizer:photoTap];

    UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
    [photoImageView setImage:[UIImage imageNamed:@"10_商品询单对话_添加照片"]];
    [photoView addSubview:photoImageView];
    
    UILabel * photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 59, 18)];
    photoLabel.text = @"照片";
    photoLabel.font = [UIFont fontWithName:nil size:16];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
    [photoView addSubview:photoLabel];
    
    [self addSubview:photoView];
    
    //camera
    UIView * cameraView = [[UIView alloc] initWithFrame:CGRectMake(2 * xoffsent + 59, 15, 59, 76)];
    cameraView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [cameraView addGestureRecognizer:cameraTap];
    
    UIImageView * cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
    [cameraImageView setImage:[UIImage imageNamed:@"10_商品询单对话_添加拍照"]];
    [cameraView addSubview:cameraImageView];
    
    UILabel * cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 59, 18)];
    cameraLabel.text = @"拍摄";
    cameraLabel.font = [UIFont fontWithName:nil size:15];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
    [cameraView addSubview:cameraLabel];
    
    [self addSubview:cameraView];
    
    //推荐部分屏蔽
    if (_plusType == PlusType_Three) {
        
        //推介
        UIView * referralView = [[UIView alloc] initWithFrame:CGRectMake(3 * xoffsent + 59 * 2, 15, 59, 76)];
        referralView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        referralTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [referralView addGestureRecognizer:referralTap];
        
        UIImageView * referralImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
        [referralImageView setImage:[UIImage imageNamed:@"推荐"]];
        [referralView addSubview:referralImageView];
        
        UILabel * referralLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 59, 18)];
        referralLabel.text = @"推荐";
        referralLabel.font = [UIFont fontWithName:nil size:15];
        referralLabel.textAlignment = NSTextAlignmentCenter;
        referralLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
        [referralView addSubview:referralLabel];
        
        [self addSubview:referralView];
    }
}

- (void)viewTap:(UITapGestureRecognizer *)sender {
    
    if (sender == photoTap) {
        [self.delegate buttonAction:0];
    }
    
    if (sender == cameraTap) {
        [self.delegate buttonAction:1];
    }
    
    if (sender == referralTap) {
        [self.delegate buttonAction:2];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
