//
//  YDViewController.m
//  MyReminders
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDViewController.h"

@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self requestAccessToCalendar];
    //	Create an Add Event button
	UIBarButtonItem *addEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addReminder:)];
	self.navigationItem.rightBarButtonItem = addEventButtonItem;
}
-(void)requestAccessToCalendar
{
    self.myEventStore = [[EKEventStore alloc] init];
    __block BOOL accessGranted = NO;
    [self.myEventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted,
                                                                                   NSError *error) {
            // handle access here
        accessGranted = granted;
        dispatch_async(dispatch_get_main_queue(),^{
            accessGranted=YES;

        });
    }];
    
}


- (void)addReminder:(id)sender
{
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.myEventStore];
    [reminder setTitle:@"Pick up 2 pizzas"];
    [reminder setNotes:@"Calzone's Pizza Cucina‎. 430 Columbus Ave, San Francisco"];
        //create the geofence alarm
    EKAlarm *enterAlarm = [[EKAlarm alloc] init];
    
    [enterAlarm setProximity:EKAlarmProximityEnter];
    EKStructuredLocation *enterLocation = [EKStructuredLocation locationWithTitle:@"Grocery store"];
    CLLocationDegrees lat = 37.799052;
    CLLocationDegrees lng = -122.408187;
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    [enterLocation setGeoLocation:shopLocation];
    //set the radius in meters
    [enterLocation setRadius:200];
    reminder.calendar = [self.myEventStore defaultCalendarForNewReminders];
    [enterAlarm setStructuredLocation:enterLocation];
    [reminder addAlarm:enterAlarm];
    [reminder setCalendar:[self.myEventStore defaultCalendarForNewReminders]];
    
    NSError *err;
    [self.myEventStore saveReminder:reminder commit:YES error:&err];
    if (err)
        {
            //Handle errors here
        }

 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
