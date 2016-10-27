//
//  YDViewController.h
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

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
@interface YDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *selectedCalendarName;
@property (weak, nonatomic) IBOutlet UIButton *pickCalendarButton;
@property(nonatomic,strong)  EKEventStore *myEventStore;
@property(nonatomic,strong)EKCalendar* myCalendar;
- (IBAction)pickCalendar:(UIButton *)sender;
- (IBAction)createEvent:(UIButton *)sender;

@end
