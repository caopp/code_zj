//
//  CSPScrollTableViewCell.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPScrollTableViewCell.h"
@implementation CSPScrollTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    _scrollSegment.layer.cornerRadius = 4.0f;
    _scrollSegment.layer.masksToBounds = YES;

}
- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _imgScroll.contentOffset = CGPointMake(0, 0);
    }else{
        _imgScroll.contentOffset = CGPointMake(_dtoMode.window_referList.count*SCREEN_WIDTH, 0);
    }
}



-(void)loadMode:(GoodsMoreDTO *)dto{
    _dtoMode = dto;
    [self clearAllSubViewsFrom:_imgScroll.subviews];
    CGFloat contentWidth = SCREEN_WIDTH*dto.windowImageList.count;
    
    _imgScroll.pagingEnabled = YES;
    _imgScroll.contentSize = CGSizeMake(contentWidth, 0);

    for (int i = 0;i<dto.window_referList.count;i++) {
        ImgDTO *imgDTO = [dto.window_referList objectAtIndex:i];
        UIImageView *tmpImageView = [[UIImageView alloc]init];
        [tmpImageView setFrame:CGRectMake(i*SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_WIDTH)];
        tmpImageView.userInteractionEnabled = YES;
        tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
        // NSString *url = imagesArr[i];
        tmpImageView.tag = i;
        tmpImageView.layer.masksToBounds = YES;
        tmpImageView.tag = i;
        NSURL *url_URL = [NSURL URLWithString:imgDTO.picUrl];
        [tmpImageView sd_setImageWithURL:url_URL placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
        [tmpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [_imgScroll addSubview:tmpImageView];
        tmpImageView.hidden = NO;
    }

    for (int i = 0;i<dto.window_objectList.count;i++) {
        ImgDTO *imgDTO = [dto.window_objectList objectAtIndex:i];
        UIImageView *tmpImageView = [[UIImageView alloc]init];
        [tmpImageView setFrame:CGRectMake((dto.window_referList.count +i)*SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_WIDTH)];
        tmpImageView.userInteractionEnabled = YES;
        tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImageView.layer.masksToBounds = YES;
        tmpImageView.tag = dto.window_referList.count +i;
        // NSString *url = imagesArr[i];
        tmpImageView.tag = i+dto.window_referList.count;
        NSURL *url_URL = [NSURL URLWithString:imgDTO.picUrl];
        [tmpImageView sd_setImageWithURL:url_URL placeholderImage:[UIImage imageNamed:@""]];
        [tmpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [_imgScroll addSubview:tmpImageView];
        tmpImageView.hidden = NO;
    }

    
    
//    for (int i = 0;i<dto.windowImageList.count;i++) {
//        ImgDTO *imgDTO = [dto.windowImageList objectAtIndex:i];
//        UIImageView *tmpImageView = [[UIImageView alloc]init];
//        [tmpImageView setFrame:CGRectMake(0+i*SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_WIDTH)];
//        tmpImageView.contentMode = UIViewContentModeRedraw;
//       // NSString *url = imagesArr[i];
//        tmpImageView.tag = i;
//        NSURL *url_URL = [NSURL URLWithString:imgDTO.picUrl];
//        [tmpImageView sd_setImageWithURL:url_URL placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
//        [tmpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
//        [_imgScroll addSubview:tmpImageView];
//        tmpImageView.hidden = NO;
//    }
    if (!dto.window_objectList.count||!dto.window_referList.count) {
        _scrollSegment.hidden = YES;
    }else {
        _scrollSegment.hidden = NO;
    }
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView ==_imgScroll) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat width = self.frame.size.width;
    }
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView ==_imgScroll&&!_scrollSegment.hidden) {
        int page = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (page >=_dtoMode.window_referList.count) {
            _scrollSegment.selectedSegmentIndex = 1;
        }else{
             _scrollSegment.selectedSegmentIndex = 0;
        }
    }
}
-(void)tapImage:(UIPanGestureRecognizer *)pan{
    PhotoBrowserVM *browserVM = [[PhotoBrowserVM alloc] init];
    [browserVM tapImage:(UIImageView *)pan.view withTag:pan.view.tag withArrayImg:_dtoMode.windowImageList withMJPhotoBrowserDelegate:self];
}
@end
