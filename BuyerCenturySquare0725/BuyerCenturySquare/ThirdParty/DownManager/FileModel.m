

#import "FileModel.h"


@implementation FileModel
@synthesize fileID;
@synthesize fileName;
@synthesize fileSize;
@synthesize fileType;
@synthesize isFirstReceived;
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
@synthesize MD5,usrname,fileimage;

-(id)init{
    self = [super init];
    
    return self;
}

@end
