//
//  CSPConsumptionPointsRecordTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPConsumptionPointsRecordTableViewController.h"
#import "CSPIntegrationTableViewCell.h"
#import "CSPConsumptionPointsQuery TableViewController.h"
#import "GetIntegralListDTO.h"
#import "IntegralByMonthDTO.h"
#import "CSPUtils.h"



@interface CSPConsumptionPointsRecordTableViewController ()
{
    GetIntegralListDTO* getIntegralListDTO;
   
    
}
@end

@implementation CSPConsumptionPointsRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费积分记录";
    [self addCustombackButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //消费记录积分查询
    [HttpManager sendHttpRequestForGetIntegralListWithTime:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            getIntegralListDTO = [[GetIntegralListDTO alloc] init];
            IntegralByMonthDTO* integralDTO = [[IntegralByMonthDTO alloc] init];
            getIntegralListDTO.integralDTOList = [dic objectForKey:@"data"];
            
            if (getIntegralListDTO.integralDTOList.count>0) {
                NSMutableDictionary *otherDic = getIntegralListDTO.integralDTOList[0];
                [integralDTO setDictFrom:otherDic];
                
                _listArray = getIntegralListDTO.integralDTOList;

                //自适应label
//                self.integrationLabel.text = [CSPUtils stringFromNumber:integralDTO.integralNum];
//                UIFont *fnt = [UIFont fontWithName:@"TwCenMT-Regular" size:10];
//                self.integrationLabel.font = fnt;
//                self.integrationLabel.numberOfLines = 1;
//                self.integrationLabel.lineBreakMode = NSLineBreakByWordWrapping;
//                CGRect tmpRect = [self.integrationLabel.text boundingRectWithSize:CGSizeMake(400, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
//                self.intergrationLabelWidthConstraint.constant = tmpRect.size.width+8;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
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
    CSPBaseTableViewCell *otherCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *monthLabel;
    UILabel *integrationLabel;

    if (!integrationCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPIntegrationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPIntegrationTableViewCell"];
        integrationCell = [tableView dequeueReusableCellWithIdentifier:@"CSPIntegrationTableViewCell"];
    }
    
    if (!otherCell) {
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (45-11)/2, 150, 11)];
        //        monthLabel.text = @"2015年5月";
        monthLabel.textColor = HEX_COLOR(0x666666FF);
        monthLabel.textAlignment = NSTextAlignmentLeft;
        monthLabel.font = [UIFont systemFontOfSize:11];
        [otherCell addSubview:monthLabel];
        
        
        integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-8-100-15, (45-18)/2, 100, 18)];
        //        integrationLabel.text = @"5039";
        integrationLabel.textColor = HEX_COLOR(0x000000FF);
        integrationLabel.textAlignment = NSTextAlignmentRight;
        integrationLabel.font = [UIFont systemFontOfSize:18];
        [otherCell addSubview:integrationLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -8-15,(44-12)/2, 8, 12)];
        arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
        [otherCell addSubview:arrowImageView];
    }

    IntegralByMonthDTO* currentMonthIntegralDTO;
    IntegralByMonthDTO *otherMonthDTO;
    
    if (self.listArray.count == 1) {
        NSMutableDictionary *Dictionary = self.listArray[0];
        currentMonthIntegralDTO = [[IntegralByMonthDTO alloc] init];
        [currentMonthIntegralDTO setDictFrom:Dictionary];
//        integrationCell.titleLabel.text = currentMonthIntegralDTO.time;
//        integrationCell.integrationLabel.text = currentMonthIntegralDTO.integralNum.stringValue;
        
        integrationCell.integrationLabel.text = [CSPUtils stringFromNumber:currentMonthIntegralDTO.integralNum];
        return integrationCell;
    }else{
        
        if (indexPath.section == 0) {
            NSMutableDictionary *Dictionary = self.listArray[0];
            currentMonthIntegralDTO = [[IntegralByMonthDTO alloc] init];
            [currentMonthIntegralDTO setDictFrom:Dictionary];
//            integrationCell.titleLabel.text = currentMonthIntegralDTO.time;
//            integrationCell.integrationLabel.text = currentMonthIntegralDTO.integralNum.stringValue;
            integrationCell.integrationLabel.text = [CSPUtils stringFromNumber:currentMonthIntegralDTO.integralNum];
            
            return integrationCell;
        }else{
            NSMutableDictionary *otherDic = self.listArray[indexPath.row+1];
            otherMonthDTO = [[IntegralByMonthDTO alloc]init];
            [otherMonthDTO setDictFrom:otherDic];
            monthLabel.text = [CSPUtils converDateString:otherMonthDTO.time];
//            integrationLabel.text = otherMonthDTO.integralNum.stringValue;
            integrationLabel.text = [CSPUtils stringFromNumber:otherMonthDTO.integralNum];
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
        return 1;
    }else{
        if (section == 0) {
            return 1;
        }else
        {
            return 10;
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CSPConsumptionPointsQuery_TableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPConsumptionPointsQuery_TableViewController"];
    if (self.listArray.count == 1) {
        NSMutableDictionary *Dictionary = self.listArray[indexPath.row];
       IntegralByMonthDTO *currentMonthIntegralDTO = [[IntegralByMonthDTO alloc] init];
        [currentMonthIntegralDTO setDictFrom:Dictionary];
        nextVC.dateDTO = currentMonthIntegralDTO;
    }else
    {
        if (indexPath.section == 0) {
            NSMutableDictionary *Dictionary = self.listArray[0];
            IntegralByMonthDTO *currentMonthIntegralDTO = [[IntegralByMonthDTO alloc] init];
            [currentMonthIntegralDTO setDictFrom:Dictionary];
            nextVC.dateDTO = currentMonthIntegralDTO;

        }else{
            
            IntegralByMonthDTO *otherMonthDTO  =[[IntegralByMonthDTO alloc]init];
            NSMutableDictionary *otherDic = self.listArray[indexPath.row+1];
            [otherMonthDTO setDictFrom:otherDic];
            nextVC.dateDTO = otherMonthDTO;

        }
    }

    [self.navigationController pushViewController:nextVC animated:YES];
}




@end
