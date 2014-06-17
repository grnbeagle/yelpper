//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//
//  For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//
#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                               withFilters:(NSDictionary *)filters
                                atLocation:(CLLocation *)location
                                withOffset:(NSInteger)offset
                                   success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (offset > 0) {
        parameters[@"offset"] = [NSString stringWithFormat:@"%d", offset];
    }
    [parameters addEntriesFromDictionary:@{@"term": term,
                                           @"ll": [NSString stringWithFormat:@"%f,%f",
                                                    location.coordinate.latitude,
                                                    location.coordinate.longitude]}];
    [parameters addEntriesFromDictionary:filters];

    NSLog(@"%@", parameters);
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}
@end
