//
//  CSPMessageCenterTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMessageCenterTableViewController.h"
#import "CSPPersonCenterLetterTableViewCell.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "CSPLetterDetailTableViewController.h"
#import "ConversationWindowViewController.h"
#import "CSPMessageDetailTableViewController.h"
#import "UIImageView+WebCache.h"

#import "DeviceDBHelper.h"
#define ReceiveMessage @"receiveMessage"


@interface CSPMessageCenterTableViewController ()
@property (nonatomic,strong) NSArray  *messageArray;

@end

@implementation CSPMessageCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageInCenter) name:ReceiveMessage object:nil];
    self.title = @"消息中心";
    [self addCustombackButtonItem];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.messageArray = [[DeviceDBHelper sharedInstance]getCenterSession];
    
    [self.tableView reloadData];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.messageArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        NSArray *array = [self.messageArray objectAtIndex:section-1];
        return array.count+1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPPersonCenterLetterTableViewCell *letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    CSPPersonCenterShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    if (!letterCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterLetterTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterLetterTableViewCell"];
        letterCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterLetterTableViewCell"];
    }
    
    if (!shopCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
        
    }
    
    if (!otherCell) {
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
    }
    
    if (indexPath.section == 0) {
        //letterCell.imageView.badgeNumber = self.messageCount.stringValue;
        return letterCell;
    }

    else
    {
        
        if (indexPath.row == 0) {
            for (id view in otherCell.subviews) {
                if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]){
                    
                    [view removeFromSuperview];
                }
            }
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (29-11)/2, 150, 13)];
            titleLabel.textColor = HEX_COLOR(0x000000FF);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:13];
            [otherCell addSubview:titleLabel];
            NSArray * array = (NSArray *)[self.messageArray objectAtIndex:indexPath.section - 1];
            ECSession * session = (ECSession *)[array objectAtIndex:0];
            titleLabel.text = session.merchantName;
            
            
            UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -8-15,(29-12)/2, 8, 12)];
            arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
            [otherCell addSubview:arrowImageView];
            return otherCell;
        }else{
            NSArray *array = [self.messageArray objectAtIndex:indexPath.section - 1];
        
            ECSession * session = (ECSession *)array[indexPath.row-1];

            shopCell.badgeimageView.badgeNumber =session.unreadCount>99?@"99+" :[NSString stringWithFormat:@"%ld",session.unreadCount];
            shopCell.contentLabel.text = session.text;
            if (session.sessionType == 1) {
                shopCell.titleLabel.text = [NSString stringWithFormat:@"货号:%@  颜色:%@  价格:%@",session.goodNo,session.goodColor,session.goodPrice];
                [shopCell.badgeimageView sd_setImageWithURL:[NSURL URLWithString:session.goodPic]];
            }else{
                shopCell.titleLabel.text = [NSString stringWithFormat:@"%@",session.merchantName?session.merchantName:session.merchantNo];
                shopCell.badgeimageView.image = [UIImage imageNamed:@"10_商品询单对话_客服.png"];
            }

            shopCell.arrorImageView.hidden = YES;
            return shopCell;
        }
    }
//    else if(indexPath.row == 0){
//        return otherCell;
//    }
//    else
//    {
//        shopCell.badgeimageView.badgeNumber = @"4";
//        shopCell.arrorImageView.hidden = YES;
//        return shopCell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.row == 0)
    {
        return 29;
    }else{
        return 54;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 10;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0) {
        CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
        nextVC.returnTextBlock =^(){
            self.messageCount = [NSNumber numberWithInt:[self.messageCount intValue] -1];;
        };
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else{
       
        if (indexPath.row == 0) {
            
            CSPMessageDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPMessageDetailTableViewController"];
            NSArray * array = (NSArray *)[self.messageArray objectAtIndex:indexPath.section - 1];
            ECSession * session = (ECSession *)[array objectAtIndex:0];
            nextVC.merchantName = session.merchantName;
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }else{
            NSArray *array = [self.messageArray objectAtIndex:indexPath.section - 1];
            ECSession * session = (ECSession *)array[indexPath.row-1];
            
            ConversationWindowViewController *conversationVC;
            conversationVC = [[ConversationWindowViewController alloc]initWithSession:session];
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }
    }

}

-(void)newMessageInCenter
{
    self.messageArray = [[DeviceDBHelper sharedInstance]getCenterSession];
    
    [self.tableView reloadData];
}



@end
