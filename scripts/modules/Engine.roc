Engine := [Godot, Redot, Blazium].{
    all : List(Engine)
    all = [
        Godot,
        Redot,
        Blazium
    ]

    to_str : Engine -> Str
    to_str = |engine| {
        match engine {
            Godot => "godot"
            Redot => "redot"
            Blazium => "blazium"
        }
    }
}
