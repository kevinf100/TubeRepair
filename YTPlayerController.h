@protocol YTPlayerControllerUIDelegate, YTPlayerControllerPlaybackDelegate, YTPlayerServices, YTSubtitlesConfig, YTPlayerControlsVisibilityDelegate;
@class YTPlayer, YTPlayerView, YTSubtitlesController, YTDRMStreamConverter, UIWindow, YTVASTAd, YTStream, YTVideo, YTVideoStatsService, YTAdTrackingService, YTPTrackingService;

@interface YTPlayerController : NSObject {

	int state_;
	YTPlayer* player_;
	YTPlayerView* playerView_;
	int source_;
	YTSubtitlesController* subtitlesController_;
	YTDRMStreamConverter* DRMStreamConverter_;
	double savedSeekTime_;
	id<YTPlayerControllerUIDelegate> playerControllerUIDelegate_;
	id<YTPlayerControllerPlaybackDelegate> playerControllerPlaybackDelegate_;
	UIWindow* secondScreenWindow_;
	YTVASTAd* vastAd_;
	YTStream* adStream_;
	YTStream* videoStream_;
	YTVideo* video_;
	char hasFocus_;
	char videoAddedToHistory_;
	char wasPlayingBeforeSeeking_;
	char isUserScrubbing_;
	char brandingRequested_;
	char startPlayback_;
	id<YTPlayerServices> playerServices_;
	YTVideoStatsService* videoStatsService_;
	YTAdTrackingService* adTrackingService_;
	YTPTrackingService* PTrackingService_;
	id<YTSubtitlesConfig> subtitlesConfig_;
	id<YTPlayerControlsVisibilityDelegate> controlsVisibilityDelegate_;
	char backgroundPlaybackAllowed_;

}

@property (assign,nonatomic) id<YTPlayerControlsVisibilityDelegate> controlsVisibilityDelegate; 
@property (assign,nonatomic) char backgroundPlaybackAllowed; 
-(void)setPlayerControllerUIDelegate:(id)arg1 ;
-(void)setControlsVisibilityDelegate:(id<YTPlayerControlsVisibilityDelegate>)arg1 ;
-(void)didGainFocus;
-(void)willLoseFocus;
-(void)animateControlsToHidden;
-(id)initWithPlayerServices:(id)arg1 playerView:(id)arg2 player:(id)arg3 video:(id)arg4 source:(int)arg5 subtitlesConfig:(id)arg6 startPlayback:(char)arg7 ;
-(void)appDidEnterBackground;
-(void)appDidBecomeActive;
-(void)airPlayDidChangeToActive:(char)arg1 ;
-(void)stateDidChangeFromState:(int)arg1 toState:(int)arg2 ;
-(void)bufferedMediaTimeDidChangeToTime:(double)arg1 ;
-(void)currentMediaTimeDidChangeToTime:(double)arg1 ;
-(void)currentMediaTimeDidJumpForward;
-(char)backgroundPlaybackAllowed;
-(void)setBackgroundPlaybackAllowed:(char)arg1 ;
-(void)didPressPause;
-(void)didPressPlay;
-(void)didPressSmallscreen;
-(void)didPressFullscreen;
-(void)didPressSubtitlesInRect:(CGRect)arg1 inView:(id)arg2 ;
-(void)didPressReplay;
-(void)didStartScrubbing;
-(void)didSeekToTime:(double)arg1 ;
-(void)didEndScrubbing;
-(void)playerViewDidPressSkipAd;
-(void)playerViewDidPressAdLearnMore;
-(void)playerViewDidPressAdTitle;
-(void)playerViewDidPinchToSmallscreen;
-(void)playerViewDidPinchToFullscreen;
-(void)playerViewDidReceiveTouch;
-(void)playerViewDidShowSkipAd;
-(void)subtitlesPickerDidFailWithError:(id)arg1 message:(id)arg2 ;
-(void)subtitlesPickerDidClose;
-(void)appWillResignActive;
-(void)startSecondScreen:(id)arg1 ;
-(void)stopSecondScreen:(id)arg1 ;
-(void)loadAdThenVideoStreams;
-(void)animateControlsToVisible;
-(void)requestBranding;
-(void)saveMediaTime;
-(void)animateControlsToHiddenWithDuration:(id)arg1 ;
-(void)clearVisibilityTimer;
-(void)animateControlsToHiddenWithDelay;
-(void)refreshPlayerStreamIfNeeded;
-(void)playIfPermitted;
-(void)playerStateDidChangeToReadyToPlay;
-(void)playerStateDidChangeToPlaying;
-(void)playerStateDidChangeToPaused;
-(void)playerStateDidChangeToFinished;
-(void)addVideoToHistory;
-(void)adPlaybackDidStop;
-(void)loadVideoStream;
-(void)setAndPlayVideoStream:(id)arg1 ;
-(void)startCPNServicesForVideo;
-(id)selectStreamForVideo:(id)arg1 devicePrivileges:(id)arg2 ;
-(void)loadConfirmedEncryptedStream:(id)arg1 ;
-(void)didReceiveDRMErrorNotification:(id)arg1 ;
-(void)startCPNServicesForAd;
-(void)setPlayerControllerPlaybackDelegate:(id)arg1 ;
-(id<YTPlayerControlsVisibilityDelegate>)controlsVisibilityDelegate;
-(void)playbackDidFailWithError:(id)arg1 ;
-(id)init;
-(void)dealloc;
@end
