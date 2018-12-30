//
//  AERAtAirportViewController.m
//  SmartBagExperience
//
//  Created by Pedro Garcia Fernandez on 4/7/15.
//  Copyright (c) 2015 aeriaa. All rights reserved.
//

#import "AERAtAirportViewController.h"
#import "AERBagStatusViewController.h"
#import "AERFirstViewController.h"
#import "KontaktSDK.h"


@interface AERAtAirportViewController () <KTKLocationManagerDelegate>

@property KTKLocationManager *locationManager;
@property BOOL checkingLocation;
@property BOOL airportLocation;
@property AERFirstViewController *checkinVC;

@end

@implementation AERAtAirportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"Menu";
    
    _checkingLocation = FALSE;
    _airportLocation = FALSE;
    _locationManager = [KTKLocationManager new];
    _locationManager.delegate = self;
    
    
    if ([KTKLocationManager canMonitorBeacons])
    {        KTKRegion *region =[[KTKRegion alloc] initWithUUID:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
        //            region.uuid = @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";
        
        
        [self.locationManager setRegions:@[region]];
        //[self.locationManager startMonitoringForRegion:region];
        [self.locationManager startMonitoringBeacons];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)myBags:(id)sender{
    
    AERBagStatusViewController *bagVC = [[AERBagStatusViewController alloc]init];
    [self.navigationController pushViewController:bagVC animated:YES];
    
}


-(IBAction)checkin:(id)sender{
    
    NSLog(@"Pulsado chekin");
    if (_checkinVC == nil){
        _checkinVC = [[AERFirstViewController alloc]initWithLocationData:FALSE];
    }
    [self.navigationController pushViewController:_checkinVC animated:YES];
//    [_checkinVC arrivedToAirport];
    
}


-(IBAction)myOffers:(id)sender{
    
}

-(IBAction)myFlights:(id)sender{
    
    
    
    
    
}

#pragma mark - KTKLocationManagerDelegate


- (void)locationManager:(KTKLocationManager *)locationManager didChangeState:(KTKLocationManagerState)state withError:(NSError *)error
{
    if (state == KTKLocationManagerStateFailed)
    {
        NSLog(@"Something went wrong with your Location Services settings. Check OS settings.");
    }
}

- (void)locationManager:(KTKLocationManager *)locationManager didEnterRegion:(KTKRegion *)region
{
    
    
    NSLog(@"Enter region %i", [region.major intValue]);
    NSLog(@"Enter region %@", region.uuid);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Airport localization" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    alert.title = @"Welcome";
    alert.message = @"You're entering at the airport!";
    
    
    
    [alert show];
    
    
    
}

- (void)locationManager:(KTKLocationManager *)locationManager didExitRegion:(KTKRegion *)region
{
    NSLog(@"Exit region: %i", [region.major intValue]);
    NSLog(@"Exit region %@", region.uuid);
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Airport localization" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    alert.title = @"Bye!";
    alert.message = @"You're leaving the Airport!";
    
    [alert show];
    
    
}

- (void)locationManager:(KTKLocationManager *)locationManager didRangeBeacons:(NSArray *)beacons
{
    
    /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Airport localization" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     alert.title = @"At the airport";
     alert.message = @"You are entering in the airport";*/
    
    NSLog(@"Ranged beacon major: %i", [[[beacons firstObject] major] intValue]);
    NSLog(@"Closest Beacon: %@", [beacons firstObject]);
    
    if ([[[beacons firstObject] major] intValue] == 22928) {
        NSLog(@"Ranged beacon: %@", @"You are entering in the airport");
        
        if (!_airportLocation) {
            _airportLocation = TRUE;
        }else{
            //usamos proximidad
            
        }
        
        
    }else if([[[beacons firstObject] major] intValue] == 39299){
        NSLog(@"Ranged beacon major: %@", @"You are entering in the Checkin area");
        NSLog(@"checkin location: %hhd",_checkingLocation);
        
        if (!_checkingLocation) {
            _checkingLocation = TRUE;
             _checkinVC = [[AERFirstViewController alloc]init];
            [self.navigationController pushViewController:_checkinVC animated:YES];
            
        }
        
        
    }else{
      NSLog(@"Ranged beacon major: %@", @"You're entering F&B!");
      
      }
    
    NSLog(@"Ranged beacons count: %i", [[[beacons firstObject] major] intValue]);
    
    
    /*NSLog(@"beacon 1: %@", [beacons lastObject]);
     NSLog(@"beacon 1: %@", [beacons firstObject]);*/
    
    
}


@end
