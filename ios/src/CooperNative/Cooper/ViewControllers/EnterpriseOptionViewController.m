//
//  EnterpriseOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseOptionViewController.h"
#import "BaseNavigationController.h"

#define AUDIO_OPTION    @"随口记"
#define TASK_OPTION     @"随手派"
#define LIST_OPTION     @"查看任务"

@implementation EnterpriseOptionViewController

@synthesize infoView;
@synthesize menuScrollView;
@synthesize taskBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [infoView release];
    [menuScrollView release];
    [taskBarController release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma 私有方法

- (void)initContentView
{
    //TODO:导航下拉动画效果制作
    //TODO:封装UILabel效果
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 100)];
    infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
    [self.view addSubview:infoView];

    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor whiteColor];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = UITextAlignmentCenter;
    label1.frame = CGRectMake(0, 10, [Tools screenMaxWidth], 50.0);
    label1.font = [UIFont boldSystemFontOfSize:20.0f];
    label1.text = @"随口派活";
    [infoView addSubview:label1];
    [label1 release];

    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = UITextAlignmentCenter;
    label2.frame = CGRectMake(0, 40, [Tools screenMaxWidth], 50.0);
    label2.font = [UIFont systemFontOfSize:20.0f];
    label2.text = @"说句话，拍个照，活就派出去了！";
    [infoView addSubview:label2];
    [label2 release];

    menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 100.0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 100.0)];

    //TODO:图片替换掉
    UIButton *button1 = [self getTypeButtonWithImage:[UIImage imageNamed:@"decider_icon.png"] withTitle:AUDIO_OPTION];
    [menuScrollView addSubview:button1];
    UIButton *button2 = [self getTypeButtonWithImage:[UIImage imageNamed:@"decider_icon.png"] withTitle:TASK_OPTION];
    [menuScrollView addSubview:button2];
    UIButton *button3 = [self getTypeButtonWithImage:[UIImage imageNamed:@"decider_icon.png"] withTitle:LIST_OPTION];
    [menuScrollView addSubview:button3];

    button1.frame = CGRectMake(0, 10, button1.frame.size.width, button1.frame.size.height);
    button2.frame = CGRectMake(110, 10, button2.frame.size.width, button2.frame.size.height);
    button3.frame = CGRectMake(220, 10, button3.frame.size.width, button3.frame.size.height);

    menuScrollView.backgroundColor = [UIColor whiteColor];
    //menuScrollView.contentSize = self.view.frame.size;

    [self.view addSubview:menuScrollView];
}

- (UIButton*) getTypeButtonWithImage:(UIImage*)image withTitle:(NSString*)title{

    UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 120)]autorelease];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor colorWithRed:136/255.0f green:142/255.0f blue:160/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    //[btn setTitleColor:[UIColor colorWithRed:103/255.0f green:115/255.0f blue:138/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setShadowColor:[UIColor whiteColor]];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

    // the space between the image and text
    CGFloat spacing = 6.0;

    // get the size of the elements here for readability
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake( 25.0, 24.0, 45.0, 26.0);
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake( 10.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0 );

    [btn addTarget:self action:@selector(chooseMenu:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void) chooseMenu:(UIButton*)sender
{
    if([sender.titleLabel.text isEqualToString:AUDIO_OPTION]) {
        
    }
    else if([sender.titleLabel.text isEqualToString:TASK_OPTION]) {

    }
    else if([sender.titleLabel.text isEqualToString:LIST_OPTION]) {
        if (taskBarController == nil)
        {
            taskBarController = [[UITabBarController alloc] init];

            AssigneeTaskViewController *assigneeTaskViewController = [[AssigneeTaskViewController alloc] initWithNibName:@"AssigneeTaskViewController" bundle:nil setTitle:@"我的任务" setImage:@"task.png"];
            BaseNavigationController *assigneeNavController = [[BaseNavigationController alloc] initWithRootViewController:assigneeTaskViewController];

            RelatedTaskViewController *relatedTaskViewController = [[RelatedTaskViewController alloc] initWithNibName:@"RelatedTaskViewController" bundle:nil setTitle:@"相关任务" setImage:@"complete.png"];
            BaseNavigationController *relatedNavController = [[BaseNavigationController alloc] initWithRootViewController:relatedTaskViewController];
            if(MODEL_VERSION > 5.0)
            {
                [taskBarController.tabBar setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
                [taskBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selectedbg.png"]];
            }
            else {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
                [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 49)];
                [taskBarController.tabBar insertSubview:imageView atIndex:0];
            }
            taskBarController.viewControllers = [NSArray arrayWithObjects:assigneeNavController, relatedNavController, nil];
            [assigneeTaskViewController release];
            [relatedTaskViewController release];
            [assigneeNavController release];
            [relatedNavController release];
        }
        [self presentModalViewController:taskBarController animated:YES];
    }
}

@end
