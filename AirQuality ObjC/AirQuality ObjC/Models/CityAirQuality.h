//
//  CityAirQuality.h
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVMWeather.h"
#import "DVMPollution.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityAirQuality : NSObject

@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *country;

@property (nonatomic, copy, readonly) DVMWeather *weather;
@property (nonatomic, copy, readonly) DVMPollution *pollution;

- (instancetype)initWithCity:(NSString *)city
                       state:(NSString *)state
                     country:(NSString *)country
                     weather:(DVMWeather *)weather
                   pollution:(DVMPollution *)pollution;
@end

@interface CityAirQuality (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
