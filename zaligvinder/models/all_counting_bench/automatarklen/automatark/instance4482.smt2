(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Referer\u{3a}\u{20}[^\s]*\u{3a}8000\u{2f}[a-z]+\?[a-z]+=\d{6,7}\u{0d}\u{0a}/H
(assert (str.in_re X (re.++ (str.to_re "/Referer: ") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":8000/") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/H\u{0a}"))))
; ^((1[Zz]\d{16})|(\d{12})|([Tt]\d{10})|(\d{9}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "Z") (str.to_re "z")) ((_ re.loop 16 16) (re.range "0" "9"))) ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (re.union (str.to_re "T") (str.to_re "t")) ((_ re.loop 10 10) (re.range "0" "9"))) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
