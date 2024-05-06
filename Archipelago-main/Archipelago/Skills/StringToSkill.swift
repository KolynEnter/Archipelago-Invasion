//
//  StringToSkill.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/3/23.
//

func stringToSkill(name: String) -> Skill {
    switch name {
    case "Strike":
        return Strike()
    case "Polish":
        return Polish()
    case "Nightmare":
        return Nightmare()
    case "SwordDefense":
        return SwordDefenseSkill()
    case "Repeal":
        return Repeal()
    case "IceBeam":
        return IceBeam()
    case "SleepGas":
        return SleepGas()
    case "MagicLight":
        return MagicLight()
    case "DoubleStrikes":
        return DoubleStrikes()
    case "Claw":
        return Claw()
    case "Sting":
        return Sting()
    case "SoulStrike":
        return SoulStrike()
    case "HeavyBlow":
        return HeavyBlow()
    case "Restore":
        return Restore()
    case "MindControl":
        return MindControl()
    case "SquirrelSpell":
        return SquirrelSpell()
    default:
        return Strike()
    }
}
