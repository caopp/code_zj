//
//  CSPRecommendContactsViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPRecommendContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "HttpManager.h"
#import "GetRecommendReceiverListDTO.h"
#import "RecommendReceiverDTO.h"
#import "ChineseToPinyin.h"
#import "CSPConfirmToSendViewController.h"
#import "GetMerchantInfoDTO.h"

@interface CSPRecommendContactsViewController ()
@property (nonatomic,strong)GetRecommendReceiverListDTO *getRecommendReceiverListDTO;
@property (nonatomic,strong)NSMutableDictionary *selectedInfo;
@property (nonatomic,strong)NSMutableDictionary *contactsInfo;
@property (nonatomic,strong)NSArray *sectionIndex;
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@end

@implementation CSPRecommendContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getcontactData];
    _selectedInfo = [[NSMutableDictionary alloc]init];
    
    [self customBackBarButton];
    self.title = @"选择收件人";
    _noticeView.hidden = YES;
    [_nextButton setEnabled:NO];
    [_nextButton setBackgroundColor:[UIColor grayColor]];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest
- (void)getcontactData{
    
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:100];
    NSString *dayNum = _dayNum;
    
    
    [HttpManager sendHttpRequestForGetRecommendReceiverList:pageNo pageSize:pageSize dayNum:dayNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"dic = %@",dic);
            NSLog(@"推荐商品收件人列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getRecommendReceiverListDTO = [[GetRecommendReceiverListDTO alloc ]init];
                
                [_getRecommendReceiverListDTO setDictFrom:[dic objectForKey:@"data"]];

                [self getReconstructionData];
            }
            
        }else{
            
            NSLog(@" 推荐商品收件人列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordDetailsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

}

#pragma mark - Private Function
- (void)getReconstructionData{
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
    
    for (RecommendReceiverDTO *tmpRecDTO in _getRecommendReceiverListDTO.recommendReceiverDTOList) {
        
        NSString *nameIndex =[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:tmpRecDTO.memberName]];
    
        if (resultDic[nameIndex]) {
            
            NSMutableArray *arr = resultDic[nameIndex];
            
            [arr addObject:tmpRecDTO];
        }else{
            
            NSMutableArray *indexArr = [[NSMutableArray alloc]init];
            
            [indexArr addObject:tmpRecDTO];
            
            [resultDic setObject:indexArr forKey:nameIndex];
        }
    }
    
    _contactsInfo = resultDic;
    
    _sectionIndex = [resultDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    [self.tableView reloadData];
    
    if (_getRecommendReceiverListDTO.recommendReceiverDTOList.count==0) {
        _noticeView.hidden= NO;
        [_nextButton setEnabled:NO];
        [_nextButton setBackgroundColor:[UIColor grayColor]];
    }else{
        _noticeView.hidden=YES;
        [_nextButton setEnabled:YES];
        [_nextButton setBackgroundColor:[UIColor blackColor]];
    }
}

- (IBAction)nextConfirmButtonClicked:(id)sender {
    
    NSLog(@"%@",_selectedInfo);
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionIndex.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionIndex[section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _contactsInfo[_sectionIndex[section]];
    
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsTableViewCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell"];
    
    if (!contactsCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ContactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactsTableViewCell"];
        contactsCell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell"];
    }
    
    // Configure the cell...
    RecommendReceiverDTO *recDTO = _contactsInfo[_sectionIndex[indexPath.section]][indexPath.row];
    
    contactsCell.recommendReceiverDTO = recDTO;
    contactsCell.recommendSelectedInfo = _selectedInfo;
    
    if (_selectedInfo[recDTO.memberNo]) {
        [contactsCell setButtonSelected:YES];
    }else{
        [contactsCell setButtonSelected:NO];
    }
    
    return contactsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    if (_selectedInfo.allKeys.count) {
        
        return YES;
    }else{
        [self.view makeMessage:@"请选择收件人" duration:2.0f position:@"center"];
        return NO;
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CSPConfirmToSendViewController *confirmVC = segue.destinationViewController;
    
    confirmVC.goodsInfoDic = _goodsInfoDic;
    
    confirmVC.memberInfoDic = _selectedInfo;
   
    
    
}


@end
