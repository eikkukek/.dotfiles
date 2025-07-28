#!/bin/bash

read app_id foreign_id < <(swaymsg -t get_tree | jq -r '.. | objects | select(.focused? == true) | "\(.app_id) \(.foreign_toplevel_identifier)"')
direction="$1"

if [[ "$app_id" != "Alacritty" ]]; then
	swaymsg focus "$direction"
else

	key="$2"

	if [ -z "$key" ]; then
		exit 1
	fi

	window_id=$(tmux list-windows -t "alacritty_auto_${foreign_id}" -F "#{window_id}")

	if [ -z "$key" ]; then
		exit 1
	fi

	tmux list-panes -t "$window_id" -F '#{pane_id} #{pane_active} #{pane_current_command}' | while read id active cmd; do
		if [[ $active == 1 ]]; then
			if [[ "$cmd" == "nvim" ]]; then
				tmux send-keys -t "$id" "C-$key"
			else
				if [[ "$key" == "h" ]]; then
					tmux_dir="left"
					tmux_opt="L"
				elif [[ "$key" == "j" ]]; then
					tmux_dir="bottom"
					tmux_opt="D"
				elif [[ "$key" == "k" ]]; then
					tmux_dir="top"
					tmux_opt="U"
				elif [[ "$key" == "l" ]]; then
					tmux_dir="right"
					tmux_opt="R"
				fi
				tmux 'if' -t ${window_id} -F "#{pane_at_${tmux_dir}}" \
					"run-shell \"swaymsg focus ${direction}\"" \
					"select-pane -t ${window_id} -${tmux_opt}"
			fi
		fi
	done
fi
