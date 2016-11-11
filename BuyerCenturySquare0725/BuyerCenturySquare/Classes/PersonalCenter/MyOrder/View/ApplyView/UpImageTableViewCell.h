//
//  UpImageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpImageTableViewCell : UITableViewCell

//!上传图片的block 传过去的是选择的第几个按钮
@property(nonatomic,copy) void(^selectImageBlock)(NSInteger selectNum);

//!删除图片的blocl 传过去的是选择的第几个按钮
@property(nonatomic,copy) void(^deleteImageBlock)(NSInteger selectNum);


//!上传图片按钮的背景
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upImageBackViewHight;

//!根据图片张数 显示按钮的个数
-(void)setImageBtnNumWithArray:(NSMutableArray *)imageArray;



@end
