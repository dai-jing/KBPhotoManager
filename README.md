KBPhotoManager
==================================
![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)

A photo assets manager to fetch all assets on your phone.

## Introduction
It will support both ALAssets in iOS 7 and PHAssets available from iOS 8.
It will solve the problems blurry thumbnails using ALAssets since thumbnail images size changed since iOS 8

## CocoaPods - Try it yourself
`pod 'KBPhotoManager'`

## Example
```
[KBPhotoAssetsManager fetchAllPhotoAlbums:^(NSMutableArray *albums, NSError *error) {
        for (KBPhotoAlbum *album in albums) {
            // >= iOS 8 album object will contain an array of PHAsset objects
            // <= iOS 7 album object will contain an array of ALAsset objects
        }
    }];
```
