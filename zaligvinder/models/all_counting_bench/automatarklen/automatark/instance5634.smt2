(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Informationurl=Host\x3Aaction\x2Eforhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (str.to_re "Informationurl=Host:action.forhttp://www.searchinweb.com/search.php?said=bar\u{0a}")))
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}"))))
; \.?[a-zA-Z0-9]{1,}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
