#!/bin/julia
using YAML

REPO = "https://github.com/claudiopica/HiRep"
TEST_FOLDER = "./hirep_tests_running/"

recipes = YAML.load_file("recipes.yaml")
@show recipes

mkdir(TEST_FOLDER)
cd(TEST_FOLDER)
run(`git clone $REPO`)

for recipe in recipes
    name, keys = recipe
    cp("./HiRep", name)
    cd(name)
    cp("../../MkFlags.template", "./Make/MkFlags", force=true)
    flag_file = open("./Make/MkFlags", "a")
    for flag in ["CFLAGS", "CC", "MPICC"]
        write(flag_file, "$flag = $(keys[flag])\n")
    end
    script = open("./compile_script.sh", "w")
    write(script, "#!/bin/bash\nmodule purge\n")
    for mod in keys["modules"]
        write(script, "module load $mod\n")
    end
    write(script, read(open("../../compile_script.sh")))
    cd("../")
end
