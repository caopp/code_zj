//
//  InviteAddressBook.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/5/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "InviteAddressBook.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import "ChineseToPinyin.h"

@implementation InviteAddressBook

-(void)getSortContactDicWithAuthor:(void (^)(NSMutableDictionary *))withAuthor noAuthor:(void (^)())noAuhor{

    self.contactInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];

    //!先获取通讯录的数据
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            //得到通讯录数组
            CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
            for(int i = 0; i < CFArrayGetCount(results); i++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                //读取firstname
                NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                //读取lastname
                NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                //拼接成全名
                NSString *fullName;
                if(lastname != nil&&personName != nil)
                {
                    fullName=[lastname stringByAppendingFormat:@"%@",personName];
                }
                else if(lastname != nil && personName ==nil)
                {
                    fullName = lastname;
                }else if (lastname ==nil && personName != nil){
                    fullName = personName;
                }else {
                    fullName = @"";
                }
                
                //读取电话多值
                ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                NSString * personPhoneS;
                NSString * personPhone;
                
                for (int k = 0; k<ABMultiValueGetCount(phone); k++)
                {
                    //获取电话
                    personPhoneS = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                    //获取該电话 下的电话值
                    personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                    personPhone=[personPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    personPhone=[personPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
                    personPhone=[personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    personPhone=[personPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                }
                
                
                //组合通讯录得到的该数据为字典
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setValue:personPhone forKey:@"phoneNum"];
                [dic setValue:fullName forKey:@"name"];

                
                NSString *firstCharacter =[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:fullName]];//!获得首字母
                
                //!在字典里面添加 这个首字母为key的数组
                if ([[self.contactInfoDic allKeys] containsObject:firstCharacter]) {
                    
                    NSMutableArray * contactArray = self.contactInfoDic[firstCharacter];
                    [contactArray addObject:dic];
                    
                    [self.contactInfoDic setObject:contactArray forKey:firstCharacter];

                    
                }else{
                    
                    NSMutableArray * contactArray = [NSMutableArray arrayWithCapacity:0];
                    
                    [contactArray addObject:dic];
                
                    [self.contactInfoDic setObject:contactArray forKey:firstCharacter];
                
                }
                
            }
            
            return withAuthor(self.contactInfoDic);
            
        });
        
    }else {//!无权限读取通讯录
        
        return noAuhor();
    
    }
    
    
    

}

//获取联系人权限
- (BOOL)getAuthorization{
    
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);

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



@end
