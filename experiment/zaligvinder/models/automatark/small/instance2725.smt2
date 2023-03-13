(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Shift\+Alt\+|Ctrl\+Shift\+|Ctrl\+Alt\+|Shift\+Alt\+|Ctrl\+|Alt\+){1}(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]){1}){1}|(Shift\+)?(F1[0-2]|F[1-9]){1})$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "Ctrl+Shift+Alt+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Alt+") (str.to_re "Shift+Alt+") (str.to_re "Ctrl+") (str.to_re "Alt+"))) ((_ re.loop 1 1) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))))) (re.++ (re.opt (str.to_re "Shift+")) ((_ re.loop 1 1) (re.++ (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))))) (str.to_re "\u{0a}"))))
; /\&k=\d+($|\&h=)/U
(assert (not (str.in_re X (re.++ (str.to_re "/&k=") (re.+ (re.range "0" "9")) (str.to_re "&h=/U\u{0a}")))))
; /filename=[^\n]*\u{2e}xspf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xspf/i\u{0a}")))))
; ^[1-9][0-9][0-9][0-9]$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
