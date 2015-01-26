//
//  NWChartVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 26/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWChartVC.h"
#import <Parse/Parse.h>

@implementation NWChartVC

- (void)compareDateWithIndex:(int)j tempValues:(NSMutableArray *)tempValues compareDateOnly:(NSDate *)compareDateOnly andObject:(PFObject*)object
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* compareDateComponents = [calendar components:flags fromDate:compareDateOnly];
    compareDateOnly = [calendar dateFromComponents:compareDateComponents];
    
    NSDateComponents* components = [calendar components:flags fromDate:object.createdAt];
    NSDate* createDateOnly = [calendar dateFromComponents:components];
    
    if (j>=0)
    {
        if ([createDateOnly isEqualToDate:compareDateOnly])
        {
            // same date, add to the list
            int currentValue = [[tempValues objectAtIndex:j] intValue] + 1;
            NSNumber* currentValueObject = [NSNumber numberWithInt:currentValue];
            [tempValues replaceObjectAtIndex:j withObject:currentValueObject];
        }
        else
        {
            if (j>=0)
            {
                //went too far so we allocate previous date
                int daysToAdd = -1;
                j--;
                compareDateOnly = [compareDateOnly dateByAddingTimeInterval:60*60*24*daysToAdd];
                [self compareDateWithIndex:j tempValues:tempValues compareDateOnly:compareDateOnly andObject:object];
            }
        }
    }
}

-(void)refreshChart
{
    // Set up X-asix
    // Get dates from 6 days
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"]; // UTC is same as GMT
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MMM DD"];
    
    NSDate *now = [NSDate date];
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 0; i < 6; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:-(i * (60 * 60 * 24)) sinceDate:now];
        [results addObject:[dateFormatter stringFromDate:date]];
    }
    self.reversedDate = [[results reverseObjectEnumerator] allObjects];
    
    [self setXLabels:self.reversedDate];
    
    self.yLabelFormatter = ^(CGFloat yValue)
    {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.1f",yValueParsed];
        return labelText;
    };
    
    // Set up Data
    
    // Initialise to empty values
    NSMutableArray* tempValues = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0, @0, @0, @0]];
    
    int j = 5;
    
    for (PFObject* object in self.objects)
    {
        [self compareDateWithIndex:j tempValues:tempValues compareDateOnly:now andObject:object];
    }
    [self setYValues:tempValues];
    
    [self strokeChart];
}

@end
