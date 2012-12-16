//
//  AssigneeTaskViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomButton.h"
#import "EnterpriseTaskTableCell.h"
#import "EnterpriseTaskDetailEditViewController.h"
#import "CooperService/EnterpriseService.h"

@interface AssigneeTaskViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EnterpriseTaskTableCellDelegate>
{
    UIView *emptyView;
    UITableView *taskView;

    EnterpriseService *enterpriseService;
}

@property (nonatomic, retain) NSMutableArray *taskInfos;
@property (nonatomic, retain) EnterpriseTaskDetailEditViewController *taskDetailEditViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName;

@end
