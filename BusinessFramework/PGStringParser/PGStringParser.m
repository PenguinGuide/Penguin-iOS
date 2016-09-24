//
//  PGStringParser.m
//  Penguin
//
//  Created by Jing Dai on 7/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HTML_Tag_Body @"body"
#define HTML_Tag_Div @"div"
#define HTML_Tag_Paragraph @"p"
#define HTML_Tag_Span @"span"
#define HTML_Tag_Style @"style"
#define HTML_Tag_Bold @"b"
#define HTML_Tag_Image @"img"
#define HTML_Tag_Class @"class"
#define HTML_Tag_Hyper_Link @"a"

#define HTML_Attribute_Class @"class"
#define HTML_Attribute_Src @"src"
#define HTML_Attribute_Width @"width"
#define HTML_Attribute_Height @"height"
#define HTML_Attribute_Hyper_Ref @"href"

#define CSS_Style_Color @"color"
#define CSS_Style_Text_Font @"text-font"

#define Paragraph_Class_Catalog_Title @"catalog-title"
#define Paragraph_Class_Video @"video"

#import "PGStringParser.h"
#import "NSString+PGStringParser.h"
#import "Ono.h"

@interface PGStringParser ()

@property (nonatomic, strong) NSString *htmlString;

@end

@implementation PGStringParser

+ (instancetype)htmlParserWithString:(NSString *)htmlString
{
    return [[self alloc] initWithHTMLString:htmlString];
}

- (instancetype)initWithHTMLString:(NSString *)htmlString
{
    if (self = [super init]) {
        self.htmlString = htmlString;
    }
    
    return self;
}

- (NSArray *)articleParsedStorages
{
    if (!self.htmlString || self.htmlString.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:self.htmlString
                                                            encoding:NSUTF8StringEncoding
                                                               error:&error];
    if (!error) {
        ONOXMLElement *body = document.rootElement;
        if (body && [body.tag isEqualToString:HTML_Tag_Body]) {
            
            __block NSMutableArray *storages = [NSMutableArray new];
            [body enumerateElementsWithXPath:@"div[@class=\"content\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                if (idx > 0) {
                    *stop = YES;
                }
                [element enumerateElementsWithXPath:HTML_Tag_Paragraph usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                    if ([element children].count == 0) {
                        if ([element attributes].count == 0) {
                            if (element.stringValue && element.stringValue.length > 0) {
                                // <p></p>
                                PGParserTextStorage *textStorage = [PGParserTextStorage new];
                                NSAttributedString *attrS = [element.stringValue paragraphAttributedString];
                                if (attrS) {
                                    textStorage.text = attrS;
                                    [storages addObject:textStorage];
                                }
                            }
                        } else {
                            if ([element valueForAttribute:HTML_Tag_Class]) {
                                if ([[element valueForAttribute:HTML_Tag_Class] isEqualToString:Paragraph_Class_Catalog_Title]) {
                                    // <p class=catalog-title></p>
                                    if (element.stringValue && element.stringValue.length > 0) {
                                        PGParserTextStorage *textStorage = [PGParserTextStorage new];
                                        NSAttributedString *attrS = [element.stringValue catalogTitleAttributedString];
                                        if (attrS) {
                                            textStorage.text = attrS;
                                            [storages addObject:textStorage];
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if ([[element valueForAttribute:HTML_Tag_Class] isEqualToString:Paragraph_Class_Video]) {
                            // <p class=video></p>
                            __block PGParserVideoStorage *videoStorage = [PGParserVideoStorage new];
                            [element enumerateElementsWithXPath:HTML_Tag_Hyper_Link usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                if (idx > 0) {
                                    *stop = YES;
                                }
                                if ([element valueForAttribute:HTML_Attribute_Hyper_Ref]) {
                                    NSString *href = [element valueForAttribute:HTML_Attribute_Hyper_Ref];
                                    videoStorage.link = href;
                                }
                                
                                [element enumerateElementsWithXPath:HTML_Tag_Image usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                    if (idx > 0) {
                                        *stop = YES;
                                    }
                                    if ([element valueForAttribute:HTML_Attribute_Src]) {
                                        videoStorage.image = [element valueForAttribute:HTML_Attribute_Src];
                                        videoStorage.width = [[element valueForAttribute:HTML_Attribute_Width] floatValue];
                                        videoStorage.height = [[element valueForAttribute:HTML_Attribute_Height] floatValue];
                                        
                                        [storages addObject:videoStorage];
                                    }
                                }];
                            }];
                        } else if (element.stringValue && element.stringValue.length > 0) {
                            NSMutableArray *styles = [NSMutableArray new];
                            __block NSString *paragraphStr = element.stringValue;
                            // <span style=""></span>
                            [element enumerateElementsWithXPath:HTML_Tag_Span usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                if (element.attributes.count > 0) {
                                    if ([element valueForAttribute:HTML_Tag_Style]) {
                                        NSDictionary *cssStyles = [[element valueForAttribute:HTML_Tag_Style] CSSStyles];
                                        if (element.stringValue && element.stringValue.length > 0 && [paragraphStr rangeOfString:element.stringValue].location != NSNotFound && cssStyles) {
                                            [styles addObject:@{@"range":[NSValue valueWithRange:[paragraphStr rangeOfString:element.stringValue]],
                                                                @"styles":cssStyles}];
                                        }
                                    }
                                }
                            }];
                            [element enumerateElementsWithXPath:HTML_Tag_Bold usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                NSDictionary *cssStyles = @{@"bold":@"bold"};
                                if (element.stringValue && element.stringValue.length > 0 && [paragraphStr rangeOfString:element.stringValue].location != NSNotFound) {
                                    [styles addObject:@{@"range":[NSValue valueWithRange:[paragraphStr rangeOfString:element.stringValue]],
                                                        @"styles":cssStyles}];
                                }
                            }];
                            PGParserTextStorage *textStorage = [PGParserTextStorage new];
                            NSAttributedString *attrS = [paragraphStr styledParagraphAttributedString:[NSArray arrayWithArray:styles]];
                            if (attrS) {
                                textStorage.text = attrS;
                                [storages addObject:textStorage];
                            }
                        } else {
                            // <p><img class="content-image" /></p>
                            [element enumerateElementsWithXPath:@"img[@class=\"content-image\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                if (idx > 0) {
                                    *stop = YES;
                                }
                                if ([element valueForAttribute:HTML_Attribute_Src]) {
                                    PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                    imageStorage.image = [element valueForAttribute:HTML_Attribute_Src];
                                    imageStorage.width = [[element valueForAttribute:HTML_Attribute_Width] floatValue];
                                    imageStorage.height = [[element valueForAttribute:HTML_Attribute_Height] floatValue];
                                    
                                    [storages addObject:imageStorage];
                                }
                            }];
                            // <p><img class="content-gif" /></p>
                            [element enumerateElementsWithXPath:@"img[@class=\"content-gif\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                if (idx > 0) {
                                    *stop = YES;
                                }
                                if ([element valueForAttribute:HTML_Attribute_Src]) {
                                    PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                    imageStorage.image = [element valueForAttribute:HTML_Attribute_Src];
                                    imageStorage.width = [[element valueForAttribute:HTML_Attribute_Width] floatValue];
                                    imageStorage.height = [[element valueForAttribute:HTML_Attribute_Height] floatValue];
                                    imageStorage.isGIF = YES;
                                    
                                    [storages addObject:imageStorage];
                                }
                            }];
                            // <p><img class="content-catalog" /></p>
                            [element enumerateElementsWithXPath:@"img[@class=\"content-catalog\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                if (idx > 0) {
                                    *stop = YES;
                                }
                                if ([element valueForAttribute:HTML_Attribute_Src]) {
                                    PGParserCatalogImageStorage *imageStorage = [PGParserCatalogImageStorage new];
                                    imageStorage.image = [element valueForAttribute:HTML_Attribute_Src];
                                    imageStorage.width = [[element valueForAttribute:HTML_Attribute_Width] floatValue];
                                    imageStorage.height = [[element valueForAttribute:HTML_Attribute_Height] floatValue];
                                    
                                    [storages addObject:imageStorage];
                                }
                            }];
                        }
                    }
                }];
            }];
            return storages;
        }
    }
    
    return nil;
}

@end
