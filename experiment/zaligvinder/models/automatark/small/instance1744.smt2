(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z0-9\\-\\&-]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "\u{5c}" "\u{5c}") (str.to_re "&") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}mka/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}")))))
; www\x2Eserverlogic3\x2Ecom
(assert (str.in_re X (str.to_re "www.serverlogic3.com\u{0a}")))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3AtoUser-Agent\x3AClientsConnected-
(assert (not (str.in_re X (str.to_re "Host:toUser-Agent:ClientsConnected-\u{0a}"))))
(check-sat)
