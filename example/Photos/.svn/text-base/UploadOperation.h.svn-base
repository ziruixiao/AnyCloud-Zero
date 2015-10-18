//
//  GetImageOperation.h
//  GetPix
//
//  Created by Darren Venn on 3/31/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "AppDelegate.h"

@interface UploadOperation : NSOperation {
    BOOL executing;
    BOOL finished;
    BOOL gotImage;
}

@property (strong,nonatomic) NSMutableData *data;
@property (strong,nonatomic) UIImage *currentImage;
@property (strong,nonatomic) Photo *toolPhoto;
@property (strong,nonatomic) NSString *account;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) NSURL *myURL;

- (id)initWithPhotoData:(NSString*)photoData;
- (BOOL)imageWasFound;
- (void)facebookGetUploadURL:(NSString*)myAccount;

@end
