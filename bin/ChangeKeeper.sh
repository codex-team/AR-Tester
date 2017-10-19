# bin/bash
#
# How to use:
# Add run script with string below
# bash Scripts/ChangeKeeper xcode 300 100
# Where xcode - mode, 300 - max count for insertions inside branch, 100 - inside commit

# Set main variables
# Script working mode: xcode or git hook
MODE=$1
MAX_BRANCH_INSERTIONS=$2
MAX_COMMIT_INSERTIONS=$2

# Function for parsing insertions and deletions
PARSER() {
    PARSED_TEXT=""

    if [[ $1 = "COMMIT" ]]
    then
        COMMIT_CHANGES=$(git diff --shortstat)
        PARSED_TEXT=$COMMIT_CHANGES
    fi

    if [[ $1 = "BRANCH" ]]
    then
        BRANCH_NAME=$(git symbolic-ref --short HEAD)
        BRANCH_CHANGES=$(git diff --shortstat master $BRANCH_NAME)
        PARSED_TEXT=$BRANCH_CHANGES
    fi

    if [[ $PARSED_TEXT =~ (([0-9]{1,5}) insertions) ]]
    then
        INSERTIONS=${BASH_REMATCH[2]}
    fi

    if [[ $PARSED_TEXT =~ (([0-9]{1,5}) deletions) ]]
    then
        DELETIONS=${BASH_REMATCH[2]}
    fi
}

PARSER COMMIT
COMMIT_INSERTIONS=$INSERTIONS
COMMIT_DELETIONS=$DELETIONS

PARSER BRANCH
BRANCH_INSERTIONS=$INSERTIONS
BRANCH_DELETIONS=$DELETIONS

if [[ $COMMIT_INSERTIONS -gt $MAX_COMMIT_INSERTIONS ]];
then
    if [[ $MODE == "Xcode" ]];
    then
        echo warning: "Your commit changes too big: $COMMIT_INSERTATIONS. Recommended changes: $MAX_COMMIT_INSERTIONS ."
    fi
else
    echo "Comit changes: $COMMIT_INSERTIONS"
fi

let "BRANCH_INSERTIONS=BRANCH_INSERTIONS+COMMIT_INSERTIONS"
if [[ $BRANCH_INSERTIONS -gt $MAX_BRANCH_INSERTIONS ]];
then
    if [[ $MODE == "Xcode" ]];
    then
        echo warning: "Your branch changes too big: $BRANCH_INSERTIONS. Recomended changes: $MAC_BRANCH_INSERTIONS" ]];
    fi
else 
    echo "Branch changes: $BRANCH_INSERTIONS"
fi