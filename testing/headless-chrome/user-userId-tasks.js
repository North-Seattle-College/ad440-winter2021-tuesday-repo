const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('<url goes here>');
    await page.screenshot({ path: '<name of output file goes here>' })
})