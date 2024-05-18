#!/usr/bin/env bash

# Autor: Mariusz Gałązka <m.galazka.email@gmail.com>
# Link: https://github.com/m-galazka/k-ost

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
###

# Wczytanie pliku konfiguracyjnego.
. /usr/local/etc/k-ost.config

exit 0