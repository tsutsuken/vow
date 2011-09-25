//
//  MedialetsAnalyticsManager.h
//  Medialets iPhone Ad Client
//  
//  Copyright 2010 Medialets, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class MedialetsTrackedEventDatabase;

@interface MedialetsAnalyticsManager : NSObject <CLLocationManagerDelegate> {
	NSTimer					*broadcastTimer;
	NSTimeInterval			broadcastInterval;

	NSTimer					*connStatusTimer;
    NSTimeInterval			connStatusRefreshInterval;

	NSTimer					*_locationTimer;
	CLLocation				*_currentLocation;
    CLLocationManager		*_internalLocationManager;
	id						_locationManagerDelegate;
    NSTimeInterval			locRefreshInterval;

	MedialetsTrackedEventDatabase	*trackedEventDB;
	NSMutableDictionary		*eventKeyUserDict;
	
	BOOL					_tracking;
	NSTimeInterval			impresssionEventUpdate;
	NSString				*sysVersion;
	

}

@property (nonatomic, retain) NSTimer					*locationTimer;
@property (nonatomic, retain) CLLocation				*currentLocation;
@property (nonatomic, retain) CLLocationManager			*internalLocationManager;
@property (nonatomic, assign) id						locationManagerDelegate;
@property (nonatomic, assign) NSTimeInterval			locRefreshInterval;
@property (nonatomic, assign) NSTimeInterval			broadcastInterval;
@property (nonatomic, assign) NSTimeInterval			connStatusRefreshInterval;
@property (nonatomic, assign) NSTimeInterval			impresssionEventUpdate;
@property (nonatomic, getter=isTracking, assign) BOOL	tracking;


+ (NSString *)version;
+ (id)sharedInstance;
+ (NSString *)deviceHardware;

+ (BOOL)keyExists:(NSString *)key;

+ (NSString *)stringForKey:(NSString *)key;
+ (void)setString:(NSString *)value forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

+ (int)intForKey:(NSString *)key;
+ (void)setInt:(int)value forKey:(NSString *)key;


+ (float)floatForKey:(NSString *)key;
+ (void)setFloat:(float)value forKey:(NSString *)key;

// Returns one of "NotConnected", "CDNConnected", "WiFiConnected" or "InvalidNetworkStatus"
// Note: "CDN" stands for Carrier Data Network - EDGE or 3G
- (NSString *)internetConnectionStatus;

- (void)trackEvent:(id)event;
- (void)trackEvent:(NSString *)eventKey withUserDict:(NSDictionary *)dict;

- (void)initialize:(BOOL)locationAccessEnabled;
- (void)initializeWithAppID:(NSString *)anAppID appVersion:(NSString *)version locationManager:(CLLocationManager *)locManager locationTracking:(BOOL)locationAccessEnabled;


- (void)observeNotifications:(NSArray *)names fromObject:(id)obj;
- (void)observeNotification:(NSString *)notificationName fromObject:(id)obj;

- (void)stopObservingNotifications:(NSArray *)names fromObject:(id)obj;
- (void)stopObservingNotification:(NSString *)notificationName fromObject:(id)obj;

@end


	// An informal protocol for the location manager delegate.
@interface NSObject (MedialetsAnalyticsManagerProtocol)
- (BOOL)locationManagerShouldStopUpdatingLocation:(CLLocationManager *)cllMgr;
@end

