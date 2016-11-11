//
//  AddressMessageBook.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/12.
//  Copyright © 2016年 pactera. All rights reserved.
//
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>


#import "AddressMessageBook.h"

@implementation AddressMessageBook

#pragma mark 获取通讯录
//获取通讯录的数据
-(void)getPhoneContracts{
    
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            //得到通讯录数组
            [self copyAddressBook:addressBook];
            
            //将数组拼接成上传给服务器的数据
//            NSString *upStr=[self getUpStr];
            
            //上传给服务器
//            [self getPhoneUsers:upStr];
            
        });
        
    }else {
        
        if (self.blockPer) {
           
            self.blockPer();
        
        }
        

//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有获取通讯录权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            
//            
//        });
    }
    
}
//组合成我们需要的数据
-(void)copyAddressBook:(ABAddressBookRef)addressBook
{
    
    //通讯录数据
    _contractsArray=[NSMutableArray arrayWithCapacity:0];
    
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
        
        
        //把通讯录所有联系人保存到数组
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setValue:personPhone forKey:@"tel"];
        [dic setValue:fullName forKey:@"name"];
        [dic setValue:@"未发送" forKey:@"messageDate"];
        [_contractsArray addObject:dic];
        
        
    }
    
    
    CFRelease(results);
    CFRelease(addressBook);
    
    if (self.blockPhoneName) {
        self.blockPhoneName(_contractsArray);
    }

    
    
    
}


@end
