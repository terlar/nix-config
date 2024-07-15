# Add marker to support navigation between prompts.
function mark_prompt_start --on-event fish_prompt
    echo -en "\e]133;A\e\\"
end
