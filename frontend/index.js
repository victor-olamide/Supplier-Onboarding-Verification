// Basic React app
import React from 'react';
import ReactDOM from 'react-dom';
import { AppConfig, UserSession } from '@stacks/connect';

const appConfig = new AppConfig(['store_write', 'publish_data']);
const userSession = new UserSession({ appConfig });

function App() {
  return (
    <div>
      <h2>Stacks dApp</h2>
      <button onClick={() => userSession.signUserOut()}>Sign Out</button>
    </div>
  );
}

ReactDOM.render(<App />, document.getElementById('app'));