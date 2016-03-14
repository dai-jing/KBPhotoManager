//
//  KBPhotoAssetsManager.h
//  KBPhotoAssetsManager
//
//  Created by Jing Dai on 3/7/16.
//  Copyright © 2016 daijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface KBPhotoAssetsManager : NSObject

extern NSString * const KBPhotoNotAuthorizedErrorDomain;

+ (KBPhotoAssetsManager *)sharedInstance;

+ (void)fetchAllPhotoAlbums:(void(^)(NSMutableArray *albums, NSError *error))completion;

@end
