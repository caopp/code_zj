//
//  ZJ_TemplateiewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_TemplateiewController.h"
#import "NewAndModifyTemplateModel.h"
#import "NewAndModifyTemplateListModel.h"
#import "AddAndModifTemplateCell.h"
#import "FreightTempView.h"
#import "GUAAlertView.h"
#import "SelectedCityViewController.h"
#import "CSPUtils.h"
#import "ZJ_FreightTemplateCell.h"

#define  Time 0.4

@interface ZJ_TemplateiewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FreightTempViewDelegate,AddAndModifTemplateCellDelegate,ZJ_FreightTemplateCellDelegate>
{
    FreightTempView *freightTempView;
    UIView *headerView;
    
    BOOL isHaveDian;
}
//设置显示
@property (nonatomic,strong)UITableView *tableView;
//设置显示保存按钮
@property (nonatomic,strong)UIButton *saveButton;
//添加指定区域按钮
@property (nonatomic,strong)UIButton *designatedAreaButton;
//
@property (nonatomic,strong)NSMutableArray * weightArray;
@property (nonatomic,strong)NSMutableArray * countArray;
@property (nonatomic,strong)NSMutableArray *titleArr;

//单独装名字
@property (nonatomic,strong)NSMutableArray *nameArr;
@property (nonatomic,strong)NSMutableArray *postCountArr;

//字符串切割数组
@property (nonatomic,strong)NSArray *cutIDArr;

//把切割好的字符串添加到数组(重量)
@property (nonatomic,strong)NSMutableArray *addCutIDArr;
//把切割好的字符串添加到数组（件数）
@property (nonatomic,strong)NSMutableArray *addCountIDArr;
//设置cell的高度
@property (nonatomic,assign)CGFloat cellHeight;
//键盘的高度
@property(nonatomic,assign)CGFloat keyboardhight;
//选中按钮显示事件
@property(nonatomic,strong)UITableView *selectedTableView;


//从上一界面接受（重量）
@property (nonatomic,strong)NSMutableArray * fontWeightArr;


@end

@implementation ZJ_TemplateiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置返回按钮
    [self customBackBarButton];
    if (self.templatemanage == NewTemplate) {
        self.title = @"新建模板";
        self.type = @"1";
    }else if (self.templatemanage == OldModifyTemplate)
    {
        self.title = @"修改模板";
    }
    self.weightArray = [[NSMutableArray alloc]init];
    self.countArray = [[NSMutableArray alloc] init];
    self.nameArr = [[NSMutableArray alloc] init];
    self.postCountArr = [[NSMutableArray alloc]init];
    //字符串切割数组
    self.cutIDArr = [[NSMutableArray alloc]init];
    //把切割好的字符串添加到数组
    self.addCutIDArr = [[NSMutableArray alloc]init];
    //把切割好的字符串添加到数组（件数）
    self.addCountIDArr = [[NSMutableArray alloc]init];
    if (self.type.integerValue == 0) {
        for (NSDictionary *dic in self.lookList) {
            NSArray *arr = [dic[@"expressAreaId"] componentsSeparatedByString:@","];
            for (NSString *string  in arr) {
                [self.addCutIDArr addObject:string];
            }
        }
    }else
    {
        for (NSDictionary *dic in self.lookList) {
            NSArray *arr = [dic[@"expressAreaId"] componentsSeparatedByString:@","];
            for (NSString *string  in arr) {
                [self.addCountIDArr addObject:string];
            }
        }
    }
    //设置UI
    [self makeUI];
    //数据转化
    [self dataConversion];
}
#pragma mark ====sel数据转化====
-(void)dataConversion
{
    if (self.templatemanage == NewTemplate) {
        //初始化
        NewAndModifyTemplateModel *weightModel = [[NewAndModifyTemplateModel alloc]init];
        NewAndModifyTemplateModel *countModel = [[NewAndModifyTemplateModel alloc]init];
        [self.weightArray addObject:weightModel];
        [self.countArray addObject:countModel];
        [self.nameArr addObject:@""];
        [self.postCountArr addObject:@""];
        _titleArr = self.weightArray;
    }
    else
    {
        if (self.type.integerValue == 0) {
            NewAndModifyTemplateModel *countModel = [[NewAndModifyTemplateModel alloc]init];
            [self.countArray addObject:countModel];
            for (NSDictionary *dic  in self.lookList) {
                //初始化
                NewAndModifyTemplateModel *weightModel = [[NewAndModifyTemplateModel alloc]init];
                [weightModel setDictFrom:dic];
                weightModel.expressArea = dic[@"expressAreaId"];
                [self.nameArr addObject:dic[@"expressArea"]];
                [self.weightArray  addObject:weightModel];
            }
            [self.postCountArr addObject:@""];
            _titleArr = [self.weightArray copy];
        }else
        {
            //初始化
            NewAndModifyTemplateModel *weightModel = [[NewAndModifyTemplateModel alloc]init];
            [self.weightArray addObject:weightModel];
            for (NSDictionary *dic  in self.lookList) {
                NewAndModifyTemplateModel *countModel = [[NewAndModifyTemplateModel alloc]init];
                [countModel setDictFrom:dic];
                countModel.expressArea = dic[@"expressAreaId"];
                [self.postCountArr addObject:dic[@"expressArea"]];
                [self.countArray  addObject:countModel];
            }
            [self.nameArr addObject:@""];
            _titleArr = [self.countArray copy];
        }
    }
}

#pragma  mark ===UI====
-(void)makeUI
{
    //设置显示列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    //设置显示保存按钮浮框
    self.saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveButton.frame = CGRectMake(0,self.view.frame.size.height -  49 - 64,self.view.frame.size.width, 49);
    [self.saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [self.view addSubview:self.saveButton];
    self.saveButton.backgroundColor = [UIColor purpleColor];
    self.saveButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [self.saveButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.view addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(saveTemplateType) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark === 根据按钮选择按重量和按件数====
//进行数据筛选
//添加按重量进行筛选执行事件
-(void)executedByWeight:(UIButton *)byWeightButton;
{
    _titleArr = self.countArray;
    self.type = @"1";
    freightTempView.weightButton.selected = NO;
    freightTempView.countButton.selected = YES;
    [self.tableView reloadData];
    [freightTempView.weightButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
    [freightTempView.countButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];

}

//添加按件数进行筛选执行事件
-(void)executedByCount:(UIButton *)byCounttButton;
{
    _titleArr = self.weightArray;
    self.type = @"0";
    freightTempView.weightButton.selected = YES;
    freightTempView.countButton.selected = NO;
    [self.tableView reloadData];
    
    [freightTempView.countButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
    [freightTempView.weightButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
}




-(void)selectedButtonTitle:(NSString *)title section:(NSInteger)section buttonAction:(UIButton *)selectedButton
{
    
    if ([title isEqualToString:@"按件数"] ) {
        _titleArr = self.countArray;
        self.type = @"1";
        freightTempView.selectedTypeButton.selected = NO;
        [self.tableView reloadData];
    }else
    {
        _titleArr = self.weightArray;
        self.type = @"0";
        freightTempView.selectedTypeButton.selected = YES;
        [self.tableView reloadData];
    }
}



#pragma mark ==========tableView代理方法==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"cell";
    ZJ_FreightTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZJ_FreightTemplateCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.index_row = indexPath;
    
    cell.index_cellRow = indexPath;
    
    
    cell.delegate = self;
    cell.firstThingCountField.delegate = self;
    cell.firstThingCountField.tag = indexPath.row;
    
    cell.firstThingFreightMoneyField.delegate = self;
    cell.firstThingFreightMoneyField.tag = indexPath.row;
    
    cell.goOnThingCountField.delegate = self;
    cell.goOnThingCountField.tag = indexPath.row;
    
    cell.goOnThingFreightMoneyField.delegate = self;
    cell.goOnThingFreightMoneyField.tag = indexPath.row;
    
    
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel  alloc]init];
    
    if (newAndModifyTemplateModel != nil) {
        
        newAndModifyTemplateModel = _titleArr[indexPath.row];
    }
    
    
    if (indexPath.row == 0) {
        //运送到
        cell.shippedLabel.hidden = YES;
        
        //城市区域
        cell.cityLabel.hidden = YES;
        cell.icon.hidden = YES;
        
        cell.transportedLabel.hidden = YES;
        cell.deletedButton.hidden = YES;

        cell.deletedButton.hidden = YES;
    }else
    {
        //运送到
        cell.shippedLabel.hidden = NO;
        //城市区域
        cell.cityLabel.hidden = NO;
        cell.icon.hidden = NO;
        cell.transportedLabel.hidden = NO;
        cell.deletedButton.hidden = NO;
        cell.deletedButton.hidden = NO;
    }

    if (self.type.integerValue == 0 ) {
        NSString *areaName;
        areaName = [self.nameArr objectAtIndex:(indexPath.row)];
        [cell getLookFreightTemplateCellType:self.type cityStr:areaName indexRow:indexPath.row];
    }else
    {
        NSString *areaCountName;
        areaCountName = [self.postCountArr objectAtIndex:indexPath.row];
        [cell getLookFreightTemplateCellType:self.type cityStr:areaCountName indexRow:indexPath.row];
    }
    
    
    if ([self.type intValue] == 0) {
        
        //首重
        if (newAndModifyTemplateModel.frontWeight ) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontWeight] isEqualToString:@"0"]) {
                cell.firstThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontWeight];
            }
        }
        
        //续重
        if (newAndModifyTemplateModel.afterWeight) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterWeight] isEqualToString:@"0"]) {
                cell.goOnThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterWeight];
            }
            
        }
        
    }else{
        
        
        //首重
        if (newAndModifyTemplateModel.frontQuantity) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontQuantity] isEqualToString:@"0"]) {
                cell.firstThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontQuantity];
            }
            
        }
        //续重
        if (newAndModifyTemplateModel.afterQuantity ) {
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterQuantity] isEqualToString:@"0"]) {
                cell.goOnThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterQuantity];
                
            }
            
        }
    }
    
    //首费
    if (newAndModifyTemplateModel.frontFreight) {
        if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontFreight] isEqualToString:@"0"]) {
            cell.firstThingFreightMoneyField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontFreight];
            
        }
    }
    
    //续费
    if (newAndModifyTemplateModel.afterFreight ) {
        if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterFreight] isEqualToString:@"0"]) {
            cell.goOnThingFreightMoneyField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterFreight];
        }
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    

    ZJ_FreightTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZJ_FreightTemplateCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    if (self.type.integerValue == 0 ) {
        
        NSString *areaName;
        areaName = [self.nameArr objectAtIndex:(indexPath.row)];
        
        [cell getLookFreightTemplateCellType:self.type cityStr:areaName indexRow:indexPath.row];
    }else
    {
        NSString *areaCountName;
        
        areaCountName = [self.postCountArr objectAtIndex:indexPath.row];
        [cell getLookFreightTemplateCellType:self.type cityStr:areaCountName indexRow:indexPath.row];
    }

    NSLog(@"cell.numFloat %lf", cell.numFloat);
    
    return  cell.numFloat;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 165;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!freightTempView) {
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        headerView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
        freightTempView = [[[NSBundle mainBundle]loadNibNamed:@"FreightTempView" owner:nil options:nil]lastObject];
        if (self.type.integerValue == 0) {
            
            [freightTempView.countButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
            [freightTempView.weightButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
            freightTempView.weightButton.selected = YES;
            freightTempView.countButton.selected = NO;
            
        }else
        {
            [freightTempView.countButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
            [freightTempView.weightButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
            freightTempView.weightButton.selected = NO;
            freightTempView.countButton.selected = YES;
            
        }
        
        freightTempView.delegate = self;
        freightTempView.section = section;
        freightTempView.textField.text = self.templateName;
        freightTempView.textField.layer.cornerRadius = 2;
        freightTempView.textField.layer.masksToBounds = YES;
        freightTempView.textField.delegate = self;
        freightTempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
        [headerView addSubview:freightTempView];
        
    }
    
    return headerView;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    //添加指定区域按钮
    self.designatedAreaButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.designatedAreaButton.frame = CGRectMake(SCREEN_WIDTH/2 - 70, 10, 139, 40);
    [self.designatedAreaButton setTitle:@"新建指定区域运费" forState:(UIControlStateNormal)];
    [view addSubview:self.designatedAreaButton];
    [self.designatedAreaButton addTarget:self action:@selector(addDesignatedAreaButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.designatedAreaButton setFont:[UIFont systemFontOfSize:14]];
    [self.designatedAreaButton setTitleColor:[UIColor colorWithHexValue:0xfd4f57 alpha:1] forState:(UIControlStateNormal)];
    self.designatedAreaButton.layer.borderWidth = 1;
    self.designatedAreaButton.layer.cornerRadius = 2;
    self.designatedAreaButton.layer.masksToBounds = YES;
    self.designatedAreaButton.layer.borderColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1].CGColor;
    return view;
}

#pragma mark  ========textField  SEL===
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //获取对应的indexpath
    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:textField.tag inSection:0];
    //获取cell的frame
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:pathOne];
    if (freightTempView.textField == textField) {
        //获取cellHeight高度
        self.cellHeight = rectInTableView.size.height;

    }else
    {
        //获取cellHeight高度
        self.cellHeight = rectInTableView.origin.y+rectInTableView.size.height + 50;
    }
    
    //获取cell
    ZJ_FreightTemplateCell *cell = (ZJ_FreightTemplateCell *)[self.tableView cellForRowAtIndexPath:pathOne];
    
    //设置键盘
    if (self.type.integerValue == 0) {
        cell.firstThingCountField.keyboardType =  UIKeyboardTypeDecimalPad;
        cell.goOnThingCountField.keyboardType = UIKeyboardTypeDecimalPad;
    }else
    {
        cell.firstThingCountField.keyboardType =  UIKeyboardTypeNumberPad;
        cell.goOnThingCountField.keyboardType = UIKeyboardTypeNumberPad;
    }
    cell.firstThingFreightMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    cell.goOnThingFreightMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    return YES;
}

//textField代理方法
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:textField.tag inSection:0];
    //初始化
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel alloc]init];
    
    ZJ_FreightTemplateCell *cell = (ZJ_FreightTemplateCell *)[self.tableView cellForRowAtIndexPath:pathOne];
    
    if ([self.type intValue] == 0) {
        
        newAndModifyTemplateModel = self.weightArray[pathOne.row];
        
        //首重
        if (cell.firstThingCountField == textField ) {
            newAndModifyTemplateModel.frontWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        // 续重
        if (cell.goOnThingCountField == textField) {
            newAndModifyTemplateModel.afterWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        //首费
        if (cell.firstThingFreightMoneyField == textField) {
            newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        // 续费
        if (cell.goOnThingFreightMoneyField == textField) {
            
            newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        
        [self.weightArray replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
        
        _titleArr = self.weightArray;
        
    }else{
        
        newAndModifyTemplateModel = self.countArray[pathOne.row];
        
        //首重
        if (cell.firstThingCountField == textField ) {
            
            newAndModifyTemplateModel.frontQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        // 续重
        if (cell.goOnThingCountField == textField) {
            newAndModifyTemplateModel.afterQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        //首费
        if (cell.firstThingFreightMoneyField == textField) {
            newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        // 续费
        if (cell.goOnThingFreightMoneyField == textField) {
            
            newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
        }
        
        [self.countArray replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
        _titleArr = self.countArray;
        
    }
    
    
    newAndModifyTemplateModel = _titleArr[pathOne.row];
    
    return YES;
    
}

//textField.text 输入之前的值         string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制名字最长输入10位
    if (freightTempView.textField == textField) {
        
        if ([string isEqualToString:@"\n"])
        {
            return YES;
        }
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([toBeString length] > 10) {
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
    }
    
    
    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:textField.tag inSection:0];
    
    ZJ_FreightTemplateCell *cell = (ZJ_FreightTemplateCell *)[self.tableView cellForRowAtIndexPath:pathOne];
    
#pragma mark  首位字母不能添加小数点和0
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    
    
    if (self.type.integerValue == 0) {
        
        //首重设置小数点
        if (cell.firstThingCountField == textField || cell.goOnThingCountField == textField) {
            
            if ([string length]>0)
            {
                unichar single=[string characterAtIndex:0];//当前输入的字符
                if ((single >='0' && single<='9') || single=='.')//数据格式正确
                {
                    
                    //首字母为小数点
                    if([textField.text length]==0){
                        
                        if(single == '.'){
                            
                            return NO;
                        }
                        if (single == '0') {
                            
                            return YES;
                            
                        }
                    }
                    if (single=='.')
                    {
                        if(!isHaveDian)//text中还没有小数点
                        {
                            isHaveDian=YES;
                            return YES;
                        }else
                        {
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                    }
                    else
                    {
                        if (isHaveDian)//存在小数点
                        {
                            //判断小数点的位数
                            NSRange ran=[textField.text rangeOfString:@"."];
                            
                            NSInteger tt=range.location-ran.location;
                            
                            if (tt <= 2){
                                return YES;
                            }else{
                                return NO;
                            }
                        }
                        else
                        {
                            
                            if (range.location <= 2){
                                return YES;
                            }else{
                                return NO;
                            }
                            
                            
                        }
                    }
                }else{//输入的数据格式不正确
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
                
                
            }
            else
            {
                return YES;
            }
        }
    }else
    {
        //首件
        if (cell.firstThingCountField == textField || cell.goOnThingCountField == textField) {
            
            if ([string isEqualToString:@"\n"])
            {
                return YES;
            }
            
            
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if ([toBeString length] > 3) {
                textField.text = [toBeString substringToIndex:3];
                return NO;
            }
        }
    }
    
    
    //首费和续费小数点的输入
    if (cell.firstThingFreightMoneyField == textField || cell.goOnThingFreightMoneyField == textField) {
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                
                //首字母不能为0和小数点
                if([textField.text length]==0){
                    
                    if(single == '.'){
                        
                        return NO;
                    }
                    if (single == '0') {
                        
                        return YES;
                        
                    }
                }
                
                
                if (single=='.')
                {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        
                        NSInteger tt=range.location-ran.location;
                        
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        if (range.location <= 4){
                            return YES;
                        }else{
                            return NO;
                        }
                        
                    }
                }
                
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
        
    }
    return YES;
    
    
}


#pragma mark ===========cell代理方法=====

-(void)joinAreaDetailPageIndexPath:(NSIndexPath *)indexPath
{
    
    NewAndModifyTemplateModel *templateModel;
    
    //进行类型判断
    if (self.type.integerValue == 0) {
        //重量
        templateModel =self.weightArray[indexPath.row];
        
    }else
    {
        //件数
        templateModel =self.countArray[indexPath.row];
    }
    
    
    //进入下一个页面
    SelectedCityViewController *selectedAreaVC = [[SelectedCityViewController alloc]init];
    
    //返回来字符串
    selectedAreaVC.selectedAllAreas = ^(NSString *strID,NSString *nameStr,NSArray *modelArr)
    {
        
        
        //如果是重量计算进行判断
        if (self.type.integerValue ==  0) {
            
            //返回来的字符串ID
            templateModel.expressArea = strID;
            
            //切割字符串（返回来字符串ID进行分隔）
            self.cutIDArr = [strID componentsSeparatedByString:@","];
            
            DebugLog(@"indexPath.row:%ld", indexPath.row);
            
            //            把分割字符串地，进行数组添加
            for (NSString *stringID in _cutIDArr) {
                
                if (![self.addCutIDArr containsObject:stringID]) {
                    
                    [self.addCutIDArr addObject:stringID];
                    
                }
            }
            
            //分装名字
            [self.nameArr replaceObjectAtIndex:indexPath.row withObject:nameStr];
            
            //替换对应的indexpath.row
            [self.weightArray replaceObjectAtIndex:(indexPath.row) withObject:templateModel];
            
        }else
        {
            
            templateModel.expressArea = strID;
            
            //切割字符串
            self.cutIDArr = [strID componentsSeparatedByString:@","];
            
            for (NSString *stringID in _cutIDArr) {
                
                if (![self.addCountIDArr containsObject:stringID]) {
                    
                    [self.addCountIDArr addObject:stringID];
                    
                }
                
            }
            
            [self.postCountArr replaceObjectAtIndex:indexPath.row withObject:nameStr];
            
            [self.countArray replaceObjectAtIndex:(indexPath.row) withObject:templateModel];
            
        }
        
        [self.tableView reloadData];
        
    };
    
    //进行传值self.lookList(传过来的值)
    if ( self.type.integerValue == 0) {
        
        selectedAreaVC.type = @"0";
        
        
        //重量总共选中的个数ID
        selectedAreaVC.cityIDArr = self.addCutIDArr;
        
        
        
        
        //对应的每个cell选中的个数ID
        selectedAreaVC.cellCityID = templateModel.expressArea;
        
        
    }else
    {
        
        selectedAreaVC.type = @"1";
        
        //总共选中的个数ID
        selectedAreaVC.cityCoiuntIDArr = self.addCountIDArr;
        
        //对应每个cell选中的个数ID
        selectedAreaVC.cellCountCityID = templateModel.expressArea;
        
        
    }
    
    [self.navigationController pushViewController:selectedAreaVC animated:YES];
    
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma  mark ====保存==
-(void)saveTemplateType
{
    if ([self checkInputValues]) {
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定保存运费模版?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self saveTemplate];
            
        } dismissAction:^{
            
        }];
        [alert show];
    }
}


-(void)saveTemplate
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0;i <_titleArr.count;i++) {
        NewAndModifyTemplateModel* newAndModifyTemplateModel = [ _titleArr objectAtIndex:i];
        
        if (newAndModifyTemplateModel.frontWeight != nil ||newAndModifyTemplateModel.afterWeight != nil || newAndModifyTemplateModel.frontFreight != nil ||newAndModifyTemplateModel.afterFreight != nil){
            
            newAndModifyTemplateModel.isDefault = i?@"1":@"0";
            
            [arr addObject: newAndModifyTemplateModel.mj_keyValues];
            
        }
    }

    //添加新的模版
    if (self.templatemanage == NewTemplate) {
        
        [HttpManager sendHttpRequestForGetFreightTemplateName:freightTempView.textField.text type:self.type setList:arr  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                NSLog(@"请求数据成功");
                
                NSNotification *notification = [[NSNotification alloc]initWithName:@"freightTemplateNotification" object:self userInfo:nil];
                 [[NSNotificationCenter defaultCenter]postNotification:notification];
                
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }
    
    //修改模版保存
    else if (self.templatemanage == OldModifyTemplate)
    {
        
        [HttpManager sendHttpRequestForGetFreightTemplateName: freightTempView.textField.text type:self.type templateNameID:self.templateID setList:arr success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                NSNotification *notification = [[NSNotification alloc]initWithName:@"freightTemplateNotification" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotification:notification];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
            
        }];
        
    }
}

#pragma mark ======添加指定区域运费模版===
-(void)addDesignatedAreaButtonAction
{
    //单独装名字
    [self.addCutIDArr addObject:@""];
    [self.addCountIDArr addObject:@""];
    [self.nameArr addObject:@" "];
    [self.postCountArr addObject:@""];
    
    //初始化
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel alloc]init];
    
    if (self.type.integerValue == 0) {
        [self.weightArray addObject:newAndModifyTemplateModel];
        _titleArr = self.weightArray;
    }else
    {
        [self.countArray addObject:newAndModifyTemplateModel];
        _titleArr = self.countArray;
    }
    
    [self.tableView reloadData];
    
}


//添加手势方法
-(void)hideKeyboard{
    [self.view endEditing:YES];
}


#pragma mark===================所有的校验在此方法中进行===============================
- (BOOL)checkInputValues {
    
    if (![self verifyTemplateName]) {
        return NO;
    }
    
    for (int i = 0;i <_titleArr.count;i++) {
        
        NewAndModifyTemplateModel* newAndModifyTemplateModel = [ _titleArr objectAtIndex:i];
        
        if (self.type.integerValue == 0) {
            
            if (newAndModifyTemplateModel.frontWeight == nil ) {
                [self.view makeMessage:@"首重不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.afterWeight == nil) {
                [self.view makeMessage:@"续重不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.frontFreight == nil) {
                [self.view makeMessage:@"首费不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.afterFreight == nil) {
                [self.view makeMessage:@"续费不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (i != 0) {
                if (newAndModifyTemplateModel.expressArea == nil) {
                    [self.view makeMessage:@"地区不能为空" duration:2.0f position:@"center"];
                    return NO;
                }
                
            }
            
        }else
        {
            
            if (newAndModifyTemplateModel.frontQuantity == nil) {
                [self.view makeMessage:@"首件不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.afterQuantity == nil) {
                [self.view makeMessage:@"续件不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.frontFreight == nil) {
                [self.view makeMessage:@"首费不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (newAndModifyTemplateModel.afterFreight == nil) {
                [self.view makeMessage:@"续费不能为空" duration:2.0f position:@"center"];
                return NO;
            }
            if (i != 0) {
                if (newAndModifyTemplateModel.expressArea == nil) {
                    [self.view makeMessage:@"地区不能为空" duration:2.0f position:@"center"];
                    return NO;
                }
                
            }
            
        }
    }
    return YES;
    
}
//运费模版名称
-(BOOL)verifyTemplateName
{
    if ([freightTempView.textField.text isEqualToString:@""]|| freightTempView.textField.text == nil) {
        
        [self.view makeMessage:@"请填写运费模板名称" duration:2.0f position:@"center"];
        
        return NO;
    }
    
    return YES;
}

#pragma mark-键盘处理的方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self  registerForKeyboardNotifications];
}

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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    
    _keyboardhight = kbSize.height;
    
    CGFloat keyboardY = self.view.frame.size.height - kbSize.height;
    
    if (self.cellHeight>keyboardY) {
        
        [UIView animateWithDuration:Time animations:^{
            
            //设置tableView 进行位置移动
            self.tableView.contentOffset = CGPointMake(0, (self.cellHeight-keyboardY+50));
            
        }];
    }
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.view endEditing:YES];
    self.tableView.contentOffset = CGPointMake(0,0);
}


//进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)deletedFreightTemplateCell:(ZJ_FreightTemplateCell *)freightTemplateCell indexPath:(NSIndexPath *)indexPath
{
    
    freightTemplateCell.deletedButton.tag = indexPath.row;
    
    if ([self.type intValue] == 0) {
       
        [self.weightArray removeObjectAtIndex:(indexPath.row)];
        
        _titleArr = self.weightArray;

    }else if ([self.type intValue] == 1)
    {
        [self.countArray removeObjectAtIndex:(indexPath.row)];
        
        _titleArr = self.countArray;
    }

    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel  alloc]init];
    
    if (newAndModifyTemplateModel != nil) {
        
        newAndModifyTemplateModel = _titleArr[indexPath.row - 1];
    }
    
    //model中只是移除的地区的ID，现在做的就是根据对应的东西，移除名字
    if (self.type.integerValue == 0) {
        
        [self.nameArr removeObjectAtIndex:indexPath.row];
        
    }else
    {
        [self.postCountArr removeObjectAtIndex:indexPath.row];
    }
    
    if ([self.type intValue] == 0) {
        
        //首重
        if (newAndModifyTemplateModel.frontWeight ) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontWeight] isEqualToString:@"0"]) {
                freightTemplateCell.firstThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontWeight];
            }
        }
        
        //续重
        if (newAndModifyTemplateModel.afterWeight) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterWeight] isEqualToString:@"0"]) {
                freightTemplateCell.goOnThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterWeight];
            }
            
        }
        
    }else{
        
        
        //首重
        if (newAndModifyTemplateModel.frontQuantity) {
            
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontQuantity] isEqualToString:@"0"]) {
                freightTemplateCell.firstThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontQuantity];
            }
            
        }
        //续重
        if (newAndModifyTemplateModel.afterQuantity ) {
            if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterQuantity] isEqualToString:@"0"]) {
                
                freightTemplateCell.goOnThingCountField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterQuantity];
                
            }
            
        }
    }
    
    //首费
    if (newAndModifyTemplateModel.frontFreight) {
        if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontFreight] isEqualToString:@"0"]) {
            freightTemplateCell.firstThingFreightMoneyField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontFreight];
            
        }
    }
    
    
    //续费
    if (newAndModifyTemplateModel.afterFreight ) {
        if (![[NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterFreight] isEqualToString:@"0"]) {
            freightTemplateCell.goOnThingFreightMoneyField.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterFreight];
        }
    }
    
    [self.tableView reloadData];
}



@end
