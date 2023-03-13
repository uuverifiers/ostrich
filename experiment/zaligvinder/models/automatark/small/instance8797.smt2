(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; href[ ]*=[ ]*('|\")([^\"'])*('|\")
(assert (str.in_re X (re.++ (str.to_re "href") (re.* (str.to_re " ")) (str.to_re "=") (re.* (str.to_re " ")) (re.union (str.to_re "'") (str.to_re "\u{22}")) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.union (str.to_re "'") (str.to_re "\u{22}")) (str.to_re "\u{0a}"))))
; /\u{2e}webm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.webm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[A-Z]{1,2}[1-9][0-9]?[A-Z]? [0-9][A-Z]{2,}|GIR 0AA$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "1" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "A" "Z")) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (re.* (re.range "A" "Z"))) (str.to_re "GIR 0AA\u{0a}"))))
; /filename=[^\n]*\u{2e}mov/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mov/i\u{0a}"))))
; ^([1-9]{0,1})([0-9]{1})(\.[0-9])?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
