using System;
using Swarmops.Basic.Enums;

namespace Swarmops.Basic.Interfaces
{
    public interface IHandleProvider
    {
        string GetPersonHandle (int personId);
        void SetPersonHandle (int personId, string newHandle);
        HandleErrorType CanSetHandle (string newHandle);

        int GetPersonByHandle (string handle);
    }
}

namespace Swarmops.Basic.Enums
{
    public enum HandleErrorType
    {
        Unknown = 0,
        NoError,
        HandleNotFound,
        HandleOccupied
    }
}

namespace Swarmops.Basic.Exceptions
{
    public class HandleException : Exception
    {
        public HandleException (string attemptedHandle, HandleErrorType errorType)
        {
            this.attemptedHandle = attemptedHandle;
            this.errorType = errorType;
        }


        public override string ToString()
        {
            return "HandleException: Handle '" + attemptedHandle + "' caused '" + errorType.ToString() + "'.\r\n" +
                   base.ToString();
        }


        public HandleErrorType ErrorType
        {
            get { return errorType; }
        }

        private readonly string attemptedHandle;
        private readonly HandleErrorType errorType;
    }
}