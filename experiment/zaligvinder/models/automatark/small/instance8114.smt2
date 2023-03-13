(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?(([1-9],)?([0-9]{3},){0,3}[0-9]{3}|[0-9]{0,16})(\.[0-9]{0,3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ (re.opt (re.++ (re.range "1" "9") (str.to_re ","))) ((_ re.loop 0 3) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 0 16) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (\(")([0-9]*)(\")
(assert (not (str.in_re X (re.++ (str.to_re "(\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}")))))
; (:(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3}))?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; ^([0]?\d|1\d|2[0-3]):([0-5]\d):([0-5]\d)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}jnlp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jnlp/i\u{0a}")))))
(check-sat)
