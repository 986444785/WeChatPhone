//
//  ChineseToPinyin.m
//  DialContact
//
//  Created by lczh on 12-2-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChineseToPinyin.h"

static NSMutableDictionary *pinyinMap;

@implementation ChineseToPinyin

+ (NSString *) pinyinFromChiniseString:(NSString *)string
{
	if( !string || ![string length] ) return @"";
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"^"];
	//将Unicode转换为GB18030_2000编码
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
	NSData * gb2312_data = [string dataUsingEncoding:enc];
	
    unsigned char ucHigh, ucLow;
    int  nCode;
    NSString * strValue = @"";
	int iLen = [gb2312_data length];
	char * gb2312_string = ( char *)[gb2312_data bytes];
    for (int i=0; i< iLen; i++)
    {
        //英文，数字覆盖ASCII，一个字节小于0x80
        if ( (unsigned char)gb2312_string[i] < 0x80 )
		{
            //小写字母转大写
			strValue = [strValue stringByAppendingFormat:@"%c", gb2312_string[i] > 95 ? gb2312_string[i]-32 : gb2312_string[i] ];
            
            if (i+2<=iLen) {
                if ((unsigned char)gb2312_string[i+1] >= 0x80)
                    strValue = [strValue stringByAppendingString:@" "];
            } 
            continue;
		}
		
        ucHigh = (unsigned char)gb2312_string[i];
        ucLow  = (unsigned char)gb2312_string[i+1];
        //gb2312高位0xa1-0xf7,低位0xa1-0xfe
        if ( ucHigh < 0xa1 || ucLow < 0xa1){
            //ios符号四字节，高两位为0x9439
            if (ucHigh == 0x94 && ucLow == 0x39) {
                i=i+3;
                strValue = [strValue stringByAppendingString:@"#"];
                if (i+2<iLen) {
                    strValue = [strValue stringByAppendingString:@" "];
                }
            }else {
                i++;
                strValue = [strValue stringByAppendingString:@"#"];
                if (i+2<iLen) {
                    strValue = [strValue stringByAppendingString:@" "];
                }
            }
            continue;
        }
        else
            nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
        
		NSString * strRes = [ChineseToPinyinHelper FindLetter:nCode];
		strValue = [strValue stringByAppendingString:strRes];
        if (i+2<iLen) {
            strValue = [strValue stringByAppendingString:@" "];
        }        
        i++;
    }
	
    strValue = [strValue stringByReplacingOccurrencesOfString:@"^ " withString:@""];
    strValue = [strValue stringByReplacingOccurrencesOfString:@"^" withString:@" "];
    
	return [[NSString alloc] initWithString:strValue];
}

+ (NSString *)pinyinFromChinise:(NSString *)string
{
	//将Unicode转换为GB18030_2000编码
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
	char * gb2312_string = (char *)[string  cStringUsingEncoding:enc];
	
    if (gb2312_string) {
        unsigned char ucHigh, ucLow;
        int  nCode;
        
        ucHigh = (unsigned char)gb2312_string[0];
        ucLow  = (unsigned char)gb2312_string[1];
        //gb2312高位0xa1-0xf7,低位0xa1-0xfe
        if ( ucHigh < 0xa1 || ucLow < 0xa1){
            return @"#";
        }else{
            nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
            return [ChineseToPinyinHelper FindLetter:nCode];
        }
    }else {
        return @"#";
    }
} 

+ (NSDictionary *) divideString:(NSString *)string
{
    NSArray *strArray = [NSMutableArray array];
    NSMutableArray *fullArray = [NSMutableArray array];
    NSString *pinyinValue = @"";
    NSString *strValue = @"";
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"^"];
    string = [string stringByAppendingString:@"终"];
    int strlength = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char* utf8string = (char*)[string UTF8String];

    UTF8Tag tag = UTF8TagInit;
    UTF8Tag recordTag = UTF8TagInit;
    int i = 0; // 指向原数组的标记。
    int count = 0; // 要拆分的字符个数
    int startIndex = 0; // 当前拆分的字符起始位置
    NSString *str;//待写入字符串
    NSString *tmp;
    
    int fullIndex = 0;//字段索引
    
    while (i < strlength) {
        char b = utf8string[i]; // 起始字符
        if ((b & 0x80) == 0) {
            tag = UTF8TagAscii;
            
        } else if ((b & 0xe0) != 0) {
            // 3个字节的汉字
            tag = UTF8TagChinese;
        } else {
            // 2个字节
            tag = UTF8TagOther;
        }
        
        if (recordTag == UTF8TagInit) {
            recordTag = tag;
        }
        
        //到达该输出时，输出前边那个
        if (recordTag != tag) {
            recordTag = tag;
            if (tag == UTF8TagAscii) {
                //中文->英文
                tmp = [string substringWithRange:NSMakeRange(startIndex, 1)];
                strValue = [strValue stringByAppendingFormat:@"%@^",tmp];
                str = [ChineseToPinyin pinyinFromChinise:tmp];
                pinyinValue = [pinyinValue stringByAppendingFormat:@"%@^",str];
                startIndex = startIndex + 1;
                count = 0;
                count ++;
                i++;
            }else {
                //英文->中文
                tmp = [string substringWithRange:NSMakeRange(startIndex, count)];
                tmp = [tmp stringByReplacingOccurrencesOfString:@"^" withString:@"^ "];
                if ([tmp length]>1 && [[tmp substringFromIndex:[tmp length]-1] isEqualToString:@" "]) {
                        tmp = [tmp substringToIndex:[tmp length]-1];
                
                }
                if ([tmp length]>1 && [[tmp substringToIndex:2]isEqualToString:@"^ "]) {
                        tmp = [tmp substringFromIndex:2];
                    
                }
                if (![tmp isEqualToString:@"^"]) {
                    strValue = [strValue stringByAppendingFormat:@"%@^",tmp];
                    str = [tmp uppercaseString];
                    pinyinValue = [pinyinValue stringByAppendingFormat:@"%@^",str];
                    startIndex = startIndex + count;
                    count = 0;
                    i = i + tag;
                    for (__strong NSString *estr in [str componentsSeparatedByString:@"^ "]) {
                        estr = [estr stringByReplacingOccurrencesOfString:@"^" withString:@""];
                        //分发
                        int num = 0;//累计数
                        for (int k = 0; k <= fullIndex; k++) {
                            //n+(n-1)+(n-2)+...[共k+1个]+k
                            num = num + (fullIndex-k);
                            int to = num + k;
                            [fullArray insertObject:estr atIndex:to];
                        }
                        fullIndex ++;
                    }
                }else {
                    //两个中文间有空格，空格被当作英文，走到这里，跳过去
                    startIndex = startIndex + count;
                    count = 0;
                    i = i + tag;
                }
                
                continue;
            }
        }else{
            if (tag == UTF8TagAscii){
                //英文->英文
                count ++;
                i++;
                continue;
            }else {
                //中文->中文
                if (i == 0) {
                    //首个中文不输出
                    i = i + tag;
                    continue;
                }
                tmp = [string substringWithRange:NSMakeRange(startIndex, 1)];
                strValue = [strValue stringByAppendingFormat:@"%@^",tmp];
                str = [ChineseToPinyin pinyinFromChinise:tmp];
                pinyinValue = [pinyinValue stringByAppendingFormat:@"%@^",str];
                startIndex = startIndex + 1;
                count = 0;
                i = i + tag;
            }
        }
        
        //分发
        int num = 0;//累计数
        for (int k = 0; k <= fullIndex; k++) {
            //n+(n-1)+(n-2)+...[共k+1个]+k
            num = num + (fullIndex-k);
            int to = num + k;
            [fullArray insertObject:str atIndex:to];
        }
        fullIndex ++;
    }
    
    pinyinValue = [pinyinValue stringByReplacingOccurrencesOfString:@"^" withString:@" "];
    pinyinValue = [pinyinValue stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    pinyinValue = [pinyinValue stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    
    strValue = [strValue stringByReplacingOccurrencesOfString:@"^^" withString:@"^"];
    strValue = [strValue stringByReplacingOccurrencesOfString:@"^^" withString:@"^"];
    strArray = [strValue componentsSeparatedByString:@"^"];
    strValue = [strValue stringByReplacingOccurrencesOfString:@"^" withString:@""];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:strValue forKey:kTextString];
    [dic setValue:strArray forKey:kTextArray];
    [dic setValue:pinyinValue forKey:kPinyinString];
    
    //加分隔符
#if 0
    int num = 0;//累计数
    for (int k = 0; k < fullIndex-1; k++) {
        //n+(n-1)+(n-2)+...[共k+1个]+k
        num = num + (fullIndex-k);
        int to = num + k;
        [fullArray insertObject:@"&" atIndex:to];
    }
    fullIndex ++;
#endif
    
    BOOL hasNumOfPinyinValue = NO;
    NSString *fullString = @"";
    int index = 0;
    int num = fullIndex;
    int numOfSection = fullIndex-1;
    for (NSString *str in fullArray) {
        fullString = [fullString stringByAppendingString:[ChineseToPinyin numFromString:str isQuanPin:NO]];
        if (index == num-1 && index < [fullArray count]) {
            if (!hasNumOfPinyinValue) {
                hasNumOfPinyinValue = YES;
                [dic setValue:fullString forKey:kFullNumString];
                [dic setValue:[fullArray subarrayWithRange:NSMakeRange(0, num)] forKey:kFullNumArray];
            }
            fullString = [fullString stringByAppendingString:@"&"];
            num = num + numOfSection;
            numOfSection = numOfSection - 1;
        }
        index++;
    }
    [dic setValue:fullString forKey:kFullNumSearchString];
    return dic;
}

+ (char) sortSectionTitle:(NSString *)string
{
	int cLetter = 0;
	if( !string || 0 == [string length] )
		cLetter = '#';
	else
	{	
		if(([string characterAtIndex:0] > 64 && [string characterAtIndex:0] < 91 ) || 
		   ([string characterAtIndex:0] > 96 && [string characterAtIndex:0] < 123 ) || 
		   ([string characterAtIndex:0] > 47 && [string characterAtIndex:0] < 58 ) ||
           ([string characterAtIndex:0] == 35))
		{
			cLetter = [string characterAtIndex:0];
		}
		else
			cLetter = [ChineseToPinyinHelper pinyinFirstLetter:(unsigned short)[string characterAtIndex:0]];
		
		if( cLetter > 95 )
			cLetter -= 32;
	}
	
	return cLetter;
}

+ (NSString *) titleFromPinyin:(NSString *)pinyin{
    NSArray *pinyinarray = [pinyin componentsSeparatedByString:@" "];
    NSString * strValue = @"";
    for(NSString * pinyinsection in pinyinarray){
        if ([pinyinsection length]) {
            char c = [ChineseToPinyin sortSectionTitle:pinyinsection];
            NSString *strRes = [NSString stringWithFormat:@"%c ",c];
            strValue = [strValue stringByAppendingString:strRes];
        }
    }
    return [[NSString alloc] initWithString:strValue];
}

+ (NSString *) numFromString:(NSString *)string isQuanPin:(bool) boolQuanPin{
    NSData *testData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[testData bytes];
    NSString *strValue = [[NSString alloc] init];
    strValue = @"";
    bool turn;
    
    for(int i=0;i<[testData length];i++){
        if (boolQuanPin) {
            turn = true;
        }else if(testByte[i]==32){
            turn = false;
        }else{
            turn = true;
        }
        if(turn){
            NSString *strRes = [[NSString alloc] init];
            switch(testByte[i]){
                case 35:{
                    strRes = @"#";
                    break;}    
                case 48:{
                    strRes = @"0";
                    break;}
                case 49:{
                    strRes = @"1";
                    break;}
                case 50:    
                case 65:
                case 66:
                case 67:{
                    strRes = @"2";
                    break;}
                case 51:
                case 68:
                case 69:
                case 70:{
                    strRes = @"3";
                    break;}
                case 52:
                case 71:
                case 72:
                case 73:{
                    strRes = @"4";
                    break;}
                case 53:
                case 74:
                case 75:
                case 76:{
                    strRes = @"5";
                    break;}
                case 54:
                case 77:
                case 78:
                case 79:{
                    strRes = @"6";
                    break;}
                case 55:
                case 80:
                case 81:
                case 82:
                case 83:{
                    strRes = @"7";
                    break;}
                case 56:
                case 84:
                case 85:
                case 86:{
                    strRes = @"8";
                    break;}
                case 57:
                case 87:
                case 88:
                case 89:
                case 90:{
                    strRes = @"9";
                    break;}
                case 32:{
                    strRes = @" ";
                    break;
                }
            }
            strValue = [strValue stringByAppendingString:strRes];
        }
    }
    return [[NSString alloc] initWithString:strValue];
}

+ (NSString *)translatePinyinFromOneCharacter:(NSString *)string
{
    if (pinyinMap == NULL)
        pinyinMap = [NSMutableDictionary dictionary];
    
    if(!string.length)
        return @"";
    
    char* utf8string = (char*)[string UTF8String];
    if (utf8string == nil) {
        return @"";
    }
    char beginTag = utf8string[0];
    
    if ((beginTag & 0x80) == 0) {
        // ASCII
        return [NSString stringWithFormat:@"%c", utf8string[0] > 95 ? utf8string[0]-32 : utf8string[0]];
    } else if ((beginTag & 0xe0) != 0) {
        // 3个字节的汉字
        NSString *pinyin = [pinyinMap valueForKey:string];
        if (pinyin.length) {
            return pinyin;
        }else{
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
            char * gb2312_string = (char *)[string  cStringUsingEncoding:enc];
            
            if (gb2312_string) {
                unsigned char ucHigh, ucLow;
                int  nCode;
                
                ucHigh = (unsigned char)gb2312_string[0];
                ucLow  = (unsigned char)gb2312_string[1];
                //gb2312高位0xa1-0xf7,低位0xa1-0xfe
                if ( ucHigh < 0xa1 || ucLow < 0xa1){
                    return @"#";
                }else{
                    nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
                    pinyin = [ChineseToPinyinHelper FindLetter:nCode];
                    [pinyinMap setValue:pinyin forKey:string];
                    return pinyin;
                }
            }else {
                return @"#";
            }
        }
    } else {
        // 2个字节
        return @"#";
    }
}

+ (NSString *)translatePinyinFromString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *result = @"";
    for (int i = 0; i < string.length; i++) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        NSString *pinyin = [ChineseToPinyin translatePinyinFromOneCharacter:str];
        if (i == 0)
            result = pinyin;
        else
            result = [result stringByAppendingFormat:@" %@",pinyin];
    }
    return result;
}

+ (NSString *)translateTitleFromOneCharacter:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return @"";
    }
    
    char firstLetter = [string characterAtIndex:0];
    char result = 0;
	if(!string.length) {
        result = '#';
    }else {
        if((firstLetter > 64 && firstLetter < 91 ) || (firstLetter > 96 && firstLetter < 123 ) || (firstLetter > 47 && firstLetter < 58 ) || (firstLetter == 35)) {
			result = [string characterAtIndex:0];
		}else {
            result = [ChineseToPinyinHelper pinyinFirstLetter:(unsigned short)firstLetter];
        }

		if( result > 95)
			result -= 32;
    }
	return [NSString stringWithFormat:@"%c",result];
}

+ (NSString *)translateTitleFromString:(NSString *)string
{
    NSArray *pinyinarray = [string componentsSeparatedByString:@" "];
    NSString *result = @"";
    
    for (int i = 0; i < pinyinarray.count; i++) {
        NSString *title = [ChineseToPinyin translateTitleFromOneCharacter:[pinyinarray objectAtIndex:i]];
        if ([title isEqualToString:@""]) {
            continue;
        }
        if (i == 0)
            result = title;
        else{
            if ([result isEqualToString:@""]) {
                result = title;
            }else{
                result = [result stringByAppendingFormat:@" %@",title];
            }
        }
    }
    return result;
}

+ (NSString *)translateNumberFromString:(NSString *)string
{
    char* utf8string = (char*)[string UTF8String];
    NSString *strValue = @"";

    for(int i=0;i<string.length;i++){
        NSString *strRes = @"";
        switch(utf8string[i]){
            case 35:
                strRes = @"#";
                break;
            case 48:
                strRes = @"0";
                break;
            case 49:
                strRes = @"1";
                break;
            case 50:
            case 65:
            case 66:
            case 67:
                strRes = @"2";
                break;
            case 51:
            case 68:
            case 69:
            case 70:
                strRes = @"3";
                break;
            case 52:
            case 71:
            case 72:
            case 73:
                strRes = @"4";
                break;
            case 53:
            case 74:
            case 75:
            case 76:
                strRes = @"5";
                break;
            case 54:
            case 77:
            case 78:
            case 79:
                strRes = @"6";
                break;
            case 55:
            case 80:
            case 81:
            case 82:
            case 83:
                strRes = @"7";
                break;
            case 56:
            case 84:
            case 85:
            case 86:
                strRes = @"8";
                break;
            case 57:
            case 87:
            case 88:
            case 89:
            case 90:
                strRes = @"9";
                break;
            case 32:
                strRes = @" ";
                break;
        }
        strValue = [strValue stringByAppendingString:strRes];
    }
    return strValue;
}

+ (void)freePinyinMap
{
    pinyinMap = NULL;
    return;
}

@end