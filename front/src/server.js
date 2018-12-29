import dotenv from 'dotenv';
dotenv.load();

import express from 'express';
import compression from 'compression';
import sapperStore from 'src/middlewares/sapper-store';

const app = express();

app.use(compression({ threshold: 0 }));
app.use(express.static('static'));
app.use(sapperStore());

app.listen(process.env.PORT, err => {
  if (err) console.log('error', err);
});
