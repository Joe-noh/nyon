import fetch from 'node-fetch';

export function get(path) {
  return fetch(`${process.env.API_BASE_URL}${path}`);
};

export function post(path, params) {
  return fetch(`${process.env.API_BASE_URL}${path}`, {
    method: 'POST',
    body: JSON.stringify(params),
    headers: { 'Content-Type': 'application/json' }
  });
};
