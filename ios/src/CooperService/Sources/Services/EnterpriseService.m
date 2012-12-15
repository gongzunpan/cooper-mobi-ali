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
@end
