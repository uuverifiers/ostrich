(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{7b}\u{22}[a-f0-9]{4}\u{22}\u{3a}\u{22}([a-f0-9]{32}|false)\u{22},/smiP
(assert (not (str.in_re X (re.++ (str.to_re "/{\u{22}") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}:\u{22}") (re.union ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "false")) (str.to_re "\u{22},/smiP\u{0a}")))))
; ^(b|B)(f|F)(p|P)(o|O)(\s|\sC/O\s)[0-9]{1,4}
(assert (not (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "C/O") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
(check-sat)
