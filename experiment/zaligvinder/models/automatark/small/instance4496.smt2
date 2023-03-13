(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /X-ID\u{3a}\s\u{30}\u{30}+[0-9a-f]{20}(\r\n)+/iH
(assert (str.in_re X (re.++ (str.to_re "/X-ID:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "0") (re.+ (str.to_re "0")) ((_ re.loop 20 20) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.+ (str.to_re "\u{0d}\u{0a}")) (str.to_re "/iH\u{0a}"))))
(check-sat)
