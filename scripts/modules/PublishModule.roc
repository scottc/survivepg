import CpuArchOs
import Engine

## Publish targets
PublishModule := {}.{
    PublishMatrixEntry : { cpu_arch_os: CpuArchOs, engine: Engine }

    publish_matrix : () -> List(PublishMatrixEntry)
    publish_matrix = || {
        $entries : List(PublishMatrixEntry)
        var $entries = []

        for engine in Engine.all {
            for cpu_arch_os in CpuArchOs.all {
                $entries = $entries.append({
                    engine: engine,
                    cpu_arch_os: cpu_arch_os,
                })
            }
        }

        $entries
    }
}
