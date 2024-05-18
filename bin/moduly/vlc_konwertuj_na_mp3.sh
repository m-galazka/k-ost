#!/usr/bin/env bash

vlc_konwertuj_na_mp3() {
  # Deklaracja zmiennych
  declare -r argument_sciezka_do_aplikacji_vlc="${1}"
  declare -r argument_sciezka_zrodlowa="${2}"
  declare -r argument_sciezka_docelowa="${3}"
  declare -r argument_sciezka_logow="${4}"
  declare -r argument_usun_plik_po_przekonwertowaniu="${5}"

  declare -ar obslugiwane_formaty_do_konwersji=("*.aifc" "*.mp4")

  cd "${argument_sciezka_zrodlowa}"

  for plik in ${obslugiwane_formaty_do_konwersji[@]}; do
    [ -e "${plik}" ] || continue

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