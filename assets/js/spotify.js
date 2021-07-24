import * as Music from './music'

window.AppState = {
  spotifyToken: document.querySelector('#token').dataset.token,
  deviceId: null,
  singing: false,
  analysis: {}
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

  const playButton = document.querySelector('#play')
  const pauseButton = document.querySelector('#pause')

  playButton.style.display = 'block'
  pauseButton.style.display = 'none'

  document.querySelector('#play').addEventListener('click', async (event) => {
    const trackId = '3za3bQrlpdEwcT2C4t5Cag'

    window.AppState.analysis = await Music.analysis(trackId)

    await Music.play(trackId, window.AppState.deviceId)

    playButton.style.display = 'none'
    pauseButton.style.display = 'block'
  })

  document.querySelector('#pause').addEventListener('click', async () => {
    await Music.pause(window.AppState.deviceId)

    window.AppState.singing = false

    playButton.style.display = 'block'
    pauseButton.style.display = 'none'
  })
}
