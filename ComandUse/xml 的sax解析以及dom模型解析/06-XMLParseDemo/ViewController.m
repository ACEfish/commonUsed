//
//  ViewController.m
//  06-XMLParseDemo
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "QYBook.h"
#import "GDataXMLNode.h"

@interface ViewController () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, strong) QYBook *currentBook;
@property (nonatomic, strong) NSString *content;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)xmlParse:(id)sender {
    NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    
    // 1. create
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    // 2. set delegate
    parser.delegate = self;
    
    // 3. parse
    [parser parse];
}

#pragma mark - NSXMLParser delegate
/**
 * 当遇到文件(数据)开始时调用
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"解析开始...");
    _books = [NSMutableArray array];
}

/**
 * 遇到开始标签时
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    if ([elementName isEqualToString:kBook]) {
        _currentBook = [[QYBook alloc] init];
        // 取出book标签中的属性
        _currentBook.category = attributeDict[kCategory];
    } else if ([elementName isEqualToString:kTitle]) {
        // 取出title标签中的属性
        _currentBook.lang = attributeDict[kLanguage];
    } else {
        // do nothing
    }
}

/**
 * 遇到文本时
 */
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _content = string;
}

/**
 * 遇到标签结束时
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kBookStore]) {
        NSLog(@"解析即将结束!");
    } else if ([elementName isEqualToString:kBook]) {
        [_books addObject:_currentBook];
    } else {
        [_currentBook setValue:_content forKey:elementName];
    }
}

/**
 * 解析完成时
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"解析完成!");
    NSLog(@"%@", _books);
}

/**
 * 解析遇到错误时
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@",parseError);
}


- (IBAction)domParse:(id)sender {
    NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfURL:xmlURL];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
//    NSLog(@"%@", rootElement);
    
    NSArray *booksElement = [rootElement elementsForName:kBook];
    _books = [NSMutableArray array];
    for (GDataXMLElement *bookElement in booksElement) {
        QYBook *book = [[QYBook alloc] init];
        book.category = [[bookElement attributeForName:kCategory] stringValue];
        
        // title element
        GDataXMLElement *titleElement = [bookElement elementsForName:kTitle][0];
        book.title = [titleElement stringValue];
        book.lang = [[titleElement attributeForName:kLanguage] stringValue];
        
        // author
        GDataXMLElement *authorElement = [bookElement elementsForName:kAuthor][0];
        book.author = [authorElement stringValue];
        
        // year
        GDataXMLElement *yearElement = [bookElement elementsForName:kYear][0];
        book.year = [yearElement stringValue];
        
        // price
        GDataXMLElement *priceElement = [bookElement elementsForName:kPrice][0];
        book.price = [priceElement stringValue];
        
        [_books addObject:book];
    }
    
    NSLog(@"%@", _books);
}

@end
