import * as sapper from '__sapper__/server.js';
import { Store } from 'svelte/store.js';

export default () => sapper.middleware({
  store: req => new Store({
    apiBaseUrl: process.env.API_BASE_URL,
  })
});
