import dotenv from 'dotenv';
dotenv.load();

import express from 'express';
import compression from 'compression';
import cookieSession from 'cookie-session';
import passport from 'passport';
import requireLogin from './middlewares/require-login';
import sapperStore from './middlewares/sapper-store';

const app = express();

app.use(compression({ threshold: 0 }));
app.use(express.static('static'));

app.use(cookieSession({
  secret: process.env.SECRET_KEY_BASE,
  maxAge: 90 * 24 * 60 * 60 * 1000,
}));
app.use(passport.initialize());
app.use(passport.session());

app.use(requireLogin());
app.use(sapperStore());

app.listen(process.env.PORT, err => {
  if (err) console.log('error', err);
});
