##dms-degrees.py
##Written by Kimberly Peng
##Date: 2015
##this script takes degrees:minutes:arcseconds and converts to decimal degrees

##prompts for latitude
deglat = input("What are the latitudinal degrees? Enter>> ")
degreelat=float(deglat)

minlat=input("What are the latitudinal minutes? Enter>> ")
minutelat=float(minlat)

seclat=input("What are the latitudinal seconds? Enter>> ")
secondlat=float(seclat)

##prompts for longitude
deglon = input("What are the longitudinal degrees? Enter>> ")
degreelon=float(deglon)

minlon=input("What are the longitudinal minutes? Enter>> ")
minutelon=float(minlon)

seclon=input("What are the longitudinal seconds? Enter>> ")
secondlon=float(seclon)

##convert latitude values to decimal degrees
ddlat=(secondlat/3600)+(minutelat/60)+degreelat
print("latitude decimal degrees:",ddlat)

####convert longitude values to decimal degrees
ddlon=(secondlon/3600)+(minutelon/60)+degreelon
print("longitude decimal degrees:",ddlon)
