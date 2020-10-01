//
//  DVMPollution.m
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMPollution.h"

@implementation DVMPollution

- (instancetype)initWithAQIInteger:(NSInteger)aqi
{
    self = [super init];
    if (self) {
        _airQualityIndex = aqi;
    }
    return self;
}

@end

@implementation DVMPollution (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    NSInteger aqiValue = [dictionary[@"aqius"] integerValue];
    
    return [self initWithAQIInteger:aqiValue];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"AQI:%ld", _airQualityIndex];
}

@end
