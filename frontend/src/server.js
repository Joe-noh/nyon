import dotenv from 'dotenv';
dotenv.load();

import express from 'express';
import compression from 'compression';
import cookieSession from 'cookie-session';
import passport from 'passport';
import * as sapper from '../__sapper__/server.js';

const app = express();

app.use(compression({ threshold: 0 }));
app.use(express.static('static'));

app.use(cookieSession({secret: process.env.SECRET_KEY_BASE}));
app.use(passport.initialize());
app.use(passport.session());

app.use(sapper.middleware());

app.listen(process.env.PORT, err => {
  if (err) console.log('error', err);
});
