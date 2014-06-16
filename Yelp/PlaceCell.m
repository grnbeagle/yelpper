//
//  PlaceCell.m
//  yelpper
//
//  Created by Amie Kweon on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "PlaceCell.h"
#import "Utils.h"

@implementation PlaceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlace:(Place *)place {
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address[0];
    [Utils loadImageUrl:place.imageThumbUrl inImageView:self.thumbImage withAnimation:YES];
    [Utils loadImageUrl:place.imageRatingUrl inImageView:self.ratingImage withAnimation:YES];
    self.categoryLabel.text = place.category[0][0];

//    [self.nameLabel sizeToFit];
//    [self.addressLabel sizeToFit];
//    [self.thumbImage sizeToFit];
//    [self.ratingImage sizeToFit];
//    [self.categoryLabel sizeToFit];
}
@end
