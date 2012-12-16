//
//  RelatedTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RelatedTaskViewController.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@implementation RelatedTaskViewController

@synthesize taskInfos;
@synthesize taskDetailEditViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = title;
        //底部条
        CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
        [tabBarItem setTitle:title];
        [tabBarItem setCustomImage:[UIImage imageNamed:imageName]];
        self.tabBarItem = tabBarItem;
        [tabBarItem release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    taskInfos = [[NSMutableArray alloc] init];
    
    enterpriseService = [[EnterpriseService alloc] init];
    
    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTaskData];
    
    [self getRelatedTasks];
}

- (void)getRelatedTasks
{
    //    self.HUD = [Tools process:LOADING_TITLE view:self.view];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetRelatedTasks" forKey:REQUEST_TYPE];
    
    [enterpriseService getRelatedTasks:TEST_USERID
                           isCompleted:NO
                             isCreator:@""
                                   key:@""
                externalTaskSourceJson:@""
                               context:context
                              delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [emptyView release];
    [taskView release];
    [enterpriseService release];
    [taskInfos release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [taskInfos count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EnterpriseTaskTableCell";
    EnterpriseTaskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
	{
        cell = [[EnterpriseTaskTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
	}
    NSMutableDictionary *taskInfoDict = [taskInfos objectAtIndex:indexPath.row];
    [cell setTaskInfo:taskInfoDict];
    cell.delegate = self;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    //设置选中后cell的背景颜色
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    return indexPath;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 28;
//}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    taskDetailEditViewController = [[EnterpriseTaskDetailEditViewController alloc] init];
    
    NSMutableDictionary *taskInfoDict = [self.taskInfos objectAtIndex:indexPath.row];
    NSString *taskId = [taskInfoDict objectForKey:@"taskId"];
    taskDetailEditViewController.currentTaskId = taskId;
    
    taskDetailEditViewController.hidesBottomBarWhenPushed = YES;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:taskDetailEditViewController animated:NO];
    
    [taskDetailEditViewController release];
}

# pragma 似有方法

- (void)initContentView
{
    NSLog(@"【初始化任务列表UI】");
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 49 - 64);
    taskView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    taskView.backgroundColor = [UIColor whiteColor];
    
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    taskView.tableFooterView = footer;
    taskView.delegate = self;
    taskView.dataSource = self;
    
    [self.view addSubview: taskView];
}

- (void)loadTaskData
{
    NSLog(@"【开始初始化任务数据】");
    
    [taskView reloadData];
    
    if(taskInfos.count == 0)
    {
        taskView.hidden = YES;
        
        if (!emptyView)
        {
//            UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [Tools screenMaxWidth], 100)];
//            tempemptyView.backgroundColor = [UIColor whiteColor];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (([Tools screenMaxWidth] - 320) / 2.0), 0, 200, 30)];
//            label.text = @"点击这里指派一个新任务";
//            label.font = [UIFont boldSystemFontOfSize:16];
//            [tempemptyView addSubview:label];
//            
//            CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110 + (([Tools screenMaxWidth] - 320) / 2.0), 50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//            addFirstBtn.layer.cornerRadius = 6.0f;
//            [addFirstBtn.layer setMasksToBounds:YES];
//            [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
//            [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
//            [tempemptyView addSubview:addFirstBtn];
//            emptyView = tempemptyView;
//            [self.view addSubview:emptyView];
//            
//            [tempemptyView release];
        }
        else
        {
            emptyView.hidden = NO;
        }
    }
    else {
        taskView.hidden = NO;
        emptyView.hidden = YES;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"GetRelatedTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    
                    taskInfos = [[NSMutableArray alloc] init];
                    
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    NSMutableArray *tasks = [data objectForKey:@"tasks"];
                    
                    for(NSMutableDictionary *taskDict in tasks)
                    {
                        //TODO:排序相关
                        NSNumber *taskId = [taskDict objectForKey:@"id"];
                        NSString* subject = [taskDict objectForKey:@"subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"subject"];
                        NSString *body = [taskDict objectForKey:@"body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"body"];
                        NSString *creator = [taskDict objectForKey:@"creator"];
                        NSString *source = [taskDict objectForKey:@"source"];
                        NSNumber *isEditable = [taskDict objectForKey:@"isEditable"];
                        NSString *createTime = [taskDict objectForKey:@"createTime"];
                        NSString *dueTime = [taskDict objectForKey:@"dueTime"] == [NSNull null] ? @"" : [taskDict objectForKey:@"dueTime"];
                        NSString *priority = [taskDict objectForKey:@"priority"];
                        NSNumber *isCompleted = [taskDict objectForKey:@"isCompleted"];
                        NSString *relatedUrl = [taskDict objectForKey:@"relatedUrl"];
                        
                        NSMutableDictionary *taskInfoDict = [NSMutableDictionary dictionary];
                        [taskInfoDict setObject:taskId forKey:@"taskId"];
                        [taskInfoDict setObject:subject forKey:@"subject"];
                        [taskInfoDict setObject:body forKey:@"body"];
                        [taskInfoDict setObject:creator forKey:@"creator"];
                        [taskInfoDict setObject:source forKey:@"source"];
                        [taskInfoDict setObject:isEditable forKey:@"isEditable"];
                        [taskInfoDict setObject:createTime forKey:@"createTime"];
                        [taskInfoDict setObject:dueTime forKey:@"dueTime"];
                        [taskInfoDict setObject:priority forKey:@"priority"];
                        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
                        [taskInfoDict setObject:relatedUrl forKey:@"relateUrl"];
                        
                        [taskInfos addObject:taskInfoDict];
                    }
                    
                    [self loadTaskData];
                }
                else {
                    NSString *errorMsg = [dict objectForKey:@"errorMsg"];
                    [Tools failed:self.HUD msg:errorMsg];
                }
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeCompleted"]) {
        if(request.responseStatusCode == 200) {
            //TODO:正常ok
        }
        else {
            [Tools failed:self.HUD];
        }
    }
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
