//
//  MapViewController.m
//  yelpper
//
//  Created by Amie Kweon on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//
//  Place placemarks on the map given the current location and an array of locations.
//  Reference: http://stackoverflow.com/questions/8283520/putting-a-clplacemark-on-map-in-ios-5
//
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Place.h"
#import "Utils.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.location && self.places.count > 0) {
        float distance = [Utils convertToMeter:0.5];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, distance, distance);
        [self.mapView setRegion:viewRegion];

        for (Place *place in self.places) {
            NSString *address = [place.displayAddress componentsJoinedByString:@","];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:address
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             if (placemarks && placemarks.count > 0) {
                                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
                                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];

                                 MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                                 point.coordinate = placemark.coordinate;
                                 point.title = place.name;
                                 point.subtitle = address;
                                 [self.mapView addAnnotation:point];
                             }
                         }];
        }
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(cancel)];
    self.navigationController.navigationBar.barTintColor = [Utils getYelpRed];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = backButton;
}
@end
