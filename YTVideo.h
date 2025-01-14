/*
* This header is generated by classdump-dyld 0.7
* on Saturday, November 2, 2024, 8:30:04 PM Eastern Daylight Time
* Operating System: Version 6.1.3 (Build 10B329)
* Image Source: /private/var/root/YouTube110
* classdump-dyld is licensed under GPLv3, Copyright © 2013-2014 by Elias Limneos.
*/

@class NSSet, NSString, NSDate, YTVideoState, NSArray, NSDictionary, NSURL, YTVideoPro;

@interface YTVideo : NSObject <NSCopying> {

	char monetized_;
	NSSet* monetizedCountries_;
	NSSet* allowedCountries_;
	NSSet* deniedCountries_;
	NSString* ID_;
	NSString* title_;
	NSString* videoDescription_;
	NSString* uploaderDisplayName_;
	NSString* uploaderChannelID_;
	NSDate* uploadedDate_;
	NSDate* publishedDate_;
	unsigned duration_;
	unsigned long long viewCount_;
	unsigned long long likesCount_;
	unsigned long long dislikesCount_;
	char ratingAllowed_;
	YTVideoState* state_;
	NSArray* streams_;
	NSDictionary* thumbnailURLs_;
	NSURL* subtitlesTracksURL_;
	char commentsAllowed_;
	NSURL* commentsURL_;
	unsigned long long commentsCountHint_;
	NSURL* relatedURL_;
	char claimed_;
	NSString* categoryLabel_;
	NSString* categoryTerm_;
	char adultContent_;
	NSURL* editURL_;
	YTVideoPro* videoPro_;

}

@property (nonatomic,readonly) NSString * ID; 
@property (nonatomic,readonly) NSString * title; 
@property (nonatomic,readonly) NSString * videoDescription; 
@property (nonatomic,readonly) NSString * uploaderDisplayName; 
@property (nonatomic,readonly) NSString * uploaderChannelID; 
@property (nonatomic,readonly) NSDate * uploadedDate; 
@property (nonatomic,readonly) NSDate * publishedDate; 
@property (nonatomic,readonly) unsigned duration; 
@property (nonatomic,readonly) unsigned long long viewCount; 
@property (nonatomic,readonly) unsigned long long likesCount; 
@property (nonatomic,readonly) unsigned long long dislikesCount; 
@property (nonatomic,readonly) char ratingAllowed; 
@property (nonatomic,readonly) YTVideoState * state; 
@property (nonatomic,readonly) NSArray * streams; 
@property (nonatomic,readonly) NSDictionary * thumbnailURLs; 
@property (nonatomic,readonly) NSURL * subtitlesTracksURL; 
@property (getter=isCommentsAllowed,nonatomic,readonly) char commentsAllowed; 
@property (nonatomic,readonly) NSURL * commentsURL; 
@property (nonatomic,readonly) unsigned long long commentsCountHint; 
@property (nonatomic,readonly) NSURL * relatedURL; 
@property (getter=isClaimed,nonatomic,readonly) char claimed; 
@property (nonatomic,readonly) NSString * categoryLabel; 
@property (nonatomic,readonly) NSString * categoryTerm; 
@property (getter=isAdultContent,nonatomic,readonly) char adultContent; 
@property (nonatomic,readonly) NSURL * editURL; 
@property (nonatomic,readonly) YTVideoPro * videoPro; 
-(char)isAdultContent;
-(char)ratingAllowed;
-(char)isCommentsAllowed;
-(NSString *)uploaderChannelID;
-(char)couldBeMusic;
-(char)isClaimed;
-(NSDate *)uploadedDate;
-(NSDate *)publishedDate;
-(NSURL *)relatedURL;
-(unsigned long long)likesCount;
-(unsigned long long)dislikesCount;
-(NSURL *)subtitlesTracksURL;
-(char)isMonetizedWithCountryCode:(id)arg1 ;
-(NSString *)uploaderDisplayName;
-(YTVideoPro *)videoPro;
-(NSDictionary *)thumbnailURLs;
-(id)initWithID:(id)arg1 title:(id)arg2 description:(id)arg3 uploaderDisplayName:(id)arg4 uploaderChannelID:(id)arg5 uploadedDate:(id)arg6 publishedDate:(id)arg7 duration:(unsigned)arg8 viewCount:(unsigned long long)arg9 likesCount:(unsigned long long)arg10 dislikesCount:(unsigned long long)arg11 ratingAllowed:(char)arg12 state:(id)arg13 streams:(id)arg14 thumbnailURLs:(id)arg15 subtitlesTracksURL:(id)arg16 commentsAllowed:(char)arg17 commentsURL:(id)arg18 commentsCountHint:(unsigned long long)arg19 relatedURL:(id)arg20 claimed:(char)arg21 monetized:(char)arg22 monetizedCountries:(id)arg23 allowedCountries:(id)arg24 deniedCountries:(id)arg25 categoryLabel:(id)arg26 categoryTerm:(id)arg27 adultContent:(char)arg28 editURL:(id)arg29 videoPro:(id)arg30 ;
-(NSArray *)streams;
-(unsigned long long)commentsCountHint;
-(NSString *)categoryLabel;
-(NSString *)categoryTerm;
-(NSURL *)editURL;
-(unsigned)duration;
-(NSString *)title;
-(NSString *)ID;
-(char)isEncrypted;
-(id)init;
-(void)dealloc;
-(id)copyWithZone:(NSZone*)arg1 ;
-(char)isEqual:(id)arg1 ;
-(unsigned)hash;
-(YTVideoState *)state;
-(unsigned long long)viewCount;
-(NSURL *)commentsURL;
-(NSString *)videoDescription;
@end

