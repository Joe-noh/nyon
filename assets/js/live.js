// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/live.scss'
import './shoelace'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'
import { Socket } from 'phoenix'
import NProgress from 'nprogress'
import { LiveSocket } from 'phoenix_live_view'

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
const hooks = {
  Cell: {
    mounted() {
      this.el.addEventListener('contextmenu', (e) => {
        e.preventDefault()

        const x = this.el.getAttribute('phx-value-x')
        const y = this.el.getAttribute('phx-value-y')

        this.pushEventTo('#board', 'flag-cell', { x, y })
      })
    }
  }
}

const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken }, hooks })

// Show progress bar on live navigation and form submits
window.addEventListener('phx:page-loading-start', info => NProgress.start())
window.addEventListener('phx:page-loading-stop', info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
