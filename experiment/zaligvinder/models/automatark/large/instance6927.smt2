(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([A-Za-z])([-_.\dA-Za-z]{1,10})([\dA-Za-z]{1}))(@)(([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(([\dA-Za-z{1}][-_.\dA-Za-z]{1,25})\.([A-Za-z]{2,4}))$)
(assert (not (str.in_re X (re.++ (str.to_re "@") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "{") (str.to_re "1") (str.to_re "}")) ((_ re.loop 1 25) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))))) (str.to_re "\u{0a}") (re.union (re.range "A" "Z") (re.range "a" "z")) ((_ re.loop 1 10) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z")))))))
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}")))))
; /Referer\u{3a}\u{20}[\u{20}-\x7E]*?\/wp\u{2d}admin\/[a-z\d\u{2d}]+?\.php\r\n/Hi
(assert (str.in_re X (re.++ (str.to_re "/Referer: ") (re.* (re.range " " "~")) (str.to_re "/wp-admin/") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".php\u{0d}\u{0a}/Hi\u{0a}"))))
; t=ProtoUser-Agent\x3Aquick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (str.to_re "t=ProtoUser-Agent:quick.qsrch.com\u{0a}"))))
(check-sat)
