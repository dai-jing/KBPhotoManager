//
//  KBPhotoAlbum.h
//  KBPhotoAssetsManager
//
//  Created by Jing Dai on 3/9/16.
//  Copyright © 2016 daijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBPhotoAlbum : NSObject

@property (nonatomic, strong) NSString *localizedAlbumName;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic) BOOL newAssetType;    // true if assets contain PHAsset objects, false if assets contain ALAsset objects

@end
