//
//  BatchTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "CSPDownLoadImageDTO.h"

@interface BatchTableViewCell : CSPBaseTableViewCell
{

    CSPDownLoadImageDTO * nowDownLoadImageDTO;


}
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

//!窗口图
@property (weak, nonatomic) IBOutlet UILabel *windowNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *windowSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowBtn;

//!客观图
@property (weak, nonatomic) IBOutlet UILabel *objectNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectSizeLabel;


@property (weak, nonatomic) IBOutlet UIButton *objectBtn;


@property(nonatomic,assign)BOOL isEditing;//!是否是编辑状态

-(void)configData:(CSPDownLoadImageDTO *)downLoadImageDTO withEditStatus:(BOOL)editStatus;

//!下载的block 传过去要下载的类型
@property(nonatomic,copy) void (^downloadBlock)(NSString *);

//!编辑状态下，选中 或者 取消选中 的时候返回给controller 计算算中的数量 返回的值是：是否选中
@property(nonatomic,copy) void(^changeSelectStatusInEditing)(BOOL);



@end
