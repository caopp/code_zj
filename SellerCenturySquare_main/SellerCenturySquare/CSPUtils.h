//
//  CSPUtils.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSPUtils : NSObject

/**
 *  正则匹配固话
 */
+ (BOOL)checkFixedLineNumber:(NSString*) fixedLineNumber;

/**
 *  正则匹配手机号
 */
+ (BOOL)checkMobileNumber:(NSString *) mobileNumber;

/**
 *  正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/**
 *  正则匹配用户姓名,20位的中文或英文
 */
+ (BOOL)checkUserName : (NSString *) userName;

/**
 *  正则匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

/**
 *
 *  正则匹配用户6-20个字母、数字、下划线或减号
 */
+(BOOL)checkAccountUserName:(NSString *)userName;


/**
 *
 */
+ (BOOL)checkDetailAddressLength:(NSString*)detailAddress;


+ (NSString*)translateApplyStatus:(NSString*)applyStatus;


+ (NSString*)translateSex:(NSString *)sex;

//将时间转化成时间戳 传入的时间格式为NSDate
+ (long long)getTimeStampFromNSDate:(NSDate *)time;

//将时间转化成时间戳 传入的时间格式为yyyy-MM-dd HH:mm:ss
+ (long long)getTimeStamp:(NSString *)time;

//将时间戳转化成时间
+ (NSString *)getTime:(long)timeStamp;

//将日期转化为年月格式
+(NSString *)converDateString:(NSString *)string;

//将时间转为日期格式
+(NSString *)converDateFormatString:(NSString *)string;

+ (BOOL)checkUserNameFormat:(NSString *) userName;
//+ (BOOL)checkUserNameNumber:(NSString *) userName;
+ (BOOL)isRoundNumber:(CGFloat)value;

+(BOOL)validateIDCardNumber:(NSString *)value;

//检查 只能输入 数字，字母，汉字
+ (BOOL)checkGoodsTagFormat:(NSString *)tag;


//Label 代码适配字符长度
+ (CGRect)labelFitStringContentSizeWith:(UILabel*)label font:(UIFont*)labelFont boundingRectWithSize:(CGSize)size;

//!判断是否是null 或者 nil
+(BOOL)isEmpty:(NSObject *)obj;

//number 转为 string
+(NSString *)stringFromNumber:(NSNumber *)number;
//时间转换
+(NSString *)changeTheDateString:(NSString *)Str
;
@end
