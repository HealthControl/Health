//
//  CalendarViewController.m
//  Health
//
//  Created by VickyCao on 12/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "CalendarViewController.h"
#import "BloodRequest.h"
#import "JTCalendar.h"

@interface CalendarViewController () <JTCalendarDelegate, UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    IBOutlet JTCalendarMenuView *calendarMenuView;
    IBOutlet JTHorizontalCalendarView *calendarContentView;
    JTCalendarManager *calendarManager;
    NSDate *_dateSelected;
    NSDate *_todayDate;
}

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _todayDate = [NSDate date];
    [self loadCalendarView];
    [self loadRequest:_todayDate];
}

- (void)loadRequest:(NSDate *)date {
    
    NSString *currentDate = [date stringWithFormat:@"yyyy-MM-dd"];
    [[BloodRequest singleton] getCalendar:currentDate complete:^{
        [self loadWebView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)loadWebView {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BloodRequest singleton].calendarURL]]];
}

- (void)loadCalendarView {
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    [calendarManager setMenuView:calendarMenuView];
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:_todayDate];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [calendarContentView loadNextPageWithAnimation];
        }
        else{
            [calendarContentView loadPreviousPageWithAnimation];
        }
    }
    [self loadRequest:_dateSelected];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
@end
