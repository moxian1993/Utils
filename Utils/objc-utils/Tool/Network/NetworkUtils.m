//
//  NetworkUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NetworkUtils.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation NetworkUtils

+ (NSString *)getPhoneNetworkCarrierName {

    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *simOperator = carrier.carrierName;
    
    return simOperator;
}


+ (NSString *)getCountryISO {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    
    NSString *countryIso = carrier.isoCountryCode;
    NSString *simOperator = carrier.carrierName;
    NSString *networkOperator = carrier.mobileNetworkCode;
    
    if(!countryIso) {
        countryIso = [self getLocalCountryISO];
    }
    return countryIso;
}


+ (NSString *)getLocalCountryISO {
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryIso = [locale objectForKey:NSLocaleCountryCode];
    return countryIso;
}


@end
