(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\{\\f\d*)\\([^;]+;)
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}\u{0a}{\u{5c}f") (re.* (re.range "0" "9")) (re.+ (re.comp (str.to_re ";"))) (str.to_re ";")))))
; RXnewads1\x2EcomSPYcom\x2Findex\.php\?tpid=
(assert (str.in_re X (str.to_re "RXnewads1.comSPYcom/index.php?tpid=\u{0a}")))
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; User-Agent\x3AHost\x3ATeomaBarHost\x3AHoursHost\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:Host:TeomaBarHost:HoursHost:\u{0a}"))))
(check-sat)
