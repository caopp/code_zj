//
//  CSPFillApplicationViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

@import AssetsLibrary;

#import "CSPFillApplicationViewController.h"
#import "CustomButton.h"
#import "CustomTextField.h"

#import "HZAreaPickerView.h"
#import "CSPUtils.h"

#define kDataClassLocation NSLocalizedString(@"LOCATION_SERVICE", @"")
#define kDataClassCalendars NSLocalizedString(@"CALENDARS_SERVICE", @"")
#define kDataClassContacts NSLocalizedString(@"CONTACTS_SERVICE", @"")
#define kDataClassPhotos NSLocalizedString(@"PHOTOS_SERVICE", @"")
#define kDataClassReminders NSLocalizedString(@"REMINDERS_SERVICE", @"")
#define kDataClassMicrophone NSLocalizedString(@"MICROPHONE_SERVICE", @"")
#define kDataClassMotion NSLocalizedString(@"MOTION_SERVICE", @"")
#define kDataClassBluetooth NSLocalizedString(@"BLUETOOTH_SERVICE", @"")
#define kDataClassFacebook NSLocalizedString(@"FACEBOOK_SERVICE", @"")
#define kDataClassTwitter NSLocalizedString(@"TWITTER_SERVICE", @"")
#define kDataClassSinaWeibo NSLocalizedString(@"SINA_WEIBO_SERVICE", @"")
#define kDataClassTencentWeibo NSLocalizedString(@"TENCENT_WEIBO_SERVICE", @"")
#define kDataClassAdvertising NSLocalizedString(@"ADVERTISING_SERVICE", @"")

typedef NS_ENUM(NSInteger, DataClass)  {
    Location,
    Calendars,
    Contacts,
    Photos,
    Reminders,
    Microphone,
    Motion,
    Bluetooth,
    Facebook,
    Twitter,
    SinaWeibo,
    TencentWeibo,
    Advertising
};

typedef NS_ENUM(NSInteger, UploadImageStyle) {
    UploadImageStyleNone,
    UploadImageStyleIdCard,
    UploadImageStyleBusinessLicense,
};

@interface CSPFillApplicationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate, HZAreaPickerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl* sexSegmentedControl;
@property (weak, nonatomic) IBOutlet CustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *cityTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *detailAddrTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *fixedLineTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *idCardTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *businessLicenseTextField;
@property (weak, nonatomic) IBOutlet CustomButton *uploadIdCardButton;
@property (weak, nonatomic) IBOutlet CustomButton *uploadBusinessLicenseButton;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *businessLicenseImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadIdCardImageButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadBusinessLicenseImageButtonConstraint;

@property (nonatomic, strong)UIImagePickerController* imagePickerController;

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, assign) UploadImageStyle uploadImageStyle;

@property (nonatomic, strong) NSString* idCardImageURL;
@property (nonatomic, strong) NSString* businessLicenseImageURL;

@property (nonatomic,strong) HZAreaPickerView* locatePicker;

@property (nonatomic,strong) HZLocation* location;

@property (nonatomic, assign)BOOL keyboardShown;

@end

@implementation CSPFillApplicationViewController

static const NSInteger kButtonNormalConstraint = 0.0f;
static const NSInteger kButtonWithImageConstraint = -50.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请资料";

    [self registerForKeyboardNotifications];

    self.idCardImageView.layer.cornerRadius = 3;
    self.idCardImageView.layer.masksToBounds = YES;

    self.businessLicenseImageView.layer.cornerRadius = 3;
    self.businessLicenseImageView.layer.masksToBounds = YES;

    self.uploadBusinessLicenseImageButtonConstraint.constant = kButtonNormalConstraint;
    self.uploadIdCardImageButtonConstraint.constant = kButtonNormalConstraint;
    self.uploadImageStyle = UploadImageStyleNone;

    self.descriptionTextView.text = @"好";

    self.cityTextField.delegate = self;

    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.idCardTextField.keyboardType = UIKeyboardTypeDefault;
    self.businessLicenseTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.fixedLineTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    [self addCustombackButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 580);
}


- (IBAction)uploadIdCardImageButtonClicked:(id)sender {
    self.uploadImageStyle = UploadImageStyleIdCard;

    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"获取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)uploadBusinessLicenseImageButtonClicked:(id)sender {
    self.uploadImageStyle = UploadImageStyleBusinessLicense;

    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"获取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}

- (UIImagePickerController*)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
    }

    return _imagePickerController;
}

#pragma mark -
#pragma mark


- (BOOL)checkPhotosAuthorizationStatus {
    /*
     We can ask the asset library ahead of time what the authorization status is for our bundle and take the appropriate action.
     */
    if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
//        [self requestPhotosAccess:YES];
        return YES;
    }
    else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
        [self alertViewWithDataClass:Photos status:NSLocalizedString(@"RESTRICTED", @"")];
    }
    else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        [self alertViewWithDataClass:Photos status:NSLocalizedString(@"DENIED", @"")];
    }
    else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
//        [self alertViewWithDataClass:Photos status:NSLocalizedString(@"GRANTED", @"")];

        return YES;
    }

    return NO;
}

- (void)showImagePickerPreferType:(UIImagePickerControllerSourceType)type {
    /*
     Consent alerts can be triggered either by using UIImagePickerController or ALAssetLibrary.
     */
    if(YES) {
        /*
         Upon presenting the picker, consent will be required from the user if the user previously denied access to the asset library, an "access denied" lock screen will be presented to the user to remind them of this choice.
         */
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:type]) {
            sourceType = type;
        }

        self.imagePickerController.sourceType = sourceType;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    if (self.uploadImageStyle == UploadImageStyleIdCard) {
        self.uploadIdCardImageButtonConstraint.constant = kButtonWithImageConstraint;
        self.idCardImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];


        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:@"1" orderCode:@"" goodsNo:@"" file:UIImageJPEGRepresentation(self.idCardImageView.image, 1.0) success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                NSLog(@"success to upload id card image");
                self.idCardImageURL = dic[@"data"];
                [self.view makeToast:@"上传身份证照片成功" duration:2.0f position:@"center"];
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"上传身份证照片失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        }];

    } else if (self.uploadImageStyle == UploadImageStyleBusinessLicense) {
        self.uploadBusinessLicenseImageButtonConstraint.constant = kButtonWithImageConstraint;
        self.businessLicenseImageView.image =  [info objectForKey:UIImagePickerControllerOriginalImage];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:@"2" orderCode:@"" goodsNo:@"" file:UIImageJPEGRepresentation(self.businessLicenseImageView.image, 1.0) success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                NSLog(@"success to upload business licence image");
                self.businessLicenseImageURL = dic[@"data"];
                [self.view makeToast:@"上传营业执照成功" duration:2.0f position:@"center"];
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"上传营业执照失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            }

           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        }];
    }


    self.uploadImageStyle = UploadImageStyleNone;

    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    self.uploadImageStyle = UploadImageStyleNone;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

- (void)alertViewWithDataClass:(DataClass)class status:(NSString *)status {
    NSString *formatString = NSLocalizedString(@"Access to %@ is %@.", @"");
    NSString *message = [NSString stringWithFormat:formatString, @"PHOTOS_SERVICE", status];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REQUEST_STATUS", @"") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"相册"]) {
        if ([self checkPhotosAuthorizationStatus]) {
            [self showImagePickerPreferType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"拍照"]) {
        if ([self checkPhotosAuthorizationStatus]) {
            [self showImagePickerPreferType:UIImagePickerControllerSourceTypeCamera];
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    self.uploadImageStyle = UploadImageStyleNone;
}

- (IBAction)commitButtonClicked:(id)sender {

    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"申请资料提交后不能修改" message:@"是否提交申请" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    [alterView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"提交"]) {
        [self prepareForCommitApply];
    }
}

- (IBAction)commitButtonItemClicked:(id)sender {

    if ([self checkInputValues]) {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"申请资料提交后不能修改" message:@"是否提交申请" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
        [alterView show];
    }
}

- (void)prepareForCommitApply {
    ApplyInfoDTO* applyInfoDTO = [[ApplyInfoDTO alloc]init];
    applyInfoDTO.memberName = self.nameTextField.text;
    applyInfoDTO.mobilePhone = self.phoneNumTextField.text;
    applyInfoDTO.provinceNo = self.location.stateId;
    applyInfoDTO.cityNo = self.location.cityId;
    applyInfoDTO.countyNo = self.location.districtId;
    applyInfoDTO.detailAddress = self.detailAddrTextField.text;
    applyInfoDTO.sex = self.sexSegmentedControl.selectedSegmentIndex == 0 ? @"1" : @"2";
    applyInfoDTO.identityNo = self.idCardTextField.text;
    applyInfoDTO.joinType = @"2";
    applyInfoDTO.telephone = self.fixedLineTextField.text;
    applyInfoDTO.businessLicenseNo = self.businessLicenseTextField.text;
    applyInfoDTO.businessDesc = self.descriptionTextView.text;
    applyInfoDTO.identityPicUrl = self.idCardImageURL;
    applyInfoDTO.businessLicenseUrl = self.businessLicenseImageURL;

    [HttpManager sendHttpRequestForaddApplyInfoWithApplyInfo:applyInfoDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self performSegueWithIdentifier:@"toApplyInfo" sender:self];
        } else if ([[dic objectForKey:@"code"]isEqualToString:@"001"]) {
            [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"上传补充申请资料失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
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
    [self.detailAddrTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    [self.businessLicenseTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)verifyName {
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
    if (self.phoneNumTextField.text.length == 0) {
        [self.view makeToast:@"手机号码不能为空" duration:2.0f position:@"center"];

        return NO;
    }

    if ([CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        return YES;
    }

    [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)verifyCity {
    if (self.location != nil) {
        return YES;
    }

    [self.view makeToast:@"省市区不能为空" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)verifyDetailAddress {
    if (self.detailAddrTextField.text.length == 0) {
        [self.view makeToast:@"详细地址不能为空" duration:2.0f position:@"center"];

        return NO;
    }

    if ([CSPUtils checkDetailAddressLength:self.detailAddrTextField.text]) {
        return YES;
    }

    [self.view makeToast:@"详细地址长度必须为5~60字" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)verifyFixedLine {

    if (self.fixedLineTextField.text.length == 0) {
        [self.view makeToast:@"固定电话号码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if ([CSPUtils checkFixedLineNumber:self.fixedLineTextField.text]) {
        return YES;
    }

    [self.view makeToast:@"固定电话号码格式错误" duration:2.0f position:@"center"];

    return NO;
//    return YES;
}

- (BOOL)verifyIdCardNumber {
    if ([CSPUtils checkUserIdCard:self.idCardTextField.text]) {
        return YES;
    }

    [self.view makeToast:@"身份证号码格式错误" duration:2.0f position:@"center"];

    return NO;

//    return YES;
}

- (BOOL)verifyBusinessLicense {
    if (self.businessLicenseTextField.text.length > 6) {
        return YES;
    }

    [self.view makeToast:@"营业执照号码格式错误" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)verifyIdCardImage {
    if (self.idCardImageURL) {
        return YES;
    }

    [self.view makeToast:@"身份证照不能为空" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)verifyBusinessLicenseImage {
    if (self.businessLicenseImageURL) {
        return YES;
    }

    [self.view makeToast:@"营业执照不能为空" duration:2.0f position:@"center"];

    return NO;
}

- (BOOL)checkInputValues {
    if (![self verifyName]) {
        return NO;
    }

    if (![self verifyPhoneNumber]) {
        return NO;
    }

    if (![self verifyCity]) {
        return NO;
    }

    if (![self verifyDetailAddress]) {
        return NO;
    }

//    if (![self verifyFixedLine]) {
//        return NO;
//    }

    if (![self verifyIdCardNumber]) {
        return NO;
    }

    if (![self verifyBusinessLicense]) {
        return NO;
    }

    if (![self verifyIdCardImage]) {
        return NO;
    }

    if (![self verifyBusinessLicenseImage]) {
        return NO;
    }

    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.keyboardShown)
        return;

    NSDictionary* info = [aNotification userInfo];

    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    UIEdgeInsets contentInsets = self.scrollView.contentInset;
    contentInsets.bottom = keyboardSize.height;

    self.scrollView.contentInset = contentInsets;
    // Resize the scroll view (which is the root view of the window)
//    CGRect viewFrame = [self.scrollView frame];
//    viewFrame.size.height -= keyboardSize.height;
//    self.scrollView.frame = viewFrame;
//
//    // Scroll the active text field into view.
//    CGRect textFieldRect = [activeField frame];
//    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];

    if ([self.descriptionTextView isFirstResponder]) {
        self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.descriptionTextView.frame) - (SCREEN_HEIGHT - keyboardSize.height));
    }

    self.keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
//    NSDictionary* info = [aNotification userInfo];

    // Get the size of the keyboard.
//    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
//    CGSize keyboardSize = [aValue CGRectValue].size;

    // Reset the height of the scroll view to its original value
    UIEdgeInsets contentInsets = self.scrollView.contentInset;
    contentInsets.bottom = 0;

    self.scrollView.contentInset = contentInsets;
//    CGRect viewFrame = [scrollView frame];
//    viewFrame.size.height += keyboardSize.height;
//    scrollView.frame = viewFrame;

    self.keyboardShown = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
