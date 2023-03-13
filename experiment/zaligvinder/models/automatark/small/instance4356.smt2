(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AHost\u{3a}\u{22}The
(assert (str.in_re X (str.to_re "User-Agent:Host:\u{22}The\u{0a}")))
; ^[\w_.]{5,12}$
(assert (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; /setup=[a-z]\&s=\d\&r=\d{5}$/Ui
(assert (str.in_re X (re.++ (str.to_re "/setup=") (re.range "a" "z") (str.to_re "&s=") (re.range "0" "9") (str.to_re "&r=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; <[^>]*?>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
(check-sat)
