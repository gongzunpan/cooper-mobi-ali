//
//  MainViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "LoginViewDelegate.h"
#import "LoginViewController.h"
#import "TaskListViewController.h"
#import "TaskOptionViewController.h"
#import "EnterpriseOptionViewController.h"

@interface MainViewController : BaseViewController<LoginViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, retain) BaseNavigationController *loginViewNavController;
@property (nonatomic, retain) BaseNavigationController *tasklistNavController;
@property (nonatomic, retain) BaseNavigationController *taskOptionNavController;
@property (nonatomic, retain) EnterpriseOptionViewController *enterpriseOptionViewController;

@end
