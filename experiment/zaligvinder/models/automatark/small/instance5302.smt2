(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Spam-Level:\s[*]{11}
(assert (not (str.in_re X (re.++ (str.to_re "X-Spam-Level:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 11 11) (str.to_re "*")) (str.to_re "\u{0a}")))))
; /(DisableSandboxAndDrop|ConfusedClass|FieldAccessVerifierExpl)\.class/ims
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "DisableSandboxAndDrop") (str.to_re "ConfusedClass") (str.to_re "FieldAccessVerifierExpl")) (str.to_re ".class/ims\u{0a}")))))
; www\x2Ecameup\x2EcomNetTracker
(assert (str.in_re X (str.to_re "www.cameup.com\u{13}NetTracker\u{0a}")))
; ^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "A" "P") (re.range "R" "U") (str.to_re "W") (str.to_re "Y") (str.to_re "Z") (re.range "0" "9")) (re.union (re.range "A" "H") (re.range "K" "Y") (re.range "0" "9")) (re.opt (re.union (str.to_re "A") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y") (re.range "0" "9"))) (re.opt (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (re.range "0" "9"))) ((_ re.loop 1 2) (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (re.range "N" "U") (re.range "W" "Z")))) (str.to_re "GIR 0AA")) (str.to_re "\u{0a}")))))
(check-sat)
