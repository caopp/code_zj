//
//  AddressDetailViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/10.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddressDetailViewController.h"

#import "CSPMangeAddressViewController.h"

#import "AddressDetailTableViewCell.h"
#import "CustomBarButtonItem.h"
#import "AddressDetailCell.h"


#import "ZJ_ManagerAddressViewController.h"



@interface AddressDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
//    AddressDetailTableViewCell *cell;
    ConsigneeDTO *consigneeDTO;
    UIButton *deleteButton ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *nameArr;

@property (nonatomic,strong)NSArray *detailArr;

//设置一个开关
@property (nonatomic,assign)BOOL isOK;


@end

@implementation AddressDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

-(NSArray *)nameArr
{
    if (_nameArr == nil) {
        _nameArr = [NSArray arrayWithObjects:@"收货人",@"手机号",@"所在地区", nil];
    }
    return _nameArr;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    consigneeDTO = [[ConsigneeDTO alloc]init];
    
    consigneeDTO = self.consigneeDTO;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self addCustombackButtonItem];
    
    self.title = @"管理收货地址";
    
    [self addCustomSettingButtonItem];

    self.tableView.scrollEnabled = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置删除按钮
    [self settingDeletaBtn];
    
    [self.tableView reloadData];
}

//设置删除按钮
-(void)settingDeletaBtn
{
    deleteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    deleteButton.frame = CGRectMake(0, self.view.frame.size.height - 50 - 64, self.view.frame.size.width, 50);
    deleteButton.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:deleteButton];
    
    [deleteButton addTarget:self action:@selector(deleteDetailIofo) forControlEvents:(UIControlEventTouchUpInside)];
    [deleteButton setTitle:@"删除收货地址" forState:(UIControlStateNormal)];
    [deleteButton setBackgroundColor:[UIColor colorWithHexValue:0x1a1a1a alpha:1]];
    
    [deleteButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [deleteButton setFont:[UIFont systemFontOfSize:16]];
}

-(void)addCustomSettingButtonItem
{
    self.navigationItem.rightBarButtonItem = [[CustomBarButtonItem alloc]initWithTitle:@"修改" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickJoinSettingPage)];
}

-(void)didClickJoinSettingPage
{
    
    ZJ_ManagerAddressViewController *managerVC = [[ZJ_ManagerAddressViewController alloc]init];
    managerVC.manageAddress = CSPModifyAddress;
    
    managerVC.consigneeDTO = consigneeDTO;
    
    [self.navigationController pushViewController:managerVC animated:YES];

}
      
/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}
/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.nameArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[AddressDetailCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
  //设置线条
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 0.5)];
    lineLabel.backgroundColor =  [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    [cell addSubview:lineLabel];
    
    
    switch (indexPath.section) {
           case 0:
        {
            cell.nameLabel.text = self.nameArr[indexPath.row];

            switch (indexPath.row) {
                case 0:
                {
                    cell.detailLabel.text = consigneeDTO.consigneeName;

                }
                    break;
                    
                case 1:
                {
                    cell.detailLabel.text = consigneeDTO.consigneePhone;
                    
                }
                    break;
                    
                case 2:
                {
                     cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",consigneeDTO.provinceName,consigneeDTO.cityName,consigneeDTO.countyName];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        default:
            break;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 44;
}



-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (([self setHeight] + 30) < 44) {
        return 44;
    }
    else
    {
        return [self setHeight];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self setHeight])];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, view.center.y +7 , 80, 15)];

    nameLabel.font = [UIFont systemFontOfSize:14];
    [nameLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    nameLabel.text = @"详细地址";
    [view addSubview:nameLabel];
    
    //详细地址
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width + 20, 15, self.view.frame.size.width - nameLabel.frame.size.width - 35, [self setHeight])];
    
    detailLabel.text = consigneeDTO.detailAddress;
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.numberOfLines = 0;
//    detailLabel.backgroundColor = [UIColor redColor];
    //自动折行设置
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:2];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailLabel.text.length)];
//    detailLabel.attributedText = attributedString;
    
    [detailLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [view addSubview:detailLabel];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,detailLabel.frame.origin.y + detailLabel.frame.size.height + 15 , self.view.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    [view addSubview:lineLabel];
    
    return  view;
}

-(CGFloat)setHeight
{
    CGSize  detailAddressHeight = [consigneeDTO.detailAddress boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    return detailAddressHeight.height;
}




-(void)deleteDetailIofo
{
    deleteButton.enabled = NO;
    
    if ([consigneeDTO.defaultFlag isEqualToString:@"0"]) {
        [self.view makeMessage:@"默认收货地址不可删除" duration:2 position:@"center"];
    }else
    {
        UIAlertView * alertView  =[[UIAlertView alloc]initWithTitle:@"确定删除收货地址？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if ([self.delegate respondsToSelector:@selector(implementProxyMethodID:button:)]) {
            
            [self.delegate implementProxyMethodID:consigneeDTO.Id button:deleteButton];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
