app [main!] {
    pf: platform "https://github.com/scottc/roc-build/releases/download/nightly-2026-10-17-ca0be2b/B1AWvSBFiSLJnEvin7Rm1k4pRUMLdgE4ZVhVrey2rHSi.tar.zst",
}

import pf.Mem
import pf.Build
import pf.BuildCmd
import pf.Log

import modules/PublishModule exposing [PublishMatrixEntry]

main! : List(Str) => Try(_, _)
main! = |_args| {

    entries = PublishModule.publish_matrix() |> PublishHelper.to_run_graph
    Log.info!(Str.inspect(entries))

    graph = Build.graph_with(entries,
        {
            max_memory: Mem.gb(8),
            max_parallel: 3,
        },
    )
    Log.info!(Str.inspect(graph))

    Build.run!(graph)
}

PublishHelper := {}.{
    to_run_graph : List(PublishMatrixEntry) -> List(BuildCmd)
    to_run_graph = |entries| {

        var $graph_entries = []

        # The build cmds...
        for entry in entries {
            match entry.cpu_arch_os {
                Wasm32 => {

                    roc_build = BuildCmd.new({
                        program: "roc",
                        args: [
                     			"build",
                     			"main.roc",
                                #"--optimize=speed",
                     			"--target=${entry.cpu_arch_os.to_str()}",
                     			"--output=roc-out/${entry.engine.to_str()}/my_game.wasm.a",
                        ],
                        description: "roc build ${entry.engine.to_str()} ${entry.cpu_arch_os.to_str()}",
                    })
                    .with_memory(Mem.gb(2))
                    $graph_entries = $graph_entries.append(roc_build)

                    # TODO: fix build
#                     emcc = BuildCmd.new({
#                         program: "emcc",
#                         args: [
#                             "roc-out/${entry.engine.to_str()}/my_game.wasm.a",
#                             "-o",
#                             "emcc-out/${entry.engine.to_str()}/my_game.wasm",
#                             "-sSIDE_MODULE=2",
#                             "-sERROR_ON_UNDEFINED_SYMBOLS=0",
#                             "-sEXPORTED_FUNCTIONS='[\"_gdextension_roc_init\"]'",
#                             "-O0",
#                             "-msimd128",
#                         ],
#                         description: "emcc ${entry.engine.to_str()} ${entry.cpu_arch_os.to_str()}",
#                     })
#                     .depends_on([roc_build])
#                     .with_memory(Mem.gb(1))
#                     $graph_entries = $graph_entries.append(emcc)
#
#                     engine_export_web = BuildCmd.new({
#                         program: entry.engine.to_str(),
#                         args: [
#                  			"--headless",
#                  			"--export-release",
#                  			"Web",
#                  			"export/${entry.engine.to_str()}/index.html"
#                         ],
#                         description: "${entry.engine.to_str()} --export-release ${entry.cpu_arch_os.to_str()}",
#                     })
#                     .depends_on([emcc])
#                     .with_memory(Mem.gb(1))
#                     $graph_entries = $graph_entries.append(engine_export_web)


                    {}
                }
                X64musl => {
                    # TODO: native desktop publish
                    #
                    roc_build = BuildCmd.new({
                        program: "roc",
                        args: [
                     			"build",
                     			"main.roc",
                                "--optimize=speed",
                     			"--target=${entry.cpu_arch_os.to_str()}",
                     			"--output=roc-out/${entry.engine.to_str()}/my_game.so",
                        ],
                        description: "roc build ${entry.engine.to_str()} ${entry.cpu_arch_os.to_str()}",
                    })
                    .with_memory(Mem.gb(8))
                    $graph_entries = $graph_entries.append(roc_build)

                    {}
                }
            }
        }

        $graph_entries
    }
}
