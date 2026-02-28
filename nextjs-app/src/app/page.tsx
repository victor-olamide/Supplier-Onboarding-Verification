import ConnectWallet from '@/components/ConnectWallet';

export default function Home() {
  return (
    <main className="flex flex-col items-center justify-center min-h-screen">
      <h1 className="text-4xl font-bold mb-4">Welcome to Stacks Next.js App</h1>
      <p className="text-lg mb-8 text-gray-600">Initialize your journey with Stacks and Next.js</p>
      <ConnectWallet />
    </main>
  )
}
