﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using Swarmops.Logic.Financial;
using Swarmops.Logic.Structure;
using Swarmops.Logic.Swarm;

namespace Swarmops.Frontend.Pages.v5.Admin
{
    public partial class CreateOrganization : PageV5Base
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.PageTitle = Resources.Pages.Admin.CreateOrganization_PageTitle;
            this.PageIcon = "iconshock-organization-add";
            this.InfoBoxLiteral = Resources.Pages.Admin.CreateOrganization_Info;

            if (!Page.IsPostBack)
            {
                Localize();
            }
        }


        private readonly string[] _personLabels =
        {
            "Activist", "Person", "Sailor", "Regular", "Ambassador", "Salesperson",
            "Member", "Operative", "Employee", "Customer", "Conscript", "Resident", "Citizen", "Agent"
        };


        private void Localize()
        {
            this.LabelOrganizationName.Text = Resources.Pages.Admin.CreateOrganization_NewOrgName;
            this.LabelActivistLabel.Text = Resources.Pages.Admin.CreateOrganization_ActivistTitle;
            this.LabelCreateAs.Text = Resources.Pages.Admin.CreateOrganization_CreateNewOrgAs;
            this.LabelNativeCurrency.Text = Resources.Pages.Admin.CreateOrganization_NewOrgCurrency;
            this.LabelPersonLabel.Text = Resources.Pages.Admin.CreateOrganization_RegularTitle;

            this.ButtonCreate.Text = Resources.Global.Global_Create;

            this.DropPersonLabel.Items.Clear();
            this.DropActivistLabel.Items.Clear();
            this.DropCurrencies.Items.Clear();
            this.DropCreateChild.Items.Clear();
            this.DropPersonLabel.Items.Add(new ListItem(Resources.Global.Global_SelectOne, "0"));
            this.DropActivistLabel.Items.Add(new ListItem(Resources.Global.Global_SelectOne, "0"));
            this.DropCurrencies.Items.Add(new ListItem(Resources.Global.Global_SelectOne, "0"));
            this.DropCreateChild.Items.Add(new ListItem(Resources.Global.Global_SelectOne, "0"));


            this.DropCreateChild.Items.Add(new ListItem(Resources.Pages.Admin.CreateOrganization_AsRoot, "Root"));
            this.DropCreateChild.Items.Add(new ListItem(String.Format(Resources.Pages.Admin.CreateOrganization_ChildOfX, CurrentOrganization.Name), "Child"));

            List<string> localizedPersonLabels = new List<string>();

            foreach (string personLabel in _personLabels)
            {
                string localizedPersonLabel =
                    Resources.Global.ResourceManager.GetString("Title_" + personLabel + "_Plural");

                localizedPersonLabels.Add(localizedPersonLabel + "|" + personLabel);
            }

            localizedPersonLabels.Sort();

            foreach (string localizedPersonLabel in localizedPersonLabels)
            {
                string[] parts = localizedPersonLabel.Split('|');
                this.DropPersonLabel.Items.Add(new ListItem(parts[0], parts[1]));
                this.DropActivistLabel.Items.Add(new ListItem(parts[0], parts[1]));
            }

            Currencies currencies = Currencies.GetAll();

            List<string> currencyStrings = new List<string>();

            foreach (Currency currency in currencies)
            {
                currencyStrings.Add(String.Format("{0} {1}|{0}", currency.Code, currency.Name));
            }

            currencyStrings.Sort();

            foreach (string currencyString in currencyStrings)
            {
                string[] parts = currencyString.Split('|');

                this.DropCurrencies.Items.Add(new ListItem(parts[0], parts[1]));
            }
        }


        protected void ButtonCreate_Click(object sender, EventArgs e)
        {
            string activistLabel = this.DropActivistLabel.SelectedValue;
            string peopleLabel = this.DropPersonLabel.SelectedValue;
            string asRoot = this.DropCreateChild.SelectedValue;
            string currencyCode = this.DropCurrencies.SelectedValue;
            string newOrgName = this.TextOrganizationName.Text;

            if (string.IsNullOrEmpty(newOrgName))
            {
                throw new ArgumentException("Organization name can't be empty");
            }

            if (activistLabel == "0" || peopleLabel == "0" || asRoot == "0" || currencyCode == "0")
            {
                throw new ArgumentException("Necessary argument was not supplied (did client-side validation run?)");
            }

            Currency newOrgCurrency = Currency.FromCode(currencyCode);
            Organization parent = CurrentOrganization;

            if (asRoot == "Root")
            {
                parent = null;
            }

            Organization newOrganization = Organization.Create(parent == null ? 0 : parent.Identity, newOrgName,
                newOrgName, newOrgName, string.Empty, newOrgName, Geography.RootIdentity, true, true, 0);
            newOrganization.EnableEconomy(newOrgCurrency);

            newOrganization.RegularLabel = peopleLabel;
            newOrganization.ActivistLabel = activistLabel;

            Membership.Create(CurrentUser, newOrganization, DateTime.UtcNow.AddYears(2));

            string successMessage = String.Format(Resources.Pages.Admin.CreateOrganization_Success, Resources.Global.ResourceManager.GetString("Title_" + peopleLabel + "_Ship"));

            // Create org here

            Response.AppendCookie(new HttpCookie("DashboardMessage", HttpUtility.UrlEncode(successMessage)));

            // Redirect to dashboard

            Response.Redirect("/", true);
        }

    }
}