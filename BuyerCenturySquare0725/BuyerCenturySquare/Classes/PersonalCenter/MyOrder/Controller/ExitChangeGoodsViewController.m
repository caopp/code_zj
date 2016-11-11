//
//  ExitChangeGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExitChangeGoodsViewController.h"
#import "Masonry.h"
#import "RefundProjectTableViewCell.h"
#import "PhotoProveTableViewCell.h"
#import "RefundApplyDTO.h"
#import "BottomPhotoProveView.h"
#import "BottomPhotoProveView.h"
#import "ReturnApplyViewController.h"//!申请退换货
#import "ChangeExitChangeGoodsDetailView.h"
#import "ChangeExitGoodsAndCancelView.h"
#import "MyOrderDetailViewController.h"


@interface ExitChangeGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *titleArr;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *bottomBtn;
@property (nonatomic ,strong) RefundApplyDTO *refundDto;
@property (nonatomic ,strong) NSMutableArray *contentArr;
@property (nonatomic ,strong) ChangeExitChangeGoodsDetailView *changeExitView;
@property (nonatomic ,strong) ChangeExitGoodsAndCancelView *changeEixtCancelView;


@end

@implementation ExitChangeGoodsViewController
- (void)viewWillAppear:(BOOL)animated
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  addCustombackButtonItem];
    self.title = @"退/换货详情";
    
    
    self.titleArr = [[NSMutableArray alloc] init];
    self.contentArr = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    

    
    [HttpManager sendHttpRequestForRefundDetailOrderCode:self.orderCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            self.refundDto = [[RefundApplyDTO alloc] init];
            [self.refundDto setDictFrom:dic[@"data"]];
            
            
            //第零行 申请服务
            NSString *applyService;
            if ([self.refundDto.refundType isKindOfClass:[NSNumber class]]) {
                
            
            if (self.refundDto.refundType.integerValue == 0) {
                applyService = @"退货退款";
                
                [self.titleArr removeAllObjects];
                [self.contentArr removeAllObjects];
                NSArray *arrList = @[@"申请服务:",@"退货原因:",@"退款金额:",@"补充说明:",@"图片凭证:"];
                NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未填写",@"未上传" ];
                [self.titleArr addObjectsFromArray:arrList];
                [self.contentArr addObjectsFromArray:arrTitle];
                
                if (self.refundDto.refundStatus.integerValue == 0) {
                    
                    if (!self.changeEixtCancelView) {
                        self.changeEixtCancelView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeExitGoodsAndCancelView" owner:nil options:nil] lastObject];
                        self.changeEixtCancelView.blockChangeExitGoodsAndCancelView = ^(NSString *type)
                        {
                            
                            if ([type isEqualToString:@"0"]) {
                                
                                [self cancenExitChangeOrder];
                                
                                
                            }else if ([type isEqualToString:@"1"])
                            {
                            [self changeExitChangeGoodsContent];
                            }
                            
                        };
                        [self.view addSubview:self.changeEixtCancelView];
                        [self.changeEixtCancelView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.height.equalTo(@49);
                        }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];
                        
                    }
                }else
                {
                    if (self.changeEixtCancelView) {
                        [self.changeEixtCancelView removeFromSuperview];
                        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                        }];
                        
                        
                        
                    }
                }
                
                
            }else if (self.refundDto.refundType.integerValue == 1)
            {
                applyService = @"仅退款";
                [self.titleArr removeAllObjects];
                [self.contentArr removeAllObjects];
                NSArray *arrList = @[@"申请服务:",@"货物状态:",@"退款原因:",@"退款金额:",@"补充说明:",@"图片凭证:"];
                NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未填写",@"未填写" ,@"未上传"];
                [self.titleArr addObjectsFromArray:arrList];
                [self.contentArr addObjectsFromArray:arrTitle];


                
                if (self.refundDto.refundStatus.integerValue == 2) {
                    if (!self.changeExitView) {
                        self.changeExitView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeExitChangeGoodsDetailView" owner:nil options:nil] lastObject];
                        
                        [self.view addSubview:self.changeExitView];
                        
                        self.changeExitView.blockChangeExitChangeGoodsDetailView =^()
                        {
                            [self changeExitChangeGoodsContent];
                        };
                        
                        [self.changeExitView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.height.equalTo(@49);
                        }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];
                    }
                }else
                {
                    if (self.changeExitView) {
                        [self.changeExitView removeFromSuperview];
                        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                        }];
                    }
                    
                    
                }
                
            }else if (self.refundDto.refundType.integerValue == 2)
            {
                applyService = @"换货";
                
                [self.titleArr removeAllObjects];
                [self.contentArr removeAllObjects];
                NSArray *arrList = @[@"申请服务:",@"换货原因:",@"补充说明:",@"图片凭证:"];
                NSArray *arrTitle = @[@"未填写",@"未填写",@"未填写",@"未上传" ];
                [self.titleArr addObjectsFromArray:arrList];
                [self.contentArr addObjectsFromArray:arrTitle];


                
                if (self.refundDto.refundStatus.integerValue == 4) {
                    if (!self.changeExitView) {
                        self.changeExitView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeExitChangeGoodsDetailView" owner:nil options:nil] lastObject];
                        
                        [self.view addSubview:self.changeExitView];
                        
                        self.changeExitView.blockChangeExitChangeGoodsDetailView =^()
                        {
                            [self changeExitChangeGoodsContent];
                        };
                        
                        [self.changeExitView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.height.equalTo(@49);
                        }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];
                        
                        
                        
                    }
                }else
                {
                    if (self.changeExitView) {
                        [self.changeExitView removeFromSuperview];
                        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                        }];
                    }
                    
                    
                }

            }
            
            
        }
            //
            //货物状态
            NSString*changeGoodsResion;
            if ([self.refundDto.goodsStatus isKindOfClass:[NSNumber class]]) {
                if (self.refundDto.goodsStatus.integerValue == 0) {
                    changeGoodsResion = @"未收到货 ";
                }else if (self.refundDto.goodsStatus.integerValue == 1)
                {
                    changeGoodsResion = @"已收到货";
                }
            }
            
            
            
            
            
            //            第一行 退货原因  //换货原因
            NSString *exitGoodsResion;
            if ([self.refundDto.refundReason isKindOfClass:[NSNumber class]]) {
                switch (self.refundDto.refundReason.integerValue) {
                    case 0:
                        exitGoodsResion = @"质量问题";
                        break;
                    case 1:
                        exitGoodsResion = @"尺码问题";
                        break;
                    case 2:
                        exitGoodsResion = @"少件/破损";
                        break;
                        
                    case 3:
                        exitGoodsResion = @"卖家发错货";
                        break;
                    case 4:
                        exitGoodsResion = @"未按约定时间发货";
                        break;
                    case 5:
                        exitGoodsResion = @"多拍/拍错/不想要";
                        break;
                    case 6:
                        exitGoodsResion = @"快递/物流问题";
                        break;
                        
                    case 7:
                        exitGoodsResion = @"空包裹/少货";
                        break;
                    case 8:
                        exitGoodsResion = @"其他";
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            
            
            //退款金额
            NSString *exitMoney;
            
            if ([self.refundDto.refundFee isKindOfClass:[NSNumber class]]) {
                exitMoney = [NSString stringWithFormat:@"￥%.2f",self.refundDto.refundFee.doubleValue];
                
            }
            
            
            // 补充说明
            NSString * moreInstruction;
            if ([self.refundDto.remark isKindOfClass:[NSString class]]) {
                
                if (self.refundDto.remark.length>0) {
                    
                    
                    moreInstruction = self.refundDto.remark;
                }
                
            }
            //上传凭证
            NSString *photoStr;
            if ([self.refundDto.pics isKindOfClass:[NSString class]]) {
                photoStr = [NSString stringWithFormat:@"%@",self.refundDto.pics];
                
            }
            
            
            NSArray *contentArr = self.titleArr;
            for (int i = 0; i<self.titleArr.count; i++) {
                NSString *content = contentArr[i];
                if ([content isEqualToString:@"申请服务:"]) {
                    if (applyService.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:applyService];
                    }
                    
                }else if ([content isEqualToString:@"货物状态:"])
                {
                    if (changeGoodsResion.length>0) {
                        [self.contentArr  replaceObjectAtIndex:i withObject:changeGoodsResion];
                    }
                }else if ([content isEqualToString:@"退款原因:"])
                {
                    if (exitGoodsResion.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    }
                }else if ([content isEqualToString:@"退货原因:"])
                {
                    if (exitGoodsResion.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    }
                    
                }else if ([content isEqualToString:@"退款金额:"])
                {
                    if (exitMoney.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:exitMoney];
                    }
                }else if ([content isEqualToString:@"补充说明:"])
                {
                    if (moreInstruction.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:moreInstruction];
                    }
                }else if ([content isEqualToString:@"图片凭证:"])
                {
                    if (photoStr.length>0) {
                        [self.contentArr replaceObjectAtIndex:i withObject:photoStr];
                    }
                }else if ([content isEqualToString:@"换货原因:"])
                {
                    [self.contentArr replaceObjectAtIndex:i withObject:exitGoodsResion];
                    
                }
            }
            
            
            [self.tableView reloadData];
            

        }else
        {
            DebugLog(@"%@", dic[@"errorMessage"]);
        }

//        0-质量问题 1-尺码问题 2-少件/破损 3-卖家发错货 4-未按约定时间发货5-多拍/拍错/不想要6-快递/物流问题7-空包裹/少货8-其他
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return  self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"RefundProjectTableViewCellId";
    static NSString *cellExit = @"PhotoProveTableViewCellId";
    
    if (indexPath.row == self.titleArr.count-1) {
        
        
        if ([self.contentArr.lastObject isEqualToString:@"未上传"]) {
            
            RefundProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundProjectTableViewCell" owner:nil options:nil] lastObject];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.promptTypeLab.text = self.titleArr[indexPath.row];
            cell.prompContentLab.text = self.contentArr[indexPath.row];
            return cell;
        }

        PhotoProveTableViewCell *cellExiTView = [tableView dequeueReusableCellWithIdentifier:cellExit];
        if (!cellExiTView) {
            cellExiTView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoProveTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        cellExiTView.refundApp = self.refundDto;
        cellExiTView.selectionStyle = UITableViewCellSelectionStyleNone;

        return cellExiTView;
        
        
        
    }
    RefundProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundProjectTableViewCell" owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.promptTypeLab.text = self.titleArr[indexPath.row];
    cell.prompContentLab.text = self.contentArr[indexPath.row];
    
    
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if ([self.refundDto.refundType isKindOfClass:[NSNumber class]]) {
        
    
    if (self.refundDto.refundType.integerValue == 0) {
        
        if (self.refundDto.refundStatus.integerValue == 0) {
            
            
            UIView *headView = [[UIView alloc] init];
            headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            UILabel *headLab = [[UILabel alloc] init];
            
            
            
            headLab.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            headLab.text = @"等待商家确认收货并退款";
            headLab.font = [UIFont systemFontOfSize:13];
            
            headLab.textAlignment = NSTextAlignmentCenter;
            headLab.backgroundColor = [UIColor redColor];
            headLab.textColor = [UIColor whiteColor];
            [headView addSubview:headLab];
            return headView;
        }
    }else if (self.refundDto.refundType.integerValue == 1)
    {
        
        
        if (self.refundDto.refundStatus.integerValue == 2) {
            
            
            UIView *headView = [[UIView alloc] init];
            headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            UILabel *headLab = [[UILabel alloc] init];
            
            
            
            headLab.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            headLab.text = @"等待商家确认退款";
            headLab.font = [UIFont systemFontOfSize:13];
            
            headLab.textAlignment = NSTextAlignmentCenter;
            headLab.backgroundColor = [UIColor redColor];
            headLab.textColor = [UIColor whiteColor];
            [headView addSubview:headLab];
            return headView;        }
    }
}

    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((self.titleArr.count -2)== indexPath.row) {
        if ([self.titleArr[indexPath.row] isEqualToString:@"补充说明:"]) {
            CGFloat height = [self accordingContentFont:self.contentArr[indexPath.row]].height+29;
            if (height<45) {
                return 45;
            }
            
            
            return  height;
            
            
        }
    }
    
    if (self.titleArr.count == indexPath.row+1) {
        
        if ([self.contentArr.lastObject isEqualToString:@"未上传"]) {
            return 45;
        }
        

        if (self.refundDto) {
            //        for (NSString *refund in refundApp.pics) {
            //            NSLog(@"%@",refund);
            //        }
            NSArray *picsStr = [self.refundDto.pics componentsSeparatedByString:@","];
            NSLog(@"%@",picsStr);
            CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width - 115;
            int recordIntX = 0;
            int recordIntY = 0;
            CGFloat recordImageX = 0.0;
            CGFloat recordImageY = 0.0;
            CGRect recordImageRect;
            
            for (int i = 0; i < picsStr.count; i++) {
                

                if (recordImageX>viewWidth-80) {
                    recordIntX = 0;
                    recordIntY++;
                }
                
                CGRect rect = CGRectMake(80*recordIntX, 80*recordIntY, 70, 70);

                recordIntX++;
                recordImageRect = rect;
                recordImageX = CGRectGetMaxX(recordImageRect);
                recordImageY = CGRectGetMaxY(recordImageRect);
                }
            return recordImageY+20;
        }
        
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    
    if (self.refundDto.refundType.integerValue == 0) {
        
        if (self.refundDto.refundStatus.integerValue == 0) {
            
            return 30;
        }
    }else if (self.refundDto.refundType.integerValue == 1)
    {
        
        
        if (self.refundDto.refundStatus.integerValue == 2) {
            
            return 30;
        }
    }
    return 0.01f;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    BottomPhotoProveView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomPhotoProveView" owner:self options:nil] lastObject];
//    bottomView.refundApp = self.refundDto;
//    return bottomView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    if (self.refundDto) {
//        
//        NSArray *picsStr = [self.refundDto.pics componentsSeparatedByString:@","];
//        NSLog(@"%@",picsStr);
//        CGFloat viewWidth = self.view.frame.size.width - 97;
//        int recordIntX = 0;
//        int recordIntY = 0;
//        CGFloat recordImageX = 0.0;
//        CGFloat recordImageY = 0.0;
//        CGRect recordImageRect;
//        
//        for (int i = 0; i < picsStr.count; i++) {
//            
//            if (recordImageX>viewWidth) {
//                recordIntX = 0;
//                recordIntY++;
//            }
//            
//           CGRect rect = CGRectMake(80*recordIntX, 80*recordIntY, 70, 70);
//            
//            recordIntX++;
//            recordImageRect = rect;
////            [self.imagePhotoView addSubview:image];
//            
//            recordImageX = CGRectGetMaxX(recordImageRect);
//            recordImageY = CGRectGetMaxY(recordImageRect);
//        }
//        return recordImageY+20;
//    }
//
//    
//    return 0;
//}


//修改退换货内容
- (void)changeExitChangeGoodsContent
{
    
    ReturnApplyViewController * returnApplyVC = [[ReturnApplyViewController alloc]init];
    returnApplyVC.orderDetailInfo = self.detailDto;
    returnApplyVC.applyDTO =  self.refundDto;
    returnApplyVC.isFromApplyDetail = YES;//!标志是从申请详情进入的
    [self.navigationController pushViewController:returnApplyVC animated:YES];
    
    
}

//取消退换订单
- (void)cancenExitChangeOrder
{
    
    [self progressHUDShowWithString:@""];

    [HttpManager sendHttpRequestForRefundCancelrefundNo:self.refundDto.refundNo Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            //!发送通知给订单列表，刷新订单列表
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshOrderList" object:nil];
            [self progressHUDHiddenWidthString:@""];
            
            [self backBarButtonClick:nil];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    } ];
}


/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[MyOrderDetailViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}


- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 105;
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
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
