//
//  Utils.m
//  yelpper
//
//  Created by Amie Kweon on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Utils.h"
#import "UIImageView+AFNetworking.h"

@implementation Utils

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
    NSURL *urlObject = [NSURL URLWithString:url];
    __weak UIImageView *iv = imageView;
    
    [imageView
     setImageWithURLRequest:[NSURLRequest requestWithURL:urlObject]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         BOOL isCached = (request == nil);
         if (!isCached && enableAnimation) {
             iv.alpha = 0.0;
             iv.image = image;
             [UIView animateWithDuration:0.5
                              animations:^{
                                  iv.alpha = 1.0;
                              }];
         } else {
             iv.image = image;
         }
     }
     failure:nil];
}

+ (UIColor *)getColorFrom:(CGFloat [3])rgb {
    return [UIColor colorWithRed:rgb[0]/255.0f green:rgb[1]/255.0f blue:rgb[2]/255.0f alpha:1];
}

+ (float)convertToMeter:(float)miles {
    return miles * 1609;
}

+ (float)convertToMiles:(float)meters {
    return meters / 1609;
}

+ (UIColor *)getYelpRed {
    CGFloat colors[3] ={196.0, 18.0, 0.0};
    return [Utils getColorFrom:colors];
}
@end
