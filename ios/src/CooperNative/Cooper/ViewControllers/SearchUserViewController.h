//
//  SearchUserViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EnterpriseTaskCreateDelegate.h"
#import "CooperService/EnterpriseService.h"

@interface SearchUserViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITextField *searchText;
    
    UITableView *filterView;
    NSInteger currentIndex;

    EnterpriseService *enterpriseService;
}

@property (nonatomic, assign) id<EnterpriseTaskCreateDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *filterOptionArray;

@end
