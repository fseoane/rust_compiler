# First we need to be inside the folder containing the Cargo.toml fole of the app to be built
# This app path is the parameter os this script
if [ $# -eq 0 ]
  then
    echo "ERROR: Missing the app folder"
    echo ""
    echo "Syntax:"
    echo "    build.rust.app.inside.docker.sh <app_folder> [<build_command>]"
    echo "where"
    echo "    <app_folder> is the folder of the rust app to be built and where the Cargo.toml file is"
    echo "    <build_command> is optional and by default is cargo build --release but can be specified"
    echo "                    any Bash script present in the app folder for a more specific compilation"
    echo ""
    echo "Note: this <app_folder> will be mapped inside the container to /usr/src/myapp in order to be built."
    echo "      based on the current path (PWD environment variable)"
    echo ""
else
    echo "Building app: $1"
    cd $1
    if [ -z "$2" ]
    then
        echo "Compiling with cargo build --release"
        docker run --rm --name rust_compiler --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/myapp -w /usr/src/myapp rust_compiler cargo build --release
    else
        echo "Compiling by executing the Bash script $2"
        docker run --rm --name rust_compiler --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/myapp -w /usr/src/myapp rust_compiler sh $2
    fi

fi

