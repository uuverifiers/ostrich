(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /infor\.php\?uid=\w{52}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/infor.php?uid=") ((_ re.loop 52 52) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}")))))
(check-sat)
