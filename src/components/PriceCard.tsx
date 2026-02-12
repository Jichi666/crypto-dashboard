interface PriceCardProps {
  coin: {
    id: string;
    name: string;
    symbol: string;
    price: number;
    change: number;
    sparkline: number[];
  };
  isSelected: boolean;
  onSelect: (coinId: string) => void;
}

export default function PriceCard({ coin, isSelected, onSelect }: PriceCardProps) {
  const isPositive = coin.change >= 0;
  const gradientId = `gradient-${coin.id}`;

  return (
    <div
      onClick={() => onSelect(coin.id)}
      className={`
        relative bg-slate-800/80 backdrop-blur-sm rounded-2xl p-5
        cursor-pointer transition-all duration-200
        hover:bg-slate-700/80 
        ${isSelected ? 'ring-2 ring-blue-500 ring-offset-2 ring-offset-slate-900' : ''}
      `}
    >
      {/* Header */}
      <div className="flex justify-between items-start mb-3">
        <div>
          <h3 className="text-lg font-bold text-white">{coin.name}</h3>
          <span className="text-gray-400 text-sm">{coin.symbol}</span>
        </div>
        <span
          className={`text-sm font-bold ${
            isPositive ? 'text-green-400' : 'text-red-400'
          }`}
        >
          {isPositive ? '+' : ''}{coin.change.toFixed(2)}%
        </span>
      </div>

      {/* Price */}
      <div className="text-3xl font-bold text-white mb-2">
        {coin.price < 1 
          ? `$${coin.price.toFixed(4)}` 
          : `$${coin.price.toLocaleString()}`
        }
      </div>

      {/* Sparkline */}
      <div className="h-16">
        <div className="h-full w-full bg-slate-700 rounded-lg overflow-hidden">
          <svg
            width="100%"
            height="100%"
            viewBox="0 0 200 64"
            preserveAspectRatio="none"
          >
            <defs>
              <linearGradient id={gradientId} x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" style={{ stopColor: isPositive ? '#10b981' : '#ef4444', stopOpacity: 0.5 }} />
                <stop offset="100%" style={{ stopColor: isPositive ? '#10b981' : '#ef4444', stopOpacity: 0.1 }} />
              </linearGradient>
            </defs>
            {coin.sparkline.map((value, index) => {
              const x = (index / (coin.sparkline.length - 1)) * 200;
              const height = ((value - Math.min(...coin.sparkline)) / (Math.max(...coin.sparkline) - Math.min(...coin.sparkline))) * 64;
              const y = 64 - height;

              return (
                <rect
                  key={index}
                  x={x}
                  y={y}
                  width={200 / coin.sparkline.length - 1}
                  height={height}
                  fill={`url(#${gradientId})`}
                />
              );
            })}
          </svg>
        </div>
      </div>
    </div>
  );
}
