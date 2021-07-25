function headers() {
  return {
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    'Content-Type': 'application/json',
  }
}

function params({ method, body }) {
  if (body) {
    return { method, headers: headers(), body: JSON.stringify(body) }
  } else {
    return { method, headers: headers() }
  }
}

export async function request({ method, path, body }) {
  const res = await fetch(path, params({ method, body }))

  if (res.ok) {
    const json = await res.json()

    if (Object.keys(json).length === 0) {
      // これはサボり
      throw new Error('Something went wrong')
    } else {
      return json
    }
  }
}

export function analysis(trackId) {
  return request({ method: 'POST', path: `/music/analysis/${trackId}` })
}

export function play(trackId, deviceId) {
  return request({ method: 'PUT', path: `/music/play/${trackId}`, body: { device_id: deviceId }})
}

export function pause(deviceId) {
  return request({ method: 'PUT', path: '/music/pause', body: { device_id: deviceId }})
}
