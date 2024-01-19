(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Alt\+Shift\+Cmd\+|Ctrl\+Shift\+Cmd\+|Ctrl\+Alt\+Shift\+|Ctrl\+Alt\+Cmd\+|Alt\+Shift\+Cmd\+|Shift\+Cmd\+|Ctrl\+Shift\+|Ctrl\+Cmd\+|Ctrl\+Alt\+|Alt\+Shift\+|Alt\+Cmd\+|Cmd\+|Alt\+)(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]))|(Shift\+)?(F1[0-2]|F[1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Ctrl+Alt+Shift+Cmd+") (str.to_re "Ctrl+Shift+Cmd+") (str.to_re "Ctrl+Alt+Shift+") (str.to_re "Ctrl+Alt+Cmd+") (str.to_re "Alt+Shift+Cmd+") (str.to_re "Shift+Cmd+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Cmd+") (str.to_re "Ctrl+Alt+") (str.to_re "Alt+Shift+") (str.to_re "Alt+Cmd+") (str.to_re "Cmd+") (str.to_re "Alt+")) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))) (re.++ (re.opt (str.to_re "Shift+")) (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; (23:59:59)|([01]{1}[0-9]|2[0-3]):((00)|(15)|(30)|(45))+:(00)
(assert (str.in_re X (re.union (str.to_re "23:59:59") (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.+ (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))) (str.to_re ":00\u{0a}")))))
; /\u{2e}hhk([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.hhk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\u{2e}url([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.url") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(\d{2,3}|\(\d{2,3}\))?[ ]?\d{3,4}[-]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
