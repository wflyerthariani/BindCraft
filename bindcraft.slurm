#!/bin/bash
#SBATCH -N 1
#SBATCH --partition=batch
#SBATCH --time=100:00:00
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=arman.thariani@kaust.edu.sa
#SBATCH --mail-type=ALL

# Initialise environment and modules
source /ibex/user/thariaaa/miniforge/bin/activate /ibex/user/thariaaa/conda-environments/BindCraft || { echo "Error: Could not activate BindCraft environment."; exit 1; }

SCRIPT_DIR=$(pwd)

# Parsing command line options
SETTINGS=""
FILTERS=""
ADVANCED=""
TEMP=$(getopt -o s:f:a: --long settings:,filters:,advanced: -n 'bindcraft.slurm' -- "$@")
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -s|--settings) SETTINGS="$2" ; shift 2 ;;
        -f|--filters) FILTERS="$2" ; shift 2 ;;
        -a|--advanced) ADVANCED="$2" ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Invalid Option" ; exit 1 ;;
    esac
done

# Ensure that SETTINGS is not empty
if [ -z "$SETTINGS" ]; then
    echo "Error: The -s or --settings option is required."
    exit 1
fi

echo "Running the BindCraft pipeline"
python -u "${SCRIPT_DIR}/bindcraft.py" --settings "${SETTINGS}" --filters "${FILTERS}" --advanced "${ADVANCED}"
