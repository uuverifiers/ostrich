(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AHost\x3AhasHost\x3AComputerKeylogger\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:Host:hasHost:ComputerKeylogger.com\u{0a}")))
; Host\x3AAddressDaemonUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "Host:AddressDaemonUser-Agent:User-Agent:\u{0a}"))))
; ^[A-Za-z0-9](\.[\w\-]|[\w\-][\w\-])(\.[\w\-]|[\w\-]?[\w\-]){0,30}[\w\-]?@[A-Za-z0-9\-]{3,63}\.[a-zA-Z]{2,6}$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.union (re.++ (str.to_re ".") (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.++ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 0 30) (re.union (re.++ (str.to_re ".") (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.++ (re.opt (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") ((_ re.loop 3 63) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; Host\x3ATest\x3C\x2Fchat\x3EResultsSubject\x3A
(assert (not (str.in_re X (str.to_re "Host:Test</chat>ResultsSubject:\u{0a}"))))
; ^[0-9]*[1-9]+[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
