# iOStagram

Instagram Basic Display API tutorial - sign in, fetch user info, post to a user's wall (in-the-works?).

![iOStagram Demo](ReadmeImages/quick_demo.gif)


## Using InstagramBD

### 0. Set up an App on the Instagram Developer Portal

https://www.instagram.com/developer/


### 1. Creating a Credentials instance

Create a `Credentials` instance using your `Instagram App ID`, your `Instagram App Secret`, and a `callbackURL` (or some arbitrary https:// as was used for this demonstration).

```swift
let myCredentials = API.Credentials(key: "<your Instagram App ID here>",
                                    secret: "<your Instagram App Secret here>",
                                    callbackUrl: "<your callback url here>",
                                    scope: "user_profile,user_media",
                                    responseType: "code")
```


### 2. Launching a WebView / Login Flow

Create an `IGLoginViewController` using your credentials. 

On a successful signin, an `InstaUser` object will be created and returned in a [`Result`](https://github.com/1985wasagoodyear/ResultTypeDemonstration) instance.

```swift
let loginVC = IGLoginViewController(credentials: myCredentials,
                                    completion: { response in
                                        switch response {
                                        case .failure(let error):
                                            // some failure handling here
                                        case .success(let user):
                                            // some handling with the InstaUser instance here
                                        }
})
present(loginVC, animated: true)
```

`InstaUser` fully-encapsulates all the necessary logic, storage, OAuth, etc, for additional work with rest the endpoints available.


### 3. Using the InstaUser to fetch username

```swift
myInstaUser.getName { (name: String?) in
    // some handling for name here
}
```

This accesses the [`user`](https://developers.facebook.com/docs/instagram-basic-display-api/reference/user) endpoint to retrieve a user's screenname.


### 4. Using the InstaUser to fetch their media

```swift
myInstaUser.getMedia { (medias: [MediaInfo]) in
            self.items = medias
                .ofType(type: .image)
                .compactMap { $0.url }
        }
```

This accesses the [`user media`](https://developers.facebook.com/docs/instagram-basic-display-api/reference/user/media) endpoint to retrieve a user's media.

It returns an array of `MediaInfo`, which come with a `url` function to retrieve the url, and an extension on `Array` to allow one to filter for a certain `MediaType` [("IMAGE", "VIDEO", or "CAROUSEL_ALBUM")](https://developers.facebook.com/docs/instagram-basic-display-api/reference/media).


### 5. Accessing a Stored User

```swift
if let myInstaUser = try? InstaUser(credentials: myCredentials) {
   
}
```

`InstaUser` can be instantiated directly with just the `Credentials` instance. Doing so will retrieve a stored Oauth Token from the Keychain.

If there is no stored user, or if the app has been reinstalled, it will return `nil`.

If `Keychain` is unable to interact with the Secure Enclave, it will propogate that exception.


### 6. Handling Token Expiration

Presently, InstagramBD only uses the [1-hour long, short-lived Tokens](https://developers.facebook.com/docs/instagram-basic-display-api/overview#short-lived-access-tokens) and does not yet exchange them for long-lived Tokens.

```swift
NotificationCenter
    .default
    .addObserver(self,
                 selector: #selector(yourSignOutHandlerHere),
                 name: .refreshTokenExpired,
                 object: nil)
```

The `.refreshTokenExpired` notification will be fired each time an API response returns an expired token payload.


## Installing InstagramBD

InstagramBD is presently dependent on two other frameworks in this repository:

1. BasicKeychain
2. CommonUtility

In the future, these may be collapsed into a single framework or made more-easily distributable.


## In Progress / Future Steps:

1. Set up easy installation of InstagramBD via CocoaPods, Carthage, Swift Package Manager
2. Set up long-term token retrieval, storage, handling
3. Add other endpoints available in the Graph API.
4. Write better documentation.


## References

1. [Apple's Generic Keychain](https://developer.apple.com/library/archive/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797-Intro-DontLinkElementID_2)

2. [Instagram Graph API](https://developers.facebook.com/docs/instagram-api/)

3. [Using the new Instagram Basic Display API in Xcode using UIStoryboard:](https://medium.com/@tushargusain40/using-the-new-instagram-basic-display-api-using-swift-5-ios-10e94292e280)

Another tutorial from earlier this year, for the same objective.

4. [Enhance IT Community's Instagram](https://www.instagram.com/enhanceitcommunity/)
