//
//  ViewController.h
//  UVObjectiveC
//
//  Created by Matheus Garcia on 25/07/18.
//  Copyright © 2018 Matheus Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {

    double UVNivel;
    CLLocationManager *locationManager;

    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UIView *loadingView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UILabel *updateInfo;
    __weak IBOutlet UIImageView *sky;
}


@end
