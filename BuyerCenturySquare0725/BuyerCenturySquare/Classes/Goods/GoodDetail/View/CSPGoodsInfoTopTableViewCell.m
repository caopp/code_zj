//
//  CSPGoodsInfoTopTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsInfoTopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MWWindow.h"
@implementation CSPGoodsInfoTopTableViewCell{
    
    NSInteger imageCount;
    NSArray *urls;
}

- (void)awakeFromNib {
    // Initialization code
    
    CGRect frame = self.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.width;//frame.size.width;
    [self setFrame:frame];
    
    CGSize contentSize = self.frame.size;
    contentSize.width = self.frame.size.width*3;
    
    _scrollView.contentSize = contentSize;
    _scrollView.pagingEnabled = YES;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clearAllSubViewsFrom:(NSArray*)subViews{
    
    for (__strong UIView *obj in subViews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)obj).image = nil;
        }
        [obj removeFromSuperview];
        obj = nil;
    }
}

- (void)setImagesArr:(NSArray *)imagesArr{
    urls = nil;
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
        [tmpImageView sd_setImageWithURL:url_URL placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
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
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNextWindowHiddenAnimation object:nil];
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
    browser.delegate = self;
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark - MJPhotoBrowser delegate
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    NSLog(@"%ld",index);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _scrollView.contentOffset= CGPointMake(index*width, 0);
    
}
-(void)dealloc{
    
    
}
@end
