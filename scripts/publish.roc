app [main!] {
	pf: platform "https://github.com/scottc/roc-build/releases/download/v0.1.0-rc1/EG89xVCPEj7M71tj23bNmENBi3uHAbavsWQL9NuTV8vo.tar.zst",
}

import pf.Log
import pf.Build exposing [Cmd, BuildGraph, TaskId]

import modules/PublishModule exposing [PublishMatrixEntry]

main! : List(Str) => Try(_, _)
main! = |_args| {

    graph = PublishModule.publish_matrix()
    |> PublishHelper.to_run_graph

    Log.info!(Str.inspect(graph))
    Build.run!(graph)

}

PublishHelper := {}.{

    ensure_dir = |id, dir| {
        s : Str
        s = dir

        Build.cmd({
            id: id,
            depends_on: [], # clean?
            program: "mkdir",
            args: [],
            description: "mkdir ...",
            cwd: "",
            env: [],
            inputs: [],
            outputs: [],
        })
    }

    to_run_graph : List(PublishMatrixEntry) -> BuildGraph
    to_run_graph = |entries| {
        $id : TaskId
        var $id = 0

        #$graph_entries : List(Task)
        var $graph_entries = []

        for entry in entries {
            match entry.cpu_arch_os {
                Wasm32 => {
                    roc_build = Build.cmd({
                        id: $id,
                        depends_on: [],
                        program: "roc",
                        args: [
                     			"build",
                     			"main.roc",
                                "--optimize=speed",
                     			"--target=${entry.cpu_arch_os.to_str()}",
                     			"--output=roc-out/${entry.engine.to_str()}/my_game.wasm.a",
                        ],
                        description: "roc build ${$id.to_str()} ${entry.engine.to_str()} ${entry.cpu_arch_os.to_str()}",
                        cwd: "",
                        env: [],
                        inputs: [],
                        outputs: [],
                    })
                    $graph_entries = $graph_entries.append(roc_build)
                    $id  = $id + 1

                    emcc = Build.cmd({
                        id: $id,
                        depends_on: [$id - 1],
                        program: "emcc",
                        args: [
                            "roc-out/${entry.engine.to_str()}/my_game.wasm.a",
                            "-o",
                            "emcc-out/${entry.engine.to_str()}/my_game.wasm",
                            "-sSIDE_MODULE=2",
                            "-sERROR_ON_UNDEFINED_SYMBOLS=0",
                            "-sEXPORTED_FUNCTIONS='[\"_godot_roc_init\"]'",
                            "-O0",
                            "-msimd128",
                        ],
                        description: "emcc ${$id.to_str()} ${entry.engine.to_str()} ${entry.cpu_arch_os.to_str()}",
                        cwd: "",
                        env: [],
                        inputs: [],
                        outputs: [],
                    })
                    $graph_entries = $graph_entries.append(emcc)
                    $id  = $id + 1

                    engine_export_web = Build.cmd({
                        id: $id,
                        depends_on: [$id - 1],
                        program: entry.engine.to_str(),
                        args: [
                 			"--headless",
                 			"--export-release",
                 			"Web",
                 			"export/${entry.engine.to_str()}/index.html"
                        ],
                        description: "${entry.engine.to_str()} --export-release ${$id.to_str()} ${entry.cpu_arch_os.to_str()}",
                        cwd: "",
                        env: [],
                        inputs: [],
                        outputs: [],
                    })
                    $graph_entries = $graph_entries.append(engine_export_web)
                    $id  = $id + 1

                    {}
                }
                X64musl => {
                    # TODO: native desktop publish
                    {}
                }
            }
        }

        Build.graph($graph_entries)
    }
}
