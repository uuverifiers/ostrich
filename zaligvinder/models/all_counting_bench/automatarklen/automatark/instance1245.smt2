(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d+(\,\d{1,2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; \\red([01]?\d\d?|2[0-4]\d|25[0-5])\\green([01]?\d\d?|2[0-4]\d|25[0-5])\\blue([01]?\d\d?|2[0-4]\d|25[0-5]);
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}red") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{5c}green") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{5c}blue") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ";\u{0a}")))))
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
; /\?id=[A-Z0-9]{20}&cmd=img/U
(assert (not (str.in_re X (re.++ (str.to_re "/?id=") ((_ re.loop 20 20) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cmd=img/U\u{0a}")))))
; (?i:on(blur|c(hange|lick)|dblclick|focus|keypress|(key|mouse)(down|up)|(un)?load|mouse(move|o(ut|ver))|reset|s(elect|ubmit)))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}on") (re.union (str.to_re "blur") (re.++ (str.to_re "c") (re.union (str.to_re "hange") (str.to_re "lick"))) (str.to_re "dblclick") (str.to_re "focus") (str.to_re "keypress") (re.++ (re.union (str.to_re "key") (str.to_re "mouse")) (re.union (str.to_re "down") (str.to_re "up"))) (re.++ (re.opt (str.to_re "un")) (str.to_re "load")) (re.++ (str.to_re "mouse") (re.union (str.to_re "move") (re.++ (str.to_re "o") (re.union (str.to_re "ut") (str.to_re "ver"))))) (str.to_re "reset") (re.++ (str.to_re "s") (re.union (str.to_re "elect") (str.to_re "ubmit"))))))))
(assert (> (str.len X) 10))
(check-sat)
