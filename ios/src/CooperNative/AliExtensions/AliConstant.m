//
//  AliConstant.m
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AliConstant.h"
#import "CodesharpSDK/Cache.h"

@implementation AliConstant

@synthesize domain;
@synthesize username;
@synthesize password;
@synthesize workId;
@synthesize token;
@synthesize loginType;
@synthesize rootPath;
@synthesize recentlyIds;
@synthesize isLocalPush;
@synthesize tempCreateTasklistId;
@synthesize tempCreateTasklistName;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;
}

- (id)init {
	if ((self = [super init])) {
        domain = @"";
        username = @"";
        password = @"";
        workId = @"";
        token = @"";
        loginType = @"";
        isLocalPush = NO;
        rootPath = @"";
        recentlyIds = nil;
        return self;
	}
	return nil;
}

+ (void)loadFromCache {
    [[ConstantClass instance] setLoginType:[Cache getCacheByKey:@"loginType"]];
    [[ConstantClass instance] setIsLocalPush:[[Cache getCacheByKey:@"isLocalPush"] intValue]];
    [[ConstantClass instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [[ConstantClass instance] setUsername:[Cache getCacheByKey:@"username"]];
    [[ConstantClass instance] setWorkId:[Cache getCacheByKey:@"workId"]];
    [[ConstantClass instance] setRootPath:[Cache getCacheByKey:@"rootPath"]];
    
    id recentlyIds = [Cache getCacheByKey:@"recentlyIds"];
    if([Cache getCacheByKey:@"recentlyIds"] != nil)
    {
        [[ConstantClass instance] setRecentlyIds:recentlyIds];
    }
}

+ (void)saveToCache {
    [Cache clean];
    [Cache setCacheObject:[[ConstantClass instance] loginType] ForKey:@"loginType"];
    [Cache setCacheObject:[[ConstantClass instance] domain] ForKey:@"domain"];
    [Cache setCacheObject:[[ConstantClass instance] username] ForKey:@"username"];
    [Cache setCacheObject:[[ConstantClass instance] workId] ForKey:@"workId"];
    //[Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache setCacheObject:[[ConstantClass instance] recentlyIds] ForKey:@"recentlyIds"];
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"isLocalPush"];
    
    [Cache saveToDisk];
}

+ (void)savePathToCache
{
    [Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache saveToDisk];
}

+ (void)saveRecentlyIdsToCache
{
    [Cache setCacheObject:[[ConstantClass instance] recentlyIds] ForKey:@"recentlyIds"];
    [Cache saveToDisk];
}

+ (void)saveIsLocalPushToCache
{
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"isLocalPush"];
    [Cache saveToDisk];
}

@end
