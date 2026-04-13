#Kwestie techniczne
rm(list=ls())

#Wczytanie danych o inflacji
index<- read.csv("US_inflation_rates.csv", header=TRUE)

colnames(index)<-c("DATE","index")
colnames(index)
View(index)
dim(index)

index.ts = ts(data=index$index, frequency = 12,             
              start=c(2011,1), end=c(2023,6)) 


#Ladowanie bibliotek
library(urca)
library(fpp2)
library(forecast)
library(stats)
library(lmtest)
library(gridExtra)


#Celem jest prognozowanie wartosci indeksu

#funkcja ts - przeksztalca zbior danych w obiekt typu 'time series', czyli w szereg czasowy
  
# sprawdzamy klase
class(index.ts) 

# Podzial danych na zbior uczacy i testowy. 
# Podzial na 3 zbiory (indeks.ts), index.train (zbior uczacy), index.test (zbior testowy)

# zbior uczacy
index.train<-window(index.ts, end=c(2019,12))

# zbior testowy
index.test<-window(index.ts, start=c(2020,1)) #ostatnie trzy miesiace - dla szeregu niesezonowego to jest maksymalny horyzont estymacji



##########################
# ANALIZA SZEREGU
#########################

#Krok I - wizualizacja danych na wykresie

options(scipen = 999)

x11()
plot(index.ts,
     type="l", # linia
     #pch=16,   # rodzaj symbolu graficznego
     lty=1,    # linia kropkowana
     lwd=2     # podwojna grubosc
)

#Krok II - Autokorelacja

x11()
ggAcf(index.train, lag=40)+ ggtitle("Korelogram - index") + xlab("Opoznienie") + theme_light() + 
  theme(plot.title = element_text(hjust=0.5))




# Sprawdzenie autokorelacji za pomoca testu statystycznego
# H0: Brak autokorelacji

Box.test(index.train, lag=40, type="Ljung-Box")  # Odrzucamy hipoteze zerowa o braku autokorelacji, zatem jest silna korelacja
# Jest autokorelacja, wiec bedzie trzeba dokonac roznicowania

#Krok III - Stacjonarnosc

# Test KPSS
# test KPSS W tescie tym mamy odwrocone hipotezy: jesli statystyka
# testowa jest wieksza od wartosci krytycznej to odrzucamy H0
# o stacjonarnosci szeregu.


#dla poziomow zmiennej
kpss.test <- ur.kpss(index.train, type = c("mu"))  # stala w rownaniu testowym
summary(kpss.test)
# statystyka KPSS jest wieksza od 5% wartosci krytycznej
# (0.463) zatem odrzucamy H0 o stacjonarnosi zmiennej


# dla zmiennej jednokrotnie roznicowanej
# Roznicowanie jednokrotne mozna rowniez obliczyc za pomoca funkcji diff
index.diff <- diff(index.train,1)

kpss.test.d <- ur.kpss(diff.xts(index.train), type = c("mu"))
summary(kpss.test.d)
# statystyka KPSS jest mniejsza od 5% wartosci krytycznej
# (0.463) zatem nie mamy podstaw do odrzucenia H0 o stacjonarnosi zmiennej


# Wykres roznic
x11()
tsdisplay(index.diff)



##########################
# ARIMA
#########################

#Metoda Boxa-Jenkinsa


#### Mozemy teraz przystapic do identyfikacji rzedow p i q
# Spojrzmy na korelogramy ACF i PACF dla pierwszych roznic.
#ACF i PACF
x11()
ggtsdisplay(index.diff)

x11()
par(mfrow = c(2,1))
Acf(index.diff,  lag.max = 30)
Pacf(index.diff, lag.max = 30)

# ACF i PACF sugeruja proces ARIMA (1,1,2).

#Przykladowe modele

arima113<- Arima(index.train,
                  order = c(1, 1, 3)  #rzedy (p,d,q)
)
arima012=Arima(index.train, order=c(0,1,2))
arima111=Arima(index.train, order=c(1,1,1))
arima011=Arima(index.train, order=c(0,1,1))
arima110=Arima(index.train, order=c(1,1,0))
arima112=Arima(index.train, order=c(1,1,2))
arima212=Arima(index.train, order=c(2,1,2))


# parametry
print(arima212);print(arima012);print(arima110); print(arima112)

# Czy w modelach nie ma problemu autokorelacji w resztach?
# Ktory model jest najlepszy wg kryterioW informacyjnych?
# Porwnajmy wyniki z innymi modelami na podstawie:
#	- kryterium AIC i BIC
#	- istotnosci dodakowych parametrow


#Porownanie wartosci AIC dla modeli:
AIC(arima113,arima012,arima111,arima011,arima110,arima112, arima212)
#Porownanie wartosci BIC dla modeli:
BIC(arima113,arima012,arima111,arima011,arima110,arima112, arima212)


# Wybieramy model z najmniejsza wartoscia kryteriow informacyjnych

# Czy reszty sa bialym szumem?

x11()
par(mfrow = c(2,1))
Acf(resid(arima112), lag.max = 36,
    lwd = 7, col = "dark green")
Pacf(resid(arima112), lag.max = 36,
     lwd = 7, col = "dark green")


#Test Ljung-Boxa
Box.test(resid(arima112), type = "Ljung-Box", lag = 24)



# p-value > 0.05 zatem nie mamy podstaw do odrzucenia hipotezy zerowej o braku autokorelacji
# Jezeli nie mamy autokorelacji to mozemy przystapic do prognozowania


###############
# PROGNOZA
###############

forecast_arima112=forecast(arima112, h=12)

real_2020 <- window(index.ts, start=c(2019, 12), end=c(2020, 12))
prognoza <- forecast(arima112, h=12)
x11()
autoplot(prognoza) + 
  autolayer(real_2020, linewidth=1)






