using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatesModels
{
    public class LocationNodeDto
    {
        public long LocationNodeId { get; }
        public string LocationNodeCode { get; }

        public string LocationNodeName { get; }

        public LocationNodeDto(long id, string code, string name)
        {
            LocationNodeId = id;
            LocationNodeCode = code;
            LocationNodeName = name;
        }

    }
}
