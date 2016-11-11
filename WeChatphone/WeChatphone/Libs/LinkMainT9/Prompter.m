#import "Prompter.h"
#import "Extensions.h"


typedef NSString *Fingerprint;

static const NSUInteger DefaultMaxResults = 20;


@interface Node : NSObject
@property (nonatomic, readonly) NSUInteger idx; // Index into word list
- (id)initWithIdx:(NSUInteger)idx;
- (Node *)subNodeForChar:(unichar)character;
- (Node *)subNodeForChar:(unichar)character ifMissingCreateWithIdx:(NSUInteger)createIdx;
@end


@interface WordPair : NSObject
@property (nonatomic, readonly) NSString *word;
@property (nonatomic, readonly) Fingerprint fingerprint;
- (id)initWithWord:(NSString *)word fingerprint:(Fingerprint)fingerprint;
@end


@implementation Prompter {
  Node *_rootNode;
  NSMutableArray *_wordPairs;
  PrompterMode _mode;
}


- (Prompter *)initWithMode:(PrompterMode)mode
{
  self = [super init];
  if (self) {
    _maxResults = DefaultMaxResults;
    _mode = mode;
  }

  return self;
}


- (Fingerprint)fingerprint:(NSString *)word
{
  if (!word.length) return nil;

  word = [word lowercaseString];
  NSMutableString *fingerprint = [NSMutableString stringWithCapacity:word.length];
  for (NSUInteger j = 0; j < word.length; j++) {
    unichar c = [word characterAtIndex:j];
    switch (c) {
      #define CASE(C, S) case C: [fingerprint appendString:S]; break;

      case 'a':
      case 'b':
      case 'c':
        CASE(2, @"2")
      case 'd':
      case 'e':
      case 'f':
        CASE(3, @"3")
      case 'g':
      case 'h':
      case 'i':
        CASE(4, @"4")
      case 'j':
      case 'k':
      case 'l':
        CASE(5, @"5")
      case 'm':
      case 'n':
      case 'o':
        CASE(6, @"6")
      case 'p':
      case 'q':
      case 'r':
      case 's':
        CASE(7, @"7")
      case 't':
      case 'u':
      case 'v':
        CASE(8, @"8")
      case 'w':
      case 'x':
      case 'y':
      case 'z':
        CASE(9, @"9")
      default:
        switch (_mode) {
          case PrompterModeSkipChar:
            continue;
          case PrompterModeSkipWord:
            return nil;
          case PrompterModeUseZero:
            [fingerprint appendString:@"0"];
            break;
        }
    }
  }
  return fingerprint;
}


- (Fingerprint)sanitizeFingerprint:(NSString *)string
{
  NSMutableString *fingerprint = [NSMutableString stringWithCapacity:string.length];
  [string enumerateCharsUsingBlock:^(unichar character, NSUInteger idx, BOOL *stop) {
    if ((character >= '2' && character <= '9')
        || (character == '0' && _mode == PrompterModeUseZero)) {
      [fingerprint appendFormat:@"%c", character];
    }
  }];
    
    NSLog(@"1  fingerprint   %@",fingerprint);
  return fingerprint;
}


- (NSArray *)getSuggestedWords:(NSArray *)digits
{
  NSMutableString *string = [NSMutableString stringWithCapacity:digits.count];
  for (NSNumber *digit in digits) {
    [string appendFormat:@"%@", digit];
  }
  return [self getSuggestedWordsForString:string];
}
  

- (NSArray *)getSuggestedWordsForString:(NSString *)string
{
  return [self getSuggestedWordsForFingerprint:[self sanitizeFingerprint:string]];
}


- (NSArray *)getSuggestedWordsForFingerprint:(Fingerprint)fingerprint
{
  NSInteger idx = [self idxForFingerPrint:fingerprint];
  if (idx == NSNotFound) return @[];

  NSMutableArray *words = [NSMutableArray arrayWithCapacity:self.maxResults];
  // Try to take maxResults matches from the array
  for (NSInteger maxIdx = MIN(_wordPairs.count, idx + self.maxResults); idx < maxIdx; idx++) {
    WordPair *pair = _wordPairs[(NSUInteger)idx];
    // First part of the if is needed for the case when no search term is entered
    if (fingerprint.length && ![pair.fingerprint hasPrefix:fingerprint]) break;
    [words addObject:pair.word];
//      NSLog(@"3 pair.fingerprint   %@",pair.fingerprint);

  }
//    NSLog(@"2 words   %@",words);

  return words;
}


- (NSInteger)idxForFingerPrint:(Fingerprint)fingerprint
{
  if (!fingerprint.length) return 0; // Show all words

  __block Node *node = _rootNode;
  [fingerprint enumerateCharsUsingBlock:^(unichar character, NSUInteger idx, BOOL *stop) {
    node = [node subNodeForChar:character];
    if (!node) *stop = YES;
  }];
  return node ? node.idx : NSNotFound;
}


- (void)readDictionary:(NSArray *)words
{
  [self readDictionary:words withProgressCallback:^(NSString *string) { }];
}


- (void)readDictionary:(NSArray *)words withProgressCallback:(void (^)(NSString *))callback
{
  static const int notificationStep = 2500;
  CFAbsoluteTime startTime;

  startTime = CFAbsoluteTimeGetCurrent();
  _wordPairs = [NSMutableArray arrayWithCapacity:words.count];
  [words enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
    if (idx % notificationStep == 0) {
      callback([NSString stringWithFormat:@"Fingerprinting words %d%%", (int)(100 * idx / words.count)]);
    }
    Fingerprint fingerprint = [self fingerprint:word];
    if (fingerprint) {
      WordPair *wordPair = [[WordPair alloc] initWithWord:word fingerprint:fingerprint];
      [_wordPairs addObject:wordPair];
    }
  }];
//  NSLog(@"Fingerprinting done in %.2fs", CFAbsoluteTimeGetCurrent() - startTime);

  startTime = CFAbsoluteTimeGetCurrent();
  callback(@"Sorting");
  [_wordPairs sortUsingComparator:^NSComparisonResult(WordPair *a, WordPair *b) {
    NSComparisonResult comparisonResult = [a.fingerprint compare:b.fingerprint];
    return comparisonResult == NSOrderedSame ? [a.word compare:b.word] : comparisonResult;
  }];
  NSLog(@"Sorting done in %.2fs", CFAbsoluteTimeGetCurrent() - startTime);

  startTime = CFAbsoluteTimeGetCurrent();
  _rootNode = [[Node alloc] initWithIdx:0];
  [_wordPairs enumerateObjectsUsingBlock:^(WordPair *pair, NSUInteger idx, BOOL *stop) {
    if (idx % notificationStep == 0) {
      callback([NSString stringWithFormat:@"Building nodes %d%%",(int) (100 * idx / words.count)]);
    }
    [self insertIdx:idx forFingerprint:pair.fingerprint];
  }];
  NSLog(@"Node building done in %.2fs", CFAbsoluteTimeGetCurrent() - startTime);

  NSLog(@"Read dict with %lu words", (unsigned long)_wordPairs.count);
}


- (void)insertIdx:(NSUInteger)idx forFingerprint:(Fingerprint)fingerprint
{
  __block Node *node = _rootNode;
  [fingerprint enumerateCharsUsingBlock:^(unichar character, NSUInteger fingerprintIdx, BOOL *stop) {
    node = [node subNodeForChar:character ifMissingCreateWithIdx:idx];
  }];
}

@end


static NSUInteger UniqueCharCount = 9;

@implementation Node {
  // Sub-nodes for each character. 2-9 come first, then 0
  // Uninitialized nodes are marked with NSNull
  NSMutableArray *_nodes;
}

- (id)initWithIdx:(NSUInteger)idx
{
  self = [super init];
  if (self) {
    _idx = idx;
    _nodes = [NSMutableArray arrayWithCapacity:UniqueCharCount];
    for (NSUInteger i = 0; i < UniqueCharCount; i++) {
      [_nodes addObject:[NSNull null]];
    }
  }

  return self;
}


- (Node *)subNodeForChar:(unichar)character
{
  id node = _nodes[[self arrayIndexForChar:character]];
  return [node isEqual:[NSNull null]] ? nil : node;
}


- (Node *)subNodeForChar:(unichar)character ifMissingCreateWithIdx:(NSUInteger)createIdx
{
  NSUInteger index = [self arrayIndexForChar:character];
  id node = _nodes[index];
  if ([node isEqual:[NSNull null]]) {
    node = [[Node alloc] initWithIdx:createIdx];
    [_nodes replaceObjectAtIndex:index withObject:node];
  }
  return node;
}


- (NSUInteger)arrayIndexForChar:(unichar)character
{
  // Handle absence of '1'
  return character == '0' ? UniqueCharCount - 1 : character - '2';
}

@end

 
@implementation WordPair

- (id)initWithWord:(NSString *)word fingerprint:(Fingerprint)fingerprint
{
  self = [super init];
  if (self) {
    _word = word;
    _fingerprint = fingerprint;
  }
  return self;
}

@end
