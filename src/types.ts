// Types for crypto dashboard
export interface CoinPrice {
  id: string;
  name: string;
  symbol: string;
  price: number;
  change: number;
  sparkline: number[];
  lastUpdated: string;
}

export interface ChartDataPoint {
  time: string;
  value: number;
}

interface PortfolioItem {
  coin: string;
  symbol: string;
  amount: number;
  currentValue: number;
  avgPrice: number;
  profit: string;
}

interface MarketHeatmapItem {
  name: string;
  heat: number;
  symbol: string;
}

export interface DashboardState {
  coins: CoinPrice[];
  selectedCoin: string;
  isRealtime: boolean;
  portfolio: PortfolioItem[];
  chartData: Record<string, ChartDataPoint[]>;
  heatmapData: MarketHeatmapItem[];
  lastUpdate: string;
}
