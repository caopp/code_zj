//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "PhotoAlbumViewController.h"
@interface ELCAlbumPickerController ()
@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, strong)NSMutableArray *arrCellName;
@end

@implementation ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrCellName = [NSMutableArray arrayWithCapacity:0];

    
    //设置显示table的页面线条进行隐藏
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
	//设置title为正在加载
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
 
    //设置取消按钮，因为有导航，就设置导航栏上取消按钮
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
    
    
	[self.navigationItem setRightBarButtonItem:cancelButton];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;

    // Load Albums into assetGroups（进行数据加载，异步进行加载）
    dispatch_async(dispatch_get_main_queue(), ^
    {
        @autoreleasepool {
        
        // Group enumerator Block(进行回调)
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                //进行请求的数组（如果是没有，进行返回）
                if (group == nil) {
                    return;
                }
                
                // added fix for camera albums order（如果有图片，进行处理）
                //设置数组中，每个数据的名字sGroupPropertyName
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                //设置数组中，有图片的个数
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                    
                    [self.assetGroups insertObject:group atIndex:0];
                }
                else {
                    [self.assetGroups addObject:group];
                }

                // Reload albums
                //选择线程，进行重新加载
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            };
            
            // Group Enumerator Failure Block（失败）
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
              
                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                    NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                  
                } else {
                    NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                }

                [self.navigationItem setTitle:nil];
                NSLog(@"A problem occured %@", [error description]);	                                 
            };	
                    
            // Enumerate Albums
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
        
        }
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //将要进入这个页面时候进行处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:ALAssetsLibraryChangedNotification object:nil];
    //重新刷新列表
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    //移除通知（页面将要消失的时候）
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)reloadTableView
{
    //进行列表刷新
	[self.tableView reloadData];
	[self.navigationItem setTitle:NSLocalizedString(@"照片", nil)];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1]];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackTranslucent;
    
    

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
}


//代理方法（对数据进行处理）

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}
- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldDeselectAsset:asset previousCount:previousCount];
}
- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

- (ALAssetsFilter *)assetFilter
{
    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
    {
        return [ALAssetsFilter allAssets];
    }
    else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
    {
        return [ALAssetsFilter allVideos];
    }
    else
    {
        return [ALAssetsFilter allPhotos];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //进行工厂模式
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //获得显示的群组，以及群组的个数
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    
    //进行对象的分解
    [g setAssetsFilter:[self assetFilter]];
    
    //显示群组的个数
    NSInteger gCount = [g numberOfAssets];
    
    //进行列表上的显示
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    
    NSString *cellName = [NSString stringWithFormat:@"%@",[g valueForProperty:ALAssetsGroupPropertyName]];
    
    [_arrCellName addObject:cellName];
    
    
#pragma mark  ---对图片的处理（以及显示）-----
    //对列表上的图片进行处理
    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
    
    //对图片尺寸大小处理
    image = [self resize:image to:CGSizeMake(78, 78)];
    
    
    //把图片添加到cell上面
    [cell.imageView setImage:image];
    
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
    
}

//对接收过来的图片进行处理
- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
       UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -
#pragma mark Table view delegate

//点击每个cell的时候，进行图片列表展示页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //进入图片布局（数据进行传递，个数传递。进行对传过来的图片个数，进行显示处理x）
//    ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc]init];
//    //同样的也是采用的代理方法
//	picker.parent = self;
//    //对传递过来的数组进行接收
//    picker.titlePT = [_arrCellName objectAtIndex:indexPath.row];
//    
//    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//    
//    [picker.assetGroup setAssetsFilter:[self assetFilter]];
//    
//	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
//	
//	[self.navigationController pushViewController:picker animated:YES];
    
    PhotoAlbumViewController *picker = [[PhotoAlbumViewController alloc]init];
    
    picker.parent = self;
    
    picker.titlePT = [_arrCellName objectAtIndex:indexPath.row];
    
    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    
    [picker.assetGroup setAssetsFilter:[self assetFilter]];
    
    picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
    
    [self.navigationController pushViewController:picker animated:YES];
    
}


//设置主列表的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}


//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

