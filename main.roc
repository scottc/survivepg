app [ready!, process!, scene_init!, physics_process!] {
    # godot4.7
    pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-15-a0c681f/godot4_7-platform-CnihCYmnf85DpCER7ah8R4jLSHSSK2p6TTgWfH8dmAcL.tar.zst",
    # redot26.2
    # pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-15-a0c681f/redot26_2-platform-6BYcLkzVMZiNL2aKhRFFBMstLdjU5CGYbiimzurpD9k7.tar.zst",
    # blazium0.6
    # pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-15-a0c681f/blazium0_6-platform-8d1oUgcLnc1C3r7bxhtCPzDt6zAo1kRfPQnSeuViy7m5.tar.zst",
}

# Top level multi-engine & multi-version platform
import pf.Engine
import pf.GodotRoc
import pf.Host

# Generated Per Engine:
import pf.EngineInfo
import pf.UtilityFunctions
import pf.Vector3
import pf.Vector3Methods
import pf.InputSingleton
import pf.EngineDebuggerSingleton

# This app..
import MyPlayerCharacter
import Npc

# ---------------------------------------------------------------------------
# App hooks
# ---------------------------------------------------------------------------

scene_init! : () => {}
scene_init! = || {
    Engine.print_warning!("Hello World!")

    Engine.print_warning!("Static & Runtime info!")

    # --baseline={engine}
    Engine.print_warning!("--baseline=${EngineInfo.version_major.to_str()}.${EngineInfo.version_minor.to_str()}.${EngineInfo.version_patch.to_str()}")

    # --engines={engine1,engine2}
    _exclusive_engine_content = match Engine.current_engine!() {
        Godot4_5(_gd_api) => "Exclusive godot4.5 content is avaliable."
        Godot4_7(_gd_api) => "Exclusive godot4.7 content is avaliable."
        Redot26_2(_rd_api) => "Exclusive redot26.2 content is avaliable."
        Blazium0_6(_bz_api) => "Exclusive blazium0.6 content is avaliable."
        # other => "You snooze you loose ${Str.inspect(other)}."
    }

    # --targets={target1,target2}
    _exclusive_cpu_arch_os_content = match Engine.current_target!() {
        Wasm32 => "Exclusive Web Content!"
        X64musl => "Exclusive Native Linux Desktop Content!"
    }

    # Does the dynamiclly linked runtime
    # match one of the static --engines={engine1,engine2}?
    _is_safe = match Engine.engine_runtime_ok!() {
        0 => crash "Oh no, we're in the danger zone, we should just crash."
        1 => "We've got the green light, everything is good to go!"
        _ => crash "A GDExtension U8 Bool... Unexpected value! should be 1 or 0."
    }

    # Roc API exists
    # but we want to trigger host stub not-implementated error...
    # just as a test...
    EngineDebuggerSingleton.script_debug!(0, 0, 0)

    player_class_id = Engine.register_class!("MyPlayerCharacter", "CharacterBody3D")
    Engine.print_warning!("Registered MyPlayerCharacter (id=${player_class_id.to_str()})")

    npc_class_id = Engine.register_class!("Npc", "CharacterBody3D")
    Engine.print_warning!("Registered Npc (id=${npc_class_id.to_str()})")
}

physics_process! : GodotRoc.ClassId, F64 => {}
physics_process! = |class_id, delta| {



    _ = match class_id {
        0 => MyPlayerCharacter.physics_process!(delta)
        1 => Npc.physics_process!(delta)
        _ => {}
    }
    {}
}

process! : GodotRoc.ClassId, F64 => {}
process! = |_class_id, _delta| {
    {}
}

unhandled_input! : () => {}
unhandled_input! = || {
    {}
}

ready! : () => {}
ready! = || {
    {}
}

# main! = |_args| {{}}
