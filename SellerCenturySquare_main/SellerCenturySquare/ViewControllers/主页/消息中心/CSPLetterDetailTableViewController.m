//
//  CSPLetterDetailTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPLetterDetailTableViewController.h"
#import "CSPLetterSentTableViewCell.h"
#import "CSPLetterDetailViewController.h"
#import "GetNoticeStationListDTO.h"
#import "NoticeStationDTO.h"


@interface CSPLetterDetailTableViewController ()
{
    NSMutableArray *listArray_;
}
@property (nonatomic,strong) NSMutableArray *listArray;
@end



@implementation CSPLetterDetailTableViewController
@synthesize listArray= listArray_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"站内信";
    
  
    
    [self customBackBarButton];
    
    return;

}
-(void)getDtata{
    NSNumber* pageNo =  [[NSNumber alloc] initWithInt:1];
    NSNumber* pageSize =  [[NSNumber alloc] initWithInt:20];
    [HttpManager sendHttpRequestForGetNoticeStationList:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetNoticeStationListDTO *getNoticeStationListDTO = [[GetNoticeStationListDTO alloc ]init];
                [getNoticeStationListDTO setDictFrom:[dic objectForKey:@"data"]];
                
                
                self.listArray = getNoticeStationListDTO.noticeStationDTOList;
                
                [self.tableView reloadData];
            }
            
        }else{
            
            NSLog(@"大B站内信列表  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetNoticeStationList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDtata];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CSPLetterSentTableViewCell *lettersendCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLetterSentTableViewCell"];
    
    if (!lettersendCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPLetterSentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPLetterSentTableViewCell"];
        lettersendCell = [tableView dequeueReusableCellWithIdentifier:@"CSPLetterSentTableViewCell"];
        
    }
    
    
    CGRect cellFrame = lettersendCell.frame;
    cellFrame.origin = CGPointMake(0, 0);
    
    
    NoticeStationDTO *noticeStationDTO = [[NoticeStationDTO alloc ]init];
    NSDictionary *Dictionary = self.listArray[indexPath.section];
    [noticeStationDTO setDictFrom:Dictionary];

    
    if ([noticeStationDTO.listPic isEqualToString:@""])
    {
        lettersendCell.titleImageView.hidden = YES;
        lettersendCell.labelConstraint.constant = 10;
        lettersendCell.imageViewConstraint.constant = 10;
        
        cellFrame.size.height = 122;
    }else{
        cellFrame.size.height = 274;
        lettersendCell.titleImageView.hidden = NO;
        [lettersendCell.titleImageView sd_setImageWithURL:[NSURL URLWithString:noticeStationDTO.listPic]];
    }
    
    [lettersendCell setFrame:cellFrame];
    
    lettersendCell.titleLabel.text = noticeStationDTO.infoTitle;
    lettersendCell.contentLabel.text = noticeStationDTO.infoContent;
    lettersendCell.timeLabel.text = noticeStationDTO.createDate;
    //小红点
    if ([noticeStationDTO.readStatus isEqualToString:@"1"]) {
        lettersendCell.sendImageView.image = [UIImage imageNamed:@"bell_red"];
    }else{
        lettersendCell.sendImageView.image = [UIImage imageNamed:@"bell.png"];
        
    }
    
    return lettersendCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeStationDTO *noticeStationDTO = [[NoticeStationDTO alloc ]init];
    NSDictionary *Dictionary = self.listArray[indexPath.section];
    [noticeStationDTO setDictFrom:Dictionary];
    
    CSPLetterDetailViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailViewController"];
    nextVC.noticeStationDTO = noticeStationDTO;
    [self.navigationController pushViewController:nextVC animated:YES];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    return 274
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

@end
