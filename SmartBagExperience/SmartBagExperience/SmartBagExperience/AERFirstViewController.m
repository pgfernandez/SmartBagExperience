//
//  AERFirstViewController.m
//  SmartBagExperience
//
//  Created by Pedro Garcia Fernandez on 4/4/15.
//  Copyright (c) 2015 aeriaa. All rights reserved.
//

#import "AERFirstViewController.h"
#import "AERCheckInViewController.h"

#import "AERFlight.h"
#import "Settings.h"



@interface AERFirstViewController()

@property BOOL locatedAtAirport;

// Define keys
@property NSString *flightNumber;
@property NSString *destination;
@property NSString *icao;
@property NSString *std;
@property NSString *name;
@property NSString *surname;
@property NSString *licence;
@property NSString *resNumber;
@property NSString *gate;


@end

@implementation AERFirstViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _locatedAtAirport = TRUE;
        self.title = @"SmartBag";
        
    }
    return self;
}


-(id)initWithLocationData:(BOOL)located{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.title = @"SmartBag";
        _locatedAtAirport = located;

    }
    return self;
    
}

- (void)viewDidLoad {

 
     [super viewDidLoad];
    
    //ya que vamos a leerla fuera del bloque
    __block NSDictionary *localizationData = nil;
    
    //vamos a enviarlo a segundo plano
    //Crear la cola
    dispatch_queue_t reservations = dispatch_queue_create("data", 0);
    
    //enviarle un bloque que se va en segundo plano
    dispatch_async(reservations, ^{
        NSLog(@"Buscando la reserva: AER0004");
        NSString *reservationNumber = @"AER00004";

        
       NSMutableString *url = [[NSMutableString alloc] initWithString: @"http://"];
        [url appendString:@LOCAL_IP];
        [url appendString:@":8183/dcs/CheckPax/"];
        [url appendString:reservationNumber];
        
        

        
//       NSString *url = [[NSString alloc]initWithFormat:@"http://192.168.1.37:8183/dcs/CheckPax/%@", reservationNumber];
        
        NSLog(@"Antes de llamar al web service");
        
        NSData *jsonSource = [NSData dataWithContentsOfURL:
                              [NSURL URLWithString:url]];
        
        NSLog(@"Después de llamar al web service");
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                          jsonSource options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dataDict in jsonObjects) {
            
            _flightNumber = [dataDict objectForKey:@"Flight"];
            _name = [dataDict objectForKey:@"Name"];
            _surname = [dataDict objectForKey:@"Surname"];
            _destination = [dataDict objectForKey:@"Destination"];
            _std = [dataDict objectForKey:@"STD"];
            _icao = [dataDict objectForKey:@"ICAO"];
            _resNumber = [dataDict objectForKey:@"Resnumber"];
            
            
        }
        
       localizationData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          _flightNumber, @"Flight",
                                          _name, @"Name",
                                          _surname, @"Surname",
                                          _icao, @"destination",
                                          _std, @"STD",
                                          _resNumber, @"Reservation",
                                          nil];
        

        
        _pax = [[AERPassenger alloc]initWithPaxNameAndFlightDetails:_name
                                                            surname:_surname
                                                       boardingTime:_std
                                                       flightNumber:_flightNumber
                                                        destination:_destination
                                                             origin:@"Madrid"
                                                    icaoDestination:_icao
                                                         icaoOrigin:@"MAD"
                                                               gate:@"A28"
                                                  reservationNumber:_resNumber];
        
        
        
       
        
        NSLog(@"antes del locatedAtAirport");
        
      
        
        //esto es para que al terminar el bloque se ejecute inmediatamente esto. Se ejecuta en primer plano.
        //esta es la belleza de saltar de una cola a otra, parece secuencial pero no lo es
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activity stopAnimating];
            self.activity.hidden = TRUE;
            //la parte que es de UIKit debe ir fuera del bloque porque no funciona en entorno inseguro
            
            self.flightCode.text = _flightNumber;
            self.paxName.text = _surname;
            self.destinationAirport.text = _icao;
            self.flightSTD.text = _std;
            self.gateAssigned.text = @"A28";

            
            if(_locatedAtAirport){
                [self sendLocalization:localizationData];
            }
            
        });
        
    });
    
   
    
    // Do any additional setup after loading the view from its nib.
}

-(void)sendLocalization:(NSDictionary *)localizationData{
   
    if (_locatedAtAirport) {
        self.notificationLabel.hidden = TRUE;
        //envicar notificación al DCS
        NSLog(@"dentro del locatedAtAirport y antes de enviar localización");
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:localizationData options:0 error:&error];

      
        NSMutableString *url = [[NSMutableString alloc] initWithString: @"http://"];
        [url appendString:@LOCAL_IP];
        [url appendString:@":8183/dcs/CheckPax/"];
        [url appendString:@"location/airport"];
        
       
        
        NSURL *urlRequest = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequest];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)checkBags:(id)sender{
    
   /* UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = @"Notificacion";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];*/
    
    AERCheckInViewController *checkInVC = [[AERCheckInViewController alloc]initWithPassengerData:_pax];

    [self.navigationController pushViewController:checkInVC animated:YES];
    
    
}

-(void)arrivedToAirport{
    
    self.notificationLabel.hidden = FALSE;
    
}

@end
