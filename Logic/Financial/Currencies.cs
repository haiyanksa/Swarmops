﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Swarmops.Basic.Types;
using Swarmops.Database;
using Swarmops.Logic.Support;

namespace Swarmops.Logic.Financial
{
    public class Currencies: PluralBase<Currencies,Currency,BasicCurrency>
    {
        public static Currencies GetAll()
        {
            return FromArray(SwarmDb.GetDatabaseForReading().GetCurrencies());
        }
    }
}
