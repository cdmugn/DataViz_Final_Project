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

3/30: after-class

Decided to keep both ABV and IBU lollipop charts for the reasoning that it is one less thing for the user to put in and I think the page can handle it. It is good to compare them and just unnecessary to have another user input here. I completed the tasks of adding a description to the first tab, putting titles on the plots, and changing the layout of the style tab to prepare it for the new map output. Put in the map, but have not made it change the markers based on stylechoice yet.

4/4: beginning of class
Added a leaflet map that marks on the large scale a dot cluster where each style appears when users picks styles from the style tab. Added a tab where user can choose a brewery with choices of two breweries, two tables of output, and two barplots. Also have a mad that changes markers based on two breweries chosen. Cleaned up a lot of the leaflet proxy and observe commands.

4/4: after-class
Fixed the zoom so it is adjusting for the two component data set, added text outputs above the columns with plots and table what brewery it is showing information for and removed bar charts because they were not useful. Started adding another data set that rates breweries so I can add that in.

4/6: beginning of class
Found and cleaned another dataset with more information per brewery, turned into a csv and read that in so that the app only has the read_csv command in it. I then realized there are no breweries in common between the two data sets so it won't work and I should look for another.

4/6: after-class
More effort to troubleshoot the maps clustering and acting strange when only one observation is shown for a certain brewery.

4/11: before class 
Fixed third map to show markers for a single beer, and changed it from lines to scrollover points.

4/13: before class
Found another data set with ratings by style and added that to the beer_city data set and added a table to the style tab that has the ratings for the styles user has selected

4/18: beginning of class
Fixed style table so it is grouped and made labels say what they are showing, and be bold, and be multiple lines, not just slashes between.

4/18: after-class
Fixed third map so it does not move and resize every time you change it. Worked a lot on color coding markers for style rating, I think I am close but it isn't working yet. 

4/20: beginning of class
Colored circles by style rating in the style tab. I had to define a way to breakup the data and make a legend.

4/20: after-class
Added a data set to the main one with ratings by beer, not just style. Struggling with whether or not it is worth including the ratings with that many NA values. I decided it isn't worth including the ratings per beer if there are so many NA values. Also changed the marker color in the brewery tab to be by specific style.

4/ 25: beginning of class
Changed the cut offs in my color scale so they change more, right now most beers are in the same category. So an evenly split range might not be in my best interest. Fixed fill so you can see markers better and de-bugged the brewery tab a bit.
 