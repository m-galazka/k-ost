#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

##########################################################################################
### INSTALACJA
# Aby móć skorzystać ze skrytu należy skonfigurować system operacyjny do obsługi skryptu.
# Został utworzony specjalny skrypt instalacyjny, który należy uruchomić - ./install.sh.
# Skrypt uruchamiamy z lokalizacji katalogu k-ost oraz uprawnieniami roota.
# Skrypt stworzy linki symboliczne dla pliku k-ost/bin/k-ost oraz k-ost/etc/k-ost.config
# Po instalacji skryptu. Musimy skonfigurować program pod nasz system operacyjny.
# W tym celu należy edytować plik k-ost/etc/k-ost.config.
### ZASTOSOWANIE
# Skryptu używamy z poziomu terminala. Jeśli instalacja powiodła się pomyślnie.
# To w terminalu wydajemy polecenie "k-ost".
##########################################################################################

# Wczytanie pliku konfiguracyjnego.
if [ -f /usr/local/etc/k-ost.config ] ; then
  . /usr/local/etc/k-ost.config
else
  echo "Brak pliku konfiguracyjnego!"
  exit 1
fi
# Sprawdzenie czy katalog/plik podany w konfiguracji istnieje.
declare -ar lokalizacje_z_konfiguracji=(
    "${domyslna_sciezka_do_lokalizacji_modulow}" "${domyslna_sciezka_do_aplikacji_vlc}"
    "${domyslna_sciezka_zrodlowa}" "${domyslna_sciezka_docelowa}" "${domyslna_sciezka_logow}"
)
for wartosc_z_tablicy in "${lokalizacje_z_konfiguracji[@]}"; do
  [[ ! -d "${wartosc_z_tablicy}" && ! -f "${wartosc_z_tablicy}" ]] \
  && echo "Katalog lub plik z \"${wartosc_z_tablicy}\" nie istnieje." \
  && exit 1
done

# Obsługa argumentów
while (( "${#}" > 0 )) ; do
  case "${1}" in
    -mp3|--konwertuj_na_mp3)
      echo "Konwersja..."
      exit 0
      ;;
    *)
      echo "Nieznany argument ${1}! Użyj ${0} bez argumentów, aby wyświetlić pomoc."
      exit 1
      ;;
  esac
  shift
done

# Wyświetlenie pomocy
cat <<POMOC
Użycie: "${0}" [-mp3|--konwertuj_na_mp3]

Aktualna konfiguracja:
  Ścieżka do modułów:                           "${domyslna_sciezka_do_lokalizacji_modulow}"
  Ścieżka do aplikacji VLC:                     "${domyslna_sciezka_do_aplikacji_vlc}"
  Ścieżka źródłowa:                             "${domyslna_sciezka_zrodlowa}"
  Ścieżka docelowa:                             "${domyslna_sciezka_docelowa}"
  Ścieżka logów:                                "${domyslna_sciezka_logow}"
  Ustawienie usun_plik_po_przekonwertowaniu:    "${usun_plik_po_przekonwertowaniu}"
POMOC

exit 0