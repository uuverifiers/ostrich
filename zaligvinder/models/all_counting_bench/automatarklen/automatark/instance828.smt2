(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z]+)[0-9]*\.*[a-zA-Z0-9]+$|^[a-zA-Z]+[0-9]*$
(assert (str.in_re X (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.range "0" "9")) (re.* (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ZC-BridgeHost\x3ASubject\u{3a}as\x2Estarware\x2Ecom
(assert (str.in_re X (str.to_re "ZC-BridgeHost:Subject:as.starware.com\u{0a}")))
; ^[+]447\d{9}$
(assert (not (str.in_re X (re.++ (str.to_re "+447") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(9,)*([1-9]\d{2}-?)*[1-9]\d{2}-?\d{4}$
(assert (not (str.in_re X (re.++ (re.* (str.to_re "9,")) (re.* (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")))) (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /insertBefore\(document\.body\)([^?]+createElement\([\u{22}\u{27}]TR[\u{22}\u{27}]\)\))+[^?]+<body[^?]+?<\/body>/i
(assert (str.in_re X (re.++ (str.to_re "/insertBefore(document.body)") (re.+ (re.++ (re.+ (re.comp (str.to_re "?"))) (str.to_re "createElement(") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "TR") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "))"))) (re.+ (re.comp (str.to_re "?"))) (str.to_re "<body") (re.+ (re.comp (str.to_re "?"))) (str.to_re "</body>/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
