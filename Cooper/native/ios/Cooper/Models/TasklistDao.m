//
//  TasklistDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistDao.h"
#import "ModelHelper.h"
#import "Tasklist.h"


@implementation TasklistDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Tasklist";
    }
    return self;
}

- (NSMutableArray*)getAllTasklist
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName 
                                              inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(accountId = %@)"
                                  , [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(accountId = nil)"];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    [fetchRequest setEntity:entity];
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}

- (NSMutableArray*)getAllTasklistByGuest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName 
                                              inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(accountId = nil)"];

    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    [fetchRequest setEntity:entity];
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}

- (void)deleteTasklist:(Tasklist *)tasklist
{
    [context deleteObject:tasklist];
}

- (void)deleteAll
{
    NSMutableArray *array = [self getAllTasklist];
    
    if(array.count > 0)
        for(Tasklist* tasklist in array)
            [self deleteTasklist:tasklist];
}

- (void)addTasklist:(NSString *)id :(NSString *)name :(NSString*)type
{
    Tasklist *tasklist = [ModelHelper create:tableName context:context];
    tasklist.id = id;
    tasklist.name = name;
    tasklist.listType = type;
    if([[ConstantClass instance] username].length > 0)
        tasklist.accountId = [[ConstantClass instance] username];
}

- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context]; 
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", oldId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    if(tasklists.count > 0)
    {
        Tasklist *tasklist = [tasklists objectAtIndex:0];
        tasklist.id = newId;
    }
    
    [super commitData];
    
    [fetchRequest release];
}

@end
