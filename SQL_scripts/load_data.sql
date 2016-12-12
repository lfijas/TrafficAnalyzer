use yanosik;
load data local infile '/media/Dane/Dokumenty/Studia/Magisterskie/Praca_magisterska/Yanosik/data.txt' 
into table Traffic_with_speed 
fields terminated by ';' 
lines terminated by '\n' 
(Id, Date, Latitude, Longitude, Speed, Azimuth)
set Tag = 'WAW';
