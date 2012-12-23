//
//  EnterpriseService.h
//  CooperService
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseService : NSObject
//获取待办任务
- (void)getTodoTasks:(NSString*)workId
             context:(NSMutableDictionary*)context
            delegate:(id)delegate;
//获取相关任务
- (void)getRelatedTasks:(NSString*)workId
            isCompleted:(BOOL)isCompleted
              isCreator:(NSString*)isCreator
                    key:(NSString*)key
 externalTaskSourceJson:(NSString*)externalTaskSourceJson
                context:(NSMutableDictionary*)context
               delegate:(id)delegate;
//获取任务详情信息
- (void)getTaskDetail:(NSString*)taskId
              context:(NSMutableDictionary*)context
             delegate:(id)delegate;
//更新完成状态
- (void)changeTaskCompleted:(NSString*)taskId
                isCompleted:(NSNumber*)isCompleted
                    context:(NSMutableDictionary*)context
                   delegate:(id)delegate;
//更新期待完成时间
- (void)changeTaskDueTime:(NSString*)taskId
                  dueTime:(NSString*)dueTime
                  context:(NSMutableDictionary*)context
                 delegate:(id)delegate;
//更新优先级
- (void)changeTaskPriority:(NSString*)taskId
                  priority:(NSNumber*)priority
                   context:(NSMutableDictionary*)context
                  delegate:(id)delegate;
//更新当前任务详情
- (void)updateTask:(NSString*)taskId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeUserId:(NSString*)assigneeUserId
   relatedUserJson:(NSString*)relatedUserJson
          priority:(NSNumber*)priority
       isCompleted:(NSNumber*)isCompleted
           context:(NSMutableDictionary*)context
          delegate:(id)delegate;
//创新新任务
- (void)createTask:(NSString*)userId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeUserId:(NSString*)assigneeUserId
   relatedUserJson:(NSString*)relatedUserJson
          priority:(NSNumber*)priority
           context:(NSMutableDictionary*)context
          delegate:(id)delegate;
//创建附件
- (void)createTaskAttach:(NSData*)attachmentData
                fileName:(NSString*)fileName
                    type:(NSString*)type
                 context:(NSMutableDictionary*)context
                delegate:(id)delegate;

@end
