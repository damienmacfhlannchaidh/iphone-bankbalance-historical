/*
 *  BankBalance.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

//DEMO
#define DEMO_MODE						0

//BACKGROUND
#define BACKGROUND_IMAGE				@"Default.png"

//FONTS
#define STANDARD_FONT					@"HelveticaNeue"
#define BOLD_FONT						@"HelveticaNeue-Bold"

//FILES
#define PIN_TRIES_FILENAME				@"IncorrectPinTries.plist"

//ANALYTICS
#define FLURRY_APP_ID					@"VACKJMVYGNWYMS5ZZFXR"
#define FLURRY_PIN_SET_EVENT			@"PIN_SET"
#define FLURRY_AIB_EVENT				@"AIB"
#define FLURRY_BOI_EVENT				@"BOI"
#define FLURRY_BOI_SECURITY_PAGE		@"BOI_SECURITY_PAGE"
#define FLURRY_PIN_SECURITY_USED		@"PIN_SECURITY_USED"

//PREFS
#define PREFS_PIN_PROTECTION			@"PREFS_PIN_PROTECTION"

//PIN
#define PIN_COUNT						@"PIN_COUNT"
#define PIN_CHAR						@"•"
#define BLANK_CHAR						@""

//KEYCHAIN KEYS
#define KC_APP_PIN						@"KCAPPPIN"
#define KC_AIB_REG_NO					@"KCAIBREGNO"
#define KC_AIB_PIN_NO					@"KCAIBPINNO"
#define KC_AIB_HOME_NO					@"KCAIBHOMENO"
#define KC_AIB_WORK_NO					@"KCAIBWORKNO"
#define KC_AIB_VISA_NO					@"KCAIBVISANO"
#define KC_AIB_MASTER_NO				@"KCAIBMASTERNO"
#define KC_BOI_LOGIN_ID					@"KCBOILOGINID"
#define KC_BOI_PIN_NO					@"KCBOIPINNO"
#define KC_BOI_DOB_NO					@"KCBOIDOBNO"
#define KC_BOI_CONTACT_NO				@"KCBOICONTACTNO"

//AIB URL(s)
#define AIB_BASEURL						@"https://aibinternetbanking.aib.ie/inet/roi/login.htm"

//BOI URL(s)
#define BOI_URL1						@"https://www1.365online.com/servlet/Dispatcher/login.htm"
#define BOI_URL2						@"https://www1.365online.com/servlet/Dispatcher/login2.htm"
#define BOI_URL3						@"https://www1.365online.com/servlet/Dispatcher/validate.htm"
//#define BOI_URL4						@"https://www1.365online.com/servlet/365OnlineSecurityInformation.htm"
#define BOI_URL4						@"https://www1.365online.com/servlet/Dispatcher/accsum.htm"
#define BOI_URL5						@"https://www1.365online.com/servlet/Dispatcher/endsession.htm"

typedef enum Bank {
	AIB,
	BOI
}Bank;

typedef enum BOIChallangeOptions {
	BOIChallangeContactNumber,
	BOIChallangeDOB
}BOIChallangeOptions;

typedef enum PINViewControllerModes {
	PINCheckMode,
	PINSetMode,
	PINVerifySetMode
}PINViewControllerModes;

typedef enum PrefEntryViewControllerModes {
	AIBRegistrationNumber,
	AIBPINNumber,
	AIBHomePhoneNumber,
	AIBWorkPhoneNumber,
	AIBVisaNumber,
	AIBMastercardNumber,
	BOILoginId,
	BOIPin,
	BOIDateOfBirth,
	BOIContactNumber
}PrefEntryViewControllerModes;

@interface BankBalance : NSObject {
	
}

+ (BOOL)isAppPinSet;
+ (BOOL)checkForInternetConnection;

@end