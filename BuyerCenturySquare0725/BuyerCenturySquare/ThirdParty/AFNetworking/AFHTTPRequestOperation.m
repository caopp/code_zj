// AFHTTPRequestOperation.m
//
// Copyright (c) 2013-2014 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPRequestOperation.h"
#import "AnotherPlaceLoginAlertView.h"//!异地登录提示
#import "TokenLoseEfficacy.h"//!token失效的时候显示 登录界面
#import "AppDelegate.h"
#import "ChatManager.h"
#import "LoginDTO.h"
#import "DownloadLogControl.h"
#import "UnavailableWebView.h"
#import "CityPropValueDefault.h"
#import "NSString+Hashing.h"
static dispatch_queue_t http_request_operation_processing_queue() {
    static dispatch_queue_t af_http_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.http-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });

    return af_http_request_operation_processing_queue;
}

static dispatch_group_t http_request_operation_completion_group() {
    static dispatch_group_t af_http_request_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_completion_group = dispatch_group_create();
    });

    return af_http_request_operation_completion_group;
}

#pragma mark -

@interface AFURLConnectionOperation ()
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@end

@interface AFHTTPRequestOperation ()
@property (readwrite, nonatomic, strong) NSHTTPURLResponse *response;
@property (readwrite, nonatomic, strong) id responseObject;
@property (readwrite, nonatomic, strong) NSError *responseSerializationError;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@property(nonatomic,strong)UnavailableWebView *unavailable ;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation AFHTTPRequestOperation
@dynamic lock;

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }

    self.responseSerializer = [AFHTTPResponseSerializer serializer];

    return self;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    [self.lock lock];
    _responseSerializer = responseSerializer;
    self.responseObject = nil;
    self.responseSerializationError = nil;
    [self.lock unlock];
}

- (id)responseObject {
    [self.lock lock];
    if (!_responseObject && [self isFinished] && !self.error) {
        NSError *error = nil;
        
        
        self.responseObject = [self.responseSerializer responseObjectForResponse:self.response data:self.responseData error:&error];
        
//        if ([self.responseObject isKindOfClass:[NSDictionary class]]) {
//            
//            
//        }
        
        
        
        if (error) {
            self.responseSerializationError = error;
        }
    }
    [self.lock unlock];

    return _responseObject;
}

- (NSError *)error {
    if (_responseSerializationError) {
        return _responseSerializationError;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    self.completionBlock = ^{
        if (self.completionGroup) {
            dispatch_group_enter(self.completionGroup);
        }

        dispatch_async(http_request_operation_processing_queue(), ^{
            if (self.error) {
                if (failure) {
                    dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                id responseObject = self.responseObject;
              
               
                if (self.error) {
                    
                    if (failure) {
                        AppDelegate * delegate = [AppDelegate currentAppDelegate];
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            if ([self.responseString hasPrefix:@"<!DOCTYPE html>"]&&!delegate._unavailableWeb) {
                                NSString *strResponse = self.responseString;
                                [self showWebAlertView:strResponse];
                                
                                return ;
                            }
                            failure(self, self.error);
                        });
                    }
                } else {
                    
                    if (success) {
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            
                            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

                          
                            if ([dic[@"code"] isEqualToString:@"004"])
                            {
                                 [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                                 [[ChatManager shareInstance] disconnectToServer];
                                //!提示异地登录
                                [self showLoginAlertView:dic[@"errorMessage"]];
                                
                                return ;
                                
                            }else if([dic[@"code"] isEqualToString:@"128"]){
                                
                                [self verNewVersion];
                            
                            }else{
                                
                                if ([[ChatManager shareInstance] retunisXmppConnected]) {
                                    
                                }else{
                                    NSString *pwd = [MyUserDefault defaultLoadAppSetting_loginPassword];
                                    
                                    if (pwd) {
                                        [ChatManager shareInstance].xmppPassWord = [[pwd MD5Hash] lowercaseString];

                                    }

                                     [[ChatManager shareInstance] connectToServer:[ChatManager shareInstance].xmppUserName passWord:[ChatManager shareInstance].xmppPassWord];
                                }
                                success(self, responseObject);
                                
                                
                            }
                            
                        
                        });
                    }
                    
                }
            }
            if (self.completionGroup) {
                dispatch_group_leave(self.completionGroup);
            }
        });
    };
#pragma clang diagnostic pop
}

#pragma mark 显示  服务器正在维护
-(void)showWebAlertView:(NSString *)msg{
    AppDelegate * delegate = [AppDelegate currentAppDelegate];

    if (!_unavailable&&!delegate._unavailableWeb) {
        delegate._unavailableWeb = YES;
        _unavailable = [[UnavailableWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(verifyServer) userInfo:nil repeats:YES];
        _unavailable.htmlStr = msg;
        [delegate.window addSubview:_unavailable];
        
    }
    
    [delegate.window endEditing:YES];
    
}
#pragma mark 显示异地登录的提示view
-(void)showLoginAlertView:(NSString *)msg{

    
    //!暂停所有下载
    [[DownloadLogControl sharedInstance] suspendAllDownLoad];
    

    [LoginDTO sharedInstance].tokenId = nil;

    
    AnotherPlaceLoginAlertView * anotherPlaceLoginView = [[[NSBundle mainBundle]loadNibNamed:@"AnotherPlaceLoginAlertView" owner:self options:nil]lastObject];
    anotherPlaceLoginView.descriptionL.text = msg;
    anotherPlaceLoginView.reloginBtnBlock = ^(){
        
        // !显示登录界面
        TokenLoseEfficacy * tokenLost = [[TokenLoseEfficacy alloc]init];
        [tokenLost showLoginVC];
        
        
    };
    anotherPlaceLoginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    AppDelegate * delegate = [AppDelegate currentAppDelegate];
    
    
    for (UIView * subViews in delegate.window.subviews) {
        
        if ([subViews isKindOfClass:[AnotherPlaceLoginAlertView class]]) {
            [subViews removeFromSuperview];
        }
        
    }
    
    [delegate.window addSubview:anotherPlaceLoginView];
    
   
    
    
}

/*
 *验证  是否强制更新
 */


-(void)verNewVersion{
    NSString *userType = @"2";
    NSString *systemType = @"1";
    
    [HttpManager sendHttpRequestForGetAppVersion:userType systemType:systemType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                        
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSString *downUrl = [[dic objectForKey:@"data"] objectForKey:@"downUrl"];
                NSString *newVersion = [[dic objectForKey:@"data"] objectForKey:@"version"];
                NSString *enforceFlag = [[dic objectForKey:@"data"] objectForKey:@"enforceFlag"];

                [self verVersion:newVersion withUrl:downUrl withEnforceFlag:enforceFlag];
            }
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];

}
-(BOOL)verVersion:(NSString *)strVersion withUrl:(NSString *)downUrl withEnforceFlag:(NSString *)enforceFlag{
    
    NSString *strAlert;
    if (enforceFlag&&[enforceFlag isEqualToString:@"2"]) {
        strAlert = @"因系统更新，故当前版本不能使用，请耐心等待新版本的到来";
    }else if(enforceFlag&&[enforceFlag isEqualToString:@"0"]){
        return NO;
    }else{
        strAlert =[NSString stringWithFormat:@"叮咚管家有新的%@版本啦!\n快去更新吧，不然很多功能使用不了哦！",strVersion];
    }
   
    __weak AnotherPlaceLoginAlertView * anotherPlaceLoginView = [[[NSBundle mainBundle]loadNibNamed:@"AnotherPlaceLoginAlertView" owner:self options:nil]lastObject];
    anotherPlaceLoginView.descriptionL.text = strAlert;
    [anotherPlaceLoginView.showBtn setTitle:@"知道啦" forState:UIControlStateNormal];
    anotherPlaceLoginView.reloginBtnBlock = ^(){
        
        if (enforceFlag&&[enforceFlag isEqualToString:@"2"]) {
            [self exitApplication];
        }else{
            [anotherPlaceLoginView removeFromSuperview];
            NSString *str = [downUrl stringByReplacingOccurrencesOfString:@"https" withString:@"itms"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
        
    };
    anotherPlaceLoginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    AppDelegate * delegate = [AppDelegate currentAppDelegate];
    
    for (UIView * subViews in delegate.window.subviews) {
        
        if ([subViews isKindOfClass:[AnotherPlaceLoginAlertView class]]) {
            
            [subViews removeFromSuperview];
            
        }
        
    }
    
    [delegate.window addSubview:anotherPlaceLoginView];
    return  YES;
}



#pragma mark - AFURLRequestOperation

- (void)pause {
    [super pause];

    u_int64_t offset = 0;
    if ([self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey]) {
        offset = [(NSNumber *)[self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
    } else {
        offset = [(NSData *)[self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey] length];
    }

    NSMutableURLRequest *mutableURLRequest = [self.request mutableCopy];
    if ([self.response respondsToSelector:@selector(allHeaderFields)] && [[self.response allHeaderFields] valueForKey:@"ETag"]) {
        [mutableURLRequest setValue:[[self.response allHeaderFields] valueForKey:@"ETag"] forHTTPHeaderField:@"If-Range"];
    }
    [mutableURLRequest setValue:[NSString stringWithFormat:@"bytes=%llu-", offset] forHTTPHeaderField:@"Range"];
    self.request = mutableURLRequest;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPRequestOperation *operation = [super copyWithZone:zone];

    operation.responseSerializer = [self.responseSerializer copyWithZone:zone];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;

    return operation;
}
-(void)verifyServer{
    NSString *userType = @"2";
    NSString *systemType = @"1";
    
    [HttpManager sendHttpRequestForGetAppVersion:userType systemType:systemType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_unavailable removeFromSuperview];
        _unavailable = nil;
        AppDelegate * delegate = [AppDelegate currentAppDelegate];

        delegate._unavailableWeb = NO;
        [_timer invalidate];
        _timer = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)exitApplication

{
    AppDelegate *app =(AppDelegate *) [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
@end
