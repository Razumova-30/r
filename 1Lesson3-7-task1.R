
setwd("D:/Modelirovanie/York")
$ cd D:/Modelirovanie/York
$ git init

library(tidyverse)
library(lubridate)
library(rnoaa)

station_data = ghcnd_stations()
write.csv(station_data,"station_data.csv")
#Может занять несколько минут лучше выполнить один раз в
#месте с хорошим интернетом и сохранить результат
station_data = read.csv("station_data.csv")
#После получения всписка всех станций, получите список станций ближайших к столице вашего региона,создав таблицу с именем региона и координатами его столицы
krasnodar = data.frame(id = "krasnodar",
                  latitude = 45.039268,
                  longitude = 38.987221)
tula_around = meteo_nearby_stations(lat_lon_df = tula,
                                    station_data = station_data,
                                    limit = 40,
                                    var = c("PRCP", "TAVG"),
                                    year_min = 2008, year_max = 2018)
class(tula_around)
tula_around = tula_around[[1]]
tula_around = tula_around %>% filter(distance <= 250)
tula_id = tula_around[1,1]
#tula_around это список единственным элементом которого является таблица, содержащая идентификаторы метеостанций отсортированных по их
# удалленности от Тулы, очевидно что первым элементом таблицы будет идентификатор метеостанции Тулы, его то мы и попытаемся получить
tula_id = tula_around[["TULA"]][["id"]][1]
#Для получения всех данных с метеостанции, зная ее идентификатор, используйте след. команду
all_tula_data = meteo_tidy_ghcnd(stationid = tula_id)


all_tula_data$prcp# Precipitation - осадки
all_tula_data$snwd# Snow - высота зимних осадков
all_tula_data$tavg# Temoerature air averaged - средняя темп воздуха за день
all_tula_data$tmax# Temoerature air max - максимальная темп воздуха за день
all_tula_data$tmin# Temoerature air min - минимальная темп воздуха за день

all_tula_data = all_tula_data %>% mutate(
  year = year(date), month = month(date), doy =yday(date)
)

all_tula_data = all_tula_data %>% filter(year >1990)

all_tula_data = all_tula_data %>% mutate(
  prcp = prcp /10, snwd = snwd /10, tavg = tavg /10, tmax =tmax/10,
  tmin = tmin/10)


#active_temp - summarise, не активные температуры стали равны 0



