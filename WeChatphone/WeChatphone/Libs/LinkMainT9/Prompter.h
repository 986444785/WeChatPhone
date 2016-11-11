#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// Defines how to handle non-letter chars when creating fingerprint
typedef NS_ENUM(NSInteger, PrompterMode) {
  PrompterModeSkipChar, // Skip the character - "team-mate" gets indexed as "teammate" and can be found with 83266283
  PrompterModeSkipWord, // Skip words containing special chars - "team-mate" doesn't get added to dictionary at all
  PrompterModeUseZero,  // Use 0 for special characters - "team-mate" can be found with 832606283
};


@interface Prompter : NSObject 
 
- (Prompter *)initWithMode:(PrompterMode)mode;

- (void)readDictionary:(NSArray *)words;
- (void)readDictionary:(NSArray *)words withProgressCallback:(void (^)(NSString *))callback;
- (NSArray *)getSuggestedWords:(NSArray *)digits;
- (NSArray *)getSuggestedWordsForString:(NSString *)string;

@property NSUInteger maxResults;

@end
