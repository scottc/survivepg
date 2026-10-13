app [config] { pf: platform "https://github.com/lukewilliamboswell/roc-blueprint/releases/download/0.5.0/CupqPH9snWf11g7tWgcJf4Yg5cJ3K9fhL7fSgqDcqJQH.tar.zst" }

config = [
    Name("foo"),
    Overlay("roc", "github:roc-lang/roc-overlay"),
    Environment("dev", [
        Overlays(["roc"]),
        Command("roc", "rocpkgs.nightly-2026-09-27-a3ce7f1"),
        Tools([
            "godot",
            "godotPackages_4_5.godot",
        ])
    ]),
    Shell("default", [Use("dev")]),
]

# config = [
# 	Name("survive-pg"),
# 	Overlay("roc", "github:roc-lang/roc-overlay"),
# 	#Overlay("redot", "path:./flakes/redot-nix"),
# 	#Overlay("rex", "path:./flakes/rex-nix"),
# 	Environment("dev", [
#     	Overlays([
#             "roc",
#             #"redot",
#             #"rex",
#         ]),
#         Tools([
#       		# engines
#       		"godotPackages_4_5.godot", # sane baseline
#             "godot", # latest godot
#       		#"redot", # latest redot
#             # "godotPackages_4_3.godot", # oldest godot for max compatibility...
#       		#"rex", # When api dumps are working...
#         ]),
# 	]),
# 	# Environment(
# 	# 	"web-export",
# 	# 	[
# 	# 		Overlays(["roc"]),
# 	# 		Command("roc", "rocpkgs.nightly-2026-09-27-a3ce7f1"),
# 	# 		Command("roc-stable", "rocpkgs.nightly-2026-09-27-a3ce7f1"),
# 	# 		Tools([
# 	# 		    "godot",
# 	# 			"godot-export-templates-bin",
# 	# 			"emscripten",
#  #                #"zig", # [Optional] we use zig's "zig wasm-ld" for testing if objects are linkable.
# 	# 			#"wabt", # [Optional] we use wasm-objdump to inspect.
# 	# 		]),
# 	# 	],
# 	# ),
# 	Shell("default", [Use("dev")]),
# 	# depends on dump bindings, dev & web export...
# 	# Task("godot4.5", [
# 	#     Use("dev"),
# 	# 	Run(["godot4.5", "project.godot"])
# 	# ]),
# 	# Task("godot4.7", [
# 	#     Use("dev"),
# 	# 	Run(["godot", "project.godot"])
# 	# ]),
# 	# Task("redot23", [
# 	#     Use("dev"),
# 	# 	Run(["redot", "project.godot"])
# 	# ]),
# ]
