# Notes
- Coded on xCode 10.1 - Swift 4.2 (only computer I had available)
- You will need to run `pod install` and open the workspace
- For brevity, I did not create additional frameworks. I simply put all the folders that would be frameworks, into the main target.
- List price vs one price vs current price: I wasn't sure which price to use, so I used `listPrice`
- Implemented own api instead of simple alamofire web provider. I like the flexability and I had some code for it!
- I decided to use frames for this instead of XIBS.  Carfax and my current company's app both are portrait only,  and I personally feel frames are better.
- There are some big commits early on - just getting things setup
- It looks like the API was set up for paging, but I couldn't figure out the paging keys! So I just used the 25 first results from the endpoint.
- More optimization could be done around the image sizes based on the width of the phone, but for now I'm eating up your data with the largest image
- Thanks for the time to review this!

Time Profile looks good after scrolling:
<img width="537" alt="Screen Shot 2019-07-25 at 2 10 23 AM" src="https://user-images.githubusercontent.com/3453556/61850420-4a79f980-ae82-11e9-90ae-29e234106b49.png">

As well as leaks and allocations: <img width="661" alt="Screen Shot 2019-07-25 at 2 19 25 AM" src="https://user-images.githubusercontent.com/3453556/61850693-e4da3d00-ae82-11e9-8aa7-1a78849a7d30.png">

# carfax-assignment

Display a list of vehicles with the following information:
- photo
- year
- make
- model
- trim
- price
- mileage
- location
- "call dealer" button

Tapping "call dealer" should initiate a phone call towards the dealer

API: https://carfax-for-consumers.firebaseio.com/assignment.json

## CarfaxAPI
Network layer, maps JSON responses from the API to swift models that can be tested and typed into useful data structures.
## ClientModels:
Contains classes and structs to encapsulate the data specific to our client. Keeping it separate from API or persistent storage (Firestore - tbd) gives us flexibility and stability that we wouldn't have otherwise.
## ObjectStore:
A bridge between ClientModels and CarfaxAPI. Mostly transforms network responses into ClientModels and enriches any missing information we have stored locally.
## AppEnvironment:
AppEnvironment.swift handles some credential storage and stores which environment to use - currently only one
## CarfaxCore:
Handles a lot of business logic. Most data sources live here and it helps bridge the CarfaxAPI and CarfaxObjectStore frameworks together.
## UIColor:
Add common UI colors to UIColor extension. Avoid putting RGB and HEX colors in code for sake of sanity
## CarfaxUI:
Essentially a dumping ground for reusable UI code. I believe it's important to keep this independent from our business logic and other core frameworks like ClientModels and CarfaxCore. That allows this framework to remain true to UI only features.
## Images:
* Don't add any images into xibs or storyboards
* Add any images to the image asset class in Carfax UI (separate words with -, not underscores). After you add the image-set, run make generate-images in terminal. This will add the image to the image+extension. You can now use UIImage.image_name in code
