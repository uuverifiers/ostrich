(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^N[1-9][0-9]{0,4}$|^N[1-9][0-9]{0,3}[A-Z]$|^N[1-9][0-9]{0,2}[A-Z]{2}$
(assert (str.in_re X (re.++ (str.to_re "N") (re.range "1" "9") (re.union ((_ re.loop 0 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.range "A" "Z")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))))
; \b[1-9]{1}[0-9]{1,5}-\d{2}-\d\b
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; Log[^\n\r]*Host\x3A\dHOST\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Log") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.range "0" "9") (str.to_re "HOST:User-Agent:\u{0a}")))))
(check-sat)
