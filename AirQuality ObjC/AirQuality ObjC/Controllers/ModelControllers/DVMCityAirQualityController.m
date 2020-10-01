//
//  DVMCityAirQualityController.m
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMCityAirQualityController.h"

@implementation DVMCityAirQualityController

static NSString * const baseUrlString = @"https://api.airvisual.com/";
static NSString * const versionComponent = @"v2";
static NSString * const countryComponent = @"countries";
static NSString * const stateComponent = @"states";
static NSString * const cityComponent = @"cities";
static NSString * const cityDetailsComponent = @"city";

+ (void)fetchSupportedCountries:(void (^) (NSArray<NSString *> *))completion
{
    NSString *apiKey = [DVMCityAirQualityController apiKey];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:versionComponent];
    NSURL *countryURL = [versionURL URLByAppendingPathComponent:countryComponent];
    NSURLQueryItem *keyQueryItem = [NSURLQueryItem queryItemWithName:@"key"
                                                               value:apiKey];
    NSURLComponents *components = [NSURLComponents componentsWithURL:countryURL
                                             resolvingAgainstBaseURL:true];
    
    components.queryItems = @[keyQueryItem];
    NSURL *finalURL = components.URL;
    
    NSLog(@"%s[%d]: finalURL:%@", __FUNCTION__,__LINE__, finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil);
        }
        
        NSMutableArray *countries = [NSMutableArray new];
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSArray *dataArray = topLevelDictionary[@"data"];
        for (NSDictionary *countryDict in dataArray) {
            NSString *countryName = countryDict[@"country"];
            [countries addObject:countryName];
        }
        return completion(countries);
        
    }] resume];
}

+ (void)fetchSupportedStatesInCountry:(NSString *)country
                           completion:(void (^) (NSArray<NSString *> *))completion
{
    NSString *apiKey = [DVMCityAirQualityController apiKey];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:versionComponent];
    NSURL *stateURL = [versionURL URLByAppendingPathComponent:stateComponent];
    NSURLQueryItem *keyQueryItem = [NSURLQueryItem queryItemWithName:@"key"
                                                               value:apiKey];
    NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country"
                                                                   value:country];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:stateURL
                                             resolvingAgainstBaseURL:true];
    
    components.queryItems = @[countryQueryItem,keyQueryItem];
    NSURL *finalURL = components.URL;
    NSLog(@"%s[%d]: finalURL:%@", __FUNCTION__,__LINE__, finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil);
        }
        
        NSMutableArray *states = [NSMutableArray new];
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSString *status = topLevelDictionary[@"status"];
        
        if ([status isEqualToString:@"fail"]) {
            NSString *message = topLevelDictionary[@"data"][@"message"];
            [states addObject:message];
            NSLog(@"%s[%d]: %@--%@", __FUNCTION__,__LINE__, status, message);
            return completion(nil);
        }
        if ([status isEqualToString:@"success"]){
            NSLog(@"%s[%d]: %@", __FUNCTION__,__LINE__, status);
            
            NSArray *dataArray = topLevelDictionary[@"data"];
//            NSLog(@"%s[%d]: %@", __FUNCTION__,__LINE__, dataArray);
            for (NSDictionary *stateDict in dataArray) {
                NSString *stateName = stateDict[@"state"];
                [states addObject:stateName];
            }
            return completion(states);
        }
    }] resume];
    
}

+ (void)fetchSupportedCitiesInState:(NSString *)state
                            country:(NSString *)country
                         completion:(void (^) (NSArray<NSString *> *))completion
{
    NSString *apiKey = [DVMCityAirQualityController apiKey];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:versionComponent];
    NSURL *cityURL = [versionURL URLByAppendingPathComponent:cityComponent];
    NSURLQueryItem *keyQueryItem = [NSURLQueryItem queryItemWithName:@"key"
                                                               value:apiKey];
    NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country"
                                                                   value:country];
    NSURLQueryItem *stateQueryItem = [NSURLQueryItem queryItemWithName:@"state"
                                                                 value:state];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:cityURL
                                             resolvingAgainstBaseURL:true];
    
    components.queryItems = @[countryQueryItem,stateQueryItem,keyQueryItem];
    NSURL *finalURL = components.URL;
    NSLog(@"%s[%d]: finalURL:%@", __FUNCTION__,__LINE__, finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil);
        }
        
        NSMutableArray *cities = [NSMutableArray new];
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSString *status = topLevelDictionary[@"status"];
        
        if ([status isEqualToString:@"fail"]) {
            NSString *message = topLevelDictionary[@"data"][@"message"];
            [cities addObject:message];
            NSLog(@"%s[%d]: %@--%@", __FUNCTION__,__LINE__, status, message);
            return completion(nil);
        }
        if ([status isEqualToString:@"success"]){
            NSLog(@"%s[%d]: %@", __FUNCTION__,__LINE__, status);
            
            
            
            NSArray *dataArray = topLevelDictionary[@"data"];
            for (NSDictionary *cityDict in dataArray) {
                NSString *cityName = cityDict[@"city"];
                [cities addObject:cityName];
            }
            return completion(cities);
        }
    }] resume];
}

+ (void)fetchDataForCity:(NSString *)city
                   state:(NSString *)state
                 country:(NSString *)country
              completion:(void (^) (CityAirQuality *))completion
{
    NSString *apiKey = [DVMCityAirQualityController apiKey];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:versionComponent];
    NSURL *cityURL = [versionURL URLByAppendingPathComponent:cityDetailsComponent];
    NSURLQueryItem *keyQueryItem = [NSURLQueryItem queryItemWithName:@"key"
                                                               value:apiKey];
    NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country"
                                                                   value:country];
    NSURLQueryItem *stateQueryItem = [NSURLQueryItem queryItemWithName:@"state"
                                                                 value:state];
    NSURLQueryItem *cityQueryItem = [NSURLQueryItem queryItemWithName:@"city"
                                                                value:city];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:cityURL
                                             resolvingAgainstBaseURL:true];
    
    components.queryItems = @[cityQueryItem,countryQueryItem,stateQueryItem,keyQueryItem];
    NSURL *finalURL = components.URL;
    NSLog(@"%s[%d]: finalURL:%@", __FUNCTION__,__LINE__, finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil);
        }
        
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSDictionary *cityDict = topLevelDictionary[@"data"];
        CityAirQuality *cityAQI = [[CityAirQuality alloc] initWithDictionary:cityDict];
        
        return completion(cityAQI);
        
    }] resume];
}

+ (NSString *)apiKey
{
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"AirQualityAPI"
                      ofType:@"plist"];
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *apiKey = plistDictionary[@"API_KEY"];
    return apiKey;
}

@end
