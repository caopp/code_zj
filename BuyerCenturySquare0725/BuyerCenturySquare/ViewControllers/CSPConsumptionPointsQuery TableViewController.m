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
#import "GetIntegralListDTO.h"
#import "IntegralDTO.h"
#import "CSPUtils.h"

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
    
    self.title = @"消费积分查询";
    [self addCustombackButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [HttpManager sendHttpRequestForGetIntegralByMonthSuccess:self.dateDTO.time success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            GetIntegralListDTO *getIntegralListDTO = [[GetIntegralListDTO alloc ]init];
//            IntegralDTO *integralDTO = [[IntegralDTO alloc ]init];
            
            getIntegralListDTO.integralDTOList = [dic objectForKey:@"data"];
        
             self.listArray = [getIntegralListDTO.integralDTOList mutableCopy];
            
            [self.tableView reloadData];
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription] ]);
    }];

    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

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
        integrationCell.titleLabel.text = [NSString stringWithFormat:@"%@总计",[CSPUtils converDateString:self.dateDTO.time]] ;
//        integrationCell.integrationLabel.text = self.dateDTO.integralNum.stringValue;
        integrationCell.integrationLabel.text = [CSPUtils stringFromNumber:self.dateDTO.integralNum];
        integrationCell.enterImageView.hidden = YES;
        return integrationCell;
    }
    else{
        
        IntegralDTO *integralDTO = [[IntegralDTO alloc ]init];
        NSMutableDictionary *otherDic = self.listArray[indexPath.row];
        [integralDTO setDictFrom:otherDic];
        otherCell.shopNameLabel.text = integralDTO.merchantName;
        otherCell.orderNumber.text = [NSString stringWithFormat:@"采购单:%@",integralDTO.orderCode];
        otherCell.dateLabel.text = integralDTO.time;
        otherCell.integrationNumberLabel.text = [NSString stringWithFormat:@"+%@",[CSPUtils stringFromNumber:integralDTO.integralNum]];
//        otherCell.integrationNumberLabel.text = [CSPUtils stringFromNumber:integralDTO.integralNum];
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
        return 1;
    }else
    {
        return 10;
    }
}



@end
