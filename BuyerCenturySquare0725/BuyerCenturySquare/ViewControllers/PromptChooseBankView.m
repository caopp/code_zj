//
//  PromptChooseBankView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PromptChooseBankView.h"
#import "ChooseBankViewCell.h"
#import "Masonry.h"

@interface PromptChooseBankView ()<UITableViewDataSource,UITableViewDelegate,PromptChooseBankDelegate,ChooseBankViewCellDelegate>

//数据源
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) NSIndexPath *recordIndexPath;
@property (nonatomic ,strong) UITableView *bankTableView;


@end
@implementation PromptChooseBankView

- (instancetype)initWithFrame:(CGRect)frame bankNames:(NSArray *)arr
{
    if (self = [super init]) {
        self.dataArr = [NSMutableArray array];
        
        
        if (arr.count==1) {
            NSString*bankName = [arr objectAtIndex:0];
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];

            [dataDic setObject:bankName forKey:@"bankName"];
            [dataDic setObject:@"no" forKey:@"choose"];
            [self.dataArr addObject:dataDic];
      }else
        {
            if (arr.count !=0) {
                for (NSString *bankName in arr) {
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    
                    [dataDic setObject:bankName forKey:@"bankName"];
                    [dataDic setObject:@"no" forKey:@"choose"];
                    [self.dataArr addObject:dataDic];
                    
                }
            }
        }
        
        [self makeUI];

        
    }
    return self;
}
- (void)makeUI
{
    UIView *showContentView = [[UIView alloc] init];
    [self addSubview:showContentView];
    [showContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@350);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    showContentView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *topView = [[UIView alloc] init];
    [showContentView addSubview:topView];
    topView.backgroundColor = [UIColor blackColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showContentView.mas_top);
        make.right.equalTo(showContentView.mas_right);
        make.left.equalTo(showContentView.mas_left);
        make.height.equalTo(@44);
    }];
    UILabel *promptContentLab = [[UILabel alloc] init];
    [topView addSubview:promptContentLab];
    promptContentLab.text = @"请选择银行";
//    SourceHanSansCN-Normal
    promptContentLab.font = [UIFont systemFontOfSize:14];
    promptContentLab.textColor = [UIColor whiteColor];
    [promptContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:deleBtn];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"dele_ban_view"] forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleteSelfViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).offset(-12);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
        
    }];
    
    UIView *middleView = [[UIView alloc] init];
    [showContentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(showContentView.mas_left);
        make.right.equalTo(showContentView.mas_right);
        make.height.equalTo(@262);
    }];
    
    UITableView *bankTableView = [[UITableView alloc] init];
    bankTableView.separatorStyle = NO;
    self.bankTableView = bankTableView;
    bankTableView.delegate = self;
    bankTableView.dataSource = self;
    [middleView addSubview:bankTableView];
    [bankTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(middleView);
        make.width.equalTo(middleView);
        
    }];
    
    
    UIView *bottomView = [[UIView alloc] init];
    [showContentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_bottom);
        make.left.equalTo(showContentView.mas_left);
        make.right.equalTo(showContentView.mas_right);
        make.height.equalTo(@44);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.height.equalTo(@0.5f);
    }];
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:clickBtn];
    [clickBtn setTitle:@"确定" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickChooseBankNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.bottom.equalTo(bottomView.mas_bottom);
        
    }];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*cellID = @"cell";
    ChooseBankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ChooseBankViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.delegate = self;
        
    }

    [cell showSeleAndBankNameDic:self.dataArr[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recordIndexPath) {
        NSDictionary *recDict = self.dataArr[self.recordIndexPath.row];
        [recDict setValue:@"no" forKey:@"choose"];
        [self.dataArr replaceObjectAtIndex:self.recordIndexPath.row withObject:recDict];
        
    }
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    [dict setValue:@"yes" forKey:@"choose"];
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:dict];
    self.recordIndexPath = indexPath;
    [self.bankTableView reloadData];
    
    
}

- (void)chooseBankCell:(ChooseBankViewCell *)cell
{
    
    NSIndexPath *indexPath = [self.bankTableView indexPathForCell:cell];
    
    if (self.recordIndexPath) {
        NSDictionary *recDict = self.dataArr[self.recordIndexPath.row];
        [recDict setValue:@"no" forKey:@"choose"];
        [self.dataArr replaceObjectAtIndex:self.recordIndexPath.row withObject:recDict];
        
    }
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    [dict setValue:@"yes" forKey:@"choose"];
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:dict];
    self.recordIndexPath = indexPath;
    [self.bankTableView reloadData];

}



//删除本视图
- (void)deleteSelfViewBtn:(UIButton *)btn
{
    [self.delegate PromptChooseDeleBankView:self];
    
}


//选择了某一个银行
- (void)clickChooseBankNameBtn:(UIButton *)btn
{
    if (!self.recordIndexPath) {
        return;
    }
    NSDictionary *dic = self.dataArr[self.recordIndexPath.row];
    [self.delegate promptChoosebankChooseBankView:self bankName:dic[@"bankName"]];
}


@end

