//
//  CityAirQuality.m
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "CityAirQuality.h"

@implementation CityAirQuality

- (instancetype)initWithCity:(NSString *)city
                       state:(NSString *)state
                     country:(NSString *)country
                     weather:(DVMWeather *)weather
                   pollution:(DVMPollution *)pollution
{
    self = [super init];
    if (self) {
        _city = city;
        _state = state;
        _country = country;
        _weather = weather;
        _pollution = pollution;
    }
    return self;
}

@end

@implementation CityAirQuality (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    NSString *city = dictionary[@"city"];
    NSString *state = dictionary[@"state"];
    NSString *country = dictionary[@"country"];
    
    NSDictionary *currentDict = dictionary[@"current"];
    DVMWeather *weather = [[DVMWeather alloc] initWithDictionary:currentDict[@"weather"]];
    DVMPollution *pollution = [[DVMPollution alloc] initWithDictionary:currentDict[@"pollution"]];
    
    NSLog(@"%s[%d]: %@, %@, %@\n%@\n%@", __FUNCTION__,__LINE__, city, state, country, [weather description], [pollution description]);
    
    return [self initWithCity:city
                        state:state
                      country:country
                      weather:weather
                    pollution:pollution];
}

@end
