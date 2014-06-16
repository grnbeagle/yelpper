//
//  Place.h
//  Yelp
//
//  Created by Amie Kweon on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Place : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSString *imageThumbUrl;
@property (nonatomic, strong) NSString *imageRatingUrl;
@property (nonatomic, strong) NSArray *category;

+ (NSArray *)getCategories;
+ (NSArray *)getDistanceOptions;
+ (NSArray *)getSortOptions;
@end
