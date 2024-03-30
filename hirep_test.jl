#!/bin/julia
using YAML

REPO = "https://github.com/claudiopica/HiRep"
TEMP_FOLDER = "./hirep_test_temp/"

recipes = YAML.load_file("recipes.yaml")
@show recipes

mkdir(TEMP_FOLDER)
cd(TEMP_FOLDER)
run(`git clone $REPO`)

for recipe in recipes
    name, keys = recipe
    cp("HiRep", name)
    cd(name)
    run(`module purge`)
    for mod in keys["modules"]
        run(`module load $mod`)
    end
    cp("../../MkFlags.template", "./Make/MkFlags")
    for flag in ["CFLAGS", "CC", "MPICC"]
        write(open("./Make/MkFlags", "a"), "$(keys[flag])\n")
    end
end
