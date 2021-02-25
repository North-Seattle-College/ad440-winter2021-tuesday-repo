const puppeteer = require('puppeteer');

const escapeXpathString = str => {
  const splitedQuotes = str.replace(/'/g, `', "'", '`);
  return `concat('${splitedQuotes}', '')`;
};


const clickByText = async (page, text) => {
  const escapedText = escapeXpathString(text);
  const linkHandlers = await page.$x(`//a[contains(text(), ${escapedText})]`);

  if (linkHandlers.length > 0) {
    await linkHandlers[0].click();
  } else {
    throw new Error(`Link not found: ${text}`);
  }
};

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net');

  await clickByText(page, `Users`)
  await clickByText(page, `wgrinston0`)
  await clickByText(page, `View User Tasks`)

  await page.screenshot({ path: 'capture-users-id-tasks.png' });

  await browser.close();

})();