//
//  NWMapViewController.m
//  Pamperr
//
//  Created by Ignacio Martín on 10/07/2014.
//  Copyright (c) 2014 Niceway Asia. All rights reserved.
//

#import "NWMapVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface NWMapVC ()

@end

@implementation NWMapVC{
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.geopoint.latitude
                                                            longitude:self.geopoint.longitude
                                                                 zoom:15];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:self.geopoint.latitude longitude:self.geopoint.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSString* selectedCityName = [NSString stringWithFormat:@"%@ (%@)", [placemark.addressDictionary objectForKey:@"City"], [placemark.addressDictionary objectForKey:@"Country"]];
             marker.title = selectedCityName;
         }
     }];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    self.view = mapView_;
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
