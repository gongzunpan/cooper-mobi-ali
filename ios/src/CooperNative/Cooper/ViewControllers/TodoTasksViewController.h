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
#import "EnterpriseTaskTableCell.h"
#import "EnterpriseTaskDetailEditViewController.h"
#import "EnterpriseTaskDetailCreateViewController.h"
#import "AudioViewController.h"
#import "TabbarLineView.h"

@interface TodoTasksViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EnterpriseTaskTableCellDelegate>
{
    UIView *emptyView;
    UITableView *taskView;
    
    UIActionSheet *photoActionSheet;
    UIActionSheet *audioActionSheet;

    EnterpriseService *enterpriseService;
}

@property (nonatomic, retain) NSMutableArray *taskInfos;
@property (nonatomic, retain) EnterpriseTaskDetailEditViewController *taskDetailEditViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName;

@end
