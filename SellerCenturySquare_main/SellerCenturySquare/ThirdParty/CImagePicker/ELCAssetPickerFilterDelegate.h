//
// ELCAssetPickerFilterDelegate.h

@class ELCAsset;
@class ELCAssetTablePicker;
@class PhotoAlbumViewController;
@protocol ELCAssetPickerFilterDelegate<NSObject>

// respond YES/NO to filter out (not show the asset)
-(BOOL)assetTablePicker:(PhotoAlbumViewController *)picker isAssetFilteredOut:(ELCAsset *)elcAsset;

@end