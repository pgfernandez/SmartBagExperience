//
//  AERFirstViewController.h
//  SmartBagExperience
//
//  Created by Pedro Garcia Fernandez on 4/4/15.
//  Copyright (c) 2015 aeriaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AERPassenger.h"

@interface AERFirstViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *checkYourBag;
@property (nonatomic, weak) IBOutlet UILabel *paxName;
@property (nonatomic, weak) IBOutlet UILabel *notificationLabel;
@property (nonatomic, weak) IBOutlet UILabel *originAirport;
@property (nonatomic, weak) IBOutlet UILabel *destinationAirport;
@property (nonatomic, weak) IBOutlet UILabel *flightSTD;
@property (nonatomic, weak) IBOutlet UILabel *flightCode;
@property (nonatomic, weak) IBOutlet UILabel *flightStatus;
@property (nonatomic, weak) IBOutlet UILabel *bagStatus;
@property (nonatomic, weak) IBOutlet UILabel *gateAssigned;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) AERPassenger *pax;


-(id) initWithLocationData:(BOOL)located;
-(void)arrivedToAirport;

@end
