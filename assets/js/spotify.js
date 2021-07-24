window.AppState = {
  spotifyToken: document.querySelector('#token').dataset.token,
  deviceId: null,
  singing: false,
  analysis: {}
}

function headers() {
  return {
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    'Content-Type': 'application/json',
  }
}

function sing() {
  if (window.AppState.singing) {
    const now = new Date() - window.AppState.startedAt

    processBeats(now)
    processBars(now)

    setTimeout(sing, 10)
  }
}

function processBeats(timestamp) {
  const beats = window.AppState.analysis.beats
  const index = beats.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const beat = beats[index]
    const circle = document.querySelector('#circle_beat')
    circle.animate([
      { transform: `scaleX(${1 + beat.confidence})` },
      { transform: 'scale(1.0)'}
    ], 1000 * beat.duration)

    window.AppState.analysis.beats.splice(index, 1)
  }
}

function processBars(timestamp) {
  const bars = window.AppState.analysis.bars
  const index = bars.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const bar = bars[index]
    const circle = document.querySelector('#circle_bar')
    circle.animate([
      { transform: `scaleY(${1 + bar.confidence})` },
      { transform: 'scale(1.0)'}
    ], 1000 * bar.duration)

    window.AppState.analysis.bars.splice(index, 1)
  }
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
    player.addListener('player_state_changed', (state) => {
      if (state) {
        if (state.paused === false && !window.AppState.singing) {
          window.AppState.singing = true
          window.AppState.startedAt = new Date() - state.position

          sing()
        }
      }
    })

    // Ready
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id)

      player.setVolume(0.2)

      window.AppState.deviceId = device_id
    })

    // Not Ready
    player.addListener('not_ready', ({ device_id }) => {
      console.log('Device ID has gone offline', device_id)
    })

    // Connect to the player!
    player.connect()
  }

  const songId = '3za3bQrlpdEwcT2C4t5Cag'

  document.querySelector('#play').addEventListener('click', async () => {
    const analysis = await fetch(`/music/analysis/${songId}`, {
      method: 'POST',
      headers: headers()
    }).then(res => res.json())

    window.AppState.analysis = analysis

    await fetch(`/music/play/${songId}`, {
      method: 'PUT',
      headers: headers(),
      body: JSON.stringify({ device_id: window.AppState.deviceId }),
    })
  })

  document.querySelector('#pause').addEventListener('click', async () => {
    await fetch('/music/pause', {
      method: 'PUT',
      headers: headers(),
      body: JSON.stringify({ device_id: window.AppState.deviceId }),
    })

    window.AppState.singing = false
  })
}
