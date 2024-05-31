#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

##########################################################################################
# Skrypt stworzony dla ułatwienia konwersji pliku do formatu mp3.
# Skrypt wykorzystuję aplikację VLC, którą należy zainstalować w systemie operacyjnym.
#
### INSTALACJA SKRYPTU
# Przejdź do głównego katalogu k-ost.
# Uruchom z uprawnieniami root skrypt instalacyjny  "./install.sh".
#   Skrypt install.sh utworzony w systemie operacyjnym linki symboliczne dla:
#       - k-ost/bin/k-ost.sh
#       - k-ost/etc/k-ost.config
# Skonfiguruj skrypt edytując plik konfiguracyjny "k-ost/etc/k-ost.config".
#
### PRZYKŁAD UŻYCIA
# W terminalu wydaj następujące polecenia:
# Wyświetl stronę pomocy: "k-ost"
# Przekonwertuj pliki na mp3 "k-ost -m" lub "k-ost --mp3"
##########################################################################################

# Wczytanie pliku konfiguracyjnego.
if [[ -f /usr/local/etc/k-ost.config ]] ; then
  . /usr/local/etc/k-ost.config
else
  echo "Brak pliku konfiguracyjnego!"
  exit 20
fi
# Sprawdzenie czy katalog/plik podany w konfiguracji istnieje.
declare -ar lokalizacje_z_konfiguracji=(
    "${domyslna_sciezka_do_lokalizacji_modulow}" "${domyslna_sciezka_do_aplikacji_vlc}"
    "${domyslna_sciezka_zrodlowa}" "${domyslna_sciezka_docelowa}"
)
for wartosc_z_tablicy in "${lokalizacje_z_konfiguracji[@]}"; do
  [[ ! -d "${wartosc_z_tablicy}" && ! -f "${wartosc_z_tablicy}" ]] \
  && echo "Katalog lub plik z \"${wartosc_z_tablicy}\" nie istnieje." \
  && exit 21
done

# Sprawdzenie wersji zainstalowanego programu VLC.
declare -r wersja_VLC=`${ENV_K_OST_DOMYSLNA_SCIEZKA_DO_APLIKACJI_VLC} --version 2> /dev/null | awk NR==1`
if [[ -n "${wersja_VLC}" ]] && [[ "${wersja_VLC}" =~ "VLC" ]] ; then
  echo "Zainstalowana wersja VLC: ${wersja_VLC}"
else
  echo "Nie odnaleziono programu VLC!"
  exit 30
fi

# Wczytanie modułu vlc_konwertuj_na_mp3.sh.
if [[ -f "${domyslna_sciezka_do_lokalizacji_modulow}/vlc_konwertuj_na_mp3.sh" ]] ; then
  . "${domyslna_sciezka_do_lokalizacji_modulow}/vlc_konwertuj_na_mp3.sh"
else
  echo "Nie odnaleziono modułu vlc_konwertuj_na_mp3.sh!"
  exit 22
fi

# Obsługa argumentów.
while (( "${#}" > 0 )) ; do
  case "${1}" in
    -m|--mp3)
      vlc_konwertuj_na_mp3 "${domyslna_sciezka_do_aplikacji_vlc}" \
                           "${domyslna_sciezka_zrodlowa}" \
                           "${domyslna_sciezka_docelowa}" \
                           "${usun_plik_po_przekonwertowaniu}"
      exit 0
      ;;
    *)
      echo "Nieznany argument ${1}! Użyj ${0} bez argumentów, aby wyświetlić pomoc."
      exit 10
      ;;
  esac
  shift
done

# Wyświetlenie pomocy.
cat <<POMOC
Użycie: "${0}" [-m|--mp3]

ARGUMENTY:
  -m|--mp3                                      Uruchom konwersję plików do formatu mp3.

Aktualna konfiguracja:
  Ścieżka do modułów:                           "${domyslna_sciezka_do_lokalizacji_modulow}"
  Ścieżka do aplikacji VLC:                     "${domyslna_sciezka_do_aplikacji_vlc}"
  Ścieżka źródłowa:                             "${domyslna_sciezka_zrodlowa}"
  Ścieżka docelowa:                             "${domyslna_sciezka_docelowa}"
  Ustawienie usun_plik_po_przekonwertowaniu:    "${usun_plik_po_przekonwertowaniu}"

Kod wyjścia:
   0                                            Skrypt wykonał się prawidłowo.
  10                                            Nieznany argument skryptu.
  20                                            Nie odnaleziono pliku konfiguracyjnego.
  21                                            Plik lub katalog z pliku konfiguracyjnego nie istnieje.
  22                                            Nie odnaleziono modułu vlc_konwertuj_na_mp3.sh.
  30                                            Nie odnaleziono aplikacji VLC.
POMOC

exit 0