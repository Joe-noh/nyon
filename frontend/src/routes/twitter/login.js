import passport from './_passport';

export async function get(req, res, next) {
  return passport().authenticate('twitter')(req, res, next);
};
