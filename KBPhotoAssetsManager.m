//
//  KBPhotoAssetsManager.m
//  KBPhotoAssetsManager
//
//  Created by Jing Dai on 3/7/16.
//  Copyright © 2016 daijing. All rights reserved.
//

#import "KBPhotoAssetsManager.h"
#import "KBPhotoAlbum.h"

NSString * const KBPhotoNotAuthorizedErrorDomain = @"KBPhotoNotAuthorizedErrorDomain";

@interface KBPhotoAssetsManager ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation KBPhotoAssetsManager

+ (KBPhotoAssetsManager *)sharedInstance
{
    static KBPhotoAssetsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBPhotoAssetsManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return self;
}

+ (void)fetchAllPhotoAlbums:(void (^)(NSMutableArray *albums, NSError *error))completion
{
    // iOS 8.0
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    __block NSMutableArray *albumsArray = [NSMutableArray new];
                    // smart album
                    __block PHFetchResult *smartAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                                       subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                                                       options:nil];
                    [smartAlbumResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (assetCollection) {
                            __block KBPhotoAlbum *album = [KBPhotoAlbum new];
                            album.localizedAlbumName = assetCollection.localizedTitle;
                            __block PHFetchResult *smartAlbumAssetsResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                                                  options:nil];
                            [smartAlbumAssetsResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (asset) {
                                    [album.assets addObject:asset];
                                }
                                if (idx == smartAlbumAssetsResult.count-1) {
                                    [albumsArray addObject:album];
                                    *stop = YES;
                                }
                            }];
                        }
                        if (idx == smartAlbumResult.count-1) {
                            *stop = YES;
                        }
                    }];
                    
                    PHFetchOptions *options = [PHFetchOptions new];
                    options.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
                    // user albums
                    __block PHFetchResult *albumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                                  subtype:PHAssetCollectionSubtypeAny
                                                                                                  options:options];
                    [albumResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (assetCollection) {
                            __block KBPhotoAlbum *album = [KBPhotoAlbum new];
                            album.localizedAlbumName = assetCollection.localizedTitle;
                            __block PHFetchResult *albumAssetsResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                                                     options:nil];
                            [albumAssetsResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (asset) {
                                    [album.assets addObject:asset];
                                }
                                if (idx == albumAssetsResult.count-1) {
                                    [albumsArray addObject:album];
                                    *stop = YES;
                                }
                            }];
                        }
                        if (idx == albumResult.count-1) {
                            *stop = YES;
                        }
                    }];
                    
                    if (completion) {
                        completion(albumsArray, nil);
                    }
                } else {
                    NSError *error = [NSError errorWithDomain:KBPhotoNotAuthorizedErrorDomain code:700 userInfo:nil];
                    completion(nil, error);
                }
            });
        }];
    } else {
        if ([self sharedInstance].assetsLibrary) {
            __block NSMutableArray *groupsArray = [NSMutableArray new];
            [[self sharedInstance].assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                                               usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                                   if (group) {
                                                                       [groupsArray addObject:group];
                                                                   } else {
                                                                       if (groupsArray.count > 0) {
                                                                           __block NSMutableArray *albumsArray = [NSMutableArray new];
                                                                           ALAssetsFilter *assetsFilter = [ALAssetsFilter allPhotos];
                                                                           for (ALAssetsGroup *group in groupsArray) {
                                                                               __block KBPhotoAlbum *album = [KBPhotoAlbum new];
                                                                               [group setAssetsFilter:assetsFilter];
                                                                               [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                                                                   if (asset) {
                                                                                       album.localizedAlbumName = [asset valueForProperty:ALAssetsGroupPropertyName];
                                                                                       [album.assets addObject:asset];
                                                                                   }
                                                                               }];
                                                                               NSArray *sortedAssets = [album.assets sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                                                                   ALAsset *asset1 = (ALAsset *)obj1;
                                                                                   ALAsset *asset2 = (ALAsset *)obj2;
                                                                                   return [[asset1 valueForProperty:ALAssetPropertyDate] compare:[asset2 valueForProperty:ALAssetPropertyDate]];
                                                                               }];
                                                                               album.assets = [NSMutableArray arrayWithArray:sortedAssets];
                                                                               [albumsArray addObject:album];
                                                                           }
                                                                           completion(albumsArray, nil);
                                                                       }
                                                                   }
                                                               } failureBlock:^(NSError *error) {
                                                                   completion(nil, error);
                                                               }];
        }
    }
}

@end
