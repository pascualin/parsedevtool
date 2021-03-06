//
//  NWChartVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 26/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWChartView.h"
#import <Parse/Parse.h>

@implementation NWChartView

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
            if (currentValue > self.maxValue)
            {
                self.maxValue = currentValue;
            }
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
    self.maxValue = 0;
    int numberOfItems = 30;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"]; // UTC is same as GMT
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MMM dd"];
    
    NSDate *now = [NSDate date];
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray* tempValues = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < numberOfItems; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:-(i * (60 * 60 * 24)) sinceDate:now];
        [results addObject:[dateFormatter stringFromDate:date]];
        // Initialise to empty values
        [tempValues addObject:@0];
    }
    
    [self setStrokeColor:[UIColor colorWithRed:65.0f/255 green:120.0f/255 blue:250.0f/255 alpha:1]];
    [self setXLabelSkip:2];
    
    self.reversedDate = [[results reverseObjectEnumerator] allObjects];
    
    [self setXLabels:self.reversedDate];
    
    self.yLabelFormatter = ^(CGFloat yValue)
    {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%.0f",yValueParsed];
        return labelText;
    };
    
    // Set up Data
    int j = numberOfItems-1;
    
    for (PFObject* object in self.objects)
    {
        [self compareDateWithIndex:j tempValues:tempValues compareDateOnly:now andObject:object];
    }
    
    [self setYLabelSum:self.maxValue];
    [self setYValues:tempValues];
    
    [self strokeChart];

}

@end
