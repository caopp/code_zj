//
//  EditGoodsViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

//!剩下的工作：1、记录点击的销售渠道的类型； 2、记录零售价价格 3、零售价格的输入限制  4、是否包邮的记录  5、数据的上传


#import "EditGoodsViewController.h"
#import "NameCell.h"
#import "SizeViewCell.h"
#import "PriceViewCell.h"
#import "BeginViewCell.h"//!起批价
#import "SamplePriceViewCell.h"//!样板价
#import "SalePlaceTableViewCell.h"//!销售渠道
#import "RetailPriceTableViewCell.h"//!零售价格
#import "WeightViewCell.h"//!重量
#import "CarriageFreeTableViewCell.h"//!设置为包邮
#import "OtherViewCell.h"
#import "UpAndDownViewCell.h"//!上架/下架
#import "ConnectServiceViewCell.h"//!联系客服
#import "EditGoodsInfoDTO.h"//!请求到的商品详情
#import "CPSUploadReferImageSucessfulViewController.h"
#import "CPSUploadReferImageViewController.h"
#import "GetImageReferImageHistoryListDTO.h"
#import "GoodsLagViewController.h"//!商品标签
#import "PromptGoodsTagsViewController.h"
#import "GoodsAlllTagDTO.h"
#import "ShowGoodsTagViewController.h"
#import "CPSGoodsDetailsPreviewViewController.h"//!预览
#import "GoodsBrandViewController.h"
#import "GoodsStandardsViewController.h"
#import "LoginDTO.h"
#import "GUAAlertView.h"
#import "GoodsTemplateViewController.h"
@interface EditGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UITableView *_tableView;

    NameCell * nameCell;
    
    SizeViewCell *sizeCell;
    CGFloat sizeCellHigth;
    
    PriceViewCell * priceCell;
    BeginViewCell *beginCell;
    SamplePriceViewCell * sampleCell;
    WeightViewCell * weightCell;
    RetailPriceTableViewCell *  retailPriceCell;//!零售价
    
    
    //!预览
    UIButton * previewBtn;
    //!保存
    UIButton *saveBtn;
    
    GUAAlertView * alertView;
    
}
@property(nonatomic,strong)GetGoodsInfoListDTO *getGoodsInfoList;


@property(nonatomic,strong)NSMutableArray * historyUpArray;//!上传过的参考图


@property(nonatomic,strong)NSMutableArray * goodDataArray;//!取出来的是多个颜色，数组中的第一个是我要的dto

@end


@implementation EditGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //!创建导航
    [self createNav];

    //!创建界面
    [self createUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardDidHideNotification object:nil];
    
    //!请求需要编辑的商品详情数据
    [self requestDtatilData];

    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    
    //!请求上传过的参考图数据
    [self requestUpData];

}
#pragma mark 创建导航
-(void)createNav{

    
    self.title = @"商品编辑";
    
    //!导航左按钮
    [self customBackBarButton];

    //!导航右按钮
    UIBarButtonItem *rightBarButton = [self barButtonWithtTitle:@"上传参考图" font:[UIFont systemFontOfSize:13]];
    
    if (rightBarButton) {
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];


}

- (void)rightButtonClick:(UIButton *)sender{
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //需要判断是否有上传历史
    if (self.historyUpArray.count) {
        
        //有上传历史
        CPSUploadReferImageSucessfulViewController *uploadReferImageSucessfulViewController = [storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageSucessfulViewController"];
        
        uploadReferImageSucessfulViewController.goodsNo = self.goodsNo;
        
        [self.navigationController pushViewController:uploadReferImageSucessfulViewController animated:YES];
        
        
    }else{
        
        
        //无上传历史
        CPSUploadReferImageViewController *uploadReferImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"CPSUploadReferImageViewController"];
        
        uploadReferImageViewController.goodsNo = self.goodsNo;
        
        [self.navigationController pushViewController:uploadReferImageViewController animated:YES];
        
        
        
    }

    
    
}

#pragma mark 创建界面
-(void)createUI{

    CGFloat previewHight = 59;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 - previewHight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];

    
    //!预览、保存
    previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previewBtn.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.view.frame.size.width/2, previewHight);
    [previewBtn setBackgroundColor:[UIColor whiteColor]];
    previewBtn.layer.borderColor = [UIColor blackColor].CGColor;
    previewBtn.layer.borderWidth = 1;
    [previewBtn addTarget:self action:@selector(previewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [previewBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:previewBtn];
    
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(CGRectGetMaxX(previewBtn.frame), previewBtn.frame.origin.y, previewBtn.frame.size.width, previewBtn.frame.size.height);
    [saveBtn setBackgroundColor:[UIColor blackColor]];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [self.view addSubview:saveBtn];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 15;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OtherViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"OtherViewCell" owner:self options:nil]lastObject];
    
    __weak EditGoodsViewController * vc = self;
    if (indexPath.row == 0) {//!修改名称
       
       nameCell  = [[[NSBundle mainBundle]loadNibNamed:@"NameCell" owner:self options:nil]lastObject];
        
        nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [nameCell configData:self.getGoodsInfoList];
        
        nameCell.nameCellShowAlerrMessageBlock = ^(NSString * showMessage){
        
            [vc showAlertMessage:showMessage];
            
        };
        
        return nameCell;
        
        
    }else if (indexPath.row == 1){//!尺码
    
        sizeCell =  [[SizeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    
        sizeCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [sizeCell configData:self.getGoodsInfoList];

        return sizeCell;
        
    }else if (indexPath.row == 2){//!选择渠道为"批发"
    
        SalePlaceTableViewCell *  salePlaceCell = [[[NSBundle mainBundle]loadNibNamed:@"SalePlaceTableViewCell" owner:self options:nil]lastObject];
        
        salePlaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [salePlaceCell configData:self.getGoodsInfoList withIsRetail:NO];

        
        return salePlaceCell;
        
    }else if (indexPath.row == 3){//!会员价格
    
        priceCell = [[[NSBundle mainBundle]loadNibNamed:@"PriceViewCell" owner:self options:nil]lastObject];
        priceCell.sixPriceTextField.delegate = self;
        priceCell.fivePriceTextField.delegate = self;
        priceCell.fourPriceTextField.delegate = self;
        priceCell.threePriceTextField.delegate = self;
        priceCell.twoPriceTextField.delegate = self;
        priceCell.onePriceTextField.delegate  = self;
        
        priceCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [priceCell configData:self.getGoodsInfoList];
        
        return priceCell;

        
    }else if (indexPath.row == 4){//!起批量
    
        beginCell = [[[NSBundle mainBundle]loadNibNamed:@"BeginViewCell" owner:self options:nil]lastObject];
        beginCell.beiginTextField.delegate = self;
        beginCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [beginCell configInfo:self.getGoodsInfoList];
        
        return beginCell;
        
    
    }else if (indexPath.row == 5){//!样板价格
    
        sampleCell = [[[NSBundle mainBundle]loadNibNamed:@"SamplePriceViewCell" owner:self options:nil]lastObject];
        sampleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        sampleCell.samplePriceTextField.delegate = self;
        
        [sampleCell configData:self.getGoodsInfoList];
        
        return sampleCell;
        
        
    
    }else if (indexPath.row == 6){//!选择渠道为“零售”
        
        SalePlaceTableViewCell *  salePlaceCell = [[[NSBundle mainBundle]loadNibNamed:@"SalePlaceTableViewCell" owner:self options:nil]lastObject];
        
        salePlaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [salePlaceCell configData:self.getGoodsInfoList withIsRetail:YES];
        
        return salePlaceCell;
        
    }else if (indexPath.row == 7){//!零售价
        
        retailPriceCell = [[[NSBundle mainBundle]loadNibNamed:@"RetailPriceTableViewCell" owner:self options:nil]lastObject];
        retailPriceCell.retailPriceTextField.delegate = self;

        retailPriceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [retailPriceCell configData:self.getGoodsInfoList];
        
        retailPriceCell.retailPriceTextField.delegate = self;
        
        return retailPriceCell;
        
    }else if (indexPath.row == 8){//!重量
    
        weightCell = [[[NSBundle mainBundle]loadNibNamed:@"WeightViewCell" owner:self options:nil]lastObject];
        weightCell.weightTextField.delegate = self;
        weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [weightCell configData:self.getGoodsInfoList];
        
        return weightCell;
        
    
    }else if (indexPath.row == 9){//!品牌
    
        NSString * brandStr = [NSString stringWithFormat:@"品牌：%@",self.getGoodsInfoList.brandName];
        
        cell.leftInfoLabel.text = brandStr;
    
    
    }else if (indexPath.row == 10){//!商品标签
    
        cell.leftInfoLabel.text = @"商品标签";
    
    }else if (indexPath.row == 11){//!商品规格参数
    
        cell.leftInfoLabel.text = @"商品规格参数";
        
    }else if (indexPath.row == 12){//!设置为包邮
    
        CarriageFreeTableViewCell * carriageFressCell = [[[NSBundle mainBundle]loadNibNamed:@"CarriageFreeTableViewCell" owner:self options:nil]lastObject];
        carriageFressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [carriageFressCell configInfo:self.getGoodsInfoList];
        
        return carriageFressCell;
        
    }else if (indexPath.row == 13){//!状态
    
        UpAndDownViewCell * upAndDownCell = [[[NSBundle mainBundle]loadNibNamed:@"UpAndDownViewCell" owner:self options:nil]lastObject];
        upAndDownCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [upAndDownCell configInfo:self.getGoodsInfoList];
        
        return upAndDownCell;
        
        
    }else if (indexPath.row == 14){//!联系客服
    
        ConnectServiceViewCell *serviceCell = [[[NSBundle mainBundle]loadNibNamed:@"ConnectServiceViewCell" owner:self options:nil]lastObject];
        
        return serviceCell;
        
    }
    
       return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    switch (indexPath.row) {
        case 0://!名称
            
        {
        
            CGFloat nameTextViewHight = nameCell.goodsNameTextView.frame.size.height;
            
            if (nameTextViewHight < 33) {
                
                return 95;

            }else{
                            
                CGFloat cellHight = CGRectGetMaxY(nameCell.goodsNameTextView.frame) + 42;
            
                return cellHight;
            }

        
        }
            
            
            break;
            
        case 1://!尺码
            
            if (sizeCell.cellHight) {
                
                return sizeCell.cellHight ;
            }else{
            
                return 100;

            }
            break;
            
        case 3://!价格
            
            return 349;
            
            break;
        case 2://!批发销售渠道
        
        case 6://!零售销售渠道
            
            return 52;
            
        case 7://!零售价格
            
            return 46;
        
        case 12://!设置为包邮
        
            return 52;
            
        default:
  
            return 55;
            
            break;
            
    }
    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //!点击就收回，相当于点击空白地方就收回键盘
    [self.view endEditing:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
        case 9://!品牌
        {
            //品牌
            GoodsBrandViewController *goodsBrandVC = [[GoodsBrandViewController alloc] init];
            goodsBrandVC.goodsNameBlock = ^(GoodsListDTO*list)
            {
                //!获取到品牌、刷新列表
                self.getGoodsInfoList.brandNo = list.brandNo;
                
                
                //7. 显示中英文
                NSString *showName;
                
                
                
                //7.1 判断中文是否存在，判断不存在显示英文
                if (list.cnName.length>0&&[list.enName isEqualToString:@""]) {
                    
                    showName = list.cnName;
                    //判断英文是否存在，不存在显示中文
                }else if (list.enName.length>0&&[list.cnName isEqualToString:@""])
                {
                    showName = list.enName;
                    //如果都存在 显示中英文
                }else if (list.cnName.length>0 && list.enName.length>0)
                {
                    showName = [NSString stringWithFormat:@"%@/%@",list.cnName,list.enName];
                }
                
                self.getGoodsInfoList.brandName = [NSString stringWithFormat:@"%@",showName];

                
                
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            
            goodsBrandVC.goodsNo = self.goodsNo;
            
            [self.navigationController pushViewController:goodsBrandVC animated:YES];
        
        }
            break;
        case 10:{//!商品标签
    
            
            //!请求单个标签的数据
            [HttpManager sendHttpRequestForgoodsGetLabelListByGoodsNo:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                GoodsAlllTagDTO *goodsAll = [[GoodsAlllTagDTO alloc] init];
                [goodsAll setDictFrom:dict[@"data"]];

                if ([dict checkLegitimacyForData:@"000"]) {
                    //设置需要传的数据
                    NSMutableArray *allOrder = [NSMutableArray array];
                    
                    //判断固定标签是否存在
                    if (goodsAll.fixedArr.count>0) {
                        for (FixedTagDTO *fixDto in goodsAll.fixedArr) {
                            [allOrder addObject:fixDto];

                        }
                    }
                    
                    //判断临时标签是否存储
                    if (goodsAll.otherArr.count>0) {
                        for (FixedTagDTO *otherDto  in goodsAll.otherArr) {
                            [allOrder addObject:otherDto];
                        }
                    }
                    
                    //判断是否有数据，没有数据跳转到商品标签
                    if (allOrder.count>0) {
                        ShowGoodsTagViewController *showGoodsVC = [[ShowGoodsTagViewController alloc] init];
                        showGoodsVC.tagsArr = allOrder;
                        showGoodsVC.goodsNo = self.goodsNo;
                        [self.navigationController pushViewController:showGoodsVC animated:YES];

                    }else
                    {
                        PromptGoodsTagsViewController *promptGoodsVC = [[PromptGoodsTagsViewController alloc] init];
                        
                        promptGoodsVC.goodsNo = self.goodsNo;
                        
                                    [self.navigationController pushViewController:promptGoodsVC animated:YES];

                    }
         
                    
                }
                

                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"error = %@", error);
                

            }];
            
        
        }
            break;
        case 11:{//!商品规格参数
        
            GoodsStandardsViewController *goodsStandardVC = [[GoodsStandardsViewController alloc] init];
            goodsStandardVC.getGoodsInfoList = self.getGoodsInfoList;
            [self.navigationController pushViewController:goodsStandardVC animated:YES];
            
        
        }
            break;
        
        default:
            break;
    }




}
-(void)showAlertMessage:(NSString *)message{


    [self.view makeMessage:message duration:2.0 position:@"center"];

}
#pragma mark textField的代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    UIView * superView = textField.superview;

    
    while (![superView isKindOfClass:[UITableViewCell class]]) {
        
        superView = [superView superview];
    
    }
    
    UITableViewCell *cell = (UITableViewCell*)superView;
    

    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    
    CGFloat keyBoardHight = 216 + 40;//!键盘高度 +40
    
    if (rect.origin.y / 2 + rect.size.height>=SCREEN_HIGHT-keyBoardHight) {
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardHight, 0);
        
    
//        [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];//!把对应的cell滑动到顶部

        
    }
    
    

    return YES;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //!价格、样板价格、零售价格 可以输入小数，则对输入的内容限制，只允许用户输入到小数点第二位
    if (textField == priceCell.sixPriceTextField || textField == priceCell.fivePriceTextField || textField == priceCell.fourPriceTextField || textField == priceCell.threePriceTextField || textField == priceCell.twoPriceTextField || textField == priceCell.onePriceTextField || textField == sampleCell.samplePriceTextField || textField == retailPriceCell.retailPriceTextField) {
        
        NSArray * textArray = [textField.text componentsSeparatedByString:@"."];
        
        if (textArray.count == 2) {//!如果数组中有两个值，则说明输入了小数点
            
          return  [self decimalDeal:textField.text withRange:range];
            
            
        }else{//!只输入了整数
        
            
          return [self intergerDealWithInsterStr:string withRang:range withMaxxNum:9];//!最多输入9位整数
            
            
        }
        
        
        
    }
    
    //!重量 可以输入小数，则对输入的内容限制，只允许用户输入到小数点第二位 0.01---999.99 非必填

    if (textField == weightCell.weightTextField) {
        
        NSArray * textArray = [textField.text componentsSeparatedByString:@"."];
        
        if (textArray.count == 2) {//!如果数组中有两个值，则说明输入了小数点
            
            return  [self decimalDeal:textField.text withRange:range];
            
            
        }else{//!只输入了整数
            
            
            return [self intergerDealWithInsterStr:string withRang:range withMaxxNum:3];//!最多输入3位整数
            
            
        }
        
        
    }
    
    //!起批量
    if (textField == beginCell.beiginTextField) {
        
        
        return [self intergerDealWithInsterStr:string withRang:range withMaxxNum:9];
        
    }
    
    
    //!价格:0.01---999999999.99 必填
    //!样板价格 同价格，根据是否点击 样板价格按钮来判断是否提示用填写样板价格
    
    //!起批量：1---999999999 必填
    
    //!重量:0.01---999.99 非必填
    return YES;
    
}

//!对小数部分进行处理
-(BOOL)decimalDeal:(NSString *)textFiledStr withRange:(NSRange)range{
    
    NSRange ran=[textFiledStr rangeOfString:@"."];
   

    int tt=range.location-ran.location;//!将要修改的位置-小数点在的位置
    
    if (tt <= 2 ){
        
        return YES;
        
    }
    
    return NO;


}
//!对整数部分进行处理
-(BOOL)intergerDealWithInsterStr:(NSString *)string  withRang:(NSRange)range withMaxxNum:(int)maxNum{

    
    //!输入的是小数点的时候
    if ([string isEqualToString:@"."]) {
        
        return YES;
        
    }else{//!输入的不是小数点的时候
        
        
        if (range.location < maxNum) {//!整数部分职能输入到第9位
            
            return YES;
            
        }
        
        return NO;
        
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    //!价格 的textfield
    [self endChangePriceTextField:textField];
    
    //!起批量的textfield
    if (textField == beginCell.beiginTextField) {
        
        int beginNum = [beginCell.beiginTextField.text intValue];
        
        self.getGoodsInfoList.batchNumLimit = [NSNumber numberWithInt:beginNum];
        
    }
    
    //!样板间的textfield
    if (textField == sampleCell.samplePriceTextField) {
        
        double price = [sampleCell.samplePriceTextField.text doubleValue];
        
        self.getGoodsInfoList.samplePrice = [NSNumber numberWithDouble:price];
        
    }
    
    //!重量的textfield
    if (textField == weightCell.weightTextField) {
        
        double weight = [weightCell.weightTextField.text doubleValue
                         ];
        
        self.getGoodsInfoList.goodsWeight = [NSNumber numberWithDouble:weight];
        
    }
    //!零售价格
    if (textField == retailPriceCell.retailPriceTextField) {
        
        double retailPrice = [textField.text doubleValue];

        self.getGoodsInfoList.retailPrice = [NSNumber numberWithDouble:retailPrice];

    }
    

    
}
//!会员价格 停止编辑
-(void)endChangePriceTextField:(UITextField *)priceTextField{

    
    double price = [priceTextField.text doubleValue];

    if (priceTextField == priceCell.sixPriceTextField) {
        
        self.getGoodsInfoList.price6 = [NSNumber numberWithDouble:price];
        
    }else if (priceTextField == priceCell.fivePriceTextField){
        
        self.getGoodsInfoList.price5 = [NSNumber numberWithDouble:price];

        
    }else if (priceTextField == priceCell.fourPriceTextField){
    
        self.getGoodsInfoList.price4 = [NSNumber numberWithDouble:price];

        
    }else if (priceTextField == priceCell.threePriceTextField){
    
        
        self.getGoodsInfoList.price3 = [NSNumber numberWithDouble:price];

        
    }else if (priceTextField == priceCell.twoPriceTextField){
    
        self.getGoodsInfoList.price2 = [NSNumber numberWithDouble:price];

    }else if (priceTextField == priceCell.onePriceTextField){
    
        self.getGoodsInfoList.price1 = [NSNumber numberWithDouble:price];

        
    }
    
   


}


#pragma mark 观察键盘弹出、消失的方法
-(void)keyboardWillAppear:(NSNotification *)notification{

    

}


- (void)keyboardDidDisappear:(NSNotification *)notification{
    
    //!键盘消失就刷新数据
    [_tableView reloadData];

}
#pragma mark 预览
-(void)previewBtnClick{

    CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
    
    goodsDetailsPreviewViewController.arrColorItems = self.goodDataArray;
    goodsDetailsPreviewViewController.noGoodsListView = YES;
    
    goodsDetailsPreviewViewController.isPreview = YES;
    
    goodsDetailsPreviewViewController.defaultPicUrl = self.getGoodsInfoList.defaultPicUrl;
    
    [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];

    
}

#pragma mark 保存
-(void)saveBtnClick{

    saveBtn.enabled = NO;
    
    //!校验
    NSString * alertStr = @" ";
    //1、标题
    if (!self.getGoodsInfoList.goodsName || [self.getGoodsInfoList.goodsName isEqualToString:@" "] || [self.getGoodsInfoList.goodsName isEqualToString:@""]) {
        
        alertStr = @"请填写商品标题";
        
    }else if (self.getGoodsInfoList.goodsName.length >30){
    
        alertStr = @"商品名称必须在30字以内";
    
    }else if (![self isSelectSize]){
    
        alertStr = @"请选择尺码";
    
    }else if (![self isInsertAllVIPPrice]){
    
        alertStr = @"请填写会员价";
    
    }else if ([self.getGoodsInfoList.sampleFlag isEqualToString:@"1"] && ![self.getGoodsInfoList.samplePrice floatValue]){//!选中了样板价格
    
        alertStr = @"请填写样板价";
    
    }else if (![self.getGoodsInfoList.channelComponArray containsObject:@"0"] && ![self.getGoodsInfoList.channelComponArray containsObject:@"1"]){//!判断是否选择销售渠道
    
        alertStr = @"未选择销售渠道";
        
    }else if (![self retailOperation]){//!如果销售渠道选择零售，判断是否填写零售价格
    
        alertStr = @"请填写零售价格";
    
    }
    
    
    if (![alertStr isEqualToString:@" "]) {
        
        [self.view makeMessage:alertStr duration:2.0 position:@"center"];
    
        saveBtn.enabled = YES;
        
        return ;
    }
    
    if (alertView) {
        
        [alertView removeFromSuperview];
    
    }
    
    alertView = [GUAAlertView alertViewWithTitle:@"是否保存修改" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self saveChangeRequest];
        
    } dismissAction:^{
        
        saveBtn.enabled = YES;

    }];
    
    
    
    [alertView show];
    

}


//!判断是否有选中尺码（如果所有尺码都是无货，那就提醒）
-(BOOL)isSelectSize{

    int selectCount = 0;
    
    for (int i = 0; i<self.getGoodsInfoList.skuDTOList.count; i++) {
        
        SkuDTO * skuDTO = self.getGoodsInfoList.skuDTOList[i];
        if ([skuDTO.showStockFlag isEqualToString:@"1"]) {
            
            selectCount = selectCount +1;
        }
        
    }

    if (selectCount) {
        
        return YES;//!选中了尺码
    
    }else{
    
        return NO;//!为选中尺码
    }

}
//!判断是否填写全部等级价格
-(BOOL)isInsertAllVIPPrice{

    if (![self.getGoodsInfoList.price1 floatValue]) {
        
        return NO;
        
    }else if (![self.getGoodsInfoList.price2 floatValue]){
    
        return NO;

    }else if (![self.getGoodsInfoList.price3 floatValue]){
        
        return NO;
        
    }else if (![self.getGoodsInfoList.price4 floatValue]){
        
        return NO;
        
    }else if (![self.getGoodsInfoList.price5 floatValue]){
        
        return NO;
        
    }else if (![self.getGoodsInfoList.price6 floatValue]){
        
        return NO;
        
    }
    
   

    return YES;


}
//!如果销售渠道选择了零售、判断是否填写了零售价格
-(BOOL)retailOperation{

    //!商品销售渠道 0 批发 1零售 逗号分割 例如 0,1
    if ([self.getGoodsInfoList.channelComponArray containsObject:@"1"]) {
        
        if (![self.getGoodsInfoList.retailPrice floatValue]) {
            
            return NO;//!没有填写，不可以通过
        }else{
        
            return YES;
        
        }
        
        
    }else{//!没有选择零售，可以通过

        return YES;
        
    
    }



}

-(void)saveChangeRequest{
    
    NSMutableDictionary * upDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([LoginDTO sharedInstance].tokenId != nil) {
        
        [upDic setObject:[LoginDTO sharedInstance].tokenId forKey:@"tokenId"];

    }
    
    [upDic setObject:self.getGoodsInfoList.goodsNo forKey:@"goodsNo"];
    
    [upDic setObject:[NSString stringWithFormat:@"%@",self.getGoodsInfoList.goodsStatus] forKey:@"goodsStatus"];
    
    [upDic setObject:self.getGoodsInfoList.goodsName forKey:@"goodsName"];
    
    
    [upDic setObject:self.getGoodsInfoList.sampleFlag forKey:@"sampleFlag"];
    if ([self.getGoodsInfoList.sampleFlag isEqualToString:@"1"]) {//!选中了样板，那就传价格
        
        [upDic setObject:self.getGoodsInfoList.samplePrice forKey:@"samplePrice"];
        
    }
    
    //!不填写的话默认为1，所以这个值肯定会有的
    [upDic setObject:self.getGoodsInfoList.batchNumLimit forKey:@"batchNumLimit"];
    
    //!运费模板 选填
//    if ([self.getGoodsInfoList.ftTemplateId intValue]) {
//        
//        [upDic setObject:self.getGoodsInfoList.ftTemplateId forKey:@"ftTemplateId"];
//        
//    }
    
    //!品牌编码 选填
    if (self.getGoodsInfoList.brandNo && self.getGoodsInfoList.brandNo.length) {
        
        [upDic setObject:self.getGoodsInfoList.brandNo forKey:@"brandNo"];
        [upDic setObject:self.getGoodsInfoList.brandName forKey:@"brandName"];
        
    }
    
    //!重量 选填
    if ([self.getGoodsInfoList.goodsWeight floatValue]) {
        
        [upDic setObject:self.getGoodsInfoList.goodsWeight forKey:@"goodsWeight"];
        
    }
    
    NSMutableArray * skuList = [NSMutableArray arrayWithCapacity:0];
    
    //!skuList
    for (SkuDTO * skuDTO in self.getGoodsInfoList.skuDTOList) {
        
        NSMutableDictionary * skuDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [skuDic setObject:skuDTO.skuNo forKey:@"skuNo"];
        
        [skuDic setObject:skuDTO.showStockFlag forKey:@"showStockFlag"];
        
        
        [skuList addObject:skuDic];
        
    }
    
    [upDic setObject:skuList forKey:@"skuList"];
    
    //!vip价格
    [upDic setObject:self.getGoodsInfoList.price1 forKey:@"price1"];
    [upDic setObject:self.getGoodsInfoList.price2 forKey:@"price2"];
    [upDic setObject:self.getGoodsInfoList.price3 forKey:@"price3"];
    [upDic setObject:self.getGoodsInfoList.price4 forKey:@"price4"];
    [upDic setObject:self.getGoodsInfoList.price5 forKey:@"price5"];
    [upDic setObject:self.getGoodsInfoList.price6 forKey:@"price6"];


    //!销售渠道
    NSMutableString * channelListStr = [NSMutableString stringWithString:@""];
    
    for (int i = 0 ; i< self.getGoodsInfoList.channelComponArray.count; i++) {
        
        NSString * channelStr = self.getGoodsInfoList.channelComponArray[i];
        
        if (![channelStr isEqualToString:@""]) {//!不是空字符串再加入
           
            [channelListStr appendString:channelStr];
            
            if (i != self.getGoodsInfoList.channelComponArray.count - 1 && self.getGoodsInfoList.channelComponArray.count !=1) {
                
                [channelListStr appendString:@","];
                
            }
            
        }
      
        
    }
    
    [upDic setObject:channelListStr forKey:@"channelList"];
    


    
    //!零售价格
    if ([self.getGoodsInfoList.retailPrice floatValue]) {
        
        [upDic setObject:self.getGoodsInfoList.retailPrice forKey:@"retailPrice"];
        
    }else{
    
        [upDic setObject:[NSNumber numberWithFloat:0] forKey:@"retailPrice"];

    }

    //!是否包邮 ：0不包邮,1包邮
//    if (!self.getGoodsInfoList.freeDelivery) {//!没有
//        
//        self.getGoodsInfoList.freeDelivery = [NSNumber numberWithInteger:0];
//        
//    }
    [upDic setObject:self.getGoodsInfoList.freeDelivery forKey:@"freeDelivery"];

    
    
    
    [HttpManager sendHttpRequestGoodsInfoUpdateWithUpDic:upDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            
            //            [self progressHUDHiddenWidthString:@"保存成功"];
            [self.view makeMessage:@"保存成功" duration:2.0 position:@"center"];
            
        }else{
            
            [self progressHUDHiddenWidthString:responseDic[@"errorMessage"]];
            
            [self.view makeMessage:responseDic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        saveBtn.enabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        [self progressHUDHiddenWidthString:@"保存失败"];
        [self.view makeMessage:@"保存失败" duration:2.0 position:@"center"];
        
        saveBtn.enabled = YES;
        
    }];
    
    
    
}

#pragma mark 请求商品详情
-(void)requestDtatilData{

    [HttpManager sendHttpRequestForGetNewGoodsInfoList:self.goodsNo withIsNotes:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
        
            self.goodDataArray = [NSMutableArray arrayWithCapacity:0];
            
            NSMutableArray * dataArray =  responseDic[@"data"];
            for (int i = 0; i< dataArray.count; i++) {
    
                GetGoodsInfoListDTO * goodsInfoDTO = [[GetGoodsInfoListDTO alloc]initWithDictionary:dataArray[i]];
                

                [self.goodDataArray addObject:goodsInfoDTO];
                
                if (i == 0) {//!第一个是要显示的对象
                    
                    self.getGoodsInfoList = goodsInfoDTO;
                    
                }
                
            }
            
            
            [_tableView reloadData];
        
        }else{
        
            [self.view makeMessage:@"请求商品详情失败" duration:2.0 position:@"center"];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"请求商品详情失败" duration:2.0 position:@"center"];

        
    }];
    
    
   

}
#pragma mark 请求上传参考图的数据，判断是都上传过参考图
-(void)requestUpData{

    self.historyUpArray = [NSMutableArray arrayWithCapacity:0];
    
    [HttpManager sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:self.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据合法
            if ([self checkData:data class:[NSArray class]]) {
                
                for (NSDictionary *dic in data) {
                    
                    GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [[GetImageReferImageHistoryListDTO alloc]init];
                    
                    [getImageReferImageHistoryListDTO setDictFrom:dic];
                    
                    [self.historyUpArray addObject:getImageReferImageHistoryListDTO];
                }
            }
            
        }else{
            
            [self.view makeMessage:responseDic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];

    }];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
