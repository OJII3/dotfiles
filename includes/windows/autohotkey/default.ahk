; #Requires AutoHotkey v2.0

; ; CapsLock単押しでESC、修飾でCtrl
; CapsLock:: {
;     ; 単押し判定
;     if (A_PriorKey = "CapsLock" && A_TimeSincePriorHotkey < 200) {
;         Send "{Esc}"
;     } else {
;         Send "{Ctrl Down}"
;         KeyWait "CapsLock"
;         Send "{Ctrl Up}"
;     }
; }