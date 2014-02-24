# Notes

- latitude is Y
- longitude is X

## nextbus library

- Modifying the attributes returned with the route, but the singular Route.find gives extra detail than the collection of route.all.  For now you have to call it again, but that is fine for my usage atm...

### data questions

- when no bus is running... the prediction seems to show a epochTime of start of service -- 5:40am, and then a relative minutes from there?  Why is the first bus in the morning flagged as a 98A branch?  layover