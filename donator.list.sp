/*
* Filename: donator.list.sp
* Description: Lists donators currently on server to admins
* Dependencies: donator.core.sp            
* Includes: donator.inc
* CVARs: donator_list_version
* Public: -none-
* 
* Changelog:
* 0.0.4a - changed earlier admin check to prevent donators from triggering plugin
* 0.0.3a - alpha, added color text, changed admin check to exclude donators (unlike before)
* 0.2 - alpha
* 0.1 - alpha
*
* Restrictions:
* Uses color - cannot be used in game GetGameFolderName() == "hl2mp"
*/

#include <sourcemod>
#include <donator>
//#include <clients>	// MAX_NAME_LENGTH, MAXPLAYERS, MaxClients
//#include <admin>	// INVALID_ADMIN_ID

#pragma semicolon 1

#define PLUGIN_VERSION	"0.0.4a"

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
	CreateConVar("donator_list_version", PLUGIN_VERSION, "Donator List Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	AddCommandListener(SayHook, "say");
	AddCommandListener(SayHook, "say_team");

//	bool:dontBroadcast

}

public OnAllPluginsLoaded()
{
	if(!LibraryExists("donator.core")) SetFailState("Unable to find plugin: Basic Donator Interface");
}


public Action:SayHook(iClient, const String:command[], args)
{
	// Is this console?
	if (!iClient)
		return Plugin_Continue;
		
	// Do we really need this check?
	// Are they in game?
	if (!IsClientInGame(iClient))
		return Plugin_Continue;
		
	// Is this client an admin?
	if (GetUserAdmin(iClient) == INVALID_ADMIN_ID)
		return Plugin_Continue;
	

	decl String:text[192];
	decl String:donName[MAX_NAME_LENGTH];
	
	GetCmdArgString(text, sizeof(text));

	StripQuotes(text);
	TrimString(text);
	

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
							if (GetUserAdmin(iAdm) != INVALID_ADMIN_ID)
							{
								if (GetClientName(iDon, donName, sizeof(donName)))
									PrintToChat(iAdm, "\x04(ADMINS) \x01Donators: %s", donName);
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
