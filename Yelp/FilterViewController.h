//
//  FilterViewController.h
//  yelpper
//
//  Created by Amie Kweon on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchFilterDelegate <NSObject>

-(void) filterSelectionDone:(NSDictionary *)filters;

@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SearchFilterDelegate> myDelegate;

@end
