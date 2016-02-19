//
//  YDViewController.m
//  MyEvents
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

@interface YDViewController ()<EKCalendarChooserDelegate,EKEventEditViewDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestAccessToCalendar];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeChanged:)
                                            name:EKEventStoreChangedNotification
                                            object:self.myEventStore];
}
-(void)requestAccessToCalendar
{
    self.myEventStore = [[EKEventStore alloc] init];
    __block BOOL accessGranted = NO;
    [self.myEventStore requestAccessToEntityType:EKEntityTypeEvent
            completion:^(BOOL granted,NSError *error)
    {
        // handle access here
        accessGranted = granted;
        dispatch_async(dispatch_get_main_queue(),^{
            accessGranted=YES;
        });
    }];
}
- (IBAction)pickCalendar:(UIButton *)sender
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
        
        return;
    }
    EKCalendarChooser *calendarChooser = [[EKCalendarChooser alloc]
                                          initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle
                                          displayStyle:EKCalendarChooserDisplayAllCalendars
                                          eventStore:self.myEventStore];
    //if you don't set the selectedCalendars to an initialized NSSet it always returns nil
    calendarChooser.selectedCalendars = [[NSSet alloc] init];
  //  calendarChooser.showsDoneButton = YES;
   // calendarChooser.showsCancelButton = YES;
    calendarChooser.delegate = self;
    
    UINavigationController* newNavController = [[UINavigationController alloc]
                                                initWithRootViewController:calendarChooser];
    [self presentViewController:newNavController animated:YES completion:nil];
    
}

- (IBAction)createEvent:(UIButton *)sender
{
    EKEventEditViewController *addEventController = [[EKEventEditViewController alloc] init];
	
    // set the addController's event store to the current event store.
	addEventController.eventStore = self.myEventStore;
    addEventController.editViewDelegate = self;
    //If you have an existing event named myEvent and want to edit it pass it to the event property
        //addEventController.event = myEvent;
    // present EventsAddViewController as a modal view controller
	[self presentViewController:addEventController animated:YES completion:nil];
	
}

 
- (void)storeChanged:(NSNotification *)storeNotification
{
        //Do what you need to do here
}

#pragma mark delegates
- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser
{
      if ([calendarChooser.selectedCalendars count]>0)
        {
        NSArray* allCalendars = [calendarChooser.selectedCalendars allObjects];
        self.myCalendar = [allCalendars objectAtIndex:0];
        self.selectedCalendarName.text = self.myCalendar.title;
        [self dismissViewControllerAnimated:YES completion:nil];
        }
    
}

- (void)calendarChooserDidFinish:(EKCalendarChooser *)calendarChooser
{
      [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)calendarChooserDidCancel:(EKCalendarChooser *)calendarChooser
{
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


@end
