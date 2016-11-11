//
//  PicChooseView.h
//  IMTest
//
//  Created by 王剑粟 on 15/6/29.
//
//

#import <UIKit/UIKit.h>
//聊天的类型
typedef enum {
    
    PlusType_Two = 0,    //没有推介按钮的
    PlusType_Three = 1   //有推介按钮的
    
} PlusType;

@protocol PicChooseDelegate <NSObject>

//button click
- (void)buttonAction:(NSInteger)index;

@end

@interface PicChooseView : UIView {
    
    UITapGestureRecognizer * photoTap;
    UITapGestureRecognizer * cameraTap;
    UITapGestureRecognizer * referralTap;
    
    float xoffsent;
}

@property (nonatomic, assign) id<PicChooseDelegate>delegate;
@property (nonatomic, assign) PlusType plusType;

- (instancetype)initWithFrame:(CGRect)frame withtype:(PlusType)type;

@end
