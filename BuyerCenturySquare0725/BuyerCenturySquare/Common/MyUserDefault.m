//
//  MyUserDefault.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/6.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MyUserDefault.h"

@implementation MyUserDefault
#pragma mark ------登录--------（储存，退出时就进行删除）
/**
 *  登录账号
 */
+(void)defaultSaveAppSetting_loginPhone:(NSString*)loginPhone
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:loginPhone forKey:@"loginPhone"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_loginPhone
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"loginPhone"];
}
+(void)removeLoginPhone
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"loginPhone"];
    [user synchronize];
}
/**
 *  登录密码
 */
+(void)defaultSaveAppSetting_loginPassword:(NSString*)loginPassword
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:loginPassword forKey:@"loginPassword"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_loginPassword
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"loginPassword"];
}
+(void)removeLoginPassword
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"loginPassword"];
    [user synchronize];
}


//保存网点名字
+(void)defaultSaveAppSetting_storename:(NSString*)storename
{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:storename forKey:@"storename"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_storename
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"storename"];

}
+(void)removestorename
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"storename"];
    [user synchronize];

}

//验证码保存网点名字
+(void)defaultSaveAppSetting_codeStorename:(NSString*)codeStorename
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:codeStorename forKey:@"codeStorename"];
    [defaults synchronize];

}

+(NSString*)defaultLoadAppSetting_codeStorename
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"codeStorename"];

}
+(void)removeCodeStorename
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"codeStorename"];
    [user synchronize];

}


//验证码保存网店名字
+(void)defaultSaveAppSetting_codeStore:(NSString*)codeStore
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:codeStore forKey:@"codeStore"];
    [defaults synchronize];

}
+(NSString*)defaultLoadAppSetting_codeStore
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"codeStore"];
}
+(void)removeCodeStore
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"codeStore"];
    [user synchronize];

}










#pragma mark ------申请资料----
//tokenID
+(void)defaultSaveAppSetting_token:(NSString*)token
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:token forKey:@"tokenId"];
    
    [defaults synchronize];
    
}
+(NSString *)defaultLoadAppSetting_token
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"tokenId"];
}
+(void)removeToken
{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"tokenId"];
    [user synchronize];
    
}
//merchantNo
+(void)defaultSaveAppSetting_merchantNo:(NSString*)merchantNo
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:merchantNo forKey:@"memberNo"];
    
    [defaults synchronize];
    
}
+(NSString*)defaultLoadAppSetting_merchantNo
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"memberNo"];


}
+(void)removeMerchantNo
{

    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"memberNo"];
    [user synchronize];

}






/**
 *  姓名
 */
+(void)defaultSaveAppSetting_name:(NSString*)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"name"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"name"];
}
+(void)removeName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"name"];
    [defaults synchronize];
}

/**
 *  手机号码
 */
+(void)defaultSaveAppSetting_phone:(NSString*)phone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phone forKey:@"phone"];
    [defaults synchronize];

}
+(NSString*)defaultLoadAppSetting_phone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"phone"];

}
+(void)removePhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"phone"];
    [defaults synchronize];

}

/**
 *  省市区
 */
+(void)defaultSaveAppSetting_area:(NSString*)area
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:area forKey:@"area"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_area
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"area"];
}
+(void)removeArea
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey: @"area"];
    [defaults synchronize];
}
/**
 *  座机电话
 */
+(void)defaultSaveAppSetting_telephone:(NSString*)telephone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:telephone forKey:@"telephone"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_telephone
{
    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"telephone"];
}
+(void)removeTelephone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"telephone"];
    [defaults synchronize];
}

/**
 *  省的id
 */
+(void)defaultSaveAppSetting_stateId:(NSNumber*)stateId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:stateId forKey:@"stateId"];
    [defaults synchronize];

}
+(NSNumber*)defaultLoadAppSetting_stateId
{
    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"stateId"];
}
+(void)removesTateId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"stateId"];
    [defaults synchronize];

}

/**
 *  城市的id
 */
+(void)defaultSaveAppSetting_cityId:(NSNumber*)cityId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cityId forKey:@"cityId"];
    [defaults synchronize];


}
+(NSNumber*)defaultLoadAppSetting_cityId
{
    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"cityId"];

}
+(void)removeCityId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"cityId"];
    [defaults synchronize];



}

/**
 *  区域的id
 */
+(void)defaultSaveAppSetting_districtId:(NSString*)districtId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:districtId forKey:@"districtId"];
    [defaults synchronize];
   
    
}
+(NSString*)defaultLoadAppSetting_districtId
{
    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"districtId"];

}
+(void)removeDistrictId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"districtId"];
    [defaults synchronize];
}




/**
 *  省市区详细地址
 */
+(void)defaultSaveAppSetting_areaDetail:(NSString *)areaDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:areaDetail forKey:@"areaDetail"];
    [defaults synchronize];

}
+(NSString*)defaultLoadAppSetting_areaDetail
{
    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"areaDetail"];
}
+(void)removeAreaDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"areaDetail"];
    [defaults synchronize];
  
}

#pragma mark 判断用户是否从登陆界面过来的，是则刷新商家列表
+(void)defaultSave_logined{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"logined"];
    [defaults synchronize];


}
+(NSString*)defaultLoadLogined{

    NSUserDefaults *defaulits = [NSUserDefaults standardUserDefaults];
    return  [defaulits objectForKey: @"logined"];


}
+(void)removeLogined{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"logined"];
    [defaults synchronize];

}

//!加载本地版本号
+(void)defaultSetAppVersion:(NSString *)version{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:version forKey:@"version"];
    [defaults synchronize];
    
    
    
}

+(NSString*)defaultLoad_oldVersion{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"version"];
    
    
    
}
+(void)removeVersion{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"version"];
    [defaults synchronize];
    
}



//判断一个字符串是否为空值
+(BOOL)isBlankString:(NSObject *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
  
    return NO;
}

//判断ID不能是否为空
+(BOOL)isBlankNum:(NSNumber*)num
{
    if (num == nil || num == NULL || [num  isEqual: @""]) {
        return YES;
    }
    if ([num isKindOfClass:[NSNull class]]) {
        return YES;
    }

    return  NO;
}

//! 点击tabbar按钮进入的 全部商品列表
+(void)defaultSaveIntoAllGoods{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"intoAllGoods" forKey:@"intoAllGoods"];
    [defaults synchronize];
    

}
+(NSString*)defaultLoadIntoAllGoods{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"intoAllGoods"];
    


}
+(void)removeIntoAllGoods{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"intoAllGoods"];
    [defaults synchronize];

}

//!登录的时候判断是否是苹果审核账号
+(void)saveIsAppleAcount{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"isApple" forKey:@"isApple"];
    [defaults synchronize];
}
+(NSString*)loadIsAppleAccount{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"isApple"];
}
+(void)removeIsAppleAccount{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isApple"];
    [defaults synchronize];

}


/**
 *
 */
+(void)defaultSaveAppSetting_courierPhone:(NSString*)courierPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:courierPhone forKey:@"courierPhone"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_courierPhone
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"courierPhone"];
}

+(void)removeCourierPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"courierPhone"];
    [defaults synchronize];
}

//对省市区版本进行控制更新
+(void)defaultSaveAppSetting_cityVersion:(NSString*)cityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    [defaults setObject:cityVersion forKey:@"propValue"];
    [defaults synchronize];
    
}
+(NSString*)defaultLoadAppSetting_cityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"propValue"];
}
+(void)removeCityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"propValue"];
    [defaults synchronize];
}


//!根据后台接口进行判断
+(void)saveRegistFlagAcount:(NSString *)registFlag{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:registFlag forKey:@"registFlag"];
    [defaults synchronize];
}
+(NSString*)loadRegistFlagAccount{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"registFlag"];
}
+(void)removeRegistFlagAccount{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"registFlag"];
    [defaults synchronize];
}

//!根据后台接口进行判断
+(void)saveH5RegistFlagAcount:(NSString *)registFlag{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:registFlag forKey:@"registFlag"];
    [defaults synchronize];
}
+(NSString*)loadH5RegistFlagAccount{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"registFlag"];
}
+(void)removeH5RegistFlagAccount{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"registFlag"];
    [defaults synchronize];
}





@end
