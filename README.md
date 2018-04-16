**Technical Challenge**

Hi, fellow Reviewer,

This document will help you build the project and walk you through into some of the specifics of the project. I hope you’ll enjoy reviewing my code.

Cheers !

**Requirements**

- Xcode 9.2+ 
- iOS 10.0+ 
- Swift 4.0+

**Building the project**

This project use Cocoapods. Tap the following commands in the root directory 



It will generate a file Technical Challenge.xcworkspace. Open the project with it (not with Technical Challenge.xcodeproj)

**Project Architecture**

The architecture evolves around “Stories” where, in the future, whenever the project grows, we can separate different screen logic that represent a new story (ex: Login screens, User Settings screens).

A Story is composed of a Storyboard, ViewControllers, ViewModels and Views directories. This way, it is easy to navigate between classes that are linked inside a same story.

When possible, MVVM is used.

**Cocoapods**

Two frameworks are used with Cocoapods:

WebLinking

This little pod provides usefull helpers methods to extract header links in a httpResponse 

Kingfisher

Really good pod to handle loading and caching of images from urls.

**Testing**
To test different parts of the project, I use the Xcode test framework.


