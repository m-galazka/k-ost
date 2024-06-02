#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

# Deklaracje tput
declare -r tput_sc="$(tput sc)"
declare -r tput_rc="$(tput rc)"
declare -r tput_el="$(tput el)"
declare -r tput_blink="$(tput blink)"
declare -r tput_sgr0="$(tput sgr0)"

declare -r tput_setaf_red="$(tput setaf 1)"
declare -r tput_setaf_green="$(tput setaf 2)"
declare -r tput_setaf_yellow="$(tput setaf 3)"
declare -r tput_setaf_cyan="$(tput setaf 6)"

# Rozpoczęcie etapu weryfikacyjnego
printf "Trwa sprawdzanie poprawności konfiguracji" >&2
printf "%s [%s%sW TRAKCIE%s]" "${tput_sc}" "${tput_blink}" "${tput_setaf_cyan}" "${tput_sgr0}" >&2

# Wczytanie pliku konfiguracyjnego.
if [[ -f /usr/local/etc/k-ost.config ]] ; then
  . /usr/local/etc/k-ost.config
else
  printf "%s%s [%sBŁĄD%s]\n" "${tput_rc}" "${tput_el}" "${tput_setaf_red}" "${tput_sgr0}" >&2
  printf "%sBrak pliku konfiguracyjnego (k-ost.config)!%s\n" "${tput_setaf_red}" "${tput_sgr0}" >&2
  exit 20
fi

# Sprawdzenie czy katalog/plik podany w konfiguracji istnieje.
declare -ar lokalizacje_z_konfiguracji=(
    "${domyslna_sciezka_do_aplikacji_vlc}" "${domyslna_sciezka_zrodlowa}" "${domyslna_sciezka_docelowa}"
)
for wartosc_z_tablicy in "${lokalizacje_z_konfiguracji[@]}"; do
  [[ ! -d "${wartosc_z_tablicy}" && ! -f "${wartosc_z_tablicy}" ]] \
  && printf "%s%s [%sBŁĄD%s]\n" "${tput_rc}" "${tput_el}" "${tput_setaf_red}" "${tput_sgr0}" >&2\
  && printf "%sKatalog lub plik z \"%s\" nie istnieje.%s\n" "${tput_setaf_red}" "${wartosc_z_tablicy}" "${tput_sgr0}" >&2\
  && exit 21
done

# Wczytanie modułu vlc_konwertuj_na_mp3.sh.
declare -r sciezka_do_katalogu_k_ost="$(realpath "${0}")"
declare -r sciezka_do_katalogu_k_ost_bin="${sciezka_do_katalogu_k_ost%k-ost.sh}"
if [[ -f "${sciezka_do_katalogu_k_ost_bin}/moduly/vlc_konwertuj_na_mp3.sh" ]] ; then
  . "${sciezka_do_katalogu_k_ost_bin}/moduly/vlc_konwertuj_na_mp3.sh"
else
  printf "%s%s [%sBŁĄD%s]\n" "${tput_rc}" "${tput_el}" "${tput_setaf_red}" "${tput_sgr0}" >&2
  printf "%sNie odnaleziono modułu vlc_konwertuj_na_mp3.sh!%s\n" "${tput_setaf_red}" "${tput_sgr0}" >&2
  exit 22
fi

# Zakończenie etapu weryfikacyjnego
printf "%s%s [%sOK%s]\n" "${tput_rc}" "${tput_el}" "${tput_setaf_green}" "${tput_sgr0}" >&2

# Obsługa argumentów.
if [[ "${#}" > 0 ]] ; then
  case "${1}" in
    konwertuj)
      case "${2}" in
        mp3)
          vlc_konwertuj_na_mp3 "${domyslna_sciezka_do_aplikacji_vlc}" \
                               "${domyslna_sciezka_zrodlowa}" \
                               "${domyslna_sciezka_docelowa}" \
                               "${usun_plik_po_przekonwertowaniu}"
          exit 0
          ;;
        "")
          printf "%sBrak argumentu dla opcji \"%s\"! Użyj %s bez argumentów, aby wyświetlić pomoc.%s\n" "${tput_setaf_red}" "${1}" "${0}" "${tput_sgr0}" >&2
          exit 10
          ;;
        *)
          printf "%sNieznany argument \"%s\" dla opcji \"%s\"! Użyj %s bez argumentów, aby wyświetlić pomoc.%s\n" "${tput_setaf_red}" "${2}" "${1}" "${0}" "${tput_sgr0}" >&2
          exit 10
          ;;
      esac
      ;;
    *)
      printf "%sNieznany argument \"%s\"! Użyj %s bez argumentów, aby wyświetlić pomoc.%s\n" "${tput_setaf_red}" "${1}" "${0}" "${tput_sgr0}" >&2
      exit 10
      ;;
  esac
fi

# Wyświetlenie pomocy.
cat <<POMOC
Użycie: ${tput_setaf_yellow}"${0}" [-m|--mp3]${tput_sgr0}
${tput_setaf_cyan}
########################################
# Opis dostępnych argumentów.          #
########################################${tput_sgr0}
konwertuj                                      Uruchom tryb konwersji plików.
  mp3                                          Konwertuj pliki do formatu mp3.
${tput_setaf_cyan}
########################################
# Opis aktualnej konfiguracji.         #
########################################${tput_sgr0}
Ścieżka do aplikacji VLC:                     "${domyslna_sciezka_do_aplikacji_vlc}"
Ścieżka źródłowa:                             "${domyslna_sciezka_zrodlowa}"
Ścieżka docelowa:                             "${domyslna_sciezka_docelowa}"
Ustawienie usun_plik_po_przekonwertowaniu:    "${usun_plik_po_przekonwertowaniu}"
${tput_setaf_cyan}
########################################
# Opis kodów wyjścia.                  #
########################################${tput_sgr0}
 0                                            Skrypt wykonał się prawidłowo.
10                                            Nieznany argument skryptu.
20                                            Nie odnaleziono pliku konfiguracyjnego.
21                                            Plik lub katalog z pliku konfiguracyjnego nie istnieje.
22                                            Nie odnaleziono modułu vlc_konwertuj_na_mp3.sh.
30                                            Nie odnaleziono aplikacji VLC.
POMOC

exit 0