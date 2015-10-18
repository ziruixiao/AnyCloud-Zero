//
//  AssetsLibrary.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ASAssetsLibrary.h"

@interface ASAssetsLibrary (){
    ALAssetsLibrary* library;
}

@end

@implementation ASAssetsLibrary

+ (ASAssetsLibrary*)sharedInstance
{
    static ASAssetsLibrary* assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ASAssetsLibrary alloc] init];
    });
    return assetsLibrary;
}

- (id)init
{
    self = [super init];
   
    if (self){
        
        library = [[ALAssetsLibrary alloc] init]; // WORKAROUND from http://openradar.appspot.com/10484334 for receiving ALAssetsLibraryChangedNotification
        //[library writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock :^(NSURL *assetURL, NSError *error) {}];
        [self performSelectorOnMainThread:@selector(enumAlbums) withObject:nil waitUntilDone:NO];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (assetsLibraryDidChanged:) name: ALAssetsLibraryChangedNotification object:library];
        
    }
    return self;
}

- (void)enumAlbums
{
    NSMutableArray* __groups = [NSMutableArray array];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group){
            [__groups addObject:group];
        }else{
            self.groups = __groups;
        }
        
        
    } failureBlock:^(NSError *error) {
        
        //SHOW ERROR HERE THAT SAYS THE USER MUST GO TO SETTINGS AND ENABLE PHOTO ACCESS
        self.groups = nil;
    }];
}

@end
