import React from 'react'
import ReactDOM from 'react-dom/client'
import { HashRouter } from 'react-router-dom'
import { BrewStoreProvider } from './context/BrewStore'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <HashRouter>
      <BrewStoreProvider>
        <App />
      </BrewStoreProvider>
    </HashRouter>
  </React.StrictMode>,
)
