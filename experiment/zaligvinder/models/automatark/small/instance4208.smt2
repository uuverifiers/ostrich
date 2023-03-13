(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((l((ll)|(b)|(bb)|(bbb)))|(bb*))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "l") (re.union (str.to_re "ll") (str.to_re "b") (str.to_re "bb") (str.to_re "bbb"))) (re.++ (str.to_re "b") (re.* (str.to_re "b")))) (str.to_re "\u{0a}")))))
; /^\u{2f}[A-Za-z0-9]{33}\?s=\d\&m=\d$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 33 33) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?s=") (re.range "0" "9") (str.to_re "&m=") (re.range "0" "9") (str.to_re "/U\u{0a}")))))
; /Referer\u{3a}[^\n]*fla\.php\?wq=[a-f0-9]+\u{0d}\u{0a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/Referer:") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "fla.php?wq=") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
(check-sat)
