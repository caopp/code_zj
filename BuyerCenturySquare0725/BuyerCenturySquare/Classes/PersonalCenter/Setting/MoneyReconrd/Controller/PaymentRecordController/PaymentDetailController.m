//
//  PaymentDetailController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PaymentDetailController.h"
#import "PayDetailHeaderView.h"//!header
#import "PayDetailFooterView.h"//!footer
#import "PayDetailCell.h"//!详细信息cell
#import "LoginDTO.h"
#import "CreditTransferDTO.h"
#import "GUAAlertView.h"
#import "BankCardViewController.h"//!重新提交进入的页面

@interface PaymentDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;

    //!header
    PayDetailHeaderView * hederView;
    //!footer
    PayDetailFooterView * footerView;
    
    //!左边的数据
    NSArray * leftTitleArray;
    
    //!右导航
    UIButton *rightBtn;
    
    //!重新提交
    UIButton * resubmitBtn;
    
    CreditTransferDTO * transferDTO;
    
    
    
}
@end

@implementation PaymentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    //!导航
    [self createNav];

    leftTitleArray = @[@"审核单编号",@"转出银行",@"转出账户名",@"转账金额",@"提交时间",@"核帐通过"];
    
    //!创建tableView
    [self createTableView];

    //!请求数据
    [self getData];
    
    //!审核不通过再显示删除 和重新提交按钮
    rightBtn.hidden = YES;
    resubmitBtn.hidden = YES;
    
    
}
#pragma mark 创建导航
-(void)createNav{
    
    self.title = @"转账记录查询";
    //!左导航
    [self addCustombackButtonItem];
    
    //!右导航
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 18, 22)];
    [rightBtn addTarget:self action:@selector(deleteClcik) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"pay_delete"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.view endEditing:YES];
    
    //!点击返回按钮的时候，如果是从列表进入，则返回上一层，其他情况返回 个人中心主页
    if (self.isFromList) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
    
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.rdv_tabBarController setSelectedIndex:4];
    
    }
    
    
}

#pragma mark 创建tableView
-(void)createTableView{
    
    //!!!!!!!!!改大小
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    //!重新提交按钮
    resubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resubmitBtn.frame = CGRectMake(0, self.view.frame.size.height -  54 - self.navigationController.navigationBar.frame.size.height -20, self.view.frame.size.width,54);
    [resubmitBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    [resubmitBtn setBackgroundColor:[UIColor blackColor]];
    [resubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resubmitBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [resubmitBtn addTarget:self action:@selector(resubmitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resubmitBtn];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (transferDTO) {
        //!如果返回0  则说明这次充值没有升级 不显示升级提醒这一行
        //!审核不通过  也不显示这一行(transferDTO.auditSatus==3)
        if ([transferDTO.level isEqualToString:@"0"] || [transferDTO.auditStatus isEqualToString:@"3"]) {
            
            return 5;

        }else{
        
            return 6;
        }

    }else{
    
        return 0;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PayDetailCell" owner:nil options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    if (indexPath.row == 5) {
        
        //!是否显示这一级已经在段行数处判断(审核未通过、审核通过不升级 不显示这一行)
        
        //!0待审核，1暂未到账，2通过，3未通过
        
        //!待核帐、暂未到账：核帐通过后，您的等级将升至V?
        
        //!审核通过：核帐通过，您的等级升至V?
        
        if ([transferDTO.auditStatus isEqualToString:@"0"] || [transferDTO.auditStatus isEqualToString:@"1"]) {
        
            NSString *contentStr = [NSString stringWithFormat:@"核帐通过后，您的等级将升至%@",transferDTO.level];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
            //设置：把V？变成紫色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0x763ab7 alpha:1] range:NSMakeRange(13, 2)];
            
            [cell configInfo:str];
            
        }else if ([transferDTO.auditStatus isEqualToString:@"2"]){
        
            NSString *contentStr = [NSString stringWithFormat:@"核帐通过，您的等级升至%@",transferDTO.level];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
            //设置：把V？变成紫色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0x763ab7 alpha:1] range:NSMakeRange(11, 2)];
            
            [cell configInfo:str];
        
        }
        
        
    }else{
        
        NSString *detail = @"";
        
        switch (indexPath.row) {
            case 0://!审核单编号
                
                detail = transferDTO.auditNo;
                break;
            case 1://!转出银行
                
                detail = transferDTO.bankName;
                break;
            case 2://!转出银行开户人姓名
                detail = transferDTO.userName;
                break;
            case 3://!转账金额
                detail = [NSString stringWithFormat:@"%.2f元",transferDTO.amount];
                break;
            case 4://!提交时间
                detail = transferDTO.createDate;
                break;
            default:
                break;
        }
    
        [cell configInfo:leftTitleArray[indexPath.row] withDetailInfo:detail];
        
        
    }
    
    
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (!hederView) {
        
        hederView = [[[NSBundle mainBundle]loadNibNamed:@"PayDetailHeaderView" owner:nil options:nil]lastObject];
    }
    
    [hederView configInfo:transferDTO];

    return hederView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 171;

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{


    if (!footerView) {
        
        footerView = [[[NSBundle mainBundle]loadNibNamed:@"PayDetailFooterView" owner:nil options:nil]lastObject];
        
    }

    //!审核通过 不显示底部
    if ([transferDTO.auditStatus isEqualToString:@"2"]) {
        
        UIView * passFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [passFooterView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
        
        return passFooterView;
        
        
    }
    return footerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    //!审核通过 不显示底部
    if ([transferDTO.auditStatus isEqualToString:@"2"]) {
        
        return 0.000;

    }
    
    return 167;

}
#pragma mark 重新提交  进入重新填写界面
-(void)resubmitClick{
    
    /*
     “转出银行”、“转出银行卡开户人姓名”及“转账金额”
     
     */
    
    [self progressHUDHiddenWidthString:@"请求中"];
    
    resubmitBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForPaymentUpgradeListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        resubmitBtn.enabled = YES;
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
        
            BalanceChangeBto *balanceChange = [[BalanceChangeBto alloc] init];
            
            [balanceChange setDictFrom:dic[@"data"]];

            BankCardViewController *cardVC = [[BankCardViewController alloc]init];
            cardVC.creditDto = transferDTO;
            cardVC.balanceDto = balanceChange;
            cardVC.changeMoneyTF = YES;
            
            [self.navigationController pushViewController:cardVC animated:YES];
        
            [self progressHUDHiddenWidthString:@"请求成功"];
            
        }else{
        
            [self progressHUDHiddenWidthString:@"请求失败"];

        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        resubmitBtn.enabled = YES;

        [self progressHUDHiddenWidthString:@"请求失败"];
        
    }];
    
    
  
    
    
}

#pragma mark 请求数据
-(void)getData{

    NSDictionary *upDic = @{@"auditNo":self.auditNo,
                            @"tokenId":[LoginDTO sharedInstance].tokenId};
    
    [HttpManager sendHttpRequestForCreditTransferDetail:upDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            transferDTO = [[CreditTransferDTO alloc]initWithDictionary:dic[@"data"]];
        
            //!审核未通过（3），显示重新提交 和删除按钮 ;改变tableView的高度，不让重新提交按钮遮住tableView底部的文字
            if ([transferDTO.auditStatus isEqualToString:@"3"]) {
                
                rightBtn.hidden = NO;
                resubmitBtn.hidden = NO;
                _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 54 );
                
                
            }
            
            
            [_tableView reloadData];
        
        }else{
        
            [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];
        
    }];


}
#pragma mark !删除事件
-(void)deleteClcik{
    
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定删除?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        [self deletePost];
        
    } dismissAction:nil];
    
    [alertView show];
    
    
    
}

-(void)deletePost{

    NSDictionary *upDic = @{@"tokenId":[LoginDTO sharedInstance].tokenId,
                            @"auditNo":transferDTO.auditNo
                            
                            };
    
    [self progressHUDShowWithString:@"删除中"];
    
    [HttpManager sendHttpRequestForDeleteCreditTransfer:upDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
        
            [self progressHUDHiddenWidthString:@"删除成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        
            [self progressHUDHiddenWidthString:@"删除失败"];
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self progressHUDHiddenWidthString:@"删除失败"];
        
    }];
    
    
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
