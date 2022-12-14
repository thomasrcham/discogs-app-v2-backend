# Discogs App v2 Backend
to be paired with [Discogs App v2 Frontend](https://github.com/thomasrcham/discogs-app-v2-frontend)

originally cloned from the [Flatiron School Phase 3 Project Starter Code](https://github.com/learn-co-curriculum/phase-3-sinatra-react-project)

A backend API server using Ruby, ActiveRecord, and Sinatra (along with some clutch gems) to pull information about my Discogs collection and present it in an interesting and interactable format. A continuation of the ideas and motivations behind the vanilla JS-only [Discogs Utility](https://github.com/thomasrcham/discogs-utility).

## GOALS OF PROJECT
- I want to be able to view the library in more manageable and enjoyable ways than the default Discogs presentation, which is both aesthetically sparse and informationally overwhelming.
- I want to be able to navigate the collection using logical connections, for example: the ability to move to an artist from an album listing and view other albums in the collection by that artist in a simple way. Discogs is a wonderful trove of information but often that information is presented on a single visual level, making it very difficult to parse the information that you want in an easy way. 
- I want to be able to track my listening of each record, so that I can interact with that information in meaningful ways. More on that later.

## SETUP

The database is initially seeded with an API call to the Discogs API. The return data is then massaged into three tables (Artists, Albums, and Genres) for use in the [frontend app](https://github.com/thomasrcham/discogs-app-v2-frontend). Setting up that seeding event was actually one of the most fun parts of the project. I set up an example file (json_return.example) for easier referencing, then it took about 3 hours to set up all of the instructions to take each individual release, pull the required data, and place that information in the tables. The database is also seeded with 3000 fake "Listen Events", randomly tied to individual album instances, which were created for testing. 

## FRONTEND CONNECTION POINTS

At the time of writing, the backend covers 12 unique connection points from the frontend server. These can be as simple as "Serve the entire requested album instance to the frontend" or "Delete the named instance", but are often involved in updating and managing the data themselves. 

- For instance, in some cases the Discogs API will serve, in its year field, the year of the physical release of the owned media instead of the (personally) preferred original release year of the album. In order to obtain the "correct" year, the specific artist API URL needs to be pulled from the Album data and a separate fetch sent to that point on the Discogs API. Since the occurence of "incorrect" year happens in approximately 20% of albums, once the Collection grows large enough it would be an unwelcome burden on the Discogs API to update all of those data points upon table seeding. To solve this problem, when the specific Album instance is requested by the frontend, the backend will check and see if the "needs_year_update" flag has been set by parameters in the initial seeding process. If that flag is true, the database will then send the fetch, update the year in the Album instance to the "correct" year, and set the flag to false so that in future calls no update will be necessary.
- The backend handles artist descriptions similarly. Originally, the bio on the Artist page was populated directly from the Artist information in the original API call. However, it was discovered that the Discogs API was serving it's own backend data which included unparseable internal links, external URLs, and many other pieces of information that are not generally seen in a text description. So that these Artist Bios could exist in an aesthetically appropriate form, I set up a Nokogiri scrape which occurs in the event that the Artist page is requested for display. This also updates the Details field in the Artist instance in the table, so that the information is maintained locally and does not need to be scraped again in future instances.

## LISTEN TRACKING

This is the core of the project and a large part of the motivation behind its creation. While Digital Streaming Providers offer interesting data analysis events like Spotify's "Wrapped or Last.fm's user accessible data slicing, to my knowledge nothing like this exists for physical media and the users who primarily consume music in this way. That's annoying to me because I'm a nerd and I totally want to know what my most listened to album of the year is, or which record I loved and forgot, or any number of other parameters. The core goal of this app (and work that will come in the future) is to create that sort of functionality. To that end, the app is built to facilitate the tracking of individual "Listen Events". When I put on a record from my collection, I can click on the "Add New Listen" field, adding a Listening Event to the backend database and setting that data up for future use. 
