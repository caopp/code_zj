//
//  CSPConsumptionPointsQuery TableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPConsumptionPointsQuery TableViewController.h"
#import "CSPIntegrationTableViewCell.h"
#import "CSPIntegratinDetailTableViewCell.h"
#import "GetMerchantIntegralLogDTO.h"
#import "GetMerchantIntegralByMonthDTO.h"
#import "CSPUtils.h"
#import "CPSOrderDetailsViewController.h"
#import "OrderDetaillViewController.h"

@interface CSPConsumptionPointsQuery_TableViewController ()
{
    NSMutableArray *listArray_;
}
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation CSPConsumptionPointsQuery_TableViewController
@synthesize listArray = listArray_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营业额积分查询";
    
    [self customBackBarButton];
    
    [self getTurnOverDetailDataRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.translucent = YES;
}


#pragma mark - HttpRequest

- (void)getTurnOverDetailDataRequest{
 
    if (_dateDTO.time==nil) {
        return;
    }
    
    NSString *time = _dateDTO.time;
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:100];
    
    [HttpManager sendHttpRequestForGetMerchantIntegralByMonth:time pageNo:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
             
               self.listArray = [[NSMutableArray alloc]init];
               
               NSDictionary *dataDic = [dic objectForKey:@"data"];
               
               NSArray *array = dataDic[@"list"];
               
               for (NSDictionary *tmpDic in array) {
                   
                   GetMerchantIntegralByMonthDTO *getMerchantIntegralByMonthDTO = [[GetMerchantIntegralByMonthDTO alloc] init];
                   
                   [getMerchantIntegralByMonthDTO setDictFrom:tmpDic];
                   
                   [self.listArray addObject:getMerchantIntegralByMonthDTO];
                   
               }
               
               [self.tableView reloadData];
            }
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
}

#pragma mark - TableView DataSource&Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        return self.listArray.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPIntegrationTableViewCell *integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    CSPIntegratinDetailTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegratinDetailTableViewCell"];
    
    if (!integrationCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPIntegrationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPIntegrationTableViewCell"];
        integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    }
    
    if (!otherCell) {

        [tableView registerNib:[UINib nibWithNibName:@"CSPIntegratinDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPIntegratinDetailTableViewCell"];

    }
    
    if (indexPath.section == 0) {
        integrationCell.titleLabel.text = [NSString stringWithFormat:@"%@总计",self.dateDTO.time] ;
        integrationCell.integrationLabel.text = self.dateDTO.integralNum.stringValue;
        integrationCell.enterImageView.hidden = YES;
        return integrationCell;
    }
    else{
        
        GetMerchantIntegralByMonthDTO *integralDTO = self.listArray[indexPath.row];
        otherCell.shopNameLabel.text = integralDTO.memberName;
        if ([integralDTO.orderCode integerValue]) {
            otherCell.orderNumber.text = [NSString stringWithFormat:@"采购单:%@",integralDTO.orderCode];
        }
        
        otherCell.dateLabel.text = integralDTO.time;
        
        if ([integralDTO.integralNum integerValue]) {
         
            otherCell.integrationNumberLabel.text = [NSString stringWithFormat:@"+%@",integralDTO.integralNum.stringValue];
        }
        
        return otherCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 128;
    }else
    {
        return 52;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return .1;
    }else
    {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section>0) {
     
        GetMerchantIntegralByMonthDTO *integralDTO = self.listArray[indexPath.row];
        
        OrderDetaillViewController * vc = [[OrderDetaillViewController alloc]init];
        vc.orderCode = integralDTO.orderCode;
        [self.navigationController pushViewController:vc animated:YES];

//        CPSOrderDetailsViewController *detailVC = [[CPSOrderDetailsViewController alloc]init];
//        
//        detailVC.orderCode = integralDTO.orderCode;
//        
//        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

@end
