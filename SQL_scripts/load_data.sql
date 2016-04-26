use yanosik;
load data local infile '/media/Dane/Dokumenty/Studia/Magisterskie/Praca_magisterska/Yanosik/tracks.csv' 
into table Traffic_with_speed 
fields terminated by ';' 
lines terminated by '\n' 
(Id, Date, Longitude, Latitude, Speed, Azimuth);
