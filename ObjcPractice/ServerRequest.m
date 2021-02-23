//
//  ServerRequest.m
//  ObjcPractice
//
//  Created by Luis Santiago on 21/02/21.
//

#import "ServerRequest.h"
#import "ObjcPractice-Swift.h"

@implementation ServerRequest
static ServerRequest *singletonObject = nil;

+ (id) sharedServerRequest
{
    if (! singletonObject) {

        singletonObject = [[ServerRequest alloc] init];
    }
    return singletonObject;
}

- (id)init
{
    if (! singletonObject) {
        singletonObject = [super init];
    }
    return singletonObject;
}



-(void) registerReceipt : (Receipt*)receipt :(void (^)(NSError * _Nullable  error))onServerResponse{
    
    NSString *url = [NSString stringWithFormat:@"https://devapi.axosnet.com/am/v2/api_receipts_beta/api/receipt/insert?provider=%@&amount=%@&comment=%@&emission_date=%@&currency_code=%@", receipt.provider, receipt.amount, receipt.comment, receipt.emission_date, receipt.currency_code];

    
    NSLog(@"url %@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];

    //Apply the data to the body
    [urlRequest setHTTPBody:nil];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        onServerResponse()
        
//        if(httpResponse.statusCode == 200){
//            NSError *parseError = nil;
//
//        }
//        else
//        {
//            NSLog(@"Error");
//        }
    }];
    [dataTask resume];
}

-(void)fetchReceipts :(void (^)(NSMutableArray *list , NSError * _Nullable  error))onDataRetrieved{
    
    NSLog(@"Fetching receipts");
    NSString *urlString = @"https://devapi.axosnet.com/am/v2/api_receipts_beta/api/receipt/getall";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        NSString *strJson = [NSJSONSerialization
                            JSONObjectWithData:data
                            options:NSJSONReadingAllowFragments error:&error];
        
        
        NSData *dataJson = [strJson dataUsingEncoding: NSJSONReadingFragmentsAllowed];

        NSMutableArray<Receipt *> *receipts = NSMutableArray.new;
        NSError *err;
        
        id receiptsJSON = [NSJSONSerialization JSONObjectWithData:dataJson
                                                    options:NSJSONReadingFragmentsAllowed
                                                      error:&err];
        
        

        if(err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            onDataRetrieved(receipts, err);
            return;
        }
    
        
        
        for (NSDictionary *receiptDict in receiptsJSON){
            Receipt *receipt = Receipt.new;
            receipt = [receipt parseWithData:receiptDict];
            [receipts addObject: receipt];
        }
        
    
        onDataRetrieved(receipts, nil);
        
                
        
    }] resume];
}



@end
