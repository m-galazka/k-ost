# Opis skryptu

Skrypt k-ost został stworzony w celu przyspieszenia konwersji plików audio.
Skrypt korzysta z aplikacji VLC.

# Instalacja skryptu

Aby skorzystać z k-ost, należy pobrać projekt na swój dysk,
a następnie wywołać ./install.sh.
Skrypt instalacyjny stworzy w systemie operacyjnym linki symboliczne do plików k-ost.sh i k-ost.config.

Aby skrypt zadziałał, należy samodzielnie zainstalować program VLC.

# Konfiguracja skryptu

Cała konfiguracja skryptu znajduje się w pliku k-ost/etc/k-ost.config.
- domyslna_sciezka_do_aplikacji_vlc: Wskazujemy bezwzględną ścieżkę do aplikacji VLC.
- domyslna_sciezka_zrodlowa: Wskazujemy bezwzględną ścieżkę do katalogu, w którym znajdują się pliki przygotowane do konwersji.
- domyslna_sciezka_docelowa: Wskazujemy bezwzględną ścieżkę do katalogu, w którym będą zapisywane przekonwertowane pliki.
- usun_plik_po_przekonwertowaniu: Definiujemy, czy plik z katalogu "domyslna_sciezka_zrodlowa" ma zostać usunięty po przekonwertowaniu.

# Przykład użycia

Po prawidłowym zainstalowaniu i skonfigurowaniu skryptu wydajemy polecenie:

- "k-ost", wyświetli się strona pomocy.
- "k-ost konwertuj mp3", rozpoczniemy proces konwersji plików do mp3.
