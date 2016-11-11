//
//  SBTagListView.m
//  SBTagListView
//
//  Created by 王志龙 on 15/9/16.
//  Copyright © 2015年 王志龙. All rights reserved.
//

#import "SBTagListView.h"
#import "UIColor+UIColor.h"


@interface SBTagListView()
@property (assign, nonatomic) NSUInteger linesOfTags;

@end
@implementation SBTagListView

- (instancetype)initWithWidth:(CGFloat)width contentArray:(NSMutableArray *)array {
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    if (self) {
        self.contentArray = array;
        self.tagsArray = [self generateTagsByStrings:self.contentArray];
        self.linesOfTags = [self generateLinesOfTags];
        self.frame = CGRectMake(0, 0, width, self.linesOfTags * 39);
        
        
        UILabel *genreLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 11)];
        genreLabel.text = @"风格";
        genreLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        genreLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:genreLabel];
        
    }
    return self;
}

#pragma mark view 
- (void)layoutSubviews {
    [self layoutTags];
}

- (void)reloadTags {
    NSArray *subviews = [self subviews];
    for (UIView *subvie in subviews) {
        [subvie removeFromSuperview];
    }
    [self layoutTags];
}

- (void)layoutTags {
    NSUInteger totalLines = 1;
    CGFloat currentTotalWidth = 0;
    for (NSUInteger i = 0; i < self.tagsArray.count; ++i) {
        SBTag *tag = self.tagsArray[i];

        currentTotalWidth += tag.frame.size.width + 4;
        if (currentTotalWidth >= self.frame.size.width) {
            if (currentTotalWidth == self.frame.size.width) {
                tag.frame = CGRectMake(currentTotalWidth - tag.frame.size.width, (totalLines -1) * 39 + 16, tag.frame.size.width, tag.frame.size.height);
                [self addSubview:tag];
            }
            totalLines++;
            if (currentTotalWidth > self.frame.size.width) {
                --i;
            }
            currentTotalWidth = 0;
            
        }else {
            tag.frame = CGRectMake(currentTotalWidth - tag.frame.size.width, (totalLines -1) * 39 + 16, tag.frame.size.width, tag.frame.size.height);
            [self addSubview:tag];
        }
    }
}


- (NSUInteger)generateLinesOfTags {
    NSUInteger totalLines = 1;
    CGFloat currentTotalWidth = 0;
    for (NSUInteger i = 0; i < self.tagsArray.count; ++i) {
        SBTag *tag = self.tagsArray[i];
        currentTotalWidth += tag.frame.size.width + 4;
        if (currentTotalWidth >= self.frame.size.width) {
            totalLines++;
            if (currentTotalWidth > self.frame.size.width) {
                --i;
            }
            currentTotalWidth = 0;
        }
    }
    return totalLines;
}

- (void)removeTagAtIndex:(NSUInteger)index {
    [self.tagsArray removeObject:[self desequeseTagAtIndex:index]];
    [self reloadTags];
}


- (void)resizeToWidth:(CGFloat)width {
    //已经是这么宽
    if (self.frame.size.width == width) {
        return;
    }
    //宽度小于一个tag，不能这么玩
    for (SBTag * tag in self.tagsArray) {
        if (width <= tag.frame.size.width) {
            NSLog(@"can not resize to the width smaller than a tag");
            return;
        }
    }
    //高度重新计算,比现在大要show出来
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    CGFloat height = [self generateLinesOfTags] * 39;
    if (height < self.frame.size.height) {
        height = self.frame.size.height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    [self reloadTags];
}

#pragma mark data
- (NSMutableArray *)generateTagsByStrings:(NSMutableArray *)array {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSUInteger i = 0;
    @autoreleasepool {
        for (NSString *tagString in self.contentArray) {
            SBTag *tag = [[SBTag alloc] initWithText:tagString];
            tag.index = i;
            [tag addTarget:self action:@selector(didTappedTag:) forControlEvents:UIControlEventTouchUpInside];
            if (tag.frame.size.width > self.frame.size.width) {
                NSLog(@"can not create a taglistview that the width smaller than his tags");
            }else {
                [resultArray addObject:tag];
                ++i;
            }
        }
    }
    return resultArray;
}

#pragma SEL
- (void)didTappedTag:(SBTag *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectTagAtIndex:)]) {
        [self.delegate didSelectTagAtIndex:sender.index];
    }
}
- (SBTag *)desequeseTagAtIndex:(NSUInteger)index {
    for (SBTag *tag in self.tagsArray) {
        if (tag.index == index) {
            return tag;
        }
    }
    return nil;
}
@end

@implementation SBTag

- (instancetype)initWithText:(NSString *)text {
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self = [super initWithFrame:CGRectMake(0, 0, contentSize.width + 20, 30)];
    if (self) {
        self.text = text;
        
        //初始化地方进行修改
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        
        [self setTitle:self.text forState:(UIControlStateNormal)];
        [self  setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
        self.font = [UIFont systemFontOfSize:13];
        
        

    }
    return self;
}



- (void)setNormal {
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderWidth = 1;
     [self  setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    
}
- (void)setError {
    self.backgroundColor = [UIColor whiteColor];
     [self  setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
}


- (void)setSuccess {

    self.backgroundColor = [UIColor redColor];
    
}

- (void)setTagType:(SBTagType)type {
    switch (type) {
        case SBTagTypeNormal:
            [self setNormal];
            break;
        case SBTagTypeSuccess:
            [self setSuccess];
            break;
        case SBTagTypeError:
            [self setError];
            break;
        default:
            [self setNormal];
            break;
    }
}

@end