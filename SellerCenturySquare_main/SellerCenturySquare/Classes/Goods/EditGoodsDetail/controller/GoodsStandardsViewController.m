//
//  GoodsStandardsViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsStandardsViewController.h"
#import "Masonry.h"
#import "GoodsStandardsTableViewCell.h"
#import "AttrListDTO.h"
#import "CSPUtils.h"


@interface GoodsStandardsViewController ()<UITableViewDataSource , UITableViewDelegate ,GoodsStandardsDelegate>

/**
 *  显示数据的tableview
 */
@property (nonatomic ,strong) UITableView *tableView;

/**
 *  上一页面过来的数据
 */
@property (nonatomic ,strong) NSMutableArray *attrList;

/**
 *  保存的数据
 */
@property (nonatomic ,strong) NSMutableArray *saveList;

/**
 *  键盘的高度
 */
@property (nonatomic ,assign) CGFloat keyboardhight;

/**
 *  cell当前的位置（orgin.y+size.height）
 */
@property (nonatomic ,assign) CGFloat cellHeight;

@end

@implementation GoodsStandardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customBackBarButton];
    
    //1. 设置标题
    self.title = @"设置商品规格参数";
    
    //2. 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 200) style:UITableViewStyleGrouped];
    //2.1 设置背景色
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    //2.2 设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //2.3 隐藏cell中的底线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //2.4 添加到主视图中
    [self.view addSubview:self.tableView];
    //2.5 给tableview布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-46);
        
    }];
    //2.6 创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTakeTheKeyboardTap:)];
//    tap.cancelsTouchesInView = NO;
    //2.7 将手势添加到tableview中
    [self.tableView addGestureRecognizer:tap];
    
    //*********初始化数据源*********
    self.attrList = [NSMutableArray array];
    [self.attrList addObjectsFromArray:self.getGoodsInfoList.attrList];
    
    self.saveList = [NSMutableArray array];

    
    //3. 设置保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //3.1 添加到主视图
    [self.view addSubview:saveBtn];
    //3.2 添加保存放啊放
    [saveBtn addTarget:self action:@selector(saveChangeContentBtn:) forControlEvents:UIControlEventTouchUpInside];
    //3.3 设置按钮文字
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    //3.4 设置按钮的背景色
    saveBtn.backgroundColor = [UIColor colorWithHex:0x000000];
    //3.5 设置字体样式
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //3.6 按钮saveBtn布局
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@46);
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

#pragma mark - tableViewDelegate&&dataSource

//cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attrList.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置id
    static NSString *cellId = @"GoodsStandardsTableViewCellId";
    
    // 获取cell
    GoodsStandardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GoodsStandardsTableViewCell" owner:nil options:nil]lastObject];
        
    }
    
    // 选中取消默认背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //判断数据源是否存在
    if (self.attrList) {
        if (self.attrList.count>0) {
            AttrListDTO * attList = [self.attrList objectAtIndex:indexPath.row];
            cell.typeNameLabel.text = attList.attrName;
            cell.inputTextfield.text = attList.attrValText;
        }
    }
    
    // 设置代理
    cell.delegate = self;
    
    return cell;
    
}
//cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//自定义head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headViewID = @"headViewID";
    
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewID];
    if (headView == nil) {
    headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"cell"];
    }
    
    
    headView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    return headView;
    
}

//head的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


#pragma mark -GoodsStandardsDelegate
/**
 * 更改键盘的高度
 *
 *  @param cell
 */
- (void)GoodsStandardCurrentCell:(GoodsStandardsTableViewCell *)cell
{
    //获取indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //获取cell的frame
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    //获取cellHeight高度
    self.cellHeight = rectInTableView.origin.y+rectInTableView.size.height;
    if (_keyboardhight>0) {
        
        CGFloat keyboardY = self.view.frame.size.height-_keyboardhight;
        
        if (self.cellHeight>keyboardY) {
            
            [UIView animateWithDuration:0.4 animations:^{
                
                self.tableView.contentOffset = CGPointMake(0, (self.cellHeight-keyboardY+50));
            }];
        }
    }
}

/**
 *  根据当前的cell，更改模型中的值
 *
 *  @param content 输入框的内容
 *  @param cell
 */
- (void)GoodsStandardsChangeContent:(NSString *)content currentCell:(GoodsStandardsTableViewCell *)cell
{
    
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    AttrListDTO *attListDto = self.attrList[index.row];
    attListDto.attrValText = content;
    
}


#pragma mark - Action点击方法
//手势的点击方法
- (void)clickTakeTheKeyboardTap:(UIGestureRecognizer *)tap
{

    [self.tableView endEditing:YES];
    
    
}


//保存按钮
- (void)saveChangeContentBtn:(UIButton *)btn
{
    //收起键盘
    [self.tableView endUpdates];
    
    //判断所有的输入框是否为空
    NSString *nameStr;

    for (AttrListDTO *attList in self.attrList) {
        
        //判断是否为空
        if (attList.attrValText && ![attList.attrValText isEqualToString:@""]) {
            
            nameStr = attList.attrValText;
            
            if (nameStr.length > 10) {
                
                [self.view makeMessage:@"最多可输入10个字。" duration:2 position:@"center"];
                return;
                
            }
        }

        //转换样式
        NSDictionary *attDict = attList.mj_keyValues;
        //添加到数组
        [self.saveList addObject:attDict];
        
    }
    
    //如果都没有的话提示
    if (!nameStr || [nameStr isEqualToString:@""]) {
        [self.view makeMessage:@"请设置商品规格参数" duration:2 position:@"center"];
        return;
    }


    //上传保存数据
 [HttpManager sendHttpRequestForGoodsAttrUpdateGoodsNo:self.getGoodsInfoList.goodsNo attrList:self.saveList success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
     [self  progressHUDHiddenTipSuccessWithString:@""];
     
     if ([dict[@"code"] isEqualToString:@"000"]) {
         
         [self.view makeMessage:@"保存成功" duration:2 position:@"center"];
         
//         [NSThread sleepForTimeInterval:2];
         
         
         
     }else
     {
         [self.view makeMessage:@"保存失败" duration:2 position:@"center"];

     }
     
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"保存失败" duration:2 position:@"center"];
 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-键盘处理的方法

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);

    _keyboardhight = kbSize.height;
    
    
    CGFloat keyboardY = self.view.frame.size.height-kbSize.height;
    
        if (self.cellHeight>keyboardY) {
            
            [UIView animateWithDuration:0.4 animations:^{

            self.tableView.contentOffset = CGPointMake(0, (self.cellHeight-keyboardY+50));
        }];
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.tableView.contentOffset = CGPointMake(0,0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
