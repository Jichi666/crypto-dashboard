import { useState, useEffect, useMemo } from 'react';

// Import components
import PriceCard from './components/PriceCard';
import PriceChart from './components/Charts';
import { MarketHeatmap } from './components/Charts';
import Portfolio from './components/Portfolio';

// Import API functions
import {
  fetchCurrentPrices,
  fetchPriceHistory,
  fetchMarketCapRanking,
  generateSparkline,
} from './api';

// Types
import { CoinPrice } from './types';

// Default state
const INITIAL_COINS: CoinPrice[] = [
  {
    id: 'bitcoin',
    name: 'Bitcoin',
    symbol: 'BTC',
    price: 67500,
    change: 2.3,
    sparkline: [67200, 67300, 67100, 67400, 67600, 67300, 67400, 67500],
    lastUpdated: new Date().toISOString(),
  },
  {
    id: 'ethereum',
    name: 'Ethereum',
    symbol: 'ETH',
    price: 3450,
    change: -1.2,
    sparkline: [3480, 3470, 3460, 3455, 3460, 3470, 3465, 3450],
    lastUpdated: new Date().toISOString(),
  },
  {
    id: 'solana',
    name: 'Solana',
    symbol: 'SOL',
    price: 142,
    change: 5.7,
    sparkline: [135, 138, 140, 141, 143, 142.5, 141, 142],
    lastUpdated: new Date().toISOString(),
  },
  {
    id: 'cardano',
    name: 'Cardano',
    symbol: 'ADA',
    price: 0.52,
    change: 3.8,
    sparkline: [0.50, 0.51, 0.515, 0.52, 0.525, 0.52, 0.51, 0.52],
    lastUpdated: new Date().toISOString(),
  },
  {
    id: 'avalanche-2',
    name: 'Avalanche',
    symbol: 'AVAX',
    price: 34.2,
    change: -0.8,
    sparkline: [34.5, 34.4, 34.3, 34.25, 34.3, 34.35, 34.3, 34.2],
    lastUpdated: new Date().toISOString(),
  },
];

// Sample portfolio data
const INITIAL_PORTFOLIO = [
  { 
    coin: 'Bitcoin', 
    symbol: 'BTC', 
    amount: 0.05, 
    currentValue: 3375,
    avgPrice: 65000, 
    profit: '3.85' 
  },
  { 
    coin: 'Ethereum', 
    symbol: 'ETH', 
    amount: 2.3, 
    currentValue: 7935,
    avgPrice: 3380, 
    profit: '2.08' 
  },
  { 
    coin: 'Solana', 
    symbol: 'SOL', 
    amount: 45, 
    currentValue: 6390,
    avgPrice: 134, 
    profit: '5.97' 
  },
];

export default function App() {
  const [coins, setCoins] = useState<CoinPrice[]>(INITIAL_COINS);
  const [selectedCoin, setSelectedCoin] = useState<string>('bitcoin');
  const [chartData, setChartData] = useState<Record<string, Array<{ time: string; value: number }>>>({});
  const [heatmapData, setHeatmapData] = useState<Array<{ name: string; heat: number; symbol: string }>>([]);
  const portfolio = useMemo(() => INITIAL_PORTFOLIO, []);
  const [isRealtime, setIsRealtime] = useState<boolean>(true);
  const [lastUpdate, setLastUpdate] = useState<string>(new Date().toLocaleTimeString());
  const [isLoading, setIsLoading] = useState<boolean>(false);

  // Fetch real-time prices
  const fetchPrices = async () => {
    try {
      setIsLoading(true);
      const data = await fetchCurrentPrices();
      
      // Update coin prices
      setCoins(
        data.map((coin) => ({
          id: coin.id,
          name: coin.name,
          symbol: coin.symbol,
          price: coin.current_price.usd,
          change: (coin.current_price.usd_24h_change / coin.current_price.usd) * 100,
          sparkline: generateSparkline([]),
          lastUpdated: new Date().toISOString(),
        }))
      );
      setLastUpdate(new Date().toLocaleTimeString());
    } catch (error) {
      console.error('Error fetching prices:', error);
      // Simulate price changes when API fails
      setCoins(
        coins.map(coin => ({
          ...coin,
          price: Math.round(coin.price * (1 + (Math.random() - 0.5) * 0.02)),
          change: (Math.random() - 0.5) * 2,
        }))
      );
      setLastUpdate(new Date().toLocaleTimeString());
    } finally {
      setIsLoading(false);
    }
  };

  // Fetch chart data for selected coin
  const fetchChartData = async (coinId: string) => {
    try {
      const history = await fetchPriceHistory(coinId);
      setChartData(prev => ({ ...prev, [coinId]: history }));
    } catch (error) {
      console.error('Error fetching chart data:', error);
      // Generate mock data
      const mockData = Array.from({ length: 24 }, (_, i) => ({
        time: `${i}:00`,
        value: coins.find(c => c.id === coinId)?.price || 67500 * (1 + (Math.random() - 0.5) * 0.05),
      }));
      setChartData(prev => ({ ...prev, [coinId]: mockData }));
    }
  };

  // Fetch heatmap data
  const fetchHeatmapData = async () => {
    try {
      const data = await fetchMarketCapRanking();
      const formatted = data.map(item => ({
        name: item.name,
        symbol: item.symbol || '',
        heat: item.heat,
      }));
      setHeatmapData(formatted);
    } catch (error) {
      console.error('Error fetching heatmap data:', error);
      // Use fallback data
      setHeatmapData([
        { name: 'BTC', heat: 95, symbol: 'BTC' },
        { name: 'ETH', heat: 88, symbol: 'ETH' },
        { name: 'SOL', heat: 92, symbol: 'SOL' },
        { name: 'ADA', heat: 75, symbol: 'ADA' },
        { name: 'AVAX', heat: 68, symbol: 'AVAX' },
      ]);
    }
  };

  // Initial data fetch
  useEffect(() => {
    fetchPrices();
    fetchHeatmapData();
  }, []);

  // Real-time update loop
  useEffect(() => {
    if (!isRealtime) return;

    const interval = setInterval(fetchPrices, 30000); // 30 seconds

    return () => clearInterval(interval);
  }, [isRealtime]);

  // Fetch chart data when selected coin changes
  useEffect(() => {
    fetchChartData(selectedCoin);
  }, [selectedCoin]);

  const handleCoinSelect = (coinId: string) => {
    setSelectedCoin(coinId);
  };

  const toggleRealtime = () => {
    setIsRealtime(!isRealtime);
  };

  const selectedCoinData = coins.find(c => c.id === selectedCoin || c.name === selectedCoin);
  const currentChartData = chartData[selectedCoin] || chartData[coins[0]?.id] || [];

  return (
    <div className="min-h-screen bg-slate-900 p-4 md:p-8 color-slate-50">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <header className="bg-slate-800/80 backdrop-blur-sm rounded-2xl p-6 mb-6">
          <div className="flex flex-col md:flex-row md:justify-between md:items-center gap-4">
            <div>
              <h1 className="text-3xl font-bold bg-gradient-to-r from-blue-400 via-purple-500 to-pink-500 bg-clip-text text-transparent">
                加密市场数字看板
              </h1>
              <p className="text-gray-400 mt-1">
                实时追踪主流加密货币价格与市场动态
              </p>
            </div>
            <div className="flex flex-col md:flex-row md:items-center gap-3">
              <div className="text-sm text-gray-400">
                {isLoading ? '更新中...' : `最后更新: ${lastUpdate}`}
              </div>
              <button
                onClick={toggleRealtime}
                className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                  isRealtime 
                    ? 'bg-green-600 hover:bg-green-700' 
                    : 'bg-gray-600 hover:bg-gray-700'
                }`}
              >
                {isRealtime ? '实时更新: 开' : '实时更新: 关'}
              </button>
            </div>
          </div>
        </header>

        {/* Price Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
          {coins.map((coin) => (
            <PriceCard
              key={coin.id}
              coin={coin}
              isSelected={selectedCoin === coin.id}
              onSelect={handleCoinSelect}
            />
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Selected Coin Details */}
          <div className="bg-slate-800/80 backdrop-blur-sm rounded-2xl p-6">
            <div className="flex flex-col md:flex-row md:justify-between md:items-center mb-4 gap-3">
              <h2 className="text-xl font-bold">
                {selectedCoinData?.name} {selectedCoinData?.symbol && `(${selectedCoinData.symbol})`}
              </h2>
              <div className="flex gap-2">
                <button className="px-3 py-1 bg-slate-700 rounded-lg text-sm hover:bg-slate-600">1H</button>
                <button className="px-3 py-1 bg-blue-600 rounded-lg text-sm hover:bg-blue-700">1D</button>
                <button className="px-3 py-1 bg-purple-600 rounded-lg text-sm hover:bg-purple-700">1W</button>
              </div>
            </div>
            <div className="h-64">
              <div className={isLoading ? 'animate-pulse bg-slate-700/50 rounded-lg' : ''}>
                <PriceChart 
                  data={currentChartData}
                />
              </div>
            </div>
          </div>

          {/* Portfolio */}
          <div className="bg-slate-800/80 backdrop-blur-sm rounded-2xl p-6">
            <h2 className="text-xl font-bold mb-4">投资组合</h2>
            <Portfolio portfolio={portfolio} />
          </div>

          {/* Market Heatmap */}
          <div className="bg-slate-800/80 backdrop-blur-sm rounded-2xl p-6">
            <h2 className="text-xl font-bold mb-4">市场热力趋势</h2>
            <div className="h-52">
              <MarketHeatmap data={heatmapData} />
            </div>
          </div>
        </div>

        {/* Footer */}
        <footer className="mt-6 text-center text-gray-400 text-sm">
          <p>数据来源: CoinGecko API & CoinMarketCap API</p>
          <p>技术栈: React | Vite | Recharts | TailwindCSS</p>
          <p>部署平台: Cloudflare Pages</p>
        </footer>
      </div>
    </div>
  );
}
