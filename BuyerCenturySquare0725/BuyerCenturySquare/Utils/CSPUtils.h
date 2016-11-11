//
//  CSPUtils.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DataValidationResult) {
    DataValidationResultLegal,
    DataValidationResultEmpty,
    DataValidationResultTooShort,
    DataValidationResultTooLong,
    DataValidationResultIllegal
};

@interface CSPUtils : NSObject

+ (DataValidationResult)checkDataValidationForUserName:(NSString *) userName;
+ (DataValidationResult)checkDataValidationForCode:(NSString *) code;

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
 *  正则匹配用户姓名,中文或英文
 */
+ (BOOL)checkUserNameFormat:(NSString *) userName;

/**
 *  正则匹配用户昵称,20位的中文、英文或数字的组合
 */
+(BOOL)checkNickName:(NSString*)userName;
/**
 *  正则匹配用户微信,数字的组合
 */

+(BOOL)checkWeChatNumber:(NSString*)userName;
/**
 *  正则匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

+(BOOL)checkMoneyNumber:(NSString *)money;
//^[0-9]+(.[0-9]{2})?$

/**
 *
 */
+ (BOOL)checkDetailAddressLength:(NSString*)detailAddress;

/**
 *  正则匹配邮政编码
 */
+ (BOOL)checkPostalCode:(NSString*) postalCode;

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


+ (BOOL)isRoundNumber:(CGFloat)value;

//判断字符数
+ (int)countWord:(NSString *)s;

+ (void)loadAddressInfo;

//number 转为 string
+(NSString *)stringFromNumber:(NSNumber *)number;


//时间转换
+ (NSString *)changeTheDateString:(NSString *)Str;
//最多20个字符进行检测
+(BOOL)checkCharacterFormat:(NSString *)str;

@end
