//
//  Photo.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 5/20/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

/*  TODO:
    H)
 */

#import "Photo.h"
#import <sqlite3.h>

@implementation Photo
{
    //private variables for accessing SQLite database
    sqlite3 *MyPhotos;
}

//synthesize properties
@synthesize photoTimestamp,photoLocation,photoURL,photoCategory,photoAction,photoNativeID;

//DONE - INSERTS A PHOTO INTO THE DATABASE
/////*****Edit this method when database table is altered*****/////
- (void)insertPhoto:(Photo*)newPhoto
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO local (timestamp,location,url,category,action,lastupdate) VALUES (%i,\"%@\",\"%@\",\"%@\",\"%@\",%i)",newPhoto.photoTimestamp,newPhoto.photoLocation,newPhoto.photoURL,newPhoto.photoCategory,newPhoto.photoAction,newPhoto.photoTimestamp];
    const char *query_stmt = [querySQL UTF8String];
        
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"A new photo has been added to the database via SQL statement: %s",query_stmt);
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
        }
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
    
    sqlite3_finalize(statement);
}

//DONE - INSTANTIATES A PHOTO FROM THE DATABASE
/////*****Edit this method when database table is altered*****/////
- (void)createPhoto:(Photo*)newPhoto withURL:(NSString*)URL
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE url=\"%@\"",URL];
    const char *query_stmt = [querySQL UTF8String];
        
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
            
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 0: currently: 'timestamp'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,0)];
            newPhoto.photoTimestamp = [temp integerValue];
            
            //field 1: currently: 'location'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,1)];
            newPhoto.photoLocation = temp;
            
            //field 2: currently: 'url'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            newPhoto.photoURL = temp;
            
            //field 3: currently: 'category'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,3)];
            newPhoto.photoCategory = temp;
                
            //field 4: currently: 'action'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,4)];
            newPhoto.photoAction = temp;
            
            //field 5: currently: 'lastupdate'
            
            //field 6: currently: 'nativeid'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,6)];
            newPhoto.photoNativeID = temp;
            
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
        }
            
        sqlite3_finalize(statement);
            
    } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}

//DONE - UPDATES A ROW IN THE DATABASE WITH THE FIELD & VALUE FOR TEXT/INT
- (BOOL)updatePhoto:(Photo*)myPhoto inField:(NSString*)field toNew:(NSString*)newValue ifInt:(int)integer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    NSString *querySQL = @"";
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    int newTimestamp = [[NSNumber numberWithDouble: timeStamp] integerValue];
    
    if ([newValue isKindOfClass:[NSString class]]) { //value is text
        querySQL = [NSString stringWithFormat: @"UPDATE local SET \%@=\"%@\",lastupdate=%i WHERE url=\"%@\"",field,newValue,newTimestamp,myPhoto.photoURL];
    } else if (integer>=0) { //value is int or BOOL
        querySQL = [NSString stringWithFormat: @"UPDATE local SET \%@=\%i,lastupdate=%i WHERE url=\"%@\"",field,integer,newTimestamp,myPhoto.photoURL];
    } else {}
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"A row in the database has been updated with the statement: %s",query_stmt);
            return YES;
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
            return NO;
        }
    
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
        return NO;
    }
    
    sqlite3_finalize(statement);
}

//DONE - POPULATES THE ARRAY WITH URLS FOR CURRENT ROWS IN THE DATABASE
- (void)getCurrentPhotos:(NSMutableArray*)array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE category='none' ORDER BY lastupdate ASC"];
        
    const char *query_stmt = [querySQL UTF8String];
        
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
            
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 2: currently: 'url'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            [array addObject:temp];
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}

- (void)getHiddenPhotos:(NSMutableArray*)array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE category='hide' ORDER BY lastupdate ASC"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 2: currently: 'url'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            [array addObject:temp];
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}

- (void)getDispositionPhotos:(NSMutableArray*)array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE category!='hide' AND category!='none' ORDER BY lastupdate ASC"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 2: currently: 'url'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            [array addObject:temp];
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}

- (void)getIncompletePhotos:(NSMutableDictionary*)dictionary
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE category!='hide' AND category!='none' AND nativeid='9999' ORDER BY lastupdate ASC"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            NSString *temp2;
            
            //field 2: currently: 'url'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            
            //field 3: currently: 'category'
            temp2 = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,3)];
            
            [dictionary setValue:temp2 forKey:temp];
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }

}

- (void)getMenuCounts:(int[])array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 3: currently: 'category'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,3)];
            
            
            if ([temp isEqualToString:@"none"]) {
                array[0]++;
            } else if ([temp isEqualToString:@"hide"]) {
                array[1]++;
            } else {
                array[2]++;
            }
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}


//DONE - CHECKS TO SEE IF URL ALREADY EXISTS IN A ROW OF THE DATABASE
- (BOOL)alreadyExists:(NSString*)myURL
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE url=\"%@\"",myURL];
        
    const char *query_stmt = [querySQL UTF8String];
        
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            return YES;
        } else {
            return NO;
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
        }
        sqlite3_finalize(statement);
            
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
    return NO;
}

//DONE - RESET ENTIRE DATABASE BY SETTING CATEGORY TO NONE
- (void)resetDB
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyPhotos = [appDelegate MyPhotos];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat: @"UPDATE local SET category='none'"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyPhotos,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
        }else {
            NSLog(@"%s SQL error '%s' (%1d)", query_stmt, sqlite3_errmsg(MyPhotos), sqlite3_errcode(MyPhotos));
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyPhotos),sqlite3_errcode(MyPhotos));
    }
}


@end
