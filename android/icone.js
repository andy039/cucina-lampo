// Rigenera le icone dell'app Android partendo dal disegno che sta in index.html (funzione drawIcon).
// Serve solo se cambi l'icona: le PNG sono già nel repository.
// Uso: node android/icone.js   (richiede Playwright: npm i -g playwright && npx playwright install chromium)
'use strict';
const path = require('path');
const fs = require('fs');
const { chromium } = require('playwright');

const GAME = 'file://' + path.resolve(__dirname, '..', 'index.html');
const RES = path.join(__dirname, 'res');
// densità Android: icona classica 48 dp, livelli dell'icona adattiva 108 dp
const DENS = { mdpi: 1, hdpi: 1.5, xhdpi: 2, xxhdpi: 3, xxxhdpi: 4 };

async function render(page, hash, n, round) {
  await page.goto(GAME + '?r=' + Math.random() + hash + n, { waitUntil: 'domcontentloaded' });
  await page.waitForSelector('canvas');
  return page.evaluate(([n, round]) => {
    const src = document.querySelector('canvas');
    if (!round) return src.toDataURL('image/png');
    // icona classica (Android 7 e precedenti): quadrato con gli angoli arrotondati
    const c = document.createElement('canvas'); c.width = c.height = n;
    const x = c.getContext('2d'), r = n * .2;
    x.beginPath(); x.moveTo(r, 0); x.arcTo(n, 0, n, n, r); x.arcTo(n, n, 0, n, r); x.arcTo(0, n, 0, 0, r); x.arcTo(0, 0, n, 0, r); x.closePath();
    x.clip(); x.drawImage(src, 0, 0);
    return c.toDataURL('image/png');
  }, [n, round]);
}
function save(file, dataUrl) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, Buffer.from(dataUrl.split(',')[1], 'base64'));
  console.log('scritto', path.relative(path.join(__dirname, '..'), file));
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.route(/fonts\.googleapis|fonts\.gstatic/, r => r.abort());
  for (const [d, k] of Object.entries(DENS)) {
    const dir = path.join(RES, 'mipmap-' + d);
    save(path.join(dir, 'ic_launcher.png'), await render(page, '#icon', Math.round(48 * k), true));
    for (const [part, name] of [['bg', 'background'], ['fg', 'foreground'], ['mono', 'monochrome']])
      save(path.join(dir, 'ic_launcher_' + name + '.png'), await render(page, '#icon' + part, Math.round(108 * k), false));
  }
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
