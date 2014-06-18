yelpper
========
Yelp demo app

This is an iOS 7 Yelp demo app displaying a list of nearby businesses using [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api). It is created as part of [CodePath](http://codepath.com/) course work. (June 17, 2014)

Time spent: approximately 20 hours

Features
--------

### Search page
#### Required
- [x] Table rows should be dynamic height according to the content height
- [x] Custom cells should have the proper Auto Layout constraints
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

#### Optional
- [x] Infinite scroll for restaurant results
- [x] Implement map view of restaurant results


### Filter page
#### Required
- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states.
- [x] Radius filter should expand as in the real Yelp app
- [x] Categories should show a subset of the full list with a "See All" row to expand.

#### Optional
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
- [ ] Implement a custom switch
- [ ] Implement the restaurant detail page.


Walkthrough
------------
![Video Walkthrough](flicks-walkthrough.gif)


Known issues
------------
I'm sure there are many issues, but here are some notable ones:
- Infinite scrolling is not as smooth
- After you scroll down quite a bit, and you go to filter and search again, it doesn't scroll all the way to the top.
- In the filter screen, selecting a category only expands the section even though it looks like you can select it.
- In the filter screen, it's hard to deselect all categories.
- If you go from portrait to landscape, the business name labels don't resize properly
- The search bar doesn't stretch in landscape mode.


Credit
---------
* [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api)
