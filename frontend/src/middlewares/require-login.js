export default () => (req, res, next) => {
  const requireLogin = (req.path === '/s' || req.path.startsWith('/s/'));

  if (requireLogin && !req.session.authToken) {
    res.redirect("/");
  } else {
    next();
  }
};
