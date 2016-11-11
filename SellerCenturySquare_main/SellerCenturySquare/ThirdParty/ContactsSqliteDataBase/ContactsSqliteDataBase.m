//
//  ContactsSqliteDataBase.m
//  ContactsSqliteDatabase
//
//  Created by 李春晓 on 14-9-20.
//  Technical Communication:luckychunxiao@163.com
//  Copyright (c) 2014年 李春晓. All rights reserved.
//

#import "ContactsSqliteDataBase.h"
#import "ChineseToPinyin.h"
@implementation ContactsSqliteDataBase
{
    int dataCount;
}
@synthesize addressBooks;

static ContactsSqliteDataBase *sharedGYSqlite = nil;

+(ContactsSqliteDataBase *)sharedInstace
{
    if (sharedGYSqlite==nil)
    {
        sharedGYSqlite = [[ContactsSqliteDataBase alloc]init];
    }
    return sharedGYSqlite;
}


- (BOOL)initDataBase
{
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();

    if (authStatus == kABAuthorizationStatusAuthorized)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:CDBNAME];
        NSLog(@"sqlite数据库路径：%@",database_path);
        if (sqlite3_open([database_path UTF8String], &CDB) != SQLITE_OK)
        {
            sqlite3_close(CDB);
            NSLog(@"sqlite数据库打开失败");
           
            return NO;
        }
        else
        {
           
            [self createPersonInfoTable];
            [self createContactsInfoTable];
            
            NSMutableDictionary *contactsInfo = [[ContactsSqliteDataBase sharedInstace]selectDataFromContactsTable];
            addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
            if (contactsInfo.allKeys.count==0)
            {
                [self getContactsData];
               
                
            }else if(_contactsCount!=nPeople){
                [self deleteAllDataFromTable:dbContactsInfoTable];
                [self getContactsData];
                
            }
            
            _contactsCount = nPeople;//有部分空值的联系人不会载入到数据库
        }
    }
    
    return YES;
}


- (BOOL)isNeedChangeDataBase
{
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    if (authStatus == kABAuthorizationStatusAuthorized)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:CDBNAME];
        NSLog(@"sqlite数据库路径：%@",database_path);
        if (sqlite3_open([database_path UTF8String], &CDB) != SQLITE_OK)
        {
            sqlite3_close(CDB);
            NSLog(@"sqlite数据库打开失败");
            return NO;
        }
        else
        {
            NSMutableDictionary *contactsInfo = [[ContactsSqliteDataBase sharedInstace]selectDataFromContactsTable];
            addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
            if (contactsInfo.allKeys.count==0)
            {
                return YES;
                
            }else if(_contactsCount!=nPeople){
                
                return YES;
            }
        }
    }
    
    return NO;
}


//处理sql语句
- (BOOL)execSql:(NSString *)sql
{
    char *err;
    @try {
        NSLog(@"处理sql语句：%@",sql);
        if (sqlite3_exec(CDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            NSAssert1(0,@"Error:%s",sqlite3_errmsg(CDB));
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"execSql异常：%@",exception);
    }
    @finally {
        NSLog(@"execSql操作完成");
    }
    
    return YES;
}

//判断表是否存在 ???sqlite回调参数
- (BOOL)tableExist:(NSString*)tableName
{
    char *err;
    NSString *sqlCheckTable = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name = '%@'",tableName];
    int exist;
    sqlite3_exec(CDB, [sqlCheckTable UTF8String],NULL,&exist, &err);
    return exist;
}


//更新字段数据
- (BOOL)updateDataInTable:(NSString*)TableName changeField:(NSString*)Field withValue:(NSString*)Value whereField:(NSString*)wField equalToValue:(NSString*)wValue
{
    
    
    NSString *sqlUp = [NSString stringWithFormat:@"UPDATE %@ SET %@ ='%@' WHERE %@ =%@",TableName,Field,Value,wField,wValue];
    
    NSLog(@"%@" ,sqlUp);
    
    if ([self execSql:sqlUp])
    {
        NSLog(@"修改成功");
        return YES;
    }
    else
    {
        NSLog(@"%@修改失败",sqlUp);
    }
    return NO;
}

//删除表内全部内容
- (BOOL)deleteAllDataFromTable:(NSString*)table
{
    NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@",table];
    
    if ([self execSql:sqlDelete])
    {
        NSLog(@"%@数据删除成功",table);
        return YES;
    }
    return NO;
}

//删除表
- (BOOL)dropTable:(NSString*)table
{
    NSString *sqlDelete = [NSString stringWithFormat:@"DROP TABLE %@",table];
    
    if ([self execSql:sqlDelete])
    {
        NSLog(@"%@表删除成功",table);
        return YES;
    }
    return NO;
}

//获取数据库数据数目？？？？未完成
- (NSInteger)requestDataCountInTable:(NSString*)TableName
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) FROM %@",TableName];
    char *count;
    sqlite3_exec(CDB, [sql UTF8String],dataCountCallBack,&count,&err);
    return (int)count;
    
}

int dataCountCallBack( void * para, int n_column, char ** column_value, char ** column_name )
{
    char *count= NULL;
    count = (char*)para;
    count = *column_value;
    return  (int)*column_value;
}


/*
 * 自定义内容
 */

//创建数据表
- (BOOL)createPersonInfoTable
{
    
//    NSString *url = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    NSString *sqlCreatePersonInfoTable =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT)",dbPersonInfoTable,dbPersonInfo_userId,dbPersonInfo_password,dbPersonInfo_nickName,dbPersonInfo_localAvatarImgUrl,dbPersonInfo_netAvatarImgUrl,dbPersonInfo_sign,dbPersonInfo_email,dbPersonInfo_remainMoney,dbPersonInfo_earnMoney,dbPersonInfo_skinImgUrl,dbPersonInfo_displayed,dbPersonInfo_wifiCallType,dbPersonInfo_otherCallType,dbPersonInfo_optNORCallType,dbPersonInfo_keytoneEnable,dbPersonInfo_autoAnswerCallBack];
    
    if (![self execSql:sqlCreatePersonInfoTable])
    {
        NSLog(@"创建个人信息表失败");
        return NO;
    }
    return YES;
}

//个人信息表插入信息
- (BOOL)InsertToPersonInfoTableWithUserId:(NSString *)userId userPassword:(NSString*)upass nickName:(NSString*)nickName localAvatarImgUrl:(NSString*)localAvatarImgUrl netAvatarImgUrl:(NSString *)netAvatarImgUrl sign:(NSString*)sign email:(NSString*)email remainMoney:(NSString*)remainMoney earnMoney:(NSString*)earnMoney skinImgUrl:(NSString*)skinImgUrl displayed:(NSString *)displayed wifiCallType:(NSString*)wifiCallType otherCallType:(NSString*)otherCallType optNORCallType:(NSString*)optNORCallType keytoneEnable:(NSString*)keytoneEnable autoAnswerCallBack:(NSString*)autoAnswerCallBack
{
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dbPersonInfoTable,dbPersonInfo_userId,dbPersonInfo_password,dbPersonInfo_nickName,dbPersonInfo_localAvatarImgUrl,dbPersonInfo_netAvatarImgUrl,dbPersonInfo_sign,dbPersonInfo_email,dbPersonInfo_remainMoney,dbPersonInfo_earnMoney,dbPersonInfo_skinImgUrl,dbPersonInfo_displayed,dbPersonInfo_wifiCallType,dbPersonInfo_otherCallType,dbPersonInfo_optNORCallType,dbPersonInfo_keytoneEnable,dbPersonInfo_autoAnswerCallBack,userId,upass,nickName,localAvatarImgUrl,netAvatarImgUrl,sign,email,remainMoney,earnMoney,skinImgUrl,displayed,wifiCallType,otherCallType,optNORCallType,keytoneEnable,autoAnswerCallBack];
    
    NSLog(@"+++++++++++>>>>>>>>>>%@",sqlInsert);
    if ([self execSql:sqlInsert])
    {
        NSLog(@"PersonInfo数据插入成功");
        return YES;
    }
    else
    {
        NSLog(@"PersonInfo数据插入失败");
    }
    return NO;
}

//查询符合条件的个人信息
- (BOOL)selectDataFromPensonTableWithField:(NSString*)Field isEqualtoValue:(NSString*)Value
{
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ='%@'",dbPersonInfoTable,Field,Value];
    
    sqlite3_stmt * statement;
    @try {
        
        NSLog(@"sqlQuery:%@",sqlQuery);
        if (sqlite3_prepare_v2(CDB, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *userId_c = (char*)sqlite3_column_text(statement, 1);
                char *userPassword_c = (char*)sqlite3_column_text(statement, 2);
                char *nickName_c =(char*)sqlite3_column_text(statement, 3);
                char *localAvatarImgUrl_c = (char*)sqlite3_column_text(statement, 4);
                char *netAvatarImgUrl_c = (char*)sqlite3_column_text(statement, 5);
                char *sign_c =(char*)sqlite3_column_text(statement, 6);
                char *email_c =(char*)sqlite3_column_text(statement, 7);
                char *remainMoney_c = (char*)sqlite3_column_text(statement, 8);
                char *earnMoney_c =(char*)sqlite3_column_text(statement, 9);
                char *skinImgUrl_c = (char*)sqlite3_column_text(statement, 10);
                char *displayed_c = (char*)sqlite3_column_text(statement, 11);
                char *wifiCallType_c = (char*)sqlite3_column_text(statement, 12);
                char *otherCallType_c = (char*)sqlite3_column_text(statement, 13);
                char *optNORCallType_c = (char*)sqlite3_column_text(statement, 14);
                char *keytoneEnable_c = (char*)sqlite3_column_text(statement, 15);
                char *autoAnswerCallBack_c = (char*)sqlite3_column_text(statement, 16);
                
                
                NSString *userId = [[NSString alloc]initWithUTF8String:userId_c];
                NSString *userPassword = [[NSString alloc]initWithUTF8String:userPassword_c];
                NSString *nickName = [[NSString alloc]initWithUTF8String:nickName_c];
                NSString *localAvatarImgUrl = [[NSString alloc]initWithUTF8String:localAvatarImgUrl_c];
                NSString *netAvatarImgUrl = [[NSString alloc]initWithUTF8String:netAvatarImgUrl_c];
                NSString *sign = [[NSString alloc]initWithUTF8String:sign_c];
                NSString *email = [[NSString alloc]initWithUTF8String:email_c];
                NSString *remainMoney = [[NSString alloc]initWithUTF8String:remainMoney_c];
                NSString *earnMoney = [[NSString alloc]initWithUTF8String:earnMoney_c];
                NSString *skinImgUrl = [[NSString alloc]initWithUTF8String:skinImgUrl_c];
                NSString *displayed = [[NSString alloc]initWithUTF8String:displayed_c];
                NSString *wifiCallType = [[NSString alloc]initWithUTF8String:wifiCallType_c];
                NSString *otherCallType = [[NSString alloc]initWithUTF8String:otherCallType_c];
                NSString *optNORCallType = [[NSString alloc]initWithUTF8String:optNORCallType_c];
                NSString *keytoneEnable =  [[NSString alloc]initWithUTF8String:keytoneEnable_c];
                NSString *autoAnswerCallBack = [[NSString alloc]initWithUTF8String:autoAnswerCallBack_c];
                
                
                if (userId.length>0)
                {
                    ProfileEntity *profile = [ProfileEntity shareInstance];
                    profile.uid = userId;
                    profile.upass = userPassword;
                    profile.nickname = nickName;
                    profile.localAvatarImgUrl = localAvatarImgUrl;
                    profile.netAvatarImgUrl = netAvatarImgUrl;
                    profile.sign = sign;
                    profile.email = email;
                    profile.remainMoney = remainMoney;
                    profile.earnMoney = earnMoney;
                    profile.skinImgUrl = skinImgUrl;
                    profile.displayed = displayed;
                    profile.wifiCallType = [wifiCallType integerValue];
                    profile.otherCallType = [otherCallType integerValue];//修改
                    profile.optNORCallType = [optNORCallType integerValue];
                    profile.keytoneEnable = keytoneEnable;//按键声音
                    profile.autoAnswerCallBack = autoAnswerCallBack;
                    
                    return YES;//存在
                }
            }
        }
        else {
            NSAssert1(0,@"Error:%s",sqlite3_errmsg(CDB));
        }
        sqlite3_close(CDB);
    }
    @catch (NSException *exception) {
        NSLog(@"PersonTable 数据库异常:%@",exception);
    }
    @finally {
        NSLog(@"PersonTable数据库操作完成！");
    }
    
    return NO;//不存在
}

/*
 *联系人
 */
//创建联系人表格
- (BOOL)createContactsInfoTable
{
    NSString *sqlCreatePersonInfoTable =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT)",dbContactsInfoTable,dbContactsInfo_name,dbContactsInfo_phoneNum,dbContactsInfo_sign,dbContactsInfo_email,dbContactsInfo_netAvatarImgUrl];
    if (![self execSql:sqlCreatePersonInfoTable])
    {
        NSLog(@"创建联系人信息表失败");
        return NO;
    }
    
    return YES;
}


//个人信息表插入信息
- (BOOL)insertToContactsInfoTableWithName:(NSString *)name phoneNum:(NSString*)phoneNum sign:(NSString *)sign email:(NSString*)email andNetAvatarImgUrl:(NSString *)netAvatarImgUrl
{
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@')",dbContactsInfoTable,dbContactsInfo_name,dbContactsInfo_phoneNum,dbContactsInfo_sign,dbContactsInfo_email,dbContactsInfo_netAvatarImgUrl,name,phoneNum,sign,email,netAvatarImgUrl];

    if ([self execSql:sqlInsert])
    {
//        NSLog(@"ContactsInfo数据插入成功");
        return YES;
    }
    return NO;
}

//获取联系人权限
- (BOOL)getAuthorization{
    
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        __block BOOL isOK;
        
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
            isOK = granted;
            dispatch_semaphore_signal(sema);
        });

        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        if (isOK) {
           
            return YES;
        
        }
    
    }else{
        
        return YES;
    
    }

    return NO;
}

//本地联系人存到数据库
- (void)getContactsData
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        [self allowGetAddressBooks];
    }
    else
    {
        addressBooks = ABAddressBookCreate();
        [self allowGetAddressBooks];
    }
}

- (void)allowGetAddressBooks{
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i<nPeople; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFTypeRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString*)abName;
        NSString *lastNameString = (__bridge NSString*)abLastName;
        
        if ((__bridge id)abFullName != nil)
        {
            nameString = (__bridge NSString*)abFullName;
        }
        else
        {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@",nameString,lastNameString];
            }
        }
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *tel = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [self insertToContactsInfoTableWithName:nameString phoneNum:tel sign:kSignDefault email:kEmailDefault andNetAvatarImgUrl:@"0"];
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(percentOfGetAddressBookDataProcess:)]) {
            
            _percent = (i+1)/(float)nPeople;
            
            [self.delegate percentOfGetAddressBookDataProcess:_percent];
        }
    }
    
    
}

//获取本地数据库中的联系人
- (NSMutableDictionary*)selectDataFromContactsTable
{
    NSString *letter = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableDictionary *contactsDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<letter.length; i++)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [contactsDic setObject:arr forKey:[letter substringWithRange:NSMakeRange(i, 1)]];
    }
    
    /*
    //#客服电话
    NSMutableDictionary *LPhoneDic = [[NSMutableDictionary alloc]init];
    [LPhoneDic setObject:@"客服" forKey:@"name"];
    [LPhoneDic setObject:@"123456" forKey:@"phoneNum"];
    [contactsDic[@"#"] addObject:LPhoneDic];
     */
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",dbContactsInfoTable];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(CDB, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *Id_c = (char*)sqlite3_column_text(statement, 0);
            char *name_c = (char*)sqlite3_column_text(statement, 1);
            char *phoneNum_c =(char*)sqlite3_column_text(statement, 2);
            char *sign_c = (char*)sqlite3_column_text(statement, 3);
            char *email_c = (char*)sqlite3_column_text(statement, 4);
            char *netAvatarImgUrl_c = (char*)sqlite3_column_text(statement, 5);
            
            if(!name_c) name_c = "name";
            if(!phoneNum_c) phoneNum_c = "0";
            if(!sign_c) sign_c = "sign";
            if(!email_c) email_c = "email";
            if(!netAvatarImgUrl_c) netAvatarImgUrl_c = "0";
            
            NSString *Id = [[NSString alloc]initWithUTF8String:Id_c];
            NSString *name = [[NSString alloc]initWithUTF8String:name_c];
            NSString *phoneNum = [[NSString alloc]initWithUTF8String:phoneNum_c];
            NSString *sign = [[NSString alloc]initWithUTF8String:sign_c];
            NSString *email = [[NSString alloc]initWithUTF8String:email_c];
            NSString *netAvatarImgUrl = [[NSString alloc]initWithUTF8String:netAvatarImgUrl_c];
            
            if (!netAvatarImgUrl) netAvatarImgUrl = @"0";
            if (!email) email = kEmailDefault;
            if (!name) name = kNickNameDefault;
            if (!sign) sign = kSignDefault;
            if (!phoneNum) phoneNum = @"0";
            
            
            NSString *sectionIndex =[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:name]];//!获得首字母
            
            if (phoneNum.length>0&&![phoneNum isEqualToString:@"(null)"])
            {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:Id forKey:@"id"];
                [dic setObject:name forKey:@"name"];
                [dic setObject:phoneNum forKey:@"phoneNum"];
                
                [dic setObject:sign forKey:@"sign"];
                [dic setObject:email forKey:@"email"];
                [dic setObject:netAvatarImgUrl forKey:@"netAvatarImgUrl"];
                
                [contactsDic[sectionIndex] addObject:dic];
            }
        }
    }
    sqlite3_close(CDB);

    for (NSString *letter in contactsDic.allKeys)
    {
        if ([contactsDic[letter] count]==0)
        {
            [contactsDic removeObjectForKey:letter];
        }
    }
    return contactsDic;
}


//为搜索功能获取联系人
- (NSMutableDictionary*)selectDataFromContactsTableForSearch
{
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc]init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",dbContactsInfoTable];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(CDB, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *Id_c = (char*)sqlite3_column_text(statement, 0);
            char *name_c = (char*)sqlite3_column_text(statement, 1);
            char *phoneNum_c =(char*)sqlite3_column_text(statement, 2);
            
            NSString *Id = [[NSString alloc]initWithUTF8String:Id_c];
            NSString *name = [[NSString alloc]initWithUTF8String:name_c];
            NSString *phoneNum = [[NSString alloc]initWithUTF8String:phoneNum_c];
            NSString *pinYin =[ChineseToPinyin pinyinFromChiniseString:name];
            
            if (!name) name = kNickNameDefault;
            if (!pinYin) pinYin = @"0";
            if (!phoneNum) phoneNum = @"0";
            
            
            if (phoneNum.length>0&&phoneNum!=NULL)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                [dic setObject:Id forKey:@"id"];
                [dic setObject:name forKey:@"name"];
                [dic setObject:phoneNum forKey:@"phoneNum"];

                
                [contactDic setObject:dic forKey:name];
                [contactDic setObject:dic forKey:phoneNum];
                [contactDic setObject:dic forKey:pinYin];
            }
        }
    }
    sqlite3_close(CDB);
    return contactDic;
}

//获取联系人数组数据
- (NSMutableArray*)selectDataFromContactsTableAsArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",dbContactsInfoTable];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(CDB, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *Id_c = (char*)sqlite3_column_text(statement, 0);
            char *name_c = (char*)sqlite3_column_text(statement, 1);
            char *phoneNum_c =(char*)sqlite3_column_text(statement, 2);
            
            if(!name_c) name_c = "name";
            if(!phoneNum_c) phoneNum_c = "0";
            
            NSString *Id = [[NSString alloc]initWithUTF8String:Id_c];
            NSString *name = [[NSString alloc]initWithUTF8String:name_c];
            NSString *phoneNum = [[NSString alloc]initWithUTF8String:phoneNum_c];
            NSString *pinYin =[ChineseToPinyin pinyinFromChiniseString:name];
            
            if (phoneNum.length>0&&phoneNum!=NULL)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                [dic setObject:Id forKey:@"id"];
                [dic setObject:name forKey:@"name"];
                [dic setObject:phoneNum forKey:@"phoneNum"];
                
                [array addObject:dic];
            }
        }
    }
    sqlite3_close(CDB);
    return array;
    
}

//获取符合条件的联系人信息
- (NSDictionary*)selectDataFromContactsTableWithField:(NSString*)Field EqualToValue:(NSString*)Value
{
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc]init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ='%@'",dbContactsInfoTable,Field,Value];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(CDB, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *Id_c = (char*)sqlite3_column_text(statement, 0);
            char *name_c = (char*)sqlite3_column_text(statement, 1);
            char *phoneNum_c =(char*)sqlite3_column_text(statement, 2);
            
            if(!name_c) name_c = "name";
            if(!phoneNum_c) phoneNum_c = "0";
            
            
            NSString *Id = [[NSString alloc]initWithUTF8String:Id_c];
            NSString *name = [[NSString alloc]initWithUTF8String:name_c];
            NSString *phoneNum = [[NSString alloc]initWithUTF8String:phoneNum_c];
            
            if (!name) name = kNickNameDefault;
            if (!phoneNum) phoneNum = @"0";
            
            if (phoneNum.length>0&&phoneNum!=NULL)
            {
                
                [contactDic setObject:name forKey:@"name"];
                [contactDic setObject:phoneNum forKey:@"phoneNum"];
                
            }
        }
    }
    sqlite3_close(CDB);
    return contactDic;
}


@end
