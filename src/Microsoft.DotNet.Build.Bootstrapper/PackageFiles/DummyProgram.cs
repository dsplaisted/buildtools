using System;

//  We don't actually need to compile anything, just publish some NuGet packages to a folder.
//  However, dotnet compile doesn't currently support publish without compile.
//  See https://github.com/dotnet/cli/issues/233#issuecomment-158248695

namespace HelloWorldSample 
{
	public static class Program 
	{
		public static void Main() 
		{
			Console.WriteLine("Hello World!");
		}
	}
}