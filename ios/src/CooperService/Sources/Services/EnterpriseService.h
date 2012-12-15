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
- (void)getTasksByAssignee:(NSString*)userId
                 isCreator:(BOOL)isCreator
       isOtherAssignedToMe:(BOOL)isOtherAssignedToMe
               isCompleted:(BOOL)isCompleted
                       key:(NSString*)key
    externalTaskSourceJson:(NSString*)externalTaskSourceJson
               displayMode:(int)displayMode
          syncExternalTask:(NSString*)syncExternalTask
                   context:(NSMutableDictionary*)context
                  delegate:(id)delegate;

@end
