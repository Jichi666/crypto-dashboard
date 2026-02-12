interface PortfolioItem {
  coin: string;
  symbol: string;
  amount: number;
  currentValue: number;
  avgPrice: number;
  profit: string;
}

interface PortfolioProps {
  portfolio: PortfolioItem[];
}

export default function Portfolio({ portfolio }: PortfolioProps) {
  const totalValue = portfolio.reduce((sum, item) => sum + item.currentValue, 0);

  return (
    <div className="space-y-4">
      {/* Portfolio Table */}
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="text-left text-gray-400 border-b border-gray-700">
              <th className="pb-3 pr-4">币种</th>
              <th className="pb-3 pr-4">符号</th>
              <th className="pb-3 pr-4">持有量</th>
              <th className="pb-3 pr-4">当前价值</th>
              <th className="pb-3 pr-4">盈亏(%)</th>
            </tr>
          </thead>
          <tbody>
            {portfolio.map((item, index) => {
              const isPositive = parseFloat(item.profit) >= 0;
              return (
                <tr key={index} className={`border-b border-gray-700 last:border-0 ${isPositive ? '' : 'bg-red-500/10'}`}>
                  <td className="py-3 pr-4 font-medium">{item.coin}</td>
                  <td className="py-3 pr-4 text-gray-400">{item.symbol}</td>
                  <td className="py-3 pr-4">{item.amount}</td>
                  <td className="py-3 pr-4">
                    {item.currentValue < 1 
                      ? `$${item.currentValue.toFixed(4)}` 
                      : `$${item.currentValue.toLocaleString()}`
                    }
                  </td>
                  <td className={`py-3 pr-4 font-bold ${isPositive ? 'text-green-400' : 'text-red-400'}`}>
                    {isPositive ? '+' : ''}{item.profit}%
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Total Value Summary */}
      <div className="bg-slate-800/50 rounded-xl p-4">
        <div className="flex justify-between items-center">
          <span className="text-lg font-bold">总价值</span>
          <span className="text-3xl font-bold text-green-400">
            ${totalValue.toLocaleString()}
          </span>
        </div>
      </div>
    </div>
  );
}
