# Prognozowanie inflacji w USA z użyciem modeli ARIMA

## Opis projektu
Projekt przedstawia proces analizy i modelowania szeregów czasowych na przykładzie miesięcznych odczytów wskaźnika inflacji w Stanach Zjednoczonych (dane od stycznia 2011 do czerwca 2023). Głównym celem skryptu jest identyfikacja optymalnego modelu klasy ARIMA oraz wygenerowanie prognozy dla wartości wskaźnika, z uwzględnieniem podziału na zbiór uczący i testowy.

Kod przeprowadza użytkownika przez pełną ścieżkę analityczną opartą na metodologii Boxa-Jenkinsa: od wizualizacji i transformacji danych, przez weryfikację założeń statystycznych, aż po diagnostykę modelu końcowego.

## Zakres analizy i zastosowane metody
W ramach projektu zrealizowano następujące kroki analityczne:
* **Analiza stacjonarności:** Weryfikacja szeregu za pomocą testu KPSS. Brak stacjonarności dla poziomów zmiennej wymusił zastosowanie pierwszych różnic.
* **Identyfikacja modelu:** Analiza funkcji autokorelacji (ACF) i autokorelacji cząstkowej (PACF) w celu wstępnego doboru rzędów opóźnień (p, q).
* **Estymacja i selekcja:** Budowa kilku wariantów modeli ARIMA (np. ARIMA(1,1,3), ARIMA(1,1,2)) i wybór optymalnego w oparciu o kryteria informacyjne Akaikego (AIC) oraz bayesowskie kryterium Schwartza (BIC).
* **Diagnostyka reszt:** Weryfikacja założenia o białym szumie w resztach wybranego modelu przy użyciu testu Ljung-Boxa.
* **Prognozowanie:** Wyznaczenie 12-miesięcznej predykcji ex-post i wizualne porównanie jej z rzeczywistymi danymi ze zbioru testowego (rok 2020).

## Wymagania techniczne
Skrypt został napisany w języku R. Do jego prawidłowego działania wymagane jest zainstalowanie następujących pakietów:
* `fpp2`, `forecast` – narzędzia do modelowania szeregów czasowych i tworzenia prognoz.
* `urca` – testy pierwiastków jednostkowych (test KPSS).
* `lmtest`, `stats` – podstawowe funkcje statystyczne i diagnostyczne.
* `gridExtra` – zaawansowane zarządzanie układem wykresów.
* `xts` – obsługa rozszerzonych obiektów szeregów czasowych.

## Uruchomienie projektu
1. Pobierz repozytorium na dysk lokalny.
2. Upewnij się, że plik ze zbiorem danych `US_inflation_rates.csv` znajduje się w głównym katalogu roboczym projektu. Z tego poziomu skrypt zaczytuje dane.
3. Zainstaluj wymagane zależności w R:
   ```R
   install.packages(c("fpp2", "forecast", "urca", "lmtest", "gridExtra", "xts"))
4. Uruchom plik ze skryptem głównym
## Struktura plików
**skrypt_arima.R** – kod źródłowy przeprowadzający proces estymacji i testowania
**US_inflation_rates.csv** - historyczne dane wejściowe
**README.md** - dokumentacja
