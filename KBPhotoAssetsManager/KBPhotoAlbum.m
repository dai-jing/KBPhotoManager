//
//  KBPhotoAlbum.m
//  KBPhotoAssetsManager
//
//  Created by Jing Dai on 3/9/16.
//  Copyright © 2016 daijing. All rights reserved.
//

#import "KBPhotoAlbum.h"

@implementation KBPhotoAlbum

- (id)init
{
    if (self = [super init]) {
        self.localizedAlbumName = @"";
        self.assets = [NSMutableArray new];
    }
    
    return self;
}

@end
