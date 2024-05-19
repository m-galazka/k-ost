#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

##########################################################################################
# Moduł odpowiedzialny za konwersję pliku do formatu mp3.
# Moduł korzysta z aplikacji VLC zainstalowanej w systemie operacyjnym.
#
### PRZYKŁAD UŻYCIA
# vlc_konwertuj_na_mp3 ARGUMENTY
#
#   ARGUMENTY:
#     [1]=domyslna_sciezka_do_aplikacji_vlc # Ścieżka do aplikacji VLC
#     [2]=domyslna_sciezka_zrodlowa         # Ścieżka do katalogu z plikami 
#                                               przygotowanymi do konwersji
#     [3]=domyslna_sciezka_docelowa         # Ścieżka do katalogu w którym zostaną
#                                               zapisane pliku po przekonwertowaniu
#     [4]=domyslna_sciezka_logow            # Ścieżka do katalogu w którym zostaną
#                                               zapisane logi skryptu
#     [5]=usun_plik_po_przekonwertowaniu    # Tryb pracy skryptu:
#                                             - true  - usunie plik źródłowy 
#                                                                  po przekonwertowaniu
#                                             - false - nie usunie pliku źródłowego
#                                                                  po przekonwertowaniu
#
# Przykład wywołania:
# vlc_konwertuj_na_mp3 "${domyslna_sciezka_do_aplikacji_vlc}" \
#                      "${domyslna_sciezka_zrodlowa}" "${domyslna_sciezka_docelowa}" \
#                      "${domyslna_sciezka_logow}" "${usun_plik_po_przekonwertowaniu}"
##########################################################################################

vlc_konwertuj_na_mp3() {
  # Deklaracja zmiennych.
  declare -r argument_sciezka_do_aplikacji_vlc="${1}"
  declare -r argument_sciezka_zrodlowa="${2}"
  declare -r argument_sciezka_docelowa="${3}"
  declare -r argument_sciezka_logow="${4}"
  declare -r argument_usun_plik_po_przekonwertowaniu="${5}"

  declare -ar obslugiwane_formaty_do_konwersji=("*.aifc" "*.mp4")

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
    
    "${argument_sciezka_do_aplikacji_vlc}" "${vlc_komenda[@]}" &> "${argument_sciezka_logow}/${plik}.log"
    [[ "${argument_usun_plik_po_przekonwertowaniu}" == "true" ]] && rm "${plik}" && echo "Plik \"${plik}\" został usunięty."
  done
}