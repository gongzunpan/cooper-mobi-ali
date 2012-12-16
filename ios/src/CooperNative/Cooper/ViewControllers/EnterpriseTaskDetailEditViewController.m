//
//  EnterpriseTaskDetailEditViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailEditViewController.h"
#import "CustomButton.h"

@implementation EnterpriseTaskDetailEditViewController

@synthesize currentTaskId;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize subjectTextField;
@synthesize bodyTextView;
@synthesize bodyScrollView;
@synthesize bodyCell;
@synthesize taskDetailDict;

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
	
    enterpriseService = [[EnterpriseService alloc] init];

    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    taskDetailDict = [[NSMutableDictionary alloc] init];
    
    [self getTaskDetail];
    
    viewCenter = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)dealloc
{
    [enterpriseService release];
    [taskDetailDict release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView 事件源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == detailView)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatusCell"] autorelease];
                    cell.textLabel.text = @"状态:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    statusButton = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                    
//                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    {
                        statusButton.userInteractionEnabled = YES;
//                    }
//                    else
//                    {
//                        statusButton.userInteractionEnabled = NO;
//                    }
                    
                    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    [statusButton addTarget:self action:@selector(switchStatus) forControlEvents:UIControlEventTouchUpInside];
                    
                    [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
                }
                
                NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
                
                if(isCompleted != nil) {
                    [statusButton setTitle: [isCompleted isEqualToNumber:[NSNumber numberWithInt:1]] ? @"完成    >" : @"未完成    >" forState:UIControlStateNormal];
                    [statusButton setBackgroundImage:[UIImage imageNamed:[isCompleted isEqualToNumber:[NSNumber numberWithInt:1]] ? @"btn_bg_green.png" : @"btn_bg_gray.png"] forState:UIControlStateNormal];
                    [statusButton setTitleColor: [isCompleted isEqualToNumber:[NSNumber numberWithInt:1]] ?[UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
                    
                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
                    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
                    [cell.contentView addSubview:statusButton];
                }
            }
            else if(indexPath.row == 1)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DueDateCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DueDateCell"] autorelease];
                    cell.textLabel.text = @"截至日期:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];
                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    dueDateLabel = [[DateLabel alloc] initWithFrame:CGRectZero];
//                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    {
                        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
                        [self.dueDateLabel addGestureRecognizer:recog];
                        self.dueDateLabel.delegate = self;
                        [recog release];
                        dueDateLabel.userInteractionEnabled = YES;
//                    }
//                    else
//                    {
//                        dueDateLabel.userInteractionEnabled = NO;
//                    }
                }

                NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
                if(dueTime != nil) {
                    
                    if ([dueTime isEqualToString:@""]) {
                        [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", dueTime] forState:UIControlStateNormal];
                        //currentDueDate = [task.dueDate copy];
                    }
                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
                    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
                    [cell.contentView addSubview:dueDateLabel];
                }
            }
            else if(indexPath.row == 2)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriorityCell"] autorelease];
                    cell.textLabel.text = @"优先级:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    priorityButton = [[PriorityButton alloc] initWithFrame:CGRectZero];
                    
//                    if(![[task.editable stringValue] isEqualToString: [[NSNumber numberWithInt:0] stringValue]])
//                    {
                        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
                        [priorityButton addGestureRecognizer:recog];
                        priorityButton.delegate = self;
                        [recog release];
                        priorityButton.userInteractionEnabled = YES;
//                    }
//                    else
//                    {
//                        priorityButton.userInteractionEnabled = NO;
//                    }
                    
                    [priorityButton setTitle:[NSString stringWithFormat:@"%@    >",PRIORITY_TITLE_1] forState:UIControlStateNormal];
                }
                
                NSString *priority = [taskDetailDict objectForKey:@"priority"];
                if(priority != nil) {
                    [priorityButton setTitle: [NSString stringWithFormat:@"%@    >", [self getPriorityValue:priority]] forState:UIControlStateNormal];
                    //oldPriority = [task.priority copy];
                    
                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
                    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
                    [cell.contentView addSubview:priorityButton];
                }
            }
            else if(indexPath.row == 3)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"AssigneeCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AssigneeCell"] autorelease];
                    cell.textLabel.text = @"当前处理人:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    assigneeView = [[UIView alloc] initWithFrame:CGRectZero];
//                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    {
                        assigneeView.userInteractionEnabled = YES;
//                    }
//                    else
//                    {
//                        assigneeView.userInteractionEnabled = NO;
//                    }
                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAssignee:)];
                    [assigneeView addGestureRecognizer:recognizer];
                    [recognizer release];
                    [cell.contentView addSubview:assigneeView];
                }
                
                NSString *assigneeName = [taskDetailDict objectForKey:@"assigneeName"];
                if(assigneeName != nil && ![assigneeName isEqualToString:@""])
                {
                    CustomButton *assigneeBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                    assigneeBtn.userInteractionEnabled = NO;
                    [assigneeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [assigneeBtn setTitle:assigneeName forState:UIControlStateNormal];
                    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
                    CGSize labelsize = [assigneeBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    CGFloat labelsizeHeight = labelsize.height + 10;
                    assigneeBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
                    [assigneeView addSubview:assigneeBtn];
                    [assigneeBtn release];

                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
                    
                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
                }
                
//                if(task != nil)
//                {
//                    currentAssigneeId = task.assigneeId;
//                }
//                
//                TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:currentAssigneeId];
//                if(teamMember != nil)
//                {
//                    currentAssigneeId = teamMember.id;
//                    
//                    CustomButton *memberBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
//                    memberBtn.userInteractionEnabled = NO;
//                    [memberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [memberBtn setTitle:teamMember.name forState:UIControlStateNormal];
//                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
//                    CGSize labelsize = [memberBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                    CGFloat labelsizeHeight = labelsize.height + 10;
//                    memberBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
//                    [assigneeView addSubview:memberBtn];
//                    [memberBtn release];
//                    
//                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
//                    
//                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
//                }
//                else
//                {
//                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
//                    label.textColor = [UIColor grayColor];
//                    label.text = @"none";
//                    [assigneeView addSubview:label];
//                    [label release];
//                    
//                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
//                }
            }
            else if(indexPath.row == 4)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectCell"] autorelease];
                    cell.textLabel.text = @"标题:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, [Tools screenMaxWidth] - 120, 25)];
                    subjectTextField.userInteractionEnabled = YES;
                    [subjectTextField setReturnKeyType:UIReturnKeyDone];
                    [subjectTextField setTextAlignment:UITextAlignmentLeft];
                    [subjectTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [subjectTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [subjectTextField setPlaceholder:@"标题"];
                    [subjectTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    [cell.contentView addSubview:subjectTextField];
                }
                
                NSString *subject = [taskDetailDict objectForKey:@"subject"];
                subjectTextField.text = subject;

            }
            else if(indexPath.row == 5)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BodyCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BodyCell"] autorelease];
                    
                    bodyTextView = [[BodyTextView alloc] initWithFrame:self.view.frame];
                    bodyTextView.userInteractionEnabled = YES;
                    [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    bodyTextView.returnKeyType = UIReturnKeyDefault;
                    bodyTextView.keyboardType = UIReturnKeyDone;
                    bodyTextView.scrollEnabled = YES;
                    bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    bodyTextView.delegate = self;
                    bodyTextView.bodyDelegate = self;
                    [bodyTextView setFont:[UIFont systemFontOfSize:16]];
                    
                    bodyScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)] autorelease];
                    [bodyScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                    [bodyScrollView setContentSize:bodyTextView.frame.size];
                    [bodyScrollView addSubview:bodyTextView];
                    
                    [cell addSubview:bodyScrollView];
                    
                    bodyCell = cell;
                }

                NSString *body = [taskDetailDict objectForKey:@"body"];
                bodyTextView.text = body;
                
                int totalheight = bodyTextView.contentSize.height;
                //            if(bodyTextView.contentSize.height < 300)
                //            {
                //                totalheight = 300;
                //            }
                [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalheight + 200)];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
{
    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
    
    NSString *dueTime = [value copy];
    [taskDetailDict setObject:dueTime forKey:@"dueTime"];

    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeDueTime" forKey:REQUEST_TYPE];
    [enterpriseService changeDueTime:currentTaskId
                             dueTime:dueTime
                             context:context
                            delegate:self];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
//    [delegate loadTaskData];
}

- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
{
    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
    
    NSNumber *priority = [self getPriorityKey:value];
    [taskDetailDict setObject:priority forKey:@"priority"];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangePriority" forKey:REQUEST_TYPE];
    [enterpriseService changePriority:currentTaskId
                             priority:priority
                              context:context
                             delegate:self];

    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
}

-(void)textFieldDoneEditing:(id)sender
{
    NSString *subject = self.subjectTextField.text;
    [taskDetailDict setObject:subject forKey:@"subject"];
    
    NSString *body = [taskDetailDict objectForKey:@"body"];
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSString *assigneeUserId = [taskDetailDict objectForKey:@"assigneeUserId"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"UpdateTask" forKey:REQUEST_TYPE];
    [enterpriseService updateTask:currentTaskId
                          subject:subject
                             body:body
                          dueTime:dueTime
                   assigneeUserId:assigneeUserId
                  relatedUserJson:@""
                         priority:priority
                      isCompleted:isCompleted
                          context:context
                         delegate:self];
    
    [sender resignFirstResponder];
}

- (void)returnData
{
    NSString *subject = [taskDetailDict objectForKey:@"subject"];
    NSString *body = bodyTextView.text;
    [taskDetailDict setObject:body forKey:@"body"];
    
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSString *assigneeUserId = [taskDetailDict objectForKey:@"assigneeUserId"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"UpdateTask" forKey:REQUEST_TYPE];
    [enterpriseService updateTask:currentTaskId
                          subject:subject
                             body:body
                          dueTime:dueTime
                   assigneeUserId:assigneeUserId
                  relatedUserJson:@""
                         priority:priority
                      isCompleted:isCompleted
                          context:context
                         delegate:self];
}

- (void)selectDueDate
{
    [self.dueDateLabel becomeFirstResponder];
}

- (void)selectPriority
{
    [self.priorityButton becomeFirstResponder];
}

- (BOOL)taskIsFinish
{
    return [statusButton.titleLabel.text isEqualToString:@"完成    >"];
}

- (void)switchStatus
{
//    if([[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//        return;
    
    bool isfinish;
    if([statusButton.titleLabel.text isEqualToString:@"未完成    >"])
    {
        [statusButton setTitle:@"完成    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_green.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        isfinish = YES;
        
    }
    else
    {
        [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isfinish = NO;
    }
    
    NSNumber *isCompleted = [NSNumber numberWithInt: isfinish ? 1 : 0];
    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeCompleted" forKey:REQUEST_TYPE];
    [enterpriseService changeCompleted:currentTaskId
                           isCompleted:isCompleted
                               context:context
                              delegate:self];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
}

- (void)selectAssignee:(id)sender
{
//    if (teamTaskOptionViewController == nil)
//    {
//        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
//    }
//    
//    teamTaskOptionViewController.currentTask = task;
//    teamTaskOptionViewController.selectMultiple = NO;
//    teamTaskOptionViewController.optionType = 1;
//    teamTaskOptionViewController.currentTeamId = currentTeamId;
//    teamTaskOptionViewController.currentProjectId = currentProjectId;
//    teamTaskOptionViewController.currentMemberId = currentMemberId;
//    teamTaskOptionViewController.currentTag = currentTag;
//    teamTaskOptionViewController.delegate = self;
//    
//    [Tools layerTransition:self.navigationController.view from:@"right"];
//    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"height:%f",textView.contentSize.height);
    
    CGFloat totalheight = bodyTextView.contentSize.height;
    
    //    CGPoint center = viewCenter;
    
    //    float height = 116.0 + [Tools screenMaxHeight] - 480;
    //    if(totalheight > height)
    //    {
    //        CGFloat line = (totalheight - height) / 50.0;
    //
    //
    //        center.y -= 256 + 50 * line;
    //        center.y += 120.0f;
    //        self.view.center = center;
    //    }
    //    else {
    //        center.y -= 256;
    //        center.y += 120.0f;
    //        self.view.center = center;
    //    }
    
    //TODO:目前是无效的，后面处理
    [bodyScrollView setContentSize:bodyTextView.contentSize];
    
    CGRect rect = bodyCell.frame;
    rect.size.height = totalheight;
    bodyCell.frame = rect;
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    CGPoint center = viewCenter;
    NSLog(@"key:%f", keyboardRect.size.height);
    center.y -= keyboardRect.size.height;
    center.y += 120.0f;
    self.view.center = center;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    self.view.center = viewCenter;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (NSNumber*)getPriorityKey:(NSString*)priorityValue
{
    if([priorityValue isEqualToString:PRIORITY_TITLE_1])
        return [NSNumber numberWithInt:0];
    else if([priorityValue isEqualToString:PRIORITY_TITLE_2])
        return [NSNumber numberWithInt:1];
    else if([priorityValue isEqualToString:PRIORITY_TITLE_3])
        return [NSNumber numberWithInt:2];
    return [NSNumber numberWithInt:0];
}
- (NSString*)getPriorityValue:(NSString*)priorityKey
{
    if([priorityKey isEqualToString:@"0"])
        return PRIORITY_TITLE_1;
    else if([priorityKey isEqualToString:@"1"])
        return PRIORITY_TITLE_2;
    else if([priorityKey isEqualToString:@"2"])
        return PRIORITY_TITLE_3;
    return PRIORITY_TITLE_1;
}

//- (void)modifyAssignee:(NSString*)assignee
//{
//    currentAssigneeId = assignee;
//}
//- (void)modifyProjects:(NSString*)projects
//{
//    currentProjects = projects;
//}
//- (void)modifyTags:(NSString*)tags
//{
//    currentTags = tags;
//}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"TaskInfo"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:self.HUD];
            
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    
                    NSMutableDictionary *data = [dict objectForKey:@"data"];

                    NSString *taskId = [data objectForKey:@"id"];
                    NSString *subject = [data objectForKey:@"subject"];
                    NSString *body = [data objectForKey:@"body"];
//                    NSMutableDictionary *creatorDict = [data objectForKey:@"creator"];
                    NSMutableDictionary *assigneeDict = [data objectForKey:@"assignee"];
                    NSString *assigneeName = [assigneeDict objectForKey:@"displayname"];
                    NSString *assigneeUserId = [assigneeDict objectForKey:@"id"];
//                    NSMutableDictionary *related = [data objectForKey:@"related"];
                    NSString *dueTime = [data objectForKey:@"duetime"] == [NSNull null] ? @"" : [data objectForKey:@"duetime"];
                    NSString *priority = [data objectForKey:@"priority"] == [NSNull null] ? @"" : [data objectForKey:@"priority"];
                    NSNumber *isCompleted = [data objectForKey:@"isCompleted"];
                    
                    [taskDetailDict setObject:taskId forKey:@"taskId"];
                    [taskDetailDict setObject:subject forKey:@"subject"];
                    [taskDetailDict setObject:body forKey:@"body"];
                    [taskDetailDict setObject:dueTime forKey:@"dueTime"];
                    [taskDetailDict setObject:priority forKey:@"priority"];
                    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
                    [taskDetailDict setObject:assigneeName forKey:@"assigneeName"];
                    [taskDetailDict setObject:assigneeUserId forKey:@"assigneeUserId"];
                    
                    [detailView reloadData];
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
//            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeDueTime"]) {
        if(request.responseStatusCode == 200) {
//            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangePriority"]) {
        if(request.responseStatusCode == 200) {
//            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"UpdateTask"]) {
        if(request.responseStatusCode == 200) {
//            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

#pragma mark - 私有方法

- (void)initContentView
{
    self.title = @"任务编辑";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
//    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//    saveTaskBtn.layer.cornerRadius = 6.0f;
//    [saveTaskBtn.layer setMasksToBounds:YES];
//    [saveTaskBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
//    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
//    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
//    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    detailView = tempTableView;
    
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
    detailView.delegate = self;
    detailView.dataSource = self;
}

- (void)getTaskDetail
{
    self.HUD = [Tools process:LOADING_TITLE view:self.view];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"TaskInfo" forKey:REQUEST_TYPE];
    [enterpriseService getTaskDetail:currentTaskId context:context delegate:self];
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
	WebViewController *webViewController = [[[WebViewController alloc] init] autorelease];
	[webViewController setUrl:[link URL]];
	BaseNavigationController *navController = [[[BaseNavigationController alloc] initWithRootViewController:webViewController] autorelease];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
	[self presentModalViewController:navController animated:YES];
}

- (void)goBack:(id)sender
{
    //[commentTextField resignFirstResponder];

    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
