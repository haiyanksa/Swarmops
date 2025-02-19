﻿using System;
using System.Text;
using Swarmops.Logic.Financial;
using Swarmops.Logic.Security;

namespace Swarmops.Frontend.Pages.Financial
{
    public partial class JsonPayableCosts : DataV5Base
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Access required is change access to financials

            this.PageAccessRequired = new Access(this.CurrentOrganization, AccessAspect.Financials, AccessType.Write);

            // Get all payable items

            Payouts payouts = Payouts.Construct(this.CurrentOrganization);

            // Format as JSON and return

            Response.ContentType = "application/json";
            string json = FormatAsJson(payouts);
            Response.Output.WriteLine(json);
            Response.End();
        }

        private string FormatAsJson(Payouts payouts)
        {
            StringBuilder result = new StringBuilder(16384);

            result.Append("{\"rows\":[");

            DateTime today = DateTime.Today;

            foreach (Payout payout in payouts)
            {
                result.Append("{");
                result.AppendFormat(
                    "\"itemId\":\"{0}\"," +
                    "\"due\":\"{1}\"," +
                    "\"recipient\":\"{2}\"," +
                    "\"bank\":\"{3}\"," +
                    "\"account\":\"{4}\"," +
                    "\"reference\":\"{5}\"," +
                    "\"amount\":\"{6:N2}\"," +
                    "\"action\":\"" +
                    "<img id=\\\"IconApproval{7}\\\" class=\\\"LocalIconApproval\\\" baseid=\\\"{0}\\\" height=\\\"16\\\" width=\\\"16\\\" />" +
                    "<img id=\\\"IconApproved{7}\\\" class=\\\"LocalIconApproved\\\" baseid=\\\"{0}\\\" height=\\\"16\\\" width=\\\"16\\\" />\"",
                    payout.ProtoIdentity,
                    (payout.ExpectedTransactionDate <= today? Resources.Global.Global_ASAP: payout.ExpectedTransactionDate.ToShortDateString()),
                    JsonSanitize(TryLocalize(payout.Recipient)),
                    JsonSanitize(payout.Bank),
                    JsonSanitize(payout.Account),
                    JsonSanitize(TryLocalize(payout.Reference)),
                    payout.AmountCents/100.0,
                    payout.ProtoIdentity.Replace("|", ""));
                result.Append("},");
            }

            result.Remove(result.Length - 1, 1); // remove last comma

            result.Append("]}");

            return result.ToString();
        }

    }

}