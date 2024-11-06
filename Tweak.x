/*
TubeRepair - Main Class
Optimized and Organized
2024-01-06
*/

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TubeRepair.h"
#import "YTVideo.h"
#import "YTPlayerController.h"

// Set default URL if not already set
void betaSetDefaultUrl(void) {
    NSString *defaultApiKey = @"http://ax.init.mali357.gay/TubeRepair/";
    NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if (![prefs objectForKey:@"URLEndpoint"]) {
        [prefs setObject:defaultApiKey forKey:@"URLEndpoint"];
        [prefs writeToFile:settingsPath atomically:YES];
    }
}

%group Baseplate

// Hook NSURL for URL modifications
%hook NSURL

+ (instancetype)URLWithString:(NSString *)URLString {
    NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *modifiedURLString = URLString;
    NSString *newURL = [prefs objectForKey:@"URLEndpoint"];
    
    if (newURL && [URLString rangeOfString:@"https://www.google.com"].location != NSNotFound) {
        modifiedURLString = [URLString stringByReplacingOccurrencesOfString:@"https://www.google.com" withString:newURL];
    }
    
    if (newURL && [URLString rangeOfString:@"https://gdata.youtube.com"].location != NSNotFound) {
        modifiedURLString = [URLString stringByReplacingOccurrencesOfString:@"https://gdata.youtube.com" withString:newURL];
    }
    
    NSURL *modifiedURL = %orig(modifiedURLString);
    return modifiedURL;
}

%end

// Hook NSMutableURLRequest to add custom headers
%hook NSMutableURLRequest

+ (instancetype)requestWithURL:(NSURL *)URL {
    NSMutableURLRequest *request = %orig(URL);
    addCustomHeaderToRequest(request);
    return request;
}

+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    NSMutableURLRequest *request = %orig(URL, cachePolicy, timeoutInterval);
    addCustomHeaderToRequest(request);
    return request;
}

%end

// static YTStream* YTStreamInstance;

void sendToServer(NSData *passData, void (^completionHandler)(NSString *responseString, NSError *error)) {
    // Get URL
    NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *serverURL = [prefs objectForKey:@"URLEndpoint"];

    if (![serverURL hasSuffix:@"/"]) {
        // Append a slash if it doesn't have one
        serverURL = [serverURL stringByAppendingString:@"/getURL"];
    }
    else {
        // Else append the route
        serverURL = [serverURL stringByAppendingString:@"getURL"];
    }

    // Create the Request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    // Set to POST
    urlRequest.HTTPMethod = @"POST";
    // Tell the server it's json
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // Set what YouTube sent us to the request data.
    urlRequest.HTTPBody = passData;

    // Define the completion block to handle response
    void (^completion)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            // If there's an error, pass the error to the completion handler
            completionHandler(nil, error);
        } else {
            // Convert the response data to a string
            NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            // Pass the URL string to the completion handler
            completionHandler(urlString, nil);
        }
    };

    // Create the queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // Send the request
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:completion];
}
/*
NSString* sendToServer(NSData *passData) {
    // Get URL
    NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *serverURL = [prefs objectForKey:@"URLEndpoint"];

    if (![serverURL hasSuffix:@"/"]) {
        // Append a slash if it doesn't have one
        serverURL = [serverURL stringByAppendingString:@"/haha"];
    }
    else {
        // Else append the route
        serverURL = [serverURL stringByAppendingString:@"haha"];
    }

    // Create the Request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    // Set to POST
    urlRequest.HTTPMethod = @"POST";
    // Tell the server it's json
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // TODO: Maybe use this?
    NSURLResponse * response = nil;
    // Set what YouTube sent us to the request data.
    urlRequest.HTTPBody = passData;
    // TODO: Maybe use this?
    NSError * error = nil;
    // Fire the request
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                            returningResponse:&response
                                                        error:&error];

    // Convert NSData to NSString
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    // Extract the URL
    NSString *urlString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return urlString;
}
*/

void getInnerTubeVideo(NSString *videoID, void (^completionHandler)(NSString *urlString, NSError *error)) {
    // InnerTube
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/player?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8"]];
    // Set to post
    urlRequest.HTTPMethod = @"POST";
    NSURLResponse * response = nil;
    //NSString * userAgent = @"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.6099.46 Safari/537.36";
    //[urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    // Tell the server it's json. Might be useless here.
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *jsonError = nil;
    // Data building.
    NSDictionary *client = @{@"clientName": @"ANDROID",
                             @"clientVersion": @"19.17.34"};
    NSDictionary *context = @{@"client": client};
    // Combined Client and context for body.
    NSDictionary *jsonDict = @{@"context": context,
                               @"params": @"8AEB",
                               @"videoId": videoID};
    // Convert to Json
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonError];
    // Set to body
    urlRequest.HTTPBody = requestBodyData;
    NSError * error = nil;
    // Fire request
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                            returningResponse:&response
                                                        error:&error];
    if (error)
    {
        // Error
        completionHandler(nil, error);
    } else {
        // Send to server to format for us.
        sendToServer(data, ^(NSString *responseString, NSError *error) {
            if (error) {
                // If it errors
                completionHandler(nil, error);
            } else {
                // Send String (URL) back
                completionHandler(responseString, nil);
            }
        });
    }
}
/*
NSString* getInnerTubeVideo(NSString *videoID) {
    // Send a synchronous request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/player?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8"]];
    //NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.152:4000/haha"]];
    urlRequest.HTTPMethod = @"POST";
    NSURLResponse * response = nil;
    //NSString * userAgent = @"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.6099.46 Safari/537.36";
    //[urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    //[urlRequest setValue:@"www.youtube.com" forHTTPHeaderField:@"Host"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *jsonError = nil;
    NSDictionary *client = @{@"clientName": @"ANDROID",
                             @"clientVersion": @"19.17.34"};
    NSDictionary *context = @{@"client": client};
    NSDictionary *jsonDict = @{@"context": context,
                               @"params": @"8AEB",
                               @"videoId": videoID};
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonError];
    urlRequest.HTTPBody = requestBodyData;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                            returningResponse:&response
                                                        error:&error];
        
    if (error == nil)
    {
        sendToServer(data, ^(NSString *responseString, NSError *error) {
            if (error) {
                return;  // Just exit the block on error
            } else {
                return;  // Exit the block after processing the response
            }
        });
    }
    return nil;
}
*/

static NSString *updatedUrl;

%hook YTStream    

- (id)initWithURL:(id)arg1 format:(int)arg2 encrypted:(char)arg3 {
    //getInnerTube();
    NSURL *customURL = [NSURL URLWithString:updatedUrl];
    return %orig(customURL, arg2, arg3);

}

%end

%hook YTPlayerController

// TODO: Add button to toggle using this.
// If it's not on it'll just call %orig
-(void)loadVideoStream {
    // Get Video
    YTVideo *video_ = [self valueForKey:@"video_"];
    // Get Video Id
    NSString *videoID = [video_ valueForKey:@"ID_"];
    // Get the youtube link!
    getInnerTubeVideo(videoID, ^(NSString *urlString, NSError *error) {
        if (error) {
            return;
        }

        updatedUrl = urlString;

        // Continue with the original method after the update
        %orig;
    });
}

/*
-(void)loadVideoStream {
    YTVideo *video_ = [self valueForKey:@"video_"];
    NSString *URL__ = [video_ valueForKey:@"ID_"];
    updatedUrl = getInnerTubeVideo(URL__);
    %orig;
    return;
}
*/

%end

%hook YTSignInPopoverController_iPhone

- (void)presentInPopoverFromRect:(CGRect)a3 inView:(id)a4 permittedArrowDirections:(unsigned int)a5 resourceLoader:(id)a6 {
    // Step 1: Request Device Code
    NSURL *deviceCodeRequestURL = [NSURL URLWithString:@"https://oauth2.googleapis.com/device/code"];
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    
    // Prepare the dictionary with request parameters
    NSDictionary *requestParams = @{
        @"client_id": globalClientID,
        @"client_secret": globalClientSecret,
        @"scope": @"http://gdata.youtube.com https://www.googleapis.com/auth/youtube-paid-content",
        @"device_id": uuidString, // Use the generated UUID
        @"device_model": @"ytlr::", // Assuming this value is static; replace as needed
        @"grant_type": @"urn:ietf:params:oauth:grant-type:device_code"
    };

    NSError *error;
    NSData *deviceCodeRequestBodyData = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:&error];
    if (error) {
        NSLog(@"Error serializing request body: %@", error.localizedDescription);
        return;
    }

    NSMutableURLRequest *deviceCodeRequest = [NSMutableURLRequest requestWithURL:deviceCodeRequestURL];
    [deviceCodeRequest setHTTPMethod:@"POST"];
    [deviceCodeRequest setHTTPBody:deviceCodeRequestBodyData];
    [deviceCodeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSError *deviceCodeError;
    NSURLResponse *deviceCodeResponse;
    NSData *deviceCodeResponseData = [NSURLConnection sendSynchronousRequest:deviceCodeRequest returningResponse:&deviceCodeResponse error:&deviceCodeError];

    __block NSString *deviceCode = nil;
    __block UIAlertView *deviceCodeAlert = nil;
    
    if (!deviceCodeError && deviceCodeResponseData) {
        NSDictionary *deviceCodeResponseDict = [NSJSONSerialization JSONObjectWithData:deviceCodeResponseData options:0 error:&deviceCodeError];
        if (!deviceCodeError && deviceCodeResponseDict) {
            deviceCode = deviceCodeResponseDict[@"device_code"];
            NSString *userCode = deviceCodeResponseDict[@"user_code"];
            NSString *verificationURL = deviceCodeResponseDict[@"verification_url"];

            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *message = [NSString stringWithFormat:@"Please visit %@ and enter the code: %@, this is required In order to sign into TubeRepair securely, you only need to do this once, this message will close when verification completes or after one minute.", verificationURL, userCode];
                deviceCodeAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Required" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [deviceCodeAlert show];

                // Schedule the alert to be dismissed after 1 minute
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (deviceCodeAlert.visible) {
                        [deviceCodeAlert dismissWithClickedButtonIndex:0 animated:YES];
                    }
                });
            });

            // Move to background thread for polling
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Step 2: Polling for the OAuth token
                BOOL shouldContinuePolling = YES;
                NSDate *pollingEndTime = [[NSDate date] dateByAddingTimeInterval:60];

                while (shouldContinuePolling && [[NSDate date] compare:pollingEndTime] == NSOrderedAscending) {
                    [NSThread sleepForTimeInterval:5]; // Poll every 5 seconds

                    NSString *tokenRequestBodyString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&device_code=%@&grant_type=urn:ietf:params:oauth:grant-type:device_code", globalClientID, globalClientSecret, deviceCode];
                    NSData *tokenRequestBodyData = [tokenRequestBodyString dataUsingEncoding:NSUTF8StringEncoding];

                    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://oauth2.googleapis.com/token"]];
                    [tokenRequest setHTTPMethod:@"POST"];
                    [tokenRequest setHTTPBody:tokenRequestBodyData];
                    [tokenRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

                    NSError *error;
                    NSURLResponse *response;
                    NSData *tokenResponseData = [NSURLConnection sendSynchronousRequest:tokenRequest returningResponse:&response error:&error];

                    if (!error && tokenResponseData) {
                        NSDictionary *tokenResponse = [NSJSONSerialization JSONObjectWithData:tokenResponseData options:0 error:&error];
                        if (!error && tokenResponse) {
                            NSString *accessToken = tokenResponse[@"access_token"];
                            NSString *refreshToken = tokenResponse[@"refresh_token"];
                            NSNumber *expiresIn = tokenResponse[@"expires_in"];

                            if (accessToken && expiresIn) {
                                // Calculate and save the expiration date
                                NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:[expiresIn doubleValue]];
                                NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
                                NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

                                [prefs setObject:accessToken forKey:@"OAuthAccessToken"];
                                [prefs setObject:expirationDate forKey:@"OAuthTokenExpirationDate"];
                                [prefs setObject:refreshToken forKey:@"OAuthRefreshToken"];
                                [prefs writeToFile:settingsPath atomically:YES];

                                // Notify the user of successful authentication and dismiss alert
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (deviceCodeAlert.visible) {
                                        [deviceCodeAlert dismissWithClickedButtonIndex:0 animated:YES];
                                    }
                                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Successful" message:@"You have been successfully authenticated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [successAlert show];
                                });
                                shouldContinuePolling = NO;
                            } else if ([tokenResponse[@"error"] isEqualToString:@"authorization_pending"]) {
                                // Continue polling
                            } else {
                                // Stop polling and handle error
                                shouldContinuePolling = NO;
                                NSLog(@"Error during token polling: %@", tokenResponse[@"error"]);
                            }
                        }
                    } else {
                        // Stop polling and handle error
                        shouldContinuePolling = NO;
                        NSLog(@"Error requesting token: %@", error);
                    }
                }
            });
        }
    }
}

%end

%hook YTNavigation_iPad

- (void)showSignInFromRect:(CGRect)rect inView:(id)view auth:(id)auth authedBlock:(id)authedBlock failedBlock:(id)failedBlock canceledBlock:(id)canceledBlock {
    // Step 1: Request Device Code
    NSURL *deviceCodeRequestURL = [NSURL URLWithString:@"https://oauth2.googleapis.com/device/code"];
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    
    // Prepare the dictionary with request parameters
    NSDictionary *requestParams = @{
        @"client_id": globalClientID,
        @"client_secret": globalClientSecret,
        @"scope": @"http://gdata.youtube.com https://www.googleapis.com/auth/youtube-paid-content",
        @"device_id": uuidString, // Use the generated UUID
        @"device_model": @"ytlr::", // Assuming this value is static; replace as needed
        @"grant_type": @"urn:ietf:params:oauth:grant-type:device_code"
    };

    NSError *error;
    NSData *deviceCodeRequestBodyData = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:&error];
    if (error) {
        NSLog(@"Error serializing request body: %@", error.localizedDescription);
        return;
    }

    NSMutableURLRequest *deviceCodeRequest = [NSMutableURLRequest requestWithURL:deviceCodeRequestURL];
    [deviceCodeRequest setHTTPMethod:@"POST"];
    [deviceCodeRequest setHTTPBody:deviceCodeRequestBodyData];
    [deviceCodeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSError *deviceCodeError;
    NSURLResponse *deviceCodeResponse;
    NSData *deviceCodeResponseData = [NSURLConnection sendSynchronousRequest:deviceCodeRequest returningResponse:&deviceCodeResponse error:&deviceCodeError];

    __block NSString *deviceCode = nil;
    __block UIAlertView *deviceCodeAlert = nil;
    
    if (!deviceCodeError && deviceCodeResponseData) {
        NSDictionary *deviceCodeResponseDict = [NSJSONSerialization JSONObjectWithData:deviceCodeResponseData options:0 error:&deviceCodeError];
        if (!deviceCodeError && deviceCodeResponseDict) {
            deviceCode = deviceCodeResponseDict[@"device_code"];
            NSString *userCode = deviceCodeResponseDict[@"user_code"];
            NSString *verificationURL = deviceCodeResponseDict[@"verification_url"];

            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *message = [NSString stringWithFormat:@"Please visit %@ and enter the code: %@, this is required In order to sign into TubeRepair securely, you only need to do this once, this message will close when verification completes or after one minute.", verificationURL, userCode];
                deviceCodeAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Required" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [deviceCodeAlert show];

                // Schedule the alert to be dismissed after 1 minute
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (deviceCodeAlert.visible) {
                        [deviceCodeAlert dismissWithClickedButtonIndex:0 animated:YES];
                    }
                });
            });

            // Move to background thread for polling
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Step 2: Polling for the OAuth token
                BOOL shouldContinuePolling = YES;
                NSDate *pollingEndTime = [[NSDate date] dateByAddingTimeInterval:60];

                while (shouldContinuePolling && [[NSDate date] compare:pollingEndTime] == NSOrderedAscending) {
                    [NSThread sleepForTimeInterval:5]; // Poll every 5 seconds

                    NSString *tokenRequestBodyString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&device_code=%@&grant_type=urn:ietf:params:oauth:grant-type:device_code", globalClientID, globalClientSecret, deviceCode];
                    NSData *tokenRequestBodyData = [tokenRequestBodyString dataUsingEncoding:NSUTF8StringEncoding];

                    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://oauth2.googleapis.com/token"]];
                    [tokenRequest setHTTPMethod:@"POST"];
                    [tokenRequest setHTTPBody:tokenRequestBodyData];
                    [tokenRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

                    NSError *error;
                    NSURLResponse *response;
                    NSData *tokenResponseData = [NSURLConnection sendSynchronousRequest:tokenRequest returningResponse:&response error:&error];

                    if (!error && tokenResponseData) {
                        NSDictionary *tokenResponse = [NSJSONSerialization JSONObjectWithData:tokenResponseData options:0 error:&error];
                        if (!error && tokenResponse) {
                            NSString *accessToken = tokenResponse[@"access_token"];
                            NSString *refreshToken = tokenResponse[@"refresh_token"];
                            NSNumber *expiresIn = tokenResponse[@"expires_in"];

                            if (accessToken && expiresIn) {
                                // Calculate and save the expiration date
                                NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:[expiresIn doubleValue]];
                                NSString *settingsPath = @"/var/mobile/Library/Preferences/bag.xml.tuberepairpreference.plist";
                                NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

                                [prefs setObject:accessToken forKey:@"OAuthAccessToken"];
                                [prefs setObject:expirationDate forKey:@"OAuthTokenExpirationDate"];
                                [prefs setObject:refreshToken forKey:@"OAuthRefreshToken"];
                                [prefs writeToFile:settingsPath atomically:YES];

                                // Notify the user of successful authentication and dismiss alert
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (deviceCodeAlert.visible) {
                                        [deviceCodeAlert dismissWithClickedButtonIndex:0 animated:YES];
                                    }
                                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Successful" message:@"You have been successfully authenticated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [successAlert show];
                                });
                                shouldContinuePolling = NO;
                            } else if ([tokenResponse[@"error"] isEqualToString:@"authorization_pending"]) {
                                // Continue polling
                            } else {
                                // Stop polling and handle error
                                shouldContinuePolling = NO;
                                NSLog(@"Error during token polling: %@", tokenResponse[@"error"]);
                            }
                        }
                    } else {
                        // Stop polling and handle error
                        shouldContinuePolling = NO;
                        NSLog(@"Error requesting token: %@", error);
                    }
                }
            });
        }
    }
}

%end

%end

// Group hooks by iOS versions
%group iOS8

%hook YTSuggestService

- (instancetype)initWithOperationQueue:(id)operationQueue HTTPFetcherService:(id)httpFetcherService {
    return 0;
}

%end

%hook YTSearchHistory

- (id)history {
    return 0;
}

%end

%end

%ctor {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    float version = [systemVersion floatValue];
    
    if (version >= 2.0 && version < 11.0) {
        %init(Baseplate);
        betaSetDefaultUrl();
        fetchYouTubeTVPageAndExtractClientID(^(BOOL success, NSString *clientID, NSString *clientSecret) {
            if (success) {
                NSLog(@"Successfully extracted client ID: %@ and secret: %@", clientID, clientSecret);
            } else {
                NSLog(@"Failed to extract client ID and secret.");
            }
        });
        if (version >= 8.0) {
            %init(iOS8);
        }
    }
}