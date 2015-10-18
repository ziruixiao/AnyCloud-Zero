//
//  AssetsLibrary.h
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAssetsLibrary : NSObject

+(ASAssetsLibrary*)sharedInstance;

@property (nonatomic,strong) NSArray* groups;

@end
