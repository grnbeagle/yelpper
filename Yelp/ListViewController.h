//
//  ListViewController.h
//  yelpper
//
//  Created by Amie Kweon on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchFilterDelegate>

@property (nonatomic, strong) NSDictionary *filterSelection;

@end
