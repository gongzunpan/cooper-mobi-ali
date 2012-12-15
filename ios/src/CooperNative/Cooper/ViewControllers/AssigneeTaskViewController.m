//
//  AssigneeTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AssigneeTaskViewController.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@implementation AssigneeTaskViewController

@synthesize taskInfos;

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

    
    enterpriseService = [[EnterpriseService alloc] init];

    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self loadTaskData];
    taskInfos = [NSMutableArray arrayWithCapacity:1];

    [self getTasksByAssignee];
}

- (void)getTasksByAssignee
{
    self.HUD = [Tools process:LOADING_TITLE view:self.view];

    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetTasksByAssignee" forKey:REQUEST_TYPE];
    [enterpriseService getTasksByAssignee:TEST_USERID
                                isCreator:NO
                      isOtherAssignedToMe:NO
                              isCompleted:NO
                                      key:@""
                   externalTaskSourceJson:@""
                              displayMode:1
                         syncExternalTask:@""
                                  context:context
                                 delegate:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
//    [emptyView release];
//    [taskView release];
//    [enterpriseService release];
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
    return [self.taskInfos count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskTableViewCell"];
	}
    NSMutableDictionary *taskInfoDict = [self.taskInfos objectAtIndex:indexPath.row];
    //[cell setTaskInfo:task];
    //cell.delegate = self;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];

    //设置选中后cell的背景颜色
    cell.selectedBackgroundView = selectedView;
    cell.textLabel.text = [taskInfoDict objectForKey:@"subject"];

    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];

    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    if (teamTaskDetailViewController == nil) {
//        teamTaskDetailViewController = [[TeamTaskDetailViewController alloc] init];
//    }
//    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    teamTaskDetailViewController.task = task;
//    teamTaskDetailViewController.currentTeamId = currentTeamId;
//    teamTaskDetailViewController.currentProjectId = currentProjectId;
//    teamTaskDetailViewController.currentMemberId = currentMemberId;
//    teamTaskDetailViewController.currentTag = currentTag;
//
//    [Tools layerTransition:self.navigationController.view from:@"right"];
//    [self.navigationController pushViewController:teamTaskDetailViewController animated:NO];
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
            UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [Tools screenMaxWidth], 100)];
            tempemptyView.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (([Tools screenMaxWidth] - 320) / 2.0), 0, 200, 30)];
            label.text = @"点击这里指派一个新任务";
            label.font = [UIFont boldSystemFontOfSize:16];
            [tempemptyView addSubview:label];

            CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110 + (([Tools screenMaxWidth] - 320) / 2.0), 50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
            addFirstBtn.layer.cornerRadius = 6.0f;
            [addFirstBtn.layer setMasksToBounds:YES];
            [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
            [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
            [tempemptyView addSubview:addFirstBtn];
            emptyView = tempemptyView;
            [self.view addSubview:emptyView];

            [tempemptyView release];
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

    if([requestType isEqualToString:@"GetTasksByAssignee"])
    {
        [Tools close:self.HUD];

        if(request.responseStatusCode == 200)
        {
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                NSMutableDictionary *data = [dict objectForKey:@"data"];

                if(state == [NSNumber numberWithInt:0]) {
                    
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    NSMutableArray *tasks = [data objectForKey:@"tasks"];

                    for(NSMutableDictionary *taskDict in tasks)
                    {
                        //TODO:排序相关
                        NSNumber *taskId = [taskDict objectForKey:@"id"];
                        NSString *subject = [[taskDict objectForKey:@"subject"] copy];
                        NSString *body = [taskDict objectForKey:@"body"];
                        NSString *creator = [taskDict objectForKey:@"creator"];
                        NSString *source = [taskDict objectForKey:@"source"];
                        NSNumber *isEditable = [taskDict objectForKey:@"isEditable"];
                        NSString *createTime = [taskDict objectForKey:@"createTime"];
                        NSDate *due = @"";
                        if([taskDict objectForKey:@"dueTime"] != [NSNull null]) {
                            due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"dueTime"]];
                        }
                        NSString *priority = [taskDict objectForKey:@"priority"];
                        NSNumber *isCompleted = [taskDict objectForKey:@"isCompleted"];
                        NSString *relatedUrl = [taskDict objectForKey:@"relatedUrl"];

                        NSMutableDictionary *taskInfoDict = [NSMutableDictionary dictionary];
                        [taskInfoDict setObject:subject forKey:@"subject"];

                        
                        [taskInfos addObject:taskInfoDict];
                    }

                    [self loadTaskData];
                }
                else {
                    NSString *errorMsg = [dict objectForKey:@"errorMsg"];
                    [Tools alert:errorMsg];
                }
                
//                NSArray *tasks = [dict objectForKey:@"List"];
//                NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
//
//                [taskDao deleteAllByTeam:currentTeamId];
//                [taskIdxDao deleteAllByTeam:currentTeamId projectId:currentProjectId memberId:currentMemberId tag:currentTag];
//                [commentDao deleteAll];
//
//                [taskIdxDao commitData];
//
//                for(NSDictionary *taskDict in tasks)
//                {
//                    NSString *taskId = [taskDict objectForKey:@"ID"];
//
//                    NSString* subject = [taskDict objectForKey:@"Subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Subject"];
//                    NSString *body = [taskDict objectForKey:@"Body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Body"];
//                    NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
//                    NSNumber *status = [NSNumber numberWithInt:[isCompleted integerValue]];
//                    NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
//
//                    NSString *editable = (NSString*)[taskDict objectForKey:@"Editable"];
//
//                    NSDate *due = nil;
//                    if([taskDict objectForKey:@"DueTime"] != [NSNull null])
//                        due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"DueTime"]];
//
//                    NSString *createDateString = [taskDict objectForKey:@"CreateTime"];
//                    NSDate *createDate = nil;
//                    if(createDateString != [NSNull null])
//                    {
//                        createDate = [Tools NSStringToNSDate:createDateString];
//                    }
//                    else
//                    {
//                        createDate = [NSDate date];
//                    }
//
//                    NSMutableDictionary *creatorDict = [taskDict objectForKey:@"Creator"];
//                    NSString *createMemberId = [creatorDict objectForKey:@"id"];
//
//                    NSString *assigneeId = nil;
//                    NSMutableDictionary *assigneeDict = [taskDict objectForKey:@"Assignee"];
//                    if(assigneeDict != [NSNull null])
//                    {
//                        assigneeId = [assigneeDict objectForKey:@"id"];
//                    }
//
//                    NSMutableArray *projectsArray = [taskDict objectForKey:@"Projects"];
//                    NSString *projects = [projectsArray JSONRepresentation];
//
//                    NSMutableArray *tagsArray = [taskDict objectForKey:@"Tags"];
//                    NSString *tags = [tagsArray JSONRepresentation];
//
//                    NSMutableArray *commentsArray = [taskDict objectForKey:@"Comments"];
//                    for (NSMutableDictionary *commentDict in commentsArray)
//                    {
//                        NSMutableDictionary *comment_creatorDict = [commentDict objectForKey:@"creator"];
//                        NSString *comment_creatorId = [comment_creatorDict objectForKey:@"id"];
//                        NSString *comment_createTimeString = [commentDict objectForKey:@"createTime"];
//                        NSString *comment_body = [commentDict objectForKey:@"body"];
//                        [commentDao addComment:taskId
//                                     creatorId:comment_creatorId
//                                    createTime:[Tools NSStringToNSDate:comment_createTimeString]
//                                          body:comment_body];
//                        [commentDao commitData];
//                    }
//
//                    [taskDao addTeamTask:subject
//                              createDate:createDate
//                          lastUpdateDate:[NSDate date]
//                                    body:body
//                                isPublic:[NSNumber numberWithInt:1]
//                                  status:status
//                                priority:priority
//                                  taskId:taskId
//                                 dueDate:due
//                                editable:[NSNumber numberWithInt:[editable integerValue]]
//                          createMemberId:createMemberId
//                              assigneeId:assigneeId
//                                projects:projects
//                                    tags:tags
//                                  teamId:currentTeamId];
//                }
//
//                for(NSDictionary *idxDict in taskIdxs)
//                {
//                    NSString *by = (NSString*)[idxDict objectForKey:@"By"];
//                    NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
//                    NSString *name = (NSString*)[idxDict objectForKey:@"Name"];
//
//                    NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
//                    NSString *indexes = [array JSONRepresentation];
//
//                    [taskIdxDao addTeamTaskIdx:by
//                                           key:key
//                                          name:name
//                                       indexes:indexes
//                                        teamId:currentTeamId
//                                     projectId:currentProjectId
//                                      memberId:currentMemberId
//                                           tag:currentTag];
//                }
//                
//                [taskIdxDao commitData];
//                
//                [self loadTaskData];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
