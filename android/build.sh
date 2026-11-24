#!/bin/bash
# Costruisce l'app Android android/CucinaLampo.apk con dentro l'index.html del gioco.
#
# Serve (su Ubuntu/Debian):
#   sudo apt install aapt apksigner zipalign dalvik-exchange android-sdk-platform-23 default-jdk zip
#
# La chiave di firma è android/lampo.keystore. Se non c'è, ne crea una nuova.
# Tienila da parte: gli aggiornamenti si installano sopra l'app solo se firmati con la stessa chiave
# (con una chiave diversa bisogna prima disinstallare l'app). Non va messa su GitHub.
set -euo pipefail
cd "$(dirname "$0")"

ANDROID_JAR=${ANDROID_JAR:-/usr/lib/android-sdk/platforms/android-23/android.jar}
KEYSTORE=${KEYSTORE:-lampo.keystore}
KS_PASS=${KS_PASS:-cucinalampo}
DX=$(command -v d8 || command -v dalvik-exchange || command -v dx)
OUT=build

rm -rf "$OUT"; mkdir -p "$OUT/classes" "$OUT/assets"

echo "1/5 risorse e manifest"
aapt2 compile --dir res -o "$OUT/res.zip"
cp ../index.html "$OUT/assets/index.html"
aapt2 link -o "$OUT/base.apk" -I "$ANDROID_JAR" --manifest AndroidManifest.xml -A "$OUT/assets" "$OUT/res.zip"

echo "2/5 codice"
javac -nowarn --release 8 -classpath "$ANDROID_JAR" -d "$OUT/classes" src/it/trattoria/lampo/MainActivity.java 2>&1 | grep -v "^warning\|^1 warning" || true
case "$(basename "$DX")" in
  d8) "$DX" --release --min-api 21 --lib "$ANDROID_JAR" --output "$OUT" "$OUT"/classes/it/trattoria/lampo/*.class ;;
  *)  "$DX" --dex --min-sdk-version=21 --output="$OUT/classes.dex" "$OUT/classes" ;;
esac

echo "3/5 pacchetto"
cp "$OUT/base.apk" "$OUT/unsigned.apk"
(cd "$OUT" && zip -q -X unsigned.apk classes.dex)
zipalign -p -f 4 "$OUT/unsigned.apk" "$OUT/aligned.apk"

echo "4/5 firma"
if [ ! -f "$KEYSTORE" ]; then
  echo "    nessuna chiave: ne creo una nuova in $KEYSTORE"
  keytool -genkeypair -keystore "$KEYSTORE" -alias lampo -keyalg RSA -keysize 2048 -validity 10000 \
    -dname "CN=Cucina Lampo, O=Cucina Lampo, C=IT" -storepass "$KS_PASS" -keypass "$KS_PASS" 2>/dev/null
fi
apksigner sign --ks "$KEYSTORE" --ks-pass "pass:$KS_PASS" --key-pass "pass:$KS_PASS" --out CucinaLampo.apk "$OUT/aligned.apk"
rm -f CucinaLampo.apk.idsig

echo "5/5 controllo"
apksigner verify CucinaLampo.apk
aapt2 dump badging CucinaLampo.apk | grep -E "^package|application-icon-(160|640)|^application:"
echo "Fatto: android/CucinaLampo.apk"
