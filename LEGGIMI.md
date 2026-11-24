# Cucina Lampo: server online

Questo pacchetto fa due cose:

- mette online il gioco, così chiunque lo apre dal browser (anche su iPhone);
- collega i giocatori: uno crea una stanza, l'altro entra con il codice di 4 lettere.

Non ha dipendenze esterne. Serve solo Node 18 o più recente, e Render lo fornisce già.

## File

- `server.js`: il server
- `package.json`: dice a Render come avviarlo
- `index.html`: il gioco
- `android/`: l'app Android (vedi in fondo). A Render non serve

## Metterlo online gratis su Render

1. **GitHub.** Crea un account gratuito su github.com. Poi crea un nuovo repository chiamato `cucina-lampo` (va bene pubblico). Scegli "Add file", poi "Upload files" e carica i tre file qui sopra, poi "Commit changes".
2. **Render.** Vai su render.com e registrati con l'account GitHub. Non serve la carta di credito.
3. Scegli **New**, poi **Web Service**, e seleziona il repository `cucina-lampo`.
4. Compila così:
   - Language: **Node**
   - Build Command: `npm install`
   - Start Command: `node server.js`
   - Instance Type: **Free**
   - Region: **Frankfurt (EU Central)**, la più vicina all'Italia. La regione non si cambia dopo: se il servizio è già in un'altra regione (per esempio Oregon), creane uno nuovo in Frankfurt. Con un server lontano ogni azione dell'amico arriva con un ritardo che si sente.
5. Premi **Deploy Web Service** e aspetta un paio di minuti. In alto compare l'indirizzo, per esempio `https://cucina-lampo.onrender.com`.

## Giocare online

- **Dal browser, iPhone compreso:** apri l'indirizzo di Render. Su iPhone puoi anche usare Condividi e poi "Aggiungi alla schermata Home".
- **Dall'app Android:** premi Gioca, scegli "Online con un amico" e controlla che nel campo "Server" ci sia l'indirizzo di Render. Va fatto una volta sola.

Poi uno dei due preme **Crea una stanza** e dice il codice all'altro, che lo scrive e preme **Entra**. Quando l'amico è dentro, chi ha creato la stanza sceglie locale e difficoltà e apre il locale.

## Da sapere sul piano gratuito

- Se nessuno lo usa per 15 minuti, il server va in pausa. La prima connessione dopo la pausa può richiedere fino a un minuto.
- Ogni mese hai 750 ore gratuite: bastano per tenerlo acceso tutto il mese.
- Per aggiornare basta ricaricare su GitHub i file cambiati (`index.html`, `server.js`): Render li pubblica da solo.

## App Android

L'app è il gioco (`index.html`) dentro una finestra a tutto schermo, con l'icona del cappello e del lampo.

- **Installarla.** Copia `CucinaLampo.apk` sul telefono e aprilo. Se avevi una versione firmata con un'altra chiave, Android rifiuta l'aggiornamento: disinstalla prima la vecchia app (si perdono record e indirizzo del server salvati).
- **Ricostruirla** dopo aver cambiato il gioco, su Ubuntu o Debian:

  ```bash
  sudo apt install aapt apksigner zipalign dalvik-exchange android-sdk-platform-23 default-jdk zip
  ./android/build.sh
  ```

  Il risultato è `android/CucinaLampo.apk`. La chiave di firma è `android/lampo.keystore`: se manca, lo script ne crea una nuova. Tienila da parte e non caricarla su GitHub: gli aggiornamenti si installano sopra l'app solo se firmati con la stessa chiave.
- **Cambiare l'icona.** Il disegno sta in `index.html` (funzione `drawIcon`). Dopo averlo cambiato, `node android/icone.js` rigenera le immagini in `android/res` (serve Playwright).
