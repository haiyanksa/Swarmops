﻿namespace Swarmops.Logic.Support
{
    public class PilotInstallationIds
    {
        static public string PiratePartySE
        { get { return "d7588903-5fd0-40cf-a5b1-9af7a722cb6e"; } }

        static public string DevelopmentSandbox
        { get { return "a8187d16-d913-4ddc-a3d5-214f7c14aac5"; } }

        static public bool IsPilot(string installationId)
        {
            string thisInstallationId = Persistence.Key["SwarmopsInstallationId"];
            if (installationId == thisInstallationId)
            {
                return true;
            }

            return false;
        }
    }


}
