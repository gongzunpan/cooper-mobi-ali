//
//  EnterpriseTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskViewController.h"
#import "EnterpriseOptionViewController.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@implementation EnterpriseTaskViewController

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
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end