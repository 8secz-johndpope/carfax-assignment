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
