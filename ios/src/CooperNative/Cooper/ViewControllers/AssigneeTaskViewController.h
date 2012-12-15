//
//  AssigneeTaskViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomButton.h"
#import "CooperService/EnterpriseService.h"

@interface AssigneeTaskViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView *emptyView;
    UITableView *taskView;

    EnterpriseService *enterpriseService;
}

@property (nonatomic, retain) NSMutableArray *taskInfos;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName;

@end
