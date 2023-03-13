(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/Java([0-9]{1,2})?\.jar\?java=[0-9]{2}/U
(assert (not (str.in_re X (re.++ (str.to_re "//Java") (re.opt ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re ".jar?java=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; /\u{2e}svgz?([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.svg") (re.opt (str.to_re "z")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /infor\.php\?uid=\w{52}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/infor.php?uid=") ((_ re.loop 52 52) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}")))))
(check-sat)
