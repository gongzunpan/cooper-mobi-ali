//
//  EnterpriseOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseOptionViewController.h"
#import "TodoTasksViewController.h"
#import "RelatedTaskViewController.h"
#import "SettingViewController.h"

//#define AUDIO_OPTION    @"随口记"
//#define IMAGE_OPTION     @"随手派"
//#define LIST_OPTION     @"任务列表"

@implementation EnterpriseOptionViewController

//@synthesize infoView;
//@synthesize menuScrollView;
//@synthesize taskBarController;
//@synthesize taskCreateController;
//@synthesize audioController;
//@synthesize imageController;

@synthesize optionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma 私有方法

- (void)initContentView
{
    //任务列表View
    optionView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    optionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    optionView.dataSource = self;
    optionView.delegate = self;
    [self.view addSubview:optionView];
}

# pragma mark - 任务列表相关委托事件

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if(!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

         cell.showsReorderControl = YES;
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
         UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
         selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
         cell.backgroundColor = [UIColor whiteColor];

         //设置选中后cell的背景颜色
         cell.selectedBackgroundView = selectedView;
         [selectedView release];
     }

    if(indexPath.row == 0) {
        cell.textLabel.text = @"我的任务";
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"相关任务";
    }
    else if(indexPath.row == 2) {
        cell.textLabel.text = @"设置";
    }
    else if(indexPath.row == 3) {
        cell.textLabel.text = @"关于";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        TodoTasksViewController *taskViewController = [[TodoTasksViewController alloc] init];
        BaseNavigationController *taskNavController = [[BaseNavigationController alloc] initWithRootViewController:taskViewController];
        self.sidePanelController.centerPanel = taskNavController;
        [taskViewController release];

    }
    else if(indexPath.row == 1) {
        RelatedTaskViewController *taskViewController = [[RelatedTaskViewController alloc] init];
        BaseNavigationController *taskNavController = [[BaseNavigationController alloc] initWithRootViewController:taskViewController];
        self.sidePanelController.centerPanel = taskNavController;
        [taskViewController release];
    }
    else if(indexPath.row == 2) {
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        BaseNavigationController *settingNavController = [[BaseNavigationController alloc] initWithRootViewController:settingViewController];
        self.sidePanelController.centerPanel = settingNavController;
        [settingViewController release];
    }
    else if(indexPath.row == 3) {
        
    }
}

@end
