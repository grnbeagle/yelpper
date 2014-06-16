//
//  Place.m
//  Yelp
//
//  Created by Amie Kweon on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Place.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "Utils.h"

@implementation Place

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"address": @"location.address",
             @"imageThumbUrl": @"image_url",
             @"imageRatingUrl": @"rating_img_url",
             @"category": @"categories"
             };
}

+ (NSArray *)getCategories {
    NSArray *categories = @[
                            @{@"name": @"Active Life", @"value": @"active"},
                            @{@"name": @"Arts & Entertainment", @"value": @"arts"},
                            @{@"name": @"Automotive", @"value": @"auto"},
                            @{@"name": @"Beauty & Spas", @"value": @"beautysvc"},
                            @{@"name": @"Bicycles", @"value": @"bicycles"},
                            @{@"name": @"Education", @"value": @"education"},
                            @{@"name": @"Event Planning & Services", @"value": @"eventservices"},
                            @{@"name": @"Financial Services", @"value": @"financialservices"},
                            @{@"name": @"Food", @"value": @"food"},
                            @{@"name": @"Health Markets", @"value": @"healthmarkets"},
                            @{@"name": @"Home Services", @"value": @"homeservices"},
                            @{@"name": @"Hotels & Travel", @"value": @"hotelstravel"},
                            @{@"name": @"Local Flavor", @"value": @"localflavor"},
                            @{@"name": @"Local Services", @"value": @"localservices"},
                            @{@"name": @"Mass Media", @"value": @"massmedia"},
                            @{@"name": @"Nightlife", @"value": @"nightlife"},
                            @{@"name": @"Pets", @"value": @"pets"},
                            @{@"name": @"Professional Services", @"value": @"professional"},
                            @{@"name": @"Public Relations", @"value": @"publicrelations"},
                            @{@"name": @"Real Estate", @"value": @"realestate"},
                            @{@"name": @"Religious Organizations", @"value": @"religiousorgs"},
                            @{@"name": @"Restaurants", @"value": @"restaurants"},
                            @{@"name": @"Shopping", @"value": @"shopping"}
                            ];
    return categories;
}

+ (NSArray *)getDistanceOptions {
    NSArray *options = @[
                          @{@"name": @"Auto", @"value": @"auto"},
                          @{@"name": @"1 mile", @"value": [NSString stringWithFormat:@"%i", [Utils converToMeter:1]]},
                          @{@"name": @"5 miles", @"value": [NSString stringWithFormat:@"%i", [Utils converToMeter:5]]},
                          @{@"name": @"10 miles", @"value": [NSString stringWithFormat:@"%i", [Utils converToMeter:10]]},
                          @{@"name": @"20 miles", @"value": [NSString stringWithFormat:@"%i", [Utils converToMeter:20]]}
                          ];
    return options;
}

+ (NSArray *)getSortOptions {
    NSArray *options = @[
                          @{@"name": @"Best match", @"value": @"0"},
                          @{@"name": @"Distance", @"value": @"1"},
                          @{@"name": @"Highest rated", @"value": @"2"}
                          ];
    return options;
}
@end
