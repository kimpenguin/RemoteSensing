##meters-degree.py
##written by Kimberly Peng
##date: 2015
##this script converts meters to decimal degrees

met=input("What is the meter resolution? Enter>>")
meters=float(met)

sec=meters*(1/30.87)
deg=sec/3600
print("Approximate decimal degrees is", deg)
