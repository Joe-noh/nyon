import passport from './_passport';
import * as fetch from './_fetch';

export async function get(req, res, next) {
  const callback = (token, tokenSecret, profile, done) => {
    fetch.post('/api/sessions', {token: token, secret: tokenSecret}).then(response => {
      if (response.status === 201) {
        response.json().then(json => {
          done({authToken: json.data.token});
        });
      } else {
        done({});
      }
    }).catch(error => {
      done({error: error});
    });
  }

  const auth = passport(callback).authenticate('twitter', {failureRedirect: '/'}, result => {
    if (result.authToken) {
      req.session.authToken = result.authToken;
      res.redirect('/s');
    } else {
      res.redirect('/');
    }
  });

  auth(req, res, next);
};
