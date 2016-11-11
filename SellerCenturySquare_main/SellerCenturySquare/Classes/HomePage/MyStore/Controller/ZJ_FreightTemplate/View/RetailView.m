//
//  RetailView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RetailView.h"
#import "UIColor+UIColor.h"
#import "PublicFreightTemplateCell.h"
#import "HttpManager.h"
#import "FreightTempListModel.h"
#import "FreightTempModel.h"
#import "EditorTableViewCell.h"
#import "WholesaleAndRetailView.h"
#import "InitialFreighTemplateView.h"
#import "GUAAlertView.h"
#import "LookFreightTemplateViewController.h"
#import "EditorFreightListModel.h"
#import "RetailModel.h"
@interface RetailView ()<UITableViewDelegate,UITableViewDataSource,PublicFreightTemplateCellDelegate,InitialFreighTemplateViewDelegate,EditorTableViewCellDelegate>
{
    NSString *isDefaultStr;
    WholesaleAndRetailView *wholesaleAndRetail;
    InitialFreighTemplateView *initialView;
    //装选中模板数组
    NSMutableArray *selecdFreight;

}
//新建模版按钮
@property(nonatomic,strong)UIButton *templateButton;
//建立以及存在数据table
@property(nonatomic,strong)UITableView *tableView;
//建立全部模板table
@property(nonatomic,strong)UITableView *editorTableView;

@property (nonatomic,strong)UINavigationController *nav;
//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;

//展示批发端数组
@property (nonatomic,strong)NSMutableArray *wholesaleArr;
//进行数据储存
@property (nonatomic,strong)NSMutableArray * arr;

@end
@implementation RetailView
-(id)initWithFrame:(CGRect)frame nav:(UINavigationController *)nav
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.nav = nav;
        
        //进行数据刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataRetail) name:@"RetailNotification" object:nil];
        
        //设置UI
        [self makeUI];
        
         selecdFreight = [NSMutableArray array];
    }
    return self;
}

#pragma mark makeUI
-(void)makeUI
{
    //创建已经选中的tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64 - 49) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    //创建全部模板tableView
    self.editorTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT - 64 - 48) style:(UITableViewStyleGrouped)];
    self.editorTableView.delegate = self;
    self.editorTableView.dataSource = self;
    self.editorTableView.scrollEnabled = YES;
    self.editorTableView.hidden = YES;
    self.editorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.editorTableView];
    
    //创建模版按钮
    self.templateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.templateButton.frame = CGRectMake(0, self.frame.size.height - 49 - 64, self.frame.size.width, 49);
    self.templateButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [self.templateButton setTitle:@"编辑" forState:(UIControlStateNormal)];
    
    [self.templateButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self addSubview:self.templateButton];
    
    //添加观察者
    [self.templateButton addTarget:self action:@selector(setNewTemplateButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
}

-(NSMutableArray *)wholesaleArr
{
    if (!_wholesaleArr) {
        _wholesaleArr = [NSMutableArray array];
    }
    return _wholesaleArr;
}

-(NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

//显示小货车
-(void)showCar
{
    if (!initialView) {
        initialView = [[[NSBundle mainBundle]loadNibNamed:@"InitialFreighTemplateView" owner:self options:nil]lastObject];
        initialView.introductionLabel.text = @"可在此设置不同的“运费模板”作为配送方式，                                   共零售端用户在结算时自主选择。";
        initialView.delegate = self;
        initialView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT);
        [self addSubview:initialView];
    }
}

//加载显示数据列表
-(void)showAllFreightTemplate
{
    [initialView removeFromSuperview];
    
    if ((self.templateButton.selected =! self.templateButton.selected)) {
        
        self.retailLoad = EditorRetailTableViewLoad;
        [self.templateButton setTitle:@"保存" forState:(UIControlStateNormal)];
        
        [self.tableView reloadData];
    }
}




//获取到数据进行判断
-(void)getDatapareIofo:(NSNotification *)compareIofo;
{
    
    if (self.wholesaleArr.count != 0) {
        [self.wholesaleArr removeAllObjects];
    }
    
    
    if ([compareIofo.userInfo[@"code"] isEqualToString:@"000"]) {
        FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
        
        freightTempListModel.freightTempDTOList = [compareIofo.userInfo objectForKey:@"data"];
        
        self.infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
        
        if (self.infoListArr.count == 0) {
            initialView = [[[NSBundle mainBundle]loadNibNamed:@"InitialFreighTemplateView" owner:self options:nil]lastObject];
            initialView.delegate = self;
            initialView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT);
            [self addSubview:initialView];
        }else
        {
            for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
                
                FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
                
                [freightTempModel setDictFrom:dic];
                
                if ([freightTempModel.isRetail isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    [self.wholesaleArr addObject:freightTempModel];
                    
                }
            }
            
            self.arr = self.wholesaleArr;
            
            [self.tableView reloadData];
            
        }
    }
    
}

#pragma mark =============设置tableView代理方法===============
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      if (NormalRetailTableViewLoad == self.retailLoad)
      {
          return self.arr.count;
      }else if (EditorRetailTableViewLoad == self.retailLoad)
      {
          return _infoListArr.count;
      }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       if (NormalRetailTableViewLoad == self.retailLoad) {
        
        PublicFreightTemplateCell *freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"PublicFreightTemplateCell"];
        
        //#进行设置
        if (!freightTemplateCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublicFreightTemplateCell" bundle:nil] forCellReuseIdentifier:@"PublicFreightTemplateCell"];
            
            freightTemplateCell = [tableView dequeueReusableCellWithIdentifier:@"PublicFreightTemplateCell"];
        }
        
        freightTemplateCell.delegate = self;
        
        freightTemplateCell.selectButton.tag = indexPath.row;
        
        FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
        
        freightTempModel = self.arr[indexPath.row];
        
        freightTemplateCell.selectedLabel.text = freightTempModel.templateName;
        
        if ([freightTempModel.isRetailDefault isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            freightTemplateCell.selectButton.selected = NO;
        }
        else if([freightTempModel.isRetailDefault isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            freightTemplateCell.selectButton.selected = YES;
        }
        
        freightTemplateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return freightTemplateCell;
        
    }else if (EditorRetailTableViewLoad == self.retailLoad)
    {
        
        static NSString *cellID = @"EditorTableViewCell";
        
        EditorTableViewCell * cell = (EditorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == NULL) {
            
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"EditorTableViewCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
        }
        
        cell.delegate =  self;
        
        FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
        
        [freightTempModel setDictFrom:_infoListArr[indexPath.row]];
        
        cell.setFreightTemplateLabel.text = freightTempModel.templateName;
        
        cell.setFreightTemplateButton.tag = indexPath.row;
        
        if ([freightTempModel.isRetail isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            cell.setFreightTemplateButton.selected = NO;
        }
        else if([freightTempModel.isRetail isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            cell.setFreightTemplateButton.selected = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREEN_HIGHT - 64 - 49;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    wholesaleAndRetail = [[[NSBundle mainBundle]loadNibNamed:@"WholesaleAndRetailView" owner:self options:nil]lastObject];
    if (NormalRetailTableViewLoad == self.retailLoad) {
        
        wholesaleAndRetail.selectedUnPackage.text = @"用户不选择运费模板时，则按默认模板计算运费。";
        wholesaleAndRetail.unselectedPackage.hidden = YES;
        
    }else if (EditorRetailTableViewLoad == self.retailLoad)
    {
        wholesaleAndRetail.selectedUnPackage.text = @"∙ 用户不选择运费模板时，侧按默认模板计算运费。";
        wholesaleAndRetail.unselectedPackage.hidden = NO;
        
    }
    
    return wholesaleAndRetail;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (NormalRetailTableViewLoad == self.retailLoad)
    {
        FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
        freightTempModel = self.arr[indexPath.row];
        LookFreightTemplateViewController *lookFreightTemplateVC = [[LookFreightTemplateViewController alloc]init];
        
        lookFreightTemplateVC.Id = freightTempModel.Id;
        lookFreightTemplateVC.isDefault = freightTempModel.isDefault;
        lookFreightTemplateVC.lookTitle = freightTempModel.templateName;
        [self.nav pushViewController: lookFreightTemplateVC animated:YES];
    }
}

#pragma mark//设置选中后批发端口列表
-(void)setDefaultBtn:(UIButton *)defaluBtn
{
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    freightTempModel = self.arr[defaluBtn.tag];
    
    [self setDefaultBtnID:freightTempModel.Id type:[NSNumber numberWithInt:1] button:defaluBtn];
}

//设置默认按钮
-(void)setDefaultBtnID:(NSNumber *)defaultID  type:(NSNumber *)type  button:(UIButton *)button
{
    
    [HttpManager sendHttpRequestForUpdateGetFreightTemplateID:defaultID freightTemplateType:type Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
//            [MBProgressHUD hideHUDForView:self  animated:YES];
            
//            button.selected = !button.selected;
            
            [self getDataRetail];
            
            NSLog(@"请求数据成功");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark//设置选中后批发端口展示全部模板列表
-(void)setEditorButton:(UIButton *)editorButton
{
    
    [selecdFreight removeAllObjects];
    
    editorButton.selected = !editorButton.selected;
    //包邮
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic = [_infoListArr[editorButton.tag] mutableCopy];
    
    if (!editorButton.selected) {
        [dic setValue:[NSNumber numberWithInt:0] forKey:@"isRetail"];
        [_infoListArr replaceObjectAtIndex:editorButton.tag withObject:dic];
        
        [self.tableView reloadData];
        return;
    }
    
    
    for (NSDictionary *dic  in _infoListArr) {
        
        if (![dic[@"isDefault"] isEqualToString:@"2"])
        {
            if ([dic[@"isRetail"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [selecdFreight addObject:dic];
                
            }
        }
    }
    
    
     if (![dic[@"isDefault"] isEqualToString:@"2"]) {
         if (selecdFreight.count >= 3) {
             
             editorButton.selected = NO;
             
             NSNotification *notification = [[NSNotification alloc]initWithName:@"showThreeFreight" object:self userInfo:nil];
             [[NSNotificationCenter defaultCenter]postNotification:notification];
             
             return;
         }
     }
   
    if ([dic[@"isDefault"] isEqualToString:@"2"]) {
        
        for (int i = 0; i < _infoListArr.count; i ++) {
            
            dic = [_infoListArr[i] mutableCopy];
            
            if (i == editorButton.tag) {
                
                [dic setValue:[NSNumber numberWithInt:1] forKey:@"isRetail"];
                
            }else {
                
                [dic setValue:[NSNumber numberWithInt:0] forKey:@"isRetail"];
            }
            
            [_infoListArr replaceObjectAtIndex:i withObject:dic];
            
        }
        
    }else
    {
        for (int i = 0; i < _infoListArr.count; i ++) {
            
            dic = [_infoListArr[i] mutableCopy];
            
            if ([dic[@"isDefault"] isEqualToString:@"2"]) {
                
                [dic setValue:[NSNumber numberWithInt:0] forKey:@"isRetail"];
                
            }else if(i == editorButton.tag){
                [dic setValue:[NSNumber numberWithInt:1] forKey:@"isRetail"];
            }
            [_infoListArr replaceObjectAtIndex:i withObject:dic];
            
        }
        
    }
    
    [self.tableView reloadData];
    
}

-(void)setNewTemplateButtonAction
{
    
    if ((self.templateButton.selected =! self.templateButton.selected)) {

        self.retailLoad = EditorRetailTableViewLoad;
        [self.templateButton setTitle:@"保存" forState:(UIControlStateNormal)];
        
        [self.tableView reloadData];
        
    }else
    {
        
        NSMutableArray *editorArr = [NSMutableArray array];
        for (int i = 0; i < _infoListArr.count; i ++ ) {
            RetailModel *editorFreightModel = [[RetailModel alloc]init];
            [editorFreightModel setDictFrom:_infoListArr[i]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:editorFreightModel.Id forKey:@"id"];
            [dic setObject:editorFreightModel.isRetail forKey:@"isRetail"];
            [editorArr addObject:dic];
        }
        
        
        NSMutableArray *arr = [NSMutableArray array];
        
        [arr removeAllObjects];
        
        for (NSDictionary *dic in editorArr) {
            
            if ([dic[@"isRetail"]  intValue] == 1) {
                [arr addObject:dic];
            }
        }

        if (arr.count == 0) {
            
            [self makeMessage:@"请选择运费模板" duration:2.0f position:@"center"];
            
            return;
            
        }else
        {
            
            [self setFreightTemplateArr:editorArr];
            
        }
        self.retailLoad = NormalRetailTableViewLoad;
        
      

    
    }
}


//设置默认按钮
-(void)setFreightTemplateArr:(NSMutableArray *)freightTemplateArr
{
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"SaveFreightTemplateType" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpManager sendHttpRequestForGetTemplateArrList:freightTemplateArr Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSNotification *notification = [[NSNotification alloc]initWithName:@"EndSaveFreightTemplateType" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];

//            [MBProgressHUD hideHUDForView:self  animated:YES];
            
            [self getDataRetail];
            
            NSLog(@"请求数据成功");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNotification *notification = [[NSNotification alloc]initWithName:@"EndSaveFreightTemplateType" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];

    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RetailNotification" object:nil];
}


#pragma mark 获取列表数据
-(void)getDataRetail
{
    
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSNotification *notification = [[NSNotification alloc]initWithName:@"showRetailNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [HttpManager  sendHttpRequestForUpdateGetFreightTemplateListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _infoListArr = [[NSMutableArray alloc]initWithCapacity:40];
        
        NSMutableArray *userIofoArr = [NSMutableArray array];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
//            [MBProgressHUD hideHUDForView:self  animated:YES];
            NSNotification *notification = [[NSNotification alloc]initWithName:@"hideRetailNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            
            FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
            
            freightTempListModel.freightTempDTOList = [dic objectForKey:@"data"];
                self.infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
                
                for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
                    
                    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
                    
                    [freightTempModel setDictFrom:dic];
                    
                    if ([freightTempModel.isRetail isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        [userIofoArr addObject:freightTempModel];
                        
                    }
                }
                
                self.arr = userIofoArr;
            if (self.arr.count == 0) {
                [self showCar];
            }else
            {
                [initialView removeFromSuperview];
            }

              [self.templateButton setTitle:@"编辑" forState:(UIControlStateNormal)];
                [self.tableView reloadData];
                

            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSNotification *notification = [[NSNotification alloc]initWithName:@"hideRetailNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }];
    
}


@end
