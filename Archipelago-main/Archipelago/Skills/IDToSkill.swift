//
//  IDtoSkill.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/15/23.
//

func idToSkill(id: SkillID) -> Skill {
    switch(id) {
    case .Polish:
        return Polish()
    case .Nightmare:
        return Nightmare()
    case .SwordDefense:
        return SwordDefenseSkill()
    case .Repeal:
        return Repeal()
    case .IceBeam:
        return IceBeam()
    case .SleepGas:
        return SleepGas()
    case .MagicLight:
        return MagicLight()
    case .DoubleStrikes:
        return DoubleStrikes()
    case .Claw:
        return Claw()
    case .Sting:
        return Sting()
    case .Strike:
        return Strike()
    case .SoulStrike:
        return SoulStrike()
    case .HeavyBlow:
        return HeavyBlow()
    case .Restore:
        return Restore()
    case .MindControl:
        return MindControl()
    case .SquirrelSpell:
        return SquirrelSpell()
    }
}
