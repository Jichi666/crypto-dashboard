import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
} from 'recharts';

interface ChartDataPoint {
  time: string;
  value: number;
}

interface PriceChartProps {
  data: ChartDataPoint[];
}

export default function PriceChart({ data }: PriceChartProps) {
  return (
    <ResponsiveContainer width="100%" height={400}>
      <AreaChart data={data}>
        <defs>
          <linearGradient id="colorGradient" x1="0" y1="0" x2="0" y2="1">
            <stop offset="5%" stop-color="#3b82f6" stopOpacity={0.3} />
            <stop offset="95%" stop-color="#3b82f6" stopOpacity={0} />
          </linearGradient>
        </defs>
        <CartesianGrid strokeDasharray="3 3" stroke="#334155" />
        <XAxis 
          dataKey="time" 
          stroke="#94a3b8" 
          fontSize={12}
        />
        <YAxis 
          fontSize={12}
          stroke="#94a3b8"
        />
        <Tooltip 
          contentStyle={{ backgroundColor: '#1e293b', border: 'none', borderRadius: '8px' }}
          itemStyle={{ color: '#e2e8f0' }}
        />
        <Area
          type="monotone"
          dataKey="value"
          stroke="#3b82f6"
          fill="url(#colorGradient)"
          animationDuration={200}
        />
      </AreaChart>
    </ResponsiveContainer>
  );
}

// Market Heatmap Chart
interface HeatmapItem {
  name: string;
  symbol: string;
  heat: number;
}

interface HeatmapProps {
  data: HeatmapItem[];
}

export function MarketHeatmap({ data }: HeatmapProps) {
  return (
    <ResponsiveContainer width="100%" height={250}>
      <BarChart data={data}>
        <XAxis 
          dataKey="name" 
          tick={{ fill: '#94a3b8', fontSize: 12 }}
        />
        <YAxis
          tick={{ fill: '#94a3b8', fontSize: 12 }}
        />
        <CartesianGrid strokeDasharray="3 3" stroke="#334155" />
        <Tooltip 
          contentStyle={{ backgroundColor: '#1e293b', border: 'none', borderRadius: '8px' }}
          itemStyle={{ color: '#e2e8f0' }}
        />
        <Bar
          dataKey="heat"
          fill="#8b5cf6"
          radius={[8, 4, 2, 0]}
        />
      </BarChart>
    </ResponsiveContainer>
  );
}
