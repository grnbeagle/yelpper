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
             @"displayAddress": @"location.display_address",
             @"imageThumbUrl": @"image_url",
             @"imageRatingUrl": @"rating_img_url",
             @"category": @"categories",
             @"distance": @"distance",
             @"reviewCount": @"review_count"
             };
}

+ (NSArray *)getCategories {
    NSArray *categories = @[
      @{@"name": @"American (New)", @"value": @"newamerican"},
      @{@"name": @"American (Traditional)", @"value": @"tradamerican"},
      @{@"name": @"Argentine", @"value": @"argentine"},
      @{@"name": @"Asian Fusion", @"value": @"asianfusion"},
      @{@"name": @"Australian", @"value": @"australian"},
      @{@"name": @"Austrian", @"value": @"austrian"},
      @{@"name": @"Beer Garden", @"value": @"beergarden"},
      @{@"name": @"Belgian", @"value": @"belgian"},
      @{@"name": @"Brazilian", @"value": @"brazilian"},
      @{@"name": @"Breakfast & Brunch", @"value": @"breakfast_brunch"},
      @{@"name": @"Buffets", @"value": @"buffets"},
      @{@"name": @"Burgers", @"value": @"burgers"},
      @{@"name": @"Burmese", @"value": @"burmese"},
      @{@"name": @"Cafes", @"value": @"cafes"},
      @{@"name": @"Cajun/Creole", @"value": @"cajun"},
      @{@"name": @"Canadian", @"value": @"newcanadian"},
      @{@"name": @"Chinese", @"value": @"chinese"},
      @{@"name": @"Cantonese", @"value": @"cantonese"},
      @{@"name": @"Dim Sum", @"value": @"dimsum"},
      @{@"name": @"Cuban", @"value": @"cuban"},
      @{@"name": @"Diners", @"value": @"diners"},
      @{@"name": @"Dumplings", @"value": @"dumplings"},
      @{@"name": @"Ethiopian", @"value": @"ethiopian"},
      @{@"name": @"Fast Food", @"value": @"hotdogs"},
      @{@"name": @"French", @"value": @"french"},
      @{@"name": @"German", @"value": @"german"},
      @{@"name": @"Greek", @"value": @"greek"},
      @{@"name": @"Indian", @"value": @"indpak"},
      @{@"name": @"Indonesian", @"value": @"indonesian"},
      @{@"name": @"Irish", @"value": @"irish"},
      @{@"name": @"Italian", @"value": @"italian"},
      @{@"name": @"Japanese", @"value": @"japanese"},
      @{@"name": @"Jewish", @"value": @"jewish"},
      @{@"name": @"Korean", @"value": @"korean"},
      @{@"name": @"Venezuelan", @"value": @"venezuelan"},
      @{@"name": @"Malaysian", @"value": @"malaysian"},
      @{@"name": @"Pizza", @"value": @"pizza"},
      @{@"name": @"Russian", @"value": @"russian"},
      @{@"name": @"Salad", @"value": @"salad"},
      @{@"name": @"Scandinavian", @"value": @"scandinavian"},
      @{@"name": @"Seafood", @"value": @"seafood"},
      @{@"name": @"Turkish", @"value": @"turkish"},
      @{@"name": @"Vegan", @"value": @"vegan"},
      @{@"name": @"Vegetarian", @"value": @"vegetarian"},
      @{@"name": @"Vietnamese", @"value": @"vietnamese"}
    ];
    return categories;
}

+ (NSArray *)getDistanceOptions {
    NSArray *options = @[
      @{@"name": @"Auto", @"value": @"auto"},
      @{@"name": @"1 mile", @"value": [NSString stringWithFormat:@"%g", [Utils convertToMeter:1]]},
      @{@"name": @"5 miles", @"value": [NSString stringWithFormat:@"%g", [Utils convertToMeter:5]]},
      @{@"name": @"10 miles", @"value": [NSString stringWithFormat:@"%g", [Utils convertToMeter:10]]},
      @{@"name": @"20 miles", @"value": [NSString stringWithFormat:@"%g", [Utils convertToMeter:20]]}
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
