//
//  YDViewController.m
//  MyCalDB
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

@interface YDViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self requestAccessToCalendar];
    //	Create an Add Event button
	UIBarButtonItem *addEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
	self.navigationItem.rightBarButtonItem = addEventButtonItem;
}
-(void)requestAccessToCalendar
{
    self.myEventStore = [[EKEventStore alloc] init];
    __block BOOL accessGranted = NO;
    [self.myEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,
                                                                                   NSError *error) {
            // handle access here
        accessGranted = granted;
        dispatch_async(dispatch_get_main_queue(),^{
            accessGranted=YES;
                //call loadEvents here now you now the user has granted access
            [self loadEvents];
        });
    }];
    
}
-(void)loadEvents
{
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
        
        return;
    }
    if (self.events)
        self.events=nil;
    
    self.myCalendar = [self.myEventStore defaultCalendarForNewEvents];
    NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    // Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:self.myCalendar];
	NSPredicate *predicate = [self.myEventStore predicateForEventsWithStartDate:startDate endDate:endDate
                                                                    calendars:calendarArray];
	
    // Fetch all events that match the predicate and store in self.events
	self.events = [[NSArray alloc] initWithArray: [self.myEventStore eventsMatchingPredicate:predicate]];
    [self.mTableView reloadData];
}


- (void)addEvent:(id)sender
{
    //Add an event without UI
    EKEvent *newEvent  = [EKEvent eventWithEventStore:self.myEventStore];
    newEvent.calendar  = self.myCalendar;
    newEvent.title     = @"Finalize chapter 13";
    newEvent.notes     = @"Finish learning chapter 13 of the book Professional iOS programming";
    newEvent.startDate = [NSDate date];
    newEvent.endDate   =[[NSDate date] initWithTimeInterval:600 sinceDate:newEvent.startDate];
    NSError *err=nil;
    [self.myEventStore saveEvent:newEvent span:EKSpanThisEvent commit:YES error:&err];
    if (err)
    {
        //Handle errors here
    }
    [self loadEvents];
}

//Sample
- (void)editEvent:(EKEvent* )theEvent
{

    theEvent.calendar  = self.myCalendar;
    theEvent.title     = @"Changed event title";
      NSError *err=nil;
    [self.myEventStore saveEvent:theEvent span:EKSpanThisEvent commit:YES error:&err];
    if (err)
        {
            //Handle errors here
        }
  
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
 	UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
 	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
	}
	cell.accessoryType = editableCellAccessoryType;
    // Get the event at the row selected and display it's title
	cell.textLabel.text = [[self.events objectAtIndex:indexPath.row] title];
	return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
      [self loadEvents];
}
 
#pragma mark UITableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Upon selecting an event, create an EKEventViewController to display the event.
	EKEventViewController* editController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
	editController.event = [self.events objectAtIndex:indexPath.row];
    // Allow event editing.
	editController.allowsEditing = YES;
	[self.navigationController pushViewController:editController animated:YES];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
