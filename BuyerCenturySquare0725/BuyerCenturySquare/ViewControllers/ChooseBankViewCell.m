//
//  ChooseBankViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ChooseBankViewCell.h"
#import "Masonry.h"
@interface ChooseBankViewCell ()

@property (nonatomic ,strong) UIButton *chooseBtn;
@property (nonatomic ,strong) UILabel *bankNameLab;

@end

@implementation ChooseBankViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chooseBtn = chooseBtn;
        [self addSubview:chooseBtn];
        
//        chooseBtn.userInteractionEnabled = YES;
//        chooseBtn.imageView.userInteractionEnabled = YES;
        [chooseBtn addTarget:self action:@selector(chooseBank) forControlEvents:UIControlEventTouchUpInside];
        
        [chooseBtn  setImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"topup_sel"]  forState:UIControlStateSelected];
        
//        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
//        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"topup_sel"] forState:UIControlStateSelected];
        
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@21);
            make.height.equalTo(@21);
        }];
        
        UILabel *bankNameLab = [[UILabel alloc] init];
        self.bankNameLab =bankNameLab;
        bankNameLab.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:bankNameLab];
        [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(chooseBtn.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-0.5f);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@0.5f);
            
        }];
        
        
        
    }
    return self;
}

- (void)chooseBank
{
    if ([self.delegate respondsToSelector:@selector(chooseBankCell:)]) {
        
        [self.delegate chooseBankCell:self];
        
    }
}
- (void)showSeleAndBankNameDic:(NSDictionary *)dic
{
    if ([dic[@"choose"] isEqualToString:@"yes"]) {
        self.chooseBtn.selected = YES;
    }else
    {
        self.chooseBtn.selected = NO;
    }
    
    self.bankNameLab.text = dic[@"bankName"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

