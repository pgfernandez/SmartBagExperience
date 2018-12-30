//
//  AERCheckInViewController.m
//  SmartBagExperience
//
//  Created by Pedro Garcia Fernandez on 4/4/15.
//  Copyright (c) 2015 aeriaa. All rights reserved.
//

#import "AERCheckInViewController.h"
#import "Settings.h"


@interface AERCheckInViewController ()



@end

@implementation AERCheckInViewController


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Check your Bags";
    }
    return self;
}*/

-(id) initWithPassengerData:(AERPassenger *)pax{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Check Bags";
        _pax = pax;
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)notifyBags:(id)sender{
    
    UIButton *buttonPressed = (UIButton*)sender;
    NSNumber *numberOfBags;
    
    
    if ([buttonPressed.currentTitle isEqualToString:@"1 BAG"]){
        NSLog(@"He pulsado sobre el 1");

        numberOfBags = [[NSNumber alloc]initWithInt:1];
        
    }else if ([buttonPressed.currentTitle isEqualToString:@"2 BAGS"]){
        NSLog(@"He pulsado sobre el 2");
        
        numberOfBags = [[NSNumber alloc]initWithInt:2];
    
    }else{
             NSLog(@"He pulsado sobre el +2");
        
        numberOfBags = [[NSNumber alloc]initWithInt:3];
    }
    
    
    NSMutableString *url = [[NSMutableString alloc] initWithString: @"http://"];
    [url appendString:@LOCAL_IP];
    [url appendString:@":8183/dcs/CheckPax/"];
    [url appendString:_pax.reservationNumber];
    [url appendString:@"/"];
    [url appendString:[numberOfBags stringValue]];
    
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:url]];
    
    jsonSource = nil;

}


@end
