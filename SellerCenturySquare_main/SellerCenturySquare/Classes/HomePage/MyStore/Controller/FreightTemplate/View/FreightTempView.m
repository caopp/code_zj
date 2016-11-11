//
//  FreightTempView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightTempView.h"
#import "UIColor+UIColor.h"
#import "KeyboardToolBarTextField.h"
#import "DefineTextField.h"

@interface FreightTempView ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)NSArray *arr;

@end

@implementation FreightTempView

-(void)awakeFromNib
{
    
    [self.selectedTypeButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
    self.selectedTypeButton.layer.borderWidth = 1;
    self.selectedTypeButton.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    [KeyboardToolBarTextField registerKeyboardToolBar:self.textField];
    
    
    [self.detailAresLabel setTextColor: [UIColor colorWithHexValue:0xeb301f alpha:1]];
    self.selectedTableView.dataSource = self;
    self.selectedTableView.delegate = self;
    self.selectedTableView.hidden = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView setImage:[UIImage imageNamed:@"登录_下拉"]];
  
}

- (IBAction)didClickSelectedEventAction:(UIButton *)sender {
    
    self.arr = [NSArray arrayWithObjects:@"按件数",@"按重量" ,nil];
    self.selectedTableView.hidden = NO;
     [self.imageView setImage:[UIImage imageNamed:@"登录_收回"]];
    [self.selectedTableView reloadData];
}

#pragma mark  tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }

    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, cell.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [cell addSubview:lineLabel];
    
    cell.textLabel.text = self.arr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if ([self.delegate respondsToSelector:@selector(selectedButtonTitle: section: buttonAction:)]) {
        
        [self.delegate selectedButtonTitle:self.arr[indexPath.row] section:self.section buttonAction:self.selectedTypeButton];
              
    }
    
    [self.imageView setImage:[UIImage imageNamed:@"登录_下拉"]];
    
    self.selectedTableView.hidden = YES;
    self.arr = nil;
    [self.selectedTableView reloadData];

    
    NSLog(@"点击显示东西");

}

//添加按重量进行筛选执行事件
- (IBAction)didClickCountButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(executedByWeight:)]) {
        [self.delegate executedByWeight:self.weightButton];
    }
}

//添加按件数进行筛选执行事件
- (IBAction)didClickWeightButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(executedByCount:)]) {
        [self.delegate executedByCount:self.countButton];
    }
    
}
@end
