# Notes

- latitude is Y
- longitude is X

## map coordinates

I'm currently treating the map coordinates as square, and disregarding their projection etc.  Here are some links to consider for the future

- http://stackoverflow.com/questions/2103924/mercator-longitude-and-latitude-calculations-to-x-and-y-on-a-cropped-map-of-the/10401734#10401734
- http://stackoverflow.com/questions/2651099/convert-long-lat-to-pixel-x-y-on-a-given-picure

## other Scratch Projects

- [GPS](http://scratch.mit.edu/projects/647301/)
- [Shortest Trip on Earth](http://scratch.mit.edu/projects/12540102/) dealing with Great Circle routes
- [Maps are cool thread](http://scratch.mit.edu/discuss/topic/269/?page=1#post-1718) on the forums

## nextbus library

- Modifying the attributes returned with the route, but the singular Route.find gives extra detail than the collection of route.all.  For now you have to call it again, but that is fine for my usage atm...
- way less complete alternative library I found was [ttc-gps-gem](https://github.com/shyndman/ttc-gps-gem)

### data questions

- when no bus is running... the prediction seems to show a epochTime of start of service -- 5:40am, and then a relative minutes from there?  Why is the first bus in the morning flagged as a 98A branch?  layover

### Sample URLS

- http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=ttc&r=98
- http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&routeTag=98&stopId=7116
- http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=ttc&r=98&t=1393219514971
- http://webservices.nextbus.com/service/publicXMLFeed?command=schedule&a=ttc&r=98