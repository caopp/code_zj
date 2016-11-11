//
//  FilesDownManage.h
//  Created by yu on 13-1-21.


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CommonHelper.h"
#import "DownloadDelegate.h"
#import "FileModel.h"

#import <AVFoundation/AVAudioPlayer.h>


@interface FilesDownManage : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    
}

@property(nonatomic,retain)id<DownloadDelegate> VCdelegate;//获得下载事件的vc，用在比如多选图片后批量下载的情况，这时需配合 allowNextRequest 协议方法使用
@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;//下载列表delegate

@property(nonatomic,retain)NSString *basepath;
@property(nonatomic,retain)NSString *TargetSubPath;
@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)

/**
 *  filelist  当前任务的列表
 */
@property(nonatomic,retain)NSMutableArray *filelist;
@property(nonatomic,retain)NSMutableArray *targetPathArray;

/**
 *  恢复下载
 */
-(void)resumeRequest:(ASIHTTPRequest *)request;
/**
 *  删除下载
 */
-(void)deleteRequest:(ASIHTTPRequest *)request;
/**
 *  停止下载
 */
-(void)stopRequest:(ASIHTTPRequest *)request;
/**
 *  保存图片
 */
-(void)saveFinishedFile;
/**
 *  删除已完成的文件 ？ 待定
 */
-(void)deleteFinishFile:(FileModel *)selectFile;

/**
 *  新建下载任务
 *
 *  @param url      <#url description#>
 *  @param name     <#name description#>
 *  @param path     <#path description#>
 *  @param image    <#image description#>
 *  @param imageURL <#imageURL description#>
 */
-(void)downFileUrl:(NSString*)url
          filename:(NSString*)name
        filetarget:(NSString *)path
         fileimage:(UIImage *)image
          imageURL:(NSString *)imageURL
         ;

/**
 *  没什么用
 */

+(FilesDownManage *) sharedFilesDownManage;

//1.点击百度或者土豆的下载，进行一次新的队列请求
//2.是否接着开始下载

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;

-(void)startLoad;

-(void)restartAllRquests;

@end


