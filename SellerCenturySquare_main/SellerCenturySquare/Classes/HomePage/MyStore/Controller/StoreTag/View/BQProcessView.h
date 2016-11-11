//
//  BQProcessView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    BQTagTypeNormal = 0,
    BQTagTypeError,
    BQTagTypeSuccess,
}BQTagType;

@protocol BQTagListViewDelegate <NSObject>

@optional
- (void)didBQSelectTagAtIndex:(NSUInteger)index;

@end
@interface BQTag : UIButton

@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) NSUInteger index;

- (instancetype)initWithText:(NSString *)text;
- (void)setTagType:(BQTagType)type;

@end


@interface BQProcessView : UIView
@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property (assign, nonatomic) id<BQTagListViewDelegate> delegate;
@property (strong,nonatomic)BQTag *bqTag;


- (instancetype)initWithWidth:(CGFloat)width contentArray:(NSMutableArray *)array;

- (BQTag *)desequeseTagAtIndex:(NSUInteger)index;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)resizeToWidth:(CGFloat)width;
@end
