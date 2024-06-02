#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

# Moduł odpowiedzialny za konwersję pliku do formatu mp3.
# Moduł korzysta z aplikacji VLC zainstalowanej w systemie operacyjnym.
#
### OPIS
# vlc_konwertuj_na_mp3 ARGUMENTY
#
#   ARGUMENTY:
#     [1]=domyslna_sciezka_do_aplikacji_vlc    # Ścieżka do aplikacji VLC
#     [2]=domyslna_sciezka_zrodlowa            # Ścieżka do katalogu z plikami 
#                                                  przygotowanymi do konwersji
#     [3]=domyslna_sciezka_docelowa            # Ścieżka do katalogu w którym zostaną
#                                                  zapisane pliku po przekonwertowaniu
#     [4]=usun_plik_po_przekonwertowaniu       # Tryb pracy skryptu:
#                                                - true  - usunie plik źródłowy 
#                                                          po przekonwertowaniu
#                                                - false - nie usunie pliku źródłowego
#                                                          po przekonwertowaniu
#
### PRZYKŁAD UŻYCIA
# vlc_konwertuj_na_mp3 "${domyslna_sciezka_do_aplikacji_vlc}" \
#                      "${domyslna_sciezka_zrodlowa}" \
#                      "${domyslna_sciezka_docelowa}" \
#                      "${usun_plik_po_przekonwertowaniu}"

vlc_konwertuj_na_mp3() {
  # Deklaracja zmiennych podanych w argumentach funkcji.
  declare -r argument_sciezka_do_aplikacji_vlc="${1}"
  declare -r argument_sciezka_zrodlowa="${2}"
  declare -r argument_sciezka_docelowa="${3}"
  declare -r argument_usun_plik_po_przekonwertowaniu="${4}"

  # Deklaracja tablicy z dostępnymi formatami konwersji.
  # Pliki w tych formatach zostaną przekonwertowane na mp3.
  declare -ar obslugiwane_formaty_do_konwersji=("*.aifc" "*.mp4")

  # Deklaracja zmiennych tput.
  declare -r m_vlc_tput_sc="$(tput sc)"
  declare -r m_vlc_tput_rc="$(tput rc)"
  declare -r m_vlc_tput_el="$(tput el)"
  declare -r m_vlc_tput_blink="$(tput blink)"
  declare -r m_vlc_tput_civis="$(tput civis)"
  declare -r m_vlc_tput_cnorm="$(tput cnorm)"
  declare -r m_vlc_tput_sgr0="$(tput sgr0)"

  declare -r m_vlc_tput_setaf_red="$(tput setaf 1)"
  declare -r m_vlc_tput_setaf_green="$(tput setaf 2)"
  declare -r m_vlc_tput_setaf_yellow="$(tput setaf 3)"
  declare -r m_vlc_tput_setaf_cyan="$(tput setaf 6)"

  # Proces konwersji.
  cd "${argument_sciezka_zrodlowa}"
  for plik in ${obslugiwane_formaty_do_konwersji[@]}; do
    [[ -e "${plik}" ]] || continue

    declare -a vlc_komenda=(
      "${plik}"
      -I dummy
      -vvv
      --sout="#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100}:std{access=file,mux=dummy,dst='${argument_sciezka_docelowa}/${plik%.*}.mp3'}"
      vlc://quit
    )
    
    printf "%s: %s" "${plik}" "${m_vlc_tput_sc}" >&2
    printf "%s[%s%sKonwertuje...%s]" "${m_vlc_tput_rc}" "${m_vlc_tput_blink}" "${m_vlc_tput_setaf_cyan}" "${m_vlc_tput_sgr0}" >&2
    "${argument_sciezka_do_aplikacji_vlc}" "${vlc_komenda[@]}" &> /dev/null
    printf "%s%s[%sGotowe%s]\n" "${m_vlc_tput_rc}" "${m_vlc_tput_el}" "${m_vlc_tput_setaf_green}" "${m_vlc_tput_sgr0}" >&2
    [[ "${argument_usun_plik_po_przekonwertowaniu}" == "true" ]] && rm "${plik}" \
    && printf "[%sINFO%s]Źródłowy plik \"%s\" został usunięty.\n" "${m_vlc_tput_setaf_yellow}" "${m_vlc_tput_sgr0}" "${plik}" >&2
  done
}