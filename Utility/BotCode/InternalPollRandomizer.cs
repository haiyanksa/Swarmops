using Swarmops.Logic.Governance;

namespace Swarmops.Utility.BotCode
{
    public class InternalPollRandomizer
    {
        // Randomizes the order of candidates on the open polls.
        static public void Run()
        {

            // TODO: Foreach open poll...

            MeetingElectionCandidates candidates = MeetingElectionCandidates.ForPoll(MeetingElection.Primaries2010);

            foreach (MeetingElectionCandidate candidate in candidates)
            {
                candidate.RandomizeSortOrder();
            }
        }
    }
}
