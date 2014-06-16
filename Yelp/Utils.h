//
//  Utils.h
//  yelpper
//
//  Created by Amie Kweon on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation;

+ (UIColor *)getColorFrom:(CGFloat [3])rgb;

+ (NSInteger)converToMeter:(NSInteger)miles;
@end
