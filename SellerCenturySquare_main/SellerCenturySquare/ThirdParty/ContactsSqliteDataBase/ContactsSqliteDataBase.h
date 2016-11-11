//
//  ContactsSqliteDataBase.h
//  ContactsSqliteDatabase
//
//  Created by 李春晓 on 14-9-20.
//  Technical Communication:luckychunxiao@163.com
//  If you use GCD ,this Class cannot support.
//  Copyright (c) 2014年 李春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ProfileEntity.h"
#import <AddressBook/AddressBook.h>

//sqlite 数据库
#define CDBNAME @"GYDB.sqlite"
//PersonInfoTable this version hasn't used
#define dbPersonInfoTable @"PERSONINFO"
#define dbPersonInfo_userId @"userId"
#define dbPersonInfo_password @"password"
#define dbPersonInfo_nickName @"nickName"
#define dbPersonInfo_localAvatarImgUrl @"localAvatarImgUrl"
#define dbPersonInfo_netAvatarImgUrl @"netAvatarImgUrl"
#define dbPersonInfo_sign @"sign"
#define dbPersonInfo_email @"email"
#define dbPersonInfo_remainMoney @"remainMoney"
#define dbPersonInfo_earnMoney @"earnMoney"
#define dbPersonInfo_skinImgUrl @"skinImgUrl"
#define dbPersonInfo_displayed @"displayed"

#define dbPersonInfo_wifiCallType @"WifiCallType"
#define dbPersonInfo_otherCallType @"otherCallType"
#define dbPersonInfo_optNORCallType @"optNORCallType"
#define dbPersonInfo_keytoneEnable @"keytoneEnable"
#define dbPersonInfo_autoAnswerCallBack @"autoAnswerCallBack"

#define dbPersonInfo_registerNetworkCallType @"registerNetworkCallType"
#define dbPersonInfo_registerNONetworkCallType @"registerNONetworkCallType"
#define dbPersonInfo_unregisterType @"unregisterType"


//ContactsInfoTable
#define dbContactsInfoTable @"CONTACTS"
#define dbContactsInfo_phoneNum @"phoneNum"
#define dbContactsInfo_name @"name"
#define dbContactsInfo_sign @"sign"
#define dbContactsInfo_email @"email"
#define dbContactsInfo_netAvatarImgUrl @"netAvatarImgUrl"

#define kNickNameDefault @"昵称"
#define kSignDefault @"sign"
#define kEmailDefault @"email"

@protocol ContactsSqliteDataBaseDelegate <NSObject>

- (void)percentOfGetAddressBookDataProcess:(float)percent;

@end

@interface ContactsSqliteDataBase : NSObject
{
    sqlite3 *CDB;
}
@property (nonatomic)sqlite3 *CDB;
@property (nonatomic,assign) ABAddressBookRef addressBooks;
@property (nonatomic,assign) NSInteger contactsCount;
@property (nonatomic,strong) id <ContactsSqliteDataBaseDelegate>delegate;
@property (nonatomic,assign) float percent;
+(ContactsSqliteDataBase*)sharedInstace;

//获取联系人权限
- (BOOL)getAuthorization;
- (BOOL)isNeedChangeDataBase;
- (BOOL)initDataBase;//初始化数据库 查看是否存在 不存在则创建 返回YES ，存在返回YES
- (BOOL)execSql:(NSString *)sql;//执行sql语句
- (BOOL)updateDataInTable:(NSString*)TableName changeField:(NSString*)Field withValue:(NSString*)Value whereField:(NSString*)wField equalToValue:(NSString*)wValue;//更新
- (NSInteger)requestDataCountInTable:(NSString*)TableName;//获取数据库数据数目
- (BOOL)deleteAllDataFromTable:(NSString*)table;//删除表全部内容
- (BOOL)dropTable:(NSString*)table;//删除表

/*
 * 自定义
 */
/*个人信息表*/
- (BOOL)createPersonInfoTable;//创建个人信息表
- (BOOL)InsertToPersonInfoTableWithUserId:(NSString *)userId userPassword:(NSString*)upass nickName:(NSString*)nickName localAvatarImgUrl:(NSString*)localAvatarImgUrl netAvatarImgUrl:(NSString *)netAvatarImgUrl sign:(NSString*)sign email:(NSString*)email remainMoney:(NSString*)remainMoney earnMoney:(NSString*)earnMoney skinImgUrl:(NSString*)skinImgUrl displayed:(NSString *)displayed wifiCallType:(NSString*)wifiCallType otherCallType:(NSString*)otherCallType optNORCallType:(NSString*)optNORCallType keytoneEnable:(NSString*)keytoneEnable autoAnswerCallBack:(NSString*)autoAnswerCallBack;//个人信息数据添加
- (BOOL)selectDataFromPensonTableWithField:(NSString*)Field isEqualtoValue:(NSString*)Value;//提取符合条件个人信息

/*联系人表*/
- (BOOL)createContactsInfoTable;//创建联系人表格
- (BOOL)insertToContactsInfoTableWithName:(NSString *)name phoneNum:(NSString*)phoneNum sign:(NSString *)sign email:(NSString*)email andNetAvatarImgUrl:(NSString *)netAvatarImgUrl;//联系人数据添加
- (void)getContactsData;//获取本地联系人
- (NSMutableDictionary*)selectDataFromContactsTable;//获取本地数据库中的联系人
- (NSMutableDictionary*)selectDataFromContactsTableForSearch;//为搜索功能获取联系人
- (NSMutableArray*)selectDataFromContactsTableAsArray;//获取联系人数组数据
- (NSDictionary*)selectDataFromContactsTableWithField:(NSString*)Field EqualToValue:(NSString*)Value;//获取符合条件的联系人信息


@end
