//
//  Photo.h
//  AnyCloudZero
//
//  Created by Felix Xiao on 5/20/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Photo : NSObject
 
//declare properties
@property int photoTimestamp;
@property (strong,nonatomic) NSString *photoLocation;
@property (strong,nonatomic) NSString *photoURL;
@property (strong,nonatomic) NSString *photoCategory;
@property (strong,nonatomic) NSString *photoAction;

@property (strong,nonatomic) NSMutableArray *dispositions;
@property (strong,nonatomic) NSString *photoNativeID;

//declare methods
- (void)insertPhoto:(Photo*)newPhoto;
- (void)createPhoto:(Photo*)newPhoto withURL:(NSString*)URL;
- (BOOL)updatePhoto:(Photo*)myPhoto inField:(NSString*)field toNew:(NSString*)newValue ifInt:(int)integer;
- (void)getCurrentPhotos:(NSMutableArray*)array;
- (void)getHiddenPhotos:(NSMutableArray*)array;
- (void)getDispositionPhotos:(NSMutableArray*)array;

- (void)getIncompletePhotos:(NSMutableDictionary*)dictionary;

- (BOOL)alreadyExists:(NSString*)myURL;
- (void)resetDB;

- (void)getMenuCounts:(int[])array;
@end
