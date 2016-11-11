//
//  AccordingToTimeTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "AccordingToTimeTableViewCell.h"

@implementation AccordingToTimeTableViewCell
{
    
    BOOL accordingTime;
    NSString *telNum;
    
}

- (void)awakeFromNib {
    // Initialization code
    [_shopLevelBtn.layer setMasksToBounds:YES];
    [_shopLevelBtn.layer setCornerRadius:2.5];
    
    [_tradeLevelBtn.layer setMasksToBounds:YES];
    [_tradeLevelBtn.layer setCornerRadius:2.5];
    
    _IMInfo = [[NSMutableDictionary alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeToAccordingTime{
    
    accordingTime = YES;
}

- (void)changeToAccordingMoney{
    
    accordingTime = NO;
}


- (IBAction)call:(id)sender {
    
    NSString *tel = [NSString stringWithFormat:@"确定拨打电话%@",telNum];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (IBAction)IM:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kAccordingToTimeTableViewCellToIM object:nil userInfo:_IMInfo];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        NSString *num = [NSString stringWithFormat:@"tel://%@",telNum];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}


- (void)setMemberDTO:(id)memberDTO{
    
    NSDate *date = [[NSDate alloc]init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    if ([memberDTO isMemberOfClass:[MemberTradeDTO class]]) {
        
        MemberTradeDTO *memberTradeDTO = (MemberTradeDTO*)memberDTO;
        
        [_IMInfo setObject:memberTradeDTO.nickName forKey:@"name"];
        [_IMInfo setObject:memberTradeDTO.chatAccount forKey:@"JID"];
        
        
        _nameL.text = memberTradeDTO.memberName;
        
        _telephoneL.text = [NSString stringWithFormat:@"手机：%@",memberTradeDTO.mobilePhone];
        
        telNum = memberTradeDTO.mobilePhone;
        
        [_shopLevelBtn setTitle:[NSString stringWithFormat:@"V%@",memberTradeDTO.shopLevel] forState:UIControlStateNormal];
        
        [_tradeLevelBtn setTitle:[NSString stringWithFormat:@"V%@",memberTradeDTO.tradeLevel] forState:UIControlStateNormal];
        
        date = [formatter dateFromString:[NSString stringWithFormat:@"%@",memberTradeDTO.time]];
        
        if (date) {
            _transactionL.text = [NSString stringWithFormat:@"最新交易时间：%@",[newFormatter stringFromDate:date]];
        }else{
            _transactionL.text = @"";
        }
        
        if (accordingTime) {
            
            if (memberTradeDTO.time) {
                
                _redTitleL.text = [newFormatter stringFromDate:date];
            }
        
        }else{
            
            float price_f = [memberTradeDTO.amount floatValue];
            
            _redTitleL.text = [NSString stringWithFormat:@"¥%.2lf",price_f];
            
            _redTitleL.adjustsFontSizeToFitWidth = YES;
        }
    }else if ([memberDTO isMemberOfClass:[MemberInviteDTO class]]){
        
        MemberInviteDTO *memberInviteDTO = (MemberInviteDTO*)memberDTO;
        
        [_IMInfo setObject:memberInviteDTO.nickName forKey:@"name"];
        [_IMInfo setObject:memberInviteDTO.chatAccount forKey:@"JID"];
        
        _nameL.text = memberInviteDTO.memberName;
        
        _telephoneL.text = [NSString stringWithFormat:@"手机：%@",memberInviteDTO.mobilePhone];
        
        telNum = memberInviteDTO.mobilePhone;
        
        [_shopLevelBtn setTitle:[NSString stringWithFormat:@"V%@",memberInviteDTO.shopLevel] forState:UIControlStateNormal];
        
        [_tradeLevelBtn setTitle:[NSString stringWithFormat:@"V%@",memberInviteDTO.tradeLevel] forState:UIControlStateNormal];
        
        date = [formatter dateFromString:memberInviteDTO.time];
        
        if (date) {
            _transactionL.text = [NSString stringWithFormat:@"最新交易时间：%@",[newFormatter stringFromDate:date]];
        }else{
            _transactionL.text = @"";
        }
        
        if (accordingTime) {
            
            _redTitleL.text = [newFormatter stringFromDate:date];
        }else{
            
            float price_f = [memberInviteDTO.amount floatValue];
            
            _redTitleL.text = [NSString stringWithFormat:@"¥%.2lf",price_f];
            
            _redTitleL.adjustsFontSizeToFitWidth = YES;
        }
    }
    
    
}

@end
