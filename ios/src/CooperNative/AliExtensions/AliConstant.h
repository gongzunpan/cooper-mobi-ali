//
//  AliConstant.h
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

//#import "CooperCore/Constant.h"

@interface AliConstant : NSObject

@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,assign) NSString *loginType;
@property (nonatomic,retain) NSString *rootPath;
@property (nonatomic,retain) NSMutableArray *recentlyIds;
@property (nonatomic,assign) bool isLocalPush;
@property (nonatomic,retain) NSString* tempCreateTasklistId;
@property (nonatomic,retain) NSString* tempCreateTasklistName;

+ (id)instance;

+ (void)saveToCache;
+ (void)loadFromCache;
+ (void)savePathToCache;
//+ (void)saveRecentlyIdsToCache;
//+ (void)saveIsLocalPushToCache;

@end
