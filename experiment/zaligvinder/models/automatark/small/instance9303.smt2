(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}Host\x3Apasswordhavewww\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:Host:passwordhavewww.alfacleaner.com\u{0a}")))
; ^([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4})$
(assert (str.in_re X (re.++ ((_ re.loop 2 7) (re.++ ((_ re.loop 0 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ":"))) (re.union (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f")))) (str.to_re "\u{0a}"))))
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
(check-sat)
