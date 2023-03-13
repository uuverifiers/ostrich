(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Fdirect\.php\x3Ff=[0-9]{8}\u{26}s=[a-z0-9]{3}\.[a-z]{1,4}/U
(assert (str.in_re X (re.++ (str.to_re "//direct.php?f=") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "&s=") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
(check-sat)
