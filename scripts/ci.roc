app [main!] {
    pf: platform "https://github.com/scottc/roc-build/releases/download/nightly-2026-10-17-ca0be2b/B1AWvSBFiSLJnEvin7Rm1k4pRUMLdgE4ZVhVrey2rHSi.tar.zst",
}

import pf.Mem
import pf.Build
import pf.BuildCmd
import pf.Log

main! : List(Str) => Try(_, _)
main! = |_args| {

    roc_test_main = BuildCmd.new({
        program: "roc",
        args: [
     			"test",
     			"main.roc",
        ],
        description: "roc test",
    })

    roc_test_ci = BuildCmd.new({
        program: "roc",
        args: [
     			"test",
     			"scripts/ci.roc",
        ],
        description: "roc test",
    })

    roc_test_publish = BuildCmd.new({
        program: "roc",
        args: [
     			"test",
     			"scripts/ci.roc",
        ],
        description: "roc test",
    })

    graph = Build.graph_with(
        [
            roc_test_main,
            roc_test_ci,
            roc_test_publish,
        ],
        {
            max_memory: Mem.gb(8),
            max_parallel: 3,
        },
    )
    Log.info!(Str.inspect(graph))

    _result = Build.run!(graph)
    # TODO: log result.

    Ok({})
}
