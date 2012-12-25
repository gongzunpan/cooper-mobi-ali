//
//  EnterpriseService.m
//  CooperService
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseService.h"

@implementation EnterpriseService
- (void)getTodoTasks:(NSString*)workId
             context:(NSMutableDictionary*)context
            delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETTODOTASKS_URL];
    NSLog(@"【GetTodoTasks服务接口路径】%@", url);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:workId forKey:@"workId"];

    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)getRelevantTasks:(NSString*)workId
                 context:(NSMutableDictionary*)context
                delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETRELEVANTTASKS_URL];
    NSLog(@"【GetRelevantTasks服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:workId forKey:@"workId"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)getTaskDetail:(NSString*)taskId
              context:(NSMutableDictionary*)context
             delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_TASKDETAIL_URL];
    NSLog(@"【TaskDetail服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changeTaskCompleted:(NSString*)taskId
                isCompleted:(NSNumber*)isCompleted
                    context:(NSMutableDictionary*)context
                   delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKCOMPLETED_URL];
    NSLog(@"【ChangeTaskCompleted服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:isCompleted forKey:@"isCompleted"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changeTaskDueTime:(NSString*)taskId
                  dueTime:(NSString*)dueTime
                  context:(NSMutableDictionary*)context
                 delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKDUETIME_URL];
    NSLog(@"【ChangeTaskDueTime服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:dueTime forKey:@"dueTime"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)changeTaskPriority:(NSString*)taskId
                  priority:(NSNumber*)priority
                   context:(NSMutableDictionary*)context
                  delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKPRIORITY_URL];
    NSLog(@"【ChangeTaskPriority服务接口路径】%@", url);
    
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
- (void)createTaskAttach:(NSData*)attachmentData
                fileName:(NSString*)fileName
                    type:(NSString*)type
                 context:(NSMutableDictionary*)context
                delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ENTERPRISE_CREATETASKATTACH_URL];
    NSLog(@"【CreateTaskAttach服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:fileName forKey:@"fileName"];
    [params setObject:type forKey:@"type"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params fileData:attachmentData fileKey:@"attachment" headers:nil context:context delegate:delegate];
    [request release];
}

@end
