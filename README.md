# Github Actions

** Triggers**

# App Overview
![Simulator Screen Recording - iPhone 17 Pro - 2025-10-12 at 16 32 19](https://github.com/user-attachments/assets/15adf07d-9045-42d3-89d9-1e7fb5a52962)


### Home Tab
- Shows the latest space news (title, summary, image, date, whether user saved it)
- Pull to refresh to refresh the list
- Scroll down to paginate as long as we have next page to show
- Heart icon indicates whether user saved the newsItems. It will show a filled heart for any user has saved.
- Tapping on heart instantly reflects user choice and updated the saved ietms.
  
### Saved Tab
- Saved tab shows all the news items user saved.
- Tapping on heart here will instantly remove the item from the list and appropriately reflect on the home tab.
- Data is persisted to disk when app goes in the background

## TODO
- Author/publisher info
- Search results tab, to allow users to search news with query string
- Look into what sorting the API provides
- Look into diffable data source to improve list updates

# Architecture
- Uses reactive redux architecture throughout the app so UI can react to any state changes
- Follows SOLID principles as much as possible, can refactor some more classes to make them extensible
- Uses a mix for SwiftUI and UIKit 
- SwiftUI is used for the overall UI + the collection view cells
- UIKit is used to leverage UICollectionView to allow reusing cells + granular control over layout in future

  
## AppStore
- Connects all the pieces together - state, middleware, dispatcher
- responsible for creating all the parts used within redux architecture
- Injected within the necessary viewModels

## AppState
- Responsible to notify viewModels when data is available
- passes immutable copies to viewModels
- Handles any Set actions


## AppMiddleware
- Responsible for making n/w calls to get news from BE, saving/retreiving news from cache and persistent store
- Handle any actions that require accessing cache/store or making n/w calls
  
## NavigationMiddleware
- Responsible for handling any navigation actions like opening links in safari view controller
- Can be extended in future to handle any other navigtaion actions

## Dispatcher
- Responsible for routing actions to appropriate middleware / state
  
## Actions
- GetNewsAction for fetching news from BE or cache as needed
- SetNewsAction for notifcying the users
- SavedNewsAction for updating saved state of news items
  
## Network / Parser Layers
- Generic network layer uses combine to fetch, handle errors and publish data when available or error
- Generic parser uses combine to parse data and publish data
- API used: https://api.spaceflightnewsapi.net/v4/articles/?limit=5
- 
  
## Caching / Persistent Store
- Cache and store both are actors to make sure data access is thread safe

## SpaceNewsCollectionViewModelProtocol
- Defines the necessary methods the collectionviewcontroller relies on to properly render the data and mark news items as saved
- The concrete class conforming to this is responsible for dispatching actions to fetch news, fetch more news (paginate), etc

## SpaceNewsCollectionViewController
- UIKit collectionview for efficient scrolling

## SpaceNewsCell
- SwiftUI view for cells

# Dependencies
- SDWebImage for rendering images on news cells


