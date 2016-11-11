//
//  CPSGoodsDetailsEditViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
/*
 
 修改alert为自定义提示view
 
 */

#import "CPSGoodsDetailsEditViewController.h"
#import "CSPGoodsDetailsEditButtomView.h"
#import "GetGoodsInfoListDTO.h"
#import "CSPCustomLabel.h"
#import "CSPCustomTextField.h"
#import "CSPStepView.h"
#import "CSPSkuView.h"
#import "CPSGoodsDetailsPreviewViewController.h"
#import "CPSUploadReferImageViewController.h"
#import "GetImageReferImageHistoryListDTO.h"
#import "CPSUploadReferImageSucessfulViewController.h"
#import "GUAAlertView.h"// !自定义提示view
#import "CPSGoodsDetailsEditViewControllerCellID0.h"
#import "GoodsLagViewController.h"

@interface CPSGoodsDetailsEditViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate> {
    
    UILabel *batchNumLimitLabel;
    
    // !自定义提示view
    GUAAlertView *customAlertView;
    
    
}

@property(nonatomic,strong)GetGoodsInfoListDTO *getGoodsInfoList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  存放上传参考图的历史图片
 */
@property (strong,nonatomic)NSMutableArray *historyDataArray;

- (IBAction)previewButtonClick:(id)sender;

- (IBAction)saveButtonClick:(id)sender;

@end

@implementation CPSGoodsDetailsEditViewController{
    
    /**
     *  控制是否可以编辑
     */
    BOOL _isEdit;
    
    BOOL _isShowKeyboard;
    
    NSInteger _goodsStatus;
    
    CGFloat _lastScrollOffset;
    
    /**
     *  保存最后一次移动的位移
     */
    CGFloat _scrollOffset;
    
    /**
     *  是否预览
     */
    BOOL _isPreview;
    
    /**
     *  判断商品详情请求是否成功
     */
    BOOL _isRequestGoodsDetailsSuccess;
    
    /**
     *  判断请求上传历史请求是否成功
     */
    BOOL _isRequestHistoryDataSuccess;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [self customBackBarButton];
    
    UIBarButtonItem *rightBarButton = [self barButtonWithtTitle:@"上传参考图" font:[UIFont systemFontOfSize:13]];
    
    if (rightBarButton) {
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
    [self setExtraCellLineHidden:self.tableView];
    
    self.historyDataArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    
    
}

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    if (_isShowKeyboard) {
        
        //!阶梯价格
        UITableViewCell *stepCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        DebugLog(@"stepCell.subviews.count = %lu", (unsigned long)stepCell.subviews.count);
        
        for (UIView *view in stepCell.subviews) {
            
            for (UIView *subview in view.subviews) {
                
                if ([subview isKindOfClass:[UITextField class]]) {
                    
                    [subview resignFirstResponder];
                }
            }
        }
        //!样板价
        UITableViewCell *samplePriceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        
        UITextField *samplePriceTextField = (UITextField *)[samplePriceCell viewWithTag:102];
        
        [samplePriceTextField resignFirstResponder];
        
        [self reloadTableViewForRow:2 section:0];
        
        //恢复开始位置
        CGPoint point = self.tableView.contentOffset;
        
        point.y = _scrollOffset;
        
        [self.tableView setContentOffset:point animated:YES];
        
        
    }

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_isPreview) {
        
        [self requestData];
        
    }
}


#pragma mark-上传参考图
- (void)rightButtonClick:(UIButton *)sender{
    
//    GoodsLagViewController *goodsLadVC = [[GoodsLagViewController alloc] init];
//    
//    
//    [self.navigationController pushViewController:goodsLadVC animated:YES];
//    
    
    
    //需要判断是否有上传历史
    if (self.historyDataArray.count) {
        
        //有上传历史
        CPSUploadReferImageSucessfulViewController *uploadReferImageSucessfulViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageSucessfulViewController"];
        
        uploadReferImageSucessfulViewController.goodsNo = self.goodsNo;
        
        [self.navigationController pushViewController:uploadReferImageSucessfulViewController animated:YES];
        
    }else{
        
        //无上传历史
        CPSUploadReferImageViewController *uploadReferImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageViewController"];
        
        uploadReferImageViewController.goodsNo = self.goodsNo;
        
        [self.navigationController pushViewController:uploadReferImageViewController animated:YES];
    
        
    }
    
    
}

#pragma mark-计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification{
    
    if (_isEdit) {
        
        return;
    }
    
    _scrollOffset = _lastScrollOffset;
    
    DebugLog(@"_scrollOffset = %f", _scrollOffset);
    
    if (!_isShowKeyboard) {
        
        _isShowKeyboard = YES;
        
        //键盘需要弹出的高度
        CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
        
        DebugLog(@"change = %f", change);
        
        CGPoint point = self.tableView.contentOffset;
        
        point.y = point.y+change;
        
        self.tableView.contentOffset = point;
        
    }
}

- (void)keyboardWillDisappear:(NSNotification *)notification{
    _isShowKeyboard = NO;
    
    
}

- (void)doneButton:(UIButton *)sender{
    DebugLog(@"完成");
}

#pragma mark-请求上传历史数据
- (void)requestHistoryData{
    
    [HttpManager sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求完成
        _isRequestHistoryDataSuccess = YES;
        
        if (_isRequestHistoryDataSuccess && _isRequestGoodsDetailsSuccess) {
            
            _isRequestGoodsDetailsSuccess = NO;
            
            _isRequestHistoryDataSuccess = NO;
            
            [self.progressHUD hide:YES];
        }
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据合法
            if ([self checkData:data class:[NSArray class]]) {
                
                [self.historyDataArray removeAllObjects];
                
                for (NSDictionary *dic in data) {
                    
                    GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [[GetImageReferImageHistoryListDTO alloc]init];
                    
                    [getImageReferImageHistoryListDTO setDictFrom:dic];
                    
                    [self.historyDataArray addObject:getImageReferImageHistoryListDTO];
                }
            }
            
        }else{
            
            [self alertViewWithTitle:@"上传历史加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求完成
        _isRequestHistoryDataSuccess = YES;
        
        if (_isRequestHistoryDataSuccess && _isRequestGoodsDetailsSuccess) {
            
            _isRequestGoodsDetailsSuccess = NO;
            
            _isRequestHistoryDataSuccess = NO;
            
            [self tipRequestFailureWithErrorCode:error.code];
        }
    }];
}

#pragma mark-请求商品详情
- (void)requestGoodsDetailsData{
    
    [HttpManager sendHttpRequestForGetGoodsInfoList:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求完成
        _isRequestGoodsDetailsSuccess = YES;
        
        if (_isRequestHistoryDataSuccess && _isRequestGoodsDetailsSuccess) {
            
            _isRequestGoodsDetailsSuccess = NO;
            
            _isRequestHistoryDataSuccess = NO;
            
            [self.progressHUD hide:YES];
        }
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic%@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据的合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                self.getGoodsInfoList = nil;
                
                self.getGoodsInfoList = [[GetGoodsInfoListDTO alloc]init];
                
                [self.getGoodsInfoList setDictFrom:data];
                
                id stepDTOList = [data objectForKey:@"stepList"];
                
                //判断数据合法 steplist
                if ([self checkData:stepDTOList class:[NSArray class]]) {
                    
                    for (NSDictionary *stepDic in stepDTOList) {
                        
                        StepDTO *stepDTO = [[StepDTO alloc]init];
                        
                        [stepDTO setDictFrom:stepDic];
                        
                        [self.getGoodsInfoList.stepDTOList addObject:stepDTO];
                    }
                }
                
                //判断数据合法 windowImageList
                id windowImageList = [data objectForKey:@"windowImageList"];
                
                if ([self checkData:windowImageList class:[NSArray class]]) {
                    
                    for (NSDictionary *windowImageDic in windowImageList) {
                        
                        PicDTO *picDTO = [[PicDTO alloc]init];
                        
                        [picDTO setDictFrom:windowImageDic];
                        
                        [self.getGoodsInfoList.windowImageList addObject:picDTO];
                    }
                }
                
                //判断数据合法 objectiveImageList
                id objectiveImageList = [data objectForKey:@"objectiveImageList"];
                
                if ([self checkData:objectiveImageList class:[NSArray class]]) {
                    
                    for (NSDictionary *objectiveImageDic in objectiveImageList) {
                        
                        PicDTO *picDTO = [[PicDTO alloc]init];
                        
                        [picDTO setDictFrom:objectiveImageDic];
                        
                        [self.getGoodsInfoList.objectiveImageList addObject:picDTO];
                    }
                }
                
                //判断数据合法 windowImageList
                id referImageList = [data objectForKey:@"referImageList"];
                
                if ([self checkData:referImageList class:[NSArray class]]) {
                    
                    for (NSDictionary *referImageDic in referImageList) {
                        
                        PicDTO *picDTO = [[PicDTO alloc]init];
                        
                        [picDTO setDictFrom:referImageDic];
                        
                        [self.getGoodsInfoList.referImageList addObject:picDTO];
                    }
                }
                
                //判断数据合法 skuList
                id skuList = [data objectForKey:@"skuList"];
                
                if ([self checkData:skuList class:[NSArray class]]) {
                    
                    for (NSDictionary *skuDic in skuList) {
                        
                        SkuDTO *skuDTO = [[SkuDTO alloc]init];
                        
                        [skuDTO setDictFrom:skuDic];
                        
                        [self.getGoodsInfoList.skuDTOList addObject:skuDTO];
                    }
                }
                
                if (self.getGoodsInfoList.goodsStatus.integerValue == 1) {
                    _goodsStatus = 1;
                }else if (self.getGoodsInfoList.goodsStatus.integerValue == 2){
                    _goodsStatus = 2;
                }else if (self.getGoodsInfoList.goodsStatus.integerValue == 3){
                    _goodsStatus = 3;
                }
                
                
            }
            
            [self.tableView reloadData];
            
        }else{
            
            [self alertViewWithTitle:@"商品详情加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _isRequestGoodsDetailsSuccess = YES;
        
        if (_isRequestHistoryDataSuccess && _isRequestGoodsDetailsSuccess) {
            
            _isRequestGoodsDetailsSuccess = NO;
            
            _isRequestHistoryDataSuccess = NO;
            
            [self tipRequestFailureWithErrorCode:error.code];
        }
        
    }];
    
}


#pragma mark-请求数据
- (void)requestData{
    
    [self progressHUDShowWithString:@"加载中"];
    
    // !请求商家数据
    [self getMerchantInfo];
    
    //请求商品详情
    [self requestGoodsDetailsData];
    
    //请求历史数据
    [self requestHistoryData];
    
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    UITextField *batchNumLimitTextField = (UITextField *)[cell viewWithTag:101];
    
    if (batchNumLimitTextField == textField) {
        
        //起批量
        self.getGoodsInfoList.batchNumLimit = [NSNumber numberWithFloat:textField.text.floatValue];
        
    }else{
        
        //样板价
        self.getGoodsInfoList.samplePrice = [NSNumber numberWithFloat:textField.text.floatValue];

    }
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        
        CPSGoodsDetailsEditViewControllerCellID0 *firstcell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID0"];
        
        
        //图片
        UIImageView *imageView = (UIImageView *)[firstcell viewWithTag:101];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.getGoodsInfoList.defaultPicUrl] placeholderImage:[UIImage imageNamed:DEFAULTIMAGE]];
        
        //标题
        UITextView *textView = (UITextView*)[firstcell viewWithTag:102];
        
        textView.delegate = self;
        textView.text = self.getGoodsInfoList.goodsName;
        
        //!改变商品名称高度
        [firstcell getGoodName:self.getGoodsInfoList.goodsName];

        
        NSString *newName = [NSString stringWithFormat:@"%@",self.getGoodsInfoList.goodsName];
        textView.text = newName;
        [firstcell getGoodName:newName];

        
        //编辑
        UIButton *editButton = (UIButton *)[firstcell viewWithTag:103];
        
        [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //已上架，未定
        UILabel *groundingLabel = (UILabel *)[firstcell viewWithTag:104];
        
        UILabel *undercarriageLabel = (UILabel *)[firstcell viewWithTag:105];
        
        //判断  1:新发布  2:在售  3:下架
        if (self.getGoodsInfoList.goodsStatus.integerValue == 1) {
            //新发布
            groundingLabel.text = @"上架";
            
            undercarriageLabel.text = @"未上架";
            
        }else if (self.getGoodsInfoList.goodsStatus.integerValue ==2){
            //在售
            groundingLabel.text = @"已上架";
            
            undercarriageLabel.text = @"下架";
            
        }else if (self.getGoodsInfoList.goodsStatus.integerValue == 3){
            //下架
            groundingLabel.text = @"上架";
            
            undercarriageLabel.text = @"未上架";
        }
        
        
        if (_goodsStatus == 1) {
            
            //新发布
            groundingLabel.backgroundColor = HEX_COLOR(0xe2e2e2FF);
            
            undercarriageLabel.backgroundColor = HEX_COLOR(0xeb301fFF);
            
            
        }else if (_goodsStatus == 2) {
            //上架
            
            groundingLabel.backgroundColor = HEX_COLOR(0xeb301fFF);
            
            undercarriageLabel.backgroundColor = HEX_COLOR(0xe2e2e2FF);
            
        }else if (_goodsStatus == 3){
            //下架
            
            groundingLabel.backgroundColor = HEX_COLOR(0xe2e2e2FF);
            
            undercarriageLabel.backgroundColor = HEX_COLOR(0xeb301fFF);
        }else{
        
            groundingLabel.backgroundColor = HEX_COLOR(0xe2e2e2FF);
            
            undercarriageLabel.backgroundColor = HEX_COLOR(0xe2e2e2FF);
        
        }

        
        UIButton *groundingButton = (UIButton *)[firstcell viewWithTag:106];
        
        [groundingButton addTarget:self action:@selector(groundingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *undercarriageButton = (UIButton *)[firstcell viewWithTag:107];
        
        [undercarriageButton addTarget:self action:@selector(undercarriageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return  firstcell;
        
        
    }else if (indexPath.row == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID1"];
        
        //尺码
        for (int i = 0; i<self.getGoodsInfoList.skuDTOList.count; i++) {
            
            SkuDTO *skuDTO = [self.getGoodsInfoList.skuDTOList objectAtIndex:i];
            
            CSPSkuView *skuView = [[[NSBundle mainBundle]loadNibNamed:@"CSPSkuView" owner:self options:nil]firstObject];
            
            skuView.selectedBlock = ^(BOOL isSelected){
                
                if (isSelected) {
                    skuDTO.showStockFlag = @"1";

                }else{
                    skuDTO.showStockFlag = @"0";

                }
            };
            
            DebugLog(@"skuDTO.skuName = %@", skuDTO.skuName);
            
            //判断尺码是哪种类型
            if ([skuDTO.skuName containsString:@"/"] || [skuDTO.skuName containsString:@"（"]) {
                
                if (self.view.frame.size.width<= 375) {
                    //3行
                    
                    //间距
                    NSInteger interval = 10;
                    
                    if ([skuDTO.skuName containsString:@"（"] && self.view.frame.size.width==320) {
                        
                        skuView.sizeLabel.font = [UIFont systemFontOfSize:10];
                    }
                    
                    CGFloat width = (self.view.frame.size.width*1.0 -30- 2*interval)/3;
                    
                    //计算坐标
                    skuView.frame = CGRectMake(15+(interval+width)*(i%3),37+35*(i/3),width, 25);
                    
                }else{
                
                    //间距
                    NSInteger interval = 10;
                    
                    CGFloat width = (self.view.frame.size.width*1.0 -30- 3*interval)/4;
                    
                    //计算坐标
                    skuView.frame = CGRectMake(15+(10+width)*(i%4),37+35*(i/4),width, 25);
                }
                
            }else{
                
                if (self.view.frame.size.width<= 375) {
                
                    //间距
                    NSInteger interval = 10;
                    
                    CGFloat width = (self.view.frame.size.width*1.0 -30- 2*interval)/3;
                    
                    //计算坐标
                    skuView.frame = CGRectMake(15+(interval+width)*(i%3),37+35*(i/3),width, 25);
                    
                    
                }else {
                    
                    //间距
                    NSInteger interval = 10;
                    
                    CGFloat width = (self.view.frame.size.width*1.0 -30- 3*interval)/4;
                    
                    //计算坐标
                    skuView.frame = CGRectMake(15+(10+width)*(i%4),37+35*(i/4),width, 25);
                }
                
            }
            
            skuView.sizeLabel.text = skuDTO.skuName;
            
            if (skuDTO.showStockFlag.integerValue == 1) {
                
                skuView.isSelected = YES;
                
                skuView.goodsStateLabel.text = @"有货";
                
                skuView.backgroundColor = HEX_COLOR(0x000000FF);
                
            }else{
                
                skuView.isSelected = NO;
                
                skuView.goodsStateLabel.text = @"无货";
                
                skuView.backgroundColor = HEX_COLOR(0xe2e2e2FF);
            }
            
            [cell addSubview:skuView];
        }
        
    }else if (indexPath.row == 2){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID2"];
        
        //阶梯价格
        for (int i = 0; i<self.getGoodsInfoList.stepDTOList.count; i++) {
            
            StepDTO *stepDTO = [self.getGoodsInfoList.stepDTOList objectAtIndex:i];
            
            __weak CSPStepView *stepView = [[[NSBundle mainBundle]loadNibNamed:@"CSPStepView" owner:self options:nil]firstObject];
            stepView.tag =200+i;
            //修改数量和价格
            stepView.changeStepPriceBlock = ^(changeType type){
                
                //!最后一行
                if (i == self.getGoodsInfoList.stepDTOList.count-1) {
                    
                    stepDTO.minNum = [NSNumber numberWithFloat:[[stepView.stepMaxPriceTextField.text substringFromIndex:1] floatValue]];
                    
                    stepDTO.maxNum = nil;
                    
                    
                }else{
                    
                    stepDTO.minNum = [NSNumber numberWithFloat:[stepView.stepMinPriceTextField.text floatValue]];
                    stepDTO.maxNum = [NSNumber numberWithFloat:[stepView.stepMaxPriceTextField.text floatValue]];
                }
                
                stepDTO.price = [NSNumber numberWithFloat:[stepView.priceTextField.text floatValue]];
                
                //如果修改的最大数量
                if(type == changeMax) {
                    
                    
                    //!当前行不是倒数第二行 修改下一行的数字及内容
                    if(i != self.getGoodsInfoList.stepDTOList.count - 2) {
                        
                        StepDTO *nextStepDTO = [self.getGoodsInfoList.stepDTOList objectAtIndex:i + 1];
                        nextStepDTO.minNum = [NSNumber numberWithFloat:[stepDTO.maxNum floatValue] + 1];
                
                        //!lyt
                        CSPStepView *nextStepView = (CSPStepView*)[cell viewWithTag:200+i+1];

                        nextStepView.stepMinPriceTextField.text = [NSString stringWithFormat:@"%ld", (long)[[self transformationData:nextStepDTO.minNum] integerValue]];

                        
                        
                    }else{//! lyt 当前行是倒数第二行 修改最后一行的数字 及内容
                    
                    
                        StepDTO *nextStepDTO = [self.getGoodsInfoList.stepDTOList objectAtIndex:i + 1];
                        nextStepDTO.minNum = [NSNumber numberWithFloat:[stepDTO.maxNum floatValue] + 1];
                        
                        CSPStepView *nextStepView = (CSPStepView*)[cell viewWithTag:200+i+1];
                        
                        nextStepView.stepMaxPriceTextField.text = [NSString stringWithFormat:@"≥%ld",(long)([[self transformationData:nextStepDTO.minNum] integerValue])];
                    
                    }
                    
                    
                    
                }
                
                //!如果修改最小数量
                if (type == changeMin) {
                    batchNumLimitLabel.text = [NSString stringWithFormat:@"起批量：%.0f",[stepView.stepMinPriceTextField.text floatValue]];
                }
                

                
                
                
            };
            
            //添加阶梯价格
            stepView.addStepPriceBlock = ^(){
                
                //获取上一个dto，判断是否有最大值，没有则不能添加下一个
                StepDTO  *preStepDto = [self.getGoodsInfoList.stepDTOList objectAtIndex:i - 1];
                
                if (preStepDto.maxNum != nil && preStepDto.price != nil && [preStepDto.price floatValue] != 0) {
                 
                    //先移除这个cell上的CSPStepView
                    for (UIView *view in cell.subviews) {
                        
                        if ([view isKindOfClass:[CSPStepView class]]) {
                            
                            [view removeFromSuperview];
                        }
                    }
                    
                    StepDTO *stepDto = [[StepDTO alloc]init];
                    
                    //添加到倒数第二个
                    StepDTO *lastObject = self.getGoodsInfoList.stepDTOList.lastObject;
                    
                    //处理sort
                    NSInteger lastSort = lastObject.sort.integerValue;
                    
                    stepDto.sort = [NSNumber numberWithInteger:lastSort];
                    
                    stepDto.minNum = [NSNumber numberWithInteger:[preStepDto.maxNum integerValue] + 1];
                    
                    lastObject.sort = [NSNumber numberWithInteger:lastSort+1];
                    
                    [self.getGoodsInfoList.stepDTOList removeObject:lastObject];
                    
                    [self.getGoodsInfoList.stepDTOList addObject:stepDto];
                    
                    [self.getGoodsInfoList.stepDTOList addObject:lastObject];
                    
                    //刷新
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                    
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }else {

                    [self progressHUDTipWithString:@"请先完成上一阶段的价格编辑"];
                    
                }
                
            };
            
            //删除阶梯价格
            stepView.deleteStepPriceBlock = ^(){
                
                //先移除这个cell上的CSPStepView
                for (UIView *view in cell.subviews) {
                    
                    if ([view isKindOfClass:[CSPStepView class]]) {
                        
                        [view removeFromSuperview];
                    }
                }

                
                //删除倒数第二个
                StepDTO  *stepDto = [self.getGoodsInfoList.stepDTOList objectAtIndex:(self.getGoodsInfoList.stepDTOList.count-2)];
                
                StepDTO *lastStepDto = self.getGoodsInfoList.stepDTOList.lastObject;
                
                lastStepDto.sort = stepDto.sort;
                
                [self.getGoodsInfoList.stepDTOList removeObject:stepDto];
                
                //刷新
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            };
            
            //计算坐标
            stepView.frame = CGRectMake(0,45+45*i,tableView.frame.size.width,45);
            
//            if (i != 0) {
//                
//                stepView.stepMinPriceTextField.borderStyle = UITextBorderStyleNone;
//                
//            }else{
//                
//                stepView.stepMinPriceTextField.borderStyle = UITextBorderStyleRoundedRect;
//            }
            
            //如果是最后一行，只有最小数量，没有最大数量
            if (i == self.getGoodsInfoList.stepDTOList.count-1) {
                
                stepView.dividingLineView.hidden = YES;
                
                stepView.stepMinPriceTextField.hidden = YES;
                
                StepDTO *preStepDTO;
                for (int j = (int)self.getGoodsInfoList.stepDTOList.count - 2; j >= 0; j--) {
                
                    StepDTO *stepDTO = [self.getGoodsInfoList.stepDTOList objectAtIndex:j];
                    if (stepDTO.maxNum != nil) {
                        preStepDTO = stepDTO;
                        break;
                    }
                }
                
                stepView.stepMaxPriceTextField.text = [NSString stringWithFormat:@"≥%ld",(long)([[self transformationData:preStepDTO.maxNum] integerValue] + 1)];
                
                stepDTO.minNum = [NSNumber numberWithFloat:[preStepDTO.maxNum floatValue] + 1];
                
                stepView.stepMaxPriceTextField.borderStyle = UITextBorderStyleNone;
                [stepView.stepMaxPriceTextField setEnabled:NO];
                
            }else{
                
                stepView.dividingLineView.hidden = NO;
                
                stepView.stepMinPriceTextField.hidden = NO;
                
                stepView.stepMinPriceTextField.text = [NSString stringWithFormat:@"%ld", (long)[[self transformationData:stepDTO.minNum] integerValue]];

                stepView.stepMaxPriceTextField.text = [self transformationData:stepDTO.maxNum];
                
                stepView.stepMaxPriceTextField.borderStyle = UITextBorderStyleRoundedRect;
                
                if (i != 0) {
                    stepView.stepMinPriceTextField.borderStyle = UITextBorderStyleNone;
                    [stepView.stepMinPriceTextField setEnabled:NO];
                }

            }
            
            
            stepView.priceTextField.text = [self transformationData:stepDTO.price];
            
            //添加和删除阶梯价格按钮
            stepView.deleteButton.hidden = YES;
            
            stepView.addButton.hidden = YES;
            
            if (i == self.getGoodsInfoList.stepDTOList.count-1) {
                stepView.addButton.hidden = NO;
            }
            
            if (i == self.getGoodsInfoList.stepDTOList.count-2) {
                stepView.deleteButton.hidden = NO;
            }
            
            if (i == 0) {
                
                stepView.deleteButton.hidden = YES;
                
                stepView.addButton.hidden = YES;
            }
            
            [cell addSubview:stepView];
            
            
            
        }

    }else if (indexPath.row == 3){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID3"];
        //起批量
        batchNumLimitLabel = (UILabel *)[cell viewWithTag:101];
        
        batchNumLimitLabel.text = [NSString stringWithFormat:@"起批量：%@",[self transformationData:self.getGoodsInfoList.batchNumLimit]];
        
    }else if (indexPath.row == 4){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID4"];
        
        UIButton *samplePriceButton = (UIButton *)[cell viewWithTag:101];
        
        if ([self.getGoodsInfoList.sampleFlag isEqualToString:@"1"]) {
            
             [samplePriceButton setImage:[UIImage imageNamed:@"04_商家中心_消息中心_发送成功_"] forState:UIControlStateNormal];
            
        }else{
            
            [samplePriceButton setImage:[UIImage imageNamed:@"03_商家商品详情页_未选中"] forState:UIControlStateNormal];
            
        }
        
        //样板价
        UITextField *textField = (UITextField *)[cell viewWithTag:102];
        
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        textField.text = [self transformationData:self.getGoodsInfoList.samplePrice];
        
        [samplePriceButton addTarget:self action:@selector(samplePriceButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }else if (indexPath.row == 5){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPSGoodsDetailsEditViewControllerCellID5"];
        
        cell.contentView.backgroundColor = HEX_COLOR(0xf0f0f0FF);
        
        UILabel *tipLabel = (UILabel *)[cell viewWithTag:101];
        
        tipLabel.textColor = HEX_COLOR(0x999999FF);
        
        UIButton *button = (UIButton *)[cell viewWithTag:102];
        
        button.backgroundColor = HEX_COLOR(0xeb301fFF);
        
        [button addTarget:self action:@selector(contactServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        float width = 0;
        if (SCREEN_WIDTH>375) {
            
            width = 240;
            
        }else if(SCREEN_WIDTH >320 && SCREEN_WIDTH<=375){
            
            width = 170;
            
        }else{
            
            width =200;
            
        }
        
        //!计算商品名称的高度
        CGSize  goodNameSize = [self.getGoodsInfoList.goodsName boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size;
        //!goodName的高度在xib里面是35
        if (goodNameSize.height<35) {
            
            return 158.0f;

        }else{
        
            return 158 - 35 +goodNameSize.height;
        }

        
    }else if (indexPath.row == 1){
        
        //尺码
        NSInteger integer;
        
        NSInteger count = self.getGoodsInfoList.skuDTOList.count;
        
        SkuDTO *skuDTO = [self.getGoodsInfoList.skuDTOList objectAtIndex:0];

        
        
        //判断尺码是哪种类型
        if ([skuDTO.skuName containsString:@"/"] || [skuDTO.skuName containsString:@"（"]) {
            
            if (self.view.frame.size.width<= 375) {
                //3行
                
                if (count%3 == 0) {
                    
                    integer = count/3;
                }else{
                    integer = count/3+1;
                }
                
            }else{
                
                if (count%4 == 0) {
                    
                    integer = count/4;
                }else{
                    integer = count/4+1;
                }
            }
            
        }else{
            
            if (self.view.frame.size.width<= 375) {
                //3行
                
                if (count%3 == 0) {
                    
                    integer = count/3;
                }else{
                    integer = count/3+1;
                }
                
            }else{
            
                if (count%4 == 0) {
                
                    integer = count/4;
                }else{
                    integer = count/4+1;
                }
            }
        }
        
        return integer*35+37;
        
    }else if (indexPath.row == 2){
        
        //阶梯价格
        NSInteger count = self.getGoodsInfoList.stepDTOList.count;
        
        DebugLog(@"count = %ld", (long)count);

        return count*45+50;
        
    }else if (indexPath.row == 3){
        return 40.0f;
    }else if (indexPath.row == 4){
        return 44.0f;
    }else if (indexPath.row == 5){
        return 50.0f;
    }
    return 0;
}

#pragma mark-勾选、取消样板价
- (void)samplePriceButtonClick:(UIButton *)sender{
    
    if ([self.getGoodsInfoList.sampleFlag isEqualToString:@"1"]) {
        
        self.getGoodsInfoList.sampleFlag = @"2";
        
    }else{
        
        self.getGoodsInfoList.sampleFlag = @"1";
    }
    
    //刷新cell
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark-UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return _isEdit;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.getGoodsInfoList.goodsName = textView.text;
    
    self.getGoodsInfoList.goodsName = [self.getGoodsInfoList.goodsName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    textView.text = self.getGoodsInfoList.goodsName;
}

#pragma mark-编辑
- (void)editButtonClick:(UIButton *)sender{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UITextView *textView = (UITextView *)[cell viewWithTag:102];
    
    _isEdit = !_isEdit;
    
    if (_isEdit) {
        
        [textView becomeFirstResponder];
        
        textView.backgroundColor = HEX_COLOR(0xe2e2e2FF);
        
    }else{
        
        [textView resignFirstResponder];
        
        textView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark-拨打客服电话
- (void)contactServiceClick:(UIButton *)sender{
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打客服电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    alert.tag = 1001;
//    
//    [alert show];
    
    if (customAlertView) {
        
        [customAlertView removeFromSuperview];
        
    }
    
    customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否拨打客服电话" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self takeServicePhone:SERVICEPHONENUMBER];

    } dismissAction:nil];
    
    [customAlertView show];

}

#pragma mark-上架
- (void)groundingButtonClick:(UIButton *)sender{
    
    
    //!判断商家如果是歇业 或者 是关闭，点击上架提示用户
    // !商家歇业
    if ([GetMerchantInfoDTO sharedInstance].operateStatus == NO) {
        
        [self.view makeMessage:@"歇业中，不可上架商品。" duration:2 position:@"center"];
        
        return ;
        
    }else if ([[GetMerchantInfoDTO sharedInstance].merchantStatus isEqualToString:@"1"]){// !关闭
        
        [self.view makeMessage:@"商家已经关闭，不可上架商品。" duration:2 position:@"center"];

        
        return ;
    
    }
        

    
    _goodsStatus = 2;
    
    //刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark-下架
- (void)undercarriageButtonClick:(UIButton *)sender{
    
//    sender.backgroundColor = HEX_COLOR(0xeb301fFF);
//    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    UIButton *button = (UIButton *)[cell viewWithTag:104];
//    
//    button.backgroundColor = HEX_COLOR(0xe2e2e2FF);
    
    
    
    if (self.getGoodsInfoList.goodsStatus.integerValue == 1) {
        
        _goodsStatus = 1;
        
    }else{
        
        _goodsStatus = 3;
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark-预览
- (IBAction)previewButtonClick:(id)sender{
    
    _isPreview = YES;
    
    CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
    
    goodsDetailsPreviewViewController.getGoodsInfoList = self.getGoodsInfoList;
    
    goodsDetailsPreviewViewController.isPreview = YES;
    
    goodsDetailsPreviewViewController.defaultPicUrl = self.getGoodsInfoList.defaultPicUrl;
    
    [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
}

#pragma mark-保存
- (IBAction)saveButtonClick:(id)sender{
    
    BOOL isConform = NO;
    
    if(_goodsStatus == 1 || _goodsStatus == 2) {
        
        
        for (SkuDTO * sku in self.getGoodsInfoList.skuDTOList) {
            
            if ([sku.showStockFlag isEqualToString:@"1"]) {
                
                isConform = YES;
                break;
            }
        }
    }else {
        
        isConform = YES;
    }
    
    if (isConform) {
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 1000;
//        [alert show];
        
        if (customAlertView) {
            
            [customAlertView removeFromSuperview];
            
        }
        
        customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否保存修改" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self saveChange];
            
        } dismissAction:nil];
        
        [customAlertView show];
        
        
        
    }else {
        
        [self alertViewWithTitle:@"提示" message:@"上架商品必须有尺码有货"];
        return;
    }
    
    
}
#pragma mark 保存修改
-(void)saveChange{

    [self progressHUDShowWithString:@"保存中"];
    
    GetGoodsInfoListDTO *previewgetGoodsInfoList = [[GetGoodsInfoListDTO alloc]init];
    
    previewgetGoodsInfoList.samplePrice = self.getGoodsInfoList.samplePrice;
    
    previewgetGoodsInfoList.goodsNo = self.getGoodsInfoList.goodsNo;
    
    previewgetGoodsInfoList.merchantNo = self.getGoodsInfoList.merchantNo;
    
    previewgetGoodsInfoList.samplePrice = self.getGoodsInfoList.samplePrice;
    
    previewgetGoodsInfoList.sampleFlag = self.getGoodsInfoList.sampleFlag;
    
    previewgetGoodsInfoList.goodsName = self.getGoodsInfoList.goodsName;
    
    //商品状态需要特殊处理
    previewgetGoodsInfoList.goodsStatus = [NSNumber numberWithInteger:_goodsStatus];
    
    //尺码
    NSMutableArray *skuDTOListArray = [[NSMutableArray alloc]init];
    
    for (SkuDTO *skuDTO in self.getGoodsInfoList.skuDTOList) {
        
        NSMutableDictionary *skuDic = [[NSMutableDictionary alloc]init];
        
        if (skuDTO.skuNo) {
            [skuDic setObject:skuDTO.skuNo forKey:@"skuNo"];
            
        }
        
        if (skuDTO.showStockFlag) {
            [skuDic setObject:skuDTO.showStockFlag forKey:@"showStockFlag"];
            
        }
        
        [skuDTOListArray addObject:skuDic];
    }
    
    float highPrice = 0.0f;
    
    //阶梯价格
    NSMutableArray *stepDTOListArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.getGoodsInfoList.stepDTOList.count; i++) {
        
        StepDTO *stepDTO = [self.getGoodsInfoList.stepDTOList objectAtIndex:i];
        
        NSMutableDictionary *stepDic = [[NSMutableDictionary alloc]init];
        
        [stepDic setObject:[self transformationData:stepDTO.Id] forKey:@"id"];
        
        [stepDic setObject:[self transformationData:stepDTO.price] forKey:@"price"];
        
        [stepDic setObject:[self transformationData:stepDTO.minNum] forKey:@"minNum"];
        
        [stepDic setObject:[self transformationData:stepDTO.maxNum] forKey:@"maxNum"];
        
        [stepDic setObject:[self transformationData:stepDTO.sort] forKey:@"sort"];
        
        [stepDTOListArray addObject:stepDic];
        
        
    }
    
    
    
    previewgetGoodsInfoList.price = self.getGoodsInfoList.price;
    
    //处理previewgetGoodsInfoList中的stepDTOList、skuDTOList
    [previewgetGoodsInfoList.stepDTOList removeAllObjects];
    
    [previewgetGoodsInfoList.skuDTOList removeAllObjects];
    
    [previewgetGoodsInfoList.stepDTOList addObjectsFromArray:stepDTOListArray];
    
    [previewgetGoodsInfoList.skuDTOList addObjectsFromArray:skuDTOListArray];
    
    
    [HttpManager sendHttpRequestForGetUpdateGoodsInfo:previewgetGoodsInfoList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            //保存成功
            [self progressHUDHiddenTipSuccessWithString:@"保存成功"];
            
        }else{
            
            [self.progressHUD hide:YES];
            
            [self alertViewWithTitle:@"加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000) {
        
        if (buttonIndex == 1) {
        
            [self saveChange];
            
        }
        
    }else if(alertView.tag == 1001){
        
        if (buttonIndex == 1) {
            
            
            [self takeServicePhone:SERVICEPHONENUMBER];
            
        }
    }
}

#pragma mark-收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    DebugLog(@"收键盘");
    [self.view endEditing:YES];
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    if (_isShowKeyboard) {
        
        UITableViewCell *stepCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        DebugLog(@"stepCell.subviews.count = %lu", (unsigned long)stepCell.subviews.count);
        
        for (UIView *view in stepCell.subviews) {
            
            for (UIView *subview in view.subviews) {
                
                if ([subview isKindOfClass:[UITextField class]]) {
                    
                    [subview resignFirstResponder];
                }
            }
        }
        
        UITableViewCell *samplePriceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        
        UITextField *samplePriceTextField = (UITextField *)[samplePriceCell viewWithTag:102];
        
        [samplePriceTextField resignFirstResponder];
        
        [self reloadTableViewForRow:2 section:0];
        
        //恢复开始位置
        CGPoint point = self.tableView.contentOffset;
        
        point.y = _scrollOffset;
        
        [self.tableView setContentOffset:point animated:YES];
        
        
    }
    
    
    
}

#pragma mark-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        CGFloat y = scrollView.contentOffset.y;
        
        _lastScrollOffset = y;
    }
}

#pragma mark-刷新tableview某一个row
- (void)reloadTableViewForRow:(NSInteger)row section:(NSInteger)section{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
