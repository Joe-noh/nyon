window.AppState = {
  spotifyToken: document.querySelector('#token').dataset.token,
  deviceId: null,
}

export function setupPlayer() {
  window.onSpotifyWebPlaybackSDKReady = () => {
    const player = new Spotify.Player({
      name: 'Web Player',
      getOAuthToken: (cb) => {
        if (window.AppState.spotifyToken) {
          cb(window.AppState.spotifyToken)
        }
      }
    })

    // Error handling
    player.addListener('initialization_error', ({ message }) => { console.error(message) })
    player.addListener('authentication_error', ({ message }) => { console.error(message) })
    player.addListener('account_error', ({ message }) => { console.error(message) })
    player.addListener('playback_error', ({ message }) => { console.error(message) })

    // Playback status updates
    player.addListener('player_state_changed', state => { console.log(state) })

    // Ready
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id)

      window.AppState.deviceId = device_id
    })

    // Not Ready
    player.addListener('not_ready', ({ device_id }) => {
      console.log('Device ID has gone offline', device_id)
    })

    // Connect to the player!
    player.connect()
  }

  document.querySelector('#play').addEventListener('click', async () => {
    await fetch('/music/play', {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content"),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ device_id: window.AppState.deviceId }),
    })
  })

  document.querySelector('#pause').addEventListener('click', async () => {
    await fetch('/music/pause', {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content"),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ device_id: window.AppState.deviceId }),
    })
  })
}
