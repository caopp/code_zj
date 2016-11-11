//
//  MyOrderPromptView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/6.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MyOrderPromptView.h"
#import "Masonry.h"
#import "MyOrderPromptTableViewCell.h"


@interface MyOrderPromptView ()<UITableViewDataSource ,UITableViewDelegate>


@property (nonatomic ,strong) UITableView *orderTableView;
@property (nonatomic ,strong) UIView*promptView;




@end
@implementation MyOrderPromptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    if (self = [super init]) {
        
        UIView *promptView = [[UIView alloc] init];
        promptView.backgroundColor  = [UIColor whiteColor];
        self.promptView  = promptView;
        [self addSubview:promptView];
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY).offset(-70);
            make.height.equalTo(@350);
        }];
        
        
        promptView.layer.cornerRadius = 10;
        promptView.layer.masksToBounds = YES;
        

        
        UIView *titleView = [[UIView alloc] init];
        [promptView addSubview:titleView];
        titleView.backgroundColor =[UIColor colorWithHexValue:0x000000 alpha:1];
        
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(promptView.mas_top);
            make.right.equalTo(promptView.mas_right);
            make.left.equalTo(promptView.mas_left);
            make.height.equalTo(@40);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = @"提示";
        [titleView addSubview:titleLab];
//        titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:19];
        titleLab.font = [UIFont systemFontOfSize:19];

        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleView.mas_centerX);
            make.centerY.equalTo(titleView.mas_centerY);
            make.height.equalTo(@40);
            
        }];
        
        
        UIButton *cancenlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleView addSubview:cancenlBtn];
        [cancenlBtn setImage:[UIImage imageNamed:@"dele_ban_view"] forState:UIControlStateNormal];
        [cancenlBtn addTarget:self action:@selector(selectCancenlBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cancenlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleView.mas_centerY);
            make.right.equalTo(titleView.mas_right);
            make.height.equalTo(titleView.mas_height);
            make.width.equalTo(@40);
        }];
        
        
        self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        self.orderTableView.delegate = self;
        self.orderTableView.dataSource = self;
        self.orderTableView.backgroundColor = [UIColor whiteColor];
        
        [promptView addSubview:self.orderTableView];
        
        [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom);
            make.left.equalTo(promptView.mas_left);
            make.right.equalTo(promptView.mas_right);
            make.bottom.equalTo(promptView.mas_bottom).offset(-30);
        }];
        
   
    }
    return self;
}

- (void)selectCancenlBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(myOrderPromptClearView:)]) {
        [self.delegate myOrderPromptClearView:self];
        
    }
}


- (void) selectContinuePayBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(myOrderPromptPayMoney: view:)]) {
        [self.delegate myOrderPromptPayMoney:self.recordOrderDto.canPayOrdersArr view:self];

    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
//    if (self.recordOrderDto.cannotPayOrdersArr.count>0&&self.recordOrderDto.canPayOrdersArr.count>0) {
//        return 2;
//    }
//    
//    if (self.recordOrderDto.cannotPayOrdersArr.count>0||self.recordOrderDto.canPayOrdersArr.count>0) {
//        return 2;
//    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (self.recordOrderDto.canPayOrdersArr.count>0) {
            return self.recordOrderDto.canPayOrdersArr.count;
        }
    }

    
    if (section ==1) {
        if (self.recordOrderDto.cannotPayOrdersArr.count>0) {
            return self.recordOrderDto.cannotPayOrdersArr.count;
        }
        
    }
    
  
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyOrderPromptTableViewCellId";
    
    MyOrderPromptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderPromptTableViewCell" owner:nil options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        cell.canDto = self.recordOrderDto.canPayOrdersArr[indexPath.row];
    }
    
    if (indexPath.section == 1) {
        cell.cannnotDto = self.recordOrderDto.cannotPayOrdersArr[indexPath.row];
    }
    
    

    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
    
//    if (self.recordOrderDto.canPayOrdersArr>0) {
        
    
    UIView *headerView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [headerView addSubview:label];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        label.font = [UIFont systemFontOfSize:17];

        
    label.numberOfLines =2;
    NSInteger numb = self.recordOrderDto.canPayOrdersArr.count;
        
    label.text = @"您勾选了9个采购单，其中5个采购单可正常";
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.top.equalTo(headerView.mas_top);
        make.bottom.equalTo(headerView.mas_bottom);
        NSInteger totalNum = self.recordOrderDto.canPayOrdersArr.count+self.recordOrderDto.cannotPayOrdersArr.count;
        
        
//        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您勾选了%ld个采购单，其中",(long)totalNum] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]}];
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您勾选了%ld个采购单，其中",(long)totalNum] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];

        
        NSString *goodsPriceString = [NSString stringWithFormat:@"%ld个",(long)numb];
//        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xeb301f alpha:1]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xeb301f alpha:1]}];

        
//        NSMutableAttributedString* lastPriceString = [[NSMutableAttributedString alloc]initWithString:@"采购单可正常付款。" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]}];
        NSMutableAttributedString* lastPriceString = [[NSMutableAttributedString alloc]initWithString:@"采购单可正常付款。" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];

        
        [priceString appendAttributedString:priceValueString];
        [priceString appendAttributedString:lastPriceString];
        label.attributedText = priceString;
        
        
        

        

        
    }];
        return headerView;
//    }
    
}
    
    if (section == 1) {
        
    
//    if (self.recordOrderDto.cannotPayOrdersArr.count>0) {
        UIView *footerView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        [footerView addSubview:label];
        
        
        UILabel *line = [[UILabel alloc] init];
        [footerView addSubview:line];
        
//        line.hidden = YES;
        line.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left);
            make.right.equalTo(footerView.mas_right);
            make.top.equalTo(footerView.mas_top);
            make.height.equalTo(@0.5f);
            
        }];
        
        
//        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.font = [UIFont systemFontOfSize:14];

        label.numberOfLines =2;
        
        label.text = @"以下4个采购单商品价格已变化，采购单已失效，如需订购请重新下单";
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(15);
            make.right.equalTo(footerView.mas_right).offset(-15);
            make.top.equalTo(footerView.mas_top);
            make.bottom.equalTo(footerView.mas_bottom);
            
        }];
        NSInteger numb = self.recordOrderDto.cannotPayOrdersArr.count;
        
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"以下"] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        
        NSString *goodsPriceString = [NSString stringWithFormat:@"%ld个",(long)numb];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xeb301f alpha:1]}];
        
//        [UIFont systemFontOfSize:14]
//        NSMutableAttributedString* lastPriceString = [[NSMutableAttributedString alloc]initWithString:@"采购单内商品价格已变化，如仍需订购请重新下单！" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14]}];
        NSMutableAttributedString* lastPriceString = [[NSMutableAttributedString alloc]initWithString:@"采购单内商品价格已变化，如仍需订购请重新下单！" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

        
        [priceString appendAttributedString:priceValueString];
        [priceString appendAttributedString:lastPriceString];
        label.attributedText = priceString;
        

        
        
        
        return footerView;
        
        }
//    }
    
    return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section ==0) {
        
    
//    if (self.recordOrderDto.canPayOrdersArr.count>0) {

    CGFloat height = [self gainFontWidthContent:@"您勾选了9个采购单，其中5个采购单可正常付款" font:17];
    
    return 30+height;
//    }
        
}
    
    if (section == 1) {
//        if (self.recordOrderDto.cannotPayOrdersArr.count>0) {
            CGFloat height = [self gainFontWidthContent:@"以下4个采购单商品价格已变化，采购单已失效，如需订购请重新下单" font:14];
            return 20+height;

//        }
    }
    return 0.1f;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    

    if (section == 0) {
        
    
    if (self.recordOrderDto.canPayOrdersArr.count>0) {
        UIView *footerView = [[UIView alloc] init];
        UILabel *lineLab = [[UILabel alloc] init];
        [footerView addSubview:lineLab];
        lineLab.hidden = YES;
        
        lineLab.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(15);
            make.right.equalTo(footerView.mas_right).offset(-15);
            make.bottom.equalTo(footerView.mas_bottom);
            make.height.equalTo(@0.5f);
        }];
        
        UIButton *continuePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:continuePayBtn];
        [continuePayBtn setTitle:@"继续付款" forState:UIControlStateNormal];
//        continuePayBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        continuePayBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        [continuePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [continuePayBtn addTarget:self action:@selector(selectContinuePayBtn:) forControlEvents:UIControlEventTouchUpInside];
        continuePayBtn.backgroundColor = [UIColor blackColor];
        continuePayBtn.layer.masksToBounds = YES;
        continuePayBtn.layer.cornerRadius = 2;
        
        
        [continuePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView.mas_centerX);
            make.centerY.equalTo(footerView.mas_centerY);
            make.height.equalTo(@27);
            make.width.equalTo(@100);
            
        }];
        
        
        
        
        return footerView;
    }
        }
    
    return nil;
}



- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (self.recordOrderDto.canPayOrdersArr.count>0) {
            return 64;
        }
    }
    CGFloat height = [self gainFontWidthContent:@"以下4个采购单商品价格已变化，采购单已失效，如需订购请重新下单" font:14];

    return 0.1f;
}



/**
 *  计算字体宽度
 *
 *  @param content 输入的内容
 *
 *  @return 返回字体的宽度
 */
- (CGFloat)gainFontWidthContent:(NSString *)content font:(CGFloat)font
{
    CGSize size;
    
    CGFloat width = self.frame.size.width-120;
    size=[content boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:font]} context:nil].size;
    return size.height;
    
    
}

- (void)setOrderDto:(OrderAddDTO *)orderDto
{
        self.recordOrderDto = orderDto;
    
        [self.orderTableView reloadData];
}






@end
