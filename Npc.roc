### MyPlayerCharacter.roc - A player controlled character
# TODO: delete host import, use generated bespoke apis.
import pf.Host
import pf.Engine
import pf.GodotRoc

# bespoke apis
import pf.InputSingleton
import pf.Vector3
import pf.CharacterBody3D
import pf.PhysicsBody3D
import pf.Node3D

movement_speed = 2.0
idle_speed = 0.0
jump_force = 50.0

physics_process! : F64 => {}
physics_process! = |_delta| {
    gravity = PhysicsBody3D.get_gravity!()

    lx = InputSingleton.get_axis!("left", "right")
    lz = InputSingleton.get_axis!("forward", "back")

    jump = InputSingleton.is_action_just_pressed!("jump", GodotRoc.false) == GodotRoc.true
    on_floor = CharacterBody3D.is_on_floor!() == GodotRoc.true

    velocity = CharacterBody3D.get_velocity!()

    vx_f : F32
    vx_f = (lx * movement_speed).to_f32_wrap()
    vz_f : F32
    vz_f = (lz * movement_speed).to_f32_wrap()

    vy_f : F32
    vy_f =
        velocity.y
        + (-gravity.z).to_f32_wrap()
        + (if jump and on_floor {
            jump_force.to_f32_wrap()
        } else {
            0.0.F32
        })

    CharacterBody3D.set_velocity!({
        x: vx_f,
        y: vy_f,
        z: vz_f,
    })

    _mas = CharacterBody3D.move_and_slide!()
    {}
}

# Default app modules must have a main! function.
main! = |_args| {{}}
