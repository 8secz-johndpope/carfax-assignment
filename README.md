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

#CarfaxAPI
Network layer, maps JSON responses from the API to swift models that can be tested and typed into useful data structures.

#CarfaxClientModels:
Contains classes and structs to encapsulate the data specific to our client. Keeping it separate from API or persistent storage (Firestore - tbd) gives us flexibility and stability that we wouldn't have otherwise.
#CarfaxObjectStore:
A bridge between ClientModels and CarfaxAPI. Mostly transforms network responses into ClientModels and enriches any missing information we have stored locally.
#CarfaxCore:
Handles a lot of business logic. Most data sources live here and it helps bridge the CarfaxAPI and CarfaxObjectStore frameworks together.
