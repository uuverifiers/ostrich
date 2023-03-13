(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}b\u{2f}shoe\u{2f}[0-9]{3,5}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/shoe/") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; /encoding\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/encoding=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
(check-sat)
