import passport from 'passport';
import {Strategy} from 'passport-twitter';

export default () => {
  const params = {
    consumerKey: process.env.TWITTER_CONSUMER_KEY,
    consumerSecret: process.env.TWITTER_CONSUMER_SECRET,
    callbackURL: process.env.TWITTER_CALLBACK_URL,
  };

  passport.use(new Strategy(params, (token, tokenSecret, profile, done) => {
    console.log(token, tokenSecret, profile);
    return done(null, profile);
  }));

  return passport;
};
