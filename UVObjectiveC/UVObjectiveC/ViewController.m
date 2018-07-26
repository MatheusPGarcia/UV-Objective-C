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
    [self request:location];
    [locationManager stopUpdatingLocation];
}

- (void)updateInfo:(NSDictionary *)jsonDict {

    dispatch_sync(dispatch_get_main_queue(), ^{
        NSString *uv = jsonDict[@"result"][@"uv"];
        double result = [uv doubleValue];
        NSString *locationText = [NSString stringWithFormat:@"uv radiation: %.02f", result];
        self->locationLabel.text = locationText;
        [self setStatus:&result];
    });
}

- (void)request:(CLLocation *)location {

    NSString *urlString = [NSString stringWithFormat:@"https://api.openuv.io/api/v1/uv?lat=%f&lng=%f", location.coordinate.latitude, location.coordinate.longitude];
    NSString *key = @"c3b27e3623430b041a771d2b9e6af652";
    NSString *headerField = @"x-access-token";

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request addValue:key forHTTPHeaderField:headerField];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSData *responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSLog(@"requestReply: %@", jsonDict);
        [self updateInfo:jsonDict];
    }] resume];
}

- (IBAction)updateWasPressed:(id)sender {
    [locationManager startUpdatingLocation];
}

- (void)setStatus:(double *)UVValue {

    double compare = *UVValue;

    if (compare < 3.0) {
        statusLabel.text = @"Low";
        statusLabel.textColor = UIColor.greenColor;
    } else if (compare < 6.0) {
        statusLabel.text = @"Moderate";
        statusLabel.textColor = UIColor.yellowColor;
    } else if (compare < 8.0) {
        statusLabel.text = @"High";
        statusLabel.textColor = UIColor.orangeColor;
    } else if (compare < 11.0) {
        statusLabel.text = @"Very High";
        statusLabel.textColor = UIColor.redColor;
    } else {
        statusLabel.text = @"Extreme";
        statusLabel.textColor = UIColor.purpleColor;
    }
}

@end
