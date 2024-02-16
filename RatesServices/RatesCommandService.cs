using RatesModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace RatesServices
{
    public class RatesCommandService : IRatesCommandService
    {
        public async Task SaveRate(RateListItemDto rate)
        {
            await Task.Yield();
        }
    }
}
