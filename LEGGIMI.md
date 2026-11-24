# Cucina Lampo: server online

Questo pacchetto fa due cose:

- mette online il gioco, così chiunque lo apre dal browser (anche su iPhone);
- collega i giocatori: uno crea una stanza, l'altro entra con il codice di 4 lettere.

Non ha dipendenze esterne. Serve solo Node 18 o più recente, e Render lo fornisce già.

## File

- `server.js`: il server
- `package.json`: dice a Render come avviarlo
- `index.html`: il gioco

## Metterlo online gratis su Render

1. **GitHub.** Crea un account gratuito su github.com. Poi crea un nuovo repository chiamato `cucina-lampo` (va bene pubblico). Scegli "Add file", poi "Upload files" e carica i tre file qui sopra, poi "Commit changes".
2. **Render.** Vai su render.com e registrati con l'account GitHub. Non serve la carta di credito.
3. Scegli **New**, poi **Web Service**, e seleziona il repository `cucina-lampo`.
4. Compila così:
   - Language: **Node**
   - Build Command: `npm install`
   - Start Command: `node server.js`
   - Instance Type: **Free**
5. Premi **Deploy Web Service** e aspetta un paio di minuti. In alto compare l'indirizzo, per esempio `https://cucina-lampo.onrender.com`.

## Giocare online

- **Dal browser, iPhone compreso:** apri l'indirizzo di Render. Su iPhone puoi anche usare Condividi e poi "Aggiungi alla schermata Home".
- **Dall'app Android:** nel menu scegli "Online" e incolla l'indirizzo di Render nel campo "Indirizzo del tuo server". Va fatto una volta sola.

Poi uno dei due preme **Crea una stanza** e dice il codice all'altro, che lo scrive e preme **Entra**. Quando l'amico è dentro, chi ha creato la stanza sceglie locale e difficoltà e apre il locale.

## Da sapere sul piano gratuito

- Se nessuno lo usa per 15 minuti, il server va in pausa. La prima connessione dopo la pausa può richiedere fino a un minuto.
- Ogni mese hai 750 ore gratuite: bastano per tenerlo acceso tutto il mese.
- Per aggiornare il gioco basta ricaricare su GitHub il nuovo `index.html`: Render lo pubblica da solo.
