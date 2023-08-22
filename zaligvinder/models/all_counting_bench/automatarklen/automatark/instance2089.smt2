(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Admin\s+daosearch\x2EcomMyPostwww\.raxsearch\.comref\x3D\u{25}user\x5Fid
(assert (not (str.in_re X (re.++ (str.to_re "Admin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.comMyPostwww.raxsearch.comref=%user_id\u{0a}")))))
; ^(3276[0-7]|327[0-5]\d|32[0-6]\d{2}|3[01]\d{3}|[12]\d{4}|[1-9]\d{3}|[1-9]\d{2}|[1-9]\d|\d)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "3276") (re.range "0" "7")) (re.++ (str.to_re "327") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "32") (re.range "0" "6") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
