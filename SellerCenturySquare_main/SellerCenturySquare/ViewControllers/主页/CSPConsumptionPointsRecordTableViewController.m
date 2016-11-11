//
//  CSPConsumptionPointsRecordTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPConsumptionPointsRecordTableViewController.h"
#import "CSPConsumptionPointsQuery TableViewController.h"
#import "CSPIntegrationTableViewCell.h"
#import "GetMerchantIntegralLogDTO.h"
#import "CSPUtils.h"

@interface CSPConsumptionPointsRecordTableViewController ()



@end

@implementation CSPConsumptionPointsRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营业额积分记录";
    
    [self getTurnOverDataRequest];
    
    [self customBackBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self tabbarHidden:YES];
}

#pragma mark - HttpRequest
- (void)getTurnOverDataRequest{
    
    [HttpManager sendHttpRequestForGetMerchantIntegralLogList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
             
                _listArray = [[NSMutableArray alloc]init];
                
                NSArray *array = [dic objectForKey:@"data"];
                
                for (NSDictionary *tmpDic in array) {
                    
                    GetMerchantIntegralLogDTO *getMerchantIntegralLogDTO = [[GetMerchantIntegralLogDTO alloc] init];
                    
                    [getMerchantIntegralLogDTO setDictFrom:tmpDic];
                    
                    [_listArray addObject:getMerchantIntegralLogDTO];
                }
                
                [self.tableView reloadData];
            }
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.listArray.count == 1) {
        return 1;
    }else{
        return 2;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    if (self.listArray.count == 1) {
        return 1;
    }else{
        if (section == 0) {
            return 1;
        }else{
            return self.listArray.count -1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPIntegrationTableViewCell *integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    
    if (!integrationCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPIntegrationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPIntegrationTableViewCell"];
        integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    }
    
    if (!otherCell) {
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
    }
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (45-11)/2, 150, 11)];
    //        monthLabel.text = @"2015年5月";
    monthLabel.textColor = HEX_COLOR(0x666666FF);
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.font = [UIFont systemFontOfSize:11];
    [otherCell addSubview:monthLabel];
    
    UILabel *integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, (45-18)/2, 50, 18)];
    //        integrationLabel.text = @"5039";
    integrationLabel.textColor = HEX_COLOR(0x000000FF);
    integrationLabel.textAlignment = NSTextAlignmentRight;
    integrationLabel.font = [UIFont systemFontOfSize:18];
    [otherCell addSubview:integrationLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(350,(45-12)/2, 8, 12)];
    arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
    [otherCell addSubview:arrowImageView];
    
    GetMerchantIntegralLogDTO* currentMonthIntegralDTO;
    GetMerchantIntegralLogDTO *otherMonthDTO;
    
    if (self.listArray.count == 1) {
        currentMonthIntegralDTO = self.listArray[0];
//        integrationCell.titleLabel.text = currentMonthIntegralDTO.time;
        integrationCell.integrationLabel.text = currentMonthIntegralDTO.integralNum.stringValue;
        return integrationCell;
    }else{
        
        if (indexPath.section == 0) {
            currentMonthIntegralDTO = self.listArray[0];
//            integrationCell.titleLabel.text = currentMonthIntegralDTO.time;
            integrationCell.integrationLabel.text = currentMonthIntegralDTO.integralNum.stringValue;
            return integrationCell;
        }else{
            otherMonthDTO = self.listArray[indexPath.row+1];
            monthLabel.text = [CSPUtils converDateString:otherMonthDTO.time];
            integrationLabel.text = otherMonthDTO.integralNum.stringValue;
            return otherCell;
        }
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.listArray.count == 1) {
        return 128;
    }else
    {
        if (indexPath.section == 0) {
            return 128;
        }else
        {
            return 45;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.listArray.count == 1) {
        return 0.1;
    }else{
        if (section == 0) {
            return 0.1;
        }else
        {
            return 10;
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_listArray==nil) {
        [self alertWithAlertTip:@"未从后台获取到数据"];
        return;
    }
    
    CSPConsumptionPointsQuery_TableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsQuery_TableViewController"];
    if (self.listArray.count == 1) {
        
        GetMerchantIntegralLogDTO *currentMonthIntegralDTO  = self.listArray[indexPath.row];
        nextVC.dateDTO = currentMonthIntegralDTO;
    }else
    {
        if (indexPath.section == 0) {
            GetMerchantIntegralLogDTO *currentMonthIntegralDTO = self.listArray[0];
            nextVC.dateDTO = currentMonthIntegralDTO;

        }else{
            
            GetMerchantIntegralLogDTO *otherMonthDTO = self.listArray[indexPath.row+1];
            nextVC.dateDTO = otherMonthDTO;
        }
    }

    [self.navigationController pushViewController:nextVC animated:YES];
}




@end
