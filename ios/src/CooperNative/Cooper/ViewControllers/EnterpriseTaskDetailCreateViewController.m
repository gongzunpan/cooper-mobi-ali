//
//  EnterpriseTaskDetailCreateViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailCreateViewController.h"
#import "CustomButton.h"

@implementation EnterpriseTaskDetailCreateViewController

//@synthesize dueDateLabel;
//@synthesize priorityButton;
//@synthesize statusButton;
//@synthesize subjectTextField;
//@synthesize bodyTextView;
//@synthesize bodyScrollView;
//@synthesize bodyCell;
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
    
    if(taskDetailDict == nil) {
        taskDetailDict = [[NSMutableDictionary alloc] init];
    }
//    [taskDetailDict setObject:@"" forKey:@"subject"];
//    [taskDetailDict setObject:@"" forKey:@"body"];
//    [taskDetailDict setObject:@"" forKey:@"dueTime"];
//    [taskDetailDict setObject:TEST_USERID forKey:@"assigneeUserId"];
//    [taskDetailDict setObject:[NSNumber numberWithInt:0] forKey:@"priority"];
//
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
        
//    viewCenter = self.view.center;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
}

- (void)dealloc
{
//    [enterpriseService release];
//    [taskDetailDict release];
//    [detailView release];
//    [subjectTextView release];
//    [assigneeView release];
//    [priorityControl release];
//    [priorityView release];
//    [dueTimeTextField release];
//    [dueTimeView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 私有方法

- (void)initContentView
{
    self.title = @"任务创建";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    CustomButton *saveTaskBtn = [[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(newTask:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [saveTaskBtn release];
    
    detailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 150) style:UITableViewStyleGrouped];
    detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.scrollEnabled = NO;
   
    detailView.dataSource = self;
    detailView.delegate = self;
    [self.view addSubview:detailView];
    
    assigneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, [Tools screenMaxWidth], 40)];
    assigneeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:assigneeView];
    assigneeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 270, 30)];
    assigneeTextField.placeholder = @"指派人";
    assigneeTextField.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *chooseUserImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooseuser.png"]];
    chooseUserImageView.frame = CGRectMake(0, 0, 16, 16);
    assigneeTextField.rightView = chooseUserImageView;
    assigneeTextField.rightViewMode = UITextFieldViewModeAlways; 
    chooseUserImageView.userInteractionEnabled = YES;
    [assigneeTextField addSubview:chooseUserImageView];
    [assigneeView addSubview:assigneeTextField];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUser:)];
    [assigneeTextField addGestureRecognizer:recognizer];
    [recognizer release];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down.png"]];
    moreImageView.frame = CGRectMake(285, 10, 26, 26);
    moreImageView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(more:)];
    [moreImageView addGestureRecognizer:recognizer];
    [recognizer release];
    [assigneeView addSubview:moreImageView];
    
    [moreImageView release];
    [chooseUserImageView release];
    [assigneeTextField release];
    [assigneeView release];
    
    priorityView = [[UIView alloc] initWithFrame:CGRectMake(0, 165, [Tools screenMaxWidth], 90)];
    [self.view addSubview:priorityView];
    
    UILabel *priorityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [Tools screenMaxWidth], 20)];
    priorityLabel.text = @"优先级";
    [priorityView addSubview:priorityLabel];
    [priorityLabel release];
    
    priorityControl = [[SEFilterControl alloc]initWithFrame:CGRectMake(10, 30, 300, 60)
                                                     Titles:[NSArray arrayWithObjects:@"尽快完成", @"稍后完成", @"迟些再说", nil]];
    [priorityControl setProgressColor:[UIColor lightGrayColor]];
    [priorityControl setHandlerColor:[UIColor darkGrayColor]];
    [priorityControl setTitlesColor:[UIColor blackColor]];
    priorityControl.SelectedIndex = 1;
    //[priorityControl setTitlesFont:[UIFont fontWithName:@"Didot" size:14]];
    //[priorityControl addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [priorityView addSubview:priorityControl];
                       
    dueTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, [Tools screenMaxWidth], 100)];
    [self.view addSubview:dueTimeView];
    
    UILabel *dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [Tools screenMaxWidth], 20)];
    dueTimeLabel.text = @"期待完成时间";
    [dueTimeView addSubview:dueTimeLabel];
    [dueTimeLabel release];
    
    dueTimeTextField = [[DateTextField alloc] initWithFrame:CGRectMake(10, 30, [Tools screenMaxWidth] - 20, 35)];
    dueTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    dueTimeTextField.placeholder = @"期待完成时间";
    [dueTimeView addSubview:dueTimeTextField];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newTask:(id)sender
{
    
}

- (void)chooseUser:(id)sender
{
    NSLog(@"chooseUser");
}

- (void)more:(id)sender
{
    [subjectTextView resignFirstResponder];
}

- (void)startPhoto:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"重新拍照", @"重新从相册选择",nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //拍照
            [self takePhoto];
            
            break;
        case 1:
            //拍照
            [self localPhoto];
            break;
        default:
            break;
    }
}

- (void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - TableView 事件源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == detailView) return 1;
    else if(tableView == assigneeView) return 1;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == detailView) return 1;
    else if(tableView == assigneeView) return 1;
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == detailView) {
        if(indexPath.section == 0 && indexPath.row == 0) {
            return 100.0f;
        }
    }
    return 35.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(tableView == detailView) {
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
                if(!cell) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
                if(attachmentId != nil) {
                    NSString *attachmentFileName = [taskDetailDict objectForKey:@"attachmentFileName"];
                    NSString *attachmentThumbUrl = [taskDetailDict objectForKey:@"attachmentThumbUrl"];
                    //cell.textLabel.text = attachmentFileName;
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.frame = CGRectMake(10, 10, 80, 80);
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPhoto:)];
                    [imageView addGestureRecognizer:recognizer];
                    [recognizer release];
                    [imageView setImageWithURL:[NSURL URLWithString:attachmentThumbUrl]];
                    [cell.contentView addSubview:imageView];
                    [imageView release];
                    
                    subjectTextView = [[GCPlaceholderTextView alloc] init];
                    subjectTextView.placeholder = @"补充点什么";
                    subjectTextView.frame = CGRectMake(95, 10, cell.frame.size.width - 125, 80);
                    [cell.contentView addSubview:subjectTextView];
                    
                    [subjectTextView becomeFirstResponder];
                    
                }
            }
        }
    }
    return cell;
}

////填充单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    
//    if(tableView == detailView)
//    {
//        if(indexPath.section == 0)
//        {
//            if(indexPath.row == 0) {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AttachmentCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttachmentCell"] autorelease];
//                }
//                NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
//                if(attachmentId != nil) {
//                    NSString *attachmentFileName = [taskDetailDict objectForKey:@"attachmentFileName"];
//                    NSString *attachmentThumbUrl = [taskDetailDict objectForKey:@"attachmentThumbUrl"];
//                    cell.textLabel.text = attachmentFileName;
//                    UIImageView *imageView = [[UIImageView alloc] init];
//                    imageView.frame = CGRectMake(0, 0, 40, 40);
//                    [imageView setImageWithURL:[NSURL URLWithString:attachmentThumbUrl]];
//                    [cell.contentView addSubview:imageView];
//                    
//                    //[cell.imageView setImageWithURL:[NSURL URLWithString:attachmentUrl]];
//                }
//            }
//            else if(indexPath.row == 1)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"DueDateCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DueDateCell"] autorelease];
//                    cell.textLabel.text = @"截至日期:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];
//                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    dueDateLabel = [[DateLabel alloc] initWithFrame:CGRectZero];
//                    //                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
//                    [self.dueDateLabel addGestureRecognizer:recog];
//                    self.dueDateLabel.delegate = self;
//                    [recog release];
//                    dueDateLabel.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        dueDateLabel.userInteractionEnabled = NO;
//                    //                    }
//                    [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
//                }
//
//                CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
//                CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//                [cell.contentView addSubview:dueDateLabel];
//            }
//            else if(indexPath.row == 2)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriorityCell"] autorelease];
//                    cell.textLabel.text = @"优先级:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    priorityButton = [[PriorityButton alloc] initWithFrame:CGRectZero];
//                    
//                    //                    if(![[task.editable stringValue] isEqualToString: [[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
//                    [priorityButton addGestureRecognizer:recog];
//                    priorityButton.delegate = self;
//                    [recog release];
//                    priorityButton.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        priorityButton.userInteractionEnabled = NO;
//                    //                    }
//                    
//                    [priorityButton setTitle:[NSString stringWithFormat:@"%@    >",PRIORITY_TITLE_1] forState:UIControlStateNormal];
//                }
//
//                CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
//                CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//                [cell.contentView addSubview:priorityButton];
//            }
//            else if(indexPath.row == 3)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AssigneeCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AssigneeCell"] autorelease];
//                    cell.textLabel.text = @"当前处理人:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    assigneeView = [[UIView alloc] initWithFrame:CGRectZero];
//                    //                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    assigneeView.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        assigneeView.userInteractionEnabled = NO;
//                    //                    }
//                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAssignee:)];
//                    [assigneeView addGestureRecognizer:recognizer];
//                    [recognizer release];
//                    [cell.contentView addSubview:assigneeView];
//                }
//                
//                NSString *assigneeName = TEST_USERDISPLAYNAME;
//                if(assigneeName != nil && ![assigneeName isEqualToString:@""])
//                {
//                    CustomButton *assigneeBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
//                    assigneeBtn.userInteractionEnabled = NO;
//                    [assigneeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [assigneeBtn setTitle:assigneeName forState:UIControlStateNormal];
//                    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
//                    CGSize labelsize = [assigneeBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                    CGFloat labelsizeHeight = labelsize.height + 10;
//                    assigneeBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
//                    [assigneeView addSubview:assigneeBtn];
//                    [assigneeBtn release];
//                    
//                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
//                    
//                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
//                }
//
////                if(task != nil)
////                {
////                    currentAssigneeId = task.assigneeId;
////                }
////
////                TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:currentAssigneeId];
////                if(teamMember != nil)
////                {
////                    currentAssigneeId = teamMember.id;
////
////                    CustomButton *memberBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
////                    memberBtn.userInteractionEnabled = NO;
////                    [memberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////                    [memberBtn setTitle:teamMember.name forState:UIControlStateNormal];
////                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
////                    CGSize labelsize = [memberBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
////                    CGFloat labelsizeHeight = labelsize.height + 10;
////                    memberBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
////                    [assigneeView addSubview:memberBtn];
////                    [memberBtn release];
////
////                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
////
////                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
////                }
////                else
////                {
////                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
////                    label.textColor = [UIColor grayColor];
////                    label.text = @"none";
////                    [assigneeView addSubview:label];
////                    [label release];
////
////                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
////                }
//            }
//            else if(indexPath.row == 4)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectCell"] autorelease];
//                    cell.textLabel.text = @"标题:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, [Tools screenMaxWidth] - 120, 25)];
//                    subjectTextField.userInteractionEnabled = YES;
//                    [subjectTextField setReturnKeyType:UIReturnKeyDone];
//                    [subjectTextField setTextAlignment:UITextAlignmentLeft];
//                    [subjectTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//                    [subjectTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//                    [subjectTextField setPlaceholder:@"标题"];
//                    [subjectTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//                    [cell.contentView addSubview:subjectTextField];
//                }
//                
//            }
//            else if(indexPath.row == 5)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"BodyCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BodyCell"] autorelease];
//                    
//                    bodyTextView = [[BodyTextView alloc] initWithFrame:self.view.frame];
//                    bodyTextView.userInteractionEnabled = YES;
//                    [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//                    [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
//                    bodyTextView.returnKeyType = UIReturnKeyDefault;
//                    bodyTextView.keyboardType = UIReturnKeyDone;
//                    bodyTextView.scrollEnabled = YES;
//                    bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                    bodyTextView.delegate = self;
//                    bodyTextView.bodyDelegate = self;
//                    [bodyTextView setFont:[UIFont systemFontOfSize:16]];
//                    
//                    bodyScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)] autorelease];
//                    [bodyScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//                    [bodyScrollView setContentSize:bodyTextView.frame.size];
//                    [bodyScrollView addSubview:bodyTextView];
//                    
//                    [cell addSubview:bodyScrollView];
//                    
//                    bodyCell = cell;
//                }
//                
//                int totalheight = bodyTextView.contentSize.height;
//                [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalheight + 200)];
//            }
//        }
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}
//
//- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
//{
//    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
//    
//    NSString *dueTime = [value copy];
//    [taskDetailDict setObject:dueTime forKey:@"dueTime"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//    
//    //    [delegate loadTaskData];
//}
//
//- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
//{
//    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
//    NSNumber *priority = [self getPriorityKey:value];
//    [taskDetailDict setObject:priority forKey:@"priority"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//}
//
//-(void)textFieldDoneEditing:(id)sender
//{
//    NSString *subject = self.subjectTextField.text;
//    [taskDetailDict setObject:subject forKey:@"subject"];
//
//    [sender resignFirstResponder];
//}
//
//- (void)returnData
//{
//    NSString *body = bodyTextView.text;
//    [taskDetailDict setObject:body forKey:@"body"];
//}
//
//- (void)selectDueDate
//{
//    [self.dueDateLabel becomeFirstResponder];
//}
//
//- (void)selectPriority
//{
//    [self.priorityButton becomeFirstResponder];
//}
//
//- (BOOL)taskIsFinish
//{
//    return [statusButton.titleLabel.text isEqualToString:@"完成    >"];
//}
//
//- (void)switchStatus
//{
//    //    if([[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//    //        return;
//    
//    bool isfinish;
//    if([statusButton.titleLabel.text isEqualToString:@"未完成    >"])
//    {
//        [statusButton setTitle:@"完成    >" forState:UIControlStateNormal];
//        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_green.png"] forState:UIControlStateNormal];
//        [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        isfinish = YES;
//        
//    }
//    else
//    {
//        [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
//        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray.png"] forState:UIControlStateNormal];
//        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        isfinish = NO;
//    }
//    
//    NSNumber *isCompleted = [NSNumber numberWithInt: isfinish ? 1 : 0];
//    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//}
//
//- (void)selectAssignee:(id)sender
//{
//    //    if (teamTaskOptionViewController == nil)
//    //    {
//    //        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
//    //    }
//    //
//    //    teamTaskOptionViewController.currentTask = task;
//    //    teamTaskOptionViewController.selectMultiple = NO;
//    //    teamTaskOptionViewController.optionType = 1;
//    //    teamTaskOptionViewController.currentTeamId = currentTeamId;
//    //    teamTaskOptionViewController.currentProjectId = currentProjectId;
//    //    teamTaskOptionViewController.currentMemberId = currentMemberId;
//    //    teamTaskOptionViewController.currentTag = currentTag;
//    //    teamTaskOptionViewController.delegate = self;
//    //
//    //    [Tools layerTransition:self.navigationController.view from:@"right"];
//    //    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
//}
//
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"height:%f",textView.contentSize.height);
//    
//    CGFloat totalheight = bodyTextView.contentSize.height;
//    
//    //    CGPoint center = viewCenter;
//    
//    //    float height = 116.0 + [Tools screenMaxHeight] - 480;
//    //    if(totalheight > height)
//    //    {
//    //        CGFloat line = (totalheight - height) / 50.0;
//    //
//    //
//    //        center.y -= 256 + 50 * line;
//    //        center.y += 120.0f;
//    //        self.view.center = center;
//    //    }
//    //    else {
//    //        center.y -= 256;
//    //        center.y += 120.0f;
//    //        self.view.center = center;
//    //    }
//    
//    //TODO:目前是无效的，后面处理
//    [bodyScrollView setContentSize:bodyTextView.contentSize];
//    
//    CGRect rect = bodyCell.frame;
//    rect.size.height = totalheight;
//    bodyCell.frame = rect;
//    
//    return YES;
//}
//
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval animationDuration =
//	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    CGPoint center = viewCenter;
//    NSLog(@"key:%f", keyboardRect.size.height);
//    center.y -= keyboardRect.size.height;
//    center.y += 120.0f;
//    self.view.center = center;
//    [UIView setAnimationDuration:animationDuration];
//    [UIView commitAnimations];
//}
//
//- (void)keyboardWillHide:(NSNotification *)aNotification
//{
//    NSTimeInterval animationDuration =
//	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    self.view.center = viewCenter;
//    [UIView setAnimationDuration:animationDuration];
//    [UIView commitAnimations];
//}
//- (NSNumber*)getPriorityKey:(NSString*)priorityValue
//{
//    if([priorityValue isEqualToString:PRIORITY_TITLE_1])
//        return [NSNumber numberWithInt:0];
//    else if([priorityValue isEqualToString:PRIORITY_TITLE_2])
//        return [NSNumber numberWithInt:1];
//    else if([priorityValue isEqualToString:PRIORITY_TITLE_3])
//        return [NSNumber numberWithInt:2];
//    return [NSNumber numberWithInt:0];
//}
//- (NSString*)getPriorityValue:(NSString*)priorityKey
//{
//    if([priorityKey isEqualToString:@"0"])
//        return PRIORITY_TITLE_1;
//    else if([priorityKey isEqualToString:@"1"])
//        return PRIORITY_TITLE_2;
//    else if([priorityKey isEqualToString:@"2"])
//        return PRIORITY_TITLE_3;
//    return PRIORITY_TITLE_1;
//}
//
////- (void)modifyAssignee:(NSString*)assignee
////{
////    currentAssigneeId = assignee;
////}
////- (void)modifyProjects:(NSString*)projects
////{
////    currentProjects = projects;
////}
////- (void)modifyTags:(NSString*)tags
////{
////    currentTags = tags;
////}
//
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateTaskAttach"])
    {
        if(request.responseStatusCode == 200)
        {
            self.title = @"创建任务";
            
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    NSString *attachmentId = [data objectForKey:@"attachmentId"];
                    NSString *attachmentFileName = [data objectForKey:@"fileName"];
                    NSString *attachmentUrl = [data objectForKey:@"url"];
                    NSString *attachmentThumbUrl = [data objectForKey:@"thumbUrl"];

                    [taskDetailDict setObject:attachmentId forKey:@"attachmentId"];
                    [taskDetailDict setObject:attachmentFileName forKey:@"attachmentFileName"];
                    [taskDetailDict setObject:attachmentUrl forKey:@"attachmentUrl"];
                    [taskDetailDict setObject:attachmentThumbUrl forKey:@"attachmentThumbUrl"];
                
                    [detailView reloadData];
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
    else if([requestType isEqualToString:@"CreateTask"]) {
        if(request.responseStatusCode == 200) {
            [Tools failed:self.HUD msg:@"创建成功"];
            [self goBack:nil];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}
//
//#pragma mark - 私有方法
//
//- (void)initContentView
//{
//    self.title = @"任务编辑";
//    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
//    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    
//    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//    saveTaskBtn.layer.cornerRadius = 6.0f;
//    [saveTaskBtn.layer setMasksToBounds:YES];
//    [saveTaskBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
//    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
//    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
//    self.navigationItem.rightBarButtonItem = saveButton;
//    
//    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
//    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
//    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [tempTableView setBackgroundColor:[UIColor whiteColor]];
//    
//    //去掉底部空白
//    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//    tempTableView.tableFooterView = footer;
//    
//    detailView = tempTableView;
//    
//    [detailView setAllowsSelection:NO];
//    
//    [self.view addSubview: detailView];
//    detailView.delegate = self;
//    detailView.dataSource = self;
//}
//
//- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
//{
//	WebViewController *webViewController = [[[WebViewController alloc] init] autorelease];
//	[webViewController setUrl:[link URL]];
//	BaseNavigationController *navController = [[[BaseNavigationController alloc] initWithRootViewController:webViewController] autorelease];
//	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
//	[navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    
//	[self presentModalViewController:navController animated:YES];
//}
//
//- (void)goBack:(id)sender
//{
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (void)saveTask:(id)sender
//{
//    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
//    NSString *assigneeUserId = [taskDetailDict objectForKey:@"assigneeUserId"];
//    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
//    
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:self.HUD];
//    
//    NSMutableDictionary *context = [NSMutableDictionary dictionary];
//    [context setObject:@"CreateTask" forKey:REQUEST_TYPE];
//    
//    [enterpriseService createTask:TEST_USERID
//                          subject:subjectTextField.text
//                             body:bodyTextView.text
//                          dueTime:dueTime
//                   assigneeUserId:assigneeUserId
//                  relatedUserJson:@""
//                         priority:priority
//                          context:context
//                         delegate:self];
//}

#pragma Delegate method UIImagePickerControllerDelegate

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    NSLog(@"cancel camara.");
//}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    if (image != nil) {
        
        NSData *data;
        NSString *fileName;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像
            data = UIImagePNGRepresentation(image);
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools stringWithUUID], @"png"];
        }
        else {
            //返回为JPEG图像
            data = UIImageJPEGRepresentation(image, 1.0);
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools stringWithUUID], @"jpg"];
        }
        //保存到阿里云盘
        self.title = @"图片上传中...";
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"CreateTaskAttach" forKey:REQUEST_TYPE];
        [enterpriseService createTaskAttach:data
                                   fileName:fileName
                                       type:@"picture"
                                    context:context
                                   delegate:self];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

@end
