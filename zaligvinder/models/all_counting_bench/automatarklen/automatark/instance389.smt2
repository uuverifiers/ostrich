(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[0-9]{4,10}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 10) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; ^[a-zA-Z]{1}[\w\sa-zA-Z\d_]*[^\s]$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
