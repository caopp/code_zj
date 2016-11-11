//
//  MergeSendGoodsDTO.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MergeSendGoodsDTO : BasicDTO
/**
 *  总数量
 */
@property (nonatomic ,strong) NSNumber *totalCount;

/**
 *  会员list
 */
@property (nonatomic ,strong) NSMutableArray *memberListArr;


@end

@interface MemberListDTO : BasicDTO

/**
 *  会员编码
 */
@property (nonatomic ,strong) NSString *memberNo;

/**
 *  会员昵称
 */
@property (nonatomic ,strong) NSString *nickName;

/**
 *  会员手机号码
 */
@property (nonatomic ,strong) NSString *mobilePhone;

/**
 *  会员聊天帐号
 */
@property (nonatomic ,strong) NSString *chatAccount;

/**
 *  采购单List
 */
@property (nonatomic ,strong) NSMutableArray *orderList;

@property (nonatomic ,strong) NSString *headCheckBtn;

@property (nonatomic ,strong) NSMutableArray *groupList;

@end


@interface OrderListDTO: BasicDTO



@property (nonatomic ,strong) NSDictionary *dictDetailInfo;

@property (nonatomic ,strong)NSString* numb;

/**
*  快递地址(类型:int)
*/
@property(nonatomic,strong)NSNumber *addressId;
/**
 *  会员编号
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  商家编号
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  会员名称
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  小B昵称
 */
@property(nonatomic,copy)NSString *nickName;
/**
 *  小B会员手机
 */
@property(nonatomic,copy)NSString *memberPhone;
/**
 *  采购单号
 */
@property(nonatomic,copy)NSString *orderCode;
/**
 *  采购单状态(0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收)
 */
@property(nonatomic,strong)NSNumber *status;
/**
 *  采购单总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalQuantity;
/**
 *  采购单总金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *originalTotalAmount;
/**
 * 应付金额/(类型:double)
 */
@property(nonatomic,strong)NSNumber *totalAmount;
/**
 *  实付金额
 */
@property (nonatomic ,strong)NSNumber *paidTotalAmount;
/**
 *  采购单类型(0-期货 ;1-现货 类型:int)
 */
@property(nonatomic,strong)NSNumber *type;

/**
 *  小B聊天帐号
 */
@property(nonatomic,strong)NSString *chatAccount;

/**
 *  采购单条目列表
 */
@property(nonatomic,strong)NSMutableArray *orderGoodsItemsList;




/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString *color;
/**
 *  商品图片(窗口图的第1张)
 */
@property(nonatomic,copy)NSString *picUrl;
/**
 *  商品类型(0普通商品 , 1样板商品 2邮费专拍)
 */
@property(nonatomic,copy)NSString *cartType;
/**
 *  单价(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  该sku 购买数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 *  尺码组合(尺码:M:3,L:1（sku合并：sku名称:数量，sku名称:数量）)
 */
@property(nonatomic,copy)NSString *sizes;

/**
 *  是否选择按钮
 */
@property (nonatomic ,strong) NSString *checkBtn;








@end