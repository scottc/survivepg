app [ready!, process!, scene_init!, physics_process!] {
    # [baseline] godot4.5 (baseline)
    pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-13-dbbdb0c/godot4_5-platform-6UXQBeGpB9zY5Kytgpyavpc9ioLdWNBtQaF2orvqZGA5.tar.zst",
    # godot (latest)
    # pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-13-dbbdb0c/godot-platform-HaTJuo3owLNqLWVir5f4FxuXRZtL5H8n2WaMKd3JmFpF.tar.zst",
    # redot (latest)
    # pf: platform "https://github.com/scottc/godot-roc/releases/download/nightly-2026-10-13-dbbdb0c/redot-platform-FtpVoMidux9ARFHpmdRM2oJEYepKPGnkYbnthHAcSDXo.tar.zst",
}

# Top level multi-engine & multi-version platform
import pf.Engine
import pf.Target
import pf.GodotRoc
import pf.Host

# Generated Per Engine:
import pf.EngineInfo
import pf.UtilityFunctions
import pf.Vector3
import pf.Vector3Methods
import pf.InputSingleton

# This app..
import MyPlayerCharacter
import Npc

# ---------------------------------------------------------------------------
# App hooks
# ---------------------------------------------------------------------------

scene_init! : () => {}
scene_init! = || {
    Engine.print_warning!("Hello World!")

    player_class_id = Engine.register_class!("MyPlayerCharacter", "CharacterBody3D")
    Engine.print_warning!("Registered MyPlayerCharacter id= ${player_class_id.to_str()}")

    npc_class_id = Engine.register_class!("Npc", "CharacterBody3D")
    Engine.print_warning!("Registered Npc id= ${npc_class_id.to_str()}")
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
