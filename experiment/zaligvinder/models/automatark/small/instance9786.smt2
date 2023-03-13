(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{8})|(\d{10})|(\d{11})|(\d{6}-\d{5}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 11 11) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /^Subject\x3A[^\r\n]*Trojaner-Info\sNewsletter/smi
(assert (not (str.in_re X (re.++ (str.to_re "/Subject:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Trojaner-Info") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Newsletter/smi\u{0a}")))))
; /\u{3d}\u{0a}$/P
(assert (str.in_re X (str.to_re "/=\u{0a}/P\u{0a}")))
; ^[^\s]+@[^\.][^\s]{1,}\.[A-Za-z]{2,10}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "@") (re.comp (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(check-sat)
