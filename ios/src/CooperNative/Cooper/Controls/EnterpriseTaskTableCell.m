//
//  EnterpriseTaskTableCell.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskTableCell.h"
#import "FillLabelView.h"

#define PADDING         5.0f
#define CONTENT_WIDTH   200.0f
#define MAX_HEIGHT      10000.0f
#define BODY_MAX_LINE   3

@implementation EnterpriseTaskTableCell

@synthesize taskInfoDict;
@synthesize subjectLabel;
@synthesize bodyLabel;
@synthesize dueTimeLabel;
@synthesize creatorLabel;

@synthesize statusButton;
@synthesize leftView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (void)dealloc
{
    [subjectLabel release];
    [bodyLabel release];
    [dueTimeLabel release];
    [creatorLabel release];
    [leftView release];
    [statusButton release];
    [enterpriseService release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCompletedAction:(id)sender
{
    NSNumber *isEditable = [taskInfoDict objectForKey:@"isEditable"];
    NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
    NSString *taskId = [taskInfoDict objectForKey:@"taskId"];
    if([isEditable isEqualToNumber: [NSNumber numberWithInt:0]]) {
        return;
    }
    if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]]) {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
        isCompleted = [NSNumber numberWithInt:0];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    else {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
        isCompleted = [NSNumber numberWithInt:1];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    
    //更新完成状态
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeCompleted" forKey:REQUEST_TYPE];
    [enterpriseService changeCompleted:taskId isCompleted:isCompleted context:context delegate:delegate];
}

# pragma 私有方法

- (void)initContentView
{
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [bodyLabel setLineBreakMode:UILineBreakModeWordWrap];
    [bodyLabel setFont:[UIFont systemFontOfSize:14]];
    [bodyLabel setTextColor:[UIColor lightGrayColor]];
    
    dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dueTimeLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dueTimeLabel setFont:[UIFont systemFontOfSize:14]];
    [dueTimeLabel setTextColor:APP_BACKGROUNDCOLOR];
    
    creatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [creatorLabel setLineBreakMode:UILineBreakModeWordWrap];
    creatorLabel.font = [UIFont systemFontOfSize:12];
    creatorLabel.textColor = APP_BACKGROUNDCOLOR;
    
    [self.contentView addSubview:subjectLabel];
    [self.contentView addSubview:bodyLabel];
    [self.contentView addSubview:dueTimeLabel];
    [self.contentView addSubview:creatorLabel];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    statusButton = [[UIButton alloc] initWithFrame:CGRectMake(10, PADDING, 28, 17)];
    UIImage* image = [UIImage imageNamed:@"incomplete-small.png"];
    [statusButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.leftView addSubview:statusButton];
    
    self.leftView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCompletedAction:)];
    tapped.numberOfTapsRequired = 1;
    [self.leftView addGestureRecognizer:tapped];
    [tapped release];
    [self.contentView addSubview:self.leftView];
}

- (void) setTaskInfo:(NSMutableDictionary*)taskInfo
{
    self.taskInfoDict = taskInfo;
    
    enterpriseService = [[EnterpriseService alloc] init];
    
    NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
    
    if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]])
    {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
    }
    else {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
    }

    CGFloat totalHeight = 0;
    
    NSString *subject = [taskInfoDict objectForKey:@"subject"];
    subjectLabel.text = subject;
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font
                                            constrainedToSize:CGSizeMake(self.bounds.size.width - 100, MAX_HEIGHT)
                                                lineBreakMode:UILineBreakModeWordWrap];
    CGFloat subjectLabelHeight = subjectLabelSize.height;
    int subjectlines = subjectLabelHeight / 16;
    subjectLabel.frame = CGRectMake(50, PADDING, self.bounds.size.width - 100, subjectLabelHeight);
    subjectLabel.numberOfLines = subjectlines;
    totalHeight += subjectLabelHeight + PADDING;
    
    NSString *body = [taskInfoDict objectForKey:@"body"];
    bodyLabel.text = body;
    CGSize bodyLabelSize = [bodyLabel.text sizeWithFont:bodyLabel.font
                                      constrainedToSize:CGSizeMake(self.bounds.size.width - 50, MAX_HEIGHT)
                                          lineBreakMode:UILineBreakModeWordWrap];
    CGFloat bodyLabelHeight = bodyLabelSize.height;
    if(bodyLabelHeight == 0.0f){
        
    }
    else
    {
        int bodylines = bodyLabelHeight / 14;
        
        if(bodylines > 3)
        {
            bodylines = 3;
        }
        bodyLabel.frame = CGRectMake(50, totalHeight + PADDING, self.bounds.size.width - 100, bodylines * 14);
        bodyLabel.numberOfLines = bodylines;
        
        totalHeight += bodylines * 14 + PADDING;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd"];
    NSString* dueTime = [taskInfoDict objectForKey:@"dueTime"];
    
    if(![dueTime isEqualToString:@""])
    {
        NSDate *dueDate = [Tools NSStringToShortNSDate:dueTime];
        dueTimeLabel.text = [formatter stringFromDate:dueDate];
        [dueTimeLabel setFrame:CGRectMake(270  + [Tools screenMaxWidth] - 320, PADDING, 80, 20)];
    }
    
    CGFloat tagHeight = totalHeight;
    
    NSString *creator = [taskInfoDict objectForKey:@"creator"];
    
    if(![creator isEqualToString:@""]) {

        creatorLabel.text = creator;
        
        CGSize creatorLabelSize = [creatorLabel.text sizeWithFont:creatorLabel.font
                                                      constrainedToSize:CGSizeMake(self.bounds.size.width - 50, MAX_HEIGHT)
                                                          lineBreakMode:UILineBreakModeWordWrap];
        CGFloat creatorLabelHeight = creatorLabelSize.height;
        if(creatorLabelHeight == 0.0f)
        {
            
        }
        else
        {
            int creatorlines = creatorLabelHeight / 12;
            
            creatorLabel.frame = CGRectMake(50, totalHeight + PADDING, self.bounds.size.width - 50, creatorLabelHeight);
            creatorLabel.numberOfLines = creatorlines;
            tagHeight = totalHeight + PADDING;
            totalHeight += creatorLabelHeight + PADDING;
            
        }
    }
    
    //TODO:替代方案
    NSMutableArray *tags = [NSMutableArray array];
    [tags addObject:@"语音"];
    [tags addObject:@"图片"];
    CGFloat tagsWidth = tags.count * 40.0f;
    FillLabelView *fillLabelView = [[FillLabelView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] - tagsWidth, tagHeight, tagsWidth, 0)];
//    fillLabelView.layer.borderWidth = 1.0f;
//    fillLabelView.layer.borderColor = [[UIColor blueColor] CGColor];
    [fillLabelView bindTags:tags];
    [self.contentView addSubview:fillLabelView];
    [fillLabelView release];

    if(totalHeight < 50)
        totalHeight = 50;
    
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight + PADDING)];
    [leftView setFrame:CGRectMake(0, 0, 40, totalHeight + PADDING)];
}

@end
