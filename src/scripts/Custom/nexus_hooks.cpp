/*
* Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU GPL v2 license: http://github.com/azerothcore/azerothcore-wotlk/LICENSE-GPL2
* Copyright (C) 2008-2016 TrinityCore <http://www.trinitycore.org/>
* Copyright (C) 2005-2009 MaNGOS <http://getmangos.com/>
*/

#include "ScriptMgr.h"

class NexusHookScript : public PlayerScript
{
public:
	NexusHookScript() : PlayerScript("NexusHookScript") { }

	// Hook token system.
	void OnPVPKill(Player* _player, Player* _victim)
	{
		if (sWorld->getBoolConfig(CONFIG_PVP_TOKEN_ENABLE))
		{
			if (!_victim || _victim == _player || _victim->HasAuraType(SPELL_AURA_NO_PVP_CREDIT))
				return;

			if (_victim->GetTypeId() == TYPEID_PLAYER)
			{
				// Check if allowed to receive it in current map
				uint8 MapType = sWorld->getIntConfig(CONFIG_PVP_TOKEN_MAP_TYPE);
				if ((MapType == 1 && !_player->InBattleground() && !_player->IsFFAPvP())
					|| (MapType == 2 && !_player->IsFFAPvP())
					|| (MapType == 3 && !_player->InBattleground()))
					return;

				uint32 itemId = sWorld->getIntConfig(CONFIG_PVP_TOKEN_ID);
				int32 count = sWorld->getIntConfig(CONFIG_PVP_TOKEN_COUNT);

				if (_player->AddItem(itemId, count))
					ChatHandler(_player->GetSession()).PSendSysMessage("You have been awarded a token for slaying another player.");
			}
		}
	}
};

void AddSC_Nexus_Hooks()
{
	new NexusHookScript();
}
