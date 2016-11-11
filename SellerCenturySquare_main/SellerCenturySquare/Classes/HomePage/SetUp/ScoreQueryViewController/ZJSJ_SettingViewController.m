//
//  ZJSJ_SettingViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJSJ_SettingViewController.h"
#import "ZJSJ_TableViewCell.h"
//账户安全管理
#import "AccountAndSafeTableViewController.h"
//通用
#import "GeneralTableViewController.h"
//意见反馈
#import "CSPFeedBackViewController.h"
@interface ZJSJ_SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
//tableview
@property (nonatomic,strong)UITableView *tableView;
//推出按钮
@property (nonatomic,strong)UIButton *exitButton;

//设置两个数组 一个装图片，一个装名字
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *names;

@end

@implementation ZJSJ_SettingViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面展示
    [self makeUI];
    
    _images = @[@"04_商家中心_设置_账户与安全",@"04_商家中心_设置_ 通用",@"04_商家中心_设置_商家特权",@"04_商家中心_设置_关于世纪广场",@"10_设置_意见反馈.png"];
    _names = @[@"账户与安全",@"通用",@"商家特权",@"关于叮咚管家",@"意见反馈"];
}


#pragma mark ===视图展示====
-(void)makeUI
{
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT - 60) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark ===代理方法====
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    
    ZJSJ_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell =  [[[NSBundle mainBundle]loadNibNamed:@"ZJSJ_TableViewCell" owner:nil options:nil]lastObject];
    }
    cell.iconImage.image = [UIImage imageNamed:_images[indexPath.row]];
    
    cell.nameLabel.text = _names[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"0");
            AccountAndSafeTableViewController* accountAndSafe = [storyboard instantiateViewControllerWithIdentifier:@"AccountAndSafeTableViewController"];
            
            [self.navigationController pushViewController:accountAndSafe animated:YES];

            
        }
            break;
        case 1:
        {
            NSLog(@"1");
            AccountAndSafeTableViewController* accountAndSafe = [storyboard instantiateViewControllerWithIdentifier:@"AccountAndSafeTableViewController"];
            
            [self.navigationController pushViewController:accountAndSafe animated:YES];

        }
            break;
        case 2:
        {
            NSLog(@"2");
            AccountAndSafeTableViewController* accountAndSafe = [storyboard instantiateViewControllerWithIdentifier:@"AccountAndSafeTableViewController"];
            
            [self.navigationController pushViewController:accountAndSafe animated:YES];

        }
            break;
        case 3:
        {
            NSLog(@"3");
            AccountAndSafeTableViewController* accountAndSafe = [storyboard instantiateViewControllerWithIdentifier:@"AccountAndSafeTableViewController"];
            
            [self.navigationController pushViewController:accountAndSafe animated:YES];

        }
            break;
        
        default:
        {
            NSLog(@"4");
            AccountAndSafeTableViewController* accountAndSafe = [storyboard instantiateViewControllerWithIdentifier:@"AccountAndSafeTableViewController"];
            
            [self.navigationController pushViewController:accountAndSafe animated:YES];
            
        }
            break;
    }

     
}





@end
