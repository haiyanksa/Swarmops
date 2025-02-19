using Swarmops.Basic.Enums;
using Swarmops.Basic.Interfaces;

namespace Swarmops.Basic.Types.Financial
{
    public class BasicFinancialAccount : IHasIdentity
    {
        public BasicFinancialAccount (int financialAccountId, string name, FinancialAccountType accountType,
                                      int organizationId, int parentFinancialAccountId, int ownerPersonId,
                                      bool open, int openedYear, int closedYear, bool active, bool expensable,
                                      bool administrative, int linkBackward, int linkForward)
        {
            this.FinancialAccountId = financialAccountId;
            this.Name = name;
            this.AccountType = accountType;
            this.OrganizationId = organizationId;
            this.OwnerPersonId = ownerPersonId;
            this.ParentFinancialAccountId = parentFinancialAccountId;
            this.Open = open;
            this.OpenedYear = openedYear;
            this.ClosedYear = closedYear;
            this.Active = active;
            this.Expensable = expensable;
            this.Administrative = administrative;
            this.LinkBackward = linkBackward;
            this.LinkForward = linkForward;
        }

        public BasicFinancialAccount (BasicFinancialAccount original) :
            this(original.Identity, original.Name, original.AccountType, original.OrganizationId, original.ParentFinancialAccountId, original.OwnerPersonId, original.Open, original.OpenedYear, original.ClosedYear, original.Active, original.Expensable, original.Administrative, original.LinkBackward, original.LinkForward)
        {
            // Empty copy constructor
        }


        public int FinancialAccountId { get; private set; }
        public string Name { get; protected set; }
        public int OrganizationId { get; private set; }
        public FinancialAccountType AccountType { get; private set; }
        public int OwnerPersonId { get; protected set; }
        public int ParentFinancialAccountId { get; protected set; }
        public bool Open { get; protected set; }
        public int OpenedYear { get; protected set; }
        public int ClosedYear { get; protected set; }
        public bool Active { get; protected set; }
        public bool Expensable { get; protected set; }
        public bool Administrative { get; protected set; }
        public int LinkBackward { protected get; set; }
        public int LinkForward { protected get; set; }

        #region IHasIdentity Members

        public int Identity
        {
            get { return this.FinancialAccountId; }
        }

        #endregion
    }
}