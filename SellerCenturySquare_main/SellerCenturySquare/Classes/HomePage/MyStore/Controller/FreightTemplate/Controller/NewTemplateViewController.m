//
//  NewTemplateViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "NewTemplateViewController.h"
#import "UIColor+UIColor.h"
#import "AddAndmodificationTemplateCell.h"
#import "FreightTempView.h"
#import "HttpManager.h"
#import "SelectedAreaModel.h"
#import "AddAndModifTemplateCell.h"

#import "NewAndModifyTemplateModel.h"
#import "NewAndModifyTemplateListModel.h"
#import "GUAAlertView.h"

@interface NewTemplateViewController ()<UITableViewDataSource,UITableViewDelegate,FreightTempViewDelegate,AddAndModifTemplateCellDelegate,UITextFieldDelegate>

{
    NSString *nameString;
    CGFloat cellHeight;
    NSInteger numBer;
    
    FreightTempView *freightTempView;
    
    UIView *headerView;
    
    NSMutableArray *arr;
   
    
}



//设置显示
@property (nonatomic,strong)UITableView *tableView;
//设置显示保存按钮
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)UIScrollView *scrollView;
//添加指定区域按钮
@property (nonatomic,strong)UIButton *designatedAreaButton;
//设置可变数组
@property (nonatomic,strong)NSMutableArray *dataArr;
//设置可变数组
@property (nonatomic,strong)NSMutableArray *textFieldArr;

//
@property (nonatomic,strong)NSMutableArray *titleArr;

@property (nonatomic,strong)NSMutableArray *nameCityArr;
//获取省市区字符串
@property (nonatomic,strong)NSString *cityString;
//
@property (nonatomic,strong)NSMutableArray * weightArray;
@property (nonatomic,strong)NSMutableArray * countArray;
//
@property (nonatomic,strong)NSMutableArray *areasID;
//
@property (nonatomic,strong)NSMutableArray *countNameArray;
//
@property (nonatomic,strong)UITableView *typeTableView;
//
@property (nonatomic,strong)NSMutableArray *postWeightArr;
//
@property (nonatomic,strong)NSMutableArray *postCountArr;


@end

@implementation NewTemplateViewController

-(NSMutableArray *)textFieldArr
{
    if (_textFieldArr == nil) {
        _textFieldArr = [NSMutableArray array];
    }
    return  _textFieldArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置运费";
    //设置返回按钮
    [self customBackBarButton];
    //设置UI
    [self makeUI];
    //封装cell数据
    _nameCityArr = [[NSMutableArray alloc]initWithCapacity:0];
    _weightArray = [[NSMutableArray alloc]initWithCapacity:0];
    _countArray = [[NSMutableArray alloc] initWithCapacity:0];
    _postWeightArr = [[NSMutableArray alloc] initWithCapacity:0];
    _postCountArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    _areasID = [[NSMutableArray alloc]initWithCapacity:0];
    _countNameArray = [[NSMutableArray alloc]initWithCapacity:0];

    
    if (self.manageTemplate == AddNewTemplate) {
        
        self.type = @"0";
        
        //初始化
        NewAndModifyTemplateModel *weightModel = [[NewAndModifyTemplateModel alloc]init];
        
        [_weightArray addObject:weightModel];
        
        NewAndModifyTemplateModel *countModel = [[NewAndModifyTemplateModel alloc]init];
        
        [_countArray addObject:countModel];
        
         _titleArr = _weightArray;
        
    }else if (self.manageTemplate == ModifyTemplate)
    {
        
        NewAndModifyTemplateModel *postWeightModel = [[NewAndModifyTemplateModel alloc]init];
        
        NewAndModifyTemplateModel *postCountModel = [[NewAndModifyTemplateModel alloc]init];

        if (self.type.integerValue == 0) {
            
            if (self.lookList.count == 0) {
                
                [_postWeightArr addObject:postWeightModel];

            }else
            {
                for (NSDictionary *dic in self.lookList) {
                    
                    [postWeightModel setDictFrom:dic];
                    
                    [_postWeightArr  addObject:postWeightModel];
                }
            }
            _titleArr = [_postWeightArr copy];
 
        }else
        {
            
            if (self.lookList.count == 0) {
                
                 [_postCountArr addObject:postWeightModel];
                
            }else
            {
                for (NSDictionary *dic in self.lookList) {
                    
                    [postCountModel  setDictFrom:dic];
                }
                
                [_postCountArr addObject:postCountModel];
            }
        
            _titleArr = [_postCountArr copy];
        }
    }
}

//设置UI
-(void)makeUI
{
      //设置显示列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 49) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    
    //设置显示保存按钮浮框
    self.saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveButton.frame = CGRectMake(0,self.view.frame.size.height -  49, self.view.frame.size.width, 49);
    [self.saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [self.view addSubview:self.saveButton];
    self.saveButton.backgroundColor = [UIColor purpleColor];
    self.saveButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [self.saveButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.view addSubview:self.saveButton];
    
    [self.saveButton addTarget:self action:@selector(saveTemplateType) forControlEvents:(UIControlEventTouchUpInside)];
    
}

#pragma mark === 根据按钮选择按重量和按件数====
//根据按钮选择按重量和按件数
-(void)selectedEventAction:(UIButton *)selectedButton section:(NSInteger )section
{
    [self.tableView endEditing:YES];
    selectedButton.selected = !selectedButton.selected;
    
    if (self.manageTemplate == AddNewTemplate) {
        if ([self.type intValue]) {
            
            _titleArr = _weightArray;
            self.type = @"0";
            [self.tableView reloadData];
            
        }else
        {
            _titleArr = _countArray;
            self.type = @"1";
            [self.tableView reloadData];
            
        }
  
    }else if (self.manageTemplate == ModifyTemplate)
    {
        if ([self.type intValue]) {
            
            _titleArr = _postWeightArr;
            self.type = @"0";
            [self.tableView reloadData];
            
        }else
        {
            _titleArr = _postCountArr;
            self.type = @"1";
            [self.tableView reloadData];
        }
    }
}
#pragma mark ==========tableView代理方法==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *cellID = @"AddAndModifTemplateCell";
    AddAndModifTemplateCell * cell = (AddAndModifTemplateCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == NULL) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AddAndModifTemplateCell" owner:self options:nil] ;
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    if (indexPath.row == 0) {
        cell.imageView.hidden = YES;
        [cell.cityButton setTitle:@"除设置的指定地区之外的地区均以计价方式核算运费" forState:(UIControlStateNormal)];
        cell.cityButton.font = [UIFont systemFontOfSize:12];
        [cell.cityButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        cell.cityButton.selected = NO;
        cell.leftLenght.constant = -120;
        cell.tapLenght.constant = 40;
        cell.widthLenght.constant = 400;
        cell.defaultLabel.text = @"默认运费:";
    }

    
    cell.delegate = self;
    cell.index_row = indexPath;
#pragma mark  textfiled 代理sel
    //tag值(打上tag值)代理方法
    cell.firstThingCountText.delegate = self;
    cell.firstThingCountText.tag = indexPath.row;
    
    cell.firstThingFreightText.delegate = self;
    cell.firstThingFreightText.tag = indexPath.row;
    
    cell.goOnThingFreightText.delegate = self;
    cell.goOnThingFreightText.tag = indexPath.row;
    
    cell.goOnText.delegate = self;
    cell.goOnText.tag = indexPath.row;
    
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel  alloc]init];

    if (self.manageTemplate == AddNewTemplate) {
        
        newAndModifyTemplateModel = _titleArr[indexPath.row];
        
        if (indexPath.row > 0) {
            
            NSString *nameStr;
            if ([self.type isEqualToString: @"0"]) {
                if (_nameCityArr.count > 0) {
                    
                    nameStr = [_nameCityArr objectAtIndex:(indexPath.row - 1)];
                    
                }else
                {
                    nameStr = @"";
                }
                
                [cell.cityButton setTitle:nameStr forState:(UIControlStateNormal)];
                CGSize nameSize = [self sizeWithText:nameStr font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, MAXFLOAT)];
                cell.cityButton.titleLabel.numberOfLines = 0;
                cell.cityConstraint.constant = nameSize.height;
                
            }else
            {
                if (_countNameArray.count > 0) {
                    
                    nameStr = [_countNameArray objectAtIndex:(indexPath.row - 1)];
                    
                }else
                {
                    nameStr = @"";
                }
                
                [cell.cityButton setTitle:nameStr forState:(UIControlStateNormal)];
                CGSize nameSize = [self sizeWithText:nameStr font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, MAXFLOAT)];
                cell.cityButton.titleLabel.numberOfLines = 0;
                cell.cityConstraint.constant = nameSize.height;
            }
        }
        
    }else if (self.manageTemplate == ModifyTemplate)
    {

        newAndModifyTemplateModel = _titleArr[indexPath.row ];

        
        NSLog(@"newAndModifyTemplateModel === %@",newAndModifyTemplateModel.expressArea);
        
        if (indexPath.row == 0) {
            
            cell.imageView.hidden = YES;
            [cell.cityButton setTitle:@"除设置的指定地区之外的地区均以计价方式核算运费" forState:(UIControlStateNormal)];
            cell.cityButton.font = [UIFont systemFontOfSize:12];
            [cell.cityButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            cell.cityButton.selected = NO;
            cell.leftLenght.constant = -120;
            cell.tapLenght.constant = 40;
            cell.widthLenght.constant = 400;
            cell.defaultLabel.text = @"默认运费:";
            
        }else
        {

            if (newAndModifyTemplateModel.expressArea != NULL) {
                CGSize nameSize = [self sizeWithText:newAndModifyTemplateModel.expressArea font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, MAXFLOAT)];
                
                cell.cityButton.titleLabel.numberOfLines = 0;
                
                cell.cityConstraint.constant = nameSize.height;
                
                [cell.cityButton setTitle:newAndModifyTemplateModel.expressArea forState:(UIControlStateNormal)];
                
            }
        }
    }
    
    
    
    if (![self.type intValue]) {
        
        cell.firstThingLabel.text = @"首重";
        cell.firstUnitLabel.text = @"kg";
        cell.goOnThingFreightLabel.text = @"续重";
        cell.secondKgLabel.text = @"kg";
        
        //首重
        if (newAndModifyTemplateModel.frontWeight ) {
            cell.firstThingCountText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontWeight];
        }
        
        //续重
        if (newAndModifyTemplateModel.afterWeight) {
            cell.goOnThingFreightText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterWeight];
        }
        
    }else{
        
        cell.firstThingLabel.text = @"首件";
        cell.firstUnitLabel.text = @"件";
        cell.goOnThingFreightLabel.text = @"续件";
        cell.secondKgLabel.text = @"件";
        
        //首重
        if (newAndModifyTemplateModel.frontQuantity ) {
            cell.firstThingCountText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontQuantity];
        }
        //续重
        if (newAndModifyTemplateModel.afterQuantity ) {
            cell.goOnThingFreightText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterQuantity];
        }
    }
    
    //首费
    if (newAndModifyTemplateModel.frontFreight ) {
        cell.firstThingFreightText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.frontFreight];
    }
    
    //续fei
    if (newAndModifyTemplateModel.afterFreight ) {
        cell.goOnText.text = [NSString stringWithFormat:@"%@",newAndModifyTemplateModel.afterFreight];
    }
   
    
    return cell;
}

//键盘弹出的时候触发的方法
- (void)keyboardJumpCell:(AddAndModifTemplateCell *)cell
{
    [cell.firstThingCountText resignFirstResponder];
    [cell.goOnThingFreightText resignFirstResponder];
    [cell.firstThingFreightText resignFirstResponder];
    [cell.goOnText resignFirstResponder];
    
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
}

//textField代理方法
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   
    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:textField.tag inSection:0];
    //初始化
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel alloc]init];
    AddAndModifTemplateCell *cell = (AddAndModifTemplateCell *)[self.tableView cellForRowAtIndexPath:pathOne];
    
    if (self.manageTemplate == AddNewTemplate) {
        
        if (![self.type intValue]) {
            newAndModifyTemplateModel = _weightArray[pathOne.row];
            
            //首重
            if (cell.firstThingCountText == textField ) {
                NSLog(@"text===%@==%@",textField.text,[NSNumber numberWithDouble:textField.text.doubleValue]);
                
                newAndModifyTemplateModel.frontWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续重
            if (cell.goOnThingFreightText == textField) {
                newAndModifyTemplateModel.afterWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            
            //首费
            if (cell.firstThingFreightText == textField) {
                newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续费
            if (cell.goOnText == textField) {
                
                newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            
            [_weightArray replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
            
            _titleArr = _weightArray;
            
        }else{
            newAndModifyTemplateModel = _countArray[pathOne.row];
            
            //首重
            if (cell.firstThingCountText == textField ) {
                NSLog(@"text===%@==%@",textField.text,[NSNumber numberWithDouble:textField.text.doubleValue]);
                
                newAndModifyTemplateModel.frontQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续重
            if (cell.goOnThingFreightText == textField) {
                newAndModifyTemplateModel.afterQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            //首费
            if (cell.firstThingFreightText == textField) {
                newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续费
            if (cell.goOnText == textField) {
                
                newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            [_countArray replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
            _titleArr = _countArray;
            
        }
        
        newAndModifyTemplateModel = _titleArr[pathOne.row];

    }else if (self.manageTemplate == ModifyTemplate)
    {
       
        newAndModifyTemplateModel = _postWeightArr[pathOne.row];
        
        if (![self.type intValue]){

            //首重
            if (cell.firstThingCountText == textField ) {
                NSLog(@"text===%@==%@",textField.text,[NSNumber numberWithDouble:textField.text.doubleValue]);
                
                newAndModifyTemplateModel.frontWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            // 续重
            if (cell.goOnThingFreightText == textField) {
                newAndModifyTemplateModel.afterWeight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }

            //首费
            if (cell.firstThingFreightText == textField) {
                newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续费
            if (cell.goOnText == textField) {
                
                newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }

            [_postWeightArr replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
            
            _titleArr = _postWeightArr;
            
        }else
        {
            newAndModifyTemplateModel = _postCountArr[pathOne.row];

            //首件
            if (cell.firstThingCountText == textField ) {
                NSLog(@"text===%@==%@",textField.text,[NSNumber numberWithDouble:textField.text.doubleValue]);
                
                newAndModifyTemplateModel.frontQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续件
            if (cell.goOnThingFreightText == textField) {
                newAndModifyTemplateModel.afterQuantity = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            //首费
            if (cell.firstThingFreightText == textField) {
                newAndModifyTemplateModel.frontFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            // 续费
            if (cell.goOnText == textField) {
                
                newAndModifyTemplateModel.afterFreight = [NSNumber numberWithDouble:textField.text.doubleValue];
            }
            
            [_postCountArr replaceObjectAtIndex:pathOne.row withObject:newAndModifyTemplateModel];
            
            _titleArr = _postCountArr;
            
        }
        
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAndModifTemplateCell *cell = (AddAndModifTemplateCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        return 180;
    }else
    {
      return  cell.cityConstraint.constant + 130;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 105;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if (!freightTempView) {
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        headerView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
        
        freightTempView = [[[NSBundle mainBundle]loadNibNamed:@"FreightTempView" owner:nil options:nil]lastObject];
        freightTempView.delegate = self;
        freightTempView.section = section;
        freightTempView.textField.text = self.templateName;
        freightTempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
        [headerView addSubview:freightTempView];
        
        if (self.manageTemplate == AddNewTemplate) {
            
            
        }else if (self.manageTemplate == ModifyTemplate)
        {
            if ([self.type isEqualToString:@"0"]) {
                
                [freightTempView.selectedTypeButton setTitle:@"按重量" forState:(UIControlStateNormal)];
            }else if ([self.type isEqualToString:@"1"])
            {
                [freightTempView.selectedTypeButton setTitle:@"按件数" forState:(UIControlStateNormal)];
                
            }
        }
        
        nameString = freightTempView.textField.text;
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    //添加指定区域按钮
    self.designatedAreaButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.designatedAreaButton.frame = CGRectMake(15, 10, 150, 30);
    [self.designatedAreaButton setTitle:@"新建指定区域运费" forState:(UIControlStateNormal)];
    [view addSubview:self.designatedAreaButton];
    [self.designatedAreaButton addTarget:self action:@selector(addDesignatedAreaButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.designatedAreaButton setFont:[UIFont systemFontOfSize:14]];
    [self.designatedAreaButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    self.designatedAreaButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
   
      return view;
}

#pragma mark ======添加指定区域运费模版===
-(void)addDesignatedAreaButtonAction
{
    //初始化
    NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel alloc]init];
    
    [_nameCityArr addObject:@""];
    [_areasID addObject:@""];
    [_countNameArray addObject:@""];
    
    if (self.manageTemplate == AddNewTemplate) {
        
        [_titleArr addObject:newAndModifyTemplateModel];
        
    }else if (self.manageTemplate == ModifyTemplate)
    {
        if (self.type.integerValue == 0) {
            [_postWeightArr addObject:newAndModifyTemplateModel];
            _titleArr = [_postWeightArr copy];
            
        }else
        {
            [_postCountArr addObject:newAndModifyTemplateModel];
            _titleArr = [_postCountArr copy];
        }
    }
    [self.tableView reloadData];
}

#pragma mark ===========cell代理方法=====
-(void)joinAreaDetailPageIndexPath:(NSIndexPath *)indexPath
{
   
    /*
    SelectedAreaViewController *selectedAreaVC = [[SelectedAreaViewController alloc]init];
    selectedAreaVC.selectedAllAreas = ^(NSString *strID,NSString *nameStr)
    {
        NewAndModifyTemplateModel *templateModel;
       
        
        if (self.type.integerValue == 0 ) {
            
             templateModel =_postWeightArr[indexPath.row];
            
        }else
        {
             templateModel =_postCountArr[indexPath.row];
        }
    
        if (self.manageTemplate == AddNewTemplate) {
            
            [_areasID replaceObjectAtIndex:(indexPath.row - 1) withObject:strID];
            
            if ([self.type isEqualToString: @"0"]) {
                
                [_nameCityArr replaceObjectAtIndex:(indexPath.row - 1) withObject:nameStr];
            }else
            {
                [_countNameArray replaceObjectAtIndex:(indexPath.row - 1) withObject:nameStr];
            }
            
        }else if (self.manageTemplate == ModifyTemplate)
        {
            templateModel.expressArea = nameStr;
            
//            templateModel.expressAreaId = strID;

            if (self.type.integerValue == 0) {
                
                [_postWeightArr replaceObjectAtIndex:(indexPath.row - 1) withObject:templateModel];
                
            }else
            {
                [_postCountArr replaceObjectAtIndex:(indexPath.row - 1) withObject:templateModel];
            }
        }
        
            [self.tableView  reloadData];
    };
    
    [self.navigationController pushViewController:selectedAreaVC animated:YES];
     
     */
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
#pragma mark =========进行数据保存===
-(void)saveTemplateType
{
    
/*
    [self checkInputValues];
    
    for (int i = 0;i <_titleArr.count;i++) {
        
        NewAndModifyTemplateModel* newAndModifyTemplateModel = [ _titleArr objectAtIndex:i];
        
        newAndModifyTemplateModel.isDefault = i?@"1":@"0";
        
        if ([newAndModifyTemplateModel.isDefault isEqualToString:@"0"]) {
            
            if (self.type.integerValue == 0) {
                
                if (newAndModifyTemplateModel.frontWeight == nil) {
                    [self.view makeMessage:@"默认模板首重不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.afterWeight == nil) {
                    [self.view makeMessage:@"默认模板续重不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.frontFreight == nil) {
                    [self.view makeMessage:@"默认模板首费不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.afterFreight == nil) {
                    [self.view makeMessage:@"默认模板续费不能为空" duration:2.0f position:@"center"];
                    return;
                }

                
            }else
            {
                
                if (newAndModifyTemplateModel.frontWeight == nil) {
                    [self.view makeMessage:@"默认模板首件不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.afterWeight == nil) {
                    [self.view makeMessage:@"默认模板续件不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.frontFreight == nil) {
                    [self.view makeMessage:@"默认模板首费不能为空" duration:2.0f position:@"center"];
                    return;
                }
                if (newAndModifyTemplateModel.afterFreight == nil) {
                    [self.view makeMessage:@"默认模板续费不能为空" duration:2.0f position:@"center"];
                    return;
                }

            }

        }else
        {
            newAndModifyTemplateModel.expressArea = [_areasID objectAtIndex:(i - 1)];
        }
        
        [arr addObject: newAndModifyTemplateModel.mj_keyValues];
        
        }
    
  
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定保存运费模版?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            
            [self saveTemplate];
        } dismissAction:^{
            
        }];
        [alert show];
 
 */
}

-(void)saveTemplate
{
 
        //添加新的模版
        if (self.manageTemplate == AddNewTemplate) {
            
            [HttpManager sendHttpRequestForGetFreightTemplateName:freightTempView.textField.text type:self.type setList:arr  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    NSLog(@"请求数据成功");
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
            }];
        }
        //修改模版保存
        else if (self.manageTemplate == ModifyTemplate)
        {
            
            [HttpManager sendHttpRequestForGetFreightTemplateName: freightTempView.textField.text type:self.type templateNameID:self.templateID setList:arr success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    NSLog(@"请求sdhfdsfjkdshfdshjkhkjs数据成功");
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error==%@",error);
                
            }];
    }
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}


-(void)hideKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark ===sel===
//运费模版名称
-(BOOL)verifyTemplateName
{
    if ([freightTempView.textField.text isEqualToString:@""]|| freightTempView.textField.text == nil) {
        
        [self.view makeMessage:@"请填写运费模板名称" duration:2.0f position:@"center"];
        
        return NO;
    }

    return YES;
}

#pragma mark===================所有的校验在此方法中进行===============================
- (BOOL)checkInputValues {
   
       return YES;

}




@end
