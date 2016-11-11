//
//  CSPFeedBackTypeView.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"
#import "CSPFeedBackTypeDTO.h"
@interface CSPFeedBackTypeView : CSPBaseCustomView<UITableViewDataSource,UITableViewDelegate>
- (IBAction)removeView:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *feedBackTableView;

@property (strong,nonatomic)NSMutableArray *feedBackTypeArray;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,copy)void (^confirmBlock)(CSPFeedBackTypeDTO *feedBackTypeDTO);

@property (nonatomic,strong)CSPFeedBackTypeDTO *feedBackType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHight;

/**
 *  刷新UI
 */
- (void)reloadUI;

- (IBAction)confirmButtonClick:(id)sender;
@end
