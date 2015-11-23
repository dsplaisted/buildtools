// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using System;
using System.Diagnostics;
using System.Linq;
using System.Text.RegularExpressions;
using System.Text;
using System.Xml.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;

namespace Microsoft.DotNet.Build.Tasks
{
    public class UpdateProjectJson : Task
    {
        [Required]
        public string PackageName { get; set; }

        [Required]
        public string PackageVersion { get; set; }

        [Required]
        public string ProjectJsonFile { get; set; }

        public override bool Execute()
        {
            Log.LogMessage("Starting UpdateProjectJson");

            JObject projectJson;

            using (StreamReader sr = File.OpenText(ProjectJsonFile))
            {
                projectJson = (JObject) JToken.ReadFrom(new JsonTextReader(sr));
            }

            projectJson["dependencies"][PackageName] = PackageVersion;

            //StringBuilder sb = new StringBuilder();
            using (Stream s = File.Open(ProjectJsonFile, FileMode.Create, FileAccess.Write))
            using (StreamWriter sw = new StreamWriter(s))
            using (JsonTextWriter jsonWriter = new JsonTextWriter(sw))
            {
                jsonWriter.Formatting = Formatting.Indented;
                projectJson.WriteTo(jsonWriter);
            }

            return true;
        }
    }
}
