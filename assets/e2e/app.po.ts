import { browser, by, element } from 'protractor';

export class NyonPage {
  navigateTo() {
    return browser.get('/');
  }

  getParagraphText() {
    return element(by.css('nyon-root h1')).getText();
  }
}
