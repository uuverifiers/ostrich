(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^([0-9a-zA-Z]+|[a-zA-Z]:(\\(\w[\w ]*.*))+|\\(\\(\w[\w ]*.*))+)\.[0-9a-zA-Z]{1,3}$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":") (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar)))) (re.++ (str.to_re "\u{5c}") (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/\u{0a}")))))
; /filename=[^\n]*\u{2e}dcr/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dcr/i\u{0a}"))))
; Host\x3ATest\x3C\x2Fchat\x3EResultsSubject\x3A
(assert (not (str.in_re X (str.to_re "Host:Test</chat>ResultsSubject:\u{0a}"))))
; (^([A-Za-z])([-_.\dA-Za-z]{1,10})([\dA-Za-z]{1}))(@)(([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(([\dA-Za-z{1}][-_.\dA-Za-z]{1,25})\.([A-Za-z]{2,4}))$)
(assert (not (str.in_re X (re.++ (str.to_re "@") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "{") (str.to_re "1") (str.to_re "}")) ((_ re.loop 1 25) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))))) (str.to_re "\u{0a}") (re.union (re.range "A" "Z") (re.range "a" "z")) ((_ re.loop 1 10) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z")))))))
; source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora\x2Einfo
(assert (str.in_re X (str.to_re "source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora.info\u{0a}")))
(check-sat)
