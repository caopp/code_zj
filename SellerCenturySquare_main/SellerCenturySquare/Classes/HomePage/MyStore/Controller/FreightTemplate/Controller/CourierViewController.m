//
//  CourierViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CourierViewController.h"
#import "CourierTableViewCell.h"
#import "HttpManager.h"
#import "CourierModel.h"
#import "CourierListModel.h"
#import "CourierView.h"
#import "MyUserDefault.h"
@interface CourierViewController ()<UITableViewDataSource,UITableViewDelegate,CourierViewDelegate>

{
    CourierView *courierView;
    NSString *phoneStr;
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *listArray;


@end

@implementation CourierViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MyUserDefault removeCourierPhone];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"查看物流";
    [self makeUI];
    //设置返回按钮
    [self customBackBarButton];
}

-(NSMutableArray *)listArray
{
    if ( _listArray == nil) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return  _listArray;
}


#pragma  mark =====sel   data

-(void)getData
{
    
//测试账号
//  yuantong  881418599259350056
// shentong  3305830569941
    //yunda   3963720236838
    
    //运单的当前状态：0物流单号暂无结果，3在途，4 揽件，5 疑难，6签收，7退签，8 派件，9 退回
    /*
    if (!self.expressCompanyCode && !self.expressNO) {
        
        return;
    }
    */
    
    
//    NSString *str = @"g123456";
    
    [HttpManager sendHttpRequestForExpressCode:self.expressCompanyCode logisticCode:self.expressNO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            _listArray = [[[dic objectForKey:@"data"]objectForKey:@"traces"]  mutableCopy];
            
             NSLog(@"_listArray == %@",_listArray);
            
        }
         [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    /*
    [HttpManager sendHttpRequestForExpressCode:@"yuantong" courierNum:@"881418599259350056" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
         NSNumber *success = [dic objectForKey:@"success"];
        
        if ([success.stringValue  isEqualToString:@"1"]) {
            
            _listArray = [[dic objectForKey:@"data"] mutableCopy];
            
            NSNumber *status = [dic objectForKey:@"status"];
            
            CourierModel *courierModel = [[CourierModel alloc]init];
            
            if ([status.stringValue isEqualToString: @"6"]) {
                
                for (NSDictionary *dic  in _listArray) {
                    [courierModel setDictFrom:dic];
                    NSArray *arr = [self getPhoneNumbersFromString:courierModel.context];
                    if (arr.count > 0) {
                        phoneStr = arr[0];
                    }
                    
                }
            }
        }else
        {
            [self.view makeMessage:[dic objectForKey:@"reason"] duration:2.0f position:@"center"];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    */
}



#pragma  mark ==ui==
-(void)makeUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


#pragma mark ===tableView   sel===

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"_listArray.count === %ld",_listArray.count);
    
    
    return _listArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    
    CourierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( cell == nil) {
        cell = [[CourierTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    CourierModel *courierModel = [[CourierModel alloc]init];
    
    [courierModel setDictFrom:_listArray[indexPath.row]];
    
    [cell getLookFreightTemplateCellData:courierModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        cell.selectedButton.backgroundColor = [UIColor colorWithHexValue:0xeb301f alpha:1];
        cell.courierAddressLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        cell.verticalLabel.hidden = YES;
        
    }else
    {
        cell.selectedButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        cell.courierAddressLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        cell.verticalLabel.hidden = NO;

    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"cell";
    
    CourierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( cell == nil) {
        cell = [[CourierTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    CourierModel *courierModel = [[CourierModel alloc]init];
    
    [courierModel setDictFrom:_listArray[indexPath.row]];
    
    [cell getLookFreightTemplateCellData:courierModel];
    

    return  cell.heightCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    courierView = [[[NSBundle mainBundle]loadNibNamed:@"ZJ_CourierView" owner:nil options:nil]lastObject];
    courierView.delegate = self;

    if (phoneStr != nil) {
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:phoneStr];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        courierView.phoneNumLabel.attributedText = content;
        
    }

    
    courierView.courierName.text = self.CourierName;
    
    courierView.courierCompanyNum.text = self.expressNO;
    
    return courierView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (NSArray *) getPhoneNumbersFromString:(NSString *) str {
    
    NSError* error = nil;
    NSString* regulaStr = @"(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?))";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    NSMutableArray* numbers = [NSMutableArray arrayWithCapacity:arrayOfAllMatches.count];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [str substringWithRange:match.range];
        [numbers addObject:substringForMatch];
        
    }
    
    return numbers;
}

#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ==拨打电话===
-(void)didClickAction
{
    if (courierView.phoneNumLabel.text == nil || [courierView.phoneNumLabel.text isEqualToString:@""]) {
        return;
    }
    
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneStr]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    
}

@end

