//
//  EnterpriseOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//#import "BaseNavigationController.h"
//#import "AssigneeTaskViewController.h"
//#import "RelatedTaskViewController.h"
//#import "EnterpriseTaskDetailCreateViewController.h"
//#import "EnterpriseAudioViewController.h"
//#import "EnterpriseImageViewController.h"

@interface EnterpriseOptionViewController : BaseViewController<UITableViewDelegate
, UITableViewDataSource>

@property (nonatomic, retain) UITableView *optionView;

@end

//@interface EnterpriseOptionViewController : BaseViewController<UITabBarControllerDelegate>
//
//@property (nonatomic, retain) UIView *infoView;
//@property (nonatomic, retain) UIScrollView *menuScrollView;
//@property (nonatomic, retain) UITabBarController *taskBarController;
//@property (nonatomic, retain) BaseNavigationController *taskCreateController;
//@property (nonatomic, retain) EnterpriseAudioViewController *audioController;
//@property (nonatomic, retain) EnterpriseImageViewController *imageController;
//
//@end
