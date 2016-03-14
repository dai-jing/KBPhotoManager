//
//  ViewController.m
//  KBPhotoAssetsManager
//
//  Created by Jing Dai on 3/7/16.
//  Copyright © 2016 daijing. All rights reserved.
//

#import "ViewController.h"
#import "KBPhotoAlbum.h"
#import "KBPhotoAssetsManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [KBPhotoAssetsManager sharedInstance];
    
    [KBPhotoAssetsManager fetchAllPhotoAlbums:^(NSMutableArray *albums, NSError *error) {
        for (KBPhotoAlbum *album in albums) {
            for (ALAsset *asset in album.assets) {
                NSLog(@"asset: %@ ----- date: %@", asset, [asset valueForProperty:ALAssetPropertyDate]);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
