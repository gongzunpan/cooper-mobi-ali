//
//  Constant.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Constant.h"

@implementation Constant

@synthesize sortHasChanged;
@synthesize domain;
@synthesize username;
@synthesize password;
@synthesize workId;
@synthesize token;
@synthesize loginType;
@synthesize rootPath;
@synthesize recentlyIds;
@synthesize recentlyTeamIds;
@synthesize isLocalPush;
@synthesize tempCreateTasklistId;
@synthesize tempCreateTasklistName;
@synthesize rememberVersion;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init {
	if ((self = [super init])) {
        sortHasChanged = @"";
        domain = @"";
        username = @"";
        password = @"";
        workId = @"";
        token = @"";
        loginType = @"";
        isLocalPush = NO;
        rootPath = @"";
        recentlyIds = nil;
        recentlyTeamIds = nil;
        rememberVersion = @"";
        return self;
	}
	return nil;
}

+ (void)loadFromCache {
    [[ConstantClass instance] setLoginType:[Cache getCacheByKey:@"loginType"]];
    [[ConstantClass instance] setIsLocalPush:[[Cache getCacheByKey:@"isLocalPush"] intValue]];
    [[ConstantClass instance] setSortHasChanged:[Cache getCacheByKey:@"sortHasChanged"]];
    [[ConstantClass instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [[ConstantClass instance] setUsername:[Cache getCacheByKey:@"username"]];
    [[ConstantClass instance] setWorkId:[Cache getCacheByKey:@"workId"]];
    [[ConstantClass instance] setRootPath:[Cache getCacheByKey:@"rootPath"]];
    [[ConstantClass instance] setRememberVersion:[Cache getCacheByKey:@"rememberVersion"]];
    
    id recentlyIds = [Cache getCacheByKey:@"recentlyIds"];
    if([Cache getCacheByKey:@"recentlyIds"] != nil)
    {
        [[ConstantClass instance] setRecentlyIds:recentlyIds];
    }
    id recentlyTeamIds = [Cache getCacheByKey:@"recentlyTeamIds"];
    if([Cache getCacheByKey:@"recentlyTeamIds"] != nil)
    {
        [[ConstantClass instance] setRecentlyTeamIds:recentlyTeamIds];
    }
}

+ (void)saveToCache {
    [Cache clean];
    [Cache setCacheObject:[[ConstantClass instance] loginType] ForKey:@"loginType"];
    [Cache setCacheObject:[[ConstantClass instance] sortHasChanged] ForKey:@"sortHasChanged"];
    [Cache setCacheObject:[[ConstantClass instance] domain] ForKey:@"domain"];
    [Cache setCacheObject:[[ConstantClass instance] username] ForKey:@"username"];
    [Cache setCacheObject:[[ConstantClass instance] workId] ForKey:@"workId"];
    [Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache setCacheObject:[[ConstantClass instance] rememberVersion] ForKey:@"rememberVersion"];
    [Cache setCacheObject:[[ConstantClass instance] recentlyIds] ForKey:@"recentlyIds"];
    [Cache setCacheObject:[[ConstantClass instance] recentlyTeamIds] ForKey:@"recentlyTeamIds"];
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"isLocalPush"];
    
    [Cache saveToDisk];
}

+ (void)savePathToCache
{
    [Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache saveToDisk];
}

+ (void)saveSortHasChangedToCache
{
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"sortHasChanged"];
    [Cache saveToDisk];
}

//+ (void)saveRecentlyIdsToCache
//{
//    [Cache setCacheObject:[[ConstantClass instance] recentlyIds] ForKey:@"recentlyIds"];
//    [Cache saveToDisk];
//}
//
//+ (void)saveIsLocalPushToCache
//{
//    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"isLocalPush"];
//    [Cache saveToDisk];
//}

@end
