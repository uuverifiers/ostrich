(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((https|http)://)?(www.)?(([a-zA-Z0-9\-]{2,})\.)+([a-zA-Z0-9\-]{2,4})(/[\w\.]{0,})*((\?)(([\w\%]{0,}=[\w\%]{0,}&?)|[\w]{0,})*)?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "https://")) (re.opt (re.++ (str.to_re "www") re.allchar)) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re "/") (re.* (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.union (re.++ (re.* (re.union (str.to_re "%") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.* (re.union (str.to_re "%") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "&"))) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))) (str.to_re "\u{0a}")))))
; Host\x3A.*NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\n
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
