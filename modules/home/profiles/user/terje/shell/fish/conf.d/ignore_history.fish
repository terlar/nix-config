function __commandline_ignore_history --on-event fish_preexec
    set -l ignored_terms fg bg
    history delete --exact --case-sensitive $ignored_terms
end
