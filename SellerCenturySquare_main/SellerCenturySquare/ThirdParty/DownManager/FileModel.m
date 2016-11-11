

#import "FileModel.h"


@implementation FileModel
@synthesize fileID;
@synthesize fileName;
@synthesize fileSize;
@synthesize fileType;

@synthesize fileReceivedData;
@synthesize fileReceivedSize;
@synthesize fileURL;
@synthesize targetPath;
@synthesize tempPath;
@synthesize isDownloading;
@synthesize willDownloading;
@synthesize error;
@synthesize time;
@synthesize isP2P;
@synthesize post;
@synthesize PostPointer,postUrl,fileUploadSize;
@synthesize MD5,usrname,fileimage,imageURL;

-(id)init{
    self = [super init];
    
    return self;
}
-(void)dealloc{
    [fileID release];
    self.fileID = nil;
    
    [fileName release];
    self.fileName = nil;
    
    [fileSize release];
    self.fileSize = nil;
    
    [fileReceivedData release];
    self.fileReceivedData = nil;
    
    [fileURL release];
    self.fileURL = nil;
    
    
    [time release];
    self.time = nil;
    
    [targetPath release];
    self.targetPath = nil;
    
    [tempPath release];
    self.tempPath = nil;
    
    [fileType release];
    self.fileType = nil;
    
    [postUrl release];
    self.postUrl = nil;
    
    [fileUploadSize release];
    self.fileUploadSize = nil;
    
    [usrname release];
    self.usrname = nil;
    
    [MD5 release];
    self.MD5 = nil;
    
    [fileimage release];
    self.fileimage = nil;
    
    [imageURL release];
    self.imageURL = nil;
    
    [super dealloc];
}

- (NSString *)getReceivedContentDataLenght{

    return nil;
}
@end
