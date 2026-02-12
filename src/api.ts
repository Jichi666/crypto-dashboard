// API service for fetching crypto data
const COINGECKO_API = 'https://api.coingecko.com/api/v3';

export interface CoinGeckoPriceData {
  id: string;
  symbol: string;
  name: string;
  current_price: {
    usd: number;
    usd_24h_change: number;
    usd_24h_volume: number;
  };
}

export const MAIN_COINS = [
  'bitcoin',
  'ethereum',
  'solana',
  'cardano',
  'avalanche-2',
] as const;

// Fetch current prices for main coins
export async function fetchCurrentPrices(): Promise<CoinGeckoPriceData[]> {
  const ids = MAIN_COINS.join(',');
  const response = await fetch(
    `${COINGECKO_API}/coins/markets?vs_currency=usd&ids=${ids}`
  );
  
  if (!response.ok) {
    throw new Error('Failed to fetch prices');
  }
  
  return response.json();
}

// Fetch 24H price history for a coin
export async function fetchPriceHistory(coinId: string): Promise<Array<{ time: string; value: number }>> {
  const response = await fetch(
    `${COINGECKO_API}/coins/${coinId}/market_chart?vs_currency=usd&days=1`
  );
  
  if (!response.ok) {
    throw new Error('Failed to fetch history');
  }
  
  const data = await response.json();
  return data.prices.map((item: { price: number; time: number }) => ({
    time: new Date(item.time * 1000).toLocaleTimeString('en-US', { hour12: true, hour: 'numeric', minute: '2-digit' }),
    value: item.price,
  }));
}

// Generate sparkline data (last 24 data points)
export function generateSparkline(prices: number[]): number[] {
  if (prices.length === 0) return [];
  if (prices.length < 24) {
    while (prices.length < 24) {
      const last = prices[prices.length - 1] || prices[0];
      prices = [...prices, last];
    }
  }
  return prices.slice(-24);
}

// Get market cap ranking (simplified)
export async function fetchMarketCapRanking(): Promise<Array<{ name: string; heat: number; symbol?: string }>> {
  return [
    { name: 'BTC', heat: 95, symbol: 'BTC' },
    { name: 'ETH', heat: 88, symbol: 'ETH' },
    { name: 'SOL', heat: 92, symbol: 'SOL' },
    { name: 'ADA', heat: 75, symbol: 'ADA' },
    { name: 'AVAX', heat: 68, symbol: 'AVAX' },
  ];
}
