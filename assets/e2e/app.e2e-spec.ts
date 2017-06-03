import { NyonPage } from './app.po';

describe('nyon App', () => {
  let page: NyonPage;

  beforeEach(() => {
    page = new NyonPage();
  });

  it('should display welcome message', done => {
    page.navigateTo();
    page.getParagraphText()
      .then(msg => expect(msg).toEqual('Welcome to nyon!!'))
      .then(done, done.fail);
  });
});
