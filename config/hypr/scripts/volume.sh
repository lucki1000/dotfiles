#!/bin/bash

msgTag="volume_bar"
multipler="100"
volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@|awk '{print $2}')" 
volume="$(awk '{print $1*$2}' <<<"${volume} ${multipler}")"
muted="$(wpctl get-volume @DEFAULT_AUDIO_SINK@|awk '{print $3}')"
we10x_iconDir="/usr/share/icons/We10X-black/status/symbolic"

if [[ "$@" == "toggle" ]]; then
    if [[ "$muted" == "" ]]; then
        dunstify -a "changeVolume" -u critical -i "$we10x_iconDir/audio-volume-muted-blocking-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag "Stumm"
    else
        if [[ $volume -le 30 && $volume -ge 1 ]]; then
            dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-low-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%" 
        elif [[ $volume -le 70 && $volume -ge 31 ]] ; then
           dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-medium-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%"
        elif [[ $volume -le 100 && $volume -ge 71 ]]; then
           dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-high-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%"
        fi   
    fi
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 
else
    wpctl set-mute @DEFAULT_SINK@ 0
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$@"
    volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@|awk '{print $2}')" 
    volume="$(awk '{print $1*$2}' <<<"${volume} ${multipler}")"
    if [[ $volume == 0 || "$muted" == "[MUTED]" ]]; then
        # Show the sound muted notification
        dunstify -a "changeVolume" -u critical -i "$we10x_iconDir/audio-volume-muted-blocking-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag "Stumm" 
    else
        # Show the volume notification
        if [[ $volume -le 30 && $volume -ge 1 ]]; then
            dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-low-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%" 
        elif [[ $volume -le 70 && $volume -ge 31 ]] ; then
           dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-medium-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%"
        elif [[ $volume -le 100 && $volume -ge 71 ]]; then
           dunstify -a "changeVolume" -u low -i "$we10x_iconDir/audio-volume-high-symbolic.svg" -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Lautstärke: ${volume}%"
        fi   
    fi
fi