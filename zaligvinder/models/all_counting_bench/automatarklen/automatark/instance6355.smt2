(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DesktopHost\x3Aact=Microsoft
(assert (str.in_re X (str.to_re "DesktopHost:act=Microsoft\u{0a}")))
; :(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3})
(assert (not (str.in_re X (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(((ht|f)tp(s?))\://).*$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s"))))))
(assert (> (str.len X) 10))
(check-sat)
