import passport from './_passport';

export async function get(req, res, next) {
  const auth = passport().authenticate('twitter', { failureRedirect: '/login' }, () => {
    res.redirect('/');
  });

  auth(req, res, next);
};
