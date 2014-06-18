//
//  MapViewController.h
//  yelpper
//
//  Created by Amie Kweon on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *places;

@end
