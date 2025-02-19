using System;

namespace Swarmops.Logic.DashboardTasks
{
    public class TaskBase
    {
        public TaskBase (int identity, string description, DateTime opened, DateTime expires)
        {
            this.Identity = identity;
            this.Description = description;
            this.Opened = opened;
            this.Expires = expires;
        }

        public int Identity { get; protected set; }
        public string Description { get; protected set; }
        public DateTime Opened { get; protected set; }
        public DateTime Expires { get; protected set; }
    }
}
