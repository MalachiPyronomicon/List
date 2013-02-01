/*
* Filename: donator.list.sp
*
* Description: Lists donators currently on server
*
* Dependencies: donator.core.sp
*               
* Includes: donator.inc
*
* CVARs: donator_list_version
*
* Public: -none-
* 
* Changelog:
* 
* 0.2 - alpha
* 0.1 - alpha
*
*/

#include <sourcemod>
//#include <sdktools>
//#include <tf2>
#include <donator>
//#include <clientprefs>
#include <clients>	// MAX_NAME_LENGTH

#pragma semicolon 1

#define PLUGIN_VERSION	"0.2a"


public Plugin:myinfo = 
{
	name = "Donator List",
	author = "Malachi",
	description = "List donators for admins.",
	version = PLUGIN_VERSION,
	url = "http://www.necrophix.com/"
}

public OnPluginStart()
{
	CreateConVar("donator_list_version", PLUGIN_VERSION, "Donator Recognition Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
//	RegConsoleCmd("say", SayHook);
//	RegConsoleCmd("say_team", SayHook);
//	HookEvent("player_chat", SayHook, EventHookMode_Pre);
	AddCommandListener(SayHook, "say");
	AddCommandListener(SayHook, "say_team");

}

public OnAllPluginsLoaded()
{
	if(!LibraryExists("donator.core")) SetFailState("Unabled to find plugin: Basic Donator Interface");
}


public Action:SayHook(iClient, const String:command[], args)
{
	decl String:text[192];
	decl String:donName[MAX_NAME_LENGTH];
	
	GetCmdArgString(text, sizeof(text));

	StripQuotes(text);
	TrimString(text);
	
	// Is this console?
	if (!iClient)
		return Plugin_Continue;
		
	// Are they in game?
	if (!IsClientInGame(iClient))
		return Plugin_Continue;
		
	// Is this client an admin?
	if (!GetUserAdmin(iClient)) 
		return Plugin_Continue;
	
	if(StrEqual(text, "!donators", false) || StrEqual(text, "/donators", false))
	{
		for (new iDon = 1; iDon <= MaxClients; iDon++)
		{
			if (IsClientInGame(iDon))
			{
				// Is this client a donator?
				if (IsPlayerDonator(iDon))
				{
					for (new iAdm = 1; iAdm <= MaxClients; iAdm++)
					{
						if (IsClientInGame(iAdm))
						{
							// print only to admins
							if (GetUserAdmin(iAdm))
							{
								if (GetClientName(iDon, donName, sizeof(donName)))
									PrintToChat(iAdm, "(ADMINS) Donators: %s", donName);
							}	
						}
					}
				}	
			}
		}
		
		return Plugin_Handled;
	}
	else
	{	
		return Plugin_Continue;
	}
}
