##degree-meters.py
##Written by Kimberly Peng
##Date: 2015
##this script converts decimal degree resolution to meters


##prompt user for degree resolution
deg = input("What is the decimal degree resolution? Enter>> ")
##print("Value entered " + deg)
##print(type(deg))

degree=float(deg)
##print(type(degree))
##print(degree)

##converts degree to seconds
seconds = degree * 3600
##print(seconds)
##print("Conversion to seconds is ",seconds)

##converts seconds to meters
meters = seconds * 30.87
print("Approximate meter resolution is ", meters)
