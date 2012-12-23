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
@synthesize dueTimeLabel;
@synthesize creatorLabel;
@synthesize iconsView;

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
    [dueTimeLabel release];
    [creatorLabel release];
    [iconsView release];
    [leftView release];
    [enterpriseService release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCompletedAction:(id)sender
{
    NSNumber *isExternal = [taskInfoDict objectForKey:@"isExternal"];
    NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
    NSString *taskId = [taskInfoDict objectForKey:@"id"];
    if([isExternal isEqualToNumber: [NSNumber numberWithInt:1]]) {
        return;
    }
    if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]]) {
        self.imageView.image = [UIImage imageNamed:@"notcompleted.png"];
        isCompleted = [NSNumber numberWithInt:0];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"completed.png"];
        isCompleted = [NSNumber numberWithInt:1];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    
    //更新完成状态
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeTaskCompleted" forKey:REQUEST_TYPE];
    [enterpriseService changeTaskCompleted:taskId isCompleted:isCompleted context:context delegate:delegate];
}

# pragma 私有方法

- (void)initContentView
{
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dueTimeLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dueTimeLabel setFont:[UIFont systemFontOfSize:14]];
    dueTimeLabel.textColor = [UIColor grayColor];
    
    creatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [creatorLabel setLineBreakMode:UILineBreakModeWordWrap];
    creatorLabel.font = [UIFont systemFontOfSize:12];
    creatorLabel.textColor = [UIColor grayColor];

    [self.contentView addSubview:subjectLabel];
    [self.contentView addSubview:dueTimeLabel];
    [self.contentView addSubview:creatorLabel];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCompletedAction:)];
    tapped.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapped];
}

- (void) setTaskInfo:(NSMutableDictionary*)taskInfo
{
    self.taskInfoDict = taskInfo;

    NSString *statusImageStr = @"";
    NSNumber *isExternal = [taskInfoDict objectForKey:@"isExternal"];
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:1]]) {
        statusImageStr = @"external.png";
    }
    else {
        statusImageStr = @"notcompleted.png";
    }
    UIImage* image = [UIImage imageNamed:statusImageStr];

    self.imageView.image = image;
    self.imageView.userInteractionEnabled = YES;
    
    enterpriseService = [[EnterpriseService alloc] init];

    if([isExternal isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.imageView.image = [UIImage imageNamed:@"external.png"];
    }
    else {
        NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
        
        if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]])
        {
            self.imageView.image = [UIImage imageNamed:@"completed.png"];
        }
        else {
            self.imageView.image = [UIImage imageNamed:@"notcompleted.png"];
        }
    }

    NSNumber *attachmentCount = [taskInfoDict objectForKey:@"attachmentCount"];
    NSNumber *picCount = [taskInfoDict objectForKey:@"picCount"];
    CGFloat textWidth = self.bounds.size.width - 70;
    CGFloat textLeft = 40;
    if([attachmentCount intValue] + [picCount intValue] > 0) {
        textWidth -= 25;
        textLeft += 25;
    }

    CGFloat totalHeight = 0;
    
    NSString *subject = [taskInfoDict objectForKey:@"subject"];
    subjectLabel.text = subject;
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font
                                            constrainedToSize:CGSizeMake(textWidth, MAX_HEIGHT)
                                                lineBreakMode:UILineBreakModeWordWrap];
    CGFloat subjectLabelHeight = subjectLabelSize.height;
    int subjectlines = subjectLabelHeight / 16;
    subjectLabel.frame = CGRectMake(textLeft, PADDING, textWidth, subjectLabelHeight);
    subjectLabel.numberOfLines = subjectlines;
    totalHeight += subjectLabelHeight + PADDING;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd"];
    NSString* dueTime = [taskInfoDict objectForKey:@"dueTime"];
    
    if(![dueTime isEqualToString:@""])
    {
        NSDate *dueDate = [Tools NSStringToShortNSDate:dueTime];
        dueTimeLabel.text = [formatter stringFromDate:dueDate];
        [dueTimeLabel setFrame:CGRectMake(textLeft, totalHeight + PADDING, textWidth, 20)];

        totalHeight += 20 + PADDING;
    }
    
    CGFloat tagHeight = totalHeight;
    
    NSString *creatorDisplayName = [taskInfoDict objectForKey:@"creatorDisplayName"];
    
    if(![creatorDisplayName isEqualToString:@""]) {

        creatorLabel.text = creatorDisplayName;
        
        CGSize creatorLabelSize = [creatorLabel.text sizeWithFont:creatorLabel.font
                                                      constrainedToSize:CGSizeMake(textWidth, MAX_HEIGHT)
                                                          lineBreakMode:UILineBreakModeWordWrap];
        CGFloat creatorLabelHeight = creatorLabelSize.height;
        if(creatorLabelHeight == 0.0f)
        {
            
        }
        else
        {
            int creatorlines = creatorLabelHeight / 12;
            
            creatorLabel.frame = CGRectMake(textLeft, totalHeight + PADDING, textWidth, creatorLabelHeight);
            creatorLabel.numberOfLines = creatorlines;
            tagHeight = totalHeight + PADDING;
            totalHeight += creatorLabelHeight + PADDING;
        }
    }

    if(totalHeight < 50)
        totalHeight = 50;

    totalHeight += PADDING;
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight)];
    [leftView setFrame:CGRectMake(0, 0, 40, totalHeight)];

    if([attachmentCount intValue] + [picCount intValue] > 0) {
        iconsView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 20, totalHeight)];

        CGFloat iconHeight = 0;
        if([picCount intValue] > 0) {
            UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.png"]];
            picImageView.frame = CGRectMake(0,iconHeight + 2 * PADDING,16,16);
            [iconsView addSubview:picImageView];
            iconHeight += 20;
        }
        if([attachmentCount intValue] > 0) {
            UIImageView *audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio.png"]];
            audioImageView.frame = CGRectMake(0, iconHeight + 2 * PADDING, 16, 16);
            [iconsView addSubview:audioImageView];
            iconHeight += 20;
        }
        [self.contentView addSubview:iconsView];
    }
}

@end
