//
//  ViewController.m
//  UVObjectiveC
//
//  Created by Matheus Garcia on 25/07/18.
//  Copyright © 2018 Matheus Garcia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];

    [locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *location = locations.firstObject;
    [self updateInfo:location];
    [locationManager stopUpdatingLocation];
}

- (void)updateInfo:(CLLocation *)location {
    NSString *locationText = [NSString stringWithFormat:@"lat: %f, lon: %f", location.coordinate.latitude, location.coordinate.longitude];
    locationLabel.text = locationText;
}

- (IBAction)updateWasPressed:(id)sender {
    [locationManager startUpdatingLocation];
}

@end
