//
//  WindowImgView.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WindowImgView.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@implementation WindowImgView{
    
    NSInteger imageCount;
    NSArray *urls;
}
//-(id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        float width = [UIScreen mainScreen].bounds.size.width;
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [self  addSubview:_scrollView];
//        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, width - 40,width, 40)];
//        [self addSubview:_pageControl];
//        
//        CGRect frame = _scrollView.frame;
//        frame.size.height = width;
//        [self setFrame:frame];
//        
//        CGSize contentSize = _scrollView.frame.size;
//        contentSize.width = width*3;
//        
//        _scrollView.contentSize = contentSize;
//        _scrollView.pagingEnabled = YES;
//        [_scrollView setShowsHorizontalScrollIndicator:NO];
//
//    }
//    return self;
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//
//  
//}
- (void)awakeFromNib
{
    float width = [UIScreen mainScreen].bounds.size.width;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self  addSubview:_scrollView];
    _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, width - 40,width, 40)];
    [self addSubview:_pageControl];
    
    CGRect frame = _scrollView.frame;
    frame.size.height = width;
    [self setFrame:frame];
    
    CGSize contentSize = _scrollView.frame.size;
    contentSize.width = width*3;
    
    _scrollView.contentSize = contentSize;
    _scrollView.pagingEnabled = YES;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.backgroundColor = [UIColor greenColor];
}

- (void)clearAllSubViewsFrom:(NSArray*)subViews{
    
    for (id obj in subViews) {
        
        [obj removeFromSuperview];
    }
}

- (void)setImagesArr:(NSArray *)imagesArr{
    urls = imagesArr;
    [self clearAllSubViewsFrom:_scrollView.subviews];
    imageCount = imagesArr.count;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat contentWidth = width*imageCount;
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    
    
    for (int i = 0;i<imageCount;i++) {
        
        UIImageView *tmpImageView = [[UIImageView alloc]init];
        [tmpImageView setFrame:CGRectMake(0+i*width,0,width,height)];
        NSString *url = imagesArr[i];
        tmpImageView.tag = i;
        tmpImageView.userInteractionEnabled = YES;
        NSURL *url_URL = [NSURL URLWithString:url];
        [tmpImageView sd_setImageWithURL:url_URL placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
        [tmpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [_scrollView addSubview:tmpImageView];
        tmpImageView.hidden = NO;
    }
    
    if (imageCount>1) {
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"轮播图未选中"];
        _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"轮播图选中"];
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor clearColor];
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = imageCount;
        _pageControl.currentPage = 0;
    }else{
        _pageControl.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat width = self.frame.size.width;
    _pageControl.currentPage = (NSInteger)(offset.x/width);
}
//-(void)layoutSubviews{
//   
//}
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
  
    int count =(int) urls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = urls[i];
        NSLog(@"url==%@",url);
        url = [url stringByAppendingString:[NSString stringWithFormat:@"_%d",i]];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url =[NSURL URLWithString:url]; // 图片路径
        
        photo.srcImageView = _scrollView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
@end
