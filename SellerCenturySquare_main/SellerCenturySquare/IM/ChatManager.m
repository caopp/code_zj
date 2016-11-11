//
//  ChatManager.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ChatManager.h"
#import "XMPPFramework.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import "DeviceDBHelper.h"
#import "orderGoodsItemDTO.h"

#import "AnotherPlaceLoginAlertView.h"
#import "TokenLoseEfficacy.h"
#import "AppDelegate.h"
#import "LoginDTO.h"
#import "DownloadLogControl.h"
#import "CSPUtils.h"
// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
static ChatManager *_instance;

@interface ChatManager(){
    
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchiving;
    
    BOOL isXmppConnected;
    BOOL customCertEvaluation;
    
    NSString *password;
}
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@end

@implementation ChatManager
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppMessageArchiving;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (nil == _instance) {
            
            _instance = [[ChatManager allocWithZone:nil] init];
        }
    });
    return _instance;
}

#pragma mark -
#pragma mark connect and disconnect.
//ipv4->ipv6转换
-(NSString *)convertHostToAddress:(NSString *)host {
    
    NSError *err = nil;
    
    NSMutableArray *addresses = [GCDAsyncSocket lookupHost:host port:0 error:&err];
    
    NSLog(@"address%@",addresses);
    
    NSData *address4 = nil;
    NSData *address6 = nil;
    
    for (NSData *address in addresses)
    {
        if (!address4 && [GCDAsyncSocket isIPv4Address:address])
        {
            address4 = address;
        }
        else if (!address6 && [GCDAsyncSocket isIPv6Address:address])
        {
            address6 = address;
        }
    }
    
    NSString *ip;
    
    if (address6) {
        NSLog(@"ipv6%@",[GCDAsyncSocket hostFromAddress:address6]);
        ip = [GCDAsyncSocket hostFromAddress:address6];
    }else {
        NSLog(@"ipv4%@",[GCDAsyncSocket hostFromAddress:address4]);
        ip = [GCDAsyncSocket hostFromAddress:address4];
    }
    
    return ip;
    
}
- (BOOL)connectToServer:(NSString *)userName passWord:(NSString *)passWord{
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    NSString *myJID = userName;
    NSString *myPassword = passWord;
    
    self.xmppUserName = userName;
    self.xmppPassWord = passWord;
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    NSString *host = [self convertHostToAddress:IPAddress];
    
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",myJID,IPAddress]]];
    [xmppStream setHostName:host];
    [xmppStream setHostPort:Port];
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    
    return YES;
}

- (BOOL)disconnectToServer {
    
    [self offline];
    
    [xmppStream disconnect];
    
    return YES;
}

- (void)online{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
}


- (void)offline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    // 
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    //	[xmppStream setHostName:@"talk.google.com"];
    //	[xmppStream setHostPort:5222];	
    
    
    // You may need to alter these settings depending on the server you're connecting to
    customCertEvaluation = YES;
    
    //4.消息模块，这里用单例，不能切换账号登录，否则会出现数据问题。
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
    [xmppMessageArchiving activate:self.xmppStream];

}

- (void)teardown{

    [xmppStream removeDelegate:self];   
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}


/////////////////////////////////////////////////////
#pragma mark Core Data
/////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
    }
    
    if (customCertEvaluation)
    {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // The delegate method should likely have code similar to this,
    // but will presumably perform some extra security code stuff.
    // For example, allowing a specific self-signed certificate that is known to the app.
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    isXmppConnected = YES;
    
    NSError *error = nil;
    
    if (![xmppStream authenticateWithPassword:password error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self online];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // A simple example of inbound message handling.
    
    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                 xmppStream:xmppStream
                                                       managedObjectContext:[self managedObjectContext_roster]];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        
        NSString *bodyType = [[message elementForName:@"bodyType"] stringValue];
        
        if ([bodyType intValue]>5) {
            
        }else{
            [[DeviceDBHelper sharedInstance] addNewMessage:message withIsSender:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveMessage object:message];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewsNotification" object:nil];
        //} else {
            
            // We are not active, so use a local notification instead
//            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//            localNotification.alertAction = @"Ok";
//           // localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//            
//            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        //}
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
  
    [self available:presence.type];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"%ld",error.code);
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (!isXmppConnected)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
    if (error.code == 7) {
         [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//        [[ChatManager shareInstance] disconnectToServer];
//        //!提示异地登录
//        [self showLoginAlertView];
        [self available:@"available"];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    } 
    else 
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}

//基本的文本信息
- (void)SendTextMessage:(NSString *)textMessage toUserID:(NSString *)userID withECSession:(ECSession *)session withMerchantname:(NSString *)name {
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:textMessage];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSString *to = [NSString stringWithFormat:@"%@@%@", userID, IPAddress];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"id" stringValue:[self generateUUID]];

    NSXMLElement *bodyType = [NSXMLElement elementWithName:@"bodyType"];
    NSString *bodyTypeStr = [NSString stringWithFormat:@"0"];
    
    [bodyType setStringValue:bodyTypeStr];
    [message addChild:bodyType];
    
    
    
    if (session != nil) {
        
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:[NSString stringWithFormat:@"%ld", (long)session.sessionType]];
        [message addChild:sessionType];
        
        //添加商家名称
        NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
        [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
        [message addChild:merchantName];
        
        if(session.sessionType == 1) {
            
            //添加商品颜色
            NSXMLElement *goodColor = [NSXMLElement elementWithName:@"goodColor"];
            [goodColor setStringValue:session.goodColor];
            [message addChild:goodColor];
            
            //添加商品价格
            NSXMLElement *goodPrice = [NSXMLElement elementWithName:@"goodPrice"];
            [goodPrice setStringValue:session.goodPrice];
            [message addChild:goodPrice];
            
            //添加商品图片
            NSXMLElement *goodPic = [NSXMLElement elementWithName:@"goodPic"];
            [goodPic setStringValue:session.goodPic];
            [message addChild:goodPic];
            
            //添加商品编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:[[session.goodNo componentsSeparatedByString:@"_"] objectAtIndex:0]];
            [message addChild:goodNo];
        }else {
            
            //添加商品编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:xmppStream.myJID.user];
            [message addChild:goodNo];
        }
        
   
        
    }else {
        
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:@"0"];
        [message addChild:sessionType];
        
        //添加商家名称
        NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
        [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
        [message addChild:merchantName];
        
        //添加商家名称
        NSXMLElement *goodNoName = [NSXMLElement elementWithName:@"goodNo"];
        [goodNoName setStringValue:xmppStream.myJID.user];
        [message addChild:goodNoName];
        
   
    }
    
    //添加商家编号
    NSXMLElement *merchantNo = [NSXMLElement elementWithName:@"merchantNo"];
    [merchantNo setStringValue:[GetMerchantInfoDTO sharedInstance].merchantNo];
    [message addChild:merchantNo];
    //添加采购商编号
    NSXMLElement *memberNo = [NSXMLElement elementWithName:@"memberNo"];
    [memberNo setStringValue:self.memberNo];
    [message addChild:memberNo];
    
    //添加货号
    NSXMLElement *goodsWillNo = [NSXMLElement elementWithName:@"goodsWillNo"];
    [goodsWillNo setStringValue:session.goodsWillNo];
    [message addChild:goodsWillNo];
    //自身昵称
    NSXMLElement *fromName = [NSXMLElement elementWithName:@"fromName"];
    [fromName setStringValue:name];
    [message addChild:fromName];

    //头像
    NSXMLElement *iconUrl = [NSXMLElement elementWithName:@"iconUrl"];
    [iconUrl setStringValue:[GetMerchantInfoDTO sharedInstance].iconUrl];
    [message addChild:iconUrl];
    
    NSXMLElement *messageTime = [NSXMLElement elementWithName:@"messageTime"];
    if (_timesever) {
        [messageTime setStringValue:[CSPUtils getTime:_timesever]];
    }else{
        NSDate* now = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:now];
        [messageTime setStringValue:dateString];
    }
    [message addChild:messageTime];
    
    //!对接平台客服   1:小b - 平台    2：大b-平台
    NSXMLElement *channel = [NSXMLElement elementWithName:@"channel"];
    [channel setStringValue:@"2"];
    [message addChild:channel];

    [message addChild:body];
    [self.xmppStream sendElement:message];
    
    
    [self saveMessage:message];
    
}

//图片信息
- (void)SendPicMessage:(NSString *)picUrl toUserID:(NSString *)userID withECSession:(ECSession *)session withMerchantname:(NSString *)name withLocalUrl:(NSString *)localUrl {

    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:picUrl];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", userID, IPAddress];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"id" stringValue:[self generateUUID]];

    
    NSXMLElement *bodyType = [NSXMLElement elementWithName:@"bodyType"];
    [bodyType setStringValue:@"1"];
    [message addChild:bodyType];
    

    
    if (session != nil) {
        
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:[NSString stringWithFormat:@"%ld", (long)session.sessionType]];
        [message addChild:sessionType];
        
        //添加商家名称
        NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
        [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
        [message addChild:merchantName];
        
        if(session.sessionType == 1) {
            
            //添加商品颜色
            NSXMLElement *goodColor = [NSXMLElement elementWithName:@"goodColor"];
            [goodColor setStringValue:session.goodColor];
            [message addChild:goodColor];
            
            //添加商品价格
            NSXMLElement *goodPrice = [NSXMLElement elementWithName:@"goodPrice"];
            [goodPrice setStringValue:session.goodPrice];
            [message addChild:goodPrice];
            
            //添加商品图片
            NSXMLElement *goodPic = [NSXMLElement elementWithName:@"goodPic"];
            [goodPic setStringValue:session.goodPic];
            [message addChild:goodPic];
            
            //添加商品编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:session.goodNo];
            [message addChild:goodNo];
        }else {
            
            //添加商品编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:xmppStream.myJID.user];
            [message addChild:goodNo];
        }
        
       
    }else {
        
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:@"0"];
        [message addChild:sessionType];
        
        //添加商家名称
        NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
        [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
        [message addChild:merchantName];
        
        //添加商品编号
        NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
        [goodNo setStringValue:xmppStream.myJID.user];
        [message addChild:goodNo];
        
     
    }
    
    //添加商家编号
    NSXMLElement *merchantNo = [NSXMLElement elementWithName:@"merchantNo"];
    [merchantNo setStringValue:[GetMerchantInfoDTO sharedInstance].merchantNo];
    [message addChild:merchantNo];
    //添加采购商编号
    NSXMLElement *memberNo = [NSXMLElement elementWithName:@"memberNo"];
    [memberNo setStringValue:self.memberNo];
    [message addChild:memberNo];
    //添加货号
    NSXMLElement *goodsWillNo = [NSXMLElement elementWithName:@"goodsWillNo"];
    [goodsWillNo setStringValue:session.goodsWillNo];
    [message addChild:goodsWillNo];
    //自身昵称
    NSXMLElement *fromName = [NSXMLElement elementWithName:@"fromName"];
    [fromName setStringValue:name];
    [message addChild:fromName];
    //头像
    NSXMLElement *iconUrl = [NSXMLElement elementWithName:@"iconUrl"];
    [iconUrl setStringValue:[GetMerchantInfoDTO sharedInstance].iconUrl];
    [message addChild:iconUrl];
    
    NSXMLElement *messageTime = [NSXMLElement elementWithName:@"messageTime"];
    if (_timesever) {
        [messageTime setStringValue:[CSPUtils getTime:_timesever]];
    }else{
        NSDate* now = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:now];
        [messageTime setStringValue:dateString];
    }
    [message addChild:messageTime];
    
    //!对接平台客服   1:小b - 平台    2：大b-平台
    NSXMLElement *channel = [NSXMLElement elementWithName:@"channel"];
    [channel setStringValue:@"2"];
    [message addChild:channel];

    
    [message addChild:body];
    [self.xmppStream sendElement:message];
    
    //添加图片网络
    NSXMLElement *url = [NSXMLElement elementWithName:@"Url"];
    [url setStringValue:picUrl];
    [message addChild:url];
    
    //添加本地图片存储地址
    NSXMLElement *picLocalUrl = [NSXMLElement elementWithName:@"picLocalUrl"];
    [picLocalUrl setStringValue:localUrl];
    [message addChild:picLocalUrl];
    
    [self saveMessage:message];
}
//采购单发送
- (void)SendOrderListMessage:(NSDictionary *)dicOrder toUserID:(NSString *)userID  withMerchantname:(NSString *)name{
    
    NSXMLElement * xmlElement = [self packageOrderGoodsInfoWithDic:dicOrder withName:name withType:@"5"  toUserID:userID ];
    
    [self.xmppStream sendElement:xmlElement];
    [self saveMessage:xmlElement];
}
//商品推介，发送cell信息
- (void)SendGoodMessage:(ShopGoodsDTO *)dto toUserID:(NSString *)userID withIMtype:(NSString *)imtype withMerchantname:(NSString *)name withECSession:(ECSession *)session{
    
    [self.xmppStream sendElement:[self packageGoodsInfo:dto toUserID:userID withIMtype:imtype withMerchantname:name withECSession:session]];
    [self saveMessage:[self packageGoodsInfo:dto toUserID:userID withIMtype:imtype withMerchantname:name withECSession:session]];
}

- (NSXMLElement *)packageGoodsInfo:(ShopGoodsDTO *)dto toUserID:(NSString *)userID withIMtype:(NSString *)imtype withMerchantname:(NSString *)name withECSession:(ECSession *)session {
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@""];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", userID, IPAddress];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"id" stringValue:[self generateUUID]];

    NSXMLElement *bodyType = [NSXMLElement elementWithName:@"bodyType"];
    [bodyType setStringValue:@"4"];
    [message addChild:bodyType];
    
    NSXMLElement *messageTime = [NSXMLElement elementWithName:@"messageTime"];
    if (_timesever) {
        [messageTime setStringValue:[CSPUtils getTime:_timesever]];
    }else{
        NSDate* now = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:now];
        [messageTime setStringValue:dateString];
    }
    [message addChild:messageTime];
    NSLog(@"name===%@",name);
    
    
   
    //添加商家名称
    NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
    [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
    [message addChild:merchantName];
    
    if (session != nil) {
        
        if (session.sessionType == 0) {
            //保存用的session编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:dto.goodsNo];
            [message addChild:goodNo];
        }else {
            
            //保存用的session编号
            NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
            [goodNo setStringValue:dto.goodsNo];
            [message addChild:goodNo];
        }
        
        //会话类型
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:[NSString stringWithFormat:@"%ld", (long)session.sessionType]];
        [message addChild:sessionType];
        
       
    }else {
    
        //保存用的session编号
        NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
        [goodNo setStringValue:dto.goodsNo];
        [message addChild:goodNo];
        
        //会话类型
        NSXMLElement *sessionType = [NSXMLElement elementWithName:@"sessionType"];
        [sessionType setStringValue:imtype];
        [message addChild:sessionType];
        
  
    }
    
    
    //添加商品颜色
    NSXMLElement *goodColor = [NSXMLElement elementWithName:@"goodColor"];
    [goodColor setStringValue:dto.goodsColor];
    [message addChild:goodColor];
    
    //添加商品价格
    NSXMLElement *goodPrice = [NSXMLElement elementWithName:@"goodPrice"];
    [goodPrice setStringValue:[dto.price stringValue]];
    [message addChild:goodPrice];
    
    //添加商品图片
    NSXMLElement *goodPic = [NSXMLElement elementWithName:@"goodPic"];
    [goodPic setStringValue:dto.imgUrl];
    [message addChild:goodPic];
    
    //添加商家编号
    NSXMLElement *merchantNo = [NSXMLElement elementWithName:@"merchantNo"];
    [merchantNo setStringValue:[GetMerchantInfoDTO sharedInstance].merchantNo];
    [message addChild:merchantNo];
    
    //添加采购商编号
    NSXMLElement *memberNo = [NSXMLElement elementWithName:@"memberNo"];
    [memberNo setStringValue:self.memberNo];
    [message addChild:memberNo];
    //添加商品货号
    NSXMLElement *goodsWillNo = [NSXMLElement elementWithName:@"goodsWillNo"];
    [goodsWillNo setStringValue:dto.goodsWillNo];
    [message addChild:goodsWillNo];
    
    //头像
    NSXMLElement *iconUrl = [NSXMLElement elementWithName:@"iconUrl"];
    [iconUrl setStringValue:[GetMerchantInfoDTO sharedInstance].iconUrl];
    [message addChild:iconUrl];
    
    //自身昵称
    NSXMLElement *fromName = [NSXMLElement elementWithName:@"fromName"];
    [fromName setStringValue:name];
    [message addChild:fromName];
    
    //查询显示的goodNo
    NSXMLElement *searchGoodNo = [NSXMLElement elementWithName:@"searchGoodNo"];
    [searchGoodNo setStringValue:dto.searchGoodNo];
    [message addChild:searchGoodNo];
    
    [message addChild:body];
    
    return message;
}
//采购单xml

//封装成数组采购单
- (NSXMLElement *)packageOrderGoodsInfoWithDic:(NSDictionary *)dicOrder withName:(NSString *)name withType:(NSString *)type toUserID:(NSString *)userID {
    
    NSArray *arr= [dicOrder objectForKey:@"goodsList"];
    NSString *merchantNameStr =  name;//[GetMerchantInfoDTO sharedInstance].merchantName;//[dicOrder objectForKey:@"merchantName"];
    NSString *merchantNoStr = [dicOrder objectForKey:@"merchantNo"];
    NSString *goodStatus = [dicOrder objectForKey:@"status"];
    NSString *goodQuantity = [dicOrder objectForKey:@"quantity"];
    NSString *goodOrderCode = [dicOrder objectForKey:@"orderCode"];
    NSString *goodType = [dicOrder objectForKey:@"type"];
    NSString *goodAmount =[dicOrder objectForKey:@"originalTotalAmount"];
    NSString *goodNoStr;
    NSString *bodyTypeStr;//2 普通询单  3 样板询单
    NSString *goodPriceStr;
    NSString *goodPicStr;
    NSString *goodNumStr;
    for (NSDictionary  *goodDic in arr) {
        goodNoStr = [self createStrWithP:goodNoStr appendString:[goodDic objectForKey:@"goodsNo"] ];
        
        goodPriceStr = [self createStrWithP:goodPriceStr appendString:[NSString stringWithFormat:@"%@",[goodDic objectForKey:@"price"]]];
        goodPicStr = [self createStrWithP:goodPicStr appendString:[goodDic objectForKey:@"picUrl"]];
        goodNumStr = [self createStrWithP:goodNumStr appendString:[NSString stringWithFormat:@"%@",[goodDic objectForKey:@"quantity"]]];
    }
    
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@""];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", userID, IPAddress];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"id" stringValue:[self generateUUID]];

    NSXMLElement *messageTime = [NSXMLElement elementWithName:@"messageTime"];
    if (_timesever) {
        [messageTime setStringValue:[CSPUtils getTime:_timesever]];
    }else{
        NSDate* now = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* dateString = [fmt stringFromDate:now];
        [messageTime setStringValue:dateString];
    }
    [message addChild:messageTime];
    

    //添加商家名称
    NSXMLElement *merchantName = [NSXMLElement elementWithName:@"merchantName"];
    [merchantName setStringValue:[GetMerchantInfoDTO sharedInstance].merchantName];
    [message addChild:merchantName];
    
    //添加商家编号
    NSXMLElement *merchantNo = [NSXMLElement elementWithName:@"merchantNo"];
    [merchantNo setStringValue:merchantNoStr];
    [message addChild:merchantNo];
    
    //添加采购商编号
    NSXMLElement *memberNo = [NSXMLElement elementWithName:@"memberNo"];
    [memberNo setStringValue:self.memberNo];
    [message addChild:memberNo];
    
    
    NSXMLElement *bodyType = [NSXMLElement elementWithName:@"bodyType"];
    [bodyType setStringValue:type];
    [message addChild:bodyType];
    
    //添加商品编号
    NSXMLElement *goodNo = [NSXMLElement elementWithName:@"goodNo"];
    
    [goodNo setStringValue:goodNoStr];
    [message addChild:goodNo];
    
    //    //添加商品颜色
    //    NSXMLElement *goodColor = [NSXMLElement elementWithName:@"goodColor"];
    //    [goodColor setStringValue:goodColorStr];
    //    [message addChild:goodColor];
    
    //添加商品图片
    NSXMLElement *goodPic = [NSXMLElement elementWithName:@"goodPic"];
    [goodPic setStringValue:goodPicStr];
    [message addChild:goodPic];
    

    
    //自身昵称
    NSXMLElement *fromName = [NSXMLElement elementWithName:@"fromName"];
    [fromName setStringValue:name];
    [message addChild:fromName];
    
    //头像地址
    NSXMLElement *iconUrl = [NSXMLElement elementWithName:@"iconUrl"];
    [iconUrl setStringValue:[GetMerchantInfoDTO sharedInstance].iconUrl];
    [message addChild:iconUrl];
    
  
    //type 期货 现货 status 采购单状态0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收 goodNum 货品 号
    // <goodSku>{"orderState":"货单","orderNo":"12345","orderPrice":"123","orderStatus":"待发货 goodNum='2,4,4,3' 单个商品的数量"
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:goodType forKey:@"orderState"];
    [dic setValue:goodOrderCode forKey:@"orderNo"];
    [dic setValue:goodAmount forKey:@"orderPrice"];
    [dic setValue:goodStatus forKey:@"orderStatus"];
    [dic setValue:goodNumStr forKey:@"goodNum"];
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSXMLElement *goodSku = [NSXMLElement elementWithName:@"goodSku"];
    [goodSku setStringValue: jsonString];
    [message addChild:goodSku];
    
    //添加商品价格
    NSXMLElement *goodPrice = [NSXMLElement elementWithName:@"goodPrice"];
    [goodPrice setStringValue:goodPriceStr];
    [message addChild:goodPrice];
    
    //!对接平台客服   1:小b - 平台    2：大b-平台
    NSXMLElement *channel = [NSXMLElement elementWithName:@"channel"];
    [channel setStringValue:@"2"];
    [message addChild:channel];

    
    [message addChild:body];
    
    
    
    return message;
}
//保存信息
- (void)saveMessage:(NSXMLElement *)message {
    
    [message removeElementForName:@"isSender"];
    
    [message addAttributeWithName:@"from" stringValue:xmppStream.myJID.user];
    
   
   

    NSXMLElement *memberNo = [NSXMLElement elementWithName:@"memberNo"];
    [memberNo setStringValue:_memberNo];
    [message addChild:memberNo];
    
    [[DeviceDBHelper sharedInstance] addNewMessage:[XMPPMessage messageFromElement:message] withIsSender:1];
}


/*
 *判断 是否 被提出
 */

-(void)available:(NSString *)start{
    if ([start  isEqualToString:@"available"]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //获取会员信息
        [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                

                
            }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        } ];
        
    }
}
-(NSString *)createStrWithP:(NSString *)strP appendString:(NSString *)strL{
    
    if (strP&&[strP length]>0) {
        
        strP =  [strP stringByAppendingString:@";"];
        
        strP = [strP stringByAppendingString:strL];
        
    }else{
        
        strP = @"";
        
        strP = strL;
        
        
        
    }
    
    return strP;
    
}

-(void)testGetChatHistory:(NSString *)userID
{
    NSString *to = userID;
    ChatHistory *chatHistory = [[ChatHistory alloc] init];
    chatHistory.from = xmppStream.myJID.user
;
    chatHistory.to= to;
    chatHistory.time  = @"2016-8-24 18:12:12";
    
    if (chatHistory.pageNo == nil) {
        
        chatHistory.pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (chatHistory.pageSize == nil) {
        chatHistory.pageSize = [NSNumber numberWithInteger:20];
    }
    
    [HttpManager sendHttpRequestForGetChatHistory:chatHistory  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];  
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"获取历史聊天信息  返回正常编码");
            
        }else{
            
            NSLog(@"获取历史聊天信息 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testOrderCancel 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}
#pragma mark 显示异地登录的提示view
-(void)showLoginAlertView{
    
    
    //    // !显示登录界面
    //    TokenLoseEfficacy * tokenLost = [[TokenLoseEfficacy alloc]init];
    //    [tokenLost showLoginVC];
    
    //!如果有其他账户登录停止所有下载
    [[DownloadLogControl sharedInstance]suspendAllDownLoad];

    
    [LoginDTO sharedInstance].tokenId = nil;
    
    AnotherPlaceLoginAlertView * anotherPlaceLoginView = [[[NSBundle mainBundle]loadNibNamed:@"AnotherPlaceLoginAlertView" owner:self options:nil]lastObject];
    
    anotherPlaceLoginView.reloginBtnBlock = ^(){
        
        // !显示登录界面
        TokenLoseEfficacy * tokenLost = [[TokenLoseEfficacy alloc]init];
        [tokenLost showLoginVC];
        
    };
    anotherPlaceLoginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT);
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (UIView * subViews in delegate.window.subviews) {
        
        if ([subViews isKindOfClass:[AnotherPlaceLoginAlertView class]]) {
            
            [subViews removeFromSuperview];
            
        }
        
    }
    
    [delegate.window addSubview:anotherPlaceLoginView];
    
    
}
-(BOOL)retunisXmppConnected{
    return  xmppStream.isConnected;;
}
//本地维护时间
-(void)openTime:(long)time{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timesever  =  time;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
-(void)timerStart{
    NSLog(@"1s");
    if (_timesever) {
        _timesever += 1000;
    }
}
-(void)closeTime{
    _timesever = 0;
    [_timer invalidate];
    _timer = nil;
}

-(NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}


// 获取  客服     平台 客服
-(void)getServerAcount:(NSString *)memberNo withName:(NSString *)name withController:(UIViewController *)controller{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    [HttpManager sendHttpRequestForGetCustomerAccountWithMemberNo:memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {//
            NSLog(@"dic = %@",dic);
            NSNumber *time = dic[@"data"][@"time"];
            NSString *account = dic[@"data"][@"account"];
            ConversationWindowViewController *conversationVC;
            conversationVC = [[ConversationWindowViewController alloc]initWithName:name withJID:account  withMemberNo:memberNo];
            conversationVC.timeStart = time;
            [controller.navigationController pushViewController:conversationVC animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:delegate.window animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideHUDForView:delegate.window animated:YES];

    }];
    
}
// 获取订单  询单客服账号
-(void)getServerAcountWithName:(NSString *)name  withMerchanNo:(NSString *)merchanNo withOrderDic:(NSDictionary *)dic withController:(UIViewController *)controller{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    NSString *memberNo = dic[@"memberNo"];
    [HttpManager sendHttpRequestForGetCustomerAccountWithMemberNo:memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"]isEqualToString:@"000"]) {//
            NSLog(@"dic = %@",dict);
            NSNumber *time = dict[@"data"][@"time"];
            NSString *account = dict[@"data"][@"account"];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:name jid:account withMerchanNo:merchanNo withDic:dic];
            conversationVC.timeStart = time;
            [controller.navigationController pushViewController:conversationVC animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:delegate.window animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideHUDForView:delegate.window animated:YES];
        
    }];
    
}
- (void)dealloc
{
    [self teardown];
}
@end
