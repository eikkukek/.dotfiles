#alacritty --command tmux new-session -s $SESSION_NAME

#tmux kill-session -t "$SESSION_NAME" 2>/dev/null

title="Alacritty | Tmux"
tmp_session_name="$$"

alacritty --title "${title}" --command tmux new-session -s "$tmp_session_name" &
alacritty_pid=$!

for i in {1..50}; do

	foreign_id=$(swaymsg -t get_tree | jq -r ".. | select(.app_id? == \"Alacritty\" and .pid? == $alacritty_pid) | .foreign_toplevel_identifier")

	if [[ -n "$foreign_id" && "$foreign_id" != "null" ]]; then
		break
	fi

	sleep 0.1
done

if [[ -z "$foreign_id" || "$foreign_id" == "null" ]]; then
	echo "Failed to find Alacritty window"
	alacritty --title "${alacritty_pid}"
	exit 1
fi

session_name="alacritty_auto_${foreign_id}"

tmux rename-session -t "$tmp_session_name" "$session_name"

while true; do
	app_id=$(swaymsg -t get_tree | jq -r ".. | select(.foreign_toplevel_identifier? == \"$foreign_id\") | .app_id")
	if [[ $app_id != "Alacritty" ]]; then
		break
	fi
done

tmux kill-session -t $session_name
