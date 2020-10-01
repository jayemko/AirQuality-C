//
//  DVMCityAirQualityController.h
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityAirQuality.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVMCityAirQualityController : NSObject


/**
 array - fetchSupportedCountries
 array - fetchSupportedStatesInCountry - String
 array - fetchSupportedCitiesInState - string
 caqobj - fetchDataForCity - string, string, string
 */

+ (void)fetchSupportedCountries:(void (^) (NSArray<NSString *>*))completion;
+ (void)fetchSupportedStatesInCountry:(NSString *)country
                           completion:(void (^) (NSArray<NSString *> *))completion;
+ (void)fetchSupportedCitiesInState:(NSString *)state
                            country:(NSString *)country
                         completion:(void (^) (NSArray<NSString *> *))completion;
+ (void)fetchDataForCity:(NSString *)city
                   state:(NSString *)state
                 country:(NSString *)country
              completion:(void (^) (CityAirQuality *))completion;

@end

NS_ASSUME_NONNULL_END
