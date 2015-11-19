// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.DotNet.Build.Tasks
{
    /// <summary>
    /// An exception for reporting errors to the user. Points to a resource in <see cref="Strings"/> so
    /// we get the proper MSBuild localization handling.
    /// </summary>
    internal sealed class ExceptionFromResource : Exception
    {
        public string ResourceName { get; private set; }
        public object[] MessageArgs { get; private set; }

        public ExceptionFromResource(string resourceName, params object[] messageArgs)
        {
            ResourceName = resourceName;
            MessageArgs = messageArgs;
        }
    }
}
