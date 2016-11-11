//
//  CSPUtils.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPUtils.h"
#import "NSDate+Utils.h"
@implementation CSPUtils

+ (BOOL)checkFixedLineNumber:(NSString*) fixedLineNumber {
    NSString *pattern = @"^[0-9]{13}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:fixedLineNumber];
    return isMatch;
}

+ (BOOL)checkMobileNumber:(NSString *) mobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[0-9]|5[017-9]|7[0-9]|8[23478])\\d)\\d{7}$";// !添加了183验证
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU =@"^1(3[0-2]|4[9]|5[256]|8[156])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189 !添加了177验证
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumber] == YES)
        || ([regextestcm evaluateWithObject:mobileNumber] == YES)
        || ([regextestct evaluateWithObject:mobileNumber] == YES)
        || ([regextestcu evaluateWithObject:mobileNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    
}


+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(.){6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;

}

+ (BOOL)checkUserName:(NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;

}

+ (BOOL)checkUserNameFormat:(NSString *) userName
{
    NSString *pattern = @"^[\u4E00-\u9FA50-9a-zA-Z_]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
+ (BOOL)checkAccountUserName:(NSString *)userName
{
    
    
    NSString *pattern = @"^[a-zA-Z0-9_\u4e00-\u9fa5-]{2,10}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

+ (BOOL)checkGoodsTagFormat:(NSString *)tag
{
    NSString *pattern = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:tag];
    return isMatch;
    

}



+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    idCard = [idCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([idCard length] != 18) {
         return NO;
     }
     NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
     NSString *leapMmdd = @"0229";
     NSString *year = @"(19|20)[0-9]{2}";
     NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
     NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
     NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
     NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
     NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
     NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];

     NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
     if (![regexTest evaluateWithObject:idCard]) {
         return NO;
     }
     int summary = ([idCard substringWithRange:NSMakeRange(0,1)].intValue + [idCard substringWithRange:NSMakeRange(10,1)].intValue) *7
             + ([idCard substringWithRange:NSMakeRange(1,1)].intValue + [idCard substringWithRange:NSMakeRange(11,1)].intValue) *9
             + ([idCard substringWithRange:NSMakeRange(2,1)].intValue + [idCard substringWithRange:NSMakeRange(12,1)].intValue) *10
             + ([idCard substringWithRange:NSMakeRange(3,1)].intValue + [idCard substringWithRange:NSMakeRange(13,1)].intValue) *5
             + ([idCard substringWithRange:NSMakeRange(4,1)].intValue + [idCard substringWithRange:NSMakeRange(14,1)].intValue) *8
             + ([idCard substringWithRange:NSMakeRange(5,1)].intValue + [idCard substringWithRange:NSMakeRange(15,1)].intValue) *4
             + ([idCard substringWithRange:NSMakeRange(6,1)].intValue + [idCard substringWithRange:NSMakeRange(16,1)].intValue) *2
             + [idCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCard substringWithRange:NSMakeRange(8,1)].intValue *6
             + [idCard substringWithRange:NSMakeRange(9,1)].intValue *3;
     NSInteger remainder = summary % 11;
     NSString *checkBit = @"";
     NSString *checkString = @"10X98765432";
     checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
     return [checkBit isEqualToString:[[idCard substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

+ (BOOL)checkDetailAddressLength:(NSString *)detailAddress {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{10,120}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:detailAddress];
    return isMatch;
}

+ (NSString*)translateApplyStatus:(NSString *)applyStatus {
    NSString* translation = nil;
    if ([applyStatus isEqualToString:@"1"]) {
        translation = @"待审核";
    } else if ([applyStatus isEqualToString:@"2"]) {
        translation = @"审核通过";
    } else if ([applyStatus isEqualToString:@"3"]) {
        translation = @"关闭封号";
    } else if ([applyStatus isEqualToString:@"4"]) {
        translation = @"审核拒绝";
    }

    return translation;
}

+ (NSString*)translateSex:(NSString *)sex {
    NSString* translation = nil;
    if ([sex isEqualToString:@"1"]) {
        translation = @"男";
    } else if ([sex isEqualToString:@"2"]) {
        translation = @"女";
    }

    return translation;
}

+ (long long)getTimeStampFromNSDate:(NSDate *)time {
    
    return ((long)[time timeIntervalSince1970]) * 1000;
}

+ (long long)getTimeStamp:(NSString *)time {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    
    return ((long)[date timeIntervalSince1970]) * 1000;
}

+ (NSString *)getTime:(long)timeStamp {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp / 1000]];
}

+ (BOOL)isRoundNumber:(CGFloat)value {
    CGFloat roundNumber = floor(value);
    if (value - roundNumber < 0.001) {
        return YES;
    }

    return NO;
}

+(NSString *)converDateString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSDate *dete = [dateFormatter dateFromString:string];
    return [dateFormatter stringFromDate:dete];
}

+(NSString *)converDateFormatString:(NSString *)string
{
    NSRange range = [string rangeOfString:@" "];
    NSString *str = [string substringToIndex:range.location];
    return str;
}

+(BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            
            return NO;
            
        }
        
    }
    
    // 省份代码
    
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
        
    }
    
    if (!areaFlag) {
        
        return false;
        
    }
    
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    int year =0;
    
    switch (length) {
            
        case 15:
            
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
        
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }
                
            }else {
                
                return NO;
                
            }
            
        default:
            
            return false;
            
    }
    
}

+ (CGRect)labelFitStringContentSizeWith:(UILabel*)label font:(UIFont*)labelFont boundingRectWithSize:(CGSize)size{
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect tmpRect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:labelFont,NSFontAttributeName, nil] context:nil];
    
    return tmpRect;
}

//!判断是否是null 或者 nil
+(BOOL)isEmpty:(NSObject *)obj{


    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        
        return YES;
    }

    return NO;

}

+(NSString *)stringFromNumber:(NSNumber *)number{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *myNumber = [f stringFromNumber:number];
    return myNumber;
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
+(NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"下午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"晚上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = @"凌晨";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    // return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
    return [NSString stringWithFormat:@"%@ %02d:%02d",dateStr,(int)[lastDate hour],(int)[lastDate minute]];
}

@end
