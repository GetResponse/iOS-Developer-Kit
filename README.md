<img src="docs/gr_logo.png" width="50%" height="50%"/>
# GetResponseAPI iOS SDK
![CocoaPods](https://img.shields.io/cocoapods/v/GetResponseAPI.svg) ![license](https://img.shields.io/cocoapods/l/GetResponseAPI.svg) ![Platform](https://img.shields.io/cocoapods/p/GetResponseAPI.svg)

GetResponseAPI is an API wrapper for the [GetResponse API 3.0](https://apidocs.getresponse.com/en/v3) that allows you to use basic API methods such as listning, adding, and removing contacts as well as fetching the list of your campaigns.

## Requirements

To use the library you need to have an active [GetResponse account](http://getresponse.com) with assosicated **Developer API Key**.

This library is using [CocoaPods](https://cocoapods.org/) to maintain library dependencies.  
We use [AFNetworking](https://github.com/AFNetworking/AFNetworking) for the communication layer and [JSONModel](https://github.com/icanzilb/JSONModel) for modeling the response objects.

## Installation
1. Add `pod 'GetResponseAPI'` to your Podfile
2. Run `pod install`
3. Add `#import "GRApi.h"` from your bridging header, prefix header, or wherever you want to use the library

## Setup

First, set an API key:

```objective-c
[[GRApi sharedInstance] setupWithApiKey:DEVELOPER_API_KEY];
```
From now on, you can use the shared instance of the `GRApi` object in your project to make API calls.

The API comes with following set of helper methods:

```objective-c
[[GRApi sharedInstance] setVerbose:(BOOL)]; //Enable logging
[[GRApi sharedInstance] setResultsPerPage:(NSNumber]; //Self-explanatory
```

The `setVerbose` method will enable the underlying `AFNetworkActivityLogger` library in debug mode.

## Example usage

### Getting contact
```objective-c
[[GRApi sharedInstance] getContactByEmail:@"email@example.com" inCampaign:@"existing_campaign_name" completion:^(GRContact *contact, NSError *error) {
        if (!error) {
            NSLog(@"Got contact with name: %@ for email %@", contact.name, contact.email);
            //Do anything you want with the GRContact model.
        }
    }];
```
### Getting list of contacts
Some of the methods come with the paging mechanism that is returning a `totalPages` parameter after the first call. You can set the number of results per page as described in sections above.

```objective-c
[[GRApi sharedInstance] getContactsWithPageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        if (!error) {
            NSLog(@"Got %li contacts. Total pages: %i", contactsArray.count, totalPages.intValue);
            //Do anything you want with contactsArray that consists of GRContact models
        }
    }];
```

## Samples
### API Methods Samples
You can inspect a set of examples that are included in the [Samples](Samples/) directory.

### Example Application
We've attached a sample application called `ApiWrapper` that utilizes almost every method created in the API wrapper so far and we strongly reccomends you to take a look.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your changes & test them.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Testing
This library is using a series of unit tests to ensure it is working properly.  
For more information about testing, see the [Testing](https://github.com/GetResponse/iOS-Developer-Kit/wiki/Testing) page in our wiki.

## License
See [LICENSE.TXT](LICENSE.TXT)
