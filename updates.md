3/21: 

Read in the .csv data set on beers and breweries, that I found on GitHub. Decided I needed to figure out how to get Latitude and Longitude for the cities so that I can map the breweries in the shiny app. Recieved the suggestion to join directly from the beers dataset we used for class.

3/23: beginning of class

Read in the data and found a city data csv. Put these two into a set data set and a leaflet. Printed leaflet and a changing table by city into the shiny app. No problems so far. 

3/23: after-class

Added a new tab and a title to my shiny app and made a stagnant lollipop plot that shows all styles and each beers alcohol content, as well as the mean ABV for each style. Have to figure out how to get a title on my table and get the leaflet to zoom as you choose.

3/28: beginning of class

Added another lollipop plot for IBU by style and put my ABV lollipop plot into shiny. Worked on the issues of a reactive title for my table and zooming in on the plot when the city is selected, but did not find solutions. For today, I want to make conditional axis labels so the user can pick the response variable for the lollipop plots.

3/28: after-class

Added the title above the table that changes with the city choice. Realized it may serve me to leave both lollipop plots or I could make them one where user changes the x, I have not decided. The next step is for me to solve the zooming with input problem. I think that needs to be solved.

3/30: beginning of class

Made my leaflet zoom to the input the user picks! I had to spend hours troubleshooting and trying things but I got it.