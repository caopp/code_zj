//
//  InviteContactsViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "InviteBatchViewController.h"
#import "InviteContactInfoDTO.h"

#import "InviteAddressBook.h"

@interface InviteContactsViewController ()

@property (nonatomic,assign)int num;// !选择的个数
@property (nonatomic,assign)int allNum;// !联系人个数


// !记录是否选中的字典
@property (nonatomic,strong)NSMutableDictionary *selectedInfo;
@property (nonatomic,strong)NSMutableDictionary *contactsInfo;
@property (nonatomic,strong)NSArray *sectionIndex;

@end

@implementation InviteContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"选择联系人";
    
    // !获取通讯录的信息
    [self dataInit];
    


    // !选中、不选中联系人的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countAmountSelectedContacts:) name:kContactsSelectChangedNotification object:nil];
    
    _num = 0;
    _selectedL.text = [NSString stringWithFormat:@"已选%zi人",_num];
    _setLevelButton.enabled = NO;
    [_setLevelButton setBackgroundColor:[UIColor grayColor]];
    [self customBackBarButton];
    
    // !全选按钮的状态
    [self.selectAllBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_选中"] forState:UIControlStateSelected];
    
    [self.selectAllBtn setImage:[UIImage imageNamed:@"04_商品图片下载-编辑_未选中"] forState:UIControlStateNormal];

    
}


- (void)viewWillAppear:(BOOL)animated{
    
    // !下一个界面返回回来的时候，重新展现上一次选择的数据
    if ([[_selectedInfo allKeys] count]) {
        
        [self.tableView reloadData];
    
    }
   
    
}

// !cell上面 联系人选中 取消选中的事件
- (void)countAmountSelectedContacts:(NSNotification *)note{
    
    NSDictionary *dic = [note userInfo];
    
    NSString *numStr = dic[@"Num"];// ! 1:选中  -1：取消选中
    
    NSString *row = dic[@"Row"];// !行数目
    NSString *section = dic[@"Section"];// !段
    NSString *selectState;
    
    if ([numStr intValue]==1) {
        
        selectState = @"YES";
        
    }else{
        
        selectState = @"NO";
        
        // !全选的选择状态为no
        self.selectAllBtn.selected = NO;
        
    }
    
    // !获得当前选中数量
    _num += [numStr intValue];
    _selectedL.text = [NSString stringWithFormat:@"已选%zi人",_num];
    
    // !如果选择的个数刚好和通讯录人数相同
    if (_num == _allNum) {
        
        // !全选的选择状态为yes
        self.selectAllBtn.selected = YES;
        
    }
    
    // !记录状态
    [_selectedInfo setObject:selectState forKey:[NSString stringWithFormat:@"%@-%@",section,row]];
    
    // !“设置等级”按钮的状态
    [self setLevelBtnStatues];
    
    
   
    
    
}
// !“设置等级”按钮的状态
-(void)setLevelBtnStatues{

    if (_num>0) {
        
        _setLevelButton.enabled = YES;
        [_setLevelButton setBackgroundColor:[UIColor blackColor]];
        
    }else{
        
        _setLevelButton.enabled = NO;
        [_setLevelButton setBackgroundColor:[UIColor grayColor]];
        
    }

}

#pragma mark 获取通讯录
- (void)dataInit
{
    //获取联系人权限
    InviteAddressBook * addressBook =  [[InviteAddressBook alloc]init];
    
    [addressBook getSortContactDicWithAuthor:^(NSMutableDictionary *contactInfoDic) {//!有权限
        

        // !记录是否选中的字典
        _selectedInfo = [[NSMutableDictionary alloc]init];
        
        
        _contactsInfo = contactInfoDic;
        
        // !section的内容
        _sectionIndex = [_contactsInfo.allKeys sortedArrayUsingSelector:@selector(compare:)];

        //!需要回到主线程刷新界面，不然会崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _noticeView.hidden = YES;

            [self.tableView reloadData];

            // !获取联系人的总数
            [self getContactNum];

        });
        
    } noAuthor:^{//!无权限
       
        
        _noticeView.hidden = NO;

        
    }];
    
    
    
    
}
// !获取联系人的总个数
-(void)getContactNum{

    _allNum = 0;
    
    for (int i=0; i< _sectionIndex.count; i++) {// !段的个数
        
        NSString *sectionKey = _sectionIndex[i];
        
        NSArray * sectionArray = _contactsInfo[sectionKey];
        
        for (int j=0; j<sectionArray.count; j++) {// !行
            
                      
            _allNum++;
            
        }
        
        
    }

}

#pragma mark - TableView DataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionIndex;
}

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
    NSMutableArray *arr = _contactsInfo[_sectionIndex[section]];
    
    return [arr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsTableViewCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell"];

    if (!contactsCell) {
        

        [tableView registerNib:[UINib nibWithNibName:@"ContactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactsTableViewCell"];
        contactsCell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell"];
    
        
    }

    
    // Configure the cell...
    NSString *name = _contactsInfo[_sectionIndex[indexPath.section]][indexPath.row][@"name"];

    NSString *phoneNum = _contactsInfo[_sectionIndex[indexPath.section]][indexPath.row][@"phoneNum"];

    NSString *selected = _selectedInfo[[NSString stringWithFormat:@"%zi-%zi",indexPath.section,indexPath.row]];
    
    
    if (selected==nil) {
        
        selected = @"NO";
        
    }
    
    contactsCell.row = indexPath.row;
    contactsCell.section = indexPath.section;
    
    
    if (![name isEqualToString:@""]) {
       
        contactsCell.nameL.text =name;
    
    }else{
        
        contactsCell.nameL.text = phoneNum;
    
    }

    contactsCell.phoneNum = phoneNum;
    
    
    if ([selected isEqualToString:@"YES"]) {
        
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;

}

#pragma mark "设置等级"的事件

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"selectedContacts"]) {
        
        NSArray *contactsInfo = [self getSelectedContactsInfo];
        
        InviteBatchViewController *inviteBatch = segue.destinationViewController;
        
        inviteBatch.contactsInfo = contactsInfo;
        
        inviteBatch.getMerchantNotAuthTipDTO = _getMerchantNotAuthTipDTO;
        
    }
    
    
}
// !组合成要上传的数据
- (NSArray*)getSelectedContactsInfo{
    
    NSMutableArray *contactsInfo = [[NSMutableArray alloc]init];
    
    for (NSString *tmpIndex in _selectedInfo.allKeys) {
        
        NSString *selectedState = _selectedInfo[tmpIndex];
        
        if ([selectedState isEqualToString:@"YES"]) {
            
            NSArray *indexArr = [tmpIndex componentsSeparatedByString:@"-"];
            NSString *section = indexArr[0];
            NSString *row = indexArr[1];
            NSString *name = _contactsInfo[_sectionIndex[[section integerValue]]][[row integerValue]][@"name"];
            NSString *phoneNum = _contactsInfo[_sectionIndex[[section integerValue]]][[row integerValue]][@"phoneNum"];
            
            InviteContactInfoDTO *inviteContactDTO = [[InviteContactInfoDTO alloc]init];
            
            inviteContactDTO.name = name;
            
            inviteContactDTO.phoneNum = phoneNum;
            
            inviteContactDTO.shopLevel = 3;
            
            inviteContactDTO.isSelected = NO;
            
            inviteContactDTO.row = -1;
            
            [contactsInfo addObject:inviteContactDTO];
            
        }
        
    }
    
    return contactsInfo;
    
    
}

#pragma mark ”全选按钮的事件“
- (IBAction)selectAllBtnClick:(id)sender {
    
    NSString *statues ;// !选择状态
    
    self.selectAllBtn.selected  = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        
        statues = @"YES";

    }else{
        
        statues = @"NO";
        
    }
    
    
    
    /*
     
     _contactsInfo:
     
     {
     S =     (
     {
     email = email;
     id = 28;
     name = "\U751f";
     netAvatarImgUrl = 0;
     phoneNum = 15925367219;
     sign = sign;
     }
     );
     X =     (
     {
     email = email;
     id = 25;
     name = "\U5c0f\U80d6";
     netAvatarImgUrl = 0;
     phoneNum = 15376982126;
     sign = sign;
     }
     );
     
     }

     
     */
    

    
    // !改变数组  注意：sectionIndex = @[S,X,Y,Z];
    _selectedInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int i=0; i< _sectionIndex.count; i++) {// !段的个数
        
        NSString *sectionKey = _sectionIndex[i];
        
        NSArray * sectionArray = _contactsInfo[sectionKey];
        
        for (int j=0; j<sectionArray.count; j++) {// !行
            
            NSString * sectionStr = [NSString stringWithFormat:@"%d",i];
            NSString * rowStr = [NSString stringWithFormat:@"%d",j];
            
            [_selectedInfo setObject:statues forKey:[NSString stringWithFormat:@"%@-%@",sectionStr,rowStr]];
            
            
        }
        
        
    }
    

    
    // !改变状态
    [self.tableView reloadData];
    
    // !不是全选 选择的人数改变为0
    if (!self.selectAllBtn.selected) {
        
        _num = 0;
        
    }else{
    
        _num = _allNum;
        
    }
    // !改变选中的数量
    _selectedL.text = [NSString stringWithFormat:@"已选%zi人",_num];
    
    // !“设置等级”按钮的状态
    [self setLevelBtnStatues];

    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
