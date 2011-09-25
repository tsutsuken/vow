//
//  MedialetsAdView.h
//  MedialetsAdLib
//
//  Copyright 2008 Medialets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum adSlotTypes {
	MedialetsAdSlotTypeNone = 0,
	MedialetsBanner300x50,
	MedialetsBanner300x75,
	MedialetsBanner320x50,
	MedialetsBanner480x48,
	MedialetsInterstitial320x480,
	MedialetsInterstitial480x320,
	MedialetsMovie480x320,
	MedialetsBanner200x70,
	MedialetsBanner320x65	
} MedialetsAdSlotType;

typedef enum medialetsGestureType {
	MedialetsGestureNone = 0,
	MedialetsGestureLeftSwipe,
	MedialetsGestureRightSwipe,
	MedialetsGestureUpSwipe,
	MedialetsGestureDownSwipe
} MedialetsGestureType;

typedef enum medialetsOffsetCorner {
MedialetsOffsetCornerNone = 0,
MedialetsOffsetCornerUpperLeft,
MedialetsOffsetCornerUpperRight,
MedialetsOffsetCornerLowerRight,
MedialetsOffsetCornerLowerLeft
} MedialetsOffsetCorner;


@class MedialetsAdView;
@protocol MedialetsAdViewDelegate <NSObject>
@optional
- (BOOL)adViewCustomInteractionInterrogator:(MedialetsAdView *)adView request:(NSURLRequest *)request host:(NSString *)host protocol:(NSString *)protocol navigationType:(UIWebViewNavigationType)navigationType basePath:(NSString *)basePath;
- (void)adViewWillDisplayInterstitial:(MedialetsAdView *)adView;
- (void)adViewDidDisplayInterstitial:(MedialetsAdView *)adView;
- (void)adViewWillDismissInterstitial:(MedialetsAdView *)adView;
- (void)adViewDidDismissInterstitial:(MedialetsAdView *)adView;
- (void)adViewWillStartFullScreen:(MedialetsAdView *)adView;
- (void)adViewDidStartFullScreen:(MedialetsAdView *)adView;
- (void)adViewWillEndFullScreen:(MedialetsAdView *)adView;
- (void)adViewDidEndFullScreen:(MedialetsAdView *)adView;
- (void)adViewWillExpand:(MedialetsAdView *)adView;
- (void)adViewDidExpand:(MedialetsAdView *)adView;
- (void)adViewWillCollapse:(MedialetsAdView *)adView;
- (void)adViewDidCollapse:(MedialetsAdView *)adView;
- (void)adViewWillDisplayEmbeddedBrowser:(MedialetsAdView *)adView;
- (void)adViewDidDisplayEmbeddedBrowser:(MedialetsAdView *)adView;
- (void)adViewWillDismissEmbeddedBrowser:(MedialetsAdView *)adView;
- (void)adViewDidDismissEmbeddedBrowser:(MedialetsAdView *)adView;
- (void)adViewDidBecomeAvailable:(MedialetsAdView *)adView;
- (void)adViewDidFinishRendering:(MedialetsAdView *)adView;
- (BOOL)adViewShouldHide:(MedialetsAdView *)adView;
- (BOOL)adViewDetectedGestureEvent:(MedialetsAdView *)adView gestureType:(MedialetsGestureType)gestureType;
- (BOOL)adViewDidStartPlayingAudio:(MedialetsAdView *)adView;
- (BOOL)adViewDidFinishPlayingAudio:(MedialetsAdView *)adView;
@end

@class MedialetsAdViewController;
@class MMAdNetworkPromoSlider;
@class MedialetsCustomCloseButton;

@interface MedialetsAdView : UIView {
	BOOL					appStatusBarHidden;
	CGSize					adSlotSize;
	MedialetsAdSlotType			adSlotType;
	NSString				*adSlotKey;
	NSArray					*adSlotKeywords;
	NSArray					*adBlockKeywords;
	MedialetsAdViewController		*adVC;
    MMAdNetworkPromoSlider	*promoSlider;
	IBOutlet id <MedialetsAdViewDelegate>	delegate;
	BOOL					adIsCurrentlyLoaded;
	NSInteger				blockers;
	UIView					*webPageView;
	NSDictionary			*adKeyValuePairs;
}

@property (nonatomic, assign) BOOL						appStatusBarHidden;
@property (nonatomic, assign) CGSize					 adSlotSize;
@property (nonatomic, assign) MedialetsAdSlotType				 adSlotType;
@property (nonatomic, retain) NSString					*adSlotKey;
@property (nonatomic, retain) NSArray					*adSlotKeywords;
@property (nonatomic, retain) NSArray					*adBlockKeywords;
@property (nonatomic, retain) MedialetsAdViewController	*adVC;
@property (nonatomic, retain) MMAdNetworkPromoSlider	*promoSlider;
@property (nonatomic, retain) MedialetsCustomCloseButton	*customCloseButton;
@property (nonatomic, assign) id <MedialetsAdViewDelegate>		 delegate;
@property (nonatomic, assign) UIView					*webPageView;
@property (nonatomic, retain) NSDictionary			*adKeyValuePairs;


- (BOOL)prepareWithSlotSize:(CGSize)slotSize
                   slotName:(NSString *)slotKey 
                   keywords:(NSArray *)keywords 
           andBlockKeywords:(NSArray *)blockKeywords 
			  keyValuePairs:(NSDictionary *)keyValuePairs	
                    loadNow:(BOOL)flag;
- (BOOL)prepareWithSlotSize:(CGSize)slotSize
                   slotName:(NSString *)slotKey 
                   keywords:(NSArray *)keywords 
           andBlockKeywords:(NSArray *)blockKeywords 
                    loadNow:(BOOL)flag;
- (BOOL)prepareWithSlotType:(MedialetsAdSlotType)slotType 
                   slotName:(NSString *)slotKey 
                   keywords:(NSArray *)keywords 
           andBlockKeywords:(NSArray *)blockKeywords 
                    loadNow:(BOOL)flag;
- (BOOL)prepareWithSlotType:(MedialetsAdSlotType)slotType 
                   slotName:(NSString *)slotKey 
                   keywords:(NSArray *)keywords 
           andBlockKeywords:(NSArray *)blockKeywords 
			  keyValuePairs:(NSDictionary *)keyValuePairs	
                    loadNow:(BOOL)flag;
- (BOOL)prepareWithadID:(NSString *)slotKey 
				   adID:(NSString*) adID;
- (BOOL)prepareWithadID:(NSString *)slotKey 
				   adID:(NSString*) adID
		  keyValuePairs:(NSDictionary *)keyValuePairs;	
- (BOOL)populateWithadID:(UIWebView *)webView 
					adID:(NSString *)adID;
- (BOOL)populateWithadID:(UIWebView *)webView 
					adID:(NSString *)adID
		   keyValuePairs:(NSDictionary *)keyValuePairs;	
- (BOOL)adInterrogator:(NSURLRequest *)request 
					inWebView:(UIWebView *)webView
					navigationType:(UIWebViewNavigationType)navigationType;

- (BOOL)loadAdIfNeeded;
- (void)displayInterstitial;
- (IBAction)dismissInterstitial:(id)sender;
- (void)displayNonInterstitial;
- (void)displayWebViewAd:(UIWebView*)parentview;
- (void)adViewDismissEmbeddedBrowser;
- (void)dismissWebViewAd;
- (void)dismissAd;
- (void)expandAd;



@end

@interface MedialetsAdManager : NSObject {
}

+ (id)sharedInstance;

- (void)initialize:(BOOL)locationTracking;
- (void)initializeWithAppID:(NSString *)anAppID appVersion:(NSString *)version locationManager:(CLLocationManager *)locManager locationTracking:(BOOL)locationAccessEnabled;

- (void)resumeMediaDownload;
- (void)pauseMediaDownload;
- (void)registerWebView:(MedialetsAdSlotType)slotType 
				  slotName:(NSString *)slotKey 
				  keywords:(NSArray *)keywords 
		  andBlockKeywords:(NSArray *)blockKeywords 
				 inWebView:(UIWebView *)webView;
- (void)registerWebViewWithSlotSize:(CGSize)slotSize 
			   slotName:(NSString *)slotKey 
			   keywords:(NSArray *)keywords 
	   andBlockKeywords:(NSArray *)blockKeywords 
			  inWebView:(UIWebView *)webView;

//- (void)initializeAdServiceTestModeEnabled:(BOOL)flag;

@end
