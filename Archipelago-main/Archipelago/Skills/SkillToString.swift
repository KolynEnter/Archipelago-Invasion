//
//  SkillToString.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/5/23.
//

func skillToString(skill: Skill) -> String {
    switch skill {
    case is Strike:
        return "Strike"
    case is Polish:
        return "Polish"
    case is Nightmare:
        return "Nightmare"
    case is SwordDefenseSkill:
        return "SwordDefense"
    case is Repeal:
        return "Repeal"
    case is IceBeam:
        return "IceBeam"
    case is SleepGas:
        return "SleepGas"
    case is MagicLight:
        return "MagicLight"
    case is DoubleStrikes:
        return "DoubleStrikes"
    case is Claw:
        return "Claw"
    case is Sting:
        return "Sting"
    case is SoulStrike:
        return "SoulStrike"
    case is HeavyBlow:
        return "HeavyBlow"
    case is Restore:
        return "Restore"
    case is MindControl:
        return "MindControl"
    case is SquirrelSpell:
        return "SquirrelSpell"
    default:
        return "nil"
    }
}
