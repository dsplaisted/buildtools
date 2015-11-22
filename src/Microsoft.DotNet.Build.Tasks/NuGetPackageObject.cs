﻿// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace Microsoft.DotNet.Build.Tasks
{
    /// <summary>
    /// Metedata and information for a package listed in the lock file.
    /// </summary>
    internal sealed class NuGetPackageObject
    {
        public NuGetPackageObject(string id, string version, string fullPackagePath, JObject lockFileObject)
        {
            Id = id;
            Version = version;
            FullPackagePath = fullPackagePath;
            LockFileObject = lockFileObject;
        }

        public string Id { get; }
        public string Version { get; }
        public string FullPackagePath { get; }
        public JObject LockFileObject { get; }

        public string GetFullPathToFile(string relativePath)
        {
            relativePath = relativePath.Replace('/', '\\');
            return Path.Combine(FullPackagePath, relativePath);
        }
    }
}
