'use client';

import { showConnect } from '@stacks/connect';
import { userSession } from '@/lib/userSession';

export default function ConnectWallet() {
  const onConnect = () => {
    showConnect({
      appDetails: {
        name: 'My Stacks App',
        icon: 'https://placehold.co/600x400',
      },
      onFinish: () => {
        window.location.reload();
      },
      userSession,
    });
  };

  if (userSession.isUserSignedIn()) {
    return (
      <button
        onClick={() => {
          userSession.signUserOut();
          window.location.reload();
        }}
        className="px-4 py-2 bg-red-600 text-white rounded"
      >
        Sign Out
      </button>
    );
  }

  return (
    <button
      onClick={onConnect}
      className="px-4 py-2 bg-indigo-600 text-white rounded"
    >
      Connect Wallet
    </button>
  );
}
