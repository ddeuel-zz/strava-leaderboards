## The Data
These visualizations are based on data from Strava, a social network for sharing workouts.

This data was collected between October 18th and November 30th and includes leaderboards for 8 popular climbs from around the world. Each leaderboard has thousands of entries from unique best times of those who have uploaded their rides to Strava.

The data was collected by me using the Strava third party API ([documentation](https://developers.strava.com/docs/reference/)).

The leaderboard entry data is merged with metadata about each climb into cleaned JSON files. The metadata includes a polyline encoding of the climb which is passed to the Google Maps API using the *googleways* R package ([documentation](https://www.rdocumentation.org/packages/googleway/versions/2.7.1)).

The API access calls and the regular expression for cleaning the data are included in *commands.txt*

## About Me: Drake Deuel
I am a Harvard undergraduate studying Computer Science and passionate about cycling.

Contact me at drakedeuel@college.harvard.edu or connect with me on LinkedIn [here](https://www.linkedin.com/in/drake-d-a78569111/)

## Source Code
The source code for this project can be found at my GitHub [here](https://github.com/ddeuel/strava-leaderboards)
