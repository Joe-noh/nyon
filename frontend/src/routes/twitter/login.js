import passport from './_passport';

export async function get(req, res, next) {
  passport(() => {}).authenticate('twitter')(req, res, next);
};
