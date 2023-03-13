(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[3|4|5|6]([0-9]{15}$|[0-9]{12}$|[0-9]{13}$|[0-9]{14}$)
(assert (str.in_re X (re.++ (re.union (str.to_re "3") (str.to_re "|") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (re.union ((_ re.loop 15 15) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9")) ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; \+44\s\(0\)\s\d{2}\s\d{4}\s\d{4}
(assert (not (str.in_re X (re.++ (str.to_re "+44") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; client\x2Ebaigoo\x2Ecom\s+ised2k
(assert (not (str.in_re X (re.++ (str.to_re "client.baigoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ised2k\u{0a}")))))
(check-sat)
