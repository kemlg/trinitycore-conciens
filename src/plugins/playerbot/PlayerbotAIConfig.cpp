#include "../pchdef.h"
#include "PlayerbotAIConfig.h"
#include "playerbot.h"
#include "RandomPlayerbotFactory.h"
#include "../../game/Accounts/AccountMgr.h"
#include "../../shared/SystemConfig.h"

using namespace std;

PlayerbotAIConfig::PlayerbotAIConfig()
{
}

template <class T>
void LoadList(string value, T &list)
{
    vector<string> ids = split(value, ',');
    for (vector<string>::iterator i = ids.begin(); i != ids.end(); i++)
    {
        uint32 id = atoi((*i).c_str());
        if (!id)
            continue;

        list.push_back(id);
    }
}

bool PlayerbotAIConfig::Initialize()
{
    TC_LOG_INFO("playerbot", "Initializing AI Playerbot by ike3, based on the original Playerbot by blueboy");

    string error;
    if (!sConfigMgr->LoadInitial("aiplayerbot.conf", error))
    {
        TC_LOG_INFO("playerbot", "AI Playerbot is Disabled. Unable to open configuration file aiplayerbot.conf");
        return false;
    }

    enabled = sConfigMgr->GetBoolDefault("AiPlayerbot.Enabled", true);
    if (!enabled)
    {
        TC_LOG_INFO("playerbot", "AI Playerbot is Disabled in aiplayerbot.conf");
        return false;
    }

    globalCoolDown = (uint32) sConfigMgr->GetIntDefault("AiPlayerbot.GlobalCooldown", 500);
    maxWaitForMove = sConfigMgr->GetIntDefault("AiPlayerbot.MaxWaitForMove", 3000);
    reactDelay = (uint32) sConfigMgr->GetIntDefault("AiPlayerbot.ReactDelay", 100);

    sightDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.SightDistance", 50.0f);
    spellDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.SpellDistance", 30.0f);
    reactDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.ReactDistance", 150.0f);
    grindDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.GrindDistance", 100.0f);
    lootDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.LootDistance", 20.0f);
    fleeDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.FleeDistance", 20.0f);
    tooCloseDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.TooCloseDistance", 7.0f);
    meleeDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.MeleeDistance", 1.5f);
    followDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.FollowDistance", 1.5f);
    whisperDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.WhisperDistance", 6000.0f);
    contactDistance = sConfigMgr->GetFloatDefault("AiPlayerbot.ContactDistance", 0.5f);

    criticalHealth = sConfigMgr->GetIntDefault("AiPlayerbot.CriticalHealth", 20);
    lowHealth = sConfigMgr->GetIntDefault("AiPlayerbot.LowHealth", 50);
    mediumHealth = sConfigMgr->GetIntDefault("AiPlayerbot.MediumHealth", 70);
    almostFullHealth = sConfigMgr->GetIntDefault("AiPlayerbot.AlmostFullHealth", 85);
    lowMana = sConfigMgr->GetIntDefault("AiPlayerbot.LowMana", 15);
    mediumMana = sConfigMgr->GetIntDefault("AiPlayerbot.MediumMana", 40);

    randomGearLoweringChance = sConfigMgr->GetFloatDefault("AiPlayerbot.RandomGearLoweringChance", 0.15);
    randomBotMaxLevelChance = sConfigMgr->GetFloatDefault("AiPlayerbot.RandomBotMaxLevelChance", 0.4);

    iterationsPerTick = sConfigMgr->GetIntDefault("AiPlayerbot.IterationsPerTick", 4);

    allowGuildBots = sConfigMgr->GetBoolDefault("AiPlayerbot.AllowGuildBots", true);

    randomBotMapsAsString = sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotMaps", "0,1,530,571");
    LoadList<vector<uint32> >(randomBotMapsAsString, randomBotMaps);
    LoadList<list<uint32> >(sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotQuestItems", "6948,5175,5176,5177,5178"), randomBotQuestItems);
    LoadList<list<uint32> >(sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotSpellIds", "54197"), randomBotSpellIds);

    randomBotAutologin = sConfigMgr->GetBoolDefault("AiPlayerbot.RandomBotAutologin", true);
    minRandomBots = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBots", 50);
    maxRandomBots = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomBots", 200);
    randomBotUpdateInterval = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotUpdateInterval", 60);
    randomBotCountChangeMinInterval = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotCountChangeMinInterval", 24 * 3600);
    randomBotCountChangeMaxInterval = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotCountChangeMaxInterval", 3 * 24 * 3600);
    minRandomBotInWorldTime = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBotInWorldTime", 2 * 3600);
    maxRandomBotInWorldTime = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomBotInWorldTime", 14 * 24 * 3600);
    minRandomBotRandomizeTime = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBotRandomizeTime", 2 * 3600);
    maxRandomBotRandomizeTime = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomRandomizeTime", 14 * 24 * 3600);
    minRandomBotReviveTime = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBotReviveTime", 60);
    maxRandomBotReviveTime = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomReviveTime", 300);
    randomBotTeleportDistance = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotTeleportDistance", 1000);
    minRandomBotsPerInterval = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBotsPerInterval", 50);
    maxRandomBotsPerInterval = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomBotsPerInterval", 100);
    minRandomBotsPriceChangeInterval = sConfigMgr->GetIntDefault("AiPlayerbot.MinRandomBotsPriceChangeInterval", 2 * 3600);
    maxRandomBotsPriceChangeInterval = sConfigMgr->GetIntDefault("AiPlayerbot.MaxRandomBotsPriceChangeInterval", 48 * 3600);
    randomBotJoinLfg = sConfigMgr->GetBoolDefault("AiPlayerbot.RandomBotJoinLfg", true);
    logInGroupOnly = sConfigMgr->GetBoolDefault("AiPlayerbot.LogInGroupOnly", true);
    logValuesPerTick = sConfigMgr->GetBoolDefault("AiPlayerbot.LogValuesPerTick", false);
    fleeingEnabled = sConfigMgr->GetBoolDefault("AiPlayerbot.FleeingEnabled", true);
    randomBotMinLevel = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotMinLevel", 1);
    randomBotMaxLevel = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotMaxLevel", 255);
    randomBotLoginAtStartup = sConfigMgr->GetBoolDefault("AiPlayerbot.RandomBotLoginAtStartup", true);

    randomChangeMultiplier = sConfigMgr->GetFloatDefault("AiPlayerbot.RandomChangeMultiplier", 1.0);

    randomBotCombatStrategies = sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotCombatStrategies", "+dps,+attack weak");
    randomBotNonCombatStrategies = sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotNonCombatStrategies", "+grind,+move random,+loot");

    commandPrefix = sConfigMgr->GetStringDefault("AiPlayerbot.CommandPrefix", "");

    for (uint32 cls = 0; cls < MAX_CLASSES; ++cls)
    {
        for (uint32 spec = 0; spec < 3; ++spec)
        {
            ostringstream os; os << "AiPlayerbot.RandomClassSpecProbability." << cls << "." << spec;
            specProbability[cls][spec] = sConfigMgr->GetIntDefault(os.str().c_str(), 33);
        }
    }

    CreateRandomBots();
    TC_LOG_INFO("playerbot", "AI Playerbot configuration loaded");

    return true;
}


bool PlayerbotAIConfig::IsInRandomAccountList(uint32 id)
{
    return find(randomBotAccounts.begin(), randomBotAccounts.end(), id) != randomBotAccounts.end();
}

bool PlayerbotAIConfig::IsInRandomQuestItemList(uint32 id)
{
    return find(randomBotQuestItems.begin(), randomBotQuestItems.end(), id) != randomBotQuestItems.end();
}

string PlayerbotAIConfig::GetValue(string name)
{
    ostringstream out;

    if (name == "GlobalCooldown")
        out << globalCoolDown;
    else if (name == "ReactDelay")
        out << reactDelay;

    else if (name == "SightDistance")
        out << sightDistance;
    else if (name == "SpellDistance")
        out << spellDistance;
    else if (name == "ReactDistance")
        out << reactDistance;
    else if (name == "GrindDistance")
        out << grindDistance;
    else if (name == "LootDistance")
        out << lootDistance;
    else if (name == "FleeDistance")
        out << fleeDistance;

    else if (name == "CriticalHealth")
        out << criticalHealth;
    else if (name == "LowHealth")
        out << lowHealth;
    else if (name == "MediumHealth")
        out << mediumHealth;
    else if (name == "AlmostFullHealth")
        out << almostFullHealth;
    else if (name == "LowMana")
        out << lowMana;

    else if (name == "IterationsPerTick")
        out << iterationsPerTick;

    return out.str();
}

void PlayerbotAIConfig::SetValue(string name, string value)
{
    istringstream out(value, istringstream::in);

    if (name == "GlobalCooldown")
        out >> globalCoolDown;
    else if (name == "ReactDelay")
        out >> reactDelay;

    else if (name == "SightDistance")
        out >> sightDistance;
    else if (name == "SpellDistance")
        out >> spellDistance;
    else if (name == "ReactDistance")
        out >> reactDistance;
    else if (name == "GrindDistance")
        out >> grindDistance;
    else if (name == "LootDistance")
        out >> lootDistance;
    else if (name == "FleeDistance")
        out >> fleeDistance;

    else if (name == "CriticalHealth")
        out >> criticalHealth;
    else if (name == "LowHealth")
        out >> lowHealth;
    else if (name == "MediumHealth")
        out >> mediumHealth;
    else if (name == "AlmostFullHealth")
        out >> almostFullHealth;
    else if (name == "LowMana")
        out >> lowMana;

    else if (name == "IterationsPerTick")
        out >> iterationsPerTick;
}


void PlayerbotAIConfig::CreateRandomBots()
{
    string randomBotAccountPrefix = sConfigMgr->GetStringDefault("AiPlayerbot.RandomBotAccountPrefix", "rndbot");
    uint32 randomBotAccountCount = sConfigMgr->GetIntDefault("AiPlayerbot.RandomBotAccountCount", 50);

    if (sConfigMgr->GetBoolDefault("AiPlayerbot.DeleteRandomBotAccounts", false))
    {
        TC_LOG_INFO("playerbot", "Deleting random bot accounts...");
        QueryResult results = LoginDatabase.PQuery("SELECT id FROM account where username like '%s%%'", randomBotAccountPrefix.c_str());
        if (results)
        {
            do
            {
                Field* fields = results->Fetch();
                sAccountMgr->DeleteAccount(fields[0].GetUInt32());
            } while (results->NextRow());
        }

        CharacterDatabase.Execute("DELETE FROM ai_playerbot_random_bots");
        TC_LOG_INFO("playerbot", "Random bot accounts deleted");
    }

    for (int accountNumber = 0; accountNumber < randomBotAccountCount; ++accountNumber)
    {
        ostringstream out; out << randomBotAccountPrefix << accountNumber;
        string accountName = out.str();
        QueryResult results = LoginDatabase.PQuery("SELECT id FROM account where username = '%s'", accountName.c_str());
        if (results)
        {
            continue;
        }

        string password = "";
        for (int i = 0; i < 10; i++)
        {
            password += (char)urand('!', 'z');
        }
        sAccountMgr->CreateAccount(accountName, password, "playerbot");

        TC_LOG_INFO("playerbot", "Account %s created for random bots", accountName.c_str());
    }

    LoginDatabase.PExecute("UPDATE account SET expansion = '%u' where username like '%s%%'", 2, randomBotAccountPrefix.c_str());

    int totalRandomBotChars = 0;
    for (int accountNumber = 0; accountNumber < randomBotAccountCount; ++accountNumber)
    {
        ostringstream out; out << randomBotAccountPrefix << accountNumber;
        string accountName = out.str();

        QueryResult results = LoginDatabase.PQuery("SELECT id FROM account where username = '%s'", accountName.c_str());
        if (!results)
            continue;

        Field* fields = results->Fetch();
        uint32 accountId = fields[0].GetUInt32();

        randomBotAccounts.push_back(accountId);

        int count = sAccountMgr->GetCharactersCount(accountId);
        if (count >= 10)
        {
            totalRandomBotChars += count;
            continue;
        }

        RandomPlayerbotFactory factory(accountId);
        for (uint8 cls = CLASS_WARRIOR; cls < MAX_CLASSES; ++cls)
        {
            if (cls != 10 && cls != CLASS_DEATH_KNIGHT)
                factory.CreateRandomBot(cls);
        }

        totalRandomBotChars += sAccountMgr->GetCharactersCount(accountId);
    }

    TC_LOG_INFO("playerbot", "%d random bot accounts with %d characters available", randomBotAccounts.size(), totalRandomBotChars);
}
