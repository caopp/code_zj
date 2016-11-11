//
//  RetailOrderDetailController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/7/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RetailOrderDetailController.h"
#import "FreightIntegralTableViewCell.h"//!运费及使用积分抵扣的金额

@interface RetailOrderDetailController ()

@end

@implementation RetailOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"零售订单详情";
    
}

#pragma mark 重写父类的方法
-(void)makeBottom{

    [super makeBottom];

    if ([orderStatus intValue] == 1) {//!待付款,无底部的修改订单总价
        
        [obligationBottomView removeFromSuperview];
        
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;//!一段是商品的、一段是运费及抵扣积分的、一段 是发货信息的
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {//!运费及积分段
        
        if ([detailDTO.integralAmount doubleValue]) {//!有进行积分抵扣，就显示出抵扣的积分
            
            return 2;
            
        }else{
        
            return 1;
        }
        
    }else if (section == 2) {//!发货信息段
        
        return [self alertRowNum];
        
        
    }else{//!商品信息段
        
        
        return detailDTO.goodsList.count;
        
    }
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
    }
    if (indexPath.section == 0) {//!商品信息段
        
        if (detailDTO.goodsList.count > 0) {
            
            return [self goodsTableViewCell:indexPath isFremRetail:YES];
        }
        
    }else if (indexPath.section == 1){//!运费以及积分段
    
        FreightIntegralTableViewCell * freightCell = [[[NSBundle mainBundle]loadNibNamed:@"FreightIntegralTableViewCell" owner:self options:nil]lastObject];
        
        [freightCell configData:detailDTO withScore:indexPath.row];//!运费第0行 == NO，积分第1行 == yes
        
        freightCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return freightCell;
        
    
    }else if(indexPath.section == 2){//!发货信息
        
        
        return [self alertTableViewCell:indexPath];
        
    }
    
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {//!商品信息段
        
        return [self goodsCellHight:indexPath];
        
    }else if(indexPath.section == 1){//!积分段
    
        return 44;
        
    
    }else{//!发货信息
        
        return [self alertCellHight:indexPath];
        
    }
    
    return 100;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1 || section == 2) {//!积分及运费段、发货信息段
        
        UIView * sectionTwoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 9)];
        
        [sectionTwoView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
        
        return sectionTwoView;
        
    }
    
    if (!headerView) {
        
        headerView = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailHeaderView" owner:nil options:nil]lastObject];
        
        __weak OrderDetaillViewController * detailVC = self;
        //!客服按钮
        headerView.customBtnClickBlock = ^(){
            
            [detailVC customService];
            
        };
        
    }
    //! 零售单无“期货、现货”、无客服
    [headerView configDataInRetail:detailDTO];
    
    
    return headerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 || section == 2) {//!积分及运费段、发货信息段
        
        return 9;
        
    }
    
    return [self addressHeaderViewHight];//!收货地址headerView的高度
    
    
}

//!批发是：采购单取消时间  零售是：订单取消时间
-(NSString *)getCanacelStr
{
    return @"订单取消时间：";

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
