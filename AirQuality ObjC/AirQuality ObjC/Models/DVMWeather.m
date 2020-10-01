//
//  DVMWeather.m
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMWeather.h"

@implementation DVMWeather

- (instancetype)initWithWeatherInfo:(NSInteger)temperature
                           humidity:(NSInteger)humidity
                          windSpeed:(NSInteger)windSpeed
{
    self = [super init];
    if (self) {
        _temperature = temperature;
        _humidity = humidity;
        _windSpeed = windSpeed;
    }
    return self;
}

@end

@implementation DVMWeather (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    NSInteger weatherTemperature =  [dictionary[@"tp"] integerValue];
    NSInteger weatherHumidity =     [dictionary[@"hu"] integerValue];
    NSInteger weatherWindSpeed =    [dictionary[@"ws"] integerValue];
    
    return [self initWithWeatherInfo:weatherTemperature
                            humidity:weatherHumidity
                           windSpeed:weatherWindSpeed];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"temp:%ld\nwind:%ld\nhumidity:%ld", _temperature, _windSpeed, _humidity];
}

@end
