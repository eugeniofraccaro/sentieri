# COME MODIFICARE IL SITO — guida completa

Sito online: **https://eugeniofraccaro.github.io/sentieri/**
Repository: **https://github.com/eugeniofraccaro/sentieri**

Questa guida spiega tutto da zero, anche le cose date per scontate.
Tienila aggiornata se cambi qualcosa di importante.

---

## 1. Come funziona il sistema (leggilo una volta, poi tutto ha senso)

Esistono **due copie** del sito:

1. **La cartella sul tuo PC** (questa) → è l'ORIGINALE, quella su cui lavori.
2. **La copia su GitHub** → è quella PUBBLICATA, che il mondo vede.

**Niente si aggiorna da solo.** Se modifichi un file nella cartella, il sito
online resta com'era finché tu non "spedisci" le modifiche a GitHub con i
tre comandi di pubblicazione (capitolo 4). Vale anche al contrario: se
modifichi qualcosa direttamente su GitHub, la cartella sul PC resta vecchia
finché non la riallinei (capitolo 9).

La memoria storica di tutte le versioni è tenuta da **git**, un programma
invisibile che vive nella sottocartella nascosta `.git`: ogni volta che fai
un "commit" scatta una fotografia della cartella, e puoi sempre tornare a
qualsiasi fotografia passata (capitolo 10).

### Dove conviene modificare: locale o GitHub?

**Sempre dal PC (locale).** Motivi:
- le foto nuove le hai sul PC, e lo script che le ridimensiona gira sul PC;
- puoi vedere l'anteprima con un doppio clic PRIMA di pubblicare;
- eviti di avere due versioni diverse nello stesso momento.

Modificare da GitHub (matita sul file, dal browser) è possibile ma va
riservato a micro-correzioni di testo quando non sei al tuo PC — e dopo
DEVI riallineare la cartella locale (capitolo 9), altrimenti alla prima
pubblicazione dal PC le due versioni entrano in conflitto.

---

## 2. La mappa della cartella

```
provaClaudeSito\
│  index.html          ← TUTTO il sito: testi, grafica, elenco gite
│  ridimensiona.ps1    ← script che prepara le foto per il web
│  HOWTODO.md          ← questa guida
│  .gitignore          ← elenco di ciò che NON va mai caricato online
│  .nojekyll           ← file vuoto ma FONDAMENTALE (vedi capitolo 11)
│
├─ media\              ← le foto/video che il sito mostra (versioni leggere)
│   └─ Monte Sief\
│       _DSF5174.JPG   (~0,5 MB l'una: create dallo script)
│
├─ originali\          ← le foto piene (20+ MB). SOLO sul tuo PC, mai online.
│   └─ Monte Sief\        NON CANCELLARLA MAI: è il tuo archivio.
│
└─ .git\               ← cartella nascosta di git. Non toccarla mai.
```

Dentro `index.html` ci sono tre zone:
- in alto, tra `<style>` e `</style>`: la **grafica** (colori, caratteri);
- al centro, il testo visibile dell'intestazione e del fondo pagina;
- in basso, dopo la scritta `ELENCO DELLE GITE`: **l'elenco `VIAGGI`**,
  cioè i contenuti veri (gite, foto, didascalie). È qui che lavorerai
  quasi sempre. Tutto ciò che segue il commento "Da qui in giù è il motore
  della pagina" NON va mai toccato.

---

## 3. Aprire il "terminale" nella cartella giusta

I comandi si danno in **PowerShell**, e PowerShell deve "trovarsi" dentro
la cartella del sito. Due modi:

- **Facile**: apri la cartella in Esplora file, clic destro in un punto
  vuoto → "Apri nel terminale" (o "Apri finestra PowerShell qui").
- **A mano**: apri PowerShell dal menu Start e scrivi
  `cd "C:\Users\Utente\OneDrive\Desktop\provaClaudeSito"` e premi Invio.
  (Se sposti la cartella, aggiorna il percorso — capitolo 8.)

Per controllare di essere nel posto giusto scrivi `git status`: se risponde
con "On branch main" sei a posto; se dice "not a git repository" sei nella
cartella sbagliata.

---

## 4. Pubblicare: i tre comandi (sempre gli stessi)

Qualunque modifica tu faccia, per mandarla online la sequenza è SEMPRE:

```
git add -A
git commit -m "Due parole su cosa hai cambiato"
git push
```

Riga per riga:
- `git add -A` = "prepara tutte le modifiche" (file nuovi, cambiati, cancellati);
- `git commit -m "..."` = "scatta la fotografia", con una descrizione tua
  (il testo tra virgolette è libero: ti servirà per ritrovarla in futuro);
- `git push` = "spedisci a GitHub".

Dopo il push, GitHub ricostruisce il sito **da solo in 1–2 minuti**.
Se nel browser vedi ancora la versione vecchia, forza il ricaricamento
con **Ctrl+F5**.

> Prima di pubblicare, guarda sempre l'anteprima: doppio clic su
> `index.html` e la pagina si apre nel browser esattamente come sarà online.

---

## 5. Ricetta: cambiare i TESTI (titoli, racconti, didascalie)

1. Clic destro su `index.html` → Apri con → **Blocco note** (o altro editor).
2. Ctrl+F e cerca `ELENCO DELLE GITE`.
3. Sotto trovi le gite scritte così:
   ```
   titolo: "Monte Sief al tramonto",
   luogo:  "Dolomiti, gruppo Col di Lana",
   data:   "13 giugno 2026",
   quota:  "2.424 m",
   racconto: "Salita serale, ...",
   ```
   e per ogni foto:
   ```
   { src:"media/Monte Sief/_DSF5174.JPG",
     alt:"descrizione per chi non vede l'immagine",
     didascalia:"testo che appare sotto la foto." },
   ```
4. Cambia SOLO il testo **tra le virgolette**. Salva (Ctrl+S).
5. Anteprima con doppio clic, poi pubblica (capitolo 4).

**Le due regole d'oro dei testi:**
- non cancellare mai le virgolette `"` che aprono e chiudono, né la
  virgola a fine riga: se la pagina di colpo appare vuota, al 99% manca
  una virgoletta;
- dentro il testo non usare il carattere `"`; per citare usa «caporali»
  o l'apostrofo (l'apostrofo semplice, come in *l'alba*, va benissimo).

Anche il **titolo grande del sito** e il sottotitolo si cambiano in
`index.html`: cerca `titolo-sito` e modifica il testo lì vicino. Idem la
frase nel piè di pagina (cerca `Regola di casa`) e la firma (cerca `firma:`).

---

## 6. Ricetta: aggiungere una NUOVA GITA con foto

1. **Copia le foto piene** (anche 20+ MB, va bene) in una nuova
   sottocartella di `originali\`, per esempio `originali\Marmolada\`.
   Evita simboli strani nel nome; spazi e accenti sono ok.
2. **Ridimensiona**: apri PowerShell nella cartella del sito e lancia
   ```
   powershell -ExecutionPolicy Bypass -File .\ridimensiona.ps1
   ```
   Lo script crea da solo `media\Marmolada\` con le versioni leggere
   (2560 px, ~0,5 MB l'una) e salta quelle già fatte. Gli originali non
   vengono toccati.
3. **Scrivi la gita** in `index.html`: trova `const VIAGGI = [`, copia
   l'intero blocco del Monte Sief — da `{` a `},` compresa — e incollane
   una copia SOPRA (la gita più recente va in cima). Poi nel nuovo blocco
   cambia titolo, luogo, data, quota, racconto e l'elenco delle foto.
   I nomi dei file vanno scritti **identici, MAIUSCOLE COMPRESE**:
   `media/Marmolada/_DSF6001.JPG` e `media/Marmolada/_dsf6001.jpg` per il
   sito online sono due file diversi (sul tuo PC no: ecco perché in locale
   può funzionare e online no!).
4. Anteprima con doppio clic; se una foto mostra il riquadro
   "manca il file", il nome scritto non coincide con quello vero.
5. Pubblica (capitolo 4).

**Extra disponibili per ogni elemento della gita:**
- foto panoramica a tutta larghezza: aggiungi `pano:true,` dopo `src:...`;
- video mp4 dalla cartella media (MAI sopra i 95 MB):
  `{ tipo:"video", src:"media/Marmolada/volo.mp4", didascalia:"..." },`
- video da Vimeo/YouTube (embed):
  `{ tipo:"embed", src:"https://player.vimeo.com/video/IDNUMERICO", didascalia:"..." },`

---

## 7. Ricetta: togliere o sostituire foto e gite

- **Togliere una foto da una gita**: in `index.html` cancella il suo intero
  blocco `{ src:"...", alt:"...", didascalia:"..." },` (da graffa a graffa,
  virgola compresa). Se vuoi, elimina anche il file da `media\` (ma NON da
  `originali\`). Poi pubblica.
- **Togliere una gita intera**: cancella il suo blocco da `{` a `},` dentro
  `VIAGGI`. Poi pubblica.
- **Sostituire una foto con una versione migliore**: metti la nuova in
  `originali\<Gita>\` con lo stesso nome, cancella la versione in
  `media\<Gita>\`, rilancia lo script, pubblica.

---

## 8. Spostare o rinominare la cartella sul PC

Si può fare **liberamente e in ogni momento**: tutta la memoria di git sta
nella sottocartella nascosta `.git`, che si sposta insieme al resto. GitHub
non sa e non gli interessa dove sta la cartella sul tuo PC.

1. Chiudi editor e PowerShell aperti sulla cartella.
2. Sposta o rinomina la cartella come un normale trasloco di file
   (trascina, oppure taglia/incolla).
3. D'ora in poi apri PowerShell **nella nuova posizione** (capitolo 3).
   Tutto il resto — comandi, push, sito — funziona identico.

Nota su **OneDrive**: oggi la cartella è dentro Desktop, che OneDrive
sincronizza. Va bene (doppio backup gratis), con un'accortezza: in
OneDrive non attivare "Libera spazio"/"solo online" su questa cartella,
perché git deve avere i file fisicamente sul disco.

Se un giorno **cambi PC**: installa git e GitHub CLI, poi
`gh auth login` e `git clone https://github.com/eugeniofraccaro/sentieri`.
ATTENZIONE: così recuperi tutto TRANNE `originali\`, che non è mai stata
caricata online. Gli originali vivono solo sul tuo PC/OneDrive: fanne
un backup a parte (disco esterno) se ci tieni.

---

## 9. Modificare da GitHub (solo per emergenze di testo)

1. Vai su https://github.com/eugeniofraccaro/sentieri → clic su `index.html`
   → icona **matita** in alto a destra → modifichi nel browser →
   bottone verde **Commit changes**. Il sito si aggiorna da solo in 1–2 min.
2. **Appena torni al PC**, PRIMA di qualsiasi altra modifica locale, apri
   PowerShell nella cartella e scrivi:
   ```
   git pull
   ```
   che scarica nella cartella le modifiche fatte online. Se lo dimentichi
   e modifichi in locale, al `git push` git protesterà ("rejected"): in tal
   caso fai `git pull`, risolvi come ti indica, e ripeti il push.

Regola semplice: **una cosa alla volta, un posto alla volta.** Se lavori
sempre e solo dal PC, questo capitolo non ti servirà mai.

---

## 10. Ho combinato un pasticcio: come si torna indietro

- **Ho modificato un file e mi sono pentito (non ho ancora fatto commit):**
  ```
  git restore index.html
  ```
  riporta il file all'ultima fotografia. (`git restore .` per tutti i file.)
- **Voglio vedere cosa ho cambiato prima di pubblicare:**
  ```
  git status        ← quali file sono cambiati
  git diff          ← le righe esatte (q per uscire)
  ```
- **Voglio rivedere la storia:**
  ```
  git log --oneline
  ```
  elenca le fotografie, ognuna con un codice tipo `82bb424` e la tua
  descrizione. (q per uscire.)
- **Voglio recuperare la versione di un file da una fotografia passata:**
  ```
  git checkout 82bb424 -- index.html
  ```
  (sostituisci il codice con quello vero preso da `git log`), poi
  commit + push per pubblicare il ripristino.
- **La pagina online è rotta e voglio tornare SUBITO all'ultima versione buona:**
  ```
  git revert HEAD
  git push
  ```
  crea una fotografia che annulla l'ultima e la pubblica. Niente panico:
  con git non si perde mai niente di ciò che è stato committato.

---

## 11. Problemi frequenti e soluzioni lampo

| Sintomo | Causa e rimedio |
|---|---|
| La pagina si apre **bianca/vuota** | Virgoletta o virgola persa nell'elenco `VIAGGI`. Riapri il file e controlla l'ultima cosa modificata, oppure `git restore index.html` e riparti. |
| Una foto mostra "**manca il file**" | Il nome in `index.html` non coincide col file in `media\` (occhio a MAIUSCOLE/minuscole ed estensione `.JPG` vs `.jpg`). |
| Foto ok sul PC ma **404 online** | Quasi sempre maiuscole/minuscole sbagliate (online contano!). Oppure è sparito il file `.nojekyll`: deve esistere, anche vuoto, altrimenti GitHub nasconde i file che iniziano con `_` come `_DSF...JPG`. |
| `git push` **rifiutato** ("rejected") | Su GitHub ci sono modifiche che il PC non ha: `git pull`, poi ripeti il push. |
| GitHub **rifiuta un file** (>100 MB) | Non caricare il file pieno: passa dallo script. Se è un video, comprimilo sotto i 95 MB. |
| Il sito **non si aggiorna** dopo il push | Aspetta 1–2 minuti e poi Ctrl+F5. Lo stato della ricostruzione è su GitHub → repo → scheda "Actions"/ambiente "github-pages". |
| PowerShell **non riconosce `gh`** | Chiudi e riapri PowerShell (il PATH si aggiorna all'avvio). |
| `git push` chiede chi sei | L'accesso è scaduto: `gh auth login` e segui il browser. |

---

## 12. Le cinque regole d'oro

1. **`originali\` non si cancella mai** — è l'unico posto con le foto piene.
2. **`.nojekyll` e `.gitignore` non si toccano** — uno pubblica i file con
   `_`, l'altro impedisce di caricare per sbaglio RAW e originali.
3. **Maiuscole = sacre** nei nomi dei file citati in `index.html`.
4. **Anteprima prima, push dopo** — doppio clic su index.html costa zero.
5. **Il "motore" in fondo a index.html non si tocca** — tutto ciò che ti
   serve sta tra `ELENCO DELLE GITE` e la riga "Da qui in giù è il motore".

---

*Guida scritta il 7 luglio 2026. Il sito è nato il 6 luglio 2026.*
