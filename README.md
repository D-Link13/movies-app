# iOS Interview Coding Challenge

You are tasked with building an iOS app that will allow a user to discover the latest movies and tv shows. For now, we will be focusing on the movie aspect of the app and we will pull movie lists from The Movie Database (TMDB).

If you are feeling stuck, feel free to ask questions and you can use the internet to help you.

## Specs

* Language: Swift
* UI Framework: SwiftUI
* Minimum supported iOS version: 15.0
* Orientation support: Portrait And Landscape
* Device support: iPhone and iPad
* Localizations: English
* Dependencies required: None
    * Feel free to build using native APIs
* The Movie DB API: [Link](https://developers.themoviedb.org/3/movies)

## Requirements

* The app's main navigation will be a tab view. 
* Each tab will present a list movies in one of the following categories:
  * [Now Playing](https://developers.themoviedb.org/3/movies/get-now-playing)
  * [Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
  * [Upcoming](https://developers.themoviedb.org/3/movies/get-upcoming)
* The movie list should show the movie's title, poster and release date.
* Clicking on a movie, will bring you to its detail page. Here you can display the movie's overview.
* Add at least one unit test

## Screenshot

<img src="./Screenshots/1 List view.png" width=400>
<img src="./Screenshots/2 Details.png" width=400>


## BDD Stories

### Narrative #1
    
    As an online customer
    I want the app to automaticaly load a movie list, based on the predefined category
    So I can enjoy the list of movies

- Scenarios (Acceptance criteria)
    
    Given the customer has no connectivity
    And the predefined movie category
    When the customer requests to see the movie list
    Then the app should display the movie list from remote, based on the category
    
### Narrative #2
    
    As an offline customer
    I want my app to show an error
    So I can see that the problem is a connectivity and start solving the issue

- Scenarios (Acceptance criteria)
    
    Given the customer has no connectivity
    When the customer requests to see the movie list
    Then the app should display an error message
    

## Use Cases

### Load Movies list from Remote

- Data(Input)
    * URL
    * String - [Movie Category]
    
- Primary course (Happy path):
    
    1. Execute "Load Movies List" command with above data.
    2. System downloads data from the URL.
    3. System validates downloaded data.
    4. System creates movies list from valid data.
    5. System delivers movies list.
    
- Invalid course (Sad path):
    
    1. System delivers invalid data error.
    
- No connectivity (Sad path):
    
    1. System delivers connectivity error.
