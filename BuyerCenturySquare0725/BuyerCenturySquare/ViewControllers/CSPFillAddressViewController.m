//
//  CSPSignUpAddressViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPFillAddressViewController.h"
#import "CustomTextField.h"
#import "CSPUtils.h"
#import "ConsigneeAddressDTO.h"
#import "HZAreaPickerView.h"

@interface CSPFillAddressViewController () <HZAreaPickerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet CustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *cityTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *postalCode;


//PopUpView
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic,strong) HZAreaPickerView* locatePicker;

@property (nonatomic,strong) HZLocation* location;

@end

@implementation CSPFillAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写收货地址";
    
    [self showSaveSuccessdTipView:NO];

    [self.navigationItem setHidesBackButton:YES];

    self.cityTextField.delegate = self;

    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.postalCode.keyboardType = UIKeyboardTypeNumberPad;

    [self addCustombackButtonItem];

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

/**
 * NextStep
 */
- (IBAction)nextStepButtonClicked:(id)sender {
    [self showSaveSuccessdTipView:NO];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 * Save button on base scroll view clicked
 */
- (IBAction)saveButtonClicked:(id)sender {
//    [self showSaveSuccessdTipView:YES];
    [self prepareForCommitConsigneeAddress];
}

- (BOOL)verifyUserName {
    DataValidationResult result = [CSPUtils checkDataValidationForUserName:self.nameTextField.text];
    if (result == DataValidationResultEmpty ||
        result == DataValidationResultTooShort) {
        [self.view makeToast:@"姓名不能为空" duration:2.0f position:@"center"];
        return NO;
    } else if (result == DataValidationResultTooLong) {
        [self.view makeToast:@"姓名不得超过10个字" duration:2.0f position:@"center"];
        return NO;
    } else if (result == DataValidationResultIllegal) {
        [self.view makeToast:@"请使用中文或英文输入姓名" duration:2.0f position:@"center"];
        return NO;
    }

    return YES;
}

- (BOOL)verifyPhoneNumber {
    if (self.phoneNumTextField.text.length  == 0) {
        [self.view makeToast:@"手机号码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if (![CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

- (BOOL)verifyCityName {
    if (self.location == nil) {
        [self.view makeToast:@"省市区不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

- (BOOL)verifyDetailAddress {
    if (![CSPUtils checkDetailAddressLength:self.detailAddressTextField.text]) {
        [self.view makeToast:@"详细地址需在5-60字之间" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

- (BOOL)verifyPostalCode {
    if (self.postalCode.text.length == 0) {
        [self.view makeToast:@"邮政编码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if (![CSPUtils checkPostalCode:self.postalCode.text]) {
        [self.view makeToast:@"邮政编码格式错误" duration:2.0f position:@"center"];
        return NO;
    }

    return YES;
}

- (void)prepareForCommitConsigneeAddress {
    if (![self verifyUserName]) {
        return;
    }

    if (![self verifyPhoneNumber]) {
        return;
    }

    if (![self verifyCityName]) {
        return;
    }

    if (![self verifyDetailAddress]) {
        return;
    }

    if (![self verifyPostalCode]) {
        return;
    }

    ConsigneeAddressDTO* consigneeAddressDTO = [[ConsigneeAddressDTO alloc]init];
    consigneeAddressDTO.consigneeName = self.nameTextField.text;
    consigneeAddressDTO.consigneePhone = self.phoneNumTextField.text;
    consigneeAddressDTO.provinceNo = self.location.stateId;
    consigneeAddressDTO.cityNo = self.location.cityId;
    consigneeAddressDTO.countyNo = self.location.districtId;
    consigneeAddressDTO.detailAddress = self.detailAddressTextField.text;
    consigneeAddressDTO.postalCode = self.postalCode.text;
    consigneeAddressDTO.defaultFlag = @"0";

    [HttpManager sendHttpRequestForAddConsignee:consigneeAddressDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self showSaveSuccessdTipView:YES];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"保存收货地址失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

- (void)showSaveSuccessdTipView:(BOOL)show {
    if (show) {
        [self.popUpView setHidden:NO];
        [self.view bringSubviewToFront:self.popUpView];
    } else {
        [self.popUpView setHidden:YES];
        [self.view sendSubviewToBack:self.popUpView];

    }
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.cityTextField]) {
        self.locatePicker = [[HZAreaPickerView alloc] init];
        self.locatePicker.delegate = self;
        textField.inputView = self.locatePicker;

        self.location = self.locatePicker.locate;
        self.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];
    }

    return YES;

}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker {
    self.location = picker.locate;
    self.cityTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //    [self cancelLocatePicker];
    [self.cityTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.detailAddressTextField resignFirstResponder];
}


@end
