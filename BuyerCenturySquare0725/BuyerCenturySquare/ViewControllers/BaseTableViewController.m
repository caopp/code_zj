//
//  BaseTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CustomBarButtonItem.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    self.navigationItem.hidesBackButton = YES;
    
    
    self.tableView.delegate = self;
    //隐藏多余线
    [self setExtraCellLineHidden:self.tableView];
    //线顶头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)addCustombackButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
    


}

- (NSArray *)siftImagesFromImageList:(NSArray *)imageList withType:(CSPImageListType)type{
    
    if (imageList==nil) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tmpDic in imageList) {
        
        NSString *picType = tmpDic[@"picType"];
        if ([picType integerValue]==type) {
            
            [resultArr addObject:tmpDic];
        }
    }
    
    NSLog(@"siftImagesFromImageList:%@",resultArr);
    return resultArr;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
