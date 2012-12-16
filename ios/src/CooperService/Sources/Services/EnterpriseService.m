//
//  EnterpriseService.m
//  CooperService
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseService.h"

@implementation EnterpriseService

- (void)getTasksByAssignee:(NSString*)userId
                 isCreator:(BOOL)isCreator
       isOtherAssignedToMe:(BOOL)isOtherAssignedToMe
               isCompleted:(BOOL)isCompleted
                       key:(NSString*)key
    externalTaskSourceJson:(NSString*)externalTaskSourceJson
               displayMode:(int)displayMode
          syncExternalTask:(NSString*)syncExternalTask
                   context:(NSMutableDictionary*)context
                  delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETTASKSBYASSIGNEE_URL];
    NSLog(@"【GetTasksByAssignee服务接口路径】%@", url);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    [params setObject:isCreator ? @"True" : @"False" forKey:@"isCreator"];
    [params setObject:isOtherAssignedToMe ? @"True" : @"False" forKey:@"isOtherAssignedToMe"];
    [params setObject:isCompleted ? @"True" : @"False" forKey:@"isCompleted"];
    [params setObject:key forKey:@"key"];
    [params setObject:externalTaskSourceJson forKey:@"externalTaskSourceJson"];
    [params setObject:[NSNumber numberWithInt:displayMode] forKey:@"displayMode"];
    [params setObject:syncExternalTask forKey:@"syncExternalTask"];

    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)getRelatedTasks:(NSString*)userId
            isCompleted:(BOOL)isCompleted
              isCreator:(NSString*)isCreator
                    key:(NSString*)key
 externalTaskSourceJson:(NSString*)externalTaskSourceJson
                context:(NSMutableDictionary*)context
               delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETRELATEDTASKS_URL];
    NSLog(@"【GetRelatedTasks服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    [params setObject:isCompleted ? @"True" : @"False" forKey:@"isCompleted"];
    [params setObject:isCreator forKey:@"isCreator"];
    [params setObject:key forKey:@"key"];
    [params setObject:externalTaskSourceJson forKey:@"externalTaskSourceJson"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)getTaskDetail:(NSString*)taskId
              context:(NSMutableDictionary*)context
             delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_TASKINFO_URL];
    NSLog(@"【TaskInfo服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changeCompleted:(NSString*)taskId
            isCompleted:(NSNumber*)isCompleted
                context:(NSMutableDictionary*)context
               delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGECOMPLETED_URL];
    NSLog(@"【ChangeCompleted服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:isCompleted forKey:@"isCompleted"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changeDueTime:(NSString*)taskId
              dueTime:(NSString*)dueTime
              context:(NSMutableDictionary*)context
             delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGEDUETIME_URL];
    NSLog(@"【ChangeDueTime服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:dueTime forKey:@"dueTime"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changePriority:(NSString*)taskId
              priority:(NSNumber*)priority
               context:(NSMutableDictionary*)context
              delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGEPRIORITY_URL];
    NSLog(@"【ChangePriority服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:priority forKey:@"priority"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)updateTask:(NSString*)taskId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeUserId:(NSString*)assigneeUserId
   relatedUserJson:(NSString*)relatedUserJson
          priority:(NSNumber*)priority
       isCompleted:(NSNumber*)isCompleted
           context:(NSMutableDictionary*)context
          delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_UPDATETASK_URL];
    NSLog(@"【UpdateTask服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:body forKey:@"body"];
    [params setObject:dueTime forKey:@"dueTime"];
    [params setObject:assigneeUserId forKey:@"assigneeUserId"];
    [params setObject:relatedUserJson forKey:@"relatedUserJson"];
    [params setObject:priority forKey:@"priority"];
    [params setObject:isCompleted forKey:@"isCompleted"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)createTask:(NSString*)userId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeUserId:(NSString*)assigneeUserId
   relatedUserJson:(NSString*)relatedUserJson
          priority:(NSNumber*)priority
           context:(NSMutableDictionary*)context
          delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CREATETASK_URL];
    NSLog(@"【CreateTask服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:body forKey:@"body"];
    [params setObject:dueTime forKey:@"dueTime"];
    [params setObject:assigneeUserId forKey:@"assigneeUserId"];
    [params setObject:relatedUserJson forKey:@"relatedUserJson"];
    [params setObject:priority forKey:@"priority"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

@end
