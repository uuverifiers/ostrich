(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[1-9]\d{7,8}$
(assert (str.in_re X (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; loomcompany\x2EcomBasedURLS\swww\.fast-finder\.com
(assert (str.in_re X (re.++ (str.to_re "loomcompany.comBasedURLS") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
