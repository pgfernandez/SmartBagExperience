//
//  AERCheckInViewController.h
//  SmartBagExperience
//
//  Created by Pedro Garcia Fernandez on 4/4/15.
//  Copyright (c) 2015 aeriaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AERPassenger.h"

@interface AERCheckInViewController : UIViewController



@property (nonatomic, weak) IBOutlet UIButton *oneBagButton;
@property (nonatomic, weak) IBOutlet UIButton *twoBagsButton;
@property (nonatomic, weak) IBOutlet UIButton *plusTwoBagsButton;
@property (nonatomic, strong) AERPassenger *pax;

-(id) initWithPassengerData:(AERPassenger *)pax;

@end
