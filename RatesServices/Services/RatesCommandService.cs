using RatesModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace RatesServices.Services
{
    public class RatesCommandService : IRatesCommandService
    {
        public async Task SendRate(RateListItemDto rate)
        {
            await Task.Yield();
        }
    }
}
