//
//  NormalTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "NormalTableViewCell.h"
#import "HttpMacro.h"
#import "HttpManager.h"
@implementation NormalTableViewCell{
    
    NSString *memberNo;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeToBlackListState:(BOOL)blackListState{
    
    if (blackListState) {
        
        [_blackButton setTitle:@"移出黑名单" forState:UIControlStateNormal];
        [_blackButton setTitle:@"移出黑名单" forState:UIControlStateHighlighted];
        
    }else{
        
        [_blackButton setTitle:@"重发邀请码" forState:UIControlStateNormal];
        [_blackButton setTitle:@"重发邀请码" forState:UIControlStateHighlighted];
    }
}

- (IBAction)buttonClicked:(id)sender {
    
    if ([_blackButton.titleLabel.text isEqualToString:@"移出黑名单"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定将采购商从黑名单移出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = 10;
        
        [alertView show];
        
    }else{
        
        NSString *title = [NSString stringWithFormat:@"确定向手机号%@",_telephoneL.text];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:@"发送邀请码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = 20;
        
        [alertView show];
    }
}

- (void)setMemberDTO:(id)memberDTO{
    
    if ([memberDTO isMemberOfClass:[MemberBlackDTO class]]) {
        
        MemberBlackDTO *memberBlackDTO = (MemberBlackDTO*)memberDTO;
        
        _nameL.text = memberBlackDTO.memberName;
        
        _telephoneL.text = memberBlackDTO.mobileAccount;
        
        memberNo = memberBlackDTO.memberNo;
        
    }else if([memberDTO isMemberOfClass:[MemberInviteDTO class]]){
        
        MemberInviteDTO *memberInviteDTO = (MemberInviteDTO*)memberDTO;
        
        _nameL.text = memberInviteDTO.memberName;
        
        _telephoneL.text = memberInviteDTO.mobilePhone;
        
        memberNo = memberInviteDTO.memberNo;
    }
    
}

#pragma mark - HttpRequest
- (void)removeFromBlackListRequest{
    
    if (!memberNo) {
        return;
    }
    
    NSString *blackListFlag = @"0";
    
    [HttpManager sendHttpRequestForGetUpdateMemberBlackList: memberNo  blackListFlag:blackListFlag success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单设置接口  返回正常编码");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveFromBlackListNotification object:nil];
            
        }else{
            
            NSLog(@" 采购商-黑名单设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

- (void)resendInviteRequest{
    
    //重发邀请码 level为-1
    
    NSString *mobileList = [NSString stringWithFormat:@"%@,-1",_telephoneL.text];
    
    [HttpManager sendHttpRequestForMemberInvite:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-邀请接口 返回正常编码");
        }else{
            
            NSLog(@"采购商-邀请接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        [self tipAlertView:dic[@"errorMessage"]];
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberInvite 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

}

- (void)tipAlertView:(NSString*)msg{
    
    UIAlertView *tipView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    
    [tipView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10) {
        
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            [self removeFromBlackListRequest];
        }
        
    }else{
        
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            [self resendInviteRequest];
        }
        
    }
}

@end
