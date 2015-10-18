//
//  GetImageOperation.m
//  GetPix
//
//  Created by Darren Venn on 3/31/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "UploadOperation.h"
#import "NSURLConnection+Tag.h"

@implementation UploadOperation

@synthesize currentImage,toolPhoto,account,myURL;

- (id)initWithPhotoData:(NSString*)photoData;
{
    self = [super init];
    if (self) {
        NSArray *realData = [photoData componentsSeparatedByString:@"|"];
        self.account = [realData objectAtIndex:0];
        self.myURL = [NSURL URLWithString:[realData objectAtIndex:1]];
        self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    
   
        executing = NO;
        finished = NO;
        gotImage = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if ([self isCancelled] || finished) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //NSLog(@"Selected Asset: %@",myURL);
    [library assetForURL:myURL resultBlock:^(ALAsset *asset) {
        
        if (asset) {
            NSLog(@"Asset Found.");
            
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            self.currentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
            self.toolPhoto = [[Photo alloc] init];
            self.toolPhoto.photoURL = [NSString stringWithFormat:@"%@",myURL ];
            
            [self.toolPhoto updatePhoto:self.toolPhoto inField:@"nativeid" toNew:@"9999" ifInt:-1];
            
            //CONTINUE UPLOAD HERE
            [self facebookGetUploadURL:self.account];
            
        } else {
            //what happens when the asset doesn't exist, for example, out of range.
            NSLog(@"ALAsset does not exist, possibly out of range");
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: camera roll cannot be accessed");
    }];
}

- (void)facebookGetUploadURL:(NSString*)myAccount
{
    NSString *webAppURL = [self.appDelegate webAppURL];
    NSString *secret = @"888fe04088f29c8462c3195359e15d26";
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *myStringURL = [NSString stringWithFormat:@"%@/files/?aczsecret=%@&uid=%i",webAppURL,secret,self.appDelegate.myUserID];
    [request setURL:[NSURL URLWithString:myStringURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    myConnection.tag = 1111;
    myConnection.property = myAccount;
    
    (void)[myConnection initWithRequest:request delegate:self];
    
}

- (void)facebookPostPhoto:(NSString*)postURL withAccount:(NSString*)account
{
    
    //check for can_upload??
    NSString *reply_accountID = [self.appDelegate.myDispositions objectForKey:self.account];
    NSLog(@"%@",reply_accountID);
    //PART TWO OF POST
    //continue/////////////////////////////////////////////////////////
    NSData *imageData = UIImageJPEGRepresentation(self.currentImage,0.9);
    
    NSString *urlString = postURL;
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:urlString]];
    [request2 setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [request2 addValue:@"Keep-Alive" forHTTPHeaderField: @"Connection"];
    [request2 addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSString *mySecret = @"888fe04088f29c8462c3195359e15d26";
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"aczsecret\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[mySecret dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"uid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%i",self.appDelegate.myUserID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"aid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",reply_accountID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"asset\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",self.myURL] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request2 setHTTPBody:body];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    myConnection.tag = 2222;
    myConnection.property = [NSString stringWithFormat: @"%@",self.myURL];
    
    (void)[myConnection initWithRequest:request2 delegate:self];

    NSLog(@"BEFORE A COMPLETION: %i",self.appDelegate.uploadQueue.operationCount);
    
    
}

- (void)finishPhoto:(NSData*)data
{
    
    NSError *error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    
    self.toolPhoto.photoURL = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"asset"] ];
    
    NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *myID = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"id"] ];
    [self.toolPhoto updatePhoto:self.toolPhoto inField:@"nativeid" toNew:myID ifInt:-1];
}

- (void)markOperationAsCompleted
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark NSURLConnection Delegate Methods
//TENTATIVE - WHAT HAPPENS WHEN THE CONNECTION FIRST RECEIVES DATA
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    
    if([self isCancelled]) {
        [self markOperationAsCompleted];
		return;
    }
    
    //self.data = [NSMutableData data];
    
}

//TENTATIVE - WHAT HAPPENS AS THE CONNECTION BEGINS RECEIVING DATA
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if (connection.tag.intValue == 1111) {
        NSError* error;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *theReply = [responseDictionary objectForKey:@"blobUploadUrl"];
        
        //NSLog(@"The Upload URL is:%@",theReply);
        
        if (theReply)
            [self facebookPostPhoto:theReply withAccount:connection.property];
    } else if (connection.tag.intValue == 2222) {
        
        // Append the new data to the instance variable you declared
        //[responseData appendData:data];
        NSError *error;
        //NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
        NSLog(@"%@",theReply);
        
        self.toolPhoto.photoURL = connection.property;
        
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *myID = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"id"] ];
        [self.toolPhoto updatePhoto:self.toolPhoto inField:@"nativeid" toNew:myID ifInt:-1];
        
        
        // The request is complete and data has been received
        // You can parse the stuff in your instance variable now
        
    }
}

//EMPTY - WHAT HAPPENS WHEN A RESPONSE IS CACHED
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//TENTATIVE - WHAT HAPPENS AFTER THE CONNECTION SUCCEEDS
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
    if (connection.tag.intValue == 1111) {
        NSLog(@"connection 1111 is done");
    } else if (connection.tag.intValue == 2222) {
        [self markOperationAsCompleted];
    }
}

//TENTATIVE - WHAT HAPPENS IF THE CONNECTION FAILS
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"A connection has failed with the error %@",error);
    [self markOperationAsCompleted];
}


- (BOOL)imageWasFound
{
    return gotImage;
}

@end
