using Swarmops.Basic.Enums;
using Swarmops.Database;
using Swarmops.Logic.Structure;

namespace Swarmops.Logic.Financial
{
    /// <summary>
    /// Accessors for special accounts for a particular organization.
    /// </summary>
    public class OrganizationFinancialAccounts
    {
        public static void PrimePiratpartietSE()  // One-off. Once this has been run once, delete it.
        {
            /* -- this was a one-time one-off
            if (SwarmDb.GetDatabaseForReading().GetOrganizationFinancialAccountId(1, OrganizationFinancialAccountType.AssetsBankAccountMain) != 0)
            {
                return;
            }

            if (!Organization.PPSE.Name.StartsWith("Piratpartiet"))
            {
                return; // not PP installation
            }

            OrganizationFinancialAccounts organizationAccounts = new OrganizationFinancialAccounts(1);

            // HACK HACK HACK

            organizationAccounts[OrganizationFinancialAccountType.CostsBankFees] = FinancialAccount.FromIdentity(26); //
            organizationAccounts[OrganizationFinancialAccountType.AssetsBankAccountMain] = FinancialAccount.FromIdentity(1); //
            organizationAccounts[OrganizationFinancialAccountType.IncomeDonations] = FinancialAccount.FromIdentity(4); //
            organizationAccounts[OrganizationFinancialAccountType.IncomeGeneral] = FinancialAccount.FromIdentity(131); // 
            organizationAccounts[OrganizationFinancialAccountType.IncomeSales] = FinancialAccount.FromIdentity(5); //
            organizationAccounts[OrganizationFinancialAccountType.CostsInfrastructure] = FinancialAccount.FromIdentity(21); //
            organizationAccounts[OrganizationFinancialAccountType.CostsLocalDonationTransfers] = FinancialAccount.FromIdentity(88); //
            organizationAccounts[OrganizationFinancialAccountType.CostsAllocatedFunds] = FinancialAccount.FromIdentity(124); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsExpenseClaims] = FinancialAccount.FromIdentity(3); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsSalary] = FinancialAccount.FromIdentity(25); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsTax] = FinancialAccount.FromIdentity(86); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsInboundInvoices] = FinancialAccount.FromIdentity(25); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsOther] = FinancialAccount.FromIdentity(25); //
            organizationAccounts[OrganizationFinancialAccountType.AssetsOutboundInvoices] = FinancialAccount.FromIdentity(28); // 
            organizationAccounts[OrganizationFinancialAccountType.DebtsEquity] = FinancialAccount.FromIdentity(96); //
            organizationAccounts[OrganizationFinancialAccountType.AssetsPaypal] = FinancialAccount.FromIdentity(2); //
            organizationAccounts[OrganizationFinancialAccountType.CostsYearlyResult] = FinancialAccount.FromIdentity(97); //
            organizationAccounts[OrganizationFinancialAccountType.AssetsOutstandingCashAdvances] = FinancialAccount.FromIdentity(156); //
            organizationAccounts[OrganizationFinancialAccountType.AssetsVat] = FinancialAccount.FromIdentity(86); //
            organizationAccounts[OrganizationFinancialAccountType.DebtsVat] = FinancialAccount.FromIdentity(86); //

            FinancialAccount.FromIdentity(80).IsConferenceParent = true;
            FinancialAccount.FromIdentity(27).IsConferenceParent = true;

            Organization.PPSE.IsEconomyEnabled = true; // Kill this function in base, too
             */
        }

        public OrganizationFinancialAccounts (int organizationId)
        {
            this._organizationId = organizationId;
        }

        public OrganizationFinancialAccounts (Organization organization)
            : this (organization.Identity)
        {
            
        }

        private readonly int _organizationId;


        public FinancialAccount this[OrganizationFinancialAccountType accountType]
        {
            get
            {
                int accountId = SwarmDb.GetDatabaseForReading().GetOrganizationFinancialAccountId(_organizationId,
                                                                                                  accountType);

                if (accountId == 0)
                {
                    return null; // not set
                }

                return FinancialAccount.FromIdentity(accountId);
            }
            set
            {
                SwarmDb.GetDatabaseForWriting().SetOrganizationFinancialAccountId(_organizationId, accountType,
                                                                                 value.Identity);
            }
        }


        // -- SHORTCUTS TO GET ACCOUNTS, FOR CODE READABILITY --

        public FinancialAccount AssetsBankAccountMain
        {
            get { return this[OrganizationFinancialAccountType.AssetsBankAccountMain]; }
        }

        public FinancialAccount AssetsOutboundInvoices
        {
            get { return this[OrganizationFinancialAccountType.AssetsOutboundInvoices]; }
        }

        public FinancialAccount AssetsOutstandingCashAdvances
        {
            get { return this[OrganizationFinancialAccountType.AssetsOutstandingCashAdvances]; }
        }

        public FinancialAccount AssetsPaypal
        {
            get { return this[OrganizationFinancialAccountType.AssetsPaypal]; }
        }

        public FinancialAccount AssetsVat
        {
            get { return this[OrganizationFinancialAccountType.AssetsVat]; }
        }

        public FinancialAccount CostsBankFees
        {
            get { return this[OrganizationFinancialAccountType.CostsBankFees]; }
        }

        public FinancialAccount CostsAllocatedFunds
        {
            get { return this[OrganizationFinancialAccountType.CostsAllocatedFunds]; }
        }

        public FinancialAccount CostsInfrastructure
        {
            get { return this[OrganizationFinancialAccountType.CostsInfrastructure]; }
        }

        public FinancialAccount CostsLocalDonationTransfers
        {
            get { return this[OrganizationFinancialAccountType.CostsLocalDonationTransfers]; }
        }

        public FinancialAccount CostsYearlyResult
        {
            get { return this[OrganizationFinancialAccountType.CostsYearlyResult]; }
        }

        public FinancialAccount DebtsEquity
        {
            get { return this[OrganizationFinancialAccountType.DebtsEquity]; }
        }

        public FinancialAccount DebtsExpenseClaims
        {
            get { return this[OrganizationFinancialAccountType.DebtsExpenseClaims]; }
        }

        public FinancialAccount DebtsInboundInvoices
        {
            get { return this[OrganizationFinancialAccountType.DebtsInboundInvoices]; }
        }

        public FinancialAccount DebtsSalary
        {
            get { return this[OrganizationFinancialAccountType.DebtsSalary]; }
        }

        public FinancialAccount DebtsTax
        {
            get { return this[OrganizationFinancialAccountType.DebtsTax]; }
        }

        public FinancialAccount DebtsVat
        {
            get { return this[OrganizationFinancialAccountType.DebtsVat]; }
        }

        public FinancialAccount DebtsEarmarkedVirtualBanking
        {
            get { return this[OrganizationFinancialAccountType.DebtsEarmarkedVirtualBanking]; }
        }

        public FinancialAccount DebtsEarmarkedOtherAssets
        {
            get { return this[OrganizationFinancialAccountType.DebtsEarmarkedOtherAssets]; }
        }

        public FinancialAccount DebtsOther
        {
            get { return this[OrganizationFinancialAccountType.DebtsSalary]; }
        }

        public FinancialAccount IncomeDonations
        {
            get { return this[OrganizationFinancialAccountType.IncomeDonations]; }
        }

        public FinancialAccount IncomeSales
        {
            get { return this[OrganizationFinancialAccountType.IncomeSales]; }
        }

        public FinancialAccount ConstsMiscalculations
        {
            get { return this[OrganizationFinancialAccountType.CostsMiscalculations]; }
        }

        public FinancialAccounts CostsConferences
        {
            get
            {
                FinancialAccounts result = new FinancialAccounts();

                // THIS SERIOUSLY NEEDS OPTIMIZATION, MMMKAY?

                FinancialAccounts costAccounts =
                    FinancialAccounts.ForOrganization(Organization.FromIdentity(this._organizationId),
                                                      FinancialAccountType.Cost);

                foreach (FinancialAccount account in costAccounts)
                {
                    if (account.IsConferenceParent)
                    {
                        result.Add(account);
                    }
                }

                return result;
            }
        }

        public FinancialAccounts ExpensableBudgets
        {
            // TODO: This needs to return a tree, not a flat list.

            get 
            { 
                FinancialAccounts result = new FinancialAccounts();

                int yearlyResultId = this.CostsYearlyResult.Identity;

                FinancialAccounts costAccounts =
                    FinancialAccounts.ForOrganization(Organization.FromIdentity(_organizationId),
                                                      FinancialAccountType.Cost);

                foreach (FinancialAccount account in costAccounts)
                {
                    if (account.Identity != yearlyResultId && account.Expensable) // really should be redundant, but still...
                    {
                        result.Add(account);
                    }
                }

                return result;
            }
        }

    }
}
