#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellAuras.h"

enum says
{
#define SAY_AGGRO               "How dare you interupt my work. I will take your life!"
#define SAY_KILL2               "Another Worthless challenger"
#define SAY_DEATH               "Master i did not succeed..."
#define SAY_SUMMON_VOLCANO      "Arise my minions and aid your master!"
#define SAY_SUMMON_COMPANIONS   "You think thats all i have... ARMY ARISE!"
};

enum spells
{
    SPELL_CHANNELING                = 30540,
    SPELL_SHADOWBOLT                = 39329,    //Castable in all phases!
    SPELL_SUMMON_VOLCANO            = 66258,    // Only cast in phase 2!
    SPELL_SHADOWBOLT_VOLLY          = 32963,    //Only cast in phase 2!
    SPELL_BANISH                    = 30231,    //Only cast in phase 2!
    SPELL_SUMMON_SHADOW_DEMON       = 41117,    //
    SPELL_ARMY_OF_THE_DEAD          = 42650,
    SPELL_VOLCANIC_ERUPTION         = 40276,
    SPELL_VOLCANIC_ERUPTION_TRIGGER = 40117,
};

uint32 SUMMON_VOLCANO;          //summon a volcano that summons felguards
uint32 SHADOWBOLT_VOLLY;
uint32 SHADOWBOLT_TIMER;
uint32 SHADOW_DEMON_TIMER;
uint32 SUMMMON_SOULS;
uint32 PHASE1_TIMER;
uint32 PHASE2_TIMER;
uint32 phase;                   //Sets the phase of the boss
uint32 SUMMON_FIRE_VOLCANO;


class boss_customboss1 : public CreatureScript
{
public:
    boss_customboss1() : CreatureScript("boss_customboss1") {}

    CreatureAI* GetAI(Creature* creature) const
    {
        return new boss_customboss1AI(creature);
    }

    struct boss_customboss1AI : public ScriptedAI
    {
       boss_customboss1AI(Creature* creature) : ScriptedAI(creature) 
       {
           me->AddAura(SPELL_CHANNELING, me);
       }

        void phase1()
        {
            phase = 1;
            PHASE2_TIMER = 30000;
            me->SetReactState(REACT_AGGRESSIVE);
            me->RemoveAura(SPELL_BANISH);
            me->SetControlled(false, UNIT_STATE_ROOT);
            me->MonsterTextEmote("%s Becomes vulnerable!", 0, true);
        }
        
        void phase2()
        {
            phase = 2;
            me->SetReactState(REACT_PASSIVE);
            me->MonsterTextEmote("%s Banishes himself!", 0, true);
            me->AddAura(SPELL_BANISH, me);
            SHADOW_DEMON_TIMER = 10000;
            SUMMON_VOLCANO = 30000;
            SHADOWBOLT_TIMER = 10000;
            PHASE1_TIMER = 30000;
            me->AttackStop();
            me->SetControlled(true, UNIT_STATE_ROOT);
            SHADOWBOLT_VOLLY = 5000;
        }

        void Initialize()
        {
            phase = 1;
            SHADOWBOLT_TIMER = 3000;
            SUMMMON_SOULS = 45000;
            PHASE2_TIMER = 30000;
            me->AddAura(SPELL_CHANNELING, me);
            SUMMON_FIRE_VOLCANO = 10000;
        }
        
        void Reset()
        {
            Initialize(); 
        }

        void EnterCombat(Unit* /*who*/)
        {
            me->MonsterYell(SAY_AGGRO, LANG_UNIVERSAL, NULL);
            me->RemoveAura(SPELL_CHANNELING);
        }

        void JustDied(Unit* /*killer*/)
        {
            me->MonsterYell(SAY_DEATH, LANG_UNIVERSAL, NULL);
        }

        void KilledUnit(Unit* victim)
        {
            me->MonsterYell(SAY_KILL2, LANG_UNIVERSAL, NULL);
        }

        void UpdateAI(uint32 diff)
        {

            if (!UpdateVictim() || me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (SUMMON_FIRE_VOLCANO <= diff)
            {
                Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 1, 100, true);
                if (target)
                {
                    DoCast(target, SPELL_VOLCANIC_ERUPTION, false);
                }
                SUMMON_FIRE_VOLCANO = 10000;
            }
            else
                SUMMON_FIRE_VOLCANO -= diff;


            if (SHADOWBOLT_TIMER <= diff)
            {
                SHADOWBOLT_TIMER = 3000;
                Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 1, 100, true);
                if (target)
                    DoCast(target, SPELL_SHADOWBOLT, false);
            }
            else
                SHADOWBOLT_TIMER -= diff;

         // Phase 1   
            if (phase == 1)
            {
                if (PHASE2_TIMER <= diff)
                {
                    phase2();
                }
                else
                    PHASE2_TIMER -= diff;
            } 

            if (phase != 2)
            {
                if (SUMMMON_SOULS <= diff)
                {
                    me->MonsterYell(SAY_SUMMON_COMPANIONS, LANG_UNIVERSAL, NULL);
                    DoCast(SPELL_ARMY_OF_THE_DEAD);
                    SUMMMON_SOULS = 45000;
                }
                else
                    SUMMMON_SOULS -= diff;
            }
            
            
        // Phase 2

            if (phase == 2)
            {
                if (PHASE1_TIMER <= diff)
                {
                    phase1();
                }
                else
                    PHASE1_TIMER -= diff;
            }

            if (phase != 1)
            {
                if (SHADOWBOLT_VOLLY <= diff)
                {
                    DoCast(SPELL_SHADOWBOLT_VOLLY);
                    SHADOWBOLT_VOLLY = 5000;
                }
                else
                    SHADOWBOLT_VOLLY -= diff;

                if (SUMMON_VOLCANO <= diff)
                {
                    me->MonsterYell(SAY_SUMMON_VOLCANO, LANG_UNIVERSAL, NULL);
                    DoCast(SPELL_SUMMON_VOLCANO);
                    SUMMON_VOLCANO = 45000;
                }
                else
                    SUMMON_VOLCANO -= diff;

                if (SHADOW_DEMON_TIMER <= diff)
                {
                    DoCast(SPELL_SUMMON_SHADOW_DEMON);
                    SHADOW_DEMON_TIMER = 30000;
                }
                else
                    SHADOW_DEMON_TIMER -= diff;
            }
            DoMeleeAttackIfReady();  
        }
    };
};

class npc_volcano : public CreatureScript
{
public:
    npc_volcano() : CreatureScript("npc_volcano") {}

    CreatureAI* GetAI(Creature* creature) const
    {
        return new npc_volcanoAI(creature);
    }

    struct npc_volcanoAI : public ScriptedAI
    {
        npc_volcanoAI(Creature* creature) : ScriptedAI(creature)
        {
            me->CastSpell(me, SPELL_VOLCANIC_ERUPTION_TRIGGER, false);
        }

    };
};


void AddSC_Custombosses()
{
    new boss_customboss1();
    new npc_volcano();
}
