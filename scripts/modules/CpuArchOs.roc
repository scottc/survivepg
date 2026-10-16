CpuArchOs := [Wasm32, X64musl].{
    all : List(CpuArchOs)
    all = [
        Wasm32,
        X64musl,
    ]

    to_str : CpuArchOs -> Str
    to_str = |cpu_arch_os| {
        match cpu_arch_os {
            Wasm32 => "wasm32"
            X64musl => "x64musl"
        }
    }
}
